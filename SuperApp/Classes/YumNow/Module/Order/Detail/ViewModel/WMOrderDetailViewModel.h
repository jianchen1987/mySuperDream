//
//  WMOrderDetailViewModel.h
//  SuperApp
//
//  Created by VanJay on 2020/5/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderDetailRspModel.h"
#import "WMViewModel.h"

@class WMOrderDetailDeliveryRiderRspModel;
@class WMOrderDetailCancelOrderRspModel;
@class SAQueryPaymentStateRspModel;
@class WMOrderCancelReasonModel;

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderDetailViewModel : WMViewModel
/// 聚合订单号
@property (nonatomic, copy) NSString *orderNo;
/// 门店号
@property (nonatomic, copy) NSString *storeNo;
/// 订单详情
@property (nonatomic, strong) WMOrderDetailRspModel *orderDetailRspModel;
/// 骑手信息
@property (nonatomic, strong) WMOrderDetailDeliveryRiderRspModel *deliveryRiderRspModel;
/// 是否隐藏地图
@property (nonatomic, assign, readonly) BOOL shouldHideMap;
/// 是否已获取初始化数据
@property (nonatomic, assign) BOOL hasGotInitializedData;
/// 请求状态
@property (nonatomic, assign) int requestState;
/// TGBotLink
@property (nonatomic, copy) NSString *TGBotLink;
/// 获取聚合订单详情
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)getOrderDetailSuccess:(void (^_Nullable)(WMOrderDetailRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 获取骑手位置
/// @param deliveryRiderId 骑手 id
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)getDeliverManLocationWithDeliveryManId:(NSString *)deliveryRiderId
                                                     success:(void (^_Nullable)(WMOrderDetailDeliveryRiderRspModel *rspModel))successBlock
                                                     failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 取消订单
/// @param model 取消原因
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)userCancelOrderWithCancelReason:(nullable WMOrderCancelReasonModel *)model
                                              success:(void (^)(WMOrderDetailCancelOrderRspModel *rspModel))successBlock
                                              failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 催单
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)userUrgeOrderSuccess:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

- (void)getNewData;
- (void)getOrderPaymentStateSuccess:(void (^_Nullable)(SAQueryPaymentStateRspModel *rspModel))success failure:(CMNetworkFailureBlock _Nullable)failure;

/// 获取取消订单原因列表
/// @param successBlock 成功回调
- (void)userCancelOrderReasonSuccess:(void (^)(NSArray<WMOrderCancelReasonModel *> *rspModel, BOOL error))successBlock;

///获取绑定TG
- (void)getTGBindComplete:(void (^_Nullable)(NSString *_Nullable bindURL))successBlock;
@end

NS_ASSUME_NONNULL_END
