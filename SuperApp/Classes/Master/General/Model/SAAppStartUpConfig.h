//
//  SAAppStartUpConfig.h
//  SuperApp
//
//  Created by Chaos on 2021/4/2.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SARspModel.h"

NS_ASSUME_NONNULL_BEGIN

@class SATabBarItemConfig;
@class SAKingKongAreaItemConfig;
@class SAPaymentChannelModel;
@class SAStartupAdModel;


@interface SAAppStartUpTabbarConfig : SAModel

/// 业务线
@property (nonatomic, copy) SAClientType businessLine;
/// 配置
@property (nonatomic, strong) NSArray<SATabBarItemConfig *> *list;

@end


@interface SAAppStartUpKingkongAreaConfig : SAModel

/// 业务线
@property (nonatomic, copy) SAClientType businessLine;
/// 配置
@property (nonatomic, strong) NSArray<SAKingKongAreaItemConfig *> *list;

@end


@interface SAAppStartUpPaymentToolConfig : SAModel

/// 业务线
@property (nonatomic, copy) SAClientType businessLine;
/// 配置
@property (nonatomic, strong) NSArray<SAPaymentChannelModel *> *list;

@end


@interface SAAppStartUpConfig : SAModel

/// tabbar配置
@property (nonatomic, strong) NSArray<SAAppStartUpTabbarConfig *> *tabbars;
/// 金刚区配置
@property (nonatomic, strong) NSArray<SAAppStartUpKingkongAreaConfig *> *kingkongArea;
/// 支付工具
@property (nonatomic, strong) NSArray<SAAppStartUpPaymentToolConfig *> *paymentTools;
/// 阿波罗配置
@property (nonatomic, strong) NSDictionary *apollo;
/// 启动广告
@property (nonatomic, strong) NSArray<SAStartupAdModel *> *advertising;
/// 登录广告
@property (nonatomic, strong) NSDictionary *loginPage;

@end

NS_ASSUME_NONNULL_END
