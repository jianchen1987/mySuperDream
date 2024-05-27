//
//  PNBalanceAndExchangeModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/12/23.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"
#import "SAMoneyModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface PNBalanceAndExchangeModel : PNModel
/// 美金余额
@property (strong, nonatomic) SAMoneyModel *usdBalance;
/// 瑞尔余额
@property (strong, nonatomic) SAMoneyModel *khrBalance;
/// 汇率
@property (nonatomic, copy) NSString *exchange;
/// 是否可以汇兑 为true的话需要前端弹窗询问用户需不需要汇兑
@property (nonatomic, assign) BOOL canExchange;
@end

NS_ASSUME_NONNULL_END
