//
//  WMOrderSubmitCouponDTO.h
//  SuperApp
//
//  Created by VanJay on 2020/5/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"

@class WMOrderSubmitCouponRspModel;

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderSubmitCouponDTO : WMModel

/// 营销查询可用优惠券
/// @param businessType 业务线
/// @param storeNo 消费门店
/// @param currencyType 币种
/// @param amount 订单金额
/// @param deliveryAmt 配送费
/// @param pageSize 每页数量-查询可用优惠券时传
/// @param pageNum 当前页-查询可用优惠券传
/// @param merchantNo 商户ID
/// @param addressNo 地址编号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)getCouponListWithBusinessType:(SAMarketingBusinessType)businessType
                                            storeNo:(NSString *)storeNo
                                       currencyType:(NSString *)currencyType
                                             amount:(NSString *)amount
                                        deliveryAmt:(NSString *)deliveryAmt
                                         packingAmt:(NSString *)packingAmt
                                           pageSize:(NSUInteger)pageSize
                                            pageNum:(NSUInteger)pageNum
                                         merchantNo:(NSString *)merchantNo
                                          addressNo:(NSString *)addressNo
                                            success:(void (^_Nullable)(WMOrderSubmitCouponRspModel *rspModel))successBlock
                                            failure:(CMNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
