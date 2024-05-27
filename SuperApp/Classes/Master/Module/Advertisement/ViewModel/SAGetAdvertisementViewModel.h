//
//  SAGetAdvertisementViewModel.h
//  SuperApp
//
//  Created by VanJay on 2020/4/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAAdvertisementsRspModel.h"
#import "SAViewModel.h"

typedef NS_ENUM(NSUInteger, HDADLocation) {
    HDADLocationBootPage = 1,             ///< 启动页
    HDADLocationHomePage = 2,             ///< 首页轮播
    HDADLocationDiscoveryPage = 3,        ///< 发现页
    HDADLocationAuthPage = 4,             ///< 实名页
    HDADLocationHomePageActivity = 5,     ///< 首页活动
    HDADLocationMinePageActivity = 6,     ///< “我的”页面活动
    HDADLocationHomePageCollectionAd = 7, ///< 首页手动滑广告
};

NS_ASSUME_NONNULL_BEGIN

typedef void (^CMAdNetworkFailureBlock)(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error, HDADLocation location);


@interface SAGetAdvertisementViewModel : SAViewModel

/// 通用的获取轮播广告
/// @param location 广告位置
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)getAdvertisementWithLocation:(HDADLocation)location
                                           success:(void (^)(SAAdvertisementsRspModel *rspModel, HDADLocation location))successBlock
                                           failure:(CMAdNetworkFailureBlock _Nullable)failureBlock;

/// 获取首页轮播广告
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)getHomePageAdvertisementSuccess:(void (^)(SAAdvertisementsRspModel *rspModel, HDADLocation location))successBlock failure:(CMAdNetworkFailureBlock _Nullable)failureBlock;

/// 获取启动页轮播广告
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)getBootpageAdvertisementSuccess:(void (^)(SAAdvertisementsRspModel *rspModel, HDADLocation location))successBlock failure:(CMAdNetworkFailureBlock _Nullable)failureBlock;

/// 获取发现页轮播广告
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)getFoundAdvertisementSuccess:(void (^)(SAAdvertisementsRspModel *rspModel, HDADLocation location))successBlock failure:(CMAdNetworkFailureBlock _Nullable)failureBlock;

/// 获取实名页轮播广告
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)getAuthAdvertisementSuccess:(void (^)(SAAdvertisementsRspModel *rspModel, HDADLocation location))successBlock failure:(CMAdNetworkFailureBlock _Nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END
