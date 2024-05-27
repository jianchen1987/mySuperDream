//
//  SAForgetLoginPwdSetPwdViewModel.h
//  SuperApp
//
//  Created by VanJay on 2020/4/6.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAForgetLoginPwdSetPwdViewModel : SAViewModel
/// 帐号
@property (nonatomic, copy) NSString *accountNo;
/// 国家代码
@property (nonatomic, copy) NSString *countryCode;
/// 短信验证token
@property (nonatomic, copy) NSString *apiTicket;
/// 完整号码
@property (nonatomic, copy, readonly) NSString *fullAccountNo;

/// 重置登录密码
/// @param plainPwd 明文密码（内部处理加密逻辑）
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)resetLoginPasswordWithPlainPwd:(NSString *)plainPwd success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock)failureBlock;

@end

NS_ASSUME_NONNULL_END
