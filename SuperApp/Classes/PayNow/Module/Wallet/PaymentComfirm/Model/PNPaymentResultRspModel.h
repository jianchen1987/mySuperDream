//
//  PNPaymentResultRspModel.h
//  SuperApp
//
//  Created by xixi_wen on 2023/2/8.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNModel.h"
#import "SAMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNPaymentResultRspModel : PNModel
/// 用户钱包余额usd
@property (nonatomic, strong) SAMoneyModel *usdBalance;
/// 用户钱包余额khr
@property (nonatomic, strong) SAMoneyModel *khrBalance;
/// 订单号
@property (nonatomic, copy) NSString *tradeNo;
///
@property (nonatomic, copy) NSString *merId;
///
@property (nonatomic, copy) NSString *merName;
/// 付款方userNo
@property (nonatomic, copy) NSString *usrNo;
/// 付款方用户手机号
@property (nonatomic, copy) NSString *usrMp;
/// 付款方账号
@property (nonatomic, copy) NSString *payerAcNo;
/// 付款账户
@property (nonatomic, copy) NSString *payerAccoun;
@property (nonatomic, copy) NSString *payerAccounString;
/// 交易总金额
@property (nonatomic, strong) SAMoneyModel *total;
/// 币种
@property (nonatomic, copy) PNCurrencyType currency;
/// 用户手续费
@property (nonatomic, strong) SAMoneyModel *serviceAmt;
/// 营销减免
@property (nonatomic, strong) SAMoneyModel *promotion;
/// 汇率
@property (nonatomic, strong) NSNumber *exchangeRate;
/// 收款方账号
@property (nonatomic, copy) NSString *payeeAcNo;
/// 收款方手机号
@property (nonatomic, copy) NSString *payeeUsrMp;
/// 收款用户名
@property (nonatomic, copy) NSString *payeeUserName;
/// 收款银行
@property (nonatomic, copy) NSString *payeeBank;
/// 创建时间
@property (nonatomic, copy) NSString *createTime;
/// 用户钱包
@property (nonatomic, copy) NSString *customerNo;
/// 订单状态
@property (nonatomic, assign) PNWalletBalanceOrderStatus status;
@property (nonatomic, copy) NSString *statusString;
/// 业务类型
@property (nonatomic, assign) NSInteger businessType;

@property (nonatomic, copy) NSString *subBizEntityString;
@property (nonatomic, copy) NSString *bizEntityString;

@property (nonatomic, copy) NSString *payeeCustomerNo;
@end

NS_ASSUME_NONNULL_END
