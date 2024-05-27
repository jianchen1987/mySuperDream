//
//  PNBillPayInfoModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/3/31.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"
#import "SAMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNBillPayInfoModel : PNModel
/// 账单编号
@property (nonatomic, copy) NSString *billNo;
/// 说明文本
@property (nonatomic, copy) NSString *text;
/// 账单金额
@property (nonatomic, strong) SAMoneyModel *billAmount;
/// 代缴费用
@property (nonatomic, strong) SAMoneyModel *feeAmount;
/// 支付金额
@property (nonatomic, strong) SAMoneyModel *totalAmount;
/// 营销优惠
@property (nonatomic, strong) SAMoneyModel *marketingBreaks;
///
@property (nonatomic, strong) SAMoneyModel *otherCurrencyAmounts;
/// 账单状态(INIT:初始化 10, PROCESSING:缴费中11,SUCCESS：缴费成功12, FAIL：缴费失败15;)
@property (nonatomic, assign) PNBillPaytStatus billState;

///< 支付营销减免
@property (nonatomic, strong) SAMoneyModel *payDiscountAmount;
///< 实付金额
@property (nonatomic, strong) SAMoneyModel *payActualPayAmount;
/// 外部流水号
@property (nonatomic, copy) NSString *refNo;
/// 娱乐缴费卡密
@property (nonatomic, copy) NSString *billCustomerName;
/// 娱乐缴费组别 10为pinBase 11为pinLess
@property (nonatomic, assign) NSInteger group;
@end

NS_ASSUME_NONNULL_END
