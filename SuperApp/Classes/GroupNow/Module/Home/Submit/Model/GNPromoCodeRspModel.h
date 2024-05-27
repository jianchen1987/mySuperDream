//
//  GNPromoCodeRspModel.h
//  SuperApp
//
//  Created by wmz on 2022/5/5.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNModel.h"
#import "SAMoneyModel.h"
#import "WMOrderRelatedEnum.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNPromoCodeRspModel : GNModel
/// 优惠金额
@property (nonatomic, strong) SAMoneyModel *discountAmount;
/// 平台分担金额
@property (nonatomic, strong) SAMoneyModel *platformAmount;
/// 优惠号
@property (nonatomic, copy) NSString *activityNo;
/// 促销码
@property (nonatomic, copy) NSString *promotionCode;
/// 活动类型
@property (nonatomic, assign) WMStorePromotionMarketingType marketingType;

@end

NS_ASSUME_NONNULL_END
