//
//  SACancellationApplicationVerifyIdentityViewModel.h
//  SuperApp
//
//  Created by Tia on 2022/6/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SACancellationApplicationVerifyIdentityViewModel : SAViewModel
/// 国家代码（855、86）
@property (nonatomic, copy, readonly) NSString *countryCode;
/// 账号（手机号）
@property (nonatomic, copy, readonly) NSString *accountNo;
/// 完整的账号（国家代码+手机号码）
@property (nonatomic, copy, readonly) NSString *fullAccountNo;
/// 上次登录成功的账号
@property (nonatomic, copy) NSString *lastLoginFullAccount;

/// 获取验证码
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)getSMSCodeWithSuccess:(dispatch_block_t)successBlock failure:(CMNetworkFailureBlock)failureBlock;

/// 校验验证码
/// @param smsCode 验证码
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)verifySMSCodeWithSmsCode:(NSString *)smsCode success:(void (^)(NSString *_Nullable apiTicket))successBlock failure:(CMNetworkFailureBlock)failureBlock;

/// 提交注销申请
/// @param apiTicket 短信验证凭证
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (void)submitCanncellationApplicationWithApiTicket:(NSString *)apiTicket success:(dispatch_block_t)successBlock failure:(CMNetworkFailureBlock)failureBlock;

@end

NS_ASSUME_NONNULL_END
