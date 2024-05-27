//
//  HDQueryPaymentMethodRspModel.h
//  SuperApp
//
//  Created by VanJay on 2020/8/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDOnlinePaymentToolsModel.h"
#import "HDTradePreferentialModel.h"
#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface HDQueryPaymentMethodRspModel : SAModel
/// 优惠信息
@property (nonatomic, copy) NSArray<HDTradePreferentialModel *> *marketings;
/// 支付方式 11-支付宝支付;12-微信支付;10-余额支付;14-信用卡支付;15-ABA钱包
@property (nonatomic, copy) NSArray<HDOnlinePaymentToolsModel *> *payWays;
/// 订单号
@property (nonatomic, copy) NSString *tradeNo;
/// 交易金额
@property (nonatomic, strong) SAMoneyModel *amt;
@end

NS_ASSUME_NONNULL_END
