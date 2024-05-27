//
//  SAAddOrModifyAddressValidateCodeView.m
//  SuperApp
//
//  Created by seeu on 2021/11/7.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAAddOrModifyAddressValidateCodeView.h"
#import "HDCountDownTimeManager.h"
#import "SASMSCodeDTO.h"


@interface SAAddOrModifyAddressValidateCodeView ()

@property (nonatomic, strong) HDUITextField *validateCodeTF;   ///< 验证码输入框
@property (nonatomic, strong) HDCountDownButton *countDownBTN; ///< 倒计时按钮
@property (nonatomic, copy) NSString *mobile;                  ///< 缓存的电话
@property (nonatomic, strong) SASMSCodeDTO *smsDTO;            ///<

@end


@implementation SAAddOrModifyAddressValidateCodeView

- (void)hd_setupViews {
    [super hd_setupViews];

    [self addSubview:self.validateCodeTF];
    [self addSubview:self.countDownBTN];

    self.titleLB.text = SALocalizedString(@"validate_code", @"验证码");
    self.mobile = @"";
}

- (void)updateConstraints {
    // 覆盖父类
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(HDAppTheme.value.padding.left);
        make.width.mas_equalTo(100);
        make.centerY.equalTo(self.validateCodeTF.inputTextField);
    }];

    [self.validateCodeTF mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-kRealWidth(15));
        make.right.equalTo(self.countDownBTN.mas_left).offset(-HDAppTheme.value.padding.right);
        make.left.equalTo(self.titleLB.mas_right);
        make.height.mas_equalTo(kRealWidth(30));
    }];

    [self.validateCodeTF.inputTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
    }];

    [self updateCountDownBTNConstraints];

    [super updateConstraints];
}

- (void)updateCountDownBTNConstraints {
    [self.countDownBTN sizeToFit];
    [self.countDownBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-HDAppTheme.value.padding.right);
        make.centerY.equalTo(self.titleLB.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(self.countDownBTN.normalStateWidth, CGRectGetHeight(self.countDownBTN.bounds)));
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateSendSMSButtonBorder];
}

- (void)hd_languageDidChanged {
    [self.countDownBTN setTitle:SALocalizedString(@"get_sms_code", @"获取验证码") forState:UIControlStateNormal];
    self.countDownBTN.normalStateWidth = [self.countDownBTN sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;

    [self setNeedsUpdateConstraints];
}

#pragma mark - public methods
- (void)sendValidateSmsWthMobileNo:(NSString *)mobile {
    if (HDIsStringEmpty(mobile)) {
        return;
    }

    self.mobile = mobile;
    // 获取本地是否有剩余秒数记录
    NSInteger oldSeconds = [HDCountDownTimeManager.shared getPersistencedCountDownSecondsWithKey:SASendSMSTypeValidateConsigneeMobile];
    if (oldSeconds > 1) {
        self.countDownBTN.enabled = false;
        [self.countDownBTN startCountDownWithSecond:oldSeconds];
        [self.validateCodeTF.inputTextField becomeFirstResponder];
    } else {
        [self.countDownBTN sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - private methods

- (void)sendSMS {
    if (HDIsStringNotEmpty(self.mobile)) {
        HDLog(@"发送短信:%@", self.mobile);
        [self.superview showloading];
        self.countDownBTN.enabled = NO;
        @HDWeakify(self);
        [self.smsDTO sendSMSWithPhoneNo:self.mobile type:SASendSMSTypeValidateConsigneeMobile success:^{
            @HDStrongify(self);
            [self.superview dismissLoading];
            [self.validateCodeTF.inputTextField becomeFirstResponder];
            [self.countDownBTN startCountDownWithSecond:60];
            [HDCountDownTimeManager.shared updatePersistencedCountDownWithKey:SASendSMSTypeValidateConsigneeMobile maxSeconds:60];
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self.superview dismissLoading];
            self.countDownBTN.enabled = YES;
        }];
    } else {
        // 提示
    }
}

- (void)updateSendSMSButtonBorder {
    if (_countDownBTN && !CGSizeIsEmpty(_countDownBTN.bounds.size)) {
        self.countDownBTN.layer.cornerRadius = 5;
        self.countDownBTN.layer.borderWidth = 0.5;
        self.countDownBTN.layer.borderColor = [self.countDownBTN titleColorForState:self.countDownBTN.state].CGColor;
    }
}

#pragma mark - getter
- (NSString *)validateCode {
    return self.validateCodeTF.validInputText;
}

#pragma mark - lazy load
- (HDUITextField *)validateCodeTF {
    if (!_validateCodeTF) {
        HDUITextField *textField = [[HDUITextField alloc] initWithPlaceholder:SALocalizedString(@"validate_code", @"验证码") leftLabelString:@""];
        HDUITextFieldConfig *config = [textField getCurrentConfig];
        config.font = HDAppTheme.font.standard3;
        config.textColor = HDAppTheme.color.G1;
        config.placeholderFont = HDAppTheme.font.standard3;
        config.placeholderColor = HDAppTheme.color.G3;
        config.floatingText = @" ";
        config.characterSetString = kCharacterSetStringNumber;
        config.bottomLineNormalHeight = 0;
        config.bottomLineSelectedHeight = 0;
        config.maxInputLength = 6;
        config.leftViewEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);

        [textField setConfig:config];

        _validateCodeTF = textField;
    }
    return _validateCodeTF;
}

- (HDCountDownButton *)countDownBTN {
    if (!_countDownBTN) {
        HDCountDownButton *button = [HDCountDownButton buttonWithType:UIButtonTypeCustom];
        button.titleEdgeInsets = UIEdgeInsetsMake(7, 10, 7, 10);
        button.titleLabel.font = HDAppTheme.font.standard3;
        [button setTitleColor:HDAppTheme.color.C1 forState:UIControlStateNormal];
        [button setTitleColor:HDAppTheme.color.G2 forState:UIControlStateDisabled];
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
            NSString *title = [NSString stringWithFormat:SALocalizedString(@"resend_second_less", @"%zd秒"), second];
            return title;
        };

        button.countDownFinishedHandler = ^NSString *(HDCountDownButton *_Nonnull countDownButton, NSUInteger second) {
            countDownButton.enabled = YES;
            return SALocalizedStringFromTable(@"reget", @"重新发送", @"Buttons");
        };
        button.clickedCountDownButtonHandler = ^(HDCountDownButton *_Nonnull countDownButton) {
            @HDStrongify(self);
            [self sendSMS];
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
