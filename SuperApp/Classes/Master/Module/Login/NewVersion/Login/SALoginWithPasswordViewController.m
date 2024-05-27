//
//  SALoginWithPasswordViewController.m
//  SuperApp
//
//  Created by Tia on 2023/6/14.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SALoginWithPasswordViewController.h"
#import "LKDataRecord.h"
#import "SALoginAreaCodeView.h"
#import "SALoginViewModel.h"
#import "SALoginByPasswordRightView.h"
#import "SALoginByThirdPartySubView.h"
#import "SALoginByThirdPartyOrView.h"


@interface SALoginWithPasswordViewController ()
/// 头部
@property (nonatomic, strong) UILabel *headerLabel;
/// 选择国家
@property (nonatomic, strong) SALoginAreaCodeView *changeCountryEntryView;

/// 帐号输入框
@property (nonatomic, strong) HDUITextField *accountTextField;
/// 密码输入框
@property (nonatomic, strong) HDUITextField *passwordTF;
/// 登陆按钮
@property (nonatomic, strong) SAOperationButton *loginBTN;
/// rightView
@property (nonatomic, strong) SALoginByPasswordRightView *rightView;
/// 忘记密码按钮
@property (nonatomic, strong) UIButton *forgetBTN;

@property (nonatomic, strong) SALoginByThirdPartyOrView *orView;

@property (nonatomic, strong) SALoginByThirdPartySubView *accountView;
/// VM
@property (nonatomic, strong) SALoginViewModel *viewModel;

@end


@implementation SALoginWithPasswordViewController

- (void)hd_setupViews {
    [self.view addSubview:self.headerLabel];
    [self.view addSubview:self.changeCountryEntryView];
    [self.view addSubview:self.accountTextField];
    [self.view addSubview:self.passwordTF];
    [self.view addSubview:self.loginBTN];
    [self.view addSubview:self.forgetBTN];

    [self.view addSubview:self.orView];
    [self.view addSubview:self.accountView];

    [LKDataRecord.shared tracePVEvent:@"PasswordLoginPageView" parameters:nil SPM:nil];
    //密码登录失败超过五次跳转到验证码登录页面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushSMSLoginNotification:) name:kNotificationNamePushSMSLoginViewController object:nil];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNamePushSMSLoginViewController object:nil];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.view];
    // 获取国家
    NSString *countryCode = [SAGeneralUtil getCountryCodeFromFullAccountNo:self.viewModel.fullAccountNo];
    NSString *shortAccountNo = [SAGeneralUtil getShortAccountNoFromFullAccountNo:self.viewModel.fullAccountNo];

    [self.changeCountryEntryView setCountryWithCountryCode:countryCode];
    if (!HDIsStringEmpty(countryCode)) {
        [self.accountTextField setTextFieldText:shortAccountNo];
    }
}

- (void)updateViewConstraints {
    CGFloat margin = 12;
    CGFloat height = 44;

    [self.headerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hd_navigationBar.mas_bottom).offset(32);
        make.left.equalTo(self.view).offset(margin);
        make.right.equalTo(self.view).offset(-margin);
    }];

    [self.changeCountryEntryView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(margin);
        make.height.equalTo(self.accountTextField.inputTextField.mas_height);
        make.centerY.equalTo(self.accountTextField.inputTextField.mas_centerY);
    }];

    [self.accountTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.changeCountryEntryView);
        make.left.equalTo(self.changeCountryEntryView.mas_right).offset(kRealWidth(16));
        make.right.equalTo(self.view).offset(-margin);
        make.height.mas_equalTo(55);
        make.top.equalTo(self.headerLabel.mas_bottom).offset(kRealWidth(20));
    }];

    [self.rightView sizeToFit];
    [self.passwordTF mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(margin);
        make.right.mas_equalTo(self.view).offset(-margin);
        make.height.mas_equalTo(55);
        make.top.mas_equalTo(self.accountTextField.mas_bottom);
    }];

    [self.loginBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTF.mas_bottom).offset(kRealWidth(32));
        make.centerX.mas_equalTo(self.view);
        make.width.equalTo(self.view).offset(-UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding));
        make.height.mas_equalTo(margin * 4);
    }];

    [self.forgetBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.loginBTN.mas_bottom).offset(kRealWidth(8));
    }];

    [self.orView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(22);
        make.left.mas_equalTo(margin);
        make.right.mas_equalTo(-margin);
        make.bottom.equalTo(self.accountView.mas_top).offset(-18);
    }];

    [self.accountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
        make.left.mas_equalTo(margin);
        make.right.mas_equalTo(-margin);
        make.bottom.mas_offset(-kiPhoneXSeriesSafeBottomHeight - 32);
    }];

    [super updateViewConstraints];
}

#pragma mark - config
- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return true;
}

#pragma mark - private methods
- (void)_fixLoginBtnState {
    self.loginBTN.enabled = self.passwordTF.validInputText.length >= 6;
}

- (void)_record:(NSString *)name {
    if (!name)
        return;

    //    [LKDataRecord.shared traceClickEvent:name parameters:nil SPM:[LKSPM SPMWithPage:@"SALoginWithPasswordViewController" area:@"" node:@""]];
}

#pragma mark - event response
- (void)clickedLoginBTNHandler {
    [self.view endEditing:true];

    NSString *phoneNumber = self.accountTextField.validInputText;
    NSString *countryCode = self.changeCountryEntryView.currentCountryModel.countryCode;
    if (![phoneNumber hasPrefix:@"0"] && [countryCode isEqualToString:@"855"]) {
        phoneNumber = [@"0" stringByAppendingString:phoneNumber];
    }

    self.viewModel.countryCode = countryCode;
    self.viewModel.accountNo = phoneNumber;

    [self.viewModel loginWithplainPwd:self.passwordTF.validInputText];

    [LKDataRecord.shared traceClickEvent:@"PasswordLoginPageLoginClick" parameters:nil SPM:[LKSPM SPMWithPage:@"SALoginWithPasswordViewController" area:@"" node:@""]];
}
//密码登录失败超过五次跳转到验证码登录页面
- (void)pushSMSLoginNotification:(NSNotification *)noti {
    [HDMediator.sharedInstance navigaveToLoginWithSMSViewController:@{}];
}

#pragma mark - lazy load
- (SALoginViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = SALoginViewModel.new;
        // 获取上次登录成功的账号
        _viewModel.lastLoginFullAccount = SAUser.lastLoginFullAccount;
    }
    return _viewModel;
}

- (UILabel *)headerLabel {
    if (!_headerLabel) {
        UILabel *label = UILabel.new;
        label.text = SALocalizedString(@"login_new_WelcomeBack", @"欢迎回来");
        label.font = [UIFont systemFontOfSize:24 weight:UIFontWeightHeavy];
        label.textColor = HDAppTheme.color.sa_C333;
        _headerLabel = label;
    }
    return _headerLabel;
}

- (HDUITextField *)passwordTF {
    if (!_passwordTF) {
        HDUITextField *textField = [[HDUITextField alloc] initWithPlaceholder:nil rightLabelString:nil];

        HDUITextFieldConfig *config = [textField getCurrentConfig];
        config.font = [HDAppTheme.font sa_fontDINBold:18];
        config.textColor = HDAppTheme.color.sa_C333;
        config.maxInputLength = 20;
        config.secureTextEntry = YES;
        config.floatingText = @" ";
        config.characterSetString = kCharacterSetStringNumberAndLetterAndSpecialCharacters;
        config.rightLabelFont = HDAppTheme.font.standard3;
        config.rightLabelColor = HDAppTheme.color.C1;
        config.bottomLineSelectedColor = config.bottomLineNormalColor;
        config.textFieldTintColor = HDAppTheme.color.sa_C1;
        [textField setConfig:config];

        textField.inputTextField.attributedPlaceholder =
            [[NSMutableAttributedString alloc] initWithString:SALocalizedString(@"login_new_EnterPassword", @"输入密码")
                                                   attributes:@{NSFontAttributeName: HDAppTheme.font.sa_standard14, NSForegroundColorAttributeName: HDAppTheme.color.sa_searchBarTextColor}];
        HDKeyBoardTheme *theme = HDKeyBoardTheme.new;
        theme.enterpriseText = SALocalizedString(@"keyboard_brand_title", @"WOWNOW 安全键盘");
        HDKeyBoard *kb = [HDKeyBoard keyboardWithType:HDKeyBoardTypeLetterCapableCanSwitchToASCII theme:theme];

        kb.inputSource = textField.inputTextField;
        textField.inputTextField.inputView = kb;

        @HDWeakify(self);
        textField.textFieldDidChangeBlock = ^(NSString *text) {
            @HDStrongify(self);
            [self _fixLoginBtnState];
        };
        CGSize rightViewSize = [self.rightView layoutImmediately];
        self.rightView.frame = CGRectMake(0, 0, rightViewSize.width, rightViewSize.height);
        [textField setCustomRightView:self.rightView];
        _passwordTF = textField;
    }
    return _passwordTF;
}

- (SALoginByPasswordRightView *)rightView {
    if (!_rightView) {
        _rightView = SALoginByPasswordRightView.new;
        @HDWeakify(self);
        _rightView.showPlainPwdButtonClickedHandler = ^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            btn.selected = !btn.isSelected;
            self.passwordTF.inputTextField.secureTextEntry = !btn.isSelected;
        };
    }
    return _rightView;
}

- (SAOperationButton *)loginBTN {
    if (!_loginBTN) {
        _loginBTN = [SAOperationButton buttonWithType:UIButtonTypeCustom];
        _loginBTN.titleLabel.font = HDAppTheme.font.sa_standard16H;
        [_loginBTN addTarget:self action:@selector(clickedLoginBTNHandler) forControlEvents:UIControlEventTouchUpInside];
        _loginBTN.enabled = false;
        [_loginBTN setTitle:SALocalizedString(@"login_new2_SignIn", @"登录") forState:UIControlStateNormal];
    }
    return _loginBTN;
}

- (SALoginAreaCodeView *)changeCountryEntryView {
    if (!_changeCountryEntryView) {
        _changeCountryEntryView = SALoginAreaCodeView.new;
        @HDWeakify(self);
        _changeCountryEntryView.choosedCountryBlock = ^(SACountryModel *_Nonnull model) {
            @HDStrongify(self);
            // 清空
            [self.accountTextField setTextFieldText:@""];
            [self.accountTextField updateConfigWithDict:@{@"separatedFormat": model.phoneNumberFormat, @"maxInputLength": @(model.maximumDigits)}];
        };
    }
    return _changeCountryEntryView;
}

- (HDUITextField *)accountTextField {
    if (!_accountTextField) {
        HDUITextField *textField = [[HDUITextField alloc] initWithPlaceholder:nil leftLabelString:nil];
        HDUITextFieldConfig *config = [textField getCurrentConfig];
        config.font = [HDAppTheme.font sa_fontDINBold:18];
        config.textColor = HDAppTheme.color.sa_C333;
        config.shouldSeparatedTextWithSymbol = YES;
        config.floatingText = @" ";
        config.characterSetString = kCharacterSetStringNumber;
        config.maxInputLength = self.changeCountryEntryView.currentCountryModel.maximumDigits;
        config.separatedFormat = self.changeCountryEntryView.currentCountryModel.phoneNumberFormat;
        config.bottomLineSelectedColor = config.bottomLineNormalColor;
        config.textFieldTintColor = HDAppTheme.color.sa_C1;
        [textField setConfig:config];

        textField.inputTextField.attributedPlaceholder =
            [[NSMutableAttributedString alloc] initWithString:SALocalizedString(@"login_new_EnterMobileNumber", @"输入手机号码")
                                                   attributes:@{NSFontAttributeName: HDAppTheme.font.sa_standard14, NSForegroundColorAttributeName: HDAppTheme.color.sa_searchBarTextColor}];

        @HDWeakify(self);
        textField.textFieldDidChangeBlock = ^(NSString *text) {
            @HDStrongify(self);
            [self _fixLoginBtnState];

            if (text.length <= 1) {
                SACountryModel *model = self.changeCountryEntryView.currentCountryModel;
                if ([text hasPrefix:@"0"]) {
                    [self.accountTextField updateConfigWithDict:@{@"separatedFormat": model.zeroPrefixPhoneNumberFormat, @"maxInputLength": @(model.maximumDigits)}];
                } else {
                    [self.accountTextField updateConfigWithDict:@{@"separatedFormat": model.phoneNumberFormat, @"maxInputLength": @(model.maximumDigits)}];
                }
            }
        };
        _accountTextField = textField;
    }
    return _accountTextField;
}

- (UIButton *)forgetBTN {
    if (!_forgetBTN) {
        @HDWeakify(self);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:SALocalizedString(@"login_new_ForgetPassword", @"忘记密码") attributes:@{
            NSFontAttributeName: HDAppTheme.font.sa_standard12M,
            NSForegroundColorAttributeName: HDAppTheme.color.sa_C333,
            NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]
        }];

        [button setAttributedTitle:string forState:UIControlStateNormal];
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self.view endEditing:YES];
            NSString *phoneNumber = self.accountTextField.validInputText;
            NSString *countryCode = self.changeCountryEntryView.currentCountryModel.countryCode;
            if (![phoneNumber hasPrefix:@"0"] && [countryCode isEqualToString:@"855"]) {
                phoneNumber = [@"0" stringByAppendingString:phoneNumber];
            }
            [HDMediator.sharedInstance navigaveToForgetPasswordOrBindPhoneViewController:@{@"countryCode": countryCode, @"smsCodeType": SASendSMSTypeResetPassword, @"accountNo": phoneNumber}];

            //埋点
            //            [self _record:@"PasswordLoginPage_Forgot_Password_click"];
        }];
        _forgetBTN = button;
    }
    return _forgetBTN;
}

- (SALoginByThirdPartyOrView *)orView {
    if (!_orView) {
        _orView = SALoginByThirdPartyOrView.new;
    }
    return _orView;
}

- (SALoginByThirdPartySubView *)accountView {
    if (!_accountView) {
        SALoginByThirdPartySubView *v = [SALoginByThirdPartySubView loginHomePageViewWithText:SALocalizedString(@"login_new2_Switch account or register", @"切换账号或注册") iconName:nil];
        @HDWeakify(self);
        v.clickBlock = ^{
            @HDStrongify(self);
            [self.navigationController popViewControllerAnimated:YES];
            [LKDataRecord.shared traceClickEvent:@"PasswordLoginPageSwitchAccountClick" parameters:nil SPM:[LKSPM SPMWithPage:@"SALoginWithPasswordViewController" area:@"" node:@""]];
        };
        _accountView = v;
    }
    return _accountView;
}

@end
