//
//  WMOrderDetailPromotionModel.h
//  SuperApp
//
//  Created by VanJay on 2020/5/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"
#import "WMPromotionReductionRule.h"

NS_ASSUME_NONNULL_BEGIN

/// 订单详情活动优惠
@interface WMOrderDetailPromotionModel : WMModel
/// 优惠金额
@property (nonatomic, strong) SAMoneyModel *discountAmt;
/// 折扣比例
@property (nonatomic, strong) NSNumber *discountRatio;
/// 折扣描述
@property (nonatomic, copy, readonly) NSString *discountRadioStr;
/// 活动创建时间
@property (nonatomic, copy) NSString *createTime;
/// 活动名称
@property (nonatomic, copy) NSString *activityName;
/// 阶梯满减规则
@property (nonatomic, copy) NSArray<WMPromotionReductionRule *> *fullReductionRules;
/// 当前规则
@property (nonatomic, strong) WMPromotionReductionRule *triggerRule;
/// 折扣
@property (nonatomic, strong) NSNumber *proportion;
/// 活动终止日期
@property (nonatomic, copy) NSString *expireDate;
/// 活动ID
@property (nonatomic, copy) NSString *activityNo;
/// 活动主体类型
@property (nonatomic, assign) WMPromotionSubjectType activitySubjectType;
/// 活动起始时间
@property (nonatomic, copy) NSString *effectiveDate;
/// 营销优惠类型：11：折扣 18：满减活动 19：免配送费
@property (nonatomic, assign) WMStorePromotionMarketingType marketingType;
/// 优惠描述
@property (nonatomic, copy, readonly) NSString *promotionDesc;

@end

NS_ASSUME_NONNULL_END
