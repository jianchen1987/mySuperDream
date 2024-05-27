//
//  PNCreateAggregateOrderRspModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/5/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"
#import "SAMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNCreateAggregateOrderRspModel : PNModel
/// 下单后返回的聚合订单号
@property (nonatomic, strong) NSString *aggregateOrderNo;
/// 下单后返回的支付单号
@property (nonatomic, strong) NSString *outPayOrderNo;
/// 账单编号
@property (nonatomic, strong) NSString *billNo;
/// 说明文本
@property (nonatomic, strong) NSString *text;
/// 应付
@property (nonatomic, strong) SAMoneyModel *totalPayableAmount;
/// 账单金额
@property (nonatomic, strong) SAMoneyModel *billAmount;
/// 代缴费用
@property (nonatomic, strong) SAMoneyModel *feeAmount;
/// 支付金额
@property (nonatomic, strong) SAMoneyModel *totalAmount;
/// 账单状态
@property (nonatomic, assign) PNBillPaytStatus status;
@end

NS_ASSUME_NONNULL_END
