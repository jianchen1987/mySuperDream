//
//  SAUser.h
//  SuperApp
//
//  Created by VanJay on 2020/3/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACodingModel.h"
#import "SANotificationConst.h"

@class SALoginRspModel;
@class SAGetUserInfoRspModel;

NS_ASSUME_NONNULL_BEGIN


@interface SAUser : SACodingModel

#pragma mark - 基本信息
/// 用户名
@property (nonatomic, copy) NSString *loginName;
/// 昵称
@property (nonatomic, copy) NSString *nickName;
/// 头像地址
@property (nonatomic, copy) NSString *headURL;
/// 操作员编号
@property (nonatomic, copy) NSString *operatorNo;
@property (nonatomic, copy) NSString *education;      ///< 学历
@property (nonatomic, copy) NSString *birthday;       ///< 生日 毫秒
@property (nonatomic, copy) NSString *invitationCode; ///< 邀请码
@property (nonatomic, copy) SAGender gender;          ///< 性别
@property (nonatomic, copy) NSString *email;          ///< 邮箱
@property (nonatomic, copy) NSString *profession;     ///< 职业

/// 登录token
@property (nonatomic, copy) NSString *accessToken;
/// 刷新token
@property (nonatomic, copy) NSString *refreshToken;
/// deviceToken
@property (nonatomic, copy) NSString *deviceToken;

#pragma mark - 会员积分
///< 积分余额
@property (nonatomic, strong) NSNumber *pointBalance;
///< 会员等级
@property (nonatomic, assign) NSUInteger opLevel;
///< 会员名称
@property (nonatomic, copy) NSString *opLevelName;
///< 会员logo
@property (nonatomic, copy) NSString *memberLogo;

#pragma mark - 密码状态
/// 是否设置了登陆密码
@property (nonatomic, assign) SAUserLoginPwdState hasLoginPwd;
/// 是否设置了支付密码
@property (nonatomic, assign) BOOL tradePwdExist;

#pragma mark - 刷新token相关
/// 登录token 刷新时间
@property (atomic, strong) NSDate *accessTokenUpdateTime;

/// 最后一次登录的方式 0验证码登录，1为密码登录，2为wechat登录，3为Facebook登录，4为appleID登录
@property (nonatomic, assign) NSInteger lastLoginType;
/// 电话号码, 考虑老用户没有重新登陆的情况，优先使用[SAUser getUserMobile],判断用户有没有设置手机号码
@property (nonatomic, copy) NSString *mobile;

/// 联系电话
@property (nonatomic, copy) NSString *contactNumber;

/// 是否需要刷新 accessToken
- (BOOL)needUpdateAccessToken;
// 刷之前需要上锁，进入刷新队列
- (void)lockSessionCompletion:(void (^)(void))completion;
- (void)unlockSession;

/// 用户单例
+ (SAUser *)shared;

- (instancetype)init __attribute__((unavailable("Use +shared instead.")));

/// 是否已登入
+ (BOOL)hasSignedIn;

+ (void)logout;

/// 上次登录成功的完整帐号（不包括国家）
+ (NSString *__nullable)lastLoginAccount;

/// 上次登录成功的完整帐号（包括国家）
+ (NSString *__nullable)lastLoginFullAccount;

/// 上次登录成功的登录方式
+ (NSInteger)lastLoginUserType;

+ (NSString *)lastLoginUserHeadURL;

+ (NSString *)lastLoginUserShowName;

///判断用户有没有设置手机号码,
+ (NSString *)getUserMobile;

// 保存到缓存
- (void)save;
- (void)saveWithUserInfo:(SAGetUserInfoRspModel *_Nonnull)userInfoRsp;

/// 密码登录成功
+ (void)loginWithPwdLoginRspModel:(SALoginRspModel *)rspModel;

@end

NS_ASSUME_NONNULL_END
