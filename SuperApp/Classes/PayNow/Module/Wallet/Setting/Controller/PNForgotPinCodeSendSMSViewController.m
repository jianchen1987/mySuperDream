//
//  PNForgotPinCodeSendSMSViewController.m
//  SuperApp
//
//  Created by seeu on 2023/9/20.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNForgotPinCodeSendSMSViewController.h"
#import "PNPinCodeDTO.h"
#import "HDCountDownTimeManager.h"
#import "VipayUser.h"
#import "SASettingPayPwdViewModel.h"
#import "PNMSSMSValidateRspModel.h"


@interface PNForgotPinCodeSendSMSViewController () <HDUnitTextFieldDelegate>
/// 提示
@property (nonatomic, strong) SALabel *tipLB;
/// 验证码输入框
@property (nonatomic, strong) HDUnitTextField *textField;
/// 倒计时按钮
@property (nonatomic, strong) HDCountDownButton *countDownBTN;
/// 短信序列号
@property (nonatomic, copy) NSString *serialNum;
/// 回调
@property (nonatomic, copy) void (^successHandler)(BOOL needSetting, BOOL isSuccess);

@property (nonatomic, copy) NSString *operatorNo;

@end


@implementation PNForgotPinCodeSendSMSViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;

    self.successHandler = [self.parameters objectForKey:@"completion"];
    return self;
}

- (void)hd_setupViews {
    self.view.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self.view addSubview:self.tipLB];
    [self.view addSubview:self.textField];
    [self.view addSubview:self.countDownBTN];

    [self handleCountDownTime];
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"write_verification_code", @"填写验证码");
}

#pragma mark - private methods
- (void)handleCountDownTime {
    void (^countDownChangingHandler)(PNForgotPinCodeSendSMSViewController *) = ^(PNForgotPinCodeSendSMSViewController *vc) {
        vc.countDownBTN.countDownChangingHandler = ^NSString *(HDCountDownButton *_Nonnull countDownButton, NSUInteger second) {
            NSString *title = [NSString stringWithFormat:SALocalizedStringFromTable(@"resend_after_some_seconds", @"%zd秒后再次发送", @"Buttons"), second];
            return title;
        };
    };

    void (^countDownFinishedHandler)(PNForgotPinCodeSendSMSViewController *) = ^(PNForgotPinCodeSendSMSViewController *vc) {
        vc.countDownBTN.countDownFinishedHandler = ^NSString *(HDCountDownButton *_Nonnull countDownButton, NSUInteger second) {
            countDownButton.enabled = true;
            return SALocalizedStringFromTable(@"reget", @"重新发送", @"Buttons");
        };
    };

    static NSString *key = @"ms_forgotPinCodeSendSMSSecurityCode";
    @HDWeakify(self);
    self.countDownBTN.clickedCountDownButtonHandler = ^(HDCountDownButton *_Nonnull countDownButton) {
        @HDStrongify(self);
        // 清空
        [self.textField clear];
        countDownButton.enabled = false;

        [self showloading];
        @HDWeakify(self);
        [PNPinCodeDTO forgotPinCodeSendSmsCompletion:^(NSString *_Nullable serialNum) {
            @HDStrongify(self);
            [self dismissLoading];
            if (serialNum && HDIsStringNotEmpty(serialNum)) {
                [countDownButton startCountDownWithSecond:60];
                [HDCountDownTimeManager.shared updatePersistencedCountDownWithKey:key maxSeconds:60];
                self.serialNum = [serialNum copy];
                [self updateTipsValue:VipayUser.shareInstance.loginName];

                countDownChangingHandler(self);
                countDownFinishedHandler(self);
                
                [self.textField becomeFirstResponder];
            } else {
                countDownButton.enabled = true;
            }
        }];
    };

    // 获取本地是否有剩余秒数记录
    NSInteger oldSeconds = [HDCountDownTimeManager.shared getPersistencedCountDownSecondsWithKey:key];
    if (oldSeconds > 1) {
        self.countDownBTN.enabled = false;
        [self.countDownBTN startCountDownWithSecond:oldSeconds];
        countDownChangingHandler(self);
        countDownFinishedHandler(self);
        [self.textField becomeFirstResponder];
    } else {
        // 主动点击
        [self.countDownBTN sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - HDUnitTextFieldDelegate
- (void)unitTextFieldDidEndEditing:(HDUnitTextField *)textField {
    [self showloading];
    @HDWeakify(self);
    [PNPinCodeDTO validateForgotPinCodeSMSWithCode:textField.text serialNum:self.serialNum success:^(PNMSSMSValidateRspModel *_Nullable rspModel) {
        @HDStrongify(self);
        [self dismissLoading];
        [self.view endEditing:YES];
        
        [HDMediator.sharedInstance navigaveToSettingPayPwdViewController:@{@"actionType": @(SASettingPayPwdActionTypePinCodeNew), @"completion": self.successHandler, @"accessToken": rspModel.token}];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}

#pragma mark - layout
- (void)updateViewConstraints {
    [self.tipLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hd_navigationBar.mas_bottom).offset(kRealWidth(30));
        make.width.equalTo(self.view).offset(-2 * kRealWidth(15));
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

    [self updateCountDownBTNConstraints];

    [super updateViewConstraints];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    [self updateSendSMSButtonBorder];
}

- (void)updateCountDownBTNConstraints {
    [self.countDownBTN sizeToFit];
    [self.countDownBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.textField.mas_bottom).offset(kRealWidth(50));
        if (self.countDownBTN.shouldUseNormalStateWidth) {
            make.size.mas_equalTo(CGSizeMake(self.countDownBTN.normalStateWidth, CGRectGetHeight(self.countDownBTN.bounds)));
        } else {
            make.size.mas_equalTo(self.countDownBTN.bounds.size);
        }
    }];
}

- (void)updateSendSMSButtonBorder {
    if (_countDownBTN && !CGSizeIsEmpty(_countDownBTN.bounds.size)) {
        self.countDownBTN.layer.cornerRadius = CGRectGetHeight(self.countDownBTN.frame) * 0.5;
        self.countDownBTN.layer.borderWidth = 1;
        self.countDownBTN.layer.borderColor = [self.countDownBTN titleColorForState:self.countDownBTN.state].CGColor;
    }
}

- (void)updateTipsValue:(NSString *)mobile {
    NSString *mobileStr = mobile;
    if (mobileStr.length > 4) {
        mobileStr = [mobileStr substringFromIndex:mobileStr.length - 4];
    }

    NSString *str = [NSString stringWithFormat:SALocalizedString(@"sendSms_enter_inputCode", @"我们已向您的手机尾号%@\n发送短信，请查看短信并输入验证码"), mobileStr];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str
                                                                             attributes:@{NSFontAttributeName: HDAppTheme.font.standard3, NSForegroundColorAttributeName: HDAppTheme.color.G2}];
    [text setAttributes:@{NSFontAttributeName: HDAppTheme.font.standard3Bold, NSForegroundColorAttributeName: HDAppTheme.color.G1} range:[str rangeOfString:mobileStr]];
    self.tipLB.attributedText = text;
}

#pragma mark - lazy load
- (SALabel *)tipLB {
    if (!_tipLB) {
        SALabel *label = SALabel.new;
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        _tipLB = label;
    }
    return _tipLB;
}

- (HDUnitTextField *)textField {
    if (!_textField) {
        _textField = [[HDUnitTextField alloc] initWithStyle:HDUnitTextFieldStyleBorder inputUnitCount:6];
        _textField.trackTintColor = HDAppTheme.PayNowColor.mainThemeColor;
        _textField.tintColor = HDAppTheme.color.G3;
        _textField.cursorColor = HDAppTheme.PayNowColor.mainThemeColor;
        _textField.textFont = HDAppTheme.font.standard3Bold;
        _textField.borderRadius = kRealWidth(8);
        _textField.autoResignFirstResponderWhenInputFinished = true;
        _textField.delegate = self;
        _textField.unitSpace = kRealWidth(8);
        _textField.textFont = [HDAppTheme.font boldForSize:22];
        if (@available(iOS 12.0, *)) {
            _textField.textContentType = UITextContentTypeOneTimeCode;
        }
        _textField.autoResignFirstResponderWhenInputFinished = true;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _textField;
}

- (HDCountDownButton *)countDownBTN {
    if (!_countDownBTN) {
        HDCountDownButton *button = [HDCountDownButton buttonWithType:UIButtonTypeCustom];
        button.titleEdgeInsets = UIEdgeInsetsMake(7, 15, 7, 15);
        button.titleLabel.font = HDAppTheme.font.standard3;
        [button setTitleColor:HDAppTheme.color.C1 forState:UIControlStateNormal];
        [button setTitleColor:HDAppTheme.color.G2 forState:UIControlStateDisabled];
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
        _countDownBTN = button;
    }
    return _countDownBTN;
}

@end
