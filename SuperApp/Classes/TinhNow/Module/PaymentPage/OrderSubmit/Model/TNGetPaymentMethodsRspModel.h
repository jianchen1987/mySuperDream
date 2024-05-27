//
//  TNGetPaymentMethodsRspModel.h
//  SuperApp
//
//  Created by seeu on 2020/7/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNRspModel.h"

NS_ASSUME_NONNULL_BEGIN
@class TNPaymentMethodModel;


@interface TNGetPaymentMethodsRspModel : TNRspModel

/// 支付方式列表
@property (nonatomic, strong) NSArray<TNPaymentMethodModel *> *paymentMethods;

@end

NS_ASSUME_NONNULL_END
