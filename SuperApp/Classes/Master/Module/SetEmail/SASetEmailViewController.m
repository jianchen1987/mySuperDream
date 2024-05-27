//
//  SASetEmailViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/5/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SASetEmailViewController.h"
#import "SAUpdateUserInfoViewModel.h"


@interface SASetEmailViewController ()
/// 输入框
@property (nonatomic, strong) HDUITextField *emailTF;
/// 确定按钮
@property (nonatomic, strong) SAOperationButton *confirmBTN;
/// 更新用户信息 VM
@property (nonatomic, strong) SAUpdateUserInfoViewModel *updateUserInfoViewModel;

@end


@implementation SASetEmailViewController

- (void)hd_setupViews {
    [self.view addSubview:self.emailTF];
    [self.view addSubview:self.confirmBTN];

    [self.confirmBTN setFollowKeyBoardConfigEnable:YES margin:30 refView:self.emailTF distanceToRefViewBottom:20];

    NSString *email = [self.parameters valueForKey:@"email"];
    if (HDIsStringNotEmpty(email) && email.hd_isValidEmail) {
        [self.emailTF setTextFieldText:email];
    }
}

- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"modify_emial", @"修改邮箱");
}

- (void)hd_languageDidChanged {
    [self.emailTF updateConfigWithDict:@{@"placeholder": SALocalizedString(@"input_real_email", @"请输入真实邮箱")}];
    [self.confirmBTN setTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons") forState:UIControlStateNormal];

    [self.view setNeedsUpdateConstraints];
}

#pragma mark - private methods
- (void)fixconfirmBTNState {
    NSString *text = self.emailTF.validInputText;
    self.confirmBTN.enabled = text.length >= 6 && text.length <= 320;
}

#pragma mark - event response
- (void)clickedConfirmBTNHandler {
    if (!self.emailTF.validInputText.hd_isValidEmail) {
        [self.emailTF becomeFirstResponder];
        [NAT showToastWithTitle:nil content:SALocalizedString(@"invalid_email_format", @"邮箱格式不正确") type:HDTopToastTypeWarning];
        return;
    }

    [self.view endEditing:true];
    [self showloading];
    @HDWeakify(self);
    [self.updateUserInfoViewModel updateUserInfoWithHeadURL:nil nickName:nil email:self.emailTF.validInputText gender:nil birthday:nil profession:nil education:nil success:^{
        @HDStrongify(self);
        [self dismissLoading];
        [self.navigationController popViewControllerAnimated:true];
    } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}

- (void)updateViewConstraints {
    [self.emailTF mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(HDAppTheme.value.padding.left);
        make.right.mas_equalTo(self.view).offset(-HDAppTheme.value.padding.right);
        make.height.mas_equalTo(60);
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom).offset(kRealWidth(20));
    }];

    [self.confirmBTN sizeToFit];
    [self.confirmBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view).offset(-UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding));
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-(kiPhoneXSeriesSafeBottomHeight + kRealWidth(30)));
    }];
    [super updateViewConstraints];
}

#pragma mark - lazy load
- (HDUITextField *)emailTF {
    if (!_emailTF) {
        HDUITextField *textField = [[HDUITextField alloc] initWithPlaceholder:nil rightLabelString:nil];
        HDUITextFieldConfig *config = [textField getCurrentConfig];
        config.font = HDAppTheme.font.standard2;
        config.textColor = HDAppTheme.color.G1;
        config.maxInputLength = 50;
        config.keyboardType = UIKeyboardTypeDefault;
        config.rightLabelFont = HDAppTheme.font.standard3;
        config.rightLabelColor = HDAppTheme.color.C1;
        config.floatingText = @"";
        [textField setConfig:config];

        @HDWeakify(self);
        textField.textFieldDidChangeBlock = ^(NSString *text) {
            @HDStrongify(self);
            [self fixconfirmBTNState];
        };
        _emailTF = textField;
    }
    return _emailTF;
}

- (SAOperationButton *)confirmBTN {
    if (!_confirmBTN) {
        _confirmBTN = [SAOperationButton buttonWithType:UIButtonTypeCustom];
        [_confirmBTN addTarget:self action:@selector(clickedConfirmBTNHandler) forControlEvents:UIControlEventTouchUpInside];
        _confirmBTN.enabled = false;
    }
    return _confirmBTN;
}

- (SAUpdateUserInfoViewModel *)updateUserInfoViewModel {
    return _updateUserInfoViewModel ?: ({ _updateUserInfoViewModel = SAUpdateUserInfoViewModel.new; });
}

@end
