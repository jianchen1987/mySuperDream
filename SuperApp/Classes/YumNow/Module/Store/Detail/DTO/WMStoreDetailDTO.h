//
//  WMStoreDetailDTO.h
//  SuperApp
//
//  Created by VanJay on 2020/6/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN

@class WMStoreDetailRspModel, WMOrderBriefRspModel, WMSearchStoreRspModel;


@interface WMStoreDetailDTO : WMModel

/// 获取门店详情
/// @param storeNo 门店号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)getStoreDetailInfoWithStoreNo:(NSString *)storeNo success:(void (^)(WMStoreDetailRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 获取订单评价简要信息
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)getOrderBriefInfoWithOrderId:(NSString *)orderId success:(void (^)(WMOrderBriefRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 获取相似门店
/// @param storeNo 门店号
/// @param pageNum 分页
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getSimilarStoreListWithStoreNo:(NSString *)storeNo
                               pageNum:(NSInteger)pageNum
                               success:(void (^)(WMSearchStoreRspModel *rspModel))successBlock
                               failure:(CMNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
