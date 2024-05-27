//
//  SAWalletBalanceModel.h
//  SuperApp
//
//  Created by VanJay on 2020/8/17.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "PNEnum.h"
#import "SAModel.h"
#import "SAMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAWalletBalanceModel : SAModel
/// 余额 [原来balance字段是账户余额；包含不可提现账户余额：balance = cashBalance + nonCashBalance]
@property (nonatomic, strong) SAMoneyModel *balance;
/// 币种
@property (nonatomic, copy) SACurrencyType currency;
/// 不可提现余额；
@property (nonatomic, strong) SAMoneyModel *nonCashBalance;
/// 可提现余额
@property (nonatomic, strong) SAMoneyModel *cashBalance;
/// 营销信息,会有多个营销活动
@property (nonatomic, strong) NSArray *marketinginfoList;
/// 是否开通钱包
@property (nonatomic) BOOL walletCreated;
/// 钱包账户状态
@property (nonatomic, assign) PNWAlletAccountStatus accountStatus;
/// 钱包账户等级
@property (nonatomic, assign) PNAccountLevelUpgradeStatus accountLevel;
/// khr账户余额
@property (nonatomic, strong) SAMoneyModel *khrBalance;
/// khr汇兑成usd的金额
@property (nonatomic, strong) SAMoneyModel *exchangedBalance;
/// 汇兑后总额
@property (nonatomic, strong) SAMoneyModel *amountBalance;

@end

NS_ASSUME_NONNULL_END
