//
//  SALoginByThirdPartyView.h
//  SuperApp
//
//  Created by Tia on 2022/9/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN

///第三方类型
typedef NS_ENUM(NSUInteger, SALoginByThirdPartyViewType) {
    SALoginByThirdPartyViewTypeSMS = 0,      ///< 验证码登录
    SALoginByThirdPartyViewTypePassword = 1, ///< 密码登录
    SALoginByThirdPartyViewTypeApple = 2,    ///< apple
    SALoginByThirdPartyViewTypeFacebook = 3, ///<  facebook
    SALoginByThirdPartyViewTypeWechat = 4,   ///< 微信
};


@interface SALoginByThirdPartyView : SAView
/// 是否展示验证码登录
@property (nonatomic, assign) BOOL showSmsLogin;
/// 是否展示密码登录
@property (nonatomic, assign) BOOL showPasswordLogin;
///点击item回调
@property (nonatomic, copy) void (^clickBlock)(SALoginByThirdPartyViewType type);
/// 验证码类型
@property (nonatomic, copy) SASendSMSType smsCodeType;

@end

NS_ASSUME_NONNULL_END
