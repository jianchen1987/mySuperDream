//
//  PNBillSupplierInfoModel.h
//  SuperApp
//
//  Created by xixi_wen on 2022/4/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"
#import "SAMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNBillSupplierInfoModel : PNModel
/// id
@property (nonatomic, strong) NSString *idStr;
/// logo
@property (nonatomic, strong) NSString *logo;
/// 收款商户编号
@property (nonatomic, strong) NSString *payeeMerNo;
/// 收款商户名称
@property (nonatomic, strong) NSString *payeeMerName;
@property (nonatomic, strong) NSString *payeeMerName_search;
/// 允许超额支付
@property (nonatomic, assign) BOOL allowExceedPayment;
/// 允许部分支付
@property (nonatomic, assign) BOOL allowPartialPayment;
/// 最大支付金额（USD）
@property (nonatomic, strong) SAMoneyModel *maxPaymentAmountUsd;
/// 最小支付金额（USD）
@property (nonatomic, strong) SAMoneyModel *minPaymentAmountUsd;
/// 最大支付金额（KHR）
@property (nonatomic, strong) SAMoneyModel *maxPaymentAmountKhr;
/// 最小支付金额（KHR）
@property (nonatomic, strong) SAMoneyModel *minPaymentAmountKhr;
/// 币种
@property (nonatomic, strong) NSString *currency;
/// 账单类型
@property (nonatomic, assign) PNPaymentCategory paymentCategory;
/// 账单结算周期
@property (nonatomic, strong) NSString *billSettlementCycle;
/// 手续费结算周期
@property (nonatomic, strong) NSString *feeSettlementCycle;
/// 对账文件发送方式
@property (nonatomic, strong) NSString *verifyBillFileSendWay;
/// 收款商户收费标准
@property (nonatomic, strong) NSString *payeeMerChargeStandard;
/// 手续费是否参与分配
@property (nonatomic, assign) BOOL feeInDistribution;
/// 手续费分配比例
@property (nonatomic, assign) CGFloat feeDistributionRatio;
/// 变更原因
@property (nonatomic, strong) NSString *changeReason;
/// 状态 0关闭 1开启
@property (nonatomic, assign) NSInteger status;
/// 临时数据是否已完善
@property (nonatomic, assign) BOOL completed;
/// API凭证 [UTILITY :10 Utility GENERAL_BILL :11 General Bill]
@property (nonatomic, strong) NSString *apiCredential;
/// 最低收费（USD）
@property (nonatomic, strong) SAMoneyModel *minFeeUsd;
/// 最高收费（USD）
@property (nonatomic, strong) SAMoneyModel *maxFeeUsd;
/// 最低收费（KHR）
@property (nonatomic, strong) SAMoneyModel *minFeeKhr;
/// 最高收费（KHR）
@property (nonatomic, strong) SAMoneyModel *maxFeeKhr;
/// 创建时间
@property (nonatomic, strong) NSString *createTime;
/// 修改时间
@property (nonatomic, strong) NSString *updateTime;
/// 删除状态
@property (nonatomic, assign) NSInteger delState;

@end

NS_ASSUME_NONNULL_END
