//
//  PNBillModifyAmountModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/3/23.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"
#import "SAMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNBillModifyAmountModel : PNModel
/// 账单金额 应付金额
@property (nonatomic, strong) SAMoneyModel *billAmount;
/// Bill24手续费 Bill24设置的服务费
@property (nonatomic, strong) SAMoneyModel *feeAmount;
/// 总金额 应付金额【含手续费】
@property (nonatomic, strong) SAMoneyModel *totalAmount;
/// 营销优惠
@property (nonatomic, strong) SAMoneyModel *marketingBreadks;

@property (nonatomic, copy) NSString *paymentToken;
/// 其他币种金额 【支付合计（换算为USD】
@property (nonatomic, strong) SAMoneyModel *otherCurrencyAmounts;
@end

NS_ASSUME_NONNULL_END
