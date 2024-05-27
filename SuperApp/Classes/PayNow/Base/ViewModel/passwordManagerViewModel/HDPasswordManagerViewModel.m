//
//  HDPasswordManagerViewModel.m
//  customer
//
//  Created by 陈剑 on 2018/8/2.
//  Copyright © 2018年 chaos network technology. All rights reserved.
//

#import "HDPasswordManagerViewModel.h"
#import "HDGetAccessTokenRspModel.h"
#import "HDGetEncryptFactorRspModel.h"
#import "HDVerifyLoginPwdRspModel.h"
#import "NSDate+Extension.h"
#import "PNOpenPaymentRspModel.h"
#import "PNPasswordManagerDTO.h"
#import "PayHDTradeSubmitPaymentRspModel.h"
#import "SAAppEnvManager.h"
#import "VipayUser.h"


@interface HDPasswordManagerViewModel ()
@property (nonatomic, strong) PNPasswordManagerDTO *passwordDTO;
@end


@implementation HDPasswordManagerViewModel

/// 根据随机数获取加密因子
- (void)getEncryptFactorWithRandom:(NSString *)random finish:(void (^)(NSString *index, NSString *factor))finish failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    [self.passwordDTO getEncryptFactorWithRandom:random success:^(HDGetEncryptFactorRspModel *_Nonnull rspModel) {
        !finish ?: finish(rspModel.index, rspModel.publicKey);
    } failure:failureBlock];
}

/// 校验原支付密码，获取凭证
- (void)verifyPayPwdByIndex:(NSString *)index Password:(NSString *)pwd finish:(void (^)(NSString *token))finish failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    [self.passwordDTO verifyPayPwdByIndex:index Password:pwd success:^(HDVerifyLoginPwdRspModel *_Nonnull rspModel) {
        !finish ?: finish(rspModel.accessToken);
    } failure:failureBlock];
}

/// 获取凭证
- (void)getAccessTokenWithTokenType:(PNTokenType)tokenType success:(void (^)(NSString *accessToken))success failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    [self.passwordDTO getAccessTokenWithTokenType:tokenType success:^(HDGetAccessTokenRspModel *_Nonnull rspModel) {
        !success ?: success(rspModel.token);
    } failure:failureBlock];
}

/// 开通付款码功能
- (void)requestOpenPaymentWithBusinessType:(NSInteger)businessType
                          payCertifiedType:(NSInteger)payCertifiedType
                                     index:(NSString *)index
                                  password:(NSString *)password
                                   success:(void (^)(NSString *authKey, NSString *payerUsrToken))successBlock
                                   failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    [self.passwordDTO requestOpenPaymentWithBusinessType:businessType payCertifiedType:payCertifiedType index:index password:password success:^(PNOpenPaymentRspModel *_Nonnull rspModel) {
        !successBlock ?: successBlock(rspModel.authKey, rspModel.payerUsrToken);
    } failure:failureBlock];
}

/// 获取 付款码
- (void)requestPaymentQRCodeWithBusinessType:(NSInteger)businessType
                                       index:(NSString *)index
                                    password:(NSString *)password
                                     success:(void (^)(NSDictionary *rspData))successBlock
                                     failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    [self.passwordDTO requestPaymentQRCodeWithBusinessType:businessType index:index password:password success:^(NSDictionary *_Nonnull rspData) {
        !successBlock ?: successBlock(rspData);
    } failure:failureBlock];
}

/// 出金 确认付款/支付 [coolcash]
- (void)coolCashOutPaymentSubmitWithVoucherNo:(NSString *)voucherNo
                                        index:(NSString *)index
                                       payPwd:(NSString *)securityTxt
                                      success:(void (^)(PayHDTradeSubmitPaymentRspModel *rspModel))successBlock
                                      failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    [self.passwordDTO coolCashOutPaymentSubmitWithVoucherNo:voucherNo index:index payPwd:securityTxt success:successBlock failure:failureBlock];
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
    [self.passwordDTO pn_tradeSubmitPaymentWithIndex:index payPwd:payPwd tradeNo:tradeNo voucherNo:voucherNo outBizNo:outBizNo qrData:qrData payWay:payWay success:successBlock failure:failureBlock];
}

#pragma mark
- (PNPasswordManagerDTO *)passwordDTO {
    return _passwordDTO ?: ({ _passwordDTO = [[PNPasswordManagerDTO alloc] init]; });
}
@end
