//
//  PNPaymentComfirmRspModel.h
//  SuperApp
//
//  Created by xixi_wen on 2023/2/7.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNEnumModel.h"
#import "PNModel.h"
#import "SAMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNPaymentComfirmRspModel : PNModel
/// 钱包usd余额
@property (nonatomic, strong) SAMoneyModel *usdBalance;
/// 钱包khr余额
@property (nonatomic, strong) SAMoneyModel *khrBalance;
/// 需要汇兑的部分(红色括号内的)
@property (nonatomic, strong) SAMoneyModel *exchangeAmount;
/// 账单的支付币种
@property (nonatomic, strong) PNEnumModel *currency;
/// KHR账户
@property (nonatomic, strong) SAMoneyModel *accountKhr;
/// USD账户
@property (nonatomic, strong) SAMoneyModel *accountUsd;
/// 钱包账号
@property (nonatomic, copy) NSString *walletAccount;
/// 交易金额
@property (nonatomic, strong) SAMoneyModel *tradeAmount;
/// 登陆账号
@property (nonatomic, copy) NSString *loginName;
/// 判断余额是否足够，不足返回False，足够返回True
@property (nonatomic, assign) BOOL balanceEnough;
/// 汇率
@property (nonatomic, copy) NSString *rate;
/// 默认支付方式
@property (nonatomic, strong) PNEnumModel *balanceTypeEnum;
/**
 paymentCurrency == null || paymentCurrency == 0  是订单币种
 paymentCurrency == 1 是汇兑支付
 paymentCurrency == 2 是组合支付
 */
@property (nonatomic, assign) NSInteger paymentCurrency;

/// 交易类型
@property (nonatomic, strong) PNEnumModel *transactionTypeEnum;
@end

NS_ASSUME_NONNULL_END
