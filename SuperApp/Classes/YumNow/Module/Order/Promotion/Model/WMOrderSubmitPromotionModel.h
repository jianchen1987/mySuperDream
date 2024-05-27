//
//  WMOrderSubmitPromotionModel.h
//  SuperApp
//
//  Created by VanJay on 2020/5/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAMoneyModel.h"
#import "WMModel.h"
#import "WMPromotionReductionRule.h"
#import "WMStoreLadderRuleModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 优惠活动
@interface WMOrderSubmitPromotionModel : WMModel
/// 优惠金额
@property (nonatomic, strong) SAMoneyModel *discountAmount;
/// 优惠号
@property (nonatomic, copy) NSString *activityNo;
/// 优惠类型
@property (nonatomic, assign) WMStorePromotionMarketingType marketingType;
/// 折扣比例(折扣类型(活动和优惠券)要用)
@property (nonatomic, strong) NSNumber *discountRatio;
/// 折扣描述
@property (nonatomic, copy, readonly) NSString *discountRadioStr;
/// 周几优惠
@property (nonatomic, copy) NSString *openingWeekdays;
/// 周几哪个时间端优惠
@property (nonatomic, copy) NSString *openingTimes;
/// 展示优惠
@property (nonatomic, copy) NSString *promotionDesc;
/// 满减阶梯
@property (nonatomic, copy) NSArray<WMStoreLadderRuleModel *> *ladderRules;
/// 在使用中的满减优惠梯度模型
@property (nonatomic, strong, readonly) WMStoreLadderRuleModel *inUseLadderRuleModel;
/// 首单优惠
@property (nonatomic, strong) SAMoneyModel *firstOrderReductionAmount;

@end

NS_ASSUME_NONNULL_END
