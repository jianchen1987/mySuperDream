//
//  PNForgotPasswordVerifySMSCodeController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/9/7.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNForgotPasswordVerifySMSCodeController.h"
#import "HDUnitTextField.h"
#import "NSMutableAttributedString+Highlight.h"
#import "PNUserPasswordDTO.h"
#import "PNValidateSMSCodeRspModel.h"


@interface PNForgotPasswordVerifySMSCodeController () <HDUnitTextFieldDelegate>
/// 提示
@property (nonatomic, strong) SALabel *tipLB;
/// 验证码输入框
@property (nonatomic, strong) HDUnitTextField *textField;
/// 底部时间提示
@property (nonatomic, strong) SALabel *bottomTipsLabel;
@property (nonatomic, strong) PNUserPasswordDTO *passwordDTO;
/// 回调
@property (nonatomic, copy) void (^successHandler)(BOOL needSetting, BOOL isSuccess);
@end


@implementation PNForgotPasswordVerifySMSCodeController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;
    self.successHandler = [self.parameters objectForKey:@"completion"];
    return self;
}

- (void)hd_setupViews {
    [self.view addSubview:self.tipLB];
    [self.view addSubview:self.textField];
    [self.view addSubview:self.bottomTipsLabel];
}

- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"write_verification_code", @"填写验证码");
}

- (void)updateViewConstraints {
    [self.tipLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hd_navigationBar.mas_bottom).offset(kRealWidth(28));
        make.width.equalTo(self.view).offset(-2 * kRealWidth(12));
        make.centerX.equalTo(self.view);
    }];

    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.tipLB.mas_bottom).offset(kRealWidth(20));
        CGFloat width = CGRectGetWidth(self.view.frame) - 2 * kRealWidth(25);
        CGFloat height = (width - (self.textField.inputUnitCount - 1) * self.textField.unitSpace) / self.textField.inputUnitCount;
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];

    [self.bottomTipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textField.mas_bottom).offset(kRealWidth(36));
        make.width.equalTo(self.view).offset(-2 * kRealWidth(12));
        make.centerX.equalTo(self.view);
    }];

    [super updateViewConstraints];
}

#pragma mark HDUnitTextFieldDelegate
- (void)unitTextFieldDidEndEditing:(HDUnitTextField *)textField {
    [self.view showloading];
    @HDWeakify(self);
    [self.passwordDTO validateSMSCode:textField.text success:^(PNValidateSMSCodeRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];

        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
        void (^completion)(BOOL, BOOL) = ^(BOOL needSetting, BOOL isSuccess) {
            [self.navigationController popToViewControllerClass:NSClassFromString(@"PNWalletSettingViewController")];
            !self.successHandler ?: self.successHandler(needSetting, isSuccess);
        };
        params[@"completion"] = completion;
        // 设置新密码
        params[@"actionType"] = @(4);
        params[@"accessToken"] = rspModel.token;
        params[@"serialNumber"] = rspModel.serialNumber;
        [HDMediator.sharedInstance navigaveToSettingPayPwdViewController:params];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

#pragma mark
- (SALabel *)tipLB {
    if (!_tipLB) {
        SALabel *label = SALabel.new;
        label.numberOfLines = 0;
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard16B;
        label.text = PNLocalizedString(@"input_sms_code", @"请输入短信验证码");
        _tipLB = label;
    }
    return _tipLB;
}

- (SALabel *)bottomTipsLabel {
    if (!_bottomTipsLabel) {
        SALabel *label = SALabel.new;
        label.numberOfLines = 0;
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard16;
        NSString *hightStr = @"5";
        NSString *allStr = [NSString stringWithFormat:PNLocalizedString(@"sms_code_valid_time", @"验证码有效时间 %@ 分钟"), hightStr];
        label.attributedText = [NSMutableAttributedString highLightString:hightStr inWholeString:allStr highLightFont:HDAppTheme.PayNowFont.standard16B
                                                           highLightColor:HDAppTheme.PayNowColor.mainThemeColor];

        _bottomTipsLabel = label;
    }
    return _bottomTipsLabel;
}

- (HDUnitTextField *)textField {
    if (!_textField) {
        _textField = [[HDUnitTextField alloc] initWithStyle:HDUnitTextFieldStyleBorder inputUnitCount:6];
        _textField.trackTintColor = HDAppTheme.color.C1;
        _textField.tintColor = HDAppTheme.color.G3;
        _textField.cursorColor = HDAppTheme.color.G3;
        _textField.textFont = HDAppTheme.font.standard3Bold;
        _textField.borderRadius = 5;
        _textField.autoResignFirstResponderWhenInputFinished = true;
        _textField.delegate = self;
        _textField.unitSpace = kRealWidth(10);
        _textField.textFont = [HDAppTheme.font boldForSize:22];
        if (@available(iOS 12.0, *)) {
            _textField.textContentType = UITextContentTypeOneTimeCode;
        }
        _textField.autoResignFirstResponderWhenInputFinished = true;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _textField;
}

- (PNUserPasswordDTO *)passwordDTO {
    if (!_passwordDTO) {
        _passwordDTO = [[PNUserPasswordDTO alloc] init];
    }
    return _passwordDTO;
}
@end
