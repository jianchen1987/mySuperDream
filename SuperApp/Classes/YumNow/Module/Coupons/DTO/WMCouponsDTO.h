//
//  WMCouponsDTO.h
//  SuperApp
//
//  Created by wmz on 2022/7/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMCouponActivityModel.h"
#import "WMModel.h"
#import "WMOneClickResultModel.h"
#import "WMOrderSubmitCouponRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMCouponsDTO : WMModel

/// 营销查询可用现金优惠券
/// @param storeNo 消费门店
/// @param currencyType 币种
/// @param amount 订单金额
/// @param couponNo 已选择优惠券编号
/// @param deliveryAmt 配送费
/// @param merchantNo 商户ID
/// @param hasPromoCode 是否有PromoCode
/// @param hasShippingCoupon 是否有运费券
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getVoucherCouponListWithStoreNo:(NSString *)storeNo
                                 amount:(NSString *)amount
                            deliveryAmt:(NSString *)deliveryAmt
                             packingAmt:(NSString *)packingAmt
                           currencyType:(NSString *)currencyType
                             merchantNo:(NSString *)merchantNo
                           hasPromoCode:(NSString *)hasPromoCode
                      hasShippingCoupon:(NSString *)hasShippingCoupon
                               couponNo:(nullable NSString *)couponNo
                              addressNo:(NSString *)addressNo
                            activityNos:(NSArray<NSString *> *)activityNos
                                success:(void (^_Nullable)(WMOrderSubmitCouponRspModel *rspModel))successBlock
                                failure:(CMNetworkFailureBlock)failureBlock;

/// 营销查询可用运费券
/// @param storeNo 消费门店
/// @param currencyType 币种
/// @param amount 订单金额
/// @param deliveryAmt 配送费
/// @param merchantNo 商户ID
/// @param hasPromoCode 是否有PromoCode
/// @param hasShippingCoupon 是否有运费券
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getShippingCouponListWithStoreNo:(NSString *)storeNo
                                  amount:(NSString *)amount
                             deliveryAmt:(NSString *)deliveryAmt
                              packingAmt:(NSString *)packingAmt
                            currencyType:(NSString *)currencyType
                              merchantNo:(NSString *)merchantNo
                            hasPromoCode:(NSString *)hasPromoCode
                       hasShippingCoupon:(NSString *)hasShippingCoupon
                                couponNo:(nullable NSString *)couponNo
                               addressNo:(NSString *)addressNo
                             activityNos:(NSArray<NSString *> *)activityNos
                                 success:(void (^_Nullable)(WMOrderSubmitCouponRspModel *rspModel))successBlock
                                 failure:(CMNetworkFailureBlock)failureBlock;

/// 获取当前最新门店优惠券活动
/// @param storeNo 消费门店
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getStoreCouponActivityStoreNo:(NSString *)storeNo success:(void (^_Nullable)(WMCouponActivityContentModel *rspModel))successBlock failure:(CMNetworkFailureBlock)failureBlock;

/// 获取当前门店全部优惠券活动
/// @param storeNo 消费门店
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getStoreAllCouponActivityStoreNo:(NSString *)storeNo success:(void (^_Nullable)(WMCouponActivityModel *rspModel))successBlock failure:(CMNetworkFailureBlock)failureBlock;

/// 一键领券
/// @param storeNo 消费门店
/// @param activityNo 活动编号
/// @param couponNo 门店优惠券
/// @param storeJoinNo 门店参与编号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getOneClickCouponWithActivityNo:(NSString *)activityNo
                               couponNo:(NSArray<NSString *> *)couponNo
                            storeJoinNo:(NSString *)storeJoinNo
                                storeNo:(NSString *)storeNo
                                success:(void (^_Nullable)(WMOneClickResultModel *rspModel))successBlock
                                failure:(CMNetworkFailureBlock)failureBlock;

/// 手工领券
/// @param storeNo 消费门店
/// @param activityNo 活动编号
/// @param couponNo 门店优惠券
/// @param storeJoinNo 门店参与编号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)giveCouponWithActivityNo:(NSString *)activityNo
                        couponNo:(NSString *)couponNo
                     storeJoinNo:(NSString *)storeJoinNo
                         storeNo:(NSString *)storeNo
                         success:(void (^_Nullable)(WMOneClickItemResultModel *rspModel))successBlock
                         failure:(CMNetworkFailureBlock)failureBlock;
@end

NS_ASSUME_NONNULL_END
