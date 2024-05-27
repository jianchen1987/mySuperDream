//
//  WMOrderFeedBackDTO.h
//  SuperApp
//
//  Created by wmz on 2021/11/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "WMEnum.h"
#import "WMFeedBackRefundAmountModel.h"
#import "WMModel.h"
#import "WMOrderDetailProductModel.h"
#import "WMOrderFeedBackDetailModel.h"
#import "WMOrderFeedBackReasonRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderFeedBackDTO : WMModel

/// 用户创建售后反馈单
/// @param orderNo 订单号
/// @param postSaleType 期望处理方式
/// @param reasonCode 原因编号
/// @param description 原因详情
/// @param imagePaths 图片数组
/// @param commodityInfo 商品信息
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)requestSubmitOrderPostSaleFeedBackWithNo:(NSString *)orderNo
                                    postSaleType:(WMOrderFeedBackPostShowType)postSaleType
                                      reasonCode:(NSString *)reasonCode
                                   commodityInfo:(nullable NSArray *)commodityInfo
                                     description:(nullable NSString *)description
                                      imagePaths:(nullable NSArray<NSString *> *)imagePaths
                                         success:(CMNetworkSuccessBlock _Nullable)successBlock
                                         failure:(CMNetworkFailureBlock _Nullable)failureBlock;

///获取订单反馈问题原因列表
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)requestFindFeedbackReasonListWithSuccess:(void (^_Nullable)(NSArray<WMOrderFeedBackReasonRspModel *> *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 获取可退商品列表
/// @param orderNo 订单号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)requestGetRefundableProductWithNO:(NSString *)orderNo
                                  success:(void (^_Nullable)(NSArray<WMOrderDetailProductModel *> *rspModel))successBlock
                                  failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 计算退款金额
/// @param orderNo 订单号
/// @param commodityInfo 商品信息
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)requestCalculationRefundAmountWithNO:(NSString *)orderNo
                               commodityInfo:(nullable NSArray *)commodityInfo
                                     success:(void (^_Nullable)(WMFeedBackRefundAmountModel *rspModel))successBlock
                                     failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 售后反馈单列表
/// @param orderNo 订单号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)requestPostSaleListByOrderWithNO:(NSString *)orderNo
                                 success:(void (^_Nullable)(NSArray<WMOrderFeedBackDetailModel *> *rspModel))successBlock
                                 failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 售后反馈单详情
/// @param ids 反馈单id
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)requestPostSaleDetailByOrderWithId:(NSInteger)ids success:(void (^_Nullable)(WMOrderFeedBackDetailModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
