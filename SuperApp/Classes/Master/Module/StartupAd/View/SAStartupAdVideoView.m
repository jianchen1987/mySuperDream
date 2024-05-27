//
//  SAStartupAdVideoView.m
//  SuperApp
//
//  Created by Chaos on 2021/4/14.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAStartupAdVideoView.h"

static NSString *const VideoPlayStatus = @"status";


@interface SAStartupAdVideoView ()

/// 填充视频第一帧图片
@property (nonatomic, strong) UIImageView *preViewIV;
@property (nonatomic, strong) AVPlayerViewController *videoPlayer;
@property (nonatomic, strong) AVPlayerItem *playerItem;

@end


@implementation SAStartupAdVideoView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.muted = NO;
        self.showVideoControls = NO;
        self.videoCycleOnce = NO;
    }
    return self;
}

- (void)dealloc {
    [self.playerItem removeObserver:self forKeyPath:VideoPlayStatus];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self stopVideoPlayer];
}

- (void)hd_setupViews {
    [self addSubview:self.preViewIV];
    @HDWeakify(self);
    self.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        @HDStrongify(self);
        self->_videoPlayer.view.frame = view.bounds;
        self.preViewIV.frame = view.bounds;
    };
}

#pragma mark - Action
- (void)startVideoPlayer {
    [self stopVideoPlayer];
    [self addSubview:self.videoPlayer.view];
    self.playerItem = [AVPlayerItem playerItemWithURL:self.contentURL];
    self.videoPlayer.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.videoPlayer.player.muted = self.muted;
    self.videoPlayer.videoGravity = self.videoGravity;
    self.videoPlayer.showsPlaybackControls = self.showVideoControls;
    // 监听播放失败状态
    [self.playerItem addObserver:self forKeyPath:VideoPlayStatus options:NSKeyValueObservingOptionNew context:nil];
    [self.videoPlayer.player play];
}

- (void)stopVideoPlayer {
    if (!_videoPlayer)
        return;
    [_videoPlayer.player pause];
    [_videoPlayer.view removeFromSuperview];
    _videoPlayer = nil;

    /** 释放音频焦点 */
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    self.preViewIV.image = nil;
}

- (void)runLoopTheMovie:(NSNotification *)notification {
    //需要循环播放
    if (!self.videoCycleOnce) {
        @HDWeakify(self);
        [(AVPlayerItem *)[notification object] seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
            @HDStrongify(self);
            if (finished)
                [self.videoPlayer.player play]; //重播
        }];
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey, id> *)change context:(void *)context {
    if ([keyPath isEqualToString:VideoPlayStatus]) {
        NSInteger newStatus = ((NSNumber *)change[@"new"]).integerValue;
        if (newStatus == AVPlayerItemStatusFailed) {
            [self stopVideoPlayer];
            !self.videoPlayerFailBlock ?: self.videoPlayerFailBlock();
        } else if (newStatus == AVPlayerItemStatusReadyToPlay) {
            self.preViewIV.image = nil;
        }
    }
}

#pragma mark - private methods
// 获取视频第一帧
- (UIImage *)getVideoPreViewImage:(NSURL *)path {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];

    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}

#pragma mark - setter
- (void)setVideoGravity:(AVLayerVideoGravity)videoGravity {
    _videoGravity = videoGravity;
    _videoPlayer.videoGravity = videoGravity;
}

- (void)setMuted:(BOOL)muted {
    _muted = muted;
    _videoPlayer.player.muted = muted;
}

- (void)setContentURL:(NSURL *)contentURL {
    _contentURL = contentURL;
    UIImage *image = [self getVideoPreViewImage:self.contentURL];
    @HDWeakify(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        @HDStrongify(self);
        self.preViewIV.image = image;
    });
}

- (void)setShowVideoControls:(BOOL)showVideoControls {
    _showVideoControls = showVideoControls;
    _videoPlayer.showsPlaybackControls = showVideoControls;
}

#pragma mark - lazy
- (AVPlayerViewController *)videoPlayer {
    if (!_videoPlayer) {
        _videoPlayer = [[AVPlayerViewController alloc] init];
        _videoPlayer.view.frame = self.frame;
        _videoPlayer.showsPlaybackControls = NO;
        _videoPlayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _videoPlayer.view.backgroundColor = [UIColor clearColor];
        //注册通知控制是否循环播放
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(runLoopTheMovie:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];

        /** 获取音频焦点 */
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
    }
    return _videoPlayer;
}

- (UIImageView *)preViewIV {
    if (!_preViewIV) {
        _preViewIV = UIImageView.new;
        _preViewIV.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _preViewIV;
}

@end
