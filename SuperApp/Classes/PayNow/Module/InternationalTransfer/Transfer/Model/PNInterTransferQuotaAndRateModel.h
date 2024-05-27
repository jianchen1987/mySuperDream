//
//  PNInterTransferQuotaAndRateModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/6/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInterTransferAmountModel.h"
#import "PNModel.h"
#import "SAMoneyModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface PNInterTransferQuotaAndRateModel : PNModel
/// 转账单笔额度
@property (strong, nonatomic) SAMoneyModel *singleAmount;
/// 账户余额
@property (strong, nonatomic) SAMoneyModel *balance;
/// 汇率
@property (nonatomic, copy) NSString *rate;
/// 协议说明
@property (strong, nonatomic) NSArray<NSString *> *agreementsStr;
@end

NS_ASSUME_NONNULL_END
