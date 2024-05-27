//
//  SASMSCodeDTO.m
//  SuperApp
//
//  Created by VanJay on 2020/4/13.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SASMSCodeDTO.h"
#import "SAUserCenterDTO.h"


@implementation SASMSCodeDTO

- (void)getSMSCodeWithCountryCode:(NSString *)countryCode accountNo:(NSString *)accountNo type:(SASendSMSType)type success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.requestURI = @"/operator/register/sendRegisterSms.do";
    request.isNeedLogin = false;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"loginName"] = [NSString stringWithFormat:@"%@%@", countryCode, accountNo];
    params[@"biz"] = type;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)verifySMSCodeWithCountryCode:(NSString *)countryCode
                           accountNo:(NSString *)accountNo
                                type:(SASendSMSType)type
                             smsCode:(NSString *)smsCode
                             success:(void (^)(SAVerifySMSCodeRspModel *rspModel))successBlock
                             failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/operator/register/verifyRegisterSms.do";
    request.isNeedLogin = false;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"loginName"] = [NSString stringWithFormat:@"%@%@", countryCode, accountNo];
    params[@"biz"] = type;
    params[@"code"] = smsCode;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SAVerifySMSCodeRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 发送注册或登陆短信
/// @param phoneNo 手机号码
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)sendRegisterOrLoginSMSWithPhoneNo:(NSString *)phoneNo success:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/operator/login/sendLoginSms.do";
    request.isNeedLogin = NO;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"mobile"] = phoneNo;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)sendSMSWithPhoneNo:(NSString *)phoneNo type:(SASendSMSType)type success:(CMNetworkSuccessVoidBlock)successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/operator/sms/send.do";
    request.isNeedLogin = NO;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"mobile"] = phoneNo;
    params[@"biz"] = type;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)sendVoiceCodeWithPhoneNo:(NSString *)phoneNo type:(nonnull SASendSMSType)type success:(dispatch_block_t)successBlock failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/operator/login/sendSmsVoip.do";
    request.isNeedLogin = NO;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"loginName"] = phoneNo;
    params[@"biz"] = type;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)sendVoiceCodeByLoginWithPhoneNo:(NSString *)phoneNo success:(dispatch_block_t)successBlock failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/operator/login/sendLoginSmsVoiceOtp.do";
    request.isNeedLogin = NO;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"mobile"] = phoneNo;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
