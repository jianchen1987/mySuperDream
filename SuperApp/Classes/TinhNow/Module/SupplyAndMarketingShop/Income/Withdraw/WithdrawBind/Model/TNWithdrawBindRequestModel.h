//
//  TNWithdrawBindRequestModel.h
//  SuperApp
//
//  Created by xixi_wen on 2021/12/15.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAMoneyModel.h"
#import "TNModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNWithdrawBindRequestModel : TNModel
/// 提现金额
@property (strong, nonatomic) SAMoneyModel *amount; ///<  提现金额
///  提现方式     0：银行转账    1：第三方支付
@property (nonatomic, copy) TNPaymentWayCode settlementType;
///// 第三方支付    第三方支付方式 微信：WeChat    支付宝：Alipay    2：ViPay    3：WING    4：HUIONE
//@property (nonatomic, strong) NSString *payType;
///// 银行转账    银行名称：ABA
//@property (nonatomic, strong) NSString *bank;
//* 支付方名称
//   *  提现方式为 0：BANK(银行转账)    返回数据 0：ABA(ABA银行)
//   *  提现方式为 1：THIRD_PARTY_PAYMENT(第三方支付)    返回数据 0：WEIXIN(微信)  1：ALIPAY(支付宝)  2：VIPAY(ViPay)  3：WING(WING)  4：HUIONE(HUIONE)
@property (nonatomic, copy) NSString *paymentType; ///<  支付方式名称
/// 银行账号
@property (nonatomic, strong) NSString *account;
/// 开户名
@property (nonatomic, strong) NSString *accountHolder;
/// 操作员编号
@property (nonatomic, strong) NSString *operatorNo;
/// settlementType == bank   就是银行名称
@property (nonatomic, copy) NSString *companyName; ///<
@end

NS_ASSUME_NONNULL_END
