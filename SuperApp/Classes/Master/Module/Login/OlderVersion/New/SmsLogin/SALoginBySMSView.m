//
//  SALoginBySMSView.m
//  SuperApp
//
//  Created by Tia on 2022/9/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SALoginBySMSView.h"
#import "LKDataRecord.h"
#import "SAAppSwitchManager.h"
#import "SALoginAreaCodeView.h"
#import "SALoginBaseViewModel.h"
#import "SALoginByPasswordRightView.h"
#import "SALoginByThirdPartyView.h"


@interface SALoginBySMSView ()
/// 头部
@property (nonatomic, strong) UILabel *headerLabel;
/// 选择国家
@property (nonatomic, strong) SALoginAreaCodeView *changeCountryEntryView;
/// 帐号输入框
@property (nonatomic, strong) HDUITextField *accountTextField;
/// 登陆按钮
@property (nonatomic, strong) SAOperationButton *loginBTN;

@property (nonatomic, strong) SALoginByThirdPartyView *thirdPartyView;
/// VM
@property (nonatomic, strong) SALoginBaseViewModel *viewModel;

@end


@implementation SALoginBySMSView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_setupViews {
    [self addSubview:self.headerLabel];
    [self addSubview:self.changeCountryEntryView];
    [self addSubview:self.accountTextField];
    [self addSubview:self.loginBTN];

    [self addSubview:self.thirdPartyView];

    if (self.viewModel.smsCodeType == SASendSMSTypeResetPassword || self.viewModel.smsCodeType == SASendSMSTypeThirdRegister) {
        self.thirdPartyView.hidden = true;
        if (self.viewModel.smsCodeType == SASendSMSTypeResetPassword) {
            [LKDataRecord.shared tracePVEvent:@"Forgot_Password_Page_PV" parameters:nil SPM:nil];
        }
    }
    if (self.viewModel.smsCodeType == SASendSMSTypeLogin) {
        [LKDataRecord.shared tracePVEvent:@"SMS_Login_Page_PV" parameters:nil SPM:nil];
    }
    if (self.viewModel.smsCodeType == SASendSMSTypeRegister) {
        [LKDataRecord.shared tracePVEvent:@"SMS_Registered_Page_PV" parameters:nil SPM:nil];
    }
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
        make.right.equalTo(self).offset(-margin);
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

    [self.loginBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountTextField.mas_bottom).offset(kRealWidth(32));
        make.centerX.mas_equalTo(self);
        make.width.equalTo(self).offset(-UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding));
        make.height.mas_equalTo(margin * 4);
    }];

    [self.thirdPartyView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginBTN.mas_bottom);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-(kiPhoneXSeriesSafeBottomHeight + kRealWidth(8)));
    }];

    [super updateConstraints];
}

#pragma mark - event response
- (void)clickedLoginBTNHandler {
    [self.window endEditing:true];

    NSString *phoneNumber = self.accountTextField.validInputText;
    NSString *countryCode = self.changeCountryEntryView.currentCountryModel.countryCode;
    if (![phoneNumber hasPrefix:@"0"] && [countryCode isEqualToString:@"855"]) {
        phoneNumber = [@"0" stringByAppendingString:phoneNumber];
    }

    //增加忘记密码页面【获取验证码】按钮点击事件
    if (self.viewModel.smsCodeType == SASendSMSTypeResetPassword && ![SAUser hasSignedIn]) {
        [self _record:@"ForgotPasswordPage_Get_Verification_Code_click" page:@"SAForgotPasswordViewController"];
    }

    //增加短信登录页面【获取验证码】按钮点击事件
    if (self.viewModel.smsCodeType == SASendSMSTypeLogin) {
        [self _record:@"SMSLoginPage_Get_Verification_Code_click" page:@"SALoginBySMSViewController"];
    }

    //增加短信注册页面【获取验证码】按钮点击事件
    if (self.viewModel.smsCodeType == SASendSMSTypeRegister) {
        [self _record:@"SMSRegisteredPage_Get_Verification_Code_click" page:@"SAForgotPasswordViewController"];
    }

    [self.viewModel checkUserStatusWithCountryCode:countryCode accountNo:phoneNumber];
}

#pragma mark - private methods
- (void)fixNextStepBTNState {
    SACountryModel *model = self.changeCountryEntryView.currentCountryModel;
    BOOL isValid = model.isPhoneNumberValidBlock ? model.isPhoneNumberValidBlock(self.accountTextField.validInputText) : true;
    self.loginBTN.enabled = isValid;
}

- (void)_record:(NSString *)name page:(NSString *)pageName {
    if (!name || !pageName)
        return;

    [LKDataRecord.shared traceClickEvent:name parameters:nil SPM:[LKSPM SPMWithPage:pageName area:@"" node:@""]];
}

#pragma mark - lazy load
- (UILabel *)headerLabel {
    if (!_headerLabel) {
        UILabel *label = UILabel.new;
        label.text = SALocalizedString(@"login_new_WelcomeBack", @"欢迎回来");
        if (self.viewModel.smsCodeType == SASendSMSTypeResetPassword || self.viewModel.smsCodeType == SASendSMSTypeThirdRegister || self.viewModel.smsCodeType == SASendSMSTypeRegister) {
            label.text = SALocalizedString(@"login_new_PleaseConfirmYourMobileNumber", @"请确认你的手机号码?");
        }
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:24 weight:UIFontWeightHeavy];
        label.hd_lineSpace = 12;
        label.textColor = HDAppTheme.color.sa_C333;
        _headerLabel = label;
    }
    return _headerLabel;
}

- (SAOperationButton *)loginBTN {
    if (!_loginBTN) {
        _loginBTN = [SAOperationButton buttonWithType:UIButtonTypeCustom];
        _loginBTN.titleLabel.font = HDAppTheme.font.sa_standard16H;
        [_loginBTN addTarget:self action:@selector(clickedLoginBTNHandler) forControlEvents:UIControlEventTouchUpInside];
        _loginBTN.enabled = false;
        [_loginBTN setTitle:SALocalizedString(@"login_new_GetVerificationCode", @"获取验证码") forState:UIControlStateNormal];
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
        config.bottomLineSelectedColor = config.bottomLineNormalColor;
        config.maxInputLength = self.changeCountryEntryView.currentCountryModel.maximumDigits;
        config.separatedFormat = self.changeCountryEntryView.currentCountryModel.phoneNumberFormat;
        config.textFieldTintColor = HDAppTheme.color.sa_C1;
        [textField setConfig:config];

        textField.inputTextField.attributedPlaceholder =
            [[NSMutableAttributedString alloc] initWithString:SALocalizedString(@"login_new_EnterMobileNumber", @"输入手机号码")
                                                   attributes:@{NSFontAttributeName: HDAppTheme.font.sa_standard14, NSForegroundColorAttributeName: HDAppTheme.color.sa_searchBarTextColor}];

        @HDWeakify(self);
        textField.textFieldDidChangeBlock = ^(NSString *text) {
            @HDStrongify(self);
            [self fixNextStepBTNState];

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

- (SALoginByThirdPartyView *)thirdPartyView {
    if (!_thirdPartyView) {
        _thirdPartyView = SALoginByThirdPartyView.new;
        _thirdPartyView.smsCodeType = self.viewModel.smsCodeType;
        if (self.viewModel.smsCodeType != SASendSMSTypeRegister) {
            _thirdPartyView.showPasswordLogin = true;
        }
        @HDWeakify(self);
        _thirdPartyView.clickBlock = ^(SALoginByThirdPartyViewType type) {
            @HDStrongify(self);
            [self.viewModel handleThirdParthLoginWithType:type];

            if (self.viewModel.smsCodeType == SASendSMSTypeLogin) {
                //埋点
                NSString *name;
                if (type == SALoginByThirdPartyViewTypePassword) {
                    name = @"SMSLoginPage_Password_Login_click";
                } else if (type == SALoginByThirdPartyViewTypeFacebook) {
                    name = @"SMSLoginPage_Facebook_Login_click";
                } else if (type == SALoginByThirdPartyViewTypeWechat) {
                    name = @"SMSLoginPage_WeChat_Login_click";
                } else if (type == SALoginByThirdPartyViewTypeApple) {
                    name = @"SMSLoginPage_APPLE_ID_Login_click";
                }
                [self _record:name page:@"SALoginBySMSViewController"];
            }

            if (self.viewModel.smsCodeType == SASendSMSTypeRegister) {
                //埋点
                NSString *name;
                if (type == SALoginByThirdPartyViewTypeFacebook) {
                    name = @"SMSRegisteredPage_Facebook_Registered_click";
                } else if (type == SALoginByThirdPartyViewTypeWechat) {
                    name = @"SMSRegisteredPage_WeChat_Registered_click";
                } else if (type == SALoginByThirdPartyViewTypeApple) {
                    name = @"SMSRegisteredPage_APPLE_ID_Registered_click";
                }
                [self _record:name page:@"SALoginBySMSViewController"];
            }
        };
    }
    return _thirdPartyView;
}

@end
