//
//  WMPromotionReductionRule.h
//  SuperApp
//
//  Created by VanJay on 2020/5/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAMoneyModel.h"
#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 阶梯满减规则
@interface WMPromotionReductionRule : WMModel
/// 币种
@property (nonatomic, copy) SACurrencyType currencyType;
/// 满减规则编号 创建时为空,编辑时必填
@property (nonatomic, copy) NSString *laderRuleNo;
/// 优惠金额
@property (nonatomic, strong) SAMoneyModel *discountAmt;
/// 门槛金额
@property (nonatomic, strong) SAMoneyModel *thresholdAmt;
@end

NS_ASSUME_NONNULL_END
