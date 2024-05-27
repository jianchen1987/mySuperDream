//
//  PNMSBindDTO.m
//  SuperApp
//
//  Created by xixi_wen on 2022/6/10.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSBindDTO.h"


@implementation PNMSBindDTO

/// 查询商户信息 - [绑定关联商户那边使用]
- (void)queryMerchantServicesInfoWithMerchantNo:(NSString *)merchantNo success:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/usercenter/merchants/query";
    request.requestParameter = @{
        @"merchantNo": [merchantNo uppercaseString],
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 获取验证码 - [绑定商户]
- (void)sendSMSCodeWithMerchantNo:(NSString *)merchantNo success:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/usercenter/merchants/sendSms";
    request.requestParameter = @{
        @"merchantNo": [merchantNo uppercaseString],
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 校验 验证码 并且 绑定
- (void)verifyAndBindWithMerchantNo:(NSString *)merchantNo smsCode:(NSString *)smsCode success:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/usercenter/merchants/verifyAndBind";
    request.requestParameter = @{
        @"merchantNo": [merchantNo uppercaseString],
        @"smsCode": smsCode,
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 获取加密因子
- (void)getEncryptionFactorRandom:(NSString *)random success:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/login/sessionkey/get/encryption/factor.do";
    request.requestParameter = @{
        @"random": random,
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
