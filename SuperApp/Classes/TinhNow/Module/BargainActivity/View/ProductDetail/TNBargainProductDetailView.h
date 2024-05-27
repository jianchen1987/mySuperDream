//
//  TNBargainProductDetailView.h
//  SuperApp
//
//  Created by 张杰 on 2022/7/1.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SJVideoPlayer.h"
#import "TNView.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNBargainProductDetailView : TNView
/// 播放器
@property (strong, nonatomic, readonly) SJVideoPlayer *player;
///// 拨打电话回调
//@property (nonatomic, copy) void (^callPhoneClickCallBack)(void);
///// 分享回调
//@property (nonatomic, copy) void (^shareClickCallBack)(void);
@end

NS_ASSUME_NONNULL_END
