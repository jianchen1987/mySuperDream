//
//  TNOrderDTO.h
//  SuperApp
//
//  Created by seeu on 2020/7/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN
@class TNQueryProcessingOrderRspModel;
@class TNQueryOrderDetailsRspModel;
@class TNQueryExchangeOrderExplainRspModel;
@class TNCheckRegionModel;
@class TNOrderListRspModel;


@interface TNOrderDTO : TNModel

///// 查询当前用户待处理订单数     中台接口 电商用新开的接口
///// @param operatorNo 操作员id
///// @param successBlock 成功回调
///// @param failureBlock 失败回调
//- (void)queryProccessingOrdersWithOperatorNo:(NSString *)operatorNo
//                                     success:(void (^_Nullable)(TNQueryProcessingOrderRspModel *rspModel))successBlock
//                                     failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 查询订单详情
/// @param orderNo 中台订单号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryOrderDetailsWithOrderNo:(NSString *)orderNo success:(void (^_Nullable)(TNQueryOrderDetailsRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;
///  再次购买
/// @param orderNo 中台订单号
/// @param successBlock 成功回调 返回再次购买的skuIDs 用于去购物车列表帮助用户自动勾选
/// @param failureBlock 失败回调
- (void)rebuyOrderWithOrderNo:(NSString *)orderNo success:(void (^_Nullable)(NSArray *skuIds))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 取消订单
/// @param orderNo 订单号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)cancelOrderWithOrderNo:(NSString *)orderNo success:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 确认订单
/// @param orderNo 订单号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)confirmOrderWithOrderNo:(NSString *)orderNo success:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 换货
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)exchangeOrderExplainSuccess:(void (^_Nullable)(TNQueryExchangeOrderExplainRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 等待付款、等待审核、等待发货 这三种状态可以修改订单地址
/// @param orderNo 订单号
/// @param addressNo 地址编号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)changeOrderAddressWithOrderNo:(NSString *)orderNo addressNo:(NSString *)addressNo success:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 检查 校验配送地址是否在配送范围内
/// @param latitude 纬度
/// @param longitude 经度
/// @param storeNo 店铺NO
/// @param paymentMethod 支付方式
/// @param scene =1订单详情
- (void)checkRegionAreaWithLatitude:(NSNumber *)latitude
                          longitude:(NSNumber *)longitude
                            storeNo:(NSString *)storeNo
                      paymentMethod:(TNPaymentMethod)paymentMethod
                              scene:(NSString *)scene
                            Success:(void (^_Nullable)(TNCheckRegionModel *model))successBlock
                            failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 获取附近购买的跳转路由
/// @param orderNo 订单号
/// @param storeNo 门店号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryNearByRouteWithOrderNo:(NSString *_Nonnull)orderNo
                            storeNo:(NSString *_Nonnull)storeNo
                            success:(void (^)(NSString *_Nullable route))successBlock
                            failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 获取电商订单列表处理中的订单数量
/// @param operatorNo 用户id
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryTinhNowProcessOrdersNumberWithOperateNo:(NSString *)operatorNo
                                             success:(void (^_Nullable)(TNQueryProcessingOrderRspModel *rspModel))successBlock
                                             failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 获取订单列表数据
/// @param operatorNo 操作员编号
/// @param state 订单状态
/// @param pageSize 页数
/// @param pageNum 页码
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)queryOrderListDataWithOperateNo:(NSString *)operatorNo
                                  state:(TNOrderState)state
                               pageSize:(NSInteger)pageSize
                                pageNum:(NSInteger)pageNum
                                success:(void (^_Nullable)(TNOrderListRspModel *rspModel))successBlock
                                failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 创建支付单  返回一个支付订单号
/// @param returnUrl 支付跳转url
/// @param orderNo 聚合订单号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)createPayOrderWithReturnUrl:(NSString *)returnUrl
                            orderNo:(NSString *)orderNo
                            success:(void (^_Nullable)(NSString *outPayOrderNo))successBlock
                            failure:(CMNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
