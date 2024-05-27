//
//  SASMSCodeDTO.h
//  SuperApp
//
//  Created by VanJay on 2020/4/13.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAVerifySMSCodeRspModel.h"
#import "SAViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SASMSCodeDTO : SAViewModel

/// 发送短信验证码 (旧）
/// @param countryCode 国家
/// @param accountNo 手机号
/// @param type 类型
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getSMSCodeWithCountryCode:(NSString *)countryCode accountNo:(NSString *)accountNo type:(SASendSMSType)type success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock)failureBlock;

/// 校验短信验证码 （旧）
/// @param countryCode 国家
/// @param accountNo 手机号
/// @param type 类型
/// @param smsCode 验证码
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)verifySMSCodeWithCountryCode:(NSString *)countryCode
                           accountNo:(NSString *)accountNo
                                type:(SASendSMSType)type
                             smsCode:(NSString *)smsCode
                             success:(void (^)(SAVerifySMSCodeRspModel *rspModel))successBlock
                             failure:(CMNetworkFailureBlock)failureBlock;
/// 发送注册或登陆短信
/// @param phoneNo 手机号码
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)sendRegisterOrLoginSMSWithPhoneNo:(NSString *)phoneNo success:(void (^_Nullable)(void))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 发送短信验证码
/// @param phoneNo 手机号
/// @param type 类型
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)sendSMSWithPhoneNo:(NSString *)phoneNo type:(SASendSMSType)type success:(CMNetworkSuccessVoidBlock)successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 发送语音验证码
/// @param phoneNo 手机号
/// @param type 类型
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)sendVoiceCodeWithPhoneNo:(NSString *)phoneNo type:(SASendSMSType)type success:(dispatch_block_t)successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock;

/// 发送语音验证码（用于登录注册）
/// @param phoneNo 手机号
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)sendVoiceCodeByLoginWithPhoneNo:(NSString *)phoneNo success:(dispatch_block_t)successBlock failure:(CMNetworkFailureBlock)failureBlock;

@end

NS_ASSUME_NONNULL_END
