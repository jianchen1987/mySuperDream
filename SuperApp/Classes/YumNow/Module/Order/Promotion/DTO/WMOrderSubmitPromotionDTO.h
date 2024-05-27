//
//  WMOrderSubmitPromotionDTO.h
//  SuperApp
//
//  Created by VanJay on 2020/5/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"

@class WMOrderSubmitPromotionModel;

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderSubmitPromotionDTO : WMModel

/// 营销查询可用优惠活动
/// @param businessType 业务线
/// @param storeNo 消费门店
/// @param currencyType 币种
/// @param amount 订单金额
/// @param deliveryAmt 配送费
/// @param merchantNo 商户ID
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)getPromotionListWithBusinessType:(SAMarketingBusinessType)businessType
                                               storeNo:(NSString *)storeNo
                                          currencyType:(NSString *)currencyType
                                                amount:(NSString *)amount
                                           deliveryAmt:(NSString *)deliveryAmt
                                            merchantNo:(NSString *)merchantNo
                                            packingAmt:(NSString *)packingAmt
                                 specialMarketingTypes:(NSArray<NSNumber *> *)specialMarketingTypes
                                               success:(void (^_Nullable)(NSArray<WMOrderSubmitPromotionModel *> *_Nullable list))successBlock
                                               failure:(CMNetworkFailureBlock _Nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END
