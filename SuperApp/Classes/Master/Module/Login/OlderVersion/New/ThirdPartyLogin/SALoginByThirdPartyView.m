//
//  SALoginByThirdPartyView.m
//  SuperApp
//
//  Created by Tia on 2022/9/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SALoginByThirdPartyView.h"
#import "SAAppSwitchManager.h"
#import "SALoginByThirdPartySubView.h"
#import "SALoginByThirdPartyTopView.h"
#import "SAPayHelper.h"


@interface SALoginByThirdPartyView ()

@property (nonatomic, strong) SALoginByThirdPartyTopView *topView;

@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) SALoginByThirdPartySubView *smsView;
@property (nonatomic, strong) SALoginByThirdPartySubView *passwordView;
@property (nonatomic, strong) SALoginByThirdPartySubView *appleView;
@property (nonatomic, strong) SALoginByThirdPartySubView *facebookView;
@property (nonatomic, strong) SALoginByThirdPartySubView *wechatView;
/// 协议
@property (nonatomic, strong) YYLabel *agreementLB;

@end


@implementation SALoginByThirdPartyView

- (void)hd_setupViews {
    [self addSubview:self.agreementLB];
    [self addSubview:self.stackView];
    [self addSubview:self.topView];

    if (@available(iOS 13.0, *)) { //苹果登录iOS13之后才支持
        self.appleView.hidden = false;
    }

    NSString *wechatSwitch = [SAAppSwitchManager.shared switchForKey:SAAppSwitchWechatLogin];
    if (HDIsStringNotEmpty(wechatSwitch) && [wechatSwitch isEqualToString:@"on"]) {
        if ([SAPayHelper isSupportWechatPayAppNotInstalledHandler:nil appNotSupportApiHandler:nil]) {
            self.wechatView.hidden = false;
        }
    }

    NSString *thirdPartLoginSwitch = [SAAppSwitchManager.shared switchForKey:SAAppSwitchThirdPartLogin];
    if (thirdPartLoginSwitch && [thirdPartLoginSwitch isEqualToString:@"on"]) {
    } else {
        // 先隐藏
        self.appleView.hidden = true;
        self.facebookView.hidden = true;
        self.wechatView.hidden = true;
    }
}

- (void)updateConstraints {
    CGFloat margin = kRealWidth(12);
    CGFloat height = kRealWidth(44);

    [self.agreementLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.left.mas_equalTo(kRealWidth(20));
        make.right.mas_equalTo(-kRealWidth(20));
        make.bottom.equalTo(self);
    }];

    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.agreementLB.mas_top).offset(-margin);
        make.left.mas_equalTo(margin);
        make.right.mas_equalTo(-margin);
    }];

    [self.smsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
        make.width.equalTo(self.stackView);
    }];
    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
        make.width.equalTo(self.stackView);
    }];
    [self.appleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
        make.width.equalTo(self.stackView);
    }];
    [self.facebookView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
        make.width.equalTo(self.stackView);
    }];

    [self.wechatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
        make.width.equalTo(self.stackView);
    }];

    [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.mas_equalTo(margin);
        make.right.mas_equalTo(-margin);
        make.bottom.equalTo(self.stackView.mas_top);
    }];

    [super updateConstraints];
}

- (void)updateAgreementText {
    NSString *stringGray = SALocalizedString(@"login_new_agreement_tip", @"登录本系统表明已同意 用户协议 及 隐私政策");
    NSString *stringBlack1 = SALocalizedString(@"login_new_agreement_tip_key1", @"用户协议");
    NSString *stringBlack2 = SALocalizedString(@"login_new_agreement_tip_key2", @"隐私政策");
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:stringGray];

    text.yy_font = HDAppTheme.font.sa_standard11;
    text.yy_color = HDAppTheme.color.sa_C999;

    [text yy_setTextHighlightRange:[stringGray rangeOfString:stringBlack1] color:HDAppTheme.color.sa_C1 backgroundColor:[UIColor whiteColor]
                         tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
                             [HDMediator.sharedInstance navigaveToWebViewViewController:@{@"path": @"/mobile-h5/super/app/user/v1/legal-policies"}];
                         }];

    [text yy_setTextHighlightRange:[stringGray rangeOfString:stringBlack2] color:HDAppTheme.color.sa_C1 backgroundColor:[UIColor whiteColor]
                         tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
                             [HDMediator.sharedInstance navigaveToWebViewViewController:@{@"path": @"/mobile-h5/super/app/user/v1/legal-policies"}];
                         }];
    self.agreementLB.attributedText = text;
    self.agreementLB.textAlignment = NSTextAlignmentLeft;
}

#pragma mark - setter
- (void)setShowSmsLogin:(BOOL)showSmsLogin {
    _showSmsLogin = showSmsLogin;
    self.smsView.hidden = !showSmsLogin;
}

- (void)setShowPasswordLogin:(BOOL)showPasswordLogin {
    _showPasswordLogin = showPasswordLogin;
    self.passwordView.hidden = !showPasswordLogin;
}

- (void)setSmsCodeType:(SASendSMSType)smsCodeType {
    _smsCodeType = smsCodeType;
    if (smsCodeType == SASendSMSTypeRegister) {
        self.appleView.label.text = SALocalizedString(@"login_new_registrationAPPLEID", @"APPLE ID注册");
        self.wechatView.label.text = SALocalizedString(@"login_new_registrationWechat", @"微信注册");
        self.facebookView.label.text = SALocalizedString(@"login_new_registrationFacebook", @"Facebook注册");
    }
}

#pragma mark - lazy load
- (YYLabel *)agreementLB {
    if (!_agreementLB) {
        _agreementLB = [[YYLabel alloc] init];
        _agreementLB.preferredMaxLayoutWidth = SCREEN_WIDTH - kRealWidth(40); //自适应高度
        _agreementLB.numberOfLines = 0;
        [self updateAgreementText];
    }
    return _agreementLB;
}

- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.smsView, self.passwordView, self.appleView, self.facebookView, self.wechatView]];
        _stackView.axis = UILayoutConstraintAxisVertical;
        _stackView.spacing = kRealWidth(8);
    }
    return _stackView;
}

- (SALoginByThirdPartySubView *)smsView {
    if (!_smsView) {
        SALoginByThirdPartySubView *v = [SALoginByThirdPartySubView viewWithText:SALocalizedString(@"login_new_SMSSignIn", @"短信登录") iconName:@"icon_login_msg"];
        @HDWeakify(self);
        v.clickBlock = ^{
            @HDStrongify(self);
            !self.clickBlock ?: self.clickBlock(SALoginByThirdPartyViewTypeSMS);
        };
        _smsView = v;
        _smsView.hidden = true;
    }
    return _smsView;
}

- (SALoginByThirdPartySubView *)passwordView {
    if (!_passwordView) {
        SALoginByThirdPartySubView *v = [SALoginByThirdPartySubView viewWithText:SALocalizedString(@"login_new_SignInPassword", @"密码登录") iconName:@"icon_login_password"];
        @HDWeakify(self);
        v.clickBlock = ^{
            @HDStrongify(self);
            !self.clickBlock ?: self.clickBlock(SALoginByThirdPartyViewTypePassword);
        };
        _passwordView = v;
        _passwordView.hidden = true;
    }
    return _passwordView;
}

- (SALoginByThirdPartySubView *)appleView {
    if (!_appleView) {
        SALoginByThirdPartySubView *v = [SALoginByThirdPartySubView viewWithText:SALocalizedString(@"login_new_SignInWithAPPLEID", @"APPLE ID 登录") iconName:@"icon_login_apple"];
        @HDWeakify(self);
        v.clickBlock = ^{
            @HDStrongify(self);
            !self.clickBlock ?: self.clickBlock(SALoginByThirdPartyViewTypeApple);
        };
        _appleView = v;
        _appleView.hidden = true;
    }
    return _appleView;
}

- (SALoginByThirdPartySubView *)facebookView {
    if (!_facebookView) {
        SALoginByThirdPartySubView *v = [SALoginByThirdPartySubView viewWithText:SALocalizedString(@"login_new_SignInWithFacebook", @"Facebook登录") iconName:@"icon_login_facebook"];
        @HDWeakify(self);
        v.clickBlock = ^{
            @HDStrongify(self);
            !self.clickBlock ?: self.clickBlock(SALoginByThirdPartyViewTypeFacebook);
        };
        _facebookView = v;
    }
    return _facebookView;
}

- (SALoginByThirdPartySubView *)wechatView {
    if (!_wechatView) {
        SALoginByThirdPartySubView *v = [SALoginByThirdPartySubView viewWithText:SALocalizedString(@"login_new_SignInWithWechat", @"微信登录") iconName:@"icon_login_wechat"];
        @HDWeakify(self);
        v.clickBlock = ^{
            @HDStrongify(self);
            !self.clickBlock ?: self.clickBlock(SALoginByThirdPartyViewTypeWechat);
        };
        _wechatView = v;
        _wechatView.hidden = true;
    }
    return _wechatView;
}

- (SALoginByThirdPartyTopView *)topView {
    if (!_topView) {
        _topView = SALoginByThirdPartyTopView.new;
    }
    return _topView;
}

@end
