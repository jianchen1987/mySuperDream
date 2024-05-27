//
//  PayHDTradeCreatePaymentRspModel.h
//  customer
//
//  Created by VanJay on 2019/5/16.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDJsonRspModel.h"
//#import "SAMoneyModel.h"
#import "PayHDTradeAmountModel.h"
#import "PayHDTradePaymentMethodModel.h"
#import "PayHDTradePreferentialModel.h"
NS_ASSUME_NONNULL_BEGIN

/**
 下单返回模型
 */
@interface PayHDTradeCreatePaymentRspModel : HDJsonRspModel

@property (nonatomic, strong) NSNumber *exchangeRate;                            ///< 汇率
@property (nonatomic, strong) SAMoneyModel *orderAmt;                            ///< 下单金额
@property (nonatomic, strong) SAMoneyModel *payAmt;                              ///< 支付金额/单位分
@property (nonatomic, strong) SAMoneyModel *payeeAmt;                            ///< 兑换金额/单位分
@property (nonatomic, strong) SAMoneyModel *userFeeAmt;                          ///< 用户手续费
@property (nonatomic, copy) NSString *payeeSymbol;                               ///< 收款币种符号(转账/汇兑)
@property (nonatomic, copy) NSArray<PayHDTradePreferentialModel *> *couponList;  ///< 优惠信息
@property (nonatomic, copy) NSArray<PayHDTradePaymentMethodModel *> *methodList; ///< 支付方式
@property (nonatomic, copy) NSString *tradeNo;                                   ///< 交易订单号
@property (nonatomic, assign) PNTransType tradeType;                             ///< 交易类型
@property (nonatomic, assign) PNTradeSubTradeType subTradeType;                  ///< 二级交易类型 (10:手机充值,11:立返,12:网络和电视)

@property (nonatomic, strong) PayHDTradeAmountModel *orderFeeAmt; ///< 订单手续费

@property (nonatomic, strong) PayHDTradeAmountModel *discountFeeAmt; /// 减免手续费

@end

NS_ASSUME_NONNULL_END
