//
//  SALoginRspModel.h
//  SuperApp
//
//  Created by VanJay on 2020/4/9.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SARspModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 登录类型
typedef NS_ENUM(NSInteger, SALoginType) {
    SALoginTypeWithSMS = 0,
    SALoginTypeWithPassword = 1,
    SALoginTypeWithWechat = 2,
    SALoginTypeWithFacebook = 3,
    SALoginTypeWithAppleId = 4,
};

@interface SALoginRspModel : SARspModel
/// 用户名
@property (nonatomic, copy) NSString *loginName;
/// 昵称
@property (nonatomic, copy) NSString *nickName;
/// 头像地址
@property (nonatomic, copy) NSString *headURL;
/// 操作员编号
@property (nonatomic, copy) NSString *operatorNo;
/// 登录token
@property (nonatomic, copy) NSString *accessToken;
/// 刷新token
@property (nonatomic, copy) NSString *refreshToken;
/// 是否已设置登陆密码
@property (nonatomic, assign) SAUserLoginPwdState hasLoginPwd;

@property (nonatomic, assign) SALoginType lastLoginType;
/// 手机号码
@property (nonatomic, copy) NSString *mobile;

@end

NS_ASSUME_NONNULL_END
