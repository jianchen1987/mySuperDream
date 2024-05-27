//
//  SALoginFrontPageViewModel.h
//  SuperApp
//
//  Created by Tia on 2023/6/14.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAViewModel.h"
#import "SAThirdPartyAccountBindStatusRspModel.h"
#import "SAGuardian.h"
#import "SAWindowManager.h"
#import "SAUserCenterDTO.h"

NS_ASSUME_NONNULL_BEGIN

///第三方类型
typedef NS_ENUM(NSUInteger, SALoginWithThirdPartyViewType) {
    //    SALoginWithThirdPartyViewTypeSMS = 0,      ///< 验证码登录
    //    SALoginWithThirdPartyViewTypePassword = 1, ///< 密码登录
    SALoginWithThirdPartyViewTypeApple = 0,    ///< apple
    SALoginWithThirdPartyViewTypeFacebook = 1, ///<  facebook
    SALoginWithThirdPartyViewTypeWechat = 2,   ///< 微信
};


@interface SALoginViewModel : SAViewModel
/// 完整号码
@property (nonatomic, copy, readonly) NSString *fullAccountNo;
/// 帐号
@property (nonatomic, copy) NSString *accountNo;
/// 国家代码
@property (nonatomic, copy) NSString *countryCode;
/// 验证码类型
@property (nonatomic, copy) SASendSMSType smsCodeType;
/// 用户中心DTO
@property (nonatomic, strong) SAUserCenterDTO *userDTO;
/// 渠道
@property (nonatomic, copy) NSString *channel;
/// 第三方注册 token
@property (nonatomic, copy) NSString *thirdToken;
/// 第三方用户名
@property (nonatomic, copy) NSString *thirdUserName;
/// accessToken
@property (nonatomic, copy) NSString *accessToken;
/// 是否为真的注册用户
@property (nonatomic) BOOL isRealRegister;
/// 上次登录成功的账号
@property (nonatomic, copy) NSString *lastLoginFullAccount;

@property (nonatomic, copy) dispatch_block_t facebookLoginFailBlock;

/// 账号密码登录
/// @param plainPwd 明文密码（内部处理加密逻辑）
- (void)loginWithplainPwd:(NSString *)plainPwd;

/// 检查手机号注册状态
/// @param countryCode 国家
/// @param accountNo 手机号
- (void)checkUserStatusWithCountryCode:(NSString *)countryCode accountNo:(NSString *)accountNo;

- (void)getVerificationCodeForLoginWithSmsByCountryCode:(NSString *)countryCode accountNo:(NSString *)accountNo;

/// 处理第三方登录
/// @param type 登录类型
- (void)handleThirdParthLoginWithType:(SALoginWithThirdPartyViewType)type;
/// 查询用户第三方绑定状态
- (void)checkThirdPartyAccountBindStatusV2WithChannel:(SAThirdPartyBindChannel)channel
                                               userId:(NSString *)userId
                                              success:(void (^)(SAThirdPartyAccountBindStatusRspModel *rspModel))successBlock
                                              failure:(CMNetworkFailureBlock)failureBlock;


- (void)loginWithRspModel:(SALoginRspModel *)rspModel;

@end

NS_ASSUME_NONNULL_END
