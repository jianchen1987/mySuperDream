//
//  PNGuarateenBuildOrderPaymentRspModel.h
//  SuperApp
//
//  Created by xixi_wen on 2023/1/11.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNModel.h"
#import "SAMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNGuarateenBuildOrderPaymentRspModel : PNModel
/// 天数
@property (nonatomic, assign) NSInteger day;
@property (nonatomic, copy) NSString *guarateenTipsStr;
/// 交易金额
@property (nonatomic, copy) NSString *tradeAmt;
@property (nonatomic, strong) SAMoneyModel *tradeAmtMoneyModel;
/// 交易金额币种
@property (nonatomic, copy) NSString *tradeCy;
/// 付款金额(一定是美金)
@property (nonatomic, copy) NSString *payAmt;
@property (nonatomic, strong) SAMoneyModel *payAmtMoneyModel;
/// 付款金额(一定是美金)
@property (nonatomic, copy) NSString *payAmtCy;
/// 服务费
@property (nonatomic, copy) NSString *freeAmt;
@property (nonatomic, strong) SAMoneyModel *freeAmtMoneyModel;
/// 买入价格
@property (nonatomic, copy) NSString *khrBuyUsd;
/// 卖出价格
@property (nonatomic, copy) NSString *usdBuyKhr;

@property (nonatomic, copy) NSString *orderNo;
@end

NS_ASSUME_NONNULL_END
