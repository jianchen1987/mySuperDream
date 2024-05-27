//
//  WMMineViewModel.h
//  SuperApp
//
//  Created by VanJay on 2020/3/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACouponInfoRspModel.h"
#import "SAGetUserInfoRspModel.h"
#import "SAUser.h"
#import "WMFAQViewModel.h"
#import "WMViewModel.h"

@class HDTableViewSectionModel;

NS_ASSUME_NONNULL_BEGIN


@interface WMMineViewModel : WMViewModel
/// 数据源
@property (nonatomic, strong, readonly) NSMutableArray<HDTableViewSectionModel *> *dataSource;
/// 用户
@property (nonatomic, strong) SAUser *user;
/// 优惠信息
@property (nonatomic, strong, readonly) HDTableViewSectionModel *couponInfoSectionModel;
/// 用户信息
@property (nonatomic, strong, readonly) SAGetUserInfoRspModel *userInfoRspModel;
/// faqViewMdoel
@property (nonatomic, strong) WMFAQViewModel *faqViewModel;
/// 标志，只要变化就刷新
@property (nonatomic, assign) BOOL refreshFlag;

- (void)handleLanguageDidChanged;

/// 获取优惠券信息以及操作员信息，避免多次reload tableView
/// @param completion 两个请求都完成得回调
- (void)getCouponInfoAndUserInfoCompletion:(void (^)(void))completion;

/// 清除数据
- (void)clearDataSource;
@end

NS_ASSUME_NONNULL_END
