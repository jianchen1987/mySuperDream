//
//  WalletAcountModel.h
//  SuperApp
//
//  Created by Quin on 2021/11/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNModel.h"
#import "SAMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNBalanceModel : PNModel
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, copy) NSString *centFactor;
@property (nonatomic, copy) NSString *rsa;
@property (nonatomic, copy) NSString *cent;
@property (nonatomic, copy) NSString *md5;
@end


@interface PNWalletAcountItemModel : PNModel
/**
 三个基本字段：
 cashBalance：可提现余额
 nonCashBalance： 不可提现余额
 frozenAmt：冻结金额

 三个派生字段：
 balance ： 可提现余额 + 不可提现余额
 availableBalanceForWithdraw ： (提现、转账)可用余额= 可提现余额 - 冻结金额
 availableBalanceForConsume：（消费）可用余额 = 可提现余额 + 不可提现余额 - 冻结金额
 */

@property (nonatomic, copy) NSString *currency;
/// 可提现余额
@property (nonatomic, strong) SAMoneyModel *cashBalance;
/// 不可提现金额
@property (nonatomic, strong) SAMoneyModel *nonCashBalance;
/// 冻结金额
@property (nonatomic, strong) SAMoneyModel *frozenAmt;
/// 余额 （可提现余额 + 不可提现余额）
@property (nonatomic, strong) SAMoneyModel *balance;
/// (提现、转账)可用余额
@property (nonatomic, strong) SAMoneyModel *availableBalanceForWithdraw;
/// （消费）可用余额
@property (nonatomic, strong) SAMoneyModel *availableBalanceForConsume;
@end


@interface PNWalletAcountModel : PNModel
@property (nonatomic, strong) PNWalletAcountItemModel *KHR;
@property (nonatomic, strong) PNWalletAcountItemModel *USD;
@end

NS_ASSUME_NONNULL_END
