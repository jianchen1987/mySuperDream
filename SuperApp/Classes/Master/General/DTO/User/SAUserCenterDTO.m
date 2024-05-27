//
//  SAUserCenterDTO.m
//  SuperApp
//
//  Created by seeu on 2020/8/17.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAUserCenterDTO.h"
#import "SACheckUserStatusRspModel.h"
#import "SAEarnPointBannerRspModel.h"
#import "SAGeneralUtil.h"
#import "SAMoneyModel.h"
#import "SAUserSilentPermissionRspModel.h"
#import "SAWPontWillGetRspModel.h"


@implementation SAUserCenterDTO
/// 短信登陆，注册并登陆使用同一个接口
/// @param phoneNo 手机号
/// @param code 验证码
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)loginWithPhoneNo:(NSString *)phoneNo
                 SmsCode:(NSString *)code
                 bizType:(NSString *)bizType
             agreementNo:(NSString *)agreementNo
               riskToken:(NSString *)riskToken
                 success:(void (^_Nullable)(SALoginRspModel *rspModel))successBlock
                 failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"mobile"] = phoneNo;
    params[@"smsCode"] = code;
    params[@"biz"] = bizType;
    params[@"agreementNo"] = agreementNo;
    params[@"deviceInfo"] = [SAGeneralUtil getDeviceInfo];
    if (HDIsStringNotEmpty(riskToken)) {
        params[@"riskToken"] = riskToken;
    }

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 1;
    request.requestURI = @"/operator/login/smsLogin.do";
    request.isNeedLogin = NO;

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SALoginRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

/// 设置登陆密码
/// @param password 登陆密码密文
/// @param index 加密因子索引
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)setLoginPasswordWithEncryptPwd:(NSString *)password index:(NSString *)index success:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"index"] = index;
    params[@"password"] = password;
    params[@"deviceInfo"] = [SAGeneralUtil getDeviceInfo];

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 1;
    request.requestURI = @"/operator/password/setLoginPwd.do";
    request.isNeedLogin = YES;

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)checkUserStatusWithCountryCode:(NSString *)countryCode
                             accountNo:(NSString *)accountNo
                               success:(void (^)(SACheckUserStatusRspModel *_Nonnull))successBlock
                               failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"loginName"] = [NSString stringWithFormat:@"%@%@", countryCode, accountNo];

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/operator/login/check.do";
    request.isNeedLogin = false;

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SACheckUserStatusRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)checkThirdPartyAccountBindStatusChannel:(SAThirdPartyBindChannel)channel
                                         userId:(NSString *)userId
                                        success:(void (^)(SAThirdPartyAccountBindStatusRspModel *rspModel))successBlock
                                        failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"channel"] = channel;
    params[@"userId"] = userId;

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/operator/register/bindStatus.do";
    request.isNeedLogin = false;

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SAThirdPartyAccountBindStatusRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)authLoginWithChannel:(SAThirdPartyBindChannel)channel
                      userId:(NSString *)userId
                  thirdToken:(NSString *)thirdToken
                   riskToken:(NSString *)riskToken
                     success:(void (^)(SALoginRspModel *_Nonnull))successBlock
                     failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"channel"] = channel;
    params[@"userId"] = userId;
    params[@"thirdToken"] = thirdToken;
    params[@"deviceInfo"] = [SAGeneralUtil getDeviceInfo];
    if (HDIsStringNotEmpty(riskToken)) {
        params[@"riskToken"] = riskToken;
    }

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/operator/login/authLogin.do";
    request.isNeedLogin = false;

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SALoginRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)loginWithAccountNo:(NSString *)accountNo
                encryptPwd:(NSString *)pwd
                     index:(NSString *)index
                 riskToken:(NSString *)riskToken
                   success:(void (^)(SALoginRspModel *rspModel))successBlock
                   failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"index"] = index;
    params[@"loginName"] = accountNo;
    params[@"password"] = pwd;
    params[@"deviceInfo"] = [SAGeneralUtil getDeviceInfo];
    if (HDIsStringNotEmpty(riskToken)) {
        params[@"riskToken"] = riskToken;
    }
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/operator/login/password.do";
    request.isNeedLogin = false;

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SALoginRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)bindLoginThirdPartyWithAccount:(NSString *)account
                        pwdSecurityStr:(NSString *_Nullable)pwdSecurityStr
                                 index:(NSString *_Nullable)index
                            thirdToken:(NSString *)thirdToken
                         thirdUserName:(NSString *)thirdUserName
                               channel:(NSString *)channel
                             apiTicket:(NSString *)apiTicket
                               success:(void (^)(SALoginRspModel *_Nonnull))successBlock
                               failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"loginName"] = account;
    if (HDIsStringNotEmpty(pwdSecurityStr)) {
        params[@"password"] = pwdSecurityStr;
    }
    if (HDIsStringNotEmpty(index)) {
        params[@"index"] = index;
    }
    params[@"thirdToken"] = thirdToken;
    params[@"thirdUserName"] = thirdUserName;
    params[@"channel"] = channel;
    params[@"apiTicket"] = apiTicket;
    params[@"agreementNo"] = @"AG1139809824121798655";
    params[@"deviceInfo"] = [SAGeneralUtil getDeviceInfo];

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/operator/register/password/auth/bind.do";
    request.isNeedLogin = false;

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SALoginRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)activeOperatorWithAccount:(NSString *)account
                       thirdToken:(NSString *)thirdToken
                    thirdUserName:(NSString *)thirdUserName
                          channel:(NSString *)channel
                        apiTicket:(NSString *)apiTicket
                        riskToken:(NSString *)riskToken
                          success:(void (^)(SALoginRspModel *rspModel))successBlock
                          failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"apiTicket"] = apiTicket;
    params[@"loginName"] = account;
    params[@"thirdToken"] = thirdToken;
    params[@"thirdUserName"] = thirdUserName;
    params[@"channel"] = channel;
    params[@"agreementNo"] = @"AG1139809824121798655";
    if (HDIsStringNotEmpty(riskToken)) {
        params[@"riskToken"] = riskToken;
    }

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/operator/register/active/bind.do";
    request.isNeedLogin = false;

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SALoginRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)thirtPartyBindRegisterWithAccountNo:(NSString *)account
                                 thirdToken:(NSString *)thirdToken
                              thirdUserName:(NSString *)thirdUserName
                                    channel:(NSString *)channel
                                  apiTicket:(NSString *)apiTicket
                                  riskToken:(NSString *)riskToken
                                    success:(void (^)(SALoginRspModel *_Nonnull))successBlock
                                    failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    params[@"apiTicket"] = apiTicket;
    params[@"agreementNo"] = @"AG1139809824121798655";
    params[@"loginName"] = account;
    params[@"thirdToken"] = thirdToken;
    params[@"channel"] = channel;
    params[@"thirdUserName"] = thirdUserName;
    params[@"deviceInfo"] = [SAGeneralUtil getDeviceInfo];
    if (HDIsStringNotEmpty(riskToken)) {
        params[@"riskToken"] = riskToken;
    }

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/operator/register/bind.do";
    request.isNeedLogin = false;

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SALoginRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)thirdPartyRegisterWithChannel:(SAThirdPartyBindChannel)channel
                               userId:(NSString *)userId
                             authCode:(NSString *)authCode
                          accessToken:(NSString *)accessToken
                            riskToken:(NSString *)riskToken
                              success:(void (^)(SALoginRspModel *rspModel))successBlock
                              failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/operator/register/bindAccount.do";
    request.isNeedLogin = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    params[@"agreementNo"] = @"AG1139809824121798655";
    params[@"accessToken"] = accessToken;
    params[@"channel"] = channel;
    params[@"userId"] = userId;
    params[@"authorizationCode"] = authCode;
    params[@"deviceInfo"] = [SAGeneralUtil getDeviceInfo];
    if (HDIsStringNotEmpty(riskToken)) {
        params[@"riskToken"] = riskToken;
    }
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SALoginRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)getWechatAccessTokenWithAuthCode:(NSString *)authCode
                                 channel:(SAThirdPartyBindChannel)channel
                                 success:(void (^_Nullable)(SAWechatGetAccessTokenRspModel *rspModel))successBlock
                                 failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"code"] = authCode;
    params[@"channel"] = channel;

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/operator/login/queryUserInfo.do";
    request.isNeedLogin = NO;

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SAWechatGetAccessTokenRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)userPermissionSilentlyWithParams:(NSDictionary *)paramDic
                                 success:(void (^_Nullable)(SAUserSilentPermissionRspModel *rspModel))successBlock
                                 failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:paramDic];
    params[@"deviceInfo"] = [SAGeneralUtil getDeviceInfo];

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/gateway.do";
    request.isNeedLogin = YES;

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SAUserSilentPermissionRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)bindInvitationCodeWithCode:(NSString *)invitationCode
                 invitationChannel:(NSString *)channel
                           success:(void (^_Nullable)(void))successBlock
                           failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"invitationCode"] = invitationCode;
    params[@"invitationSource"] = channel;
    params[@"deviceInfo"] = [SAGeneralUtil getDeviceInfo];

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/operator/register/Inviter/bind.do";
    request.isNeedLogin = YES;

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock();
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)uploadUserContactsWithDataArray:(NSArray<SAContactModel *> *)datas
                             operatorNo:(NSString *)operatorNo
                                success:(void (^_Nullable)(NSArray<SAContactModel *> *uploadedData))successBlock
                                failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"contacts"] = [datas yy_modelToJSONString];
    params[@"operatorNo"] = operatorNo;
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/operator/info/modify.do";
    request.isNeedLogin = YES;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        !successBlock ?: successBlock(datas);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)queryHowManyWPointWillGetWithOrderNo:(NSString *)orderNo
                                businessLine:(SAClientType)businessLine
                          actuallyPaidAmount:(SAMoneyModel *)actuallyPaidAmount
                                  merchantNo:(NSString *_Nullable)merchantNo
                                     success:(void (^_Nullable)(SAWPontWillGetRspModel *_Nullable rspModel))successBlock
                                     failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/operator/aggregation/point/queryRules.do";
    request.isNeedLogin = YES;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"businessNo"] = orderNo;
    params[@"actualPayAmount"] = @{@"cent": actuallyPaidAmount.cent, @"currency": actuallyPaidAmount.cy, @"amount": actuallyPaidAmount.amount};
    params[@"businessLine"] = businessLine;
    if (HDIsStringNotEmpty(merchantNo)) {
        params[@"merchantNo"] = merchantNo;
    }

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SAWPontWillGetRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)queryEarnPointBannerSuccess:(void (^)(SAEarnPointBannerRspModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/cam-member-center/manager/bannerConfig/queryEarnPointBanner";
    request.isNeedLogin = YES;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SAEarnPointBannerRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)thirdPartLoginWithChannel:(SAThirdPartyBindChannel)channel
                           userId:(NSString *)userId
                       thirdToken:(NSString *)thirdToken
                        riskToken:(NSString *)riskToken
                          success:(void (^)(SALoginRspModel *_Nonnull))successBlock
                          failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"channel"] = channel;
    params[@"userId"] = userId;
    params[@"thirdToken"] = thirdToken;
    params[@"deviceInfo"] = [SAGeneralUtil getDeviceInfo];
    if (HDIsStringNotEmpty(riskToken)) {
        params[@"riskToken"] = riskToken;
    }

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    if ([channel isEqualToString:SAThirdPartyBindChannelApple]) {
        request.requestURI = @"/operator/login/appleAuthBind.do";
    } else if ([channel isEqualToString:SAThirdPartyBindChannelFacebook]) {
        request.requestURI = @"/operator/login/facebookAuthBind.do";
    }
    request.isNeedLogin = false;
    request.shouldAlertErrorMsgExceptSpecCode = NO;

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SALoginRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)checkThirdPartyAccountBindStatusV2WithChannel:(SAThirdPartyBindChannel)channel
                                               userId:(NSString *)userId
                                              success:(void (^)(SAThirdPartyAccountBindStatusRspModel *_Nonnull))successBlock
                                              failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"channel"] = channel;
    params[@"userId"] = userId;

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/operator/register/bindStatusV2.do";
    request.isNeedLogin = false;

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SAThirdPartyAccountBindStatusRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

- (void)authLoginV2WithChannel:(SAThirdPartyBindChannel)channel
                        userId:(NSString *)userId
                    thirdToken:(NSString *)thirdToken
                     riskToken:(NSString *)riskToken
                       success:(void (^)(SALoginRspModel *_Nonnull))successBlock
                       failure:(CMNetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"channel"] = channel;
    params[@"userId"] = userId;
    params[@"thirdToken"] = thirdToken;
    params[@"deviceInfo"] = [SAGeneralUtil getDeviceInfo];
    if (HDIsStringNotEmpty(riskToken)) {
        params[@"riskToken"] = riskToken;
    }

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/operator/login/authLoginV2.do";
    request.isNeedLogin = false;

    request.requestParameter = params;
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        !successBlock ?: successBlock([SALoginRspModel yy_modelWithJSON:rspModel.data]);
    } failure:^(HDNetworkResponse *_Nonnull response) {
        !failureBlock ?: failureBlock(response.extraData, response.errorType, response.error);
    }];
}

@end
