//
//  PNInterTransferViewModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/6/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInterTransferConfirmInfoModel.h"
#import "PNInterTransferPayerInfoModel.h"
#import "PNInterTransferQuotaAndRateModel.h"
#import "PNInterTransferRateFeeModel.h"
#import "PNTransferFormConfig.h"
#import "PNViewModel.h"
@class PNInterTransferReciverModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNInterTransferViewModel : PNViewModel
/// 国际转账开通数据源
@property (strong, nonatomic) NSMutableArray<PNTransferFormConfig *> *transOpenDataArr;
/// 国际转账金额数据源
@property (strong, nonatomic) NSMutableArray<HDTableViewSectionModel *> *transferAmountDataArr;
/// 国际转账付款人信息数据源
@property (strong, nonatomic) NSMutableArray<HDTableViewSectionModel *> *payerInfoDataArr;
/// 国际转账确认信息数据源
@property (strong, nonatomic) NSMutableArray<HDTableViewSectionModel *> *transConfirmDataArr;

/// 开通页面刷新数据
@property (nonatomic, assign) BOOL openVcRefrehData;
/// 预计兑换到账金额 刷新
@property (nonatomic, assign) BOOL transExchangeAmountRrfreshData;
/// 手续费 刷新
@property (nonatomic, assign) BOOL chargeRrfreshData;
/// 转账金额页面刷新数据
@property (nonatomic, assign) BOOL transAmountVcRefrehData;
/// 付款人页面刷新数据
@property (nonatomic, assign) BOOL payerInfoVcRefrehData;
/// 请求接口获取到手续费 刷新
@property (nonatomic, assign) BOOL getExchangeRateRefreshData;

/// 转账源金额
@property (nonatomic, copy) NSString *sourceAmount;
/// 兑换金额
@property (nonatomic, copy) NSString *exchangeAmount;
/// 手续费
@property (nonatomic, copy) NSString *serviceCharge;
/// 资金来源ID
@property (nonatomic, copy) NSString *sourceId;
/// 资金来源名称
@property (nonatomic, copy) NSString *sourceName;
/// 其他来源 选取其他时必输项
@property (nonatomic, copy) NSString *otherSourceOfFund;

/// 转账目的ID
@property (nonatomic, copy) NSString *purposeId;
/// 转账目的名称
@property (nonatomic, copy) NSString *purposeName;
/// 其它转账目的
@property (nonatomic, copy) NSString *otherPurposeRemittance;

/// thuns  转账汇率数据
@property (strong, nonatomic) PNInterTransferRateFeeModel *feeModel;
/// 用户转账额度以及汇率数据源
@property (strong, nonatomic) PNInterTransferQuotaAndRateModel *quotaAndRateModel;
/// 收款人数据
@property (strong, nonatomic) PNInterTransferReciverModel *reciverModel;
/// 付款人数据
@property (strong, nonatomic) PNInterTransferPayerInfoModel *payerInfoModel;
/// 国际转账确认模型
@property (strong, nonatomic) PNInterTransferConfirmInfoModel *confirmModel;
///是否已经同意条款
@property (nonatomic, assign) BOOL agreementCoolcashTerms;

/// 转账金额下一步按钮是否可点击
@property (nonatomic, assign) BOOL amountContinueBtnEnabled;
/// 付款人信息下一步按钮是否可点击
@property (nonatomic, assign) BOOL payerContinueBtnEnabled;

/// 邀请码
@property (nonatomic, copy) NSString *inviteCode;

@property (nonatomic, assign) PNInterTransferThunesChannel channel;

/// 初始化转账开通页面数据
- (void)initTransferOpenData;
/// 初始化转账金额页面数据
- (void)initTransferAmountData;
- (void)initPayerInfoData;
- (void)initTransferConfirmData;

//检验付款人按钮是否可以点击
- (void)checkPayerContinueBtnEabled;

/// 获取转账费率及手续费
- (void)queryRateFeeAndServiceChargeCompletion:(void (^)(void))completion;

/// 开通国际转账
- (void)openInterTransferAccountCompletion:(void (^)(void))completion;

/// 查询额度和汇率
- (void)queryQuotaAndExchangeRateNeedLoading:(BOOL)needLoading completion:(void (^)(BOOL isSuccess))completion;

/// 查询付款人信息
- (void)queryPayerInfoCompletion:(void (^)(BOOL isSuccess))completion;

/// 反洗钱校验并下单
- (void)amlAnalyzeVerificationAndCreateOrderCompletion:(void (^)(BOOL isSuccess))completion;

/// 选择收款人信息
- (void)chooseReciverInfo;

/// 是否是首单需要输入邀请码
- (void)checkNeedInviateCode:(void (^)(BOOL isSuccess))completion;

/// 检查是否绑定了推广专员
- (void)checkIsBind;

@end

NS_ASSUME_NONNULL_END
