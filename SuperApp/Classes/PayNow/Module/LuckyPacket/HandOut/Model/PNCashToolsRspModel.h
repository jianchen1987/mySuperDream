//
//  PNCashToolsRspModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/12/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"
#import "SAMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNCashToolsMethodPaymentItemModel : PNModel
/// amount
@property (nonatomic, strong) NSNumber *amount;
/// 币种
@property (nonatomic, strong) NSString *currency;
/// 付款业务(1-EXC/2-PAY)
@property (nonatomic, assign) NSInteger biz;
/// 付款渠道(WALLET)
@property (nonatomic, copy) NSString *channel;
/// 汇率
@property (nonatomic, strong) NSNumber *rate;

@property (nonatomic, assign) NSInteger sort;

@end


@interface PNCashToolsRspModel : PNModel

@property (nonatomic, strong) SAMoneyModel *amt;

@property (nonatomic, copy) NSString *tradeNo;

@property (nonatomic, strong) NSArray<PNCashToolsMethodPaymentItemModel *> *methodPayment;
@end

NS_ASSUME_NONNULL_END
