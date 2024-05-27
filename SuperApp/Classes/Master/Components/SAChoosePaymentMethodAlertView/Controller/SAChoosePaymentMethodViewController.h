//
//  SAChoosePaymentMethodViewController.h
//  SuperApp
//
//  Created by seeu on 2022/6/2.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class HDPaymentMethodType;
@class SAMoneyModel;


@interface SAChoosePaymentMethodViewController : SAViewController

/// 选择支付方式回调
@property (nonatomic, copy) void (^choosedPaymentMethodHandler)(HDPaymentMethodType *paymentMethod, SAMoneyModel *_Nullable paymentDiscountAmount);

@end

NS_ASSUME_NONNULL_END
