//
//  SJAVMediaPlaybackController.h
//  Pods
//
//  Created by 畅三江 on 2020/2/18.
//

#import "SJAVMediaPlayer.h"
#import "SJAVMediaPlayerLayerView.h"
#import "SJMediaPlaybackController.h"

NS_ASSUME_NONNULL_BEGIN


@interface SJAVMediaPlaybackController : SJMediaPlaybackController

@property (nonatomic, strong, readonly, nullable) SJAVMediaPlayer *currentPlayer;
@property (nonatomic, strong, readonly, nullable) SJAVMediaPlayerLayerView *currentPlayerView;
@property (nonatomic) BOOL accurateSeeking;

@end


@interface SJAVMediaPlaybackController (SJAVMediaPlaybackAdd) <SJMediaPlaybackExportController, SJMediaPlaybackScreenshotController>

@end
NS_ASSUME_NONNULL_END
