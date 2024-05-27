//
//  PayHDTradeBuildOrderRspModel.h
//  customer
//
//  Created by VanJay on 2019/5/16.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDDealCommonInfoRowViewModel.h"
#import "HDJsonRspModel.h"
#import "PayHDTradeConfirmPaymentRspModel.h"
#import "SAMoneyModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 创建订单返回模型
 */
@interface PayHDTradeBuildOrderRspModel : HDJsonRspModel

@property (nonatomic, strong) SAMoneyModel *payAmt;                                         ///< 新接口 订单金额/兑换金额
@property (nonatomic, strong) SAMoneyModel *payeeAmount;                                    ///< 新接口 目标兑汇金额
@property (nonatomic, copy) NSString *amt;                                                  ///< 旧接口 金额
@property (nonatomic, copy) NSString *cy;                                                   ///< 旧接口 币种
@property (nonatomic, copy) NSString *headUrl;                                              ///< 收款方头像地址
@property (nonatomic, copy) NSString *payeeAmt;                                             ///< 目标兑汇金额/单位分
@property (nonatomic, copy) NSString *payeeCy;                                              ///< 目标兑汇的币种
@property (nonatomic, copy) NSString *payeeName;                                            ///< 收款方名称
@property (nonatomic, copy) NSString *payeeNo;                                              ///< 收款方
@property (nonatomic, copy) NSString *tradeNo;                                              ///< 交易订单号
@property (nonatomic, assign) PNTransType tradeType;                                        ///< 交易类型
@property (nonatomic, copy) NSString *payeeBankName;                                        //收款银行
@property (nonatomic, strong) NSMutableArray<HDDealCommonInfoRowViewModel *> *customerInfo; ///< 自定义信息栏
@property (nonatomic, assign) PNTradeSubTradeType subTradeType;
@property (nonatomic, copy) NSString *remark;
@property (copy, nonatomic) NSString *payeeStoreName;
@property (copy, nonatomic) NSString *payeeStoreLocation;

//新增一个额外的判断字段bizType
@property (nonatomic, copy) NSString *bizType;

/// 扫码到bakong 增加入参 qrData
@property (nonatomic, strong) NSString *qrData;

/// 商户入金
/// 入金账户
@property (nonatomic, copy) NSString *caseInAccount;
/// 入金账户人名称
@property (nonatomic, copy) NSString *receiver;
/// 入金类型[交易类型] - 入金
@property (nonatomic, copy) NSString *casetInType;
/// 入金金额
@property (nonatomic, copy) NSString *caseInAmount;

/// 提现到银行
/// 银行账号
@property (nonatomic, copy) NSString *accountNumber;
@property (nonatomic, copy) NSString *accountName;
/// 银行名称
@property (nonatomic, copy) NSString *bankName;
/// 银行code
@property (nonatomic, copy) NSString *participantCode;

@property (nonatomic, copy) NSString *inputVCTitle;
@property (nonatomic, copy) NSString *tipsStr;
@property (nonatomic, copy) NSString *payWay;

@property (nonatomic, strong) PayHDTradeConfirmPaymentRspModel *confirmRspMode;

+ (instancetype)modelWithOrderAmount:(SAMoneyModel *)orderAmt tradeNo:(NSString *)tradeNo;
- (instancetype)initWithOrderAmount:(SAMoneyModel *)orderAmt tradeNo:(NSString *)tradeNo;
@end

NS_ASSUME_NONNULL_END
