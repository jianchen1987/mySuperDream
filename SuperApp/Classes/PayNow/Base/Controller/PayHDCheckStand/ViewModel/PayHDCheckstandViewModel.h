//
//  PayHDCheckstandViewModel.h
//  customer
//
//  Created by VanJay on 2019/5/16.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "PNModel.h"

@class PayHDTradeCreatePaymentRspModel;
@class PayHDTradeConfirmPaymentRspModel;
@class PayHDTradeSubmitPaymentRspModel;
@class PayHDTradePreferentialModel;
@class PayHDTradePaymentMethodModel;
@class PNCashToolsRspModel;
@class PNCashToolsMethodPaymentItemModel;
NS_ASSUME_NONNULL_BEGIN

/**
 收银台相关接口
 */
@interface PayHDCheckstandViewModel : PNModel

/**
 关闭订单

 @param tradeNo 交易订单号
 @param successBlock 成功回调
 @param failureBlock 网络错误回调
 */
- (void)pn_tradeClosePaymentWithTradeNo:(NSString *)tradeNo success:(void (^)(NSString *tradeNo))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

///出金 资金/支付受理 [coolcash]
- (void)coolCashOutCashAcceptWithTradeNo:(NSString *)tradeNo
                         paymentCurrency:(NSInteger)paymentCurrency
                           methodPayment:(PNCashToolsMethodPaymentItemModel *_Nullable)methodPayment
                                 success:(void (^)(PayHDTradeConfirmPaymentRspModel *rspModel))successBlock
                                 failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// PaymentTool
/// @param tradeNo 交易流水号
- (void)paymentTools:(NSString *)tradeNo success:(void (^)(PayHDTradeCreatePaymentRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;
/// 获取资金工具
- (void)cashTool:(NSString *)tradeNo success:(void (^_Nullable)(PNCashToolsRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;
/**
 下单

 @param amountStr 金额
 @param currency 币种
 @param tradeNo 交易订单号
 @param successBlock 成功回调
 @param failureBlock 网络错误回调
 */
- (void)pn_tradeCreatePaymentWithAmount:(NSString *)amountStr
                               currency:(NSString *)currency
                                tradeNo:(NSString *)tradeNo
                                success:(void (^)(PayHDTradeCreatePaymentRspModel *rspModel))successBlock
                                failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/**
 确认支付

 @param tradeNo 订单号 (最大长度32)
 @param successBlock 成功回调
 @param failureBlock 网络错误回调
 */
- (void)pn_tradeConfirmPaymentWithTradeNo:(NSString *)tradeNo
                          paymentCurrency:(NSInteger)paymentCurrency
                                  success:(void (^)(PayHDTradeConfirmPaymentRspModel *rspModel))successBlock
                                  failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 提现 下单
- (void)ms_withdrawToBankCardCreateOrder:(NSString *)amountStr
                                currency:(NSString *)currency
                           accountNumber:(NSString *)accountNumber
                         participantCode:(NSString *)participantCode
                                 success:(void (^)(PayHDTradeConfirmPaymentRspModel *rspModel))successBlock
                                 failure:(PNNetworkFailureBlock _Nullable)failureBlock;
@end

NS_ASSUME_NONNULL_END
