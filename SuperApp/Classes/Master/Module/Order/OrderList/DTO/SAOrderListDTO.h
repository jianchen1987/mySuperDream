//
//  SAOrderListDTO.h
//  SuperApp
//
//  Created by VanJay on 2020/5/20.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAModel.h"
#import "SAOrderBillListModel.h"

@class SAOrderListRspModel;

NS_ASSUME_NONNULL_BEGIN


@interface SAOrderListDTO : SAModel

/// /// 用户端查询订单列表
/// @param businessType 业务线
/// @param orderState 订单状态
/// @param pageNum 第几页
/// @param pageSize 每页几条
/// @param orderTimeStart 开始时间
/// @param orderTimeEnd 结束时间
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getOrderListWithBusinessType:(SAClientType)businessType
                          orderState:(SAOrderState)orderState
                             pageNum:(NSUInteger)pageNum
                            pageSize:(NSUInteger)pageSize
                      orderTimeStart:(nullable NSString *)orderTimeStart
                        orderTimeEnd:(nullable NSString *)orderTimeEnd
                             success:(void (^)(SAOrderListRspModel *rspModel))successBlock
                             failure:(CMNetworkFailureBlock)failureBlock;

/// 用户端查询订单列表
/// @param businessType 业务线
/// @param orderState 订单状态
/// @param pageNum 第几页
/// @param pageSize 每页几条
/// @param orderTimeStart 开始时间
/// @param orderTimeEnd 结束时间
/// @param keyName 搜索关键字
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getOrderListWithBusinessType:(SAClientType)businessType
                          orderState:(SAOrderState)orderState
                             pageNum:(NSUInteger)pageNum
                            pageSize:(NSUInteger)pageSize
                      orderTimeStart:(nullable NSString *)orderTimeStart
                        orderTimeEnd:(nullable NSString *)orderTimeEnd
                             keyName:(nullable NSString *)keyName
                             success:(void (^)(SAOrderListRspModel *rspModel))successBlock
                             failure:(CMNetworkFailureBlock)failureBlock;

/// 确认订单
/// @param orderNo 订单号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)confirmOrderWithOrderNo:(NSString *)orderNo success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

///  再次购买
/// @param orderNo 中台订单号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)rebuyOrderWithOrderNo:(NSString *)orderNo success:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

///  删除订单
/// @param orderNo 中台订单号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)deleteOrderWithOrderNo:(NSString *)orderNo success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock)failureBlock;

/// 获取订单账单列表
/// @param orderNo 中台订单号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getOrderBillListWithOrderNo:(NSString *)orderNo success:(void (^)(SAOrderBillListModel *model))successBlock failure:(CMNetworkFailureBlock)failureBlock;

/// 确定取餐
/// @param orderNo 中台订单号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)submitPickUpOrderWithOrderNo:(NSString *)orderNo success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END
