//
//  SALoginByVerificationCodeViewModel.h
//  SuperApp
//
//  Created by Tia on 2022/9/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SALoginBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SALoginByVerificationCodeViewModel : SALoginBaseViewModel
/// 验证码回调
@property (nonatomic, copy) void (^callBack)(NSString *code);

/// 发送注册 登陆短信
/// @param countryCode 国家码
/// @param smsType 短信类型
/// @param accountNo 账号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getSMSCodeWithCountryCode:(NSString *)countryCode
                        accountNo:(NSString *)accountNo
                          smsType:(SASendSMSType)smsType
                          success:(void (^)(void))successBlock
                          failure:(CMNetworkFailureBlock)failureBlock;

/// 发送语音登陆短信
/// @param successBlock  成功回调
/// @param failureBlock  失败回调
/// @param smsType 短信类型
- (void)getVoiceCodeWithSmsType:(SASendSMSType)smsType success:(dispatch_block_t)successBlock failure:(CMNetworkFailureBlock)failureBlock;

/// 发送短信验证码
/// @param phoneNo 手机号
/// @param type 类型
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)sendSMSWithPhoneNo:(NSString *)phoneNo type:(SASendSMSType)type success:(dispatch_block_t)successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 验证短信验证码
/// @param smsCode 验证码
- (void)verifySMSCodeWithCode:(NSString *)smsCode;

@end

NS_ASSUME_NONNULL_END
