//
//  PayHDCheckstandChoosePayMethodViewController.h
//  customer
//
//  Created by VanJay on 2019/5/16.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "PayHDCheckstandBaseViewController.h"
@class PayHDTradePaymentMethodModel, SAMoneyModel;

NS_ASSUME_NONNULL_BEGIN


@interface PayHDCheckstandChoosePayMethodViewController : PayHDCheckstandBaseViewController
@property (nonatomic, copy) NSArray<PayHDTradePaymentMethodModel *> *payMethodList; ///< 付款方式
@property (nonatomic, strong) SAMoneyModel *payAmount;                              ///< 订单金额
@end

NS_ASSUME_NONNULL_END
