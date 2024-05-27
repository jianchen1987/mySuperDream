//
//  SAMineViewModel.h
//  SuperApp
//
//  Created by VanJay on 2020/3/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACMSFloatWindowPluginView.h"
#import "SACouponInfoRspModel.h"
#import "SAGetUserInfoRspModel.h"
#import "SAUser.h"
#import "SAViewModel.h"

@class HDTableViewSectionModel;

NS_ASSUME_NONNULL_BEGIN


@interface SAMineViewModel : SAViewModel
/// 数据源
@property (nonatomic, strong, readonly) NSMutableArray<HDTableViewSectionModel *> *dataSource;
/// 用户
@property (nonatomic, strong) SAUser *user;
/// 优惠信息
@property (nonatomic, strong, readonly) HDTableViewSectionModel *couponInfoSectionModel;
/// 用户信息
@property (nonatomic, strong, readonly) SAGetUserInfoRspModel *userInfoRspModel;

///< 签到活动入口
@property (nonatomic, copy) NSString *signinActivityEntranceUrl;
@property (nonatomic, assign) UIEdgeInsets contentInsets; ///< 内边距
@property (nonatomic, strong) UIColor *bgColor;           ///< 背景色
@property (nonatomic, copy) NSString *bgImageUrl;         ///< 背景地址

/// 标志，只要变化就刷新
@property (nonatomic, assign) BOOL refreshFlag;

///< 插件
@property (nonatomic, strong) NSArray<SACMSPluginViewConfig *> *plugins;

/// 重新获取数据
- (void)getNewData:(void (^)(void))completion;

@end

NS_ASSUME_NONNULL_END
