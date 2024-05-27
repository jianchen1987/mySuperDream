//
//  SAVerificationCodeView.m
//  SuperApp
//
//  Created by Tia on 2023/6/19.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAVerificationCodeView.h"
#import "HDCountDownTimeManager.h"
#import "LKDataRecord.h"
#import "SAAppSwitchManager.h"
#import "SALoginByVerificationCodeViewModel.h"
#import "SALogoTitleHeaderView.h"
#import "SAVerifySMSCodeRspModel.h"
#import <KSInstantMessagingKit/KSInstMsgManager.h>


@interface SAVerificationCodeView () <HDUnitTextFieldDelegate>
/// 标题
@property (nonatomic, strong) UILabel *headerLabel;
/// 子标题
@property (nonatomic, strong) UILabel *headerDetailLabel;
/// 验证码输入框
@property (nonatomic, strong) HDUnitTextField *textField;
/// VM
@property (nonatomic, strong) SALoginByVerificationCodeViewModel *viewModel;
/// 倒计时按钮
@property (nonatomic, strong) HDCountDownButton *countDownBTN;
/// 提示文本
@property (nonatomic, strong) UILabel *tipsLabel;
/// 获取语音验证码按钮
@property (nonatomic, strong) HDCountDownButton *voiceBTN;

@end


@implementation SAVerificationCodeView

static NSInteger kKeyBoardHeight = 0;

- (void)hd_setupViews {
    [self addSubview:self.headerLabel];
    [self addSubview:self.headerDetailLabel];
    [self addSubview:self.textField];
    [self addSubview:self.countDownBTN];
    [self addSubview:self.tipsLabel];
    [self addSubview:self.voiceBTN];

    [self handleCountDownTime];

    //判断是否隐藏语音验证码功能，默认隐藏
    NSString *switchLine = [SAAppSwitchManager.shared switchForKey:SAAppSwitchVoiceVerification];
    if (HDIsStringNotEmpty(switchLine) && [switchLine isEqualToString:@"on"]) {
        self.tipsLabel.hidden = false;
        self.voiceBTN.hidden = false;

        //判断是否支持86号码，默认隐藏
        if ([self.viewModel.fullAccountNo hasPrefix:@"86"]) {
            NSString *switchLine = [SAAppSwitchManager.shared switchForKey:SAAppSwitchVoiceVerificationSupportChineseMobilePhone];
            if (HDIsStringEmpty(switchLine) || ![switchLine isEqualToString:@"on"]) {
                self.tipsLabel.hidden = true;
                self.voiceBTN.hidden = true;
            }
        }
    }

    if (self.viewModel.smsCodeType == SASendSMSTypeResetPassword) {
        [LKDataRecord.shared tracePVEvent:@"Forgot_PasswordPage_Get_Verification_Code_Page_PV" parameters:nil SPM:nil];
    } else if (self.viewModel.smsCodeType == SASendSMSTypeLogin) {
        [LKDataRecord.shared tracePVEvent:@"SMSLoginPage_Get_Verification_Code_Page_PV" parameters:nil SPM:nil];
    } else if (self.viewModel.smsCodeType == SASendSMSTypeRegister) {
        [LKDataRecord.shared tracePVEvent:@"SMSRegisteredPage_Get_Verification_Code_Page_PV" parameters:nil SPM:nil];
    } else if (self.viewModel.smsCodeType == SASendSMSTypeValidateConsigneeMobile) {
        [LKDataRecord.shared tracePVEvent:@"consignee_verification_number_page_pv" parameters:nil SPM:nil];
    }
}

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_languageDidChanged {
    [self.countDownBTN setTitle:SALocalizedString(@"login_new_GetVerificationCode", @"获取验证码") forState:UIControlStateNormal];
    self.countDownBTN.normalStateWidth = [self.countDownBTN sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;

    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    CGFloat margin = kRealWidth(12);

    [self.headerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kRealWidth(32));
        make.left.equalTo(self).offset(margin);
        make.right.equalTo(self).offset(-margin);
    }];

    [self.headerDetailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerLabel.mas_bottom).offset(kRealWidth(8));
        make.left.equalTo(self).offset(margin);
        make.right.equalTo(self).offset(-margin);
    }];

    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.headerDetailLabel.mas_bottom).offset(kRealWidth(25));
        CGFloat width = kScreenWidth - 2 * margin;
        CGFloat height = (width - (self.textField.inputUnitCount - 1) * self.textField.unitSpace) / self.textField.inputUnitCount;
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];

    [self updateCountDownBTNConstraints];

    if (kKeyBoardHeight > 0) {
        [self.voiceBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-kKeyBoardHeight);
            make.left.mas_equalTo(kRealWidth(15));
        }];

        [self.tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.voiceBTN.mas_top).offset(-kRealWidth(8));
            make.left.mas_equalTo(kRealWidth(15));
            make.right.mas_equalTo(-kRealWidth(15));
        }];
    } else {
        [self.tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.countDownBTN.mas_bottom).offset(kRealWidth(128));
            make.left.mas_equalTo(kRealWidth(15));
            make.right.mas_equalTo(-kRealWidth(15));
        }];

        [self.voiceBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tipsLabel.mas_bottom).offset(kRealWidth(8));
            make.left.mas_equalTo(kRealWidth(15));
        }];
    }

    [super updateConstraints];
}

- (void)updateCountDownBTNConstraints {
    [self.countDownBTN sizeToFit];
    [self.countDownBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-kRealWidth(12));
        make.top.equalTo(self.textField.mas_bottom).offset(kRealWidth(12));
        //        if (self.countDownBTN.shouldUseNormalStateWidth) {
        //            make.size.mas_equalTo(CGSizeMake(self.countDownBTN.normalStateWidth, CGRectGetHeight(self.countDownBTN.bounds)));
        //        } else {
        make.size.mas_equalTo(self.countDownBTN.bounds.size);
        //        }
    }];
}

- (void)updateSendSMSButtonBorder {
    if (_countDownBTN && !CGSizeIsEmpty(_countDownBTN.bounds.size)) {
        self.countDownBTN.layer.cornerRadius = CGRectGetHeight(self.countDownBTN.frame) * 0.5;
        self.countDownBTN.layer.borderWidth = 1;
        self.countDownBTN.layer.borderColor = [self.countDownBTN titleColorForState:self.countDownBTN.state].CGColor;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateSendSMSButtonBorder];
}

#pragma mark -监听键盘
- (void)keyboardWillShow:(NSNotification *)noti {
    if (self.voiceBTN.hidden)
        return;
    CGRect keyboardRect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyBoardHeight = keyboardRect.size.height + 16;
    if (kKeyBoardHeight != keyBoardHeight) {
        kKeyBoardHeight = keyBoardHeight;
        [self updateConstraints];
    }
}

#pragma mark - private methods
- (void)handleCountDownTime {
    // 获取本地是否有剩余秒数记录
    NSInteger oldSeconds = [HDCountDownTimeManager.shared getPersistencedCountDownSecondsWithKey:self.viewModel.smsCodeType];
    NSInteger voiceOldSeconds = [HDCountDownTimeManager.shared getPersistencedCountDownSecondsWithKey:SASendSMSTypeVoice];

    if (voiceOldSeconds > 1) { //发送过语音验证码
        self.voiceBTN.enabled = false;
        [self.voiceBTN startCountDownWithSecond:voiceOldSeconds];
        // 号码正确才聚焦
        if (HDIsStringNotEmpty(self.viewModel.fullAccountNo)) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.textField becomeFirstResponder];
            });
        }
    }

    if (oldSeconds > 1) {
        self.countDownBTN.enabled = false;
        [self.countDownBTN startCountDownWithSecond:oldSeconds];
        // 号码正确才聚焦
        if (HDIsStringNotEmpty(self.viewModel.fullAccountNo)) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.textField becomeFirstResponder];
            });
        }
    } else {
        // 号码正确才发送
        if (HDIsStringNotEmpty(self.viewModel.fullAccountNo)) {
            // 主动点击
            [self.countDownBTN sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    }
}

#pragma mark - HDUnitTextFieldDelegate
- (void)textFieldDidEndEditing:(HDUnitTextField *)textField {
    if (textField.text.length == 6) {
        [self.viewModel verifySMSCodeWithCode:textField.text];
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
        NSString *phoneTail = [self.viewModel.accountNo substringFromIndex:self.viewModel.accountNo.length - 4];
        NSString *tips = [NSString stringWithFormat:SALocalizedString(@"login_new2_login_new_GetVerificationCode_tip", @"我们已向你的手机尾号%@发送6位验证码，请查看短信并输入"), phoneTail];
        if ([self.viewModel.smsCodeType isEqualToString:SASendSMSTypeValidateConsigneeMobile]) {
            phoneTail = self.viewModel.fullAccountNo;
            tips = [NSString stringWithFormat:SALocalizedString(@"address_code_tips", @"我们已向收货人手机号 %@ 发送验证码，请查看短信并输入验证码"), phoneTail];
        }
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
        //        _textField.borderRadius = 5;
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
            [self setNeedsUpdateConstraints];
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

            //            [self showloading];

            if ([self.viewModel.smsCodeType isEqualToString:SASendSMSTypeValidateConsigneeMobile]) { //验证收货人手机号

                @HDWeakify(self);
                [self.viewModel sendSMSWithPhoneNo:self.viewModel.fullAccountNo type:SASendSMSTypeValidateConsigneeMobile success:^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        @HDStrongify(self);
                        //                        [self dismissLoading];
                        [self.textField becomeFirstResponder];
                        [countDownButton startCountDownWithSecond:60];
                        [HDCountDownTimeManager.shared updatePersistencedCountDownWithKey:self.viewModel.smsCodeType maxSeconds:60];
                    });
                } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
                    //                    @HDStrongify(self);
                    //                    [self dismissLoading];
                    countDownButton.enabled = true;
                }];
                return;
            }

            // 埋点记录
            NSString *businessName = nil;
            if ([self.viewModel.smsCodeType isEqualToString:SASendSMSTypeLogin]) {
                businessName = @"登陆短信";
            } else if ([self.viewModel.smsCodeType isEqualToString:SASendSMSTypeRegister]) {
                businessName = @"注册短信";
            } else if ([self.viewModel.smsCodeType isEqualToString:SASendSMSTypeThirdPartyActiveOperator]) {
                businessName = @"三方绑定短信";
            } else if ([self.viewModel.smsCodeType isEqualToString:SASendSMSTypeThirdRegister]) {
                businessName = @"三方注册短信";
            } else if ([self.viewModel.smsCodeType isEqualToString:SASendSMSTypeResetPassword]) {
                businessName = @"重置密码短信";
            } else {
                businessName = @"";
            }

            [LKDataRecord.shared traceEventGroup:LKEventGroupNameLogin event:@"sendSms" name:businessName parameters:@{@"phone": self.viewModel.fullAccountNo} SPM:nil];

            @HDWeakify(self);
            [self.viewModel getSMSCodeWithCountryCode:self.viewModel.countryCode accountNo:self.viewModel.accountNo smsType:self.viewModel.smsCodeType success:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    @HDStrongify(self);
                    //                    [self dismissLoading];
                    [self.textField becomeFirstResponder];
                    [countDownButton startCountDownWithSecond:60];
                    [HDCountDownTimeManager.shared updatePersistencedCountDownWithKey:self.viewModel.smsCodeType maxSeconds:60];
                });
            } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
                //                    @HDStrongify(self);
                //                    [self dismissLoading];
                countDownButton.enabled = true;
            }];
        };

        _countDownBTN = button;
    }
    return _countDownBTN;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        label.font = HDAppTheme.font.sa_standard12;
        label.textColor = HDAppTheme.color.sa_C999;
        label.hd_lineSpace = 4;
        label.text = SALocalizedString(@"login_voice_tip1", @"If you haven't received the verification code for a long time, you can try another method1");
        label.hidden = true;
        _tipsLabel = label;
    }
    return _tipsLabel;
}

- (HDCountDownButton *)voiceBTN {
    if (!_voiceBTN) {
        @HDWeakify(self);
        HDCountDownButton *button = [HDCountDownButton buttonWithType:UIButtonTypeCustom];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:SALocalizedString(@"login_voice_tip2", @"尝试语音获取验证码") attributes:@{
            NSFontAttributeName: HDAppTheme.font.sa_standard14B,
            NSForegroundColorAttributeName: HDAppTheme.color.sa_C333,
            NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]
        }];
        [button setAttributedTitle:string forState:UIControlStateNormal];

        button.countDownChangingHandlerByAttributedString = ^NSAttributedString *_Nullable(HDCountDownButton *_Nonnull countDownButton, NSUInteger second) {
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:SALocalizedString(@"login_voice_tip3", @"我们正在给你拨打电话，请稍等") attributes:@{
                NSFontAttributeName: HDAppTheme.font.sa_standard14B,
                NSForegroundColorAttributeName: HDAppTheme.color.sa_C999,
                NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]
            }];
            return string;
        };
        button.countDownFinishedHandlerByAttributedString = ^NSAttributedString *_Nullable(HDCountDownButton *_Nonnull countDownButton, NSUInteger second) {
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:SALocalizedString(@"login_voice_tip2", @"尝试语音获取验证码") attributes:@{
                NSFontAttributeName: HDAppTheme.font.sa_standard14B,
                NSForegroundColorAttributeName: HDAppTheme.color.sa_C333,
                NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]
            }];
            countDownButton.enabled = true;
            return string;
        };
        button.clickedCountDownButtonHandler = ^(HDCountDownButton *_Nonnull countDownButton) {
            @HDStrongify(self);
            countDownButton.enabled = false;
            [self showloading];
            @HDWeakify(self);
            [self.viewModel getVoiceCodeWithSmsType:self.viewModel.smsCodeType success:^{
                @HDStrongify(self);
                [self dismissLoading];
                [self.textField becomeFirstResponder];
                [countDownButton startCountDownWithSecond:60];
                [HDCountDownTimeManager.shared updatePersistencedCountDownWithKey:SASendSMSTypeVoice maxSeconds:60];

                NSString *name = @"SMSLoginPage_Voice_Verification_Code_CLICK";
                NSString *page = @"SALoginBySMSViewController";
                if (self.viewModel.smsCodeType == SASendSMSTypeLogin) {
                    name = @"SMSLoginPage_Voice_Verification_Code_CLICK";
                    page = @"SALoginBySMSViewController";
                } else if (self.viewModel.smsCodeType == SASendSMSTypeRegister) {
                    name = @"SMSRegisteredPage_Voice_Verification_Code_CLICK";
                    page = @"SALoginBySMSViewController";
                } else if (self.viewModel.smsCodeType == SASendSMSTypeResetPassword) {
                    name = @"ForgotPasswordPage_Voice_Verification_Code_CLICK";
                    page = @"SAForgotPasswordViewController";
                } else if (self.viewModel.smsCodeType == SASendSMSTypeValidateConsigneeMobile) {
                    name = @"consignee_verification_number_page_voice_verification_code_click";
                    page = @"other";
                } else {
                    name = @"other";
                    page = @"other";
                }

                [LKDataRecord.shared traceClickEvent:name
                                          parameters:
                                              @{@"phone": self.viewModel.fullAccountNo,
                                                @"time": [NSString stringWithFormat:@"%.0f", [NSDate new].timeIntervalSince1970 * 1000.0],
                                                @"success": @true}
                                                 SPM:[LKSPM SPMWithPage:page area:@"" node:@""]];
            } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
                @HDStrongify(self);
                [self dismissLoading];
                countDownButton.enabled = true;

                NSString *name = @"SMSLoginPage_Voice_Verification_Code_CLICK";
                NSString *page = @"SALoginBySMSViewController";
                if (self.viewModel.smsCodeType == SASendSMSTypeLogin) {
                    name = @"SMSLoginPage_Voice_Verification_Code_CLICK";
                    page = @"SALoginBySMSViewController";
                } else if (self.viewModel.smsCodeType == SASendSMSTypeRegister) {
                    name = @"SMSRegisteredPage_Voice_Verification_Code_CLICK";
                    page = @"SALoginBySMSViewController";
                } else if (self.viewModel.smsCodeType == SASendSMSTypeResetPassword) {
                    name = @"ForgotPasswordPage_Voice_Verification_Code_CLICK";
                    page = @"SAForgotPasswordViewController";
                } else if (self.viewModel.smsCodeType == SASendSMSTypeValidateConsigneeMobile) {
                    name = @"consignee_verification_number_page_voice_verification_code_click";
                    page = @"other";
                } else {
                    name = @"other";
                    page = @"other";
                }

                [LKDataRecord.shared traceClickEvent:name
                                          parameters:
                                              @{@"phone": self.viewModel.fullAccountNo,
                                                @"time": [NSString stringWithFormat:@"%.0f", [NSDate new].timeIntervalSince1970 * 1000.0],
                                                @"success": @false}
                                                 SPM:[LKSPM SPMWithPage:page area:@"" node:@""]];
            }];
        };
        button.hidden = true;
        _voiceBTN = button;
    }
    return _voiceBTN;
}

@end
