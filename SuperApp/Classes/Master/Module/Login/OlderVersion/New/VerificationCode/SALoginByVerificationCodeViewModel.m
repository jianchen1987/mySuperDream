//
//  SALoginByVerificationCodeViewModel.m
//  SuperApp
//
//  Created by Tia on 2022/9/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SALoginByVerificationCodeViewModel.h"
#import "LKDataRecord.h"
#import "SASMSCodeDTO.h"


@interface SALoginByVerificationCodeViewModel ()
/// 短信DTO
@property (nonatomic, strong) SASMSCodeDTO *smsDTO;

@end


@implementation SALoginByVerificationCodeViewModel

- (void)getSMSCodeWithCountryCode:(NSString *)countryCode
                        accountNo:(NSString *)accountNo
                          smsType:(SASendSMSType)smsType
                          success:(void (^)(void))successBlock
                          failure:(CMNetworkFailureBlock)failureBlock {
    /// 业务差异在vm里面处理
    if ([self.smsCodeType isEqualToString:SASendSMSTypeRegister] || [self.smsCodeType isEqualToString:SASendSMSTypeLogin]) {
        [self.smsDTO sendRegisterOrLoginSMSWithPhoneNo:self.fullAccountNo success:successBlock failure:failureBlock];
    } else {
        [self.smsDTO getSMSCodeWithCountryCode:self.countryCode accountNo:self.accountNo type:self.smsCodeType success:successBlock failure:failureBlock];
    }
}

- (void)getVoiceCodeWithSmsType:(SASendSMSType)smsType success:(dispatch_block_t)successBlock failure:(CMNetworkFailureBlock)failureBlock {
    /// 业务差异在vm里面处理
    if ([self.smsCodeType isEqualToString:SASendSMSTypeRegister] || [self.smsCodeType isEqualToString:SASendSMSTypeLogin]) {
        [self.smsDTO sendVoiceCodeByLoginWithPhoneNo:self.fullAccountNo success:successBlock failure:failureBlock];
    } else {
        [self.smsDTO sendVoiceCodeWithPhoneNo:self.fullAccountNo type:smsType success:successBlock failure:failureBlock];
    }
}

- (void)sendSMSWithPhoneNo:(NSString *)phoneNo type:(SASendSMSType)type success:(dispatch_block_t)successBlock failure:(CMNetworkFailureBlock)failureBlock {
    [self.smsDTO sendSMSWithPhoneNo:phoneNo type:type success:successBlock failure:failureBlock];
}

- (void)verifySMSCodeWithCode:(NSString *)smsCode {
    if ([self.smsCodeType isEqualToString:SASendSMSTypeValidateConsigneeMobile]) {
        if (self.callBack)
            self.callBack(smsCode);
        return;
    }

    @HDWeakify(self);
    [self.view showloading];
    if ([self.smsCodeType isEqualToString:SASendSMSTypeRegister] || [self.smsCodeType isEqualToString:SASendSMSTypeLogin]) {
        // 新用户注册，短信登陆 使用同一接口
        [SAGuardian getTokenWithTimeout:5000 completeHandler:^(NSString *_Nonnull token, NSInteger code, NSString *_Nonnull message) {
            @HDStrongify(self);
            @HDWeakify(self);
            [self.userDTO loginWithPhoneNo:self.fullAccountNo SmsCode:smsCode bizType:self.smsCodeType agreementNo:@"AG1139809824121798655" riskToken:token
                success:^(SALoginRspModel *_Nonnull rspModel) {
                    @HDStrongify(self);
                    [self.view dismissLoading];

                    [self loginWithRspModel:rspModel];

                    if ([self.smsCodeType isEqualToString:SASendSMSTypeLogin]) {
                        [LKDataRecord.shared loginWithType:LKDataRecordLoginTypeSms userId:SAUser.shared.operatorNo SPM:[LKSPM SPMWithPage:@"SALoginBySMSViewController" area:@"" node:@""]];
                    } else {
                        // 埋点
                        [self _dataRecord];
                    }
                } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
                    @HDStrongify(self);
                    [self.view dismissLoading];
                }];
        }];
    } else {
        // 其他业务，校验验证码返回token
        [self.smsDTO verifySMSCodeWithCountryCode:self.countryCode accountNo:self.accountNo type:self.smsCodeType smsCode:smsCode success:^(SAVerifySMSCodeRspModel *_Nonnull rspModel) {
            @HDStrongify(self);

            if ([self.smsCodeType isEqualToString:SASendSMSTypeResetPassword]) {
                @HDStrongify(self);
                [self.view dismissLoading];
                // 验证成功，跳转设置密码页面
                [HDMediator.sharedInstance navigaveToSetPasswordViewController:@{
                    @"countryCode": self.countryCode,
                    @"accountNo": self.accountNo,
                    @"apiTicket": rspModel.apiTicket,
                    @"smsCodeType": self.smsCodeType,
                }];
            } else {
                if ([SASendSMSTypeThirdRegister isEqualToString:self.smsCodeType] || [SASendSMSTypeThirdPartyActiveOperator isEqualToString:self.smsCodeType]) {
                    /// 三方登陆注册
                    [self _bindThirdPardAccountWithApiTicket:rspModel.apiTicket];
                } else {
                    [self.view dismissLoading];
                    [SAWindowManager switchWindowToMainTabBarController];
                }
                //埋点
                [self _dataRecord];
            }
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self.view dismissLoading];
        }];
    }
}

#pragma mark private methods
- (void)_bindThirdPardAccountWithApiTicket:(NSString *)apiTicket {
    @HDWeakify(self);
    // 已注册，激活流程
    if ([self.smsCodeType isEqualToString:SASendSMSTypeThirdPartyActiveOperator]) {
        [SAGuardian getTokenWithTimeout:5000 completeHandler:^(NSString *_Nonnull token, NSInteger code, NSString *_Nonnull message) {
            @HDStrongify(self);
            @HDWeakify(self);
            [self.userDTO activeOperatorWithAccount:self.fullAccountNo thirdToken:self.thirdToken thirdUserName:self.thirdUserName channel:self.channel apiTicket:apiTicket riskToken:token
                success:^(SALoginRspModel *_Nonnull rspModel) {
                    @HDStrongify(self);
                    [self.view dismissLoading];

                    [self loginWithRspModel:rspModel];
                } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
                    @HDStrongify(self);
                    [self.view dismissLoading];
                }];
        }];
    } else if ([self.smsCodeType isEqualToString:SASendSMSTypeThirdRegister]) {
        [SAGuardian getTokenWithTimeout:5000 completeHandler:^(NSString *_Nonnull token, NSInteger code, NSString *_Nonnull message) {
            @HDStrongify(self);
            @HDWeakify(self);
            [self.userDTO thirtPartyBindRegisterWithAccountNo:self.fullAccountNo thirdToken:self.thirdToken thirdUserName:self.thirdUserName channel:self.channel apiTicket:apiTicket riskToken:token
                success:^(SALoginRspModel *_Nonnull rspModel) {
                    @HDStrongify(self);
                    [self.view dismissLoading];

                    [self loginWithRspModel:rspModel];
                } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
                    @HDStrongify(self);
                    [self.view dismissLoading];
                }];
        }];
    }
}

///埋点
- (void)_dataRecord {
    if ([self.smsCodeType isEqualToString:SASendSMSTypeRegister] || [self.smsCodeType isEqualToString:SASendSMSTypeThirdRegister]) {
        NSString *activityNo = [NSUserDefaults.standardUserDefaults objectForKey:@"activityNo"];
        NSString *invitedCode = [NSUserDefaults.standardUserDefaults objectForKey:@"invitedCode"];
        NSString *channel = [NSUserDefaults.standardUserDefaults objectForKey:@"shareChannel"];
        NSMutableDictionary *tmp = [[NSMutableDictionary alloc] initWithCapacity:3];
        if (HDIsStringNotEmpty(activityNo)) {
            [tmp setObject:activityNo forKey:@"activityNo"];
        }
        if (HDIsStringNotEmpty(invitedCode)) {
            [tmp setObject:invitedCode forKey:@"invitedCode"];
        }
        if (HDIsStringNotEmpty(channel)) {
            [tmp setObject:channel forKey:@"channel"];
        }
        NSString *businessName = nil;
        if ([self.smsCodeType isEqualToString:SASendSMSTypeRegister]) {
            businessName = @"短信注册";
        } else {
            if ([self.channel isEqualToString:SAThirdPartyBindChannelApple]) {
                businessName = @"Apple注册";
            } else if ([self.channel isEqualToString:SAThirdPartyBindChannelWechat]) {
                businessName = @"微信注册";
            } else if ([self.channel isEqualToString:SAThirdPartyBindChannelFacebook]) {
                businessName = @"FaceBook注册";
            } else {
                businessName = @"";
            }
        }
        [LKDataRecord.shared traceEventGroup:LKEventGroupNameLogin event:@"register" name:businessName parameters:tmp SPM:nil];

    } else if ([self.smsCodeType isEqualToString:SASendSMSTypeThirdPartyActiveOperator]) {
        NSString *businessName = nil;
        if ([self.channel isEqualToString:SAThirdPartyBindChannelApple]) {
            businessName = @"Apple绑定";
        } else if ([self.channel isEqualToString:SAThirdPartyBindChannelWechat]) {
            businessName = @"微信绑定";
        } else if ([self.channel isEqualToString:SAThirdPartyBindChannelFacebook]) {
            businessName = @"FaceBook绑定";
        } else {
            businessName = @"";
        }
        [LKDataRecord.shared traceEventGroup:LKEventGroupNameLogin event:@"register" name:businessName parameters:nil SPM:nil];
    }
}

#pragma mark - lazy load
- (SASMSCodeDTO *)smsDTO {
    if (!_smsDTO) {
        _smsDTO = SASMSCodeDTO.new;
    }
    return _smsDTO;
}

@end
