//
//  WMOrderDetailDTO.h
//  SuperApp
//
//  Created by VanJay on 2020/7/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"
#import "WMOrderCancelReasonModel.h"

@class WMOrderDetailRspModel;
@class WMOrderDetailDeliveryRiderRspModel;
@class WMOrderDetailCancelOrderRspModel;
@class WMOrderCancelReasonModel;

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderDetailDTO : WMModel
/// 获取聚合订单详情
/// @param orderNo 订单号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)getOrderDetailWithOrderNo:(NSString *)orderNo success:(void (^_Nullable)(WMOrderDetailRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 获取骑手位置
/// @param deliveryRiderId 骑手 id
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)getDeliverManLocationWithDeliveryManId:(NSString *)deliveryRiderId
                                                     success:(void (^_Nullable)(WMOrderDetailDeliveryRiderRspModel *rspModel))successBlock
                                                     failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 取消订单
/// @param orderNo 订单号
- (CMNetworkRequest *)userCancelOrderWithOrderNo:(NSString *)orderNo
                                    cancelReason:(nullable WMOrderCancelReasonModel *)model
                                         success:(void (^)(WMOrderDetailCancelOrderRspModel *rspModel))successBlock
                                         failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 取消订单
/// @param orderNo 订单号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)userCancelOrderWithOrderNo:(NSString *)orderNo success:(void (^)(WMOrderDetailCancelOrderRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 催单订单
/// @param orderNo 订单号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)userUrgeOrderWithOrderNo:(NSString *)orderNo success:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 再来一单
/// @param orderNo 订单号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)onceAgainOrderWithOrderNo:(NSString *)orderNo success:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 取消原因
/// @param orderNo 订单号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)userCancelOrderReasonWithOrderNo:(NSString *)orderNo
                                               success:(void (^_Nullable)(NSArray<WMOrderCancelReasonModel *> *rspModel))successBlock
                                               failure:(CMNetworkFailureBlock _Nullable)failureBlock;
/// im群聊入口开启
- (void)wmFindSystemConfigs:(NSString *)key block:(void (^_Nullable)(BOOL canEnter))successBlock;

///查询用户tg账号是否绑定
- (void)WMCheckTGBindWithBlock:(void (^_Nullable)(NSString *_Nullable bindURL))successBlock;

@end

NS_ASSUME_NONNULL_END
