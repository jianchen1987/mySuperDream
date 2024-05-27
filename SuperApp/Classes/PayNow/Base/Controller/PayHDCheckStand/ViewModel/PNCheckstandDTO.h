//
//  PNCheckstandDTO.h
//  SuperApp
//
//  Created by xixi_wen on 2022/2/28.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNCashToolsRspModel.h"
#import "PNModel.h"

@class PayHDTradeConfirmPaymentRspModel;
@class PayHDTradeCreatePaymentRspModel;
@class PayHDTradePreferentialModel;
@class PayHDTradePaymentMethodModel;
@class PNCashToolsRspModel;
NS_ASSUME_NONNULL_BEGIN


@interface PNCheckstandDTO : PNModel

/// 关闭订单
- (void)pn_tradeClosePaymentWithTradeNo:(NSString *)tradeNo success:(void (^)(NSString *tradeNo))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

///出金 资金/支付受理 [coolcash]
- (void)coolCashOutCashAcceptWithTradeNo:(NSString *)tradeNo
                         paymentCurrency:(NSInteger)paymentCurrency
                           methodPayment:(PNCashToolsMethodPaymentItemModel *_Nullable)methodPayment
                                 success:(void (^)(PayHDTradeConfirmPaymentRspModel *rspModel))successBlock
                                 failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 获取支付工具 [返回订单支持的支付方式，比如钱包USD、钱包KHR、或者其他支付方式]
- (void)paymentTools:(NSString *)tradeNo success:(void (^)(PayHDTradeCreatePaymentRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 获取资金工具
- (void)cashTool:(NSString *)tradeNo success:(void (^_Nullable)(PNCashToolsRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 下单
- (void)pn_tradeCreatePaymentWithAmount:(NSString *)amountStr
                               currency:(NSString *)currency
                                tradeNo:(NSString *)tradeNo
                                success:(void (^)(PayHDTradeCreatePaymentRspModel *rspModel))successBlock
                                failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 订单确认 [确认支付] - 新的支付收银台用
- (void)pn_tradeConfirmPaymentWithTradeNo:(NSString *)tradeNo
                          paymentCurrency:(NSInteger)paymentCurrency
                                   payWay:(NSString *)payWay
                                  success:(void (^)(PayHDTradeConfirmPaymentRspModel *rspModel))successBlock
                                  failure:(PNNetworkFailureBlock _Nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END
