//
//  SALoginByPasswordViewModel.m
//  SuperApp
//
//  Created by Tia on 2022/9/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SALoginBaseViewModel.h"
#import "LKDataRecord.h"
#import "SAAppSwitchManager.h"
#import "SAAppleIDSignInProvider.h"
#import "SACacheManager.h"
#import "SACheckUserStatusRspModel.h"
#import "SAGetEncryptFactorRspModel.h"
#import "SAWechatGetAccessTokenRspModel.h"
#import "WXApiManager.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <HDServiceKit/RSACipher.h>
#import <KSInstantMessagingKit/KSInstMsgManager.h>
#import <WXApiObject.h>


@interface SALoginBaseViewModel () <SAAppleIDSignInProvider>
/// 苹果ID登陆
@property (nonatomic, strong) SAAppleIDSignInProvider *appleIDSignInProvider;

@end


@implementation SALoginBaseViewModel

//缓存标识
static NSString *const kCacheKeyLoginSkipSetPasswordHistory = @"kCacheKeyLoginSkipSetPasswordHistory";

#pragma mark public methods
- (void)loginWithplainPwd:(NSString *)plainPwd {
    @HDWeakify(self);
    [self.view showloading];
    [self loginWithAccountNo:self.fullAccountNo plainPwd:plainPwd success:^(SALoginRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];

        [self loginWithRspModel:rspModel];

        [LKDataRecord.shared loginWithType:LKDataRecordLoginTypePassword userId:SAUser.shared.operatorNo SPM:[LKSPM SPMWithPage:@"SALoginByPasswordViewController" area:@"" node:@""]];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

- (void)handleThirdParthLoginWithType:(SALoginByThirdPartyViewType)type {
    [self.view endEditing:YES];
    if (type == SALoginByThirdPartyViewTypeSMS) {
        [self SMSLogin];
    } else if (type == SALoginByThirdPartyViewTypePassword) {
        [self.view.viewController.navigationController popViewControllerAnimated:true];
    } else if (type == SALoginByThirdPartyViewTypeApple) {
        [self appleSignIn];
    } else if (type == SALoginByThirdPartyViewTypeFacebook) {
        [self fackbookLogin];
    } else if (type == SALoginByThirdPartyViewTypeWechat) {
        [WXApiManager.sharedManager sendLoginReqWithViewController:self.view.viewController];
    }
}

- (void)checkUserStatusWithCountryCode:(NSString *)countryCode accountNo:(NSString *)accountNo {
    @HDWeakify(self);
    [self.view showloading];
    [self checkUserStatusWithCountryCode:countryCode accountNo:accountNo success:^(SACheckUserStatusRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];

        NSMutableDictionary *params = @{@"countryCode": countryCode, @"accountNo": accountNo}.mutableCopy;

        //从忘记密码进来
        if ([self.smsCodeType isEqualToString:SASendSMSTypeResetPassword]) {
            if (rspModel.isRegistered) {
                [params addEntriesFromDictionary:@{@"smsCodeType": self.smsCodeType}];
                [HDMediator.sharedInstance navigaveToLoginByVerificationCodeViewController:params];
            } else {
                [NAT showAlertWithMessage:SALocalizedString(@"account_not_exist", @"账号不存在") buttonTitle:SALocalizedString(@"complete", @"Done")
                                  handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                                      [alertView dismiss];
                                  }];
            }
        } else if ([self.smsCodeType isEqualToString:SASendSMSTypeLogin] || [self.smsCodeType isEqualToString:SASendSMSTypeRegister]) {
            if (rspModel.isRegistered) {
                // 已注册，短信登陆
                //                                [params addEntriesFromDictionary:@{@"smsCodeType" : SASendSMSTypeLogin}];
            } else {
                // 未注册，接受验证码，注册
                [params addEntriesFromDictionary:@{@"isRealRegister": @true}];
            }
            [params addEntriesFromDictionary:@{@"smsCodeType": self.smsCodeType}];
            [HDMediator.sharedInstance navigaveToLoginByVerificationCodeViewController:params];
        } else { //第三方登录和注册
            [params addEntriesFromDictionary:@{@"channel": self.channel}];
            [params addEntriesFromDictionary:@{@"thirdToken": self.accessToken}];
            [params addEntriesFromDictionary:@{@"thirdUserName": self.thirdUserName}];
            [params addEntriesFromDictionary:@{@"isThirdPartyBinding": @"1"}];
            if (rspModel.isRegistered) {
                // 已注册，短信登陆
                //                [params addEntriesFromDictionary:@{@"smsCodeType" : SASendSMSTypeLogin}];
                [params addEntriesFromDictionary:@{@"smsCodeType": SASendSMSTypeThirdPartyActiveOperator}];
                //                [HDMediator.sharedInstance navigaveToLoginByVerificationCodeViewController:params];
            } else {
                // 未注册，接受验证码，注册
                //                [params addEntriesFromDictionary:@{@"smsCodeType" : SASendSMSTypeRegister}];
                [params addEntriesFromDictionary:@{@"smsCodeType": SASendSMSTypeThirdRegister}];
            }
            [HDMediator.sharedInstance navigaveToLoginByVerificationCodeViewController:params];
        }
    } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

/// im登录
- (void)loginWithRspModel:(SALoginRspModel *)rspModel {
    [SAUser loginWithPwdLoginRspModel:rspModel];

    if (![SAUser hasSignedIn])
        return;
    // im登录
    [KSInstMsgManager.share signinWithOperatorNo:rspModel.operatorNo storeNo:nil role:KSInstMsgRoleUser completion:^(NSError *_Nonnull error) {
        if (!error) {
            [NSNotificationCenter.defaultCenter postNotificationName:kNotificationNameIMLoginSuccess object:nil];
        } else {
            HDLog(@"IM登陆失败:%@", error.localizedDescription);
        }
    }];

    //特殊流程
    NSString *thirdPartyRegisterBindPhoneSwitch = [SAAppSwitchManager.shared switchForKey:SAAppSwitchThirdPartyBindPhone];
    if ([self.channel isEqualToString:SAThirdPartyBindChannelApple] && HDIsStringNotEmpty(thirdPartyRegisterBindPhoneSwitch) &&
        [thirdPartyRegisterBindPhoneSwitch.lowercaseString isEqualToString:@"on"]) {
        [SAWindowManager switchWindowToMainTabBarControllerCompletion:nil];
        [NAT showToastWithTitle:nil content:SALocalizedString(@"login_success", @"登录成功") type:HDTopToastTypeSuccess];
        return;
    }


    //新增跳过设置密码判断流程
    NSString *appSwitch = [SAAppSwitchManager.shared switchForKey:SAAppSwitchLoginSkipSetPassword];
    if (HDIsStringNotEmpty(appSwitch) && [appSwitch.lowercaseString isEqualToString:@"on"]) {
        [SAWindowManager switchWindowToMainTabBarControllerCompletion:nil];
        [NAT showToastWithTitle:nil content:SALocalizedString(@"login_success", @"登录成功") type:HDTopToastTypeSuccess];
        return;
    }


    BOOL goToSetPasswordVC = false;
    //登录时，判断是否设置密码，是否勾选了不再进入填写设置密码页面
    if (rspModel.hasLoginPwd == SAUserLoginPwdStateNotSet && self.smsCodeType == SASendSMSTypeLogin) {
        NSArray *array = [SACacheManager.shared objectForKey:kCacheKeyLoginSkipSetPasswordHistory];
        if (![array containsObject:self.fullAccountNo] || !array) {
            goToSetPasswordVC = true;
        }
    }

    if ((self.smsCodeType == SASendSMSTypeRegister && rspModel.hasLoginPwd == SAUserLoginPwdStateNotSet) || goToSetPasswordVC) {
        [HDMediator.sharedInstance navigaveToSetPasswordViewController:@{
            @"countryCode": self.countryCode,
            @"accountNo": self.accountNo,
            @"smsCodeType": self.smsCodeType,
            @"isRealRegister": @(self.isRealRegister),
        }];
    } else {
        [SAWindowManager switchWindowToMainTabBarControllerCompletion:nil];
        [NAT showToastWithTitle:nil content:SALocalizedString(@"login_success", @"登录成功") type:HDTopToastTypeSuccess];
    }
}

- (void)recordSkipSetpassword {
    HDLog(@"%s", __func__);
    NSArray *array = [SACacheManager.shared objectForKey:kCacheKeyLoginSkipSetPasswordHistory];
    if (![array containsObject:self.fullAccountNo] || !array) {
        NSMutableArray *mArr = [NSMutableArray arrayWithArray:array];
        [mArr addObject:self.fullAccountNo];
        [SACacheManager.shared setObject:mArr forKey:kCacheKeyLoginSkipSetPasswordHistory];
        HDLog(@"没有保存过");
    } else {
        HDLog(@"保存过了");
    }
}

#pragma mark - private methods
- (void)loginWithAccountNo:(NSString *)accountNo plainPwd:(NSString *)plainPwd success:(void (^)(SALoginRspModel *_Nonnull))successBlock failure:(CMNetworkFailureBlock)failureBlock {
    @HDWeakify(self);
    [self.getEncryptFactorDTO getEncryptFactorSuccess:^(SAGetEncryptFactorRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        NSString *pwdSecurityStr = [RSACipher encrypt:plainPwd publicKey:rspModel.publicKey];
        //            [self.userDTO loginWithAccountNo:accountNo encryptPwd:pwdSecurityStr index:rspModel.index success:successBlock failure:failureBlock];
        [self p_loginWithAccountNo:accountNo encryptPwd:pwdSecurityStr index:rspModel.index success:successBlock failure:failureBlock];
    } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
        !failureBlock ?: failureBlock(rspModel, errorType, error);
    }];
}

- (void)p_loginWithAccountNo:(NSString *)accountNo
                  encryptPwd:(NSString *)pwd
                       index:(NSString *)index
                     success:(void (^)(SALoginRspModel *rspModel))successBlock
                     failure:(CMNetworkFailureBlock)failureBlock {
    @HDWeakify(self);
    [SAGuardian getTokenWithTimeout:5000 completeHandler:^(NSString *_Nonnull token, NSInteger code, NSString *_Nonnull message) {
        @HDStrongify(self);
        [self.userDTO loginWithAccountNo:accountNo encryptPwd:pwd index:index riskToken:token success:successBlock failure:failureBlock];
    }];
}

/// SMS login
- (void)SMSLogin {
    NSMutableDictionary *params = @{@"countryCode": self.countryCode, @"accountNo": self.accountNo, @"smsCodeType": SASendSMSTypeLogin}.mutableCopy;
    [HDMediator.sharedInstance navigaveToLoginBySMSViewController:params];
}

/// apple sign id
- (void)appleSignIn {
    if (self.appleIDSignInProvider.isAvailable) {
        [self.appleIDSignInProvider start];
    }
}

/// fackbook
- (void)fackbookLogin {
    FBSDKLoginManager *manager = [[FBSDKLoginManager alloc] init];
    @HDWeakify(self);
    [manager logOut];
    [manager logInWithPermissions:@[@"public_profile", @"email"] fromViewController:self.view.viewController handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        @HDStrongify(self);
        HDLog(@"facebook登录结果，权限信息： %@, error = %@", result.grantedPermissions, error);
        if (error || result.isCancelled)
            return;
        HDLog(@"获取 token 成功：%@", result.token.tokenString);
        [FBSDKAccessToken setCurrentAccessToken:result.token];
        [self getUserInfoWithAuthResult:result];
    }];
}

///获取facebook昵称
- (void)getUserInfoWithAuthResult:(FBSDKLoginManagerLoginResult *)result {
    @HDWeakify(self);
    [FBSDKProfile loadCurrentProfileWithCompletion:^(FBSDKProfile *_Nullable profile, NSError *_Nullable error) {
        if (profile) {
            @HDStrongify(self);
            [self thirdPartLoginForChannel:SAThirdPartyBindChannelFacebook userId:result.token.userID authCode:result.authenticationToken.tokenString token:result.token.tokenString
                             thirdUserName:profile.name];
        }
    }];
}

///微信登录授权回调通知
- (void)receiveWechatAuthLoginResp:(NSNotification *)notification {
    if (!notification.object || ![notification.object isKindOfClass:SendAuthResp.class])
        return;
    SendAuthResp *resp = notification.object;
    if (resp.errCode != WXSuccess)
        return;
    [self.view showloading];
    @HDWeakify(self);
    [self.userDTO getWechatAccessTokenWithAuthCode:resp.code channel:SAThirdPartyBindChannelWechat success:^(SAWechatGetAccessTokenRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self thirdPartLoginForChannel:SAThirdPartyBindChannelWechat userId:rspModel.openId authCode:resp.code token:rspModel.accessToken thirdUserName:rspModel.nickName];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

/// 查询是否已经有绑定过的账号
- (void)thirdPartLoginForChannel:(SAThirdPartyBindChannel)channel
                          userId:(NSString *_Nonnull)userId
                        authCode:(NSString *_Nonnull)authCode
                           token:(NSString *_Nonnull)token
                   thirdUserName:(NSString *_Nullable)thirdUserName {
    NSString *thirdPartyRegisterBindPhoneSwitch = [SAAppSwitchManager.shared switchForKey:SAAppSwitchThirdPartyBindPhone];
    @HDWeakify(self);
    self.channel = channel;
    [self checkThirdPartyAccountBindStatusChannel:channel userId:userId success:^(SAThirdPartyAccountBindStatusRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        if (rspModel.isBind) {
            // TODO: 可能有问题
            self.smsCodeType = SASendSMSTypeLogin;
            // 三方登陆
            [self authLoginWithChannel:channel userId:userId authCode:authCode token:token];
        } else {
            if ([channel isEqualToString:SAThirdPartyBindChannelApple] && HDIsStringNotEmpty(thirdPartyRegisterBindPhoneSwitch) &&
                [thirdPartyRegisterBindPhoneSwitch.lowercaseString isEqualToString:@"on"]) {
                [self authRegisterWithChannel:channel userId:userId authCode:authCode accessToken:token];
            } else {
                [self.view dismissLoading];
                //第三方注册登录设置手机号码
                [HDMediator.sharedInstance
                    navigaveToForgotPasswordViewController:@{@"accessToken": token, @"channel": channel, @"thirdUserName": thirdUserName, @"smsCodeType": SASendSMSTypeThirdRegister}];
            }
        }
    } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

/// 查询用户第三方绑定状态
- (void)checkThirdPartyAccountBindStatusChannel:(SAThirdPartyBindChannel)channel
                                         userId:(NSString *)userId
                                        success:(void (^)(SAThirdPartyAccountBindStatusRspModel *rspModel))successBlock
                                        failure:(CMNetworkFailureBlock)failureBlock {
    [self.userDTO checkThirdPartyAccountBindStatusChannel:channel userId:userId success:successBlock failure:failureBlock];
}

/// 三方登陆
- (void)authLoginWithChannel:(SAThirdPartyBindChannel)channel userId:(NSString *_Nonnull)userId authCode:(NSString *_Nonnull)authCode token:(NSString *_Nonnull)token {
    @HDWeakify(self);
    [self authLoginWithChannel:channel userId:userId thirdToken:token success:^(SALoginRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];

        [self loginWithRspModel:rspModel];

        // 埋点相关
        NSUInteger authLoginType = 0;
        if ([channel isEqualToString:SAThirdPartyBindChannelApple]) {
            authLoginType = LKDataRecordLoginTypeAppleId;
        } else if ([channel isEqualToString:SAThirdPartyBindChannelWechat]) {
            authLoginType = LKDataRecordLoginTypeWechat;
        } else if ([channel isEqualToString:SAThirdPartyBindChannelFacebook]) {
            authLoginType = LKDataRecordLoginTypeFaceBook;
        } else {
            authLoginType = LKDataRecordLoginTypeCustomer;
        }

        [LKDataRecord.shared loginWithType:authLoginType userId:SAUser.shared.operatorNo SPM:[LKSPM SPMWithPage:@"SALoginByPasswordViewController" area:@"" node:@""]];
    } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

- (void)authLoginWithChannel:(SAThirdPartyBindChannel)channel
                      userId:(NSString *)userId
                  thirdToken:(NSString *)thirdToken
                     success:(void (^)(SALoginRspModel *_Nonnull))successBlock
                     failure:(CMNetworkFailureBlock)failureBlock {
    @HDWeakify(self);
    [SAGuardian getTokenWithTimeout:5000 completeHandler:^(NSString *_Nonnull token, NSInteger code, NSString *_Nonnull message) {
        @HDStrongify(self);
        [self.userDTO authLoginWithChannel:channel userId:userId thirdToken:thirdToken riskToken:token success:successBlock failure:failureBlock];
    }];
}

- (void)authRegisterWithChannel:(SAThirdPartyBindChannel)channel userId:(NSString *_Nonnull)userId authCode:(NSString *)authCode accessToken:(NSString *_Nonnull)accessToken {
    @HDWeakify(self);
    [self thirdPartyRegisterWithChannel:channel userId:userId accessToken:accessToken authCode:authCode success:^(SALoginRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        self.channel = SAThirdPartyBindChannelApple;

        [self loginWithRspModel:rspModel];

        //埋点相关
        NSUInteger authLoginType = 0;
        if ([channel isEqualToString:SAThirdPartyBindChannelApple]) {
            authLoginType = LKDataRecordLoginTypeAppleId;
        } else if ([channel isEqualToString:SAThirdPartyBindChannelWechat]) {
            authLoginType = LKDataRecordLoginTypeWechat;
        } else if ([channel isEqualToString:SAThirdPartyBindChannelFacebook]) {
            authLoginType = LKDataRecordLoginTypeFaceBook;
        } else {
            authLoginType = LKDataRecordLoginTypeCustomer;
        }
        [LKDataRecord.shared loginWithType:authLoginType userId:SAUser.shared.operatorNo SPM:[LKSPM SPMWithPage:@"SALoginByPasswordViewController" area:@"" node:@""]];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

- (void)thirdPartyRegisterWithChannel:(SAThirdPartyBindChannel)channel
                               userId:(NSString *_Nonnull)userId
                          accessToken:(NSString *_Nonnull)accessToken
                             authCode:(NSString *_Nonnull)authCode
                              success:(void (^)(SALoginRspModel *rspModel))successBlock
                              failure:(CMNetworkFailureBlock)failureBlock {
    @HDWeakify(self);
    [SAGuardian getTokenWithTimeout:5000 completeHandler:^(NSString *_Nonnull token, NSInteger code, NSString *_Nonnull message) {
        @HDStrongify(self);
        [self.userDTO thirdPartyRegisterWithChannel:channel userId:userId authCode:authCode accessToken:accessToken riskToken:token success:successBlock failure:failureBlock];
    }];
}

- (void)checkUserStatusWithCountryCode:(NSString *)countryCode
                             accountNo:(NSString *)accountNo
                               success:(void (^)(SACheckUserStatusRspModel *_Nonnull))successBlock
                               failure:(CMNetworkFailureBlock)failureBlock {
    [self.userDTO checkUserStatusWithCountryCode:countryCode accountNo:accountNo success:successBlock failure:failureBlock];
}

#pragma mark - SAAppleIDSignInProvider
- (void)appleIDSignInProvider:(SAAppleIDSignInProvider *)provider
    didCompleteWithCredential:(id<ASAuthorizationCredential>)credential
                         type:(ASAuthorizationCredentialType)type API_AVAILABLE(ios(13.0)) {
    NSString *userId;
    NSString *userName;
    NSString *accessToken;
    NSString *authCode;
    if (type == ASAuthorizationCredentialTypeAppleID) {
        // 用户登录使用ASAuthorizationAppleIDCredential
        ASAuthorizationAppleIDCredential *idCredential = (ASAuthorizationAppleIDCredential *)credential;
        userId = idCredential.user;

        if ([idCredential.authorizedScopes containsObject:ASAuthorizationScopeFullName]) {
            userName = idCredential.fullName.nickname;
        } else if ([idCredential.authorizedScopes containsObject:ASAuthorizationScopeEmail]) {
            userName = idCredential.email;
        } else {
            userName = @"";
        }
        NSData *identityToken = idCredential.identityToken;
        accessToken = [[NSString alloc] initWithData:identityToken encoding:NSUTF8StringEncoding];

        NSData *authorizationCode = idCredential.authorizationCode;
        authCode = [[NSString alloc] initWithData:authorizationCode encoding:NSUTF8StringEncoding];
        // 保存apple返回的唯一标识符
        HDLog(@"fullName:%@\nemail:%@", idCredential.fullName, idCredential.email);
        HDLog(@"userId:%@\naccessToken:%@\nauthCode:%@", userId, accessToken, authCode);

    } else if (type == ASAuthorizationCredentialTypePassword) {
        // 用户登录使用现有的密码凭证
        ASPasswordCredential *psdCredential = (ASPasswordCredential *)credential;
        // 密码凭证对象的用户标识 用户的唯一标识
        accessToken = psdCredential.user;
        userId = psdCredential.user;
        userName = psdCredential.user;
        NSString *psd = psdCredential.password;
        HDLog(@"psd user - %@   %@", psd, accessToken);
    }

    [self thirdPartLoginForChannel:SAThirdPartyBindChannelApple userId:userId authCode:authCode token:accessToken thirdUserName:userName];
}

- (void)appleIDSignInProvider:(SAAppleIDSignInProvider *)provider didCompleteWithError:(NSError *)error errorMsg:(nonnull NSString *)errorMsg API_AVAILABLE(ios(13.0)) {
    HDLog(@"appleIDSignIn - errorMsg: %@", errorMsg);
    if (error) {
        [NAT showToastWithTitle:nil content:errorMsg type:HDTopToastTypeError];
    }
}

- (void)appleIDSignInProvider:(SAAppleIDSignInProvider *)provider didReceivedCredentialRevokedNotification:(NSNotification *)notification {
    HDLog(@"didReceivedCredentialRevokedNotification: %@", notification.userInfo);
}

#pragma mark - setter
- (void)setLastLoginFullAccount:(NSString *)lastLoginFullAccount {
    _lastLoginFullAccount = lastLoginFullAccount;
    if (HDIsStringNotEmpty(lastLoginFullAccount)) {
        self.countryCode = [SAGeneralUtil getCountryCodeFromFullAccountNo:lastLoginFullAccount];
        self.accountNo = [SAGeneralUtil getShortAccountNoFromFullAccountNo:lastLoginFullAccount];
    }
}

#pragma mark - getter
- (NSString *)fullAccountNo {
    return [NSString stringWithFormat:@"%@%@", self.countryCode, self.accountNo];
}

#pragma mark - lazy load
- (SAGetEncryptFactorDTO *)getEncryptFactorDTO {
    return _getEncryptFactorDTO ?: ({ _getEncryptFactorDTO = SAGetEncryptFactorDTO.new; });
}

- (SAUserCenterDTO *)userDTO {
    if (!_userDTO) {
        _userDTO = SAUserCenterDTO.new;
    }
    return _userDTO;
}

- (SAAppleIDSignInProvider *)appleIDSignInProvider {
    if (!_appleIDSignInProvider) {
        _appleIDSignInProvider = SAAppleIDSignInProvider.new;
        _appleIDSignInProvider.delegate = self;
    }
    return _appleIDSignInProvider;
}

- (void)dealloc {
    HDLog(@"%s", __func__);
}

@end
