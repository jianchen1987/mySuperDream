//
//  SAChangePayPwdInputSMSViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/8/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAChangePayPwdInputSMSViewController.h"
#import "HDCountDownTimeManager.h"
#import "SAVerifySMSCodeRspModel.h"
#import "SAWalletDTO.h"


@interface SAChangePayPwdInputSMSViewController () <HDUnitTextFieldDelegate>
/// 提示
@property (nonatomic, strong) SALabel *tipLB;
/// 验证码输入框
@property (nonatomic, strong) HDUnitTextField *textField;
/// 发送验证码 VM
@property (nonatomic, strong) SAWalletDTO *walletDTO;
/// 倒计时按钮
@property (nonatomic, strong) HDCountDownButton *countDownBTN;
/// 短信序列号
@property (nonatomic, copy) NSString *serialNum;
/// 回调
@property (nonatomic, copy) void (^successHandler)(BOOL needSetting, BOOL isSuccess);
@end


@implementation SAChangePayPwdInputSMSViewController
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
    [self.view addSubview:self.countDownBTN];

    [self handleCountDownTime];
}

- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"write_verification_code", @"填写验证码");
}

#pragma mark - private methods
- (void)handleCountDownTime {
    void (^countDownChangingHandler)(SAChangePayPwdInputSMSViewController *) = ^(SAChangePayPwdInputSMSViewController *vc) {
        vc.countDownBTN.countDownChangingHandler = ^NSString *(HDCountDownButton *_Nonnull countDownButton, NSUInteger second) {
            NSString *title = [NSString stringWithFormat:SALocalizedStringFromTable(@"resend_after_some_seconds", @"%zd秒后再次发送", @"Buttons"), second];
            return title;
        };
    };

    void (^countDownFinishedHandler)(SAChangePayPwdInputSMSViewController *) = ^(SAChangePayPwdInputSMSViewController *vc) {
        vc.countDownBTN.countDownFinishedHandler = ^NSString *(HDCountDownButton *_Nonnull countDownButton, NSUInteger second) {
            countDownButton.enabled = true;
            return SALocalizedStringFromTable(@"reget", @"重新发送", @"Buttons");
        };
    };

    static NSString *key = @"changeWalletPayPwdSMSSecurityCode";
    @HDWeakify(self);
    self.countDownBTN.clickedCountDownButtonHandler = ^(HDCountDownButton *_Nonnull countDownButton) {
        @HDStrongify(self);
        // 清空
        [self.textField clear];
        countDownButton.enabled = false;

        [self showloading];
        @HDWeakify(self);
        [self.walletDTO sendSMSCodeSuccess:^(NSString *_Nonnull serialNum) {
            @HDStrongify(self);
            [self dismissLoading];

            [countDownButton startCountDownWithSecond:60];
            [HDCountDownTimeManager.shared updatePersistencedCountDownWithKey:key maxSeconds:60];
            countDownChangingHandler(self);
            countDownFinishedHandler(self);

            self.serialNum = serialNum;
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self dismissLoading];
            countDownButton.enabled = true;
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

    void (^failureBlock)(SARspModel *_Nonnull, CMResponseErrorType, NSError *_Nonnull) = ^void(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
        @HDStrongify(self);
        [self dismissLoading];
    };

    // 60 秒内不重复发送，也就获取不到新的序列号，随便用个序列号解决后端抛‘不能为空’问题
    NSString *serialNum = HDIsStringEmpty(self.serialNum) ? @"1301347403747045376" : self.serialNum;
    [self.walletDTO verifySMSCodeWithSmsCode:textField.text serialNum:serialNum success:^(SAVerifySMSCodeRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self dismissLoading];
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
        void (^completion)(BOOL, BOOL) = ^(BOOL needSetting, BOOL isSuccess) {
            [self.navigationController popToViewControllerClass:NSClassFromString(@"PNWalletSettingViewController")];
            !self.successHandler ?: self.successHandler(needSetting, isSuccess);
        };
        params[@"completion"] = completion;
        // 设置新密码
        params[@"actionType"] = @(4);
        params[@"accessToken"] = rspModel.apiTicket;
        [HDMediator.sharedInstance navigaveToSettingPayPwdViewController:params];
    } failure:failureBlock];
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

#pragma mark - lazy load
- (SALabel *)tipLB {
    if (!_tipLB) {
        SALabel *label = SALabel.new;
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        NSString *numberSuffix, *loginName = SAUser.shared.loginName;
        if (HDIsStringNotEmpty(loginName) && loginName.length >= 4) {
            numberSuffix = [loginName substringFromIndex:loginName.length - 4];
        }
        NSString *str = [NSString stringWithFormat:SALocalizedString(@"sendSms_enter_inputCode", @"我们已向您的手机尾号%@\n发送短信，请查看短信并输入验证码"), numberSuffix];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str
                                                                                 attributes:@{NSFontAttributeName: HDAppTheme.font.standard3, NSForegroundColorAttributeName: HDAppTheme.color.G2}];
        [text setAttributes:@{NSFontAttributeName: HDAppTheme.font.standard3Bold, NSForegroundColorAttributeName: HDAppTheme.color.G1} range:[str rangeOfString:numberSuffix]];
        label.attributedText = text;
        _tipLB = label;
    }
    return _tipLB;
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

- (SAWalletDTO *)walletDTO {
    return _walletDTO ?: ({ _walletDTO = SAWalletDTO.new; });
}
@end
