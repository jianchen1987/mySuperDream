//
//  SAChangeLoginPwdViewModel.h
//  SuperApp
//
//  Created by VanJay on 2020/4/13.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAChangeLoginPwdViewModel : SAViewModel

/// 修改密码
/// @param oldPlainPwd 旧密码
/// @param plainPwd 密码
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)changeLoginPasswordWithOldPlainPwd:(NSString *)oldPlainPwd plainPwd:(NSString *)plainPwd success:(void (^)(void))successBlock failure:(CMNetworkFailureBlock)failureBlock;

@end

NS_ASSUME_NONNULL_END
