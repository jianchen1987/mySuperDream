//
//  TNMoreTableHeaderView.h
//  SuperApp
//
//  Created by seeu on 2020/6/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNView.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNMoreTableHeaderView : TNView
/// 我的助力回调点击
@property (nonatomic, copy) void (^myBargainClickCallBack)(void);
/// 我的拼团回调点击
@property (nonatomic, copy) void (^myJoinGroupClickCallBack)(void);
@end

NS_ASSUME_NONNULL_END
