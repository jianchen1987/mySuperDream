//
//  SALoginWithSMSViewController.m
//  SuperApp
//
//  Created by Tia on 2023/6/14.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SALoginWithSMSViewController.h"
#import "SALoginViewModel.h"
#import "SALoginAreaCodeView.h"
#import "SALoginByThirdPartySubView.h"
#import "SALoginByThirdPartyOrView.h"
#import "LKDataRecord.h"


@interface SALoginWithSMSViewController ()
/// VM
@property (nonatomic, strong) SALoginViewModel *viewModel;
/// 头部
@property (nonatomic, strong) UILabel *headerLabel;
/// 选择国家
@property (nonatomic, strong) SALoginAreaCodeView *changeCountryEntryView;
/// 帐号输入框
@property (nonatomic, strong) HDUITextField *accountTextField;
/// 登陆按钮
@property (nonatomic, strong) SAOperationButton *loginBTN;
/// 协议
@property (nonatomic, strong) YYLabel *agreementLB;

@property (nonatomic, strong) SALoginByThirdPartyOrView *orView;

@property (nonatomic, strong) SALoginByThirdPartySubView *accountView;

@end


@implementation SALoginWithSMSViewController


- (void)hd_setupViews {
    [self.view addSubview:self.headerLabel];
    [self.view addSubview:self.changeCountryEntryView];
    [self.view addSubview:self.accountTextField];
    [self.view addSubview:self.loginBTN];
    [self.view addSubview:self.agreementLB];

    [self.view addSubview:self.orView];
    [self.view addSubview:self.accountView];

    [LKDataRecord.shared tracePVEvent:@"SmsLoginPageView" parameters:nil SPM:nil];
}

- (void)hd_setupNavigation {
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.view];

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

- (void)updateViewConstraints {
    CGFloat margin = 12;
    CGFloat height = 44;

    [self.headerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hd_navigationBar.mas_bottom).offset(32);
        make.left.equalTo(self.view).offset(margin);
        make.right.equalTo(self.view).offset(margin);
    }];

    [self.changeCountryEntryView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(margin);
        make.height.equalTo(self.accountTextField.inputTextField.mas_height);
        make.top.equalTo(self.headerLabel.mas_bottom).offset(kRealWidth(20));
        make.centerY.equalTo(self.accountTextField.inputTextField.mas_centerY);
    }];

    [self.accountTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.changeCountryEntryView);
        make.left.equalTo(self.changeCountryEntryView.mas_right).offset(kRealWidth(16));
        make.right.equalTo(self.view).offset(-margin);
        make.height.mas_equalTo(55);
    }];

    [self.loginBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountTextField.mas_bottom).offset(24);
        make.centerX.mas_equalTo(self.view);
        make.width.equalTo(self.view).offset(-UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding));
        make.height.mas_equalTo(margin * 4);
    }];

    [self.agreementLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.left.mas_equalTo(margin);
        make.right.mas_equalTo(-margin);
        make.top.equalTo(self.loginBTN.mas_bottom).offset(24);
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
- (void)_fixNextStepBTNState {
    SACountryModel *model = self.changeCountryEntryView.currentCountryModel;
    BOOL isValid = model.isPhoneNumberValidBlock ? model.isPhoneNumberValidBlock(self.accountTextField.validInputText) : true;
    self.loginBTN.enabled = isValid;
}

- (void)_record:(NSString *)name page:(NSString *)pageName {
    if (!name || !pageName)
        return;
}


- (void)updateAgreementText {
    NSString *stringBlack1 = SALocalizedString(@"login_new2_User Agreement", @"《用户协议》");
    NSString *stringBlack2 = SALocalizedString(@"login_new2_Privacy Policy", @"《隐私政策》");
    NSString *stringGray = [NSString stringWithFormat:SALocalizedString(@"login_new2_tip9", @"创建/使用您的用户账号表示接受我们的 %@ 及 %@"), stringBlack1, stringBlack2];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:stringGray];

    text.yy_font = HDAppTheme.font.sa_standard12;
    text.yy_color = UIColor.sa_C666;

    [text yy_setTextHighlightRange:[stringGray rangeOfString:stringBlack1] color:UIColor.sa_C333 backgroundColor:[UIColor whiteColor]
                         tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
                             [HDMediator.sharedInstance navigaveToWebViewViewController:@{@"path": @"/mobile-h5/super/app/user/v1/legal-policies"}];
                         }];


    [text yy_setTextHighlightRange:[stringGray rangeOfString:stringBlack2] color:UIColor.sa_C333 backgroundColor:[UIColor whiteColor]
                         tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
                             [HDMediator.sharedInstance navigaveToWebViewViewController:@{@"path": @"/mobile-h5/super/app/user/v1/legal-policies"}];
                         }];

    [text addAttribute:NSFontAttributeName value:HDAppTheme.font.sa_standard12SB range:[stringGray rangeOfString:stringBlack1]];
    [text addAttribute:NSFontAttributeName value:HDAppTheme.font.sa_standard12SB range:[stringGray rangeOfString:stringBlack2]];

    [text addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:[stringGray rangeOfString:stringBlack1]];
    [text addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:[stringGray rangeOfString:stringBlack2]];

    self.agreementLB.attributedText = text;
    self.agreementLB.textAlignment = NSTextAlignmentCenter;
}

#pragma mark - event response
- (void)clickedLoginBTNHandler {
    [self.view endEditing:true];

    NSString *phoneNumber = self.accountTextField.validInputText;
    NSString *countryCode = self.changeCountryEntryView.currentCountryModel.countryCode;
    if (![phoneNumber hasPrefix:@"0"] && [countryCode isEqualToString:@"855"]) {
        phoneNumber = [@"0" stringByAppendingString:phoneNumber];
    }

    [self.viewModel getVerificationCodeForLoginWithSmsByCountryCode:countryCode accountNo:phoneNumber];

    [LKDataRecord.shared traceClickEvent:@"SmsLoginPageLoginClick" parameters:nil SPM:[LKSPM SPMWithPage:@"SALoginWithSMSViewController" area:@"" node:@""]];
}

#pragma mark - lazy load
- (UILabel *)headerLabel {
    if (!_headerLabel) {
        UILabel *label = UILabel.new;
        label.text = SALocalizedString(@"login_new2_Mobile registration or Sign in", @"手机号码注册或登录");
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:24 weight:UIFontWeightHeavy];
        label.hd_lineSpace = 12;
        label.textColor = HDAppTheme.color.sa_C333;
        _headerLabel = label;
    }
    return _headerLabel;
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
            [self _fixNextStepBTNState];

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

- (SAOperationButton *)loginBTN {
    if (!_loginBTN) {
        _loginBTN = [SAOperationButton buttonWithType:UIButtonTypeCustom];
        _loginBTN.titleLabel.font = HDAppTheme.font.sa_standard16H;
        [_loginBTN addTarget:self action:@selector(clickedLoginBTNHandler) forControlEvents:UIControlEventTouchUpInside];
        _loginBTN.enabled = false;
        [_loginBTN setTitle:SALocalizedString(@"login_new2_Get verification code", @"获取验证码") forState:UIControlStateNormal];
    }
    return _loginBTN;
}

- (YYLabel *)agreementLB {
    if (!_agreementLB) {
        _agreementLB = [[YYLabel alloc] init];
        _agreementLB.preferredMaxLayoutWidth = SCREEN_WIDTH - 24; //自适应高度
        _agreementLB.numberOfLines = 0;
        [self updateAgreementText];
    }
    return _agreementLB;
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

            [LKDataRecord.shared traceClickEvent:@"FastLoginPageSwitchAccountClick" parameters:nil SPM:[LKSPM SPMWithPage:@"SALoginWithSMSViewController" area:@"" node:@""]];
        };
        _accountView = v;
    }
    return _accountView;
}

- (SALoginViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = SALoginViewModel.new;
        // 获取上次登录成功的账号
        _viewModel.accountNo = [self.parameters objectForKey:@"accountNo"];
        _viewModel.countryCode = [self.parameters objectForKey:@"countryCode"];
        _viewModel.lastLoginFullAccount = SAUser.lastLoginFullAccount;
    }
    return _viewModel;
}

@end
