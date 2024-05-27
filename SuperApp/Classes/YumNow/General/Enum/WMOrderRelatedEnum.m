//
//  SAOrderRelatedEnum.m
//  SuperApp
//
//  Created by VanJay on 2020/4/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderRelatedEnum.h"

WMOrderAutoAcceptConfigType const WMOrderAutoAcceptConfigTypeNone = @"NON_AUTO_CONFIRM ";
WMOrderAutoAcceptConfigType const WMOrderAutoAcceptConfigTypeAuto = @"AUTO_CONFIRM";

WMOrderDeliveryMode const WMOrderDeliveryModeMerchant = @"PLATFORM_DELIVERY";
WMOrderDeliveryMode const WMOrderDeliveryModePlatform = @"MERCHANT_DELIVERY";

/// 下单异常场景
SAResponseType const WMOrderCheckFailureReasonStoreClosed = @"T0406";         ///< 门店休息
SAResponseType const WMOrderCheckFailureReasonStoreStopped = @"T0501";        ///< 门店停业/停用
SAResponseType const WMOrderCheckFailureReasonBeyondDeliveryScope = @"TO024"; ///< 超出配送范围
SAResponseType const WMOrderCheckFailureReasonDeliveryFeeChanged = @"MK4026"; ///< 配送费活动变更
SAResponseType const WMOrderCheckFailureReasonPromotionEnded = @"MK4026";     ///< 活动已结束或停用

SAResponseType const WMOrderCheckFailureReasonProductOutOfStock = @"TO012";   ///< 商品库存不足
SAResponseType const WMOrderCheckFailureReasonProductInfoChanged = @"ME1050"; ///< 商品信息变更
SAResponseType const WMOrderCheckFailureReasonHaveRemovedProduct = @"TO011";  ///< 包含失效商品
SAResponseType const WMOrderCheckFailureReasonProductAmountChanged = @"";     ///< 商品金额变更

/// 加购失败原因
// SAResponseType const WMAddProductFailureReasonInfoChanged = @"";                       ///< 商品属性、规格变更
// SAResponseType const WMAddProductFailureReasonRemoved = @"";                           ///< 商品失效
