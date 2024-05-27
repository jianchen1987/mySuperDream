//
//  SAAppConfigDTO.h
//  SuperApp
//
//  Created by VanJay on 2020/4/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAKingKongAreaItemConfig.h"
#import "SAMarketingAlertView.h"
#import "SATabBarItemConfig.h"
#import "SAViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@class SAAppStartUpConfig;


@interface SAAppConfigDTO : SAViewModel

/// 查询APP启动时需要拉取的配置
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryAppStartupConfigWithSuccess:(void (^)(SAAppStartUpConfig *startupConfig))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 查询金刚区配置
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryKingKongAreaConfigListWithType:(SAClientType)type success:(void (^)(NSArray<SAKingKongAreaItemConfig *> *list))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 查询首页 Tab 配置
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryTabBarConfigListWithType:(SAClientType)type success:(void (^)(NSArray<SATabBarItemConfig *> *list))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

- (void)queryAppRemoteConfigWithAppNo:(NSString *)appNo success:(void (^_Nullable)(SARspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 查询弹窗广告
/// @param type 业务线类型
/// @param province 省市
/// @param district 区
/// @param lat 纬度
/// @param lon 经度
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryAppMarketingAlertWithType:(SAClientType)type
                              province:(NSString *_Nullable)province
                              district:(NSString *_Nullable)district
                              latitude:(NSNumber *)lat
                             longitude:(NSNumber *)lon
                               success:(void (^)(NSArray<SAMarketingAlertViewConfig *> *list))successBlock
                               failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 查询登陆相关活动
/// @param type 业务线类型
/// @param province 省市
/// @param district 区
/// @param lat 经度
/// @param lon 纬度
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryLoginMarketingAlertWithType:(SAClientType)type
                                province:(NSString *_Nullable)province
                                district:(NSString *_Nullable)district
                                latitude:(NSNumber *)lat
                               longitude:(NSNumber *)lon
                              operatorNo:(NSString *)operatorNo
                                 success:(void (^)(NSArray<SAMarketingAlertViewConfig *> *list))successBlock
                                 failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 查询蓝绿标签
/// @param completion 成功回调
- (void)queryBlueAndGreenFlagCompletion:(void (^_Nullable)(NSString *_Nullable flag))completion;
@end

NS_ASSUME_NONNULL_END
