//
//  SJAVMediaPlayerLayerView.h
//  Pods
//
//  Created by 畅三江 on 2020/2/19.
//

#import "SJMediaPlaybackController.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface SJAVMediaPlayerLayerView : UIView <SJMediaPlayerView>
@property (nonatomic, strong, readonly) AVPlayerLayer *layer;
- (void)setScreenshot:(nullable UIImage *)image;
@end

NS_ASSUME_NONNULL_END
