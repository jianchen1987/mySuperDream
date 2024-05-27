//
//  CMSPlayerCardView.h
//  SuperApp
//
//  Created by Tia on 2022/6/2.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACMSCardView.h"

NS_ASSUME_NONNULL_BEGIN


@interface CMSPlayerCardView : SACMSCardView
/// 播放视频
- (void)startPlayer;
/// 暂停视频
- (void)stopPlayer;

@end

NS_ASSUME_NONNULL_END
