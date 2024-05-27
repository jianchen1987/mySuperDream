//
//  WMPromoCodeRspModel.h
//  SuperApp
//
//  Created by Chaos on 2020/12/24.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAMoneyModel.h"
#import "WMRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMPromoCodeRspModel : WMRspModel

/// 优惠金额
@property (nonatomic, strong) SAMoneyModel *discountAmount;
/// 优惠号
@property (nonatomic, copy) NSString *activityNo;
/// 促销码
@property (nonatomic, copy) NSString *promotionCode;
/// 活动类型
@property (nonatomic, assign) WMStorePromotionMarketingType marketingType;
/// 限制现金券
@property (nonatomic, assign) BOOL voucherCouponLimit;
/// 限制运费券
@property (nonatomic, assign) BOOL shippingCouponLimit;

@end

NS_ASSUME_NONNULL_END
