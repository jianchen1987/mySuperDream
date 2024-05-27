//
//  SAUpdateUserInfoViewModel.h
//  SuperApp
//
//  Created by VanJay on 2020/4/12.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAUpdateUserInfoViewModel : SAViewModel

/// 更新用户信息
/// @param headURL 头像
/// @param nickName 昵称
/// @param email 邮箱
/// @param gender 性别
/// @param birthday 生日
/// @param profession 职业
/// @param education 学历
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
- (CMNetworkRequest *)updateUserInfoWithHeadURL:(NSString *_Nullable)headURL
                                       nickName:(NSString *_Nullable)nickName
                                          email:(NSString *_Nullable)email
                                         gender:(SAGender _Nullable)gender
                                       birthday:(NSString *_Nullable)birthday
                                     profession:(NSString *_Nullable)profession
                                      education:(NSString *_Nullable)education
                                        success:(void (^)(void))successBlock
                                        failure:(CMNetworkFailureBlock)failureBlock;

@end

NS_ASSUME_NONNULL_END
