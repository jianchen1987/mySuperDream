//
//  PNApartmentComfirmRspModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/12/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"
#import "SAMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNApartmentComfirmRspModel : PNModel
/// 金额
@property (nonatomic, strong) SAMoneyModel *amount;
/// 缴费金额
@property (nonatomic, strong) SAMoneyModel *payTheFees;
/// 汇率
@property (nonatomic, strong) NSString *rate;
/// 下单后返回的聚合订单号
@property (nonatomic, copy) NSString *aggregateOrderNo;
/// 下单后返回的支付单号
@property (nonatomic, copy) NSString *outPayOrderNo;
/// 应付
@property (nonatomic, strong) SAMoneyModel *totalPayableAmount;
/// 实付
@property (nonatomic, strong) SAMoneyModel *actualPayAmount;
///
@property (nonatomic, strong) SAMoneyModel *moneyAmount;

@end

NS_ASSUME_NONNULL_END
