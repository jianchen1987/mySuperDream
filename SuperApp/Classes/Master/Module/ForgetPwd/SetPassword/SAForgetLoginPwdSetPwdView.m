//
//  SAForgetLoginPwdSetPwdView.m
//  SuperApp
//
//  Created by VanJay on 2020/4/6.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAForgetLoginPwdSetPwdView.h"
#import "SAForgetLoginPwdSetPwdViewModel.h"
#import "SALogoTitleHeaderView.h"
#import "SAPasswordSettingOptionViewController.h"


@interface SAForgetLoginPwdSetPwdView ()

/// 密码输入框
@property (nonatomic, strong) HDUITextField *passwordTF;
/// 确认密码输入框
@property (nonatomic, strong) HDUITextField *confirmPwdTF;
/// 确定按钮
@property (nonatomic, strong) SAOperationButton *confirmBTN;
/// 提示
@property (nonatomic, strong) SALabel *bottomTipLB;
/// VM
@property (nonatomic, strong) SAForgetLoginPwdSetPwdViewModel *viewModel;
@end


@implementation SAForgetLoginPwdSetPwdView
- (void)hd_setupViews {
    [self addSubview:self.passwordTF];
    [self addSubview:self.confirmPwdTF];
    [self addSubview:self.bottomTipLB];
    [self addSubview:self.confirmBTN];

    [self.confirmBTN setFollowKeyBoardConfigEnable:YES margin:30 refView:self.bottomTipLB distanceToRefViewBottom:20];
}

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_bindViewModel {
}

- (void)hd_languageDidChanged {
    self.bottomTipLB.text = SALocalizedString(@"password_vaild_desc", @"密码为6-20数字、字母或特殊符号的组合");
    [self.passwordTF updateConfigWithDict:@{@"placeholder": SALocalizedString(@"placeholder_input_pwd", @"请输入密码")}];
    [self.confirmPwdTF updateConfigWithDict:@{@"placeholder": SALocalizedString(@"placeholder_input_pwd_again", @"请再次输入密码")}];
    [self.confirmBTN setTitle:SALocalizedStringFromTable(@"next_step", @"下一步", @"Buttons") forState:UIControlStateNormal];
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    [self.passwordTF mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(HDAppTheme.value.padding.left);
        make.right.mas_equalTo(self).offset(-HDAppTheme.value.padding.right);
        make.height.mas_equalTo(60);
        make.top.mas_equalTo(self.top).offset(kRealWidth(30));
    }];

    [self.confirmPwdTF mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.left.mas_equalTo(self.passwordTF);
        make.top.mas_equalTo(self.passwordTF.mas_bottom).offset(kRealWidth(10));
    }];

    [self.bottomTipLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(HDAppTheme.value.padding.left);
        make.right.mas_equalTo(self).offset(-HDAppTheme.value.padding.right);
        make.top.mas_equalTo(self.confirmPwdTF.mas_bottom).offset(kRealWidth(10));
    }];

    [self.confirmBTN sizeToFit];
    [self.confirmBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self).offset(-UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding));
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self).offset(-(kiPhoneXSeriesSafeBottomHeight + kRealWidth(30)));
    }];
    [super updateConstraints];
}

#pragma mark - private methods
- (void)fixconfirmBTNState {
    self.confirmBTN.enabled = self.passwordTF.validInputText.length >= 6 && self.confirmPwdTF.validInputText.length >= 6;
}

- (HDUITextField *)passwordTextField {
    HDUITextField *textField = [[HDUITextField alloc] initWithPlaceholder:nil rightLabelString:nil];
    HDUITextFieldConfig *config = [textField getCurrentConfig];
    config.font = HDAppTheme.font.standard2;
    config.textColor = HDAppTheme.color.G1;
    config.maxInputLength = 20;
    config.secureTextEntry = YES;
    config.floatingText = @" ";
    config.characterSetString = kCharacterSetStringNumberAndLetterAndSpecialCharacters;
    config.rightLabelFont = HDAppTheme.font.standard3;
    config.rightLabelColor = HDAppTheme.color.C1;

    [textField setConfig:config];

    HDKeyBoardTheme *theme = HDKeyBoardTheme.new;
    theme.enterpriseText = SALocalizedString(@"keyboard_brand_title", @"WOWNOW 安全键盘");
    HDKeyBoard *kb = [HDKeyBoard keyboardWithType:HDKeyBoardTypeLetterCapableCanSwitchToASCII theme:theme];
    kb.inputSource = textField.inputTextField;
    textField.inputTextField.inputView = kb;

    @HDWeakify(self);
    textField.textFieldDidChangeBlock = ^(NSString *text) {
        @HDStrongify(self);
        [self fixconfirmBTNState];
    };

    // 设置眼睛按钮
    HDUIButton *eyeBTN = [HDUIButton buttonWithType:UIButtonTypeCustom];
    eyeBTN.adjustsButtonWhenHighlighted = false;
    [eyeBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
        btn.selected = !btn.isSelected;
        textField.inputTextField.secureTextEntry = !btn.isSelected;
    }];
    [eyeBTN setImage:[UIImage imageNamed:@"password_hide"] forState:UIControlStateNormal];
    [eyeBTN setImage:[UIImage imageNamed:@"password_show"] forState:UIControlStateSelected];
    eyeBTN.imageEdgeInsets = UIEdgeInsetsMake(7, 5, 7, 10);
    [eyeBTN sizeToFit];
    [textField setCustomRightView:eyeBTN];
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
    [self showloading];
    @HDWeakify(self);
    [self.viewModel resetLoginPasswordWithPlainPwd:self.confirmPwdTF.validInputText success:^{
        @HDStrongify(self);
        [self dismissLoading];
        [self resetSuccess];
    } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}

- (void)resetSuccess {
    @HDWeakify(self);
    [NAT showAlertWithMessage:SALocalizedString(@"reset_password_success_relogin", @"您已重置登录密码，请重新登录。") buttonTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons")
                      handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                          [alertView dismiss];
                          @HDStrongify(self);
                          // 去密码输入页
                          if ([SAUser hasSignedIn]) {
                              [SAUser logout];
                              [SAWindowManager switchWindowToLoginViewControllerCompletion:nil];
                              [self.viewController.navigationController popToRootViewControllerAnimated:NO];
                          } else {
                              [self.viewController.navigationController popToRootViewControllerAnimated:YES];
                          }
                      }];
}

#pragma mark - lazy load
- (SALabel *)bottomTipLB {
    if (!_bottomTipLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard4;
        label.textColor = HDAppTheme.color.G3;
        label.numberOfLines = 0;
        _bottomTipLB = label;
    }
    return _bottomTipLB;
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
@end
