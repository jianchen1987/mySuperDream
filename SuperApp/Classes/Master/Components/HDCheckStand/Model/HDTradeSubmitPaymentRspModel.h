//
//  HDTradeSubmitPaymentRspModel.h
//  SuperApp
//
//  Created by VanJay on 2019/5/16.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDCheckStandEnum.h"
#import "HDTradeSubmitPreferentialModel.h"
#import "SAMoneyModel.h"
#import "SARspModel.h"

NS_ASSUME_NONNULL_BEGIN

/**
 支付返回模型
 */
@interface HDTradeSubmitPaymentRspModel : SARspModel
@property (nonatomic, copy) NSArray<HDTradeSubmitPreferentialModel *> *couponList; ///< 优惠信息
@property (nonatomic, copy) NSString *date;                                        ///< 收银完成时间
@property (nonatomic, copy) NSString *desc;                                        ///< 商品描述
@property (nonatomic, strong) SAMoneyModel *orderAmt;                              ///< 下单金额
@property (nonatomic, strong) SAMoneyModel *payAmt;                                ///< 支付金额/单位分
@property (nonatomic, strong) SAMoneyModel *payeeAmt;                              ///< 汇兑金额
@property (nonatomic, strong) SAMoneyModel *userFeeAmt;                            ///< 用户手续费
@property (nonatomic, strong) NSNumber *exchangeRate;                              ///< 汇率
@property (nonatomic, copy) NSString *mark;                                        ///< 金额方向标记
@property (nonatomic, strong) SAMoneyModel *feeAmt;                                ///< 费用
@property (nonatomic, copy) NSString *payeeName;                                   ///< 收款方名称
@property (nonatomic, copy) NSString *payeeNo;                                     ///< 收款方
@property (nonatomic, copy) NSString *payerMp;                                     ///< 付款人手机号
@property (nonatomic, copy) NSString *payeeSymbol;                                 ///< 目标（兑换）币种符号
@property (nonatomic, assign) HDPayOrderStatus status;                             ///< 收银流水状态
@property (nonatomic, copy) NSString *symbol;                                      ///< 币种符号
@property (nonatomic, copy) NSString *tradeNo;                                     ///< 交易订单号
@property (nonatomic, assign) HDTransType tradeType;                               ///< 交易类型
@property (nonatomic, assign) HDTradeSubTradeType subTradeType;                    ///< 二级交易类型 (10:手机充值,11:立返,12:网络和电视)
@end

NS_ASSUME_NONNULL_END
