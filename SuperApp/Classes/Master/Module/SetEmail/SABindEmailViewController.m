//
//  SABindEmailViewController.m
//  SuperApp
//
//  Created by Tia on 2023/6/25.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SABindEmailViewController.h"
#import "SAUpdateUserInfoViewModel.h"
#import "SABindEmailByVerificationCodeViewController.h"
#import "HDCountDownTimeManager.h"
#import "LKDataRecord.h"


@interface SABindEmailViewController ()
/// 头部
@property (nonatomic, strong) UILabel *headerLabel;
/// 输入框
@property (nonatomic, strong) HDUITextField *emailTF;
/// 确定按钮
@property (nonatomic, strong) SAOperationButton *confirmBTN;
/// 更新用户信息 VM
@property (nonatomic, strong) SAUpdateUserInfoViewModel *updateUserInfoViewModel;

@end


@implementation SABindEmailViewController

- (void)hd_setupViews {
    [self.view addSubview:self.headerLabel];
    [self.view addSubview:self.emailTF];
    [self.view addSubview:self.confirmBTN];

    [self.confirmBTN setFollowKeyBoardConfigEnable:YES margin:30 refView:self.emailTF distanceToRefViewBottom:20];

    NSString *email = [self.parameters valueForKey:@"email"];
    if (HDIsStringNotEmpty(email) && email.hd_isValidEmail) {
        [self.emailTF setTextFieldText:email];
    }

    [LKDataRecord.shared tracePVEvent:@"EmailVerificationPageView" parameters:nil SPM:nil];
}

- (void)hd_setupNavigation {
    //    self.boldTitle = SALocalizedString(@"modify_emial", @"修改邮箱");
    self.boldTitle = SALocalizedString(@"login_new2_Set email", @"设置邮箱");
}

- (void)hd_languageDidChanged {
    //    [self.emailTF updateConfigWithDict:@{@"placeholder": SALocalizedString(@"input_real_email", @"请输入真实邮箱")}];
    [self.emailTF updateConfigWithDict:@{@"placeholder": SALocalizedString(@"login_new2_Please enter your email account", @"请输入邮箱账号")}];
    [self.confirmBTN setTitle:SALocalizedStringFromTable(@"get_verification_code", @"获取验证码", @"Buttons") forState:UIControlStateNormal];

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


    [LKDataRecord.shared traceClickEvent:@"EmailVerificationPageObtainVerificationCodeButtonClick" parameters:nil SPM:[LKSPM SPMWithPage:@"SABindEmailViewController" area:@"" node:@""]];

    [self.view endEditing:true];
    [self showloading];


    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/operator/email/send.do";
    request.isNeedLogin = YES;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"email"] = self.emailTF.validInputText;
    params[@"biz"] = @"OTHER";
    params[@"templateNo"] = @"EMAIL_PUBLIC_SET_UP";
    request.requestParameter = params;
    @HDWeakify(self);
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        @HDStrongify(self);
        HDLog(@"已发送");

        [self dismissLoading];
        [HDCountDownTimeManager.shared updatePersistencedCountDownWithKey:@"SASetEmailByVerificationCodeViewController" maxSeconds:60];
        SABindEmailByVerificationCodeViewController *vc = SABindEmailByVerificationCodeViewController.new;
        vc.email = self.emailTF.validInputText;
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(HDNetworkResponse *_Nonnull response) {
        HDLog(@"发送失败");
        [self dismissLoading];
    }];
}

- (void)updateViewConstraints {
    CGFloat margin = 12;

    [self.headerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hd_navigationBar.mas_bottom).offset(32);
        make.left.equalTo(self.view).offset(margin);
        make.right.equalTo(self.view).offset(margin);
    }];


    [self.emailTF mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(HDAppTheme.value.padding.left);
        make.right.mas_equalTo(self.view).offset(-HDAppTheme.value.padding.right);
        make.height.mas_equalTo(55);
        make.top.mas_equalTo(self.headerLabel.mas_bottom).offset(2 * margin);
    }];

    [self.confirmBTN sizeToFit];
    [self.confirmBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view).offset(-UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding));
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.emailTF.mas_bottom).offset(2 * margin);
    }];
    [super updateViewConstraints];
}

#pragma mark - config
- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return true;
}


#pragma mark - lazy load


- (UILabel *)headerLabel {
    if (!_headerLabel) {
        UILabel *label = UILabel.new;
        label.text = SALocalizedString(@"login_new2_Please confirm your email account", @"请确认您的邮箱账号");
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:24 weight:UIFontWeightHeavy];
        label.hd_lineSpace = 12;
        label.textColor = HDAppTheme.color.sa_C333;
        _headerLabel = label;
    }
    return _headerLabel;
}

- (HDUITextField *)emailTF {
    if (!_emailTF) {
        HDUITextField *textField = [[HDUITextField alloc] initWithPlaceholder:nil rightLabelString:nil];
        HDUITextFieldConfig *config = [textField getCurrentConfig];
        config.font = [HDAppTheme.font sa_fontDINBold:18];
        config.textColor = HDAppTheme.color.sa_C333;
        config.maxInputLength = 50;
        config.keyboardType = UIKeyboardTypeEmailAddress;
        config.rightLabelFont = HDAppTheme.font.standard3;
        config.rightLabelColor = HDAppTheme.color.C1;
        config.bottomLineSelectedColor = config.bottomLineNormalColor;
        config.floatingText = @"";
        config.textFieldTintColor = HDAppTheme.color.sa_C1;
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
