//
//  PNBalancesInfoModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/3/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"
#import "SAMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNBalancesInfoModel : PNModel
/// 账单金额（数字）-应付款
@property (nonatomic, strong) SAMoneyModel *billAmount;
/// 最小金额
@property (nonatomic, strong) SAMoneyModel *minAmount;
/// 最大金额
@property (nonatomic, strong) SAMoneyModel *maxAmount;
/// 币种（字符串）-币种
@property (nonatomic, copy) NSString *currency;
/// 支付token-用于支付账单
@property (nonatomic, copy) NSString *paymentToken;
/// 手续费类型-手续费类型（层/百分比） (tier / percentage) (WING only)
@property (nonatomic, copy) NSString *feeType;
/// 总金额（数字）应付金额（含手续费）
@property (nonatomic, strong) SAMoneyModel *totalAmount;
/// 其他币种金额 【支付合计（换算为USD】
@property (nonatomic, strong) SAMoneyModel *otherCurrencyAmounts;
/// 用户支付大于账单金额的金额
@property (nonatomic, strong) SAMoneyModel *balance;
/// 手续费（数字）-bill24设置的支付服务手续费
@property (nonatomic, strong) SAMoneyModel *feeAmount;
/// 用户手续费占比-用户按比例承担手续费
@property (nonatomic, copy) NSString *customerFeePercentage;
/// 商家手续费占比-商家按比例承担手续费
@property (nonatomic, copy) NSString *supplierFeePercentage;
/// 费用类型（D=客户全部承担，C=商家全部承担，P=客户和商家按比例共同承担
@property (nonatomic, strong) PNChargeType chargeType;
/// 营销优惠
@property (nonatomic, strong) SAMoneyModel *marketingBreaks;
/// 账单编号
@property (nonatomic, copy) NSString *billNo;
/// 账单状态(INIT:初始化 10, PROCESSING:缴费中11,SUCCESS：缴费成功12, FAIL：缴费失败15;)
@property (nonatomic, assign) PNBillPaytStatus billState;
/// 客户电话
@property (nonatomic, copy) NSString *customerPhone;
/// 备注
@property (nonatomic, copy) NSString *notes;
/// billCode
@property (nonatomic, copy) NSString *billCode;
/// 分类名称
@property (nonatomic, copy) NSString *paymentCategoryName;
/// 分类
@property (nonatomic, assign) PNPaymentCategory paymentCategory;
/// 实际支付的币种
@property (nonatomic, copy) NSString *actualPaymentCurrency;
/// 创建时间
@property (nonatomic, copy) NSString *orderTime;
/// 产品类目
@property (nonatomic, copy) NSString *billItmeName;

@end

NS_ASSUME_NONNULL_END
