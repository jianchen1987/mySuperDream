//
//  PNPasswordManagerDTO.m
//  SuperApp
//
//  Created by xixi_wen on 2022/2/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPasswordManagerDTO.h"
#import "HDGetAccessTokenRspModel.h"
#import "HDGetEncryptFactorRspModel.h"
#import "HDVerifyLoginPwdRspModel.h"
#import "PNOpenPaymentRspModel.h"
#import "PNRspModel.h"
#import "PayHDTradeSubmitPaymentRspModel.h"
#import "SAUser.h"
#import "VipayUser.h"


@implementation PNPasswordManagerDTO

/// 获取加密因子
- (void)getEncryptFactorWithRandom:(NSString *)random
                         LoginName:(NSString *)loginName
                           success:(void (^)(HDGetEncryptFactorRspModel *rspModel))successBlock
                           failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/sa/encryption/factor.do";
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
    [dict setValue:random forKey:@"random"];

    if (HDIsStringNotEmpty(loginName)) {
        [request setValue:loginName forKey:@"loginName"];
    }

    request.requestParameter = dict;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        HDGetEncryptFactorRspModel *encryptModel = [HDGetEncryptFactorRspModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(encryptModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 获取加密因子
- (void)getEncryptFactorWithRandom:(NSString *)random success:(void (^)(HDGetEncryptFactorRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/sa/encryption/factor.do";
    request.requestParameter = @{@"random": random, @"loginName": [VipayUser shareInstance].loginName ? [VipayUser shareInstance].loginName : @""};

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        HDGetEncryptFactorRspModel *encryptModel = [HDGetEncryptFactorRspModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(encryptModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 验证支付密码获取凭证
- (void)verifyPayPwdByIndex:(NSString *)index Password:(NSString *)pwd success:(void (^)(HDVerifyLoginPwdRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/tradePwd/validate/pwd/update.do";
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    request.requestParameter = @{@"index": index, @"oldTradePwd": pwd, @"bizType": @16};

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        HDVerifyLoginPwdRspModel *verifyModel = [HDVerifyLoginPwdRspModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(verifyModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 获取accessToken
- (void)getAccessTokenWithTokenType:(PNTokenType)tokenType success:(void (^)(HDGetAccessTokenRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/token/create.do";
    request.requestParameter = @{@"loginName": [VipayUser shareInstance].loginName ?: SAUser.shared.loginName, @"bizType": [NSNumber numberWithInteger:tokenType]};

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        HDGetAccessTokenRspModel *accessTokenModel = [HDGetAccessTokenRspModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(accessTokenModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 开通用户付款业务（启用）
- (void)requestOpenPaymentWithBusinessType:(NSInteger)businessType
                          payCertifiedType:(NSInteger)payCertifiedType
                                     index:(NSString *)index
                                  password:(NSString *)password
                                   success:(void (^)(PNOpenPaymentRspModel *rspModel))successBlock
                                   failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/biz-codepayment-service/trade/user/business/create";
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:4];
    [dict setObject:@(businessType) forKey:@"businessType"];
    [dict setObject:@(payCertifiedType) forKey:@"payCertifiedType"];
    [dict setObject:index forKey:@"index"];
    [dict setObject:password forKey:@"password"];
    request.requestParameter = dict;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        PNOpenPaymentRspModel *openPaymentRspModel = [PNOpenPaymentRspModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(openPaymentRspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 获取 付款码
- (void)requestPaymentQRCodeWithBusinessType:(NSInteger)businessType
                                       index:(NSString *)index
                                    password:(NSString *)password
                                     success:(void (^)(NSDictionary *rspData))successBlock
                                     failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/biz-codepayment-service/trade/user/code/pay/create";
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:4];
    [dict setObject:@(businessType) forKey:@"businessType"];

    //加密因子(免密不上送)
    if (index.length > 0) {
        [dict setObject:index forKey:@"index"];
    }
    //密码(免密不上送)
    if (password.length > 0) {
        [dict setObject:password forKey:@"password"];
    }

    request.requestParameter = dict;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        NSDictionary *dict = rspModel.data;
        !successBlock ?: successBlock(dict);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 出金 确认付款/支付 [coolcash]
- (void)coolCashOutPaymentSubmitWithVoucherNo:(NSString *)voucherNo
                                        index:(NSString *)index
                                       payPwd:(NSString *)securityTxt
                                      success:(void (^)(PayHDTradeSubmitPaymentRspModel *rspModel))successBlock
                                      failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/cashier/payment/submit";
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    request.requestParameter = @{
        @"voucherNo": voucherNo,
        @"index": index,
        @"payPwd": securityTxt,
        @"deviceId": [HDDeviceInfo getUniqueId],
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        PayHDTradeSubmitPaymentRspModel *tradeSubmitModel = [PayHDTradeSubmitPaymentRspModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(tradeSubmitModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 支付
- (void)pn_tradeSubmitPaymentWithIndex:(NSString *)index
                                payPwd:(NSString *)payPwd
                               tradeNo:(NSString *)tradeNo
                             voucherNo:(NSString *)voucherNo
                              outBizNo:(NSString *)outBizNo
                                qrData:(NSString *)qrData
                                payWay:(NSString *)payWay
                               success:(void (^)(PayHDTradeSubmitPaymentRspModel *rspModel))successBlock
                               failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/trade/v3/payment/submit";
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:6];
    [param setValue:index forKey:@"index"];
    [param setValue:payPwd forKey:@"payPwd"];
    [param setValue:tradeNo forKey:@"tradeNo"];
    [param setValue:voucherNo forKey:@"voucherNo"];
    [param setValue:qrData forKey:@"qrData"];

    if (HDIsStringNotEmpty(payWay)) {
        [param setValue:payWay forKey:@"payWay"];
    }
    if (HDIsStringNotEmpty(outBizNo)) {
        [param setValue:outBizNo forKey:@"outBizNo"];
    }

    request.requestParameter = param;

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        PayHDTradeSubmitPaymentRspModel *model = [PayHDTradeSubmitPaymentRspModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(model);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
