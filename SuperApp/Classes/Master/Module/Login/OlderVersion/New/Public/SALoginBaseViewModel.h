//
//  SALoginByPasswordViewModel.h
//  SuperApp
//
//  Created by Tia on 2022/9/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAGetEncryptFactorDTO.h"
#import "SAGuardian.h"
#import "SALoginByThirdPartyView.h"
#import "SALoginRspModel.h"
#import "SAThirdPartyAccountBindStatusRspModel.h"
#import "SAUserCenterDTO.h"
#import "SAViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SALoginBaseViewModel : SAViewModel
/// 帐号
@property (nonatomic, copy) NSString *accountNo;
/// 国家代码
@property (nonatomic, copy) NSString *countryCode;
/// 完整号码
@property (nonatomic, copy, readonly) NSString *fullAccountNo;
/// 上次登录成功的账号
@property (nonatomic, copy) NSString *lastLoginFullAccount;
/// 验证码类型
@property (nonatomic, copy) SASendSMSType smsCodeType;
/// 渠道
@property (nonatomic, copy) NSString *channel;
/// 第三方注册 token
@property (nonatomic, copy) NSString *thirdToken;
/// 第三方用户名
@property (nonatomic, copy) NSString *thirdUserName;
/// accessToken
@property (nonatomic, copy) NSString *accessToken;
/// 用户中心DTO
@property (nonatomic, strong) SAUserCenterDTO *userDTO;
/// 获取加密因子 VM
@property (nonatomic, strong) SAGetEncryptFactorDTO *getEncryptFactorDTO;
/// 账号密码登录
/// @param plainPwd 明文密码（内部处理加密逻辑）
- (void)loginWithplainPwd:(NSString *)plainPwd;
/// 处理第三方登录
/// @param type 登录类型
- (void)handleThirdParthLoginWithType:(SALoginByThirdPartyViewType)type;
/// 检查手机号注册状态
/// @param countryCode 国家
/// @param accountNo 手机号
- (void)checkUserStatusWithCountryCode:(NSString *)countryCode accountNo:(NSString *)accountNo;
/// im登录
/// @param rspModel 登录模型
- (void)loginWithRspModel:(SALoginRspModel *)rspModel;
/// 记录跳过密码设置的账号
- (void)recordSkipSetpassword;
/// 是否为真的注册用户
@property (nonatomic) BOOL isRealRegister;

@end

NS_ASSUME_NONNULL_END
