//
//  SALoginByPasswordView.m
//  SuperApp
//
//  Created by Tia on 2022/9/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SALoginByPasswordView.h"
#import "LKDataRecord.h"
#import "SALoginAreaCodeView.h"
#import "SALoginBaseViewModel.h"
#import "SALoginByPasswordRightView.h"
#import "SALoginByThirdPartyView.h"


@interface SALoginByPasswordView ()
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
/// VM
@property (nonatomic, strong) SALoginBaseViewModel *viewModel;
/// rightView
@property (nonatomic, strong) SALoginByPasswordRightView *rightView;
/// 忘记密码按钮
@property (nonatomic, strong) UIButton *forgetBTN;

@property (nonatomic, strong) SALoginByThirdPartyView *thirdPartyView;

@end


@implementation SALoginByPasswordView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_setupViews {
    [self addSubview:self.headerLabel];
    [self addSubview:self.changeCountryEntryView];
    [self addSubview:self.accountTextField];
    [self addSubview:self.passwordTF];
    [self addSubview:self.loginBTN];
    [self addSubview:self.forgetBTN];
    [self addSubview:self.thirdPartyView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushSMSLoginNotification:) name:kNotificationNamePushSMSLoginViewController object:nil];

    [LKDataRecord.shared tracePVEvent:@"Password_Login_Page_PV" parameters:nil SPM:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)hd_bindViewModel {
    if (HDIsStringNotEmpty(self.viewModel.fullAccountNo)) {
        // 获取国家
        NSString *countryCode = [SAGeneralUtil getCountryCodeFromFullAccountNo:self.viewModel.fullAccountNo];
        NSString *shortAccountNo = [SAGeneralUtil getShortAccountNoFromFullAccountNo:self.viewModel.fullAccountNo];

        [self.changeCountryEntryView setCountryWithCountryCode:countryCode];
        if (!HDIsStringEmpty(countryCode)) {
            [self.accountTextField setTextFieldText:shortAccountNo];
        }
    }
}

- (void)updateConstraints {
    CGFloat margin = kRealWidth(12);

    [self.headerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kRealWidth(32));
        make.left.equalTo(self).offset(margin);
        make.right.equalTo(self).offset(margin);
    }];

    [self.changeCountryEntryView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(margin);
        make.height.equalTo(self.accountTextField.inputTextField.mas_height);
        make.top.equalTo(self.headerLabel.mas_bottom).offset(kRealWidth(20));
    }];

    [self.changeCountryEntryView.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.accountTextField.inputTextField.mas_centerY);
    }];

    [self.accountTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.changeCountryEntryView);
        make.left.equalTo(self.changeCountryEntryView.mas_right).offset(kRealWidth(16));
        make.right.equalTo(self).offset(-margin);
        make.height.mas_equalTo(55);
    }];

    [self.rightView sizeToFit];
    [self.passwordTF mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(margin);
        make.right.mas_equalTo(self).offset(-margin);
        make.height.mas_equalTo(55);
        make.top.mas_equalTo(self.accountTextField.mas_bottom);
    }];

    [self.loginBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTF.mas_bottom).offset(kRealWidth(32));
        make.centerX.mas_equalTo(self);
        make.width.equalTo(self).offset(-UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding));
        make.height.mas_equalTo(margin * 4);
    }];

    [self.forgetBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.loginBTN.mas_bottom).offset(kRealWidth(8));
    }];

    [self.thirdPartyView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.forgetBTN.mas_bottom);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-(kiPhoneXSeriesSafeBottomHeight + kRealWidth(8)));
    }];

    [super updateConstraints];
}

#pragma mark - private methods
- (void)fixLoginBtnState {
    self.loginBTN.enabled = self.passwordTF.validInputText.length >= 6;
}

#pragma mark - event response
- (void)clickedLoginBTNHandler {
    [self.window endEditing:true];

    NSString *phoneNumber = self.accountTextField.validInputText;
    NSString *countryCode = self.changeCountryEntryView.currentCountryModel.countryCode;
    if (![phoneNumber hasPrefix:@"0"] && [countryCode isEqualToString:@"855"]) {
        phoneNumber = [@"0" stringByAppendingString:phoneNumber];
    }

    self.viewModel.countryCode = countryCode;
    self.viewModel.accountNo = phoneNumber;

    [self.viewModel loginWithplainPwd:self.passwordTF.validInputText];

    //埋点
    [self _record:@"PasswordLoginPage_Login_click"];
}

- (void)pushSMSLoginNotification:(NSNotification *)noti {
    [self handleThirdParthLoginWithType:SALoginByThirdPartyViewTypeSMS];
}

- (void)handleThirdParthLoginWithType:(SALoginByThirdPartyViewType)type {
    if (type == SALoginByThirdPartyViewTypeSMS) {
        NSString *phoneNumber = self.accountTextField.validInputText;
        NSString *countryCode = self.changeCountryEntryView.currentCountryModel.countryCode;
        if (![phoneNumber hasPrefix:@"0"] && [countryCode isEqualToString:@"855"]) {
            phoneNumber = [@"0" stringByAppendingString:phoneNumber];
        }

        self.viewModel.countryCode = countryCode;
        self.viewModel.accountNo = phoneNumber;
    }
    [self.viewModel handleThirdParthLoginWithType:type];

    //埋点
    NSString *name;
    if (type == SALoginByThirdPartyViewTypeSMS) {
        name = @"PasswordLoginPage_SMS_Login_click";
    } else if (type == SALoginByThirdPartyViewTypeFacebook) {
        name = @"PasswordLoginPage_Facebook_Login_click";
    } else if (type == SALoginByThirdPartyViewTypeWechat) {
        name = @"PasswordLoginPage_WeChat_Login_click";
    } else if (type == SALoginByThirdPartyViewTypeApple) {
        name = @"PasswordLoginPage_APPLE_ID_Login_click";
    }
    [self _record:name];
}

- (void)_record:(NSString *)name {
    if (!name)
        return;

    [LKDataRecord.shared traceClickEvent:name parameters:nil SPM:[LKSPM SPMWithPage:@"SALoginByPasswordViewController" area:@"" node:@""]];
}

#pragma mark - lazy load
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
            [self fixLoginBtnState];
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
        [_loginBTN setTitle:SALocalizedString(@"login_new_SignIn", @"登录") forState:UIControlStateNormal];
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
            [self fixLoginBtnState];

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
            [self endEditing:YES];
            NSString *phoneNumber = self.accountTextField.validInputText;
            NSString *countryCode = self.changeCountryEntryView.currentCountryModel.countryCode;
            if (![phoneNumber hasPrefix:@"0"] && [countryCode isEqualToString:@"855"]) {
                phoneNumber = [@"0" stringByAppendingString:phoneNumber];
            }
            [HDMediator.sharedInstance navigaveToForgotPasswordViewController:@{@"countryCode": countryCode, @"smsCodeType": SASendSMSTypeResetPassword, @"accountNo": phoneNumber}];

            //埋点
            [self _record:@"PasswordLoginPage_Forgot_Password_click"];
        }];
        _forgetBTN = button;
    }
    return _forgetBTN;
}

- (SALoginByThirdPartyView *)thirdPartyView {
    if (!_thirdPartyView) {
        _thirdPartyView = SALoginByThirdPartyView.new;
        _thirdPartyView.showSmsLogin = true;
        @HDWeakify(self);
        _thirdPartyView.clickBlock = ^(SALoginByThirdPartyViewType type) {
            @HDStrongify(self);
            [self handleThirdParthLoginWithType:type];
        };
    }
    return _thirdPartyView;
}

@end
