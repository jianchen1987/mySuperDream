//
//  SAMyInfomationSetContactNumberViewController.m
//  SuperApp
//
//  Created by Tia on 2023/8/16.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAMyInfomationSetContactNumberViewController.h"
#import "SALoginViewModel.h"
#import "SALoginAreaCodeView.h"
#import "SASetPhoneByVerificationCodeViewController.h"

@interface SAMyInfomationSetContactNumberViewController ()
/// 头部
@property (nonatomic, strong) UILabel *headerLabel;
/// 选择国家
@property (nonatomic, strong) SALoginAreaCodeView *changeCountryEntryView;
/// 帐号输入框
@property (nonatomic, strong) HDUITextField *accountTextField;
/// 登陆按钮
@property (nonatomic, strong) SAOperationButton *loginBTN;

@end

@implementation SAMyInfomationSetContactNumberViewController

- (void)hd_setupViews {
    [self.view addSubview:self.headerLabel];
    [self.view addSubview:self.changeCountryEntryView];
    [self.view addSubview:self.accountTextField];
    [self.view addSubview:self.loginBTN];
    
    if(self.contactNumber) {
        // 获取国家
        NSString *countryCode = [SAGeneralUtil getCountryCodeFromFullAccountNo:self.contactNumber];
        NSString *shortAccountNo = [SAGeneralUtil getShortAccountNoFromFullAccountNo:self.contactNumber];
        [self.changeCountryEntryView setCountryWithCountryCode:countryCode];
        [self.accountTextField setTextFieldText:shortAccountNo];
    }
}

- (void)updateViewConstraints {
    CGFloat margin = 12;

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

#pragma mark - event response
- (void)clickedLoginBTNHandler {
    [self.view endEditing:true];
    
    NSString *phoneNumber = self.accountTextField.validInputText;
    NSString *countryCode = self.changeCountryEntryView.currentCountryModel.countryCode;
    if (![phoneNumber hasPrefix:@"0"] && [countryCode isEqualToString:@"855"]) {
        phoneNumber = [@"0" stringByAppendingString:phoneNumber];
    }
    
    NSString *contactNumber = [NSString stringWithFormat:@"%@%@",countryCode,phoneNumber];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"operatorNo"] = SAUser.shared.operatorNo;
    params[@"contactNumber"] = contactNumber;
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/operator/info/modify.do";
    request.isNeedLogin = YES;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    request.requestParameter = params;
    @HDWeakify(self);
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        @HDStrongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(HDNetworkResponse *_Nonnull response) {
        SARspModel *rspModel = response.extraData;
        if(rspModel && HDIsStringNotEmpty(rspModel.msg)) {
            [NAT showToastWithTitle:nil content:rspModel.msg type:HDTopToastTypeError];
        }
    }];
}

#pragma mark - lazy load
- (UILabel *)headerLabel {
    if (!_headerLabel) {
        UILabel *label = UILabel.new;
        label.text = SALocalizedString(@"login_new2_Please set mobile number", @"请设置手机号码");
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:24 weight:UIFontWeightHeavy];
        label.hd_lineSpace = 12;
        label.textColor = HDAppTheme.color.sa_C333;
        _headerLabel = label;
    }
    return _headerLabel;
}

- (SAOperationButton *)loginBTN {
    if (!_loginBTN) {
        _loginBTN = [SAOperationButton buttonWithType:UIButtonTypeCustom];
        _loginBTN.titleLabel.font = HDAppTheme.font.sa_standard16H;
        [_loginBTN addTarget:self action:@selector(clickedLoginBTNHandler) forControlEvents:UIControlEventTouchUpInside];
        _loginBTN.enabled = false;
        [_loginBTN setTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons") forState:UIControlStateNormal];
    }
    return _loginBTN;
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

@end
