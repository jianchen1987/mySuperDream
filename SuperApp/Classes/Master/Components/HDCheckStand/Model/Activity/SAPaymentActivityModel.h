//
//  SAPaymentActivityModel.h
//  SuperApp
//
//  Created by seeu on 2022/5/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "HDCheckStandEnum.h"
#import "SAEnumModel.h"
#import "SAModel.h"
#import "SAMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAPaymentActivityModel : SAModel
///< 规则NO
@property (nonatomic, copy) NSString *ruleNo;
///< 门槛金额
@property (nonatomic, strong) SAMoneyModel *thresholdAmt;
///< 试算id
@property (nonatomic, copy) NSString *trialId;
///< 活动标题
@property (nonatomic, copy) NSString *title;
///< 活动是否满足 10：满足 11：不满足
@property (nonatomic, assign) HDPaymentActivityState fulfill;
///< 减免金额
@property (nonatomic, strong) SAMoneyModel *discountAmt;
///< 过期时间
@property (nonatomic, copy) NSString *expireDate;
///< 生效时间
@property (nonatomic, copy) NSString *effectiveDate;
///< 活动号
@property (nonatomic, copy) NSString *activityNo;
///< 支付营销类型
@property (nonatomic, strong) SAEnumModel *marketingType;

///< 是否选中
@property (nonatomic, assign) BOOL selected;
/// 不可用原因
@property (nonatomic, copy) NSString *unavailableReason;

@end

NS_ASSUME_NONNULL_END
