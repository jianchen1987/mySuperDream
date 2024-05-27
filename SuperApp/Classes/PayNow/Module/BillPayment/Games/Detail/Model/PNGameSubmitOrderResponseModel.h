//
//  PNGameSubmitOrderResponseModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/12/26.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"
#import "SAMoneyModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface PNGameSubmitOrderResponseModel : PNModel
///账单编号 billNo
@property (nonatomic, copy) NSString *billNo;
///
@property (nonatomic, copy) NSString *billCode;
///
@property (nonatomic, copy) NSString *pinCode;
/// 外部流水号
@property (nonatomic, copy) NSString *refNo;
///手续费
@property (nonatomic, strong) SAMoneyModel *fee;
///应付
@property (nonatomic, strong) SAMoneyModel *totalPayableAmount;
///账单金额（不含手续费）
@property (nonatomic, strong) SAMoneyModel *billAmount;
///中台聚合订单号
@property (nonatomic, copy) NSString *aggregateOrderNo;
///钱包订单号
@property (nonatomic, copy) NSString *tradeNo;
@end

NS_ASSUME_NONNULL_END
