//
//  PNPasswordManagerDTO.h
//  SuperApp
//
//  Created by xixi_wen on 2022/2/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNModel.h"

@class HDGetEncryptFactorRspModel;
@class HDVerifyLoginPwdRspModel;
@class HDGetAccessTokenRspModel;
@class PNOpenPaymentRspModel;
@class PayHDTradeSubmitPaymentRspModel;

NS_ASSUME_NONNULL_BEGIN


@interface PNPasswordManagerDTO : PNModel

/// 获取加密因子
- (void)getEncryptFactorWithRandom:(NSString *)random success:(void (^)(HDGetEncryptFactorRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 验证支付密码获取凭证
- (void)verifyPayPwdByIndex:(NSString *)index Password:(NSString *)pwd success:(void (^)(HDVerifyLoginPwdRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 获取accessToken
- (void)getAccessTokenWithTokenType:(PNTokenType)tokenType success:(void (^)(HDGetAccessTokenRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 开通用户付款业务（启用）
- (void)requestOpenPaymentWithBusinessType:(NSInteger)businessType
                          payCertifiedType:(NSInteger)payCertifiedType
                                     index:(NSString *)index
                                  password:(NSString *)password
                                   success:(void (^)(PNOpenPaymentRspModel *rspModel))successBlock
                                   failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 获取 付款码
- (void)requestPaymentQRCodeWithBusinessType:(NSInteger)businessType
                                       index:(NSString *)index
                                    password:(NSString *)password
                                     success:(void (^)(NSDictionary *rspData))successBlock
                                     failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 出金 确认付款/支付 [coolcash]
- (void)coolCashOutPaymentSubmitWithVoucherNo:(NSString *)voucherNo
                                        index:(NSString *)index
                                       payPwd:(NSString *)securityTxt
                                      success:(void (^)(PayHDTradeSubmitPaymentRspModel *rspModel))successBlock
                                      failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 支付
- (void)pn_tradeSubmitPaymentWithIndex:(NSString *)index
                                payPwd:(NSString *)payPwd
                               tradeNo:(NSString *)tradeNo
                             voucherNo:(NSString *)voucherNo
                              outBizNo:(NSString *)outBizNo
                                qrData:(NSString *)qrData
                                payWay:(NSString *)payWay
                               success:(void (^)(PayHDTradeSubmitPaymentRspModel *rspModel))successBlock
                               failure:(PNNetworkFailureBlock _Nullable)failureBlock;

@end

NS_ASSUME_NONNULL_END
