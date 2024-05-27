//
//  SASetNickNameViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/4/7.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SASetNickNameViewController.h"
#import "SAUpdateUserInfoViewModel.h"


@interface SASetNickNameViewController ()
/// 输入框
@property (nonatomic, strong) HDUITextField *nickNameTF;
/// 确定按钮
@property (nonatomic, strong) SAOperationButton *confirmBTN;
/// 更新用户信息 VM
@property (nonatomic, strong) SAUpdateUserInfoViewModel *updateUserInfoViewModel;
@end


@implementation SASetNickNameViewController

- (void)hd_setupViews {
    [self.view addSubview:self.nickNameTF];
    [self.view addSubview:self.confirmBTN];
    if (HDIsStringNotEmpty(SAUser.shared.nickName)) {
        [self.nickNameTF setTextFieldText:SAUser.shared.nickName];
    }

    [self.confirmBTN setFollowKeyBoardConfigEnable:YES margin:30 refView:self.nickNameTF distanceToRefViewBottom:20];
}

- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"nickname", @"修改昵称");
}

- (void)hd_languageDidChanged {
    [self.nickNameTF updateConfigWithDict:@{@"placeholder": SALocalizedString(@"your_nickname", @"请输入昵称")}];
    [self.confirmBTN setTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons") forState:UIControlStateNormal];

    [self.view setNeedsUpdateConstraints];
}

#pragma mark - private methods
- (void)fixconfirmBTNState {
    self.confirmBTN.enabled = self.nickNameTF.validInputText.length >= 2 && self.nickNameTF.validInputText.length <= 32;
}

#pragma mark - event response
- (void)clickedConfirmBTNHandler {
    [self.view endEditing:true];
    [self showloading];
    @HDWeakify(self);
    [self.updateUserInfoViewModel updateUserInfoWithHeadURL:nil nickName:self.nickNameTF.validInputText email:nil gender:nil birthday:nil profession:nil education:nil success:^{
        @HDStrongify(self);
        [self dismissLoading];

        SAUser.shared.nickName = self.nickNameTF.validInputText;
        [SAUser.shared save];

        [self.navigationController popViewControllerAnimated:true];
    } failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}

- (void)updateViewConstraints {
    [self.nickNameTF mas_remakeConstraints:^(MASConstraintMaker *make) {
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
- (HDUITextField *)nickNameTF {
    if (!_nickNameTF) {
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
        _nickNameTF = textField;
    }
    return _nickNameTF;
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
