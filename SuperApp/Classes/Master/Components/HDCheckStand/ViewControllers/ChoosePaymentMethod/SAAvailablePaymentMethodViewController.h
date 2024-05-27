//
//  SAAvailablePaymentMethodViewController.h
//  SuperApp
//
//  Created by seeu on 2022/5/12.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "HDCheckStandBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class HDPaymentMethodType;
@class SAMoneyModel;


@interface SAAvailablePaymentMethodViewController : HDCheckStandBaseViewController

/// 收银台调用，其他方式不能用
/// @param buildModel 收银台构建模型
+ (instancetype)checkStandWithTradeBuildModel:(HDTradeBuildOrderModel *)buildModel;

/// 选择支付方式回调
@property (nonatomic, copy) void (^choosePaymentMethodHandler)(HDPaymentMethodType *paymentMethod, SAMoneyModel *_Nullable paymentDiscountAmount);

@end

NS_ASSUME_NONNULL_END
