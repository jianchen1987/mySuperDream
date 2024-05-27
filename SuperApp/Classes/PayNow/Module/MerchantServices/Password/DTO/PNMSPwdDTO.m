//
//  PNMSPwdDTO.m
//  SuperApp
//
//  Created by xixi_wen on 2022/6/9.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSPwdDTO.h"
#import "NAT.h"
#import "NSString+AES.h"
#import "PNMSEncryptFactorRspModel.h"
#import "PNMSRoleManagerInfoModel.h"
#import "PNMSSMSValidateRspModel.h"
#import "PNRspModel.h"
#import "VipayUser.h"


@implementation PNMSPwdDTO
/// 获取加密因子
- (void)getMSEncryptFactorWithRandom:(NSString *)random success:(void (^)(PNMSEncryptFactorRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.needSessionKey = YES;
    request.requestURI = @"/login/sessionkey/get/encryption/factor.do";
    request.requestParameter = @{
        @"random": random,
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        PNMSEncryptFactorRspModel *encryptModel = [[PNMSEncryptFactorRspModel alloc] init];

        NSString *realKey = [random getRealKey]; // base64字符串16位数
        NSString *encrypFactorStr = [rspModel.data objectForKey:@"encrypFactor"];
        NSString *indexfactor = [encrypFactorStr AES128CBCDecryptWithKey:realKey andVI:@"A-16-Byte-String"]; //获得加密因子
        NSArray *arr = [indexfactor componentsSeparatedByString:@"_"];
        if (arr.count == 2) {
            encryptModel.index = arr[0];
            encryptModel.encrypFactor = arr[1];
            !successBlock ?: successBlock(encryptModel);
        } else {
            [NAT showToastWithTitle:nil content:@"解析错误" type:HDTopToastTypeError];
        }
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 设置交易密码
- (void)saveMSTradePwd:(NSString *)password
                 index:(NSString *)index
            operatorNo:(NSString *)operatorNo
               success:(void (^)(PNRspModel *rspModel))successBlock
               failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.needSessionKey = true;
    request.requestURI = @"/usercenter/trade/pwd/save.do";
    request.requestParameter = @{
        @"password": password,
        @"index": index,
        @"operatorNo": operatorNo,
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 校验交易密码
- (void)validatorMSTradePwd:(NSString *)password
                      index:(NSString *)index
                 operatorNo:(NSString *)operatorNo
                    success:(void (^)(PNRspModel *rspModel))successBlock
                    failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.needSessionKey = true;
    request.requestURI = @"/usercenter/trade/pwd/validator.do";
    request.requestParameter = @{
        @"tradePwd": password,
        @"index": index,
        @"operatorNo": operatorNo,
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 修改交易密码
- (void)updateMSTradePwd:(NSString *)newPassword
             oldTradePwd:(NSString *)oldTradePwd
                   index:(NSString *)index
              operatorNo:(NSString *)operatorNo
                 success:(void (^)(PNRspModel *rspModel))successBlock
                 failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.needSessionKey = true;
    request.requestURI = @"/usercenter/trade/pwd/update.do";
    request.requestParameter = @{
        @"tradePwd": oldTradePwd,
        @"index": index,
        @"operatorNo": operatorNo,
        @"newTradePwd": newPassword,
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 发送短信 【忘记密码】
- (void)sendSMS:(void (^)(PNRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.needSessionKey = true;
    request.requestURI = @"/sms/send8550.do";
    /* customerType    客户类型PERSON(个人) ORG(企业)
     * smsSendTemplate 短信类型11(忘记模板)
     */
    request.requestParameter = @{
        @"customerType": @"ORG",
        @"loginName": VipayUser.shareInstance.loginName,
        @"smsSendTemplate": @(11),
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 校验短信验证码
- (void)validateSMSCode:(NSString *)smsCode success:(void (^)(PNMSSMSValidateRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.needSessionKey = true;
    request.requestURI = @"/sms/validate8550.do";
    /* customerType    客户类型PERSON(个人) ORG(企业)
     * smsSendTemplate 短信类型11(忘记模板)
     */
    request.requestParameter = @{
        @"customerType": @"ORG",
        @"loginName": VipayUser.shareInstance.loginName,
        @"smsSendTemplate": @(12),
        @"smsCode": smsCode,
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;

        !successBlock ?: successBlock([PNMSSMSValidateRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 重置密码
- (void)resetMSTradePwd:(NSString *)newPassword
                  index:(NSString *)index
             operatorNo:(NSString *)operatorNo
           serialNumber:(NSString *)serialNumber
                  token:(NSString *)token
                success:(void (^)(PNRspModel *rspModel))successBlock
                failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.needSessionKey = true;
    request.requestURI = @"/usercenter/trade/pwd/reset8550.do";
    request.requestParameter = @{
        @"newTradePwd": newPassword,
        @"index": index,
        @"serialNumber": serialNumber,
        @"token": token,
        @"loginName": VipayUser.shareInstance.loginName,
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 返回操作员对应超管信息
- (void)getManagerInfo:(void (^)(PNMSRoleManagerInfoModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.requestURI = @"/merchant/app/mer/role/queryManagerInfo";
    request.requestParameter = @{};

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([PNMSRoleManagerInfoModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 校验短信验证码 - 重置操作员密码
- (void)operatorPWdValidateSMSCode:(NSString *)smsCode success:(void (^)(PNMSSMSValidateRspModel *rspModel))successBlock failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.needSessionKey = true;
    request.requestURI = @"/sms/validate_app.do";
    /* customerType    客户类型PERSON(个人) ORG(企业)
     * smsSendTemplate 短信类型11(忘记模板)
     */
    request.requestParameter = @{
        @"customerType": @"ORG",
        @"loginName": VipayUser.shareInstance.loginName,
        @"smsSendTemplate": @(12),
        @"smsCode": smsCode,
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;

        !successBlock ?: successBlock([PNMSSMSValidateRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 重置密码 - 重置操作员密码
- (void)operatorResetMSTradePwd:(NSString *)newPassword
                          index:(NSString *)index
                     operatorNo:(NSString *)operatorNo
                   serialNumber:(NSString *)serialNumber
                          token:(NSString *)token
                        success:(void (^)(PNRspModel *rspModel))successBlock
                        failure:(PNNetworkFailureBlock _Nullable)failureBlock {
    PNNetworkRequest *request = PNNetworkRequest.new;
    request.needSessionKey = true;
    request.requestURI = @"/usercenter/trade/pwd/reset_app";
    request.requestParameter = @{
        @"newTradePwd": newPassword,
        @"index": index,
        @"serialNumber": serialNumber,
        @"token": token,
        @"loginName": VipayUser.shareInstance.loginName,
    };

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        PNRspModel *rspModel = response.extraData;
        !successBlock ?: successBlock(rspModel);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
