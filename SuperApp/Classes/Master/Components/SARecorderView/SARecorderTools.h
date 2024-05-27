//
//  SARecorderTools.h
//  SuperApp
//
//  Created by Tia on 2022/8/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>

#define kSAShortRecord @"SAShortRecord"

NS_ASSUME_NONNULL_BEGIN

typedef void (^SARecordFinishBlock)(NSString *recordPath, int duration);


@interface SARecorderTools : NSObject
/// 录音器
@property (nonatomic, strong, readonly) AVAudioRecorder *recorder;

+ (instancetype)shareManager;
/// 开始录音
/// @param fileName 录音路径
/// @param completion 回调
- (void)startRecordingWithFileName:(NSString *)fileName completion:(void (^)(NSError *error))completion;
/// 停止录音
/// @param completion 回调
- (void)stopRecordingWithCompletion:(nullable SARecordFinishBlock)completion;
/// 是否拥有权限
- (BOOL)canRecord;
/// 取消当前录制
- (void)cancelCurrentRecording;
/// 移除当前录音文件
/// @param fileName 文件路径
- (void)removeCurrentRecordFile:(NSString *)fileName;

@end

NS_ASSUME_NONNULL_END
