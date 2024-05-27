//
//  SASettingPayPwdView.m
//  SuperApp
//
//  Created by VanJay on 2020/8/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SASettingPayPwdView.h"
#import "PNKeyBoard.h"
#import "SASettingPayPwdViewModel.h"
#import "SATalkingData.h"
#import "VipayUser.h"


@interface SASettingPayPwdUnitTextField : HDUnitTextField
@end


@implementation SASettingPayPwdUnitTextField
#pragma mark - UITextInputTraits

- (UIKeyboardType)keyboardType {
    return UIKeyboardTypeNumberPad;
}

- (BOOL)isSecureTextEntry {
    return YES;
}

- (__kindof UIView *)inputView {
    HDKeyBoardTheme *theme = HDKeyBoardTheme.new;
    theme.enterpriseText = SALocalizedString(@"keyboard_brand_title", @"WOWNOW 安全键盘");
    //    HDKeyBoard *kb = [HDKeyBoard keyboardWithType:HDKeyBoardTypeNumberPad theme:theme];
    PNKeyBoard *kb = [[PNKeyBoard alloc] initKeyboardWithType:HDKeyBoardTypeNumberPad theme:theme isRandom:YES];
    kb.backgroundColor = [UIColor whiteColor];
    kb.keyBoard.inputSource = self;
    return kb;
}
@end


@interface SASettingPayPwdView () <HDUnitTextFieldDelegate>
/// VM
@property (nonatomic, strong) SASettingPayPwdViewModel *viewModel;
/// 密码输入框
@property (nonatomic, strong) SASettingPayPwdUnitTextField *textField;
/// 标题
@property (nonatomic, strong) SALabel *titleLB;
/// 提示
@property (nonatomic, strong) SALabel *tipLB;
/// 再次输入密码错误次数
@property (nonatomic, assign) NSInteger cfmPwdErrorCount;
@end


@implementation SASettingPayPwdView
#pragma mark - SAViewProtocol
- (void)hd_setupViews {
    [self addSubview:self.titleLB];
    [self addSubview:self.textField];
    [self addSubview:self.tipLB];

    [self.textField becomeFirstResponder];
}

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self];
}

#pragma mark - SAMultiLanguageRespond
- (void)hd_languageDidChanged {
}

#pragma mark - event response

#pragma mark - public methods

#pragma mark - private methods
- (BOOL)checkPasswordFormat:(NSString *)pwd {
    NSString *continuousRegex = @"(?:(?:0(?=1)|1(?=2)|2(?=3)|3(?=4)|4(?=5)|5(?=6)|6(?=7)|7(?=8)|8(?=9)){5}|(?:9(?=8)|8(?=7)|7(?=6)|6(?=5)|5(?=4)|4(?=3)|3(?=2)|2(?=1)|1(?=0)){5})\\d";
    if ([pwd hd_matches:continuousRegex]) {
        if(self.viewModel.actionType == SASettingPayPwdActionTypePinCodeSetting || self.viewModel.actionType == SASettingPayPwdActionTypePinCodeNew) {
            [NAT showToastWithTitle:nil content:SALocalizedString(@"pincodeCannotUseSerialNumber", @"pin-code不能是连续的数字") type:HDTopToastTypeWarning];
        } else {
            [NAT showToastWithTitle:nil content:SALocalizedString(@"pay_password_not_continuous_number", @"支付密码不能是连续的数字") type:HDTopToastTypeWarning];
        }

        [self.textField clear];
        return NO;
    } else if ([pwd hd_matches:@"([\\d])\\1{5,}"]) {
        if(self.viewModel.actionType == SASettingPayPwdActionTypePinCodeSetting || self.viewModel.actionType == SASettingPayPwdActionTypePinCodeNew) {
            [NAT showToastWithTitle:nil content:SALocalizedString(@"pincodeCannotUseRepeatNumber", @"pin-code不能是重复的数字") type:HDTopToastTypeWarning];
        } else {
            [NAT showToastWithTitle:nil content:SALocalizedString(@"pay_password_not_repeat_number", @"支付密码不能是重复的数字") type:HDTopToastTypeWarning];
            
        }
        [self.textField clear];
        return NO;
    }

    return YES;
}

- (BOOL)checkConfirmPassword:(NSString *)confirmPassword {
    if (![confirmPassword isEqualToString:self.viewModel.oldPayPassword]) {
        @HDWeakify(self);
        HDAlertViewButtonHandler handle = ^void(HDAlertView *alertView, HDAlertViewButton *button) {
            @HDStrongify(self);
            [alertView dismiss];
            [self.textField clear];
            self.cfmPwdErrorCount += 1;
            if (self.cfmPwdErrorCount > 2) {
                [self.viewController.navigationController popViewControllerAnimated:YES];
            } else {
                [self.textField becomeFirstResponder];
            }
        };
        
        if(self.viewModel.actionType == SASettingPayPwdActionTypePinCodeSettingVerify || self.viewModel.actionType == SASettingPayPwdActionTypePinCodeNewConfirm) {
            [NAT showAlertWithMessage:SALocalizedString(@"pincodeAreDifferent", @"两次输入的pin-code不一致，请重新输入。")
                          buttonTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons")
                              handler:handle];
        } else {
            [NAT showAlertWithMessage:SALocalizedString(@"password_no_same", @"两次输入的密码不一致，请重新输入。")
                          buttonTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons")
                              handler:handle];
        }

        return NO;
    } else {
        return YES;
    }
}

#pragma mark - HDUnitTextFieldDelegate
- (void)unitTextFieldDidEndEditing:(HDUnitTextField *)textField {
    [textField resignFirstResponder];

    NSString *passwordString = textField.text;
    @HDWeakify(self);
    switch (self.viewModel.actionType) {
        case SASettingPayPwdActionTypeConfirmID: {
            [self.viewModel validatePassword:passwordString];
            break;
        }

        case SASettingPayPwdActionTypeSetFirst: {
            if ([self checkPasswordFormat:passwordString]) {
                // 未设置支付密码
                [HDMediator.sharedInstance navigaveToSettingPayPwdViewController:@{
                    @"actionType": @(3),
                    @"completion": self.viewModel.successHandler,
                    @"oldPayPassword": passwordString,
                    @"firstName": self.viewModel.firstName,
                    @"lastName": self.viewModel.lastName,
                    @"headUrl": self.viewModel.headUrl,
                    @"birthday": self.viewModel.birthday,
                    @"sex": @(self.viewModel.gender)
                }];
            }
            break;
        }

        // 检验原支付密码
        case SASettingPayPwdActionTypeChangeVerify: {
            [self showloading];
            [self.viewModel verifyOriginalPayPwdWithPassword:passwordString success:^(NSString *_Nonnull accessToken) {
                @HDStrongify(self);
                [self dismissLoading];
                [HDMediator.sharedInstance navigaveToSettingPayPwdViewController:
                                               @{@"actionType": @(SASettingPayPwdActionTypeChange),
                                                 @"completion": self.viewModel.successHandler,
                                                 @"accessToken": accessToken}];
            } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
                [textField clear];
                @HDStrongify(self);
                [self dismissLoading];
            }];
            break;
        }

        // 修改密码
        case SASettingPayPwdActionTypeChange: {
            if ([self checkPasswordFormat:passwordString]) {
                // 未设置支付密码
                [HDMediator.sharedInstance navigaveToSettingPayPwdViewController:@{
                    @"actionType": @(SASettingPayPwdActionTypeChangeConfirm),
                    @"completion": self.viewModel.successHandler,
                    @"oldPayPassword": passwordString,
                    @"accessToken": self.viewModel.accessToken,
                    @"serialNumber": self.viewModel.serialNumber,
                }];
            }
            break;
        }

        // 确认修改
        case SASettingPayPwdActionTypeChangeConfirm: {
            if ([self checkConfirmPassword:passwordString]) {
                [self showloading];
                /// 暂定通过 serialNumber 没有值来判断 走不记得 和 记得 => 设置密码的 接口
                /// 不记得 流程 走 支付网关
                /// 记得 流程 走 中台网关
                if (WJIsStringNotEmpty(self.viewModel.serialNumber)) {
                    [self.viewModel resetPwd:passwordString success:^(PNRspModel *_Nonnull rspModel) {
                        @HDStrongify(self);
                        [self dismissLoading];

                        !self.viewModel.successHandler ?: self.viewModel.successHandler(true, true);

                        [NAT showToastWithTitle:nil content:SALocalizedString(@"pay_password_change_success", @"修改成功，请牢记支付密码。") type:HDTopToastTypeSuccess];
                    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
                        @HDStrongify(self);
                        [self dismissLoading];
                    }];
                } else {
                    [self.viewModel changePayPwdWithPassword:passwordString accessToken:self.viewModel.accessToken success:^{
                        @HDStrongify(self);
                        [self dismissLoading];

                        !self.viewModel.successHandler ?: self.viewModel.successHandler(true, true);

                        [NAT showToastWithTitle:nil content:SALocalizedString(@"pay_password_change_success", @"修改成功，请牢记支付密码。") type:HDTopToastTypeSuccess];
                    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
                        @HDStrongify(self);
                        [self dismissLoading];
                    }];
                }
            }
            break;
        }
        // 开通
        case SASettingPayPwdActionTypeSetConfirm: {
            if ([self checkConfirmPassword:passwordString]) {
                // 开通钱包
                NSString *firstName = self.viewModel.firstName;
                NSString *lastName = self.viewModel.lastName;
                NSInteger gender = self.viewModel.gender;
                NSString *headURL = self.viewModel.headUrl;
                NSString *birthday = self.viewModel.birthday;
                [self showloading];

                [self.viewModel enableWalletWithPassword:passwordString firstName:firstName lastName:lastName gender:gender headUrl:headURL birthday:birthday
                    success:^(SAEnableWalletRspModel *_Nonnull rspModel) {
                        @HDStrongify(self);

                        [VipayUser shareInstance].accountNo = rspModel.accountNo;
                        [VipayUser shareInstance].loginName = rspModel.loginName;
                        [VipayUser shareInstance].userNo = rspModel.userNo;
                        [[VipayUser shareInstance] save];

                        [VipayUser.shareInstance save];

                        [self dismissLoading];

                        [NAT showToastWithTitle:nil content:SALocalizedString(@"pay_password_settting_success", @"设置成功，请牢记支付密码。") type:HDTopToastTypeSuccess];

                        !self.viewModel.successHandler ?: self.viewModel.successHandler(true, true);
                    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
                        @HDStrongify(self);
                        [self dismissLoading];
                        ///////////////////////
                        !self.viewModel.successHandler ?: self.viewModel.successHandler(true, false);
                    }];
            }
            break;
        }
        case SASettingPayPwdActionTypeWalletActivation: {
            if ([self checkPasswordFormat:passwordString]) {
                // 未设置支付密码
                [HDMediator.sharedInstance navigaveToSettingPayPwdViewController:@{
                    @"actionType": @(8),
                    @"completion": self.viewModel.successHandler,
                    @"oldPayPassword": passwordString,
                    @"verifyParam": self.viewModel.verifyParam,
                }];
            }
            break;
        }
        case SASettingPayPwdActionTypeWalletActivationConfirm: {
            if ([self checkConfirmPassword:passwordString]) {
                HDLog(@"激活走起");
                [self.viewModel walletActivation:passwordString];
            }
            break;
        }
            
        case SASettingPayPwdActionTypePinCodeSetting: {
            // 设置pincode
            if([self checkPasswordFormat:passwordString]) {
                [HDMediator.sharedInstance navigaveToSettingPayPwdViewController:@{
                    @"actionType": @(SASettingPayPwdActionTypePinCodeSettingVerify),
                    @"completion": self.viewModel.successHandler,
                    @"oldPayPassword": passwordString
                }];
            }
            break;
        }
        case SASettingPayPwdActionTypePinCodeSettingVerify: {
            // 设置pincode，校验
            if([self checkConfirmPassword:passwordString]) {
                @HDWeakify(self);
                [self.viewModel createPinCodeWithPinCode:passwordString success:^{
                    @HDStrongify(self);
                    [NAT showToastWithTitle:nil content:SALocalizedString(@"settingPincodeSuccess", @"pin-code设置成功，请牢记!") type:HDTopToastTypeSuccess];
                    !self.viewModel.successHandler ?: self.viewModel.successHandler(true, true);
                    
                                } failure:nil];
            }
            break;
        }
        case SASettingPayPwdActionTypePinCodeVerify: {
            // 修改pinCode 校验原pinCode
            [self.viewModel validatePinCodeWithPinCode:passwordString success:^(NSString * _Nullable token, NSString * _Nullable errMsg) {
                if(HDIsStringNotEmpty(token)) {
                    [HDMediator.sharedInstance navigaveToSettingPayPwdViewController:@{
                        @"actionType": @(SASettingPayPwdActionTypePinCodeNew),
                        @"completion": self.viewModel.successHandler,
                        @"accessToken": token
                    }];
                }
            }];
            break;
        }
        case SASettingPayPwdActionTypePinCodeNew: {
            // 修改pinCode，输入第一次pincode
            if([self checkPasswordFormat:passwordString]) {
                [HDMediator.sharedInstance navigaveToSettingPayPwdViewController:@{
                                    @"actionType": @(SASettingPayPwdActionTypePinCodeNewConfirm),
                                    @"completion": self.viewModel.successHandler,
                                    @"oldPayPassword": passwordString,
                                    @"accessToken": self.viewModel.accessToken
                                }];
            }
            
            break;
        }
        case SASettingPayPwdActionTypePinCodeNewConfirm: {
            if([self checkConfirmPassword:passwordString]) {
                
                [self.viewModel modifyPinCodeWithPinCode:passwordString token:self.viewModel.accessToken success:^{
                    !self.viewModel.successHandler ?: self.viewModel.successHandler(true, true);
                    [NAT showToastWithTitle:nil content:SALocalizedString(@"modifyPincodeSuccess", @"pin-code修改成功，请牢记！") type:HDTopToastTypeSuccess];
                    
                } failure:nil];
                
                
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - layout
- (void)updateConstraints {
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kRealWidth(30));
        make.width.equalTo(self).offset(-UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding));
        make.centerX.equalTo(self);
    }];

    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.titleLB.mas_bottom).offset(kRealWidth(30));
        CGFloat width = kScreenWidth - 2 * kRealWidth(25);
        CGFloat height = (width - (self.textField.inputUnitCount - 1) * self.textField.unitSpace) / self.textField.inputUnitCount;
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];

    [self.tipLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textField.mas_bottom).offset(kRealWidth(20));
        make.width.equalTo(self).offset(-UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding));
        make.centerX.equalTo(self);
    }];

    [super updateConstraints];
}

#pragma mark - lazy load
- (SASettingPayPwdUnitTextField *)textField {
    if (!_textField) {
        SASettingPayPwdUnitTextField *textField = [[SASettingPayPwdUnitTextField alloc] initWithStyle:HDUnitTextFieldStyleBorder inputUnitCount:6];
        textField.delegate = self;
        textField.unitSpace = 0;
        textField.secureTextEntry = true;
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.borderRadius = 5;
        textField.borderWidth = 1;
        textField.autoResignFirstResponderWhenInputFinished = true;
        textField.textFont = [HDAppTheme.font boldForSize:22];

        _textField = textField;
    }
    return _textField;
}

- (SALabel *)titleLB {
    if (!_titleLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard3;
        label.textColor = HDAppTheme.color.G2;
        label.numberOfLines = 0;
        NSInteger actionType = self.viewModel.actionType;
        if (actionType == SASettingPayPwdActionTypeSetFirst || actionType == SASettingPayPwdActionTypeWalletActivation) {
            label.text = SALocalizedString(@"please_pay_password", @"为了保障您账户资金安全，请设置支付密码");
            
        } else if (actionType == SASettingPayPwdActionTypeSetConfirm || actionType == SASettingPayPwdActionTypeChangeConfirm || actionType == SASettingPayPwdActionTypeWalletActivationConfirm) {
            label.text = SALocalizedString(@"again_confirm_pay_password", @"再次确认支付密码");
            
        } else if (actionType == SASettingPayPwdActionTypeConfirmID) {
            label.text = SALocalizedString(@"please_input_pay_password", @"请输入支付密码");
            
        } else if (actionType == SASettingPayPwdActionTypeChange) {
            label.text = SALocalizedString(@"please_input_new_pay_password", @"请输入新支付密码");
            
        } else if (actionType == SASettingPayPwdActionTypeChangeVerify) {
            label.text = SALocalizedString(@"please_input_old_pay_password", @"请输入原支付密码");
            
        } else if (actionType == SASettingPayPwdActionTypePinCodeSetting) {
            label.text = SALocalizedString(@"pincodeSettingTips", @"Pin-code用于Bakong账户的绑定与交易，请设置。");
            
        } else if (actionType == SASettingPayPwdActionTypePinCodeSettingVerify) {
            label.text = SALocalizedString(@"confirmPincode", @"请再次确认pin-code");
            
        } else if (actionType == SASettingPayPwdActionTypePinCodeVerify) {
            label.text = SALocalizedString(@"inputOriginalPincode", @"请输入原pin-code");
            
        } else if (actionType == SASettingPayPwdActionTypePinCodeNew) {
            label.text = SALocalizedString(@"inputNewPincode", @"请输入新的pin-code");
            
        } else if (actionType == SASettingPayPwdActionTypePinCodeNewConfirm) {
            label.text = SALocalizedString(@"confirmPincode", @"请再次确认pin-code");
        }
        label.textAlignment = NSTextAlignmentCenter;
        _titleLB = label;
    }
    return _titleLB;
}

- (SALabel *)tipLB {
    if (!_tipLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard3;
        label.textColor = HDAppTheme.color.G2;
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        _tipLB = label;
    }
    return _tipLB;
}
@end
