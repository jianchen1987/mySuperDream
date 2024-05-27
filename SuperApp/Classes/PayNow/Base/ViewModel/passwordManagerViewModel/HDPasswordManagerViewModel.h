//
//  HDPasswordManagerViewModel.h
//  customer
//
//  Created by 陈剑 on 2018/8/2.
//  Copyright © 2018年 chaos network technology. All rights reserved.
//

#import "PNEnum.h"
#import "PNNetworkRequest.h"
#import "PNViewModel.h"

@class PayHDTradeSubmitPaymentRspModel;

NS_ASSUME_NONNULL_BEGIN


@interface HDPasswordManagerViewModel : PNViewModel

/// 根据随机数获取加密因子
/// @param random 密码明文 16位随机数
/// @param finish 成功回调
/// @param failureBlock 失败回调
- (void)getEncryptFactorWithRandom:(NSString *)random finish:(void (^)(NSString *index, NSString *factor))finish failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/**
 校验原支付密码，获取凭证

 @param index 加密索引
 @param pwd 支付密码
 @param finish 成功回调（凭证）
 */
- (void)verifyPayPwdByIndex:(NSString *)index Password:(NSString *)pwd finish:(void (^)(NSString *token))finish failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/**
 获取accessToken

 @param tokenType token类型
 @param success 成功回调
 */
- (void)getAccessTokenWithTokenType:(PNTokenType)tokenType success:(void (^)(NSString *accessToken))success failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 开通付款码功能
/// @param businessType 业务请求身份标识
/// @param payCertifiedType 支付认证类型
/// @param index 加密因子
/// @param password 密码
/// @param successBlock 成功回调
/// @param failureBlock 网络异常回调
- (void)requestOpenPaymentWithBusinessType:(NSInteger)businessType
                          payCertifiedType:(NSInteger)payCertifiedType
                                     index:(NSString *)index
                                  password:(NSString *)password
                                   success:(void (^)(NSString *authKey, NSString *payerUsrToken))successBlock
                                   failure:(PNNetworkFailureBlock _Nullable)failureBlock;

/// 获取 用户付款码
/// @param businessType 业务请求身份标识
/// @param index 加密因子
/// @param password 密码
/// @param successBlock 成功回调
/// @param failureBlock 网络异常回调
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

/**
 支付

 @param index 加密因子索引
 @param payPwd 支付密码
 @param tradeNo 订单号 (最大长度32)
 @param voucherNo 凭证号 (最大长度32)
 @param successBlock 成功回调
 @param failureBlock 网络错误回调
 */
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
