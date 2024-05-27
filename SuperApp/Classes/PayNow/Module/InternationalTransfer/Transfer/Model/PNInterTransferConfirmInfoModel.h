//
//  PNInterTransferConfirmInfoModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/6/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"
#import "SAMoneyModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface PNInterTransferConfirmInfoModel : PNModel
/// 订单id
@property (nonatomic, copy) NSString *orderNo;
/// 付款人账号 My Account（我的账号）
@property (nonatomic, copy) NSString *account;
/// 交易日期
@property (nonatomic, copy) NSString *translationDate;
/// 付款人出生国家
@property (nonatomic, copy) NSString *senderPayoutCountryOfBirth;
/// 银行卡账号
@property (nonatomic, copy) NSString *bankAccountNumber;
/// 银行名称
@property (nonatomic, copy) NSString *bankName;
/// 证件类型
@property (nonatomic, copy) NSString *idType;
/// 证件号
@property (nonatomic, copy) NSString *idCode;
/// 手机号
@property (nonatomic, copy) NSString *mobile;
/// 名
@property (nonatomic, copy) NSString *firstName;
/// 中间名
@property (nonatomic, copy) NSString *middleName;
/// 姓
@property (nonatomic, copy) NSString *lastName;
/// 全名
@property (nonatomic, copy) NSString *fullName;
/// 国籍
@property (nonatomic, copy) NSString *nationality;
/// 省
@property (nonatomic, copy) NSString *province;
/// 城市
@property (nonatomic, copy) NSString *city;
/// 地址
@property (nonatomic, copy) NSString *address;
/// 邮箱
@property (nonatomic, copy) NSString *email;
/// 转账目的
@property (nonatomic, copy) NSString *transferReason;
/// 资金来源
@property (nonatomic, copy) NSString *sourceOfFund;
/// 与收款人关系
@property (nonatomic, copy) NSString *relation;
/// 汇率
@property (nonatomic, copy) NSString *exchangeRate;
/// 支付金额
@property (strong, nonatomic) SAMoneyModel *payoutAmount;
/// 手续费
@property (strong, nonatomic) SAMoneyModel *serviceCharge;
/// 营销减免
@property (strong, nonatomic) SAMoneyModel *promotion;
/// 收款金额  收款金额：转账金额* 费率
@property (strong, nonatomic) SAMoneyModel *receiverAmount;
/// 转账支付金额 =转账金额+手续费-营销减免
@property (strong, nonatomic) SAMoneyModel *totalPayoutAmount;

/// 状态
@property (nonatomic, assign) PNInterTransferOrderStatus status;
/// 失败或者拒绝原因
@property (nonatomic, copy) NSString *reason;
/// 邀请码
@property (nonatomic, copy) NSString *inviteCode;
@end

NS_ASSUME_NONNULL_END
