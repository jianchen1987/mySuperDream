//
//  PNMSGetSMSCodeView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/6/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSGetSMSCodeView.h"
#import "NSMutableAttributedString+Highlight.h"


@interface PNMSGetSMSCodeView ()
@property (nonatomic, strong) SALabel *titleLabel;
@property (nonatomic, strong) HDUITextField *inputTextField;
@property (nonatomic, strong) HDCountDownButton *getCodeBtn;
@end


@implementation PNMSGetSMSCodeView

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
    [self addSubview:self.titleLabel];
    [self addSubview:self.inputTextField];
    [self addSubview:self.getCodeBtn];
}

- (void)updateConstraints {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-12));
        make.top.mas_equalTo(self.mas_top).offset(kRealWidth(24));
    }];

    [self.inputTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.getCodeBtn.mas_left).offset(kRealWidth(-12));
        make.bottom.mas_equalTo(self.getCodeBtn.mas_bottom);
    }];

    [self.getCodeBtn sizeToFit];
    [self.getCodeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(4));
        make.left.mas_equalTo(self.inputTextField.mas_right).offset(kRealWidth(12));
        make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-12));
        make.width.equalTo(@(self.getCodeBtn.width + kRealWidth(32)));
        make.height.equalTo(@(self.getCodeBtn.height + kRealWidth(12)));
        make.bottom.mas_equalTo(self.mas_bottom).offset(kRealWidth(-12));
    }];

    [super updateConstraints];
}

#pragma mark
- (void)sendSMS {
}

- (void)startCountDown {
    [self.getCodeBtn startCountDownWithSecond:120];
}

#pragma mark
- (SALabel *)titleLabel {
    if (!_titleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard14B;
        NSString *hightStr = @"*";
        NSString *allStr = [NSString stringWithFormat:@"%@%@", hightStr, PNLocalizedString(@"ms_verification_code", @"验证码")];
        label.attributedText = [NSMutableAttributedString highLightString:hightStr inWholeString:allStr highLightFont:HDAppTheme.PayNowFont.standard14B
                                                           highLightColor:HDAppTheme.PayNowColor.mainThemeColor];
        _titleLabel = label;
    }
    return _titleLabel;
}

- (HDUITextField *)inputTextField {
    if (!_inputTextField) {
        _inputTextField = [[HDUITextField alloc] initWithPlaceholder:PNLocalizedString(@"ms_input_sms_code", @"请输入短信验证码") leftLabelString:@""];
        HDUITextFieldConfig *config = [_inputTextField getCurrentConfig];
        config.floatingText = @"";
        config.keyboardType = UIKeyboardTypeNumberPad;
        config.font = HDAppTheme.font.standard2;
        config.textColor = HDAppTheme.PayNowColor.c333333;
        config.bottomLineNormalHeight = 0;
        config.bottomLineSelectedHeight = 0;
        config.maxInputLength = 6;
        config.placeholderFont = HDAppTheme.PayNowFont.standard14B;
        config.placeholderColor = HDAppTheme.PayNowColor.cCCCCCC;
        [_inputTextField setConfig:config];

        @HDWeakify(self);
        _inputTextField.textFieldDidChangeBlock = ^(NSString *text) {
            @HDStrongify(self);
            !self.inputChangeBlock ?: self.inputChangeBlock(self.inputTextField.validInputText);
        };
    }
    return _inputTextField;
}

- (HDCountDownButton *)getCodeBtn {
    if (!_getCodeBtn) {
        HDCountDownButton *button = [HDCountDownButton buttonWithType:UIButtonTypeCustom];
        //        button.titleEdgeInsets = UIEdgeInsetsMake(7, 10, 7, 10);
        button.titleLabel.font = HDAppTheme.PayNowFont.standard14B;
        [button setTitleColor:HDAppTheme.PayNowColor.mainThemeColor forState:UIControlStateNormal];
        [button setTitleColor:HDAppTheme.color.G2 forState:UIControlStateDisabled];
        button.layer.borderColor = HDAppTheme.PayNowColor.mainThemeColor.CGColor;
        button.layer.borderWidth = 1;
        button.layer.cornerRadius = kRealWidth(4);
        button.shouldUseNormalStateWidth = YES;
        [button setTitle:PNLocalizedString(@"ms_get_sms_code", @"点击获取") forState:0];
        @HDWeakify(self);
        button.countDownStateChangedHandler = ^(HDCountDownButton *_Nonnull countDownButton, BOOL enabled) {
            //            @HDStrongify(self);
            //            [self updateCountDownBTNConstraints];
        };
        button.notNormalStateWidthGreaterThanNormalBlock = ^(HDCountDownButton *_Nonnull countDownButton) {
            @HDStrongify(self);
            [self setNeedsUpdateConstraints];
        };
        button.restoreNormalStateWidthBlock = ^(HDCountDownButton *_Nonnull countDownButton) {
            //            @HDStrongify(self);
            //            [self updateCountDownBTNConstraints];
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
            !self.clickSendSMSCodeBlock ?: self.clickSendSMSCodeBlock();
        };

        _getCodeBtn = button;
    }
    return _getCodeBtn;
}
@end
