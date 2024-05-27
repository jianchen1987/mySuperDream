//
//  SAForgotPasswordView.m
//  SuperApp
//
//  Created by Tia on 2022/9/23.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SASetPasswordView.h"
#import "LKDataRecord.h"
#import "SAAppSwitchManager.h"
#import "SACacheManager.h"
#import "SALoginByPasswordViewController.h"
#import "SALogoTitleHeaderView.h"
#import "SAPasswordSettingOptionViewController.h"
#import "SASetPasswordViewModel.h"


@interface SASetPasswordView () <HDUITextFieldDelegate>
/// 标题
@property (nonatomic, strong) UILabel *headerLabel;
/// 子标题
@property (nonatomic, strong) UILabel *headerDetailLabel;
/// 密码输入框
@property (nonatomic, strong) HDUITextField *passwordTF;
/// 确认密码输入框
@property (nonatomic, strong) HDUITextField *confirmPwdTF;

@property (nonatomic, strong) HDUIButton *tipButton;
/// 确定按钮
@property (nonatomic, strong) SAOperationButton *confirmBTN;
/// VM
@property (nonatomic, strong) SASetPasswordViewModel *viewModel;

@property (nonatomic, strong) UIImageView *iv1;
@property (nonatomic, strong) UIImageView *iv2;
@property (nonatomic, strong) UIImageView *iv3;
@property (nonatomic, strong) UIImageView *iv4;

@property (nonatomic, strong) UILabel *l1;
@property (nonatomic, strong) UILabel *l2;
@property (nonatomic, strong) UILabel *l3;
@property (nonatomic, strong) UILabel *l4;

@end


@implementation SASetPasswordView

- (void)dealloc {
    if (self.tipButton.selected) {
        //增加短信登录-设置密码页面【后续不再提醒】按钮点击事件
        if (self.viewModel.smsCodeType == SASendSMSTypeLogin) {
            [self _record:@"SMSLoginPage_Set_Password_Page_No_longer_remind_click" page:@"SALoginBySMSViewController"];
        }
        //增加短信注册-设置密码页面【后续不再提醒】按钮点击事件
        if (self.viewModel.smsCodeType == SASendSMSTypeRegister) {
            [self _record:@"SMSRegisteredPage_Set_Password_Page_No_longer_remind_click" page:@"SALoginBySMSViewController"];
        }
        [self.viewModel recordSkipSetpassword];
    }
}

- (void)hd_setupViews {
    [self addSubview:self.headerLabel];
    [self addSubview:self.headerDetailLabel];
    [self addSubview:self.passwordTF];
    [self addSubview:self.confirmPwdTF];

    [self addSubview:self.confirmBTN];
    [self addSubview:self.tipButton];

    [self addSubview:self.iv1];
    [self addSubview:self.iv2];
    [self addSubview:self.iv3];
    [self addSubview:self.iv4];

    [self addSubview:self.l1];
    [self addSubview:self.l2];
    [self addSubview:self.l3];
    [self addSubview:self.l4];

    if (self.viewModel.smsCodeType == SASendSMSTypeResetPassword) {
        self.tipButton.hidden = true;
    }

    if (self.viewModel.smsCodeType == SASendSMSTypeResetPassword) {
        [LKDataRecord.shared tracePVEvent:@"Forgot_PasswordPage_Set_Password_Page_PV" parameters:nil SPM:nil];
    } else if (self.viewModel.smsCodeType == SASendSMSTypeLogin) {
        [LKDataRecord.shared tracePVEvent:@"SMSLoginPage_Set_Password_Page_PV" parameters:nil SPM:nil];
    } else if (self.viewModel.smsCodeType == SASendSMSTypeRegister) {
        [LKDataRecord.shared tracePVEvent:@"SMSRegisteredPage_Set_Password_Page_PV" parameters:nil SPM:nil];
    }
}

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_languageDidChanged {
    self.passwordTF.inputTextField.attributedPlaceholder =
        [[NSMutableAttributedString alloc] initWithString:SALocalizedString(@"login_new_EnterNewSignInPassword", @"输入新登录密码")
                                               attributes:@{NSFontAttributeName: HDAppTheme.font.sa_standard14, NSForegroundColorAttributeName: HDAppTheme.color.sa_searchBarTextColor}];

    self.confirmPwdTF.inputTextField.attributedPlaceholder =
        [[NSMutableAttributedString alloc] initWithString:SALocalizedString(@"login_new_ReEnterNewSignInPassword", @"再次输入新登录密码")
                                               attributes:@{NSFontAttributeName: HDAppTheme.font.sa_standard14, NSForegroundColorAttributeName: HDAppTheme.color.sa_searchBarTextColor}];

    [self.confirmBTN setTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons") forState:UIControlStateNormal];

    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    CGFloat margin = kRealWidth(12);

    [self.headerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kRealWidth(32));
        make.left.equalTo(self).offset(margin);
        make.right.equalTo(self).offset(margin);
    }];

    [self.headerDetailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerLabel.mas_bottom).offset(kRealWidth(8));
        make.left.equalTo(self).offset(margin);
        make.right.equalTo(self).offset(-margin);
    }];

    [self.passwordTF mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(HDAppTheme.value.padding.left);
        make.right.mas_equalTo(self).offset(-HDAppTheme.value.padding.right);
        make.height.mas_equalTo(60);
        make.top.mas_equalTo(self.headerDetailLabel.mas_bottom).offset(kRealWidth(48));
    }];

    [self.confirmPwdTF mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.left.mas_equalTo(self.passwordTF);
        make.top.mas_equalTo(self.passwordTF.mas_bottom).offset(kRealWidth(5));
    }];

    [self.confirmBTN sizeToFit];
    [self.confirmBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(margin * 4);
        make.width.mas_equalTo(self).offset(-UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding));
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self).offset(-(kiPhoneXSeriesSafeBottomHeight + kRealWidth(8)));
    }];
    [self.tipButton sizeToFit];
    [self.tipButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(HDAppTheme.value.padding.left);
        make.bottom.mas_equalTo(self.confirmBTN.mas_top).offset(-kRealWidth(8));
    }];

    [self.iv1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.left.mas_equalTo(margin);
        make.top.equalTo(self.confirmPwdTF.mas_bottom).offset(margin);
    }];

    [self.l1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iv1).offset(2);
        make.left.equalTo(self.iv1.mas_right).offset(4);
        make.right.mas_equalTo(-margin);
    }];

    [self.iv2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.left.equalTo(self.iv1);
        make.top.greaterThanOrEqualTo(self.l1.mas_bottom).offset(4);
        make.top.greaterThanOrEqualTo(self.iv1.mas_bottom).offset(4);
    }];

    [self.l2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iv2).offset(2);
        make.left.equalTo(self.iv2.mas_right).offset(4);
        make.right.mas_equalTo(-margin);
    }];

    [self.iv3 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.left.equalTo(self.iv2);
        make.top.greaterThanOrEqualTo(self.l2.mas_bottom).offset(4);
        make.top.greaterThanOrEqualTo(self.iv2.mas_bottom).offset(4);
    }];

    [self.l3 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iv3).offset(2);
        make.left.equalTo(self.iv3.mas_right).offset(4);
        make.right.mas_equalTo(-margin);
    }];

    [self.iv4 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.left.equalTo(self.iv3);
        make.top.greaterThanOrEqualTo(self.l3.mas_bottom).offset(4);
        make.top.greaterThanOrEqualTo(self.iv3.mas_bottom).offset(4);
    }];

    [self.l4 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iv4).offset(2);
        make.left.equalTo(self.iv4.mas_right).offset(4);
        make.right.mas_equalTo(-margin);
    }];

    [super updateConstraints];
}

#pragma mark - HDUITextFieldDelegate
- (void)hd_textFieldDidEndEditing:(UITextField *)textField {
    [self _fixconfirmBTNState];
}

#pragma mark - private methods
- (void)_fixconfirmBTNState {
    NSInteger length1 = self.passwordTF.validInputText.length;
    NSInteger length2 = self.confirmPwdTF.validInputText.length;

    if (length1 > 0) {
        self.iv2.image = [UIImage imageNamed:@"icon_login_check_success"];
        if (length1 < 6 || length1 > 20) {
            self.iv1.image = [UIImage imageNamed:@"icon_login_check_fail"];
        } else {
            self.iv1.image = [UIImage imageNamed:@"icon_login_check_success"];
        }

        BOOL result = self.passwordTF.validInputText.hd_isValidPasswordIgnoreLength;
        if (result) {
            self.iv3.image = [UIImage imageNamed:@"icon_login_check_success"];
        } else {
            self.iv3.image = [UIImage imageNamed:@"icon_login_check_fail"];
        }

    } else {
        self.iv1.image = [UIImage imageNamed:@"icon_login_check_success_default"];
        self.iv2.image = [UIImage imageNamed:@"icon_login_check_success_default"];
        self.iv3.image = [UIImage imageNamed:@"icon_login_check_success_default"];
    }

    if (length1 > 0 && length2 > 0) {
        if ([self.passwordTF.validInputText isEqualToString:self.confirmPwdTF.validInputText]) {
            self.iv4.image = [UIImage imageNamed:@"icon_login_check_success"];
        } else {
            self.iv4.image = [UIImage imageNamed:@"icon_login_check_fail"];
        }
    } else {
        self.iv4.image = [UIImage imageNamed:@"icon_login_check_success_default"];
    }

    self.confirmBTN.enabled = self.passwordTF.validInputText.length >= 6 && self.confirmPwdTF.validInputText.length >= 6;
}

- (HDUITextField *)passwordTextField {
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

    HDKeyBoardTheme *theme = HDKeyBoardTheme.new;
    theme.enterpriseText = SALocalizedString(@"keyboard_brand_title", @"WOWNOW 安全键盘");
    HDKeyBoard *kb = [HDKeyBoard keyboardWithType:HDKeyBoardTypeLetterCapableCanSwitchToASCII theme:theme];
    kb.inputSource = textField.inputTextField;
    textField.inputTextField.inputView = kb;

    // 设置眼睛按钮
    HDUIButton *eyeBTN = [HDUIButton buttonWithType:UIButtonTypeCustom];
    eyeBTN.adjustsButtonWhenHighlighted = false;
    [eyeBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
        btn.selected = !btn.isSelected;
        textField.inputTextField.secureTextEntry = !btn.isSelected;
    }];
    [eyeBTN setImage:[UIImage imageNamed:@"icon_login_password_hide"] forState:UIControlStateNormal];
    [eyeBTN setImage:[UIImage imageNamed:@"icon_login_password_show"] forState:UIControlStateSelected];

    [eyeBTN sizeToFit];
    [textField setCustomRightView:eyeBTN];
    textField.delegate = self;
    return textField;
}

#pragma mark - event response
- (void)clickedConfirmBTNHandler {
    [self endEditing:true];

    // 判断密码是否有效
    if (![self.passwordTF.validInputText isEqualToString:self.confirmPwdTF.validInputText]) {
        [self.passwordTF setTextFieldText:@""];
        [self.confirmPwdTF setTextFieldText:@""];

        [NAT showToastWithTitle:nil content:SALocalizedString(@"password_set_not_pair_tip", @"两次密码输入不一致") type:HDTopToastTypeWarning];
        return;
    }
    // 判断新密码是否符合正则，由于先判断是否一致，所以这里只需要判断一个即可
    if (!self.passwordTF.validInputText.hd_isValidPassword) {
        [NAT showToastWithTitle:nil content:SALocalizedString(@"password_vaild_desc", @"必须是6-20个英文字母、数字或符号（除空格外），至少包含两种的组合。") type:HDTopToastTypeWarning];
        return;
    }

    //增加忘记密码-设置密码页面【确定】按钮点击事件
    if (self.viewModel.smsCodeType == SASendSMSTypeResetPassword && ![SAUser hasSignedIn]) {
        [self _record:@"ForgotPasswordPage_Confirm_click" page:@"SAForgotPasswordViewController"];
    }

    //增加短信登录-设置密码页面【确定】按钮点击事件
    if (self.viewModel.smsCodeType == SASendSMSTypeLogin) {
        [self _record:@"SMSLoginPage_Set_Password_Page_Confirm_click" page:@"SALoginBySMSViewController"];
    }

    //增加短信注册-设置密码页面【确定】按钮点击事件
    if (self.viewModel.smsCodeType == SASendSMSTypeRegister) {
        [self _record:@"SMSRegisteredPage_Set_Password_Page_Confirm_click" page:@"SALoginBySMSViewController"];
    }

    [self showloading];
    @HDWeakify(self);
    [self.viewModel resetLoginPasswordWithPlainPwd:self.confirmPwdTF.validInputText success:^{
        @HDStrongify(self);
        [self dismissLoading];
        if (self.viewModel.smsCodeType == SASendSMSTypeResetPassword) {
            [self resetSuccess];
        } else {
            //判断是否为设置密码页进入
            BOOL result = false;
            NSArray *viewControllers = self.viewController.navigationController.viewControllers;
            for (UIViewController *vc in viewControllers) {
                if ([vc isKindOfClass:SAPasswordSettingOptionViewController.class]) {
                    result = true;
                    break;
                }
            }
            [NAT showToastWithTitle:nil content:SALocalizedString(@"password_setting_success", @"登录密码设置成功") type:HDTopToastTypeSuccess];
            SAUser.shared.hasLoginPwd = SAUserLoginPwdStateSetted;
            [SAUser.shared save];
            if (result) {
                [self.viewController.navigationController popToViewControllerClass:SAPasswordSettingOptionViewController.class];
            } else {
                [SAWindowManager switchWindowToMainTabBarControllerCompletion:nil];
            }
        }
    } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}

- (void)resetSuccess {
    [HDTips showSuccess:SALocalizedString(@"login_new_SetPassword_tip6", @"密码设置成功，请使用新密码登录") hideAfterDelay:3 iconImageName:@"icon_setPassword_success"];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 去密码输入页
        if ([SAUser hasSignedIn]) {
            [SAUser logout];
            [SAWindowManager switchWindowToLoginByPasswordViewController];
            [self.viewController.navigationController popToRootViewControllerAnimated:NO];
        } else {
            if (![self.viewController.navigationController popToViewControllerClass:SALoginByPasswordViewController.class]) {
                [self.viewController.navigationController popToRootViewControllerAnimated:YES];
            }
        }
    });
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
        label.text = SALocalizedString(@"login_new_remind", @"Remind");
        label.font = [UIFont systemFontOfSize:24 weight:UIFontWeightHeavy];
        label.textColor = HDAppTheme.color.sa_C333;
        _headerLabel = label;
    }
    return _headerLabel;
}

- (UILabel *)headerDetailLabel {
    if (!_headerDetailLabel) {
        UILabel *label = UILabel.new;
        label.font = HDAppTheme.font.sa_standard12;
        label.textColor = HDAppTheme.color.sa_C999;
        label.numberOfLines = 0;
        label.hd_lineSpace = 6;
        label.text = SALocalizedString(@"login_new_SetPassword_tip5", @"提醒：为了避免账号丢失无法登录，建议您设置登录密码！");
        _headerDetailLabel = label;
    }
    return _headerDetailLabel;
}

- (HDUITextField *)passwordTF {
    if (!_passwordTF) {
        _passwordTF = self.passwordTextField;
    }
    return _passwordTF;
}

- (HDUITextField *)confirmPwdTF {
    if (!_confirmPwdTF) {
        _confirmPwdTF = self.passwordTextField;
    }
    return _confirmPwdTF;
}

- (SAOperationButton *)confirmBTN {
    if (!_confirmBTN) {
        _confirmBTN = [SAOperationButton buttonWithType:UIButtonTypeCustom];
        [_confirmBTN addTarget:self action:@selector(clickedConfirmBTNHandler) forControlEvents:UIControlEventTouchUpInside];
        _confirmBTN.enabled = false;
    }
    return _confirmBTN;
}

- (HDUIButton *)tipButton {
    if (!_tipButton) {
        _tipButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _tipButton.spacingBetweenImageAndTitle = 4;
        [_tipButton setTitle:SALocalizedString(@"login_new_StopReminder", @"不再提醒") forState:UIControlStateNormal];
        [_tipButton setImage:[UIImage imageNamed:@"icon_login_choose_default"] forState:UIControlStateNormal];
        [_tipButton setImage:[UIImage imageNamed:@"icon_login_choose_select"] forState:UIControlStateSelected];
        [_tipButton setTitleColor:HDAppTheme.color.sa_C333 forState:UIControlStateNormal];
        _tipButton.titleLabel.font = HDAppTheme.font.sa_standard12;
        [_tipButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            btn.selected = !btn.selected;
        }];
    }
    return _tipButton;
}

- (UIImageView *)iv1 {
    if (!_iv1) {
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_login_check_success_default"]];
        _iv1 = iv;
    }
    return _iv1;
}

- (UIImageView *)iv2 {
    if (!_iv2) {
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_login_check_success_default"]];
        _iv2 = iv;
    }
    return _iv2;
}

- (UIImageView *)iv3 {
    if (!_iv3) {
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_login_check_success_default"]];
        _iv3 = iv;
    }
    return _iv3;
}

- (UIImageView *)iv4 {
    if (!_iv4) {
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_login_check_success_default"]];
        _iv4 = iv;
    }
    return _iv4;
}

- (UILabel *)l1 {
    if (!_l1) {
        UILabel *l = UILabel.new;
        l.font = HDAppTheme.font.sa_standard11;
        l.textColor = HDAppTheme.color.sa_C333;
        l.numberOfLines = 0;
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.maximumLineHeight = 16;
        paragraphStyle.minimumLineHeight = 16;
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        l.attributedText = [[NSAttributedString alloc] initWithString:SALocalizedString(@"login_new_SetPassword_tip1", @"密码长度6-20个") attributes:attributes];
        _l1 = l;
    }
    return _l1;
}

- (UILabel *)l2 {
    if (!_l2) {
        UILabel *l = UILabel.new;
        l.font = HDAppTheme.font.sa_standard11;
        l.textColor = HDAppTheme.color.sa_C333;
        l.numberOfLines = 0;
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.maximumLineHeight = 16;
        paragraphStyle.minimumLineHeight = 16;
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        l.attributedText = [[NSAttributedString alloc] initWithString:SALocalizedString(@"login_new_SetPassword_tip2", @"密码内容必须为英文字母、数字或符号(除空格外)") attributes:attributes];
        _l2 = l;
    }
    return _l2;
}

- (UILabel *)l3 {
    if (!_l3) {
        UILabel *l = UILabel.new;
        l.font = HDAppTheme.font.sa_standard11;
        l.textColor = HDAppTheme.color.sa_C333;
        l.numberOfLines = 0;
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.maximumLineHeight = 16;
        paragraphStyle.minimumLineHeight = 16;
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        l.attributedText = [[NSAttributedString alloc] initWithString:SALocalizedString(@"login_new_SetPassword_tip3", @"至少包含英文字母、数字、符号任意两种组合") attributes:attributes];
        _l3 = l;
    }
    return _l3;
}

- (UILabel *)l4 {
    if (!_l4) {
        UILabel *l = UILabel.new;
        l.font = HDAppTheme.font.sa_standard11;
        l.textColor = HDAppTheme.color.sa_C333;
        l.numberOfLines = 0;
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.maximumLineHeight = 16;
        paragraphStyle.minimumLineHeight = 16;
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        l.attributedText = [[NSAttributedString alloc] initWithString:SALocalizedString(@"login_new_SetPassword_tip4", @"两次输入的登录密码需要一致") attributes:attributes];
        _l4 = l;
    }
    return _l4;
}

@end
