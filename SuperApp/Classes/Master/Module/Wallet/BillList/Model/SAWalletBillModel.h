//
//  SAWalletBillModel.h
//  SuperApp
//
//  Created by VanJay on 2020/8/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAModel.h"
#import "SAMoneyModel.h"
#import "SAWalletEnum.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAWalletBillModelDetail : NSObject
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

#pragma mark - 绑定属性
/// 最后一个
@property (nonatomic, assign) BOOL isLast;
@end


@interface SAWalletBillModel : SAModel
/// 日期/年月
@property (nonatomic, copy) NSString *date;
/// 支出金额
@property (nonatomic, strong) SAMoneyModel *cashOutAmt;
/// 收入金额
@property (nonatomic, strong) SAMoneyModel *cashInAmt;
/// 明细
@property (nonatomic, copy) NSArray<SAWalletBillModelDetail *> *details;
@end

NS_ASSUME_NONNULL_END
