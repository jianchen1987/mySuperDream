//
//  SASetPasswordViewModel.h
//  SuperApp
//
//  Created by Tia on 2022/9/23.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SALoginBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SASetPasswordViewModel : SALoginBaseViewModel
/// 短信验证token
@property (nonatomic, copy) NSString *apiTicket;

/// 重置登录密码
/// @param plainPwd 明文密码（内部处理加密逻辑）
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)resetLoginPasswordWithPlainPwd:(NSString *)plainPwd success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock)failureBlock;

@end

NS_ASSUME_NONNULL_END
