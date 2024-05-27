//
//  SARecoderTools.m
//  SuperApp
//
//  Created by Tia on 2022/8/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SARecorderTools.h"
#import <HDKitCore/HDLog.h>


@interface SARecorderTools () <AVAudioRecorderDelegate>
/// 录音器
@property (nonatomic, strong) AVAudioRecorder *recorder;
/// 开始时间
@property (nonatomic, strong) NSDate *startDate;
/// 结束时间
@property (nonatomic, strong) NSDate *endDate;
/// 录音配置
@property (nonatomic, strong) NSDictionary *recordSetting;
/// 录音完成回调
@property (nonatomic, copy) SARecordFinishBlock recordFinish;

@end


@implementation SARecorderTools

+ (instancetype)shareManager {
    static id _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

#pragma mark - public methods
- (void)startRecordingWithFileName:(NSString *)fileName completion:(void (^)(NSError *error))completion {
    NSError *error = nil;
    if (![[SARecorderTools shareManager] canRecord]) { //判断录音权限
        if (completion) {
            error = [NSError errorWithDomain:NSLocalizedString(@"error", @"没权限") code:201 userInfo:nil];
            completion(error);
        }
        return;
    }
    if ([self.recorder isRecording]) { //停止当前录音
        [_recorder stop];
        [self cancelCurrentRecording];
        if (completion) {
            error = [NSError errorWithDomain:NSLocalizedString(@"error", @"上次录音状态没变更") code:403 userInfo:nil];
            completion(error);
        }
        return;
    } else {
        //创建录音文件路径
        NSString *wavFilePath = [self recorderPathWithFileName:fileName];
        NSURL *wavUrl = [[NSURL alloc] initFileURLWithPath:wavFilePath];

        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *setCategoryError = nil;
        //设置类别,表示该应用同时支持播放和录音
        [session setCategory:AVAudioSessionCategoryPlayAndRecord mode:AVAudioSessionModeSpokenAudio options:AVAudioSessionCategoryOptionDefaultToSpeaker error:&setCategoryError];
        if (setCategoryError) {
            HDLog(@"%@", [setCategoryError description]);
        }
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setActive:NO error:nil];
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [audioSession setActive:YES error:nil]; //启动音频会话管理,此时会阻断后台音乐的播放.

        _recorder = [[AVAudioRecorder alloc] initWithURL:wavUrl settings:self.recordSetting error:&error];
        _recorder.meteringEnabled = YES;
        if (!_recorder || error) {
            _recorder = nil;
            if (completion) {
                error = [NSError errorWithDomain:NSLocalizedString(@"error.initRecorderFail", @"Failed to initialize AVAudioRecorder") code:123 userInfo:nil];
                completion(error);
            }
            return;
        }
        _startDate = [NSDate date];
        _recorder.meteringEnabled = YES;
        _recorder.delegate = self;
        [self.recorder prepareToRecord];
        [_recorder record];
        if (completion) {
            completion(error);
        }
    }
}

- (void)stopRecordingWithCompletion:(SARecordFinishBlock)completion {
    _endDate = [NSDate date];
    if ([_recorder isRecording]) {
        if ([_endDate timeIntervalSinceDate:_startDate] < [self recordMinDuration]) {
            if (completion) {
                completion(kSAShortRecord, [self.endDate timeIntervalSinceDate:self.startDate]);
            }
            [self.recorder stop];
            [self cancelCurrentRecording];
            return;
        }
        self.recordFinish = completion;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.recorder stop];
            //            HDLog(@"录音时长 :%f", [self.endDate timeIntervalSinceDate:self.startDate]);
        });
    }
}

- (BOOL)canRecord {
    __block BOOL bCanRecord = YES;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            bCanRecord = granted;
        }];
    }
    return bCanRecord;
}

- (void)cancelCurrentRecording {
    _recorder.delegate = nil;
    if (_recorder.recording) {
        [_recorder stop];
    }
    _recorder = nil;
    _recordFinish = nil;
}

// 移除音频
- (void)removeCurrentRecordFile:(NSString *)fileName {
    [self cancelCurrentRecording];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [self recorderPathWithFileName:fileName];
    BOOL isDirExist = [fileManager fileExistsAtPath:path];
    if (isDirExist) {
        [fileManager removeItemAtPath:path error:nil];
    }
}

- (NSString *)recorderPathWithFileName:(NSString *)fileName {
    NSString *path = [self recorderMainPath];
    return [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav", fileName]];
}

// 录音文件主路径
- (NSString *)recorderMainPath {
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"Recoder"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

#pragma mark - AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    NSString *recordPath = [[_recorder url] path];
    if (self.recordFinish) {
        if (!flag) {
            recordPath = nil;
        }
        self.recordFinish(recordPath, [self.endDate timeIntervalSinceDate:self.startDate]);
    }
    _recorder = nil;
    self.recordFinish = nil;
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *__nullable)error {
    HDLog(@"录音编码错误：%@", error);
}

#pragma mark - lazy load
- (NSDictionary *)recordSetting {
    if (!_recordSetting) {
        _recordSetting = @{
            AVSampleRateKey: [NSNumber numberWithFloat:8000.0],            //录音采样率(Hz)如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
            AVFormatIDKey: [NSNumber numberWithInt:kAudioFormatLinearPCM], //音频格式
            AVLinearPCMBitDepthKey: [NSNumber numberWithInt:16],           //线性音频的位深度8、16、24、32
            AVNumberOfChannelsKey: [NSNumber numberWithInt:1],             //音频通道数1或2
        };
    }
    return _recordSetting;
}

- (NSTimeInterval)recordMinDuration {
    return 1.0f;
}

@end
