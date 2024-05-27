//
//  PNSetAmountView.m
//  SuperApp
//
//  Created by xixi_wen on 2021/12/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNSetAmountView.h"
#import "HDUITextField.h"
#import "NSString+HD_Validator.h"
#import "NSString+matchs.h"
#import "PNEnum.h"
#import "SAInfoView.h"


@interface PNSetAmountView ()
@property (nonatomic, strong) SAInfoView *accountInfoView;
@property (nonatomic, strong) SAOperationButton *confirmButton;

@property (nonatomic, strong) UIView *amountBgView;
@property (nonatomic, strong) HDUITextField *amountTextField;

@end


@implementation PNSetAmountView

- (void)hd_setupViews {
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
    [self.scrollViewContainer addSubview:self.accountInfoView];
    [self.scrollViewContainer addSubview:self.amountBgView];
    [self.amountBgView addSubview:self.amountTextField];
    [self addSubview:self.confirmButton];

    [self handlerChoose];
}

- (void)updateConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.equalTo(self);
        make.bottom.equalTo(self.confirmButton.mas_top).offset(-kRealWidth(30));
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    NSArray<UIView *> *visableViews = [self.scrollViewContainer.subviews hd_filterWithBlock:^BOOL(UIView *_Nonnull item) {
        return !item.isHidden;
    }];

    UIView *lastView;
    for (UIView *view in visableViews) {
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (!lastView) {
                make.top.equalTo(self.scrollViewContainer);
            } else {
                make.top.equalTo(lastView.mas_bottom);
            }
            make.left.right.equalTo(self.scrollViewContainer);
            if (![view isKindOfClass:SAInfoView.class]) {
                make.height.equalTo(@(kRealWidth(42)));
            }
            if (view == visableViews.lastObject) {
                make.bottom.equalTo(self.scrollViewContainer);
                if ([view isKindOfClass:SAInfoView.class]) {
                    SAInfoView *infoView = (SAInfoView *)view;
                    infoView.model.lineWidth = 0;
                    [infoView setNeedsUpdateContent];
                }
            }
        }];
        lastView = view;
    }

    ///// ------begin--------
    [self.amountTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-15));
        make.left.mas_equalTo(self.amountBgView.mas_left).offset(kRealWidth(15));
        make.centerY.mas_equalTo(self.amountBgView.mas_centerY);
    }];
    ///// -------end-------

    [self.confirmButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self).offset(-UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding));
        make.height.mas_equalTo(HDAppTheme.value.buttonHeight);
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self).offset(-(kiPhoneXSeriesSafeBottomHeight + kRealWidth(30)));
    }];
    [super updateConstraints];
}

#pragma mark
- (void)handlerChoose {
    [self.amountTextField resignFirstResponder];

    HDActionSheetView *sheetView = [HDActionSheetView alertViewWithCancelButtonTitle:PNLocalizedString(@"BUTTON_TITLE_CANCEL", @"取消") config:nil];
    sheetView.allowTapBackgroundDismiss = NO;

    // clang-format off
    HDActionSheetViewButton *khrBTN = [HDActionSheetViewButton buttonWithTitle:PNLocalizedString(@"KHR_account", @"瑞尔账户") type:HDActionSheetViewButtonTypeCustom handler:^(HDActionSheetView * _Nonnull alertView, HDActionSheetViewButton * _Nonnull button) {
        [sheetView dismiss];
        [self setKeyBoard:2];

        [self setAccountValue:PNLocalizedString(@"KHR_account", @"瑞尔账户")];
        
        HDUITextFieldConfig *config = [self.amountTextField getCurrentConfig];
        config.maxInputNumber = [self getMaxHKR];
        [self.amountTextField setConfig:config];
    }];
    HDActionSheetViewButton *usdBTN = [HDActionSheetViewButton buttonWithTitle:PNLocalizedString(@"USD_account", @"美元账户") type:HDActionSheetViewButtonTypeCustom handler:^(HDActionSheetView * _Nonnull alertView, HDActionSheetViewButton * _Nonnull button) {
        [sheetView dismiss];
        [self setKeyBoard:1];
        
        [self setAccountValue:PNLocalizedString(@"USD_account", @"美元账户")];
        
        HDUITextFieldConfig *config = [self.amountTextField getCurrentConfig];
        config.maxInputNumber = [self getMaxUSD];
        [self.amountTextField setConfig:config];
    }];
    // clang-format on
    [sheetView addButtons:@[usdBTN, khrBTN]];
    [sheetView show];
}

- (void)setKeyBoard:(NSInteger)type {
    [_amountTextField.inputTextField.inputView removeFromSuperview];
    HDKeyBoardType keyBaoardType = HDKeyBoardTypeDecimalPad;
    if (type == 2) {
        keyBaoardType = HDKeyBoardTypeNumberPad;
    }
    HDKeyBoardTheme *theme = HDKeyBoardTheme.new;
    theme.enterpriseText = @"";
    HDKeyBoard *kb = [HDKeyBoard keyboardWithType:keyBaoardType theme:theme];

    kb.inputSource = _amountTextField.inputTextField;
    _amountTextField.inputTextField.inputView = kb;
}

- (void)setAccountValue:(NSString *)value {
    self.accountInfoView.model.valueText = value;
    self.accountInfoView.model.valueColor = HDAppTheme.PayNowColor.c343B4D;
    [self.accountInfoView setNeedsUpdateContent];
    [self ruleButton];

    if (!WJIsStringNotEmpty(self.amountTextField.validInputText)) {
        [self.amountTextField becomeFirstResponder];
    }
}

- (void)ruleButton {
    if (![self.accountInfoView.model.valueText isEqualToString:PNLocalizedString(@"please_select", @"请选择")] && [self.amountTextField.validInputText matches:REGEX_AMOUNT]) {
        self.confirmButton.enabled = YES;
    } else {
        self.confirmButton.enabled = NO;
    }
    //    if (![self.accountInfoView.model.valueText isEqualToString:PNLocalizedString(@"please_select", @"请选择")] && self.amountTextField.validInputText.doubleValue >= 0 &&
    //        [self.amountTextField.validInputText matches:REGEX_AMOUNT]) {
    //        NSString *amountStr = self.amountTextField.validInputText;
    //
    //        if ([self.accountInfoView.model.valueText isEqualToString:PNLocalizedString(@"KHR_account", @"瑞尔账户")]) {
    //            if ([amountStr hd_isPureInt] && (amountStr.integerValue >= 0 && amountStr.integerValue <= [self getMaxHKR])) {
    //                self.confirmButton.enabled = YES;
    //            } else {
    //                self.confirmButton.enabled = NO;
    //            }
    //        } else {
    //            if (([amountStr hd_isPureInt] || [amountStr hd_isPureFloat]) && (amountStr.doubleValue >= 0 && amountStr.doubleValue <= [self getMaxUSD])) {
    //                self.confirmButton.enabled = YES;
    //            } else {
    //                self.confirmButton.enabled = NO;
    //            }
    //        }
    //    } else {
    //        self.confirmButton.enabled = NO;
    //    }
}

- (double)getMaxUSD {
    /*
     * 个人
       美元最大9999.99，最小0
       端尔最大999999999，最小0

       商户
       美元最大1000，最小0
       端尔最大4000000，最小0
     */

    if (self.amountType == PNSetAmountType_Persion) {
        return 9999.99;
    } else if (self.amountType == PNSetAmountType_Merchant) {
        return 1000.0;
    } else {
        return 0;
    }
}

- (NSInteger)getMaxHKR {
    /*
     * 个人
       美元最大9999.99，最小0
       端尔最大999999999，最小0


       商户
       美元最大1000，最小0
       端尔最大4000000，最小0
     */

    if (self.amountType == PNSetAmountType_Persion) {
        return 999999999;
    } else if (self.amountType == PNSetAmountType_Merchant) {
        return 4000000;
    } else {
        return 0;
    }
}

#pragma mark
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self ruleButton];
}

#pragma mark
- (SAInfoViewModel *)infoViewModelWithKey:(NSString *)key {
    SAInfoViewModel *model = SAInfoViewModel.new;
    model.keyColor = HDAppTheme.color.G1;
    model.valueColor = HDAppTheme.color.G3;
    model.keyText = key;
    model.enableTapRecognizer = true;
    return model;
}

- (SAInfoViewModel *)infoViewModelWithArrowImageAndKey:(NSString *)key {
    SAInfoViewModel *model = [self infoViewModelWithKey:key];
    model.rightButtonImage = [UIImage imageNamed:@"pn_arrow_gray_small"];
    return model;
}

#pragma mark
- (SAInfoView *)accountInfoView {
    if (!_accountInfoView) {
        SAInfoView *view = SAInfoView.new;
        SAInfoViewModel *model = [self infoViewModelWithArrowImageAndKey:PNLocalizedString(@"receive_account", @"收款账户")];
        model.valueText = PNLocalizedString(@"please_select", @"请选择");
        model.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        @HDWeakify(self);
        model.eventHandler = ^{
            @HDStrongify(self);
            [self handlerChoose];
        };
        view.model = model;
        _accountInfoView = view;
    }
    return _accountInfoView;
}

- (SAOperationButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [SAOperationButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:PNLocalizedString(@"BUTTON_TITLE_CONFIRM", @"确认") forState:0];
        _confirmButton.enabled = NO;
        @HDWeakify(self);
        [_confirmButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            NSString *account = PNCurrencyTypeUSD;
            if ([self.accountInfoView.model.valueText isEqualToString:PNLocalizedString(@"USD_account", @"美元账户")]) {
                account = PNCurrencyTypeUSD;
            } else if ([self.accountInfoView.model.valueText isEqualToString:PNLocalizedString(@"KHR_account", @"瑞尔账户")]) {
                account = PNCurrencyTypeKHR;
            }

            //进行数据校验
            NSString *amountStr = self.amountTextField.validInputText;
            ///针对数据做一下格式化，防止用户输入了 0000.88 这样的
            if ([self.amountTextField.validInputText containsString:@"."]) {
                amountStr = [NSString stringWithFormat:@"%0.2f", self.amountTextField.validInputText.doubleValue];
            }

            !self.callback ?: self.callback(amountStr, account);

            [self.viewController.navigationController popViewControllerAnimated:YES];
        }];

        _confirmButton.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(20)];
        };
    }
    return _confirmButton;
}

- (UIView *)amountBgView {
    if (!_amountBgView) {
        _amountBgView = [[UIView alloc] init];
        _amountBgView.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
    }
    return _amountBgView;
}

- (HDUITextField *)amountTextField {
    if (!_amountTextField) {
        _amountTextField = [[HDUITextField alloc] initWithPlaceholder:PNLocalizedString(@"please_input_amout", @"请输入金额") leftLabelString:PNLocalizedString(@"receive_amount", @"收款金额")];
        HDUITextFieldConfig *config = [_amountTextField getCurrentConfig];
        config.floatingText = @"";
        config.font = HDAppTheme.PayNowFont.standard15;
        config.textColor = HDAppTheme.color.G1;
        config.marginFloatingLabelToTextField = kRealWidth(4);
        config.marginBottomLineToTextField = kRealWidth(15);
        config.placeholderFont = HDAppTheme.PayNowFont.standard15;
        config.placeholderColor = HDAppTheme.color.G3;
        config.leftLabelColor = HDAppTheme.PayNowColor.c343B4D;
        config.leftLabelFont = HDAppTheme.PayNowFont.standard15;
        config.maxDecimalsCount = 2;
        config.keyboardType = UIKeyboardTypeDecimalPad;
        config.maxInputLength = 10;
        config.characterSetString = kCharacterSetStringAmount;
        config.textAlignment = NSTextAlignmentRight;
        config.bottomLineNormalHeight = 0;
        config.bottomLineSelectedHeight = 0;

        [_amountTextField setConfig:config];
        __weak __typeof(self) weakSelf = self;
        _amountTextField.textFieldDidChangeBlock = ^(NSString *text) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf ruleButton];
        };

        _amountTextField.delegate = (id)self;

        HDKeyBoardTheme *theme = HDKeyBoardTheme.new;
        theme.enterpriseText = @"";
        HDKeyBoard *kb = [HDKeyBoard keyboardWithType:HDKeyBoardTypeDecimalPad theme:theme];

        kb.inputSource = _amountTextField.inputTextField;
        _amountTextField.inputTextField.inputView = kb;
    }
    return _amountTextField;
}

- (BOOL)hd_textFieldShouldBeginEditing:(UITextField *)textField {
    HDLog(@"hd_textFieldShouldBeginEditing");
    if (![self.accountInfoView.model.valueText isEqualToString:PNLocalizedString(@"please_select", @"请选择")]) {
        return YES;
    } else {
        [self handlerChoose];
        return NO;
    }
}
@end
