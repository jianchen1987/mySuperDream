//
//  SAPaymentActivityModel.h
//  SuperApp
//
//  Created by seeu on 2022/5/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "HDCheckStandEnum.h"
#import "SAModel.h"
#import "SAMoneyModel.h"
#import "SAPaymentActivityModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAPaymentToolsActivityModel : SAModel
///< 支付工具编号
@property (nonatomic, copy) NSString *payToolNo;
///< 支付工具名称
@property (nonatomic, copy) NSString *vipayCodeName;
///< 支付工具编码
@property (nonatomic, copy) HDCheckStandPaymentTools vipayCode;
///< 应付金额
@property (nonatomic, strong) SAMoneyModel *payableAmount;
///< 营销规则
@property (nonatomic, strong) NSArray<SAPaymentActivityModel *> *rule;

@end

NS_ASSUME_NONNULL_END
