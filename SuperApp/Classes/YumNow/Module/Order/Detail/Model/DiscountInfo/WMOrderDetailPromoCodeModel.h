//
//  WMOrderDetailPromoCodeModel.h
//  SuperApp
//
//  Created by Chaos on 2020/12/24.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"
#import "SAMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderDetailPromoCodeModel : WMModel

/// 优惠金额
@property (nonatomic, strong) SAMoneyModel *discountAmt;
/// 促销码ID
@property (nonatomic, copy) NSString *promotionId;
/// 促销码
@property (nonatomic, copy) NSString *promotionCode;
/// 活动类型
@property (nonatomic, assign) WMStorePromotionMarketingType marketingType;

@end

NS_ASSUME_NONNULL_END
