//
//  PayHDTradePaymentMethodModel.h
//  customer
//
//  Created by VanJay on 2019/5/16.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "PNEnum.h"
#import "SAModel.h"
#import "SAMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 支付方式模型
 */
@interface PayHDTradePaymentMethodModel : SAModel

@property (nonatomic, strong) SAMoneyModel *balance;             ///< 余额
@property (nonatomic, strong) SAMoneyModel *exchangeBalance;     ///< 兑换余额
@property (nonatomic, copy) NSString *desc;                      ///< 描述(余额)
@property (nonatomic, copy) NSString *msg;                       ///< 不可用信息，usable可用时为null(余额不足)
@property (nonatomic, copy) NSString *number;                    ///< 付款方式编号
@property (nonatomic, assign) int32_t sort;                      ///< 排序(0)
@property (nonatomic, copy) NSString *type;                      ///< 付款方式类型(VIPAY_WALLET_USD-美元余额;VIPAY_WALLET_KHR-卡瑞尔余额)
@property (nonatomic, assign) PNTradePaymentMethodType method;   ///< 付款方式类型
@property (nonatomic, assign) PNTradePaymentMethodStatus usable; ///< 可用状态(0-不可用,1-可用)

@end

NS_ASSUME_NONNULL_END
