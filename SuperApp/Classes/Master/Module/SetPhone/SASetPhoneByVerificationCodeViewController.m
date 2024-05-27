//
//  SASetPhoneByVerificationCodeViewController.m
//  SuperApp
//
//  Created by Tia on 2023/6/21.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SASetPhoneByVerificationCodeViewController.h"
#import "HDCountDownTimeManager.h"
#import "LKDataRecord.h"
#import "SAAppSwitchManager.h"
#import "SALoginByVerificationCodeViewModel.h"
#import "SALogoTitleHeaderView.h"
#import "SAVerifySMSCodeRspModel.h"
#import <KSInstantMessagingKit/KSInstMsgManager.h>
#import "SASMSCodeDTO.h"
#import "SASetPhoneBindViewController.h"
#import "SASetPhoneViewController.h"


@interface SASetPhoneByVerificationCodeViewController () <HDUnitTextFieldDelegate>
/// 标题
@property (nonatomic, strong) UILabel *headerLabel;
/// 子标题
@property (nonatomic, strong) UILabel *headerDetailLabel;
/// 验证码输入框
@property (nonatomic, strong) HDUnitTextField *textField;
/// 倒计时按钮
@property (nonatomic, strong) HDCountDownButton *countDownBTN;

@property (nonatomic, strong) SASMSCodeDTO *smsDTO;

@end


@implementation SASetPhoneByVerificationCodeViewController

- (void)hd_setupViews {
    [self.view addSubview:self.headerLabel];
    [self.view addSubview:self.headerDetailLabel];
    [self.view addSubview:self.textField];
    [self.view addSubview:self.countDownBTN];

    [self handleCountDownTime];
}

- (void)updateViewConstraints {
    CGFloat margin = kRealWidth(12);

    [self.headerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hd_navigationBar.mas_bottom).offset(kRealWidth(32));
        make.left.equalTo(self.view).offset(margin);
        make.right.equalTo(self.view).offset(-margin);
    }];

    [self.headerDetailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerLabel.mas_bottom).offset(kRealWidth(8));
        make.left.equalTo(self.view).offset(margin);
        make.right.equalTo(self.view).offset(-margin);
    }];

    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.headerDetailLabel.mas_bottom).offset(kRealWidth(25));
        CGFloat width = kScreenWidth - 2 * margin;
        CGFloat height = (width - (self.textField.inputUnitCount - 1) * self.textField.unitSpace) / self.textField.inputUnitCount;
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];

    [self updateCountDownBTNConstraints];

    [super updateViewConstraints];
}

- (void)hd_languageDidChanged {
    [self.countDownBTN setTitle:SALocalizedString(@"login_new_GetVerificationCode", @"获取验证码") forState:UIControlStateNormal];
    self.countDownBTN.normalStateWidth = [self.countDownBTN sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;

    [self.view setNeedsUpdateConstraints];
}

#pragma mark - private methods
- (void)handleCountDownTime {
    // 获取本地是否有剩余秒数记录
    NSInteger oldSeconds = [HDCountDownTimeManager.shared getPersistencedCountDownSecondsWithKey:@"SASetPhoneByVerificationCodeViewController"];

    if (oldSeconds > 1) {
        self.countDownBTN.enabled = false;
        [self.countDownBTN startCountDownWithSecond:oldSeconds];
        // 号码正确才聚焦
        if (HDIsStringNotEmpty(self.countryCode) && HDIsStringNotEmpty(self.accountNo)) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.textField becomeFirstResponder];
            });
        }
    } else {
        // 号码正确才发送
        if (HDIsStringNotEmpty(self.countryCode) && HDIsStringNotEmpty(self.accountNo)) {
            // 主动点击
            [self.countDownBTN sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)updateCountDownBTNConstraints {
    [self.countDownBTN sizeToFit];
    [self.countDownBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-kRealWidth(12));
        make.top.equalTo(self.textField.mas_bottom).offset(kRealWidth(12));
        make.size.mas_equalTo(self.countDownBTN.bounds.size);
    }];
    [self updateSendSMSButtonBorder];
}

- (void)updateSendSMSButtonBorder {
    if (_countDownBTN && !CGSizeIsEmpty(_countDownBTN.bounds.size)) {
        self.countDownBTN.layer.cornerRadius = CGRectGetHeight(self.countDownBTN.frame) * 0.5;
        self.countDownBTN.layer.borderWidth = 1;
        self.countDownBTN.layer.borderColor = [self.countDownBTN titleColorForState:self.countDownBTN.state].CGColor;
    }
}

#pragma mark - config
- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return true;
}

#pragma mark - HDUnitTextFieldDelegate
- (void)textFieldDidEndEditing:(HDUnitTextField *)textField {
    if (textField.text.length == 6) {
        [self showloading];

        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 2;
        request.requestURI = @"/operator/mobile/update.do";
        request.isNeedLogin = YES;

        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"mobile"] = [NSString stringWithFormat:@"%@%@", self.countryCode, self.accountNo];
        params[@"biz"] = SASendSMSTypeUpdateUserMobile;
        params[@"verifyCode"] = textField.text;
        request.requestParameter = params;
        @HDWeakify(self);
        [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
            @HDStrongify(self);

            [self dismissLoading];

            //记录用户手机号码
            SAUser.shared.mobile = [NSString stringWithFormat:@"%@%@", self.countryCode, self.accountNo];
            //强改loginName
            SAUser.shared.loginName = SAUser.shared.mobile;

            [SAUser.shared save];

            [HDTips showWithText:SALocalizedString(@"login_new2_Successfully set", @"设置成功")];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //设置手机号码成功后，发送通知到接收方处理逻辑
                NSMutableArray *mArr = NSMutableArray.new;

                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if (![vc isKindOfClass:SASetPhoneBindViewController.class] && ![vc isKindOfClass:SASetPhoneViewController.class]) {
                        [mArr addObject:vc];
                    }
                }

                self.navigationController.viewControllers = mArr;
                [self.navigationController popViewControllerAnimated:YES];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    !self.bindSuccessBlock ?: self.bindSuccessBlock();
                });
            });
        } failure:^(HDNetworkResponse *_Nonnull response) {
            @HDStrongify(self);
            [self dismissLoading];
        }];
    }
}

- (BOOL)unitTextField:(HDUnitTextField *)unitTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *text = nil;
    if (range.location >= unitTextField.text.length) {
        text = [unitTextField.text stringByAppendingString:string];
    } else {
        text = [unitTextField.text stringByReplacingCharactersInRange:range withString:string];
    }
    return !text || text.hd_isPureDigitCharacters;
}


#pragma mark - lazy load
- (UILabel *)headerLabel {
    if (!_headerLabel) {
        UILabel *label = UILabel.new;
        label.text = SALocalizedString(@"login_new_VerificationCodeSent", @"发送验证码");
        label.font = [UIFont systemFontOfSize:24 weight:UIFontWeightHeavy];
        label.textColor = HDAppTheme.color.sa_C333;
        _headerLabel = label;
    }
    return _headerLabel;
}

- (UILabel *)headerDetailLabel {
    if (!_headerDetailLabel) {
        UILabel *label = UILabel.new;
        label.numberOfLines = 0;
        label.hd_lineSpace = 10;

        NSString *phoneTail = [self.accountNo substringFromIndex:self.accountNo.length - 4];
        NSString *tips = [NSString stringWithFormat:SALocalizedString(@"login_new2_GetVerificationCode_tip", @"我们已向你的手机尾号 %@ 发送6位验证码，请查看短信并输入"), phoneTail];
        label.text = tips;
        label.font = HDAppTheme.font.sa_standard12;
        label.textColor = HDAppTheme.color.sa_C999;

        _headerDetailLabel = label;
    }
    return _headerDetailLabel;
}

- (HDUnitTextField *)textField {
    if (!_textField) {
        _textField = [[HDUnitTextField alloc] initWithStyle:HDUnitTextFieldStyleUnderline inputUnitCount:6];
        _textField.trackTintColor = HDAppTheme.color.sa_separatorLineColor;
        _textField.tintColor = HDAppTheme.color.sa_separatorLineColor;
        _textField.cursorColor = HDAppTheme.color.sa_C1;
        _textField.autoResignFirstResponderWhenInputFinished = true;
        _textField.delegate = self;
        _textField.unitSpace = kRealWidth(12);
        _textField.textFont = [HDAppTheme.font sa_fontDINBold:24];
        _textField.textColor = HDAppTheme.color.sa_C333;
        [_textField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
        _textField.needListenToClickOntheBlankSpaceEvent = YES;
        if (@available(iOS 12.0, *)) {
            _textField.textContentType = UITextContentTypeOneTimeCode;
        }
        _textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _textField;
}

- (HDCountDownButton *)countDownBTN {
    if (!_countDownBTN) {
        HDCountDownButton *button = [HDCountDownButton buttonWithType:UIButtonTypeCustom];
        button.titleEdgeInsets = UIEdgeInsetsMake(6, 16, 6, 16);
        button.titleLabel.font = HDAppTheme.font.sa_standard14;
        [button setTitleColor:HDAppTheme.color.sa_C1 forState:UIControlStateNormal];
        [button setTitleColor:[HDAppTheme.color.sa_C1 colorWithAlphaComponent:0.3] forState:UIControlStateDisabled];
        button.shouldUseNormalStateWidth = YES;
        @HDWeakify(self);
        button.countDownStateChangedHandler = ^(HDCountDownButton *_Nonnull countDownButton, BOOL enabled) {
            @HDStrongify(self);
            [self updateCountDownBTNConstraints];
        };
        button.notNormalStateWidthGreaterThanNormalBlock = ^(HDCountDownButton *_Nonnull countDownButton) {
            @HDStrongify(self);
            [self.view setNeedsUpdateConstraints];
        };
        button.restoreNormalStateWidthBlock = ^(HDCountDownButton *_Nonnull countDownButton) {
            @HDStrongify(self);
            [self updateCountDownBTNConstraints];
        };
        button.countDownChangingHandler = ^NSString *(HDCountDownButton *_Nonnull countDownButton, NSUInteger second) {
            NSString *title = [NSString stringWithFormat:@"%@(%zds)", SALocalizedString(@"login_new_Resend", @"重新发送"), second];
            return title;
        };
        button.countDownFinishedHandler = ^NSString *(HDCountDownButton *_Nonnull countDownButton, NSUInteger second) {
            countDownButton.enabled = true;
            return SALocalizedString(@"login_new_Resend", @"重新发送");
        };

        button.clickedCountDownButtonHandler = ^(HDCountDownButton *_Nonnull countDownButton) {
            @HDStrongify(self);
            countDownButton.enabled = false;

            @HDWeakify(self);
            [self.smsDTO getSMSCodeWithCountryCode:self.countryCode accountNo:self.accountNo type:SASendSMSTypeUpdateUserMobile success:^{
                @HDStrongify(self);
                [self.textField becomeFirstResponder];
                [countDownButton startCountDownWithSecond:60];
                [HDCountDownTimeManager.shared updatePersistencedCountDownWithKey:@"SASetPhoneByVerificationCodeViewController" maxSeconds:60];
            } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
                countDownButton.enabled = true;
            }];
        };

        _countDownBTN = button;
    }
    return _countDownBTN;
}

- (SASMSCodeDTO *)smsDTO {
    if (!_smsDTO) {
        _smsDTO = SASMSCodeDTO.new;
    }
    return _smsDTO;
}
@end
