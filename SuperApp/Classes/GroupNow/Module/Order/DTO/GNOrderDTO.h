//
//  GNOrderDTO.h
//  SuperApp
//
//  Created by wmz on 2021/6/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNCouponDetailModel.h"
#import "GNModel.h"
#import "GNOrderCancelRspModel.h"
#import "GNOrderPagingRspModel.h"
#import "GNOrderRushBuyModel.h"
#import "GNProductModel.h"
#import "GNRefundModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNOrderDTO : GNModel

/// 抢购
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)orderRushBuyRequestStoreNo:(nonnull NSString *)storeNo
                              code:(nonnull NSString *)code
                           success:(nullable void (^)(GNOrderRushBuyModel *rspModel))successBlock
                           failure:(nullable CMNetworkFailureBlock)failureBlock;

/// 下单
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)orderCreateRequestInfo:(nonnull NSDictionary *)info success:(nullable CMNetworkSuccessBlock)successBlock failure:(nullable CMNetworkFailureBlock)failureBlock;

/// 订单列表
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)orderListRequestCustomerNo:(nonnull NSString *)customerNo
                           pageNum:(NSInteger)pageNum
                          bizState:(nullable NSString *)bizState
                           success:(nullable void (^)(GNOrderPagingRspModel *rspModel))successBlock
                           failure:(nullable CMNetworkFailureBlock)failureBlock;

/// 订单列表头部统计
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)orderListCountRequestSuccess:(nullable CMNetworkSuccessBlock)successBlock failure:(nullable CMNetworkFailureBlock)failureBlock;

/// 订单取消
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)orderCanceledRequestCustomerNo:(nonnull NSString *)customerNo
                               orderNo:(nonnull NSString *)orderNo
                           cancelState:(nonnull NSString *)cancelState
                                remark:(nullable NSString *)remark
                               success:(nullable CMNetworkSuccessBlock)successBlock
                               failure:(nullable CMNetworkFailureBlock)failureBlock;

/// 订单详情
/// @param orderNo 订单号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)orderDetailRequestCustomerNo:(nonnull NSString *)customerNo
                             orderNo:(nonnull NSString *)orderNo
                             success:(nullable void (^)(GNOrderCellModel *rspModel))successBlock
                             failure:(nullable CMNetworkFailureBlock)failureBlock;

/// 获取订单核销信息
/// @param orderNo 订单号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)orderVerificationStateRequestCustomerNo:(nonnull NSString *)customerNo
                                        orderNo:(nonnull NSString *)orderNo
                                        success:(nullable void (^)(GNMessageCode *rspModel))successBlock
                                        failure:(nullable CMNetworkFailureBlock)failureBlock;

/// 通过订单号获取商品编码（用于聚合订单页面跳转）
/// @param orderNo 订单号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)orderGetOrderProductCodeWithOrderNo:(nonnull NSString *)orderNo success:(nullable void (^)(GNProductModel *rspModel))successBlock failure:(nullable CMNetworkFailureBlock)failureBlock;

/// 通过订单号查询退款信息
/// @param orderNo 订单号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)orderRefundDetailWithOrderNo:(nonnull NSString *)orderNo success:(nullable void (^)(GNRefundModel *rspModel))successBlock failure:(nullable CMNetworkFailureBlock)failureBlock;

/// 获取订单取消原因
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)orderCancelListSuccess:(nullable void (^)(NSArray<GNOrderCancelRspModel *> *rspModel))successBlock failure:(nullable CMNetworkFailureBlock)failureBlock;

/// 获取订单优惠券
/// @param orderNo 订单号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getOrderCouponListWithOrderNo:(nonnull NSString *)orderNo
                              success:(nullable void (^)(NSArray<GNCouponDetailModel *> *rspModel))successBlock
                              failure:(nullable CMNetworkFailureBlock)failureBlock;

@end

NS_ASSUME_NONNULL_END
