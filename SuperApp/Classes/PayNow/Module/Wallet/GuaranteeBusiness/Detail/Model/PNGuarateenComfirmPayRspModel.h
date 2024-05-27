//
//  PNGuarateenComfirmPayRspModel.h
//  SuperApp
//
//  Created by xixi_wen on 2023/1/11.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNModel.h"
#import "SAMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNGuarateenComfirmPayRspModel : PNModel
/// 金额
@property (nonatomic, copy) NSString *amount;
/// 币种
@property (nonatomic, copy) NSString *curreny;
/// 汇率
@property (nonatomic, copy) NSString *rate;
/// 下单后返回的聚合订单号
@property (nonatomic, copy) NSString *aggregateOrderNo;
/// 下单后返回的支付单号
@property (nonatomic, copy) NSString *outPayOrderNo;
/// 应付
@property (nonatomic, strong) SAMoneyModel *totalPayableAmount;
/// 实付
@property (nonatomic, strong) SAMoneyModel *actualPayAmount;
@end

NS_ASSUME_NONNULL_END
