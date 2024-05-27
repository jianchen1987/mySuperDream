//
//  CMSPlayerCardView.m
//  SuperApp
//
//  Created by Tia on 2022/6/2.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "CMSPlayerCardView.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>


#define kCMSPlayerCardViewHeight (kScreenWidth * 9 / 16.0f)

static NSString *const VideoPlayStatus = @"status";


@interface CMSPlayerCardView ()
/// 视频控制器
@property (nonatomic, strong) AVPlayerViewController *videoPlayer;
/// 视频拉伸方式
@property (nonatomic, assign) AVLayerVideoGravity videoGravity;
/// 是否单次播放，默认否
@property (nonatomic, assign) BOOL videoCycleOnce;
/// 是否静音，默认静音
@property (nonatomic, assign) BOOL muted;
/// 视频url
@property (nonatomic, strong) NSURL *contentURL;
/// 播放载体
@property (nonatomic, strong) AVPlayerItem *playerItem;
/// 是否正在播放
@property (nonatomic, assign) BOOL isPlaying;

@end


@implementation CMSPlayerCardView

- (void)hd_setupViews {
    [super hd_setupViews];
    [self addSubview:self.videoPlayer.view];
}

- (void)updateConstraints {
    [self.videoPlayer.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.height.mas_equalTo(kCMSPlayerCardViewHeight);
    }];

    [super updateConstraints];
}

#pragma mark - OverWrite
- (CGFloat)heightOfCardView {
    CGFloat height = 0;
    height += kCMSPlayerCardViewHeight;
    height += [self.titleView heightOfTitleView];
    height += UIEdgeInsetsGetVerticalValue(self.config.contentEdgeInsets);

    return height;
}

#pragma mark - Action
- (void)startPlayer {
    if (!self.contentURL || self.isPlaying)
        return;
    self.isPlaying = YES;
    [self.videoPlayer.player play];
}

- (void)stopPlayer {
    if (_videoPlayer && self.isPlaying) {
        [_videoPlayer.player pause];
        self.isPlaying = NO;
    }
}

- (void)stopVideoPlayer {
    if (!_videoPlayer)
        return;
    [_videoPlayer.player pause];
    self.isPlaying = NO;
    [_videoPlayer.view removeFromSuperview];
    _videoPlayer = nil;

    /** 释放音频焦点 */
    //    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
}

- (void)runLoopTheMovie:(NSNotification *)notification {
    //需要循环播放
    self.isPlaying = NO;
    if (!_videoCycleOnce) {
        [(AVPlayerItem *)[notification object] seekToTime:kCMTimeZero completionHandler:nil];
        [_videoPlayer.player play]; //重播
        self.isPlaying = YES;
    }
}

#pragma mark - setter
- (void)setConfig:(SACMSCardViewConfig *)config {
    [super setConfig:config];
    //    self.dataSource = [NSArray yy_modelArrayWithClass:CMSMuItipleIconTextMarqueeItemConfig.class json:config.getAllNodeContents];
    //    [self.collectionView successGetNewDataWithNoMoreData:NO];
    self.contentURL = [NSURL URLWithString:@"https://carapptest.gtmc.com.cn/fs01/20220114/c75dcf4af8e8daea9908322648a23cf0.mp4"];
}

- (void)setVideoGravity:(AVLayerVideoGravity)videoGravity {
    _videoGravity = videoGravity;
    _videoPlayer.videoGravity = videoGravity;
}
- (void)setMuted:(BOOL)muted {
    _muted = muted;
    _videoPlayer.player.muted = muted;
}

- (void)setContentURL:(NSURL *)contentURL {
    if (_contentURL != contentURL || !_contentURL) {
        _contentURL = contentURL;
        AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:contentURL options:nil];
        self.playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
        _videoPlayer.player = [AVPlayer playerWithPlayerItem:self.playerItem];
        // 监听播放失败状态
        [self.playerItem addObserver:self forKeyPath:VideoPlayStatus options:NSKeyValueObservingOptionNew context:nil];
        //        [self.videoPlayer.player play];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey, id> *)change context:(void *)context {
    HDLog(@"%@-%@-%@-%@", keyPath, object, change, context);
}


#pragma mark - lazy
- (AVPlayerViewController *)videoPlayer {
    if (!_videoPlayer) {
        _videoPlayer = [[AVPlayerViewController alloc] init];
        _videoPlayer.showsPlaybackControls = NO;
        _videoPlayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _videoPlayer.view.backgroundColor = [UIColor clearColor];
        //注册通知控制是否循环播放
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(runLoopTheMovie:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];

        /** 获取音频焦点 */
        //        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        //        [[AVAudioSession sharedInstance] setActive:YES error:nil];
    }
    return _videoPlayer;
}

- (void)dealloc {
    [self.playerItem removeObserver:self forKeyPath:VideoPlayStatus];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self stopVideoPlayer];
}

@end
