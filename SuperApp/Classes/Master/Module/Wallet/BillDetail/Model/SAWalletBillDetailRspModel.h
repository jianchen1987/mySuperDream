//
//  SAWalletBillDetailRspModel.h
//  SuperApp
//
//  Created by VanJay on 2020/8/20.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAMoneyModel.h"
#import "SARspModel.h"
#import "SAWalletEnum.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAWalletBillDetailRspModel : SARspModel
/// 交易号
@property (nonatomic, copy) NSString *tradeNo;
/// 订单金额
@property (nonatomic, strong) SAMoneyModel *orderAmt;
/// 交易类型(10-消费,14-充值,15-退款)
@property (nonatomic, assign) HDWalletTransType tradeType;
/// 完成时间（时间戳）
@property (nonatomic, copy) NSString *finishTime;
/// 收入/支出
@property (nonatomic, copy) NSString *incomeFlag;
/// 支付方式
@property (nonatomic, assign) HDWalletPaymethod payWay;
@end

NS_ASSUME_NONNULL_END
