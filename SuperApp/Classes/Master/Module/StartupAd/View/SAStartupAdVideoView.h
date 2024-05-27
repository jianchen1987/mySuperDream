//
//  SAStartupAdVideoView.h
//  SuperApp
//
//  Created by Chaos on 2021/4/14.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import <AVKit/AVKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface SAStartupAdVideoView : SAView

/// 视频填充模式， 默认 AVLayerVideoGravityResizeAspectFill
@property (nonatomic, assign) AVLayerVideoGravity videoGravity;
/// 是否只播放一次（不循环播放），默认false
@property (nonatomic, assign) BOOL videoCycleOnce;
/// 是否消声, 默认false
@property (nonatomic, assign) BOOL muted;
/// 视频路径
@property (nonatomic, strong) NSURL *contentURL;
///< 展示控制条，默认false
@property (nonatomic, assign) BOOL showVideoControls;

@property (nonatomic, strong, readonly) AVPlayerViewController *videoPlayer;

/// 视频播放失败
@property (nonatomic, copy) void (^videoPlayerFailBlock)(void);

- (void)startVideoPlayer;
- (void)stopVideoPlayer;

@end

NS_ASSUME_NONNULL_END
