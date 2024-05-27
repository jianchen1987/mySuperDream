//
//  WMStoreDTO.h
//  SuperApp
//
//  Created by VanJay on 2020/4/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"

@class WMCheckIsStoreCanDeliveryRspModel;
@class WMQueryNearbyStoreRspModel;
@class WMQueryMerchantFilterCategoryRspModel;
@class WMHomeLayoutModel;
@class WMQueryNearbyStoreNewRspModel;

NS_ASSUME_NONNULL_BEGIN


@interface WMStoreDTO : WMModel

/// 获取附近可配送门店. 距离由近到远
/// @param requestSource 推荐来源
/// @param longitude 经度
/// @param latitude 纬度
/// @param pageSize 每页几条
/// @param pageNum 第几页
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)getNearbyStoreWithRequestSource:(WMMerchantRecommendType)requestSource
                                            longitude:(NSString *)longitude
                                             latitude:(NSString *)latitude
                                             pageSize:(NSUInteger)pageSize
                                              pageNum:(NSUInteger)pageNum
                                             sortType:(NSString *)sortType
                                       marketingTypes:(NSArray<NSString *> *)marketingTypes
                                         storeFeature:(NSArray<NSString *> *)storeFeature
                                        businessScope:(NSString *)businessScope
                                              success:(void (^)(WMQueryNearbyStoreNewRspModel *rspModel))successBlock
                                              failure:(CMNetworkFailureBlock _Nullable)failureBlock;
/// 查询免配送费门店列表
/// @param longitude 经度
/// @param latitude 纬度
/// @param pageSize 每页几条
/// @param pageNum 第几页
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getDeliveryFeeStoreListLongitude:(NSString *)longitude
                                latitude:(NSString *)latitude
                                pageSize:(NSUInteger)pageSize
                                 pageNum:(NSUInteger)pageNum
                                   param:(nullable NSDictionary *)param
                                 success:(void (^)(WMQueryNearbyStoreRspModel *rspModel))successBlock
                                 failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 判断目标经纬度是否在门店配送范围内
/// @param storeNo 门店号
/// @param longitude 经度
/// @param latitude 纬度
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)checkIsStoreCanDeliveryWithStoreNo:(NSString *)storeNo
                                               longitude:(NSString *)longitude
                                                latitude:(NSString *)latitude
                                                 success:(void (^_Nullable)(WMCheckIsStoreCanDeliveryRspModel *rspModel))successBlock
                                                 failure:(CMNetworkFailureBlock _Nullable)failureBlock;



/// 阿波罗首页配置
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)getWMAplioConfigSuccess:(void (^)(id rspModel))successBlock failure:(CMNetworkFailureBlock)failureBlock;

/// 阿波罗活动精选配置
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)getWMAplioConfigAreaNameSuccess:(void (^)(id rspModel))successBlock failure:(CMNetworkFailureBlock)failureBlock;

///根据经纬度获取首页栏目配置
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getWMIndexShowColumnSuccess:(void (^)(id rspModel))successBlock failure:(CMNetworkFailureBlock)failureBlock;
@end

NS_ASSUME_NONNULL_END
