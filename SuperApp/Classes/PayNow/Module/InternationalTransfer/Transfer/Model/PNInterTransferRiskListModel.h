//
//  PNInterTransferRiskListModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/7/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"
#import "SAMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNInterTransferRiskListModel : PNModel
/// 转出币种 - USD,KHR
@property (nonatomic, strong) PNCurrencyType payoutCurrency;
/// 转入币种 - USD,KHR
@property (nonatomic, strong) PNCurrencyType receiverCurrency;
/// 单笔限额
@property (nonatomic, strong) SAMoneyModel *singleLimit;
/// 单日限额
@property (nonatomic, strong) SAMoneyModel *singleDayLimit;
/// 月累计限额
@property (nonatomic, strong) SAMoneyModel *monthlyCumulativeLimit;
/// 年累计限额
@property (nonatomic, strong) SAMoneyModel *annualCumulativeLimit;
/// 日累计次数
@property (nonatomic, assign) NSInteger dailyCumulativeTimes;
/// 月累计次数
@property (nonatomic, assign) NSInteger monthlyCumulativeTimes;

/// 规则适用风控方  10 付款方 11 收款方
@property (nonatomic, assign) PNInterTransferDirection direction;
@end

NS_ASSUME_NONNULL_END
