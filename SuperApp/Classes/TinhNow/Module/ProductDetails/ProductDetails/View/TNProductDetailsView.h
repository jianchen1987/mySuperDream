//
//  TNSectionTableViewSceneView.h
//  SuperApp
//
//  Created by seeu on 2020/7/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNView.h"
//#import <SJVideoPlayer/SJVideoPlayer.h>
#import "SJVideoPlayer.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNProductDetailsView : TNView
/// 播放器
@property (strong, nonatomic, readonly) SJVideoPlayer *player;

/// 拨打电话回调
@property (nonatomic, copy) void (^callPhoneClickCallBack)(void);
/// 分享回调
@property (nonatomic, copy) void (^shareClickCallBack)(void);
@end

NS_ASSUME_NONNULL_END
