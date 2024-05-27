//
//  TNOrderDetailsPaymentInfoModel.h
//  SuperApp
//
//  Created by seeu on 2020/7/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAMoneyModel.h"
#import "TNCodingModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNOrderDetailsPaymentInfoModel : TNCodingModel
/// 支付i
@property (nonatomic, copy) NSString *paymentId;
/// 支付方式名
@property (nonatomic, copy) NSString *paymentMethodName;
/// 支付类型
@property (nonatomic, copy) NSString *paymentMethodType;
/// 金额
@property (nonatomic, strong) SAMoneyModel *amount;
/// 支付日期
@property (nonatomic, assign) NSTimeInterval paidDate;
/// 手续费
@property (nonatomic, strong) SAMoneyModel *fee;
/// 支付信息
@property (nonatomic, strong) TNPaymentMethod method;
@end

NS_ASSUME_NONNULL_END
