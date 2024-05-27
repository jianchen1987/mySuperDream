//
//  WMTopUpOrderDetailModel.h
//  SuperApp
//
//  Created by Chaos on 2020/6/24.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAModel.h"

@class SAMoneyModel;

NS_ASSUME_NONNULL_BEGIN


@interface SATopUpOrderDetailModel : SAModel

/// 交易状态
@property (nonatomic, copy) NSString *orderStatus;
/// 交易金额
@property (nonatomic, strong) SAMoneyModel *money;
/// 订单金额
@property (nonatomic, strong) SAMoneyModel *orderMoney;
/// 付款账号
@property (nonatomic, copy) NSString *payAccount;
/// 收款方
@property (nonatomic, copy) NSString *receiveAccount;
/// 账单类型
@property (nonatomic, copy) NSString *orderClassify;
/// 产品说明
@property (nonatomic, copy) NSString *goodInstruction;
/// 创建时间
@property (nonatomic, copy) NSString *createTime;
/// 订单号
@property (nonatomic, copy) NSString *topUpTime;

@end

NS_ASSUME_NONNULL_END
