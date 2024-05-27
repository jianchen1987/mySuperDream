//
//  PNMSTradePwdView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/6/9.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSTradePwdView.h"
#import "PNKeyBoard.h"
#import "PNMSTradePwdViewModel.h"
#import "SATalkingData.h"


@interface PNMSSettingPayPwdUnitTextField : HDUnitTextField
@end


@implementation PNMSSettingPayPwdUnitTextField
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
    PNKeyBoard *kb = [[PNKeyBoard alloc] initKeyboardWithType:HDKeyBoardTypeNumberPad theme:theme isRandom:YES];
    //    HDKeyBoard *kb = [HDKeyBoard keyboardWithType:HDKeyBoardTypeNumberPad theme:theme];
    kb.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
    kb.keyBoard.inputSource = self;
    return kb;
}
@end


@interface PNMSTradePwdView () <HDUnitTextFieldDelegate>
/// VM
@property (nonatomic, strong) PNMSTradePwdViewModel *viewModel;
/// 密码输入框
@property (nonatomic, strong) PNMSSettingPayPwdUnitTextField *textField;
/// 标题
@property (nonatomic, strong) SALabel *titleLB;
/// 提示
@property (nonatomic, strong) SALabel *tipLB;
/// 再次输入密码错误次数
@property (nonatomic, assign) NSInteger cfmPwdErrorCount;
@end


@implementation PNMSTradePwdView

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self addSubview:self.titleLB];
    [self addSubview:self.textField];
    [self addSubview:self.tipLB];

    [self.textField becomeFirstResponder];
}

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

#pragma mark - private methods
- (BOOL)checkPasswordFormat:(NSString *)pwd {
    NSString *continuousRegex = @"(?:(?:0(?=1)|1(?=2)|2(?=3)|3(?=4)|4(?=5)|5(?=6)|6(?=7)|7(?=8)|8(?=9)){5}|(?:9(?=8)|8(?=7)|7(?=6)|6(?=5)|5(?=4)|4(?=3)|3(?=2)|2(?=1)|1(?=0)){5})\\d";
    if ([pwd hd_matches:continuousRegex]) {
        [NAT showToastWithTitle:nil content:PNLocalizedString(@"pn_ms_error_tips", @"交易密码不能是重复、连续的数字") type:HDTopToastTypeWarning];

        [self.textField clear];
        return NO;
    } else if ([pwd hd_matches:@"([\\d])\\1{5,}"]) {
        [NAT showToastWithTitle:nil content:PNLocalizedString(@"pn_ms_error_tips", @"交易密码不能是重复、连续的数字") type:HDTopToastTypeWarning];

        [self.textField clear];
        return NO;
    }

    return YES;
}

- (BOOL)checkConfirmPassword:(NSString *)confirmPassword {
    if (![confirmPassword isEqualToString:self.viewModel.oldPayPassword]) {
        [NAT showAlertWithMessage:SALocalizedString(@"password_no_same", @"两次输入的密码不一致，请重新输入。") buttonTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons")
                          handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                              [alertView dismiss];
                              [self.textField clear];
                              self.cfmPwdErrorCount += 1;
                              if (self.cfmPwdErrorCount > 2) {
                                  [self.viewController.navigationController popViewControllerAnimated:YES];
                              } else {
                                  [self.textField becomeFirstResponder];
                              }
                          }];

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
        case PNMSSettingPayPwdActionTypeSetFirst: {
            if ([self checkPasswordFormat:passwordString]) {
                // 未设置支付密码 [第一次设置]
                @HDStrongify(self);
                [HDMediator.sharedInstance navigaveToPayNowMerchantServicesSetTradePwdVC:@{
                    @"actionType": @(2),
                    @"completion": self.viewModel.successHandler,
                    @"oldPayPassword": passwordString,
                    @"operatorNo": self.viewModel.operatorNo,
                }];
            }
            break;
        }
        case PNMSSettingPayPwdActionTypeSetConfirm: {
            if ([self checkConfirmPassword:passwordString]) {
                [self.viewModel saveTradePwd:passwordString success:^{
                    [NAT showToastWithTitle:nil content:SALocalizedString(@"pay_password_settting_success", @"设置成功，请牢记支付密码。") type:HDTopToastTypeSuccess];

                    !self.viewModel.successHandler ?: self.viewModel.successHandler(YES);
                }];
            }
            break;
        }
        case PNMSSettingPayPwdActionTypeValidator: {
            [self.viewModel validatorTradePwd:passwordString success:^{
                @HDStrongify(self);
                [HDMediator.sharedInstance navigaveToPayNowMerchantServicesSetTradePwdVC:@{
                    @"actionType": @(4),
                    @"completion": self.viewModel.successHandler,
                    @"oldPayPassword": passwordString,
                    @"operatorNo": self.viewModel.operatorNo,
                    @"currentPassword": passwordString,
                }];
            }];
        } break;
        case PNMSSettingPayPwdActionTypeUpdate: {
            if ([self checkPasswordFormat:passwordString]) {
                @HDStrongify(self);
                [HDMediator.sharedInstance navigaveToPayNowMerchantServicesSetTradePwdVC:@{
                    @"actionType": @(5),
                    @"completion": self.viewModel.successHandler,
                    @"oldPayPassword": passwordString,
                    @"operatorNo": self.viewModel.operatorNo,
                    @"currentPassword": self.viewModel.currentPassword,
                }];
            }
        } break;
        case PNMSSettingPayPwdActionTypeUpdateConfrim: {
            if ([self checkConfirmPassword:passwordString]) {
                [self.viewModel updateTradePwd:passwordString oldPwd:self.viewModel.currentPassword success:^{
                    @HDStrongify(self);

                    !self.viewModel.successHandler ?: self.viewModel.successHandler(true);

                    [NAT showToastWithTitle:nil content:PNLocalizedString(@"pn_ms_update_pwd_success", @"交易密码修改成功，请牢记！") type:HDTopToastTypeSuccess];
                }];
            }
        } break;
        case PNMSSettingPayPwdActionTypeReset: {
            if ([self checkPasswordFormat:passwordString]) {
                @HDStrongify(self);
                [HDMediator.sharedInstance navigaveToPayNowMerchantServicesSetTradePwdVC:@{
                    @"actionType": @(7),
                    @"completion": self.viewModel.successHandler,
                    @"oldPayPassword": passwordString,
                    @"serialNumber": self.viewModel.serialNumber,
                    @"token": self.viewModel.token
                }];
            }
        } break;
        case PNMSSettingPayPwdActionTypeResetConfirm: {
            if ([self checkConfirmPassword:passwordString]) {
                [self.viewModel resetTradePwd:passwordString success:^{
                    @HDStrongify(self);

                    [NAT showToastWithTitle:nil content:SALocalizedString(@"pay_password_change_success", @"设置成功，请牢记支付密码。") type:HDTopToastTypeSuccess];

                    !self.viewModel.successHandler ?: self.viewModel.successHandler(YES);
                }];
            }
        } break;
        case PNMSSettingPayPwdActionTypeResetOperator: {
            if ([self checkPasswordFormat:passwordString]) {
                @HDStrongify(self);
                [HDMediator.sharedInstance navigaveToPayNowMerchantServicesSetTradePwdVC:@{
                    @"actionType": @(9),
                    @"completion": self.viewModel.successHandler,
                    @"oldPayPassword": passwordString,
                    @"serialNumber": self.viewModel.serialNumber,
                    @"token": self.viewModel.token
                }];
            }
        } break;
        case PNMSSettingPayPwdActionTypeResetOperatorConfirm: {
            if ([self checkConfirmPassword:passwordString]) {
                [self.viewModel operatorResetTradePwd:passwordString success:^{
                    @HDStrongify(self);

                    [NAT showToastWithTitle:nil content:SALocalizedString(@"pay_password_change_success", @"设置成功，请牢记支付密码。") type:HDTopToastTypeSuccess];

                    !self.viewModel.successHandler ?: self.viewModel.successHandler(YES);
                }];
            }
        } break;
        default:
            break;
    }
}

#pragma mark - layout
- (void)updateConstraints {
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kRealWidth(24));
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(16));
        make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-16));
    }];

    [self.tipLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLB.mas_bottom).offset(kRealWidth(4));
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(16));
        make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-16));
    }];

    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.tipLB.mas_bottom).offset(kRealWidth(20));
        CGFloat width = kScreenWidth - 2 * kRealWidth(25);
        CGFloat height = (width - (self.textField.inputUnitCount - 1) * self.textField.unitSpace) / self.textField.inputUnitCount;
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];

    [super updateConstraints];
}

#pragma mark - lazy load
- (PNMSSettingPayPwdUnitTextField *)textField {
    if (!_textField) {
        PNMSSettingPayPwdUnitTextField *textField = [[PNMSSettingPayPwdUnitTextField alloc] initWithStyle:HDUnitTextFieldStyleBorder inputUnitCount:6];
        textField.delegate = self;
        textField.cursorColor = HDAppTheme.PayNowColor.mainThemeColor;
        textField.trackTintColor = HDAppTheme.PayNowColor.mainThemeColor;
        textField.unitSpace = kRealWidth(8);
        textField.secureTextEntry = true;
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.borderRadius = kRealWidth(8);
        textField.borderWidth = 0;
        textField.autoResignFirstResponderWhenInputFinished = true;
        textField.textFont = [HDAppTheme.font boldForSize:22];
        textField.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;

        _textField = textField;
    }
    return _textField;
}

- (SALabel *)titleLB {
    if (!_titleLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.PayNowFont.standard20B;
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.numberOfLines = 0;
        PNMSSettingPayPwdActionType type = self.viewModel.actionType;
        if (type == PNMSSettingPayPwdActionTypeSetFirst) {
            label.text = PNLocalizedString(@"pn_ms_set_trade_pwd", @"Set password");
        } else if (type == PNMSSettingPayPwdActionTypeSetConfirm) {
            label.text = PNLocalizedString(@"pn_ms_set_trade_pwd_confirm", @"Confirm password");
        } else if (type == PNMSSettingPayPwdActionTypeValidator) {
            label.text = PNLocalizedString(@"pn_ms_current_pwd_tips", @"请输入原交易密码");
        } else if (type == PNMSSettingPayPwdActionTypeUpdate || type == PNMSSettingPayPwdActionTypeReset || type == PNMSSettingPayPwdActionTypeResetOperator) {
            label.text = PNLocalizedString(@"pn_ms_new_pwd_tips", @"请输入新的交易密码");
        } else if (type == PNMSSettingPayPwdActionTypeUpdateConfrim || type == PNMSSettingPayPwdActionTypeResetConfirm || type == PNMSSettingPayPwdActionTypeResetOperatorConfirm) {
            label.text = PNLocalizedString(@"pn_ms_confirm_new_pwd_tips", @"请再次确认交易密码");
        }
        _titleLB = label;
    }
    return _titleLB;
}

- (SALabel *)tipLB {
    if (!_tipLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.PayNowFont.standard12;
        label.textColor = HDAppTheme.PayNowColor.c999999;
        label.numberOfLines = 0;
        PNMSSettingPayPwdActionType type = self.viewModel.actionType;
        if (type == PNMSSettingPayPwdActionTypeSetFirst) {
            label.text = PNLocalizedString(@"pn_ms_trade_first_tips", @"请设置6位商户钱包交易密码,该密码仅用于商户钱包交易");
        } else if (type == PNMSSettingPayPwdActionTypeSetConfirm) {
            label.text = PNLocalizedString(@"pn_ms_trade_confirm_tips", @"请再次确认商户钱包交易密码");
        } else if (type == PNMSSettingPayPwdActionTypeUpdate || type == PNMSSettingPayPwdActionTypeUpdateConfrim || type == PNMSSettingPayPwdActionTypeReset
                   || type == PNMSSettingPayPwdActionTypeResetConfirm || type == PNMSSettingPayPwdActionTypeResetOperator || type == PNMSSettingPayPwdActionTypeResetOperatorConfirm) {
            label.text = PNLocalizedString(@"pn_ms_error_tips", @"交易密码不能是重复、连续的数字");
        }

        _tipLB = label;
    }
    return _tipLB;
}
@end
