//
//  SAQueryPaymentStateRspModel.h
//  SuperApp
//
//  Created by seeu on 2020/9/1.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAInternationalizationModel.h"
#import "SAMoneyModel.h"
#import "SARspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAQueryPaymentStateRspModel : SARspModel

/// 外部支付订单号  电商需要用到这个字段
@property (nonatomic, copy) NSString *outPayOrderNo;
/// 实付金额
@property (nonatomic, strong) SAMoneyModel *actualPayAmount;
/// 支付单号
@property (nonatomic, copy) NSString *payOrderNo;
/// 支付时间
//@property (nonatomic, assign) NSTimeInterval payTime;
/// 支付状态
@property (nonatomic, assign) SAPaymentState payState;
/// 支付方式
//@property (nonatomic, copy) NSString *paymentMethod;
/// 支付渠道
//@property (nonatomic, copy) NSString *payChannel;
/// 聚合单号
@property (nonatomic, copy) NSString *aggregateOrderNo;
/// 应付金额
//@property (nonatomic, strong) SAMoneyModel *payableAmount;

@end

NS_ASSUME_NONNULL_END
