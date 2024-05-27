//
//  WMPromoCodeAlertView.m
//  SuperApp
//
//  Created by wmz on 2022/9/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMPromoCodeAlertView.h"


@interface WMPromoCodeAlertView ()
/// titleLb
@property (nonatomic, strong) HDLabel *titleLB;
/// inputTF
@property (nonatomic, strong) UITextField *inputTF;
///不使用
@property (nonatomic, strong) HDUIButton *notUseBTN;
///确认
@property (nonatomic, strong) SAOperationButton *submitBTN;

@end


@implementation WMPromoCodeAlertView

- (void)hd_setupViews {
    [self addSubview:self.titleLB];
    [self addSubview:self.inputTF];
    [self addSubview:self.notUseBTN];
    [self addSubview:self.submitBTN];
    // 延迟弹出键盘，
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.inputTF becomeFirstResponder];
    });
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRealWidth(4));
        make.left.mas_equalTo(kRealWidth(12));
        make.right.mas_equalTo(-kRealWidth(12));
    }];

    [self.inputTF mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLB.mas_bottom).offset(kRealWidth(12));
        make.left.mas_equalTo(kRealWidth(12));
        make.right.mas_equalTo(-kRealWidth(12));
        make.height.mas_equalTo(kRealWidth(44));
    }];

    [self.notUseBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputTF.mas_bottom).offset(kRealWidth(108));
        make.left.mas_equalTo(kRealWidth(12));
        make.height.mas_equalTo(kRealWidth(44));
    }];

    [self.submitBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.equalTo(self.notUseBTN);
        make.right.mas_equalTo(-kRealWidth(12));
        make.left.equalTo(self.notUseBTN.mas_right).offset(kRealWidth(8));
    }];
}

- (void)layoutyImmediately {
    [self layoutIfNeeded];
    self.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(self.submitBTN.frame) + kRealWidth(8));
}

- (void)changeAction:(UITextField *)te {
    self.submitBTN.enabled = !HDIsStringEmpty(te.text);
}

- (void)setPromoCode:(NSString *)promoCode {
    _promoCode = promoCode;
    self.inputTF.text = promoCode;
    self.submitBTN.enabled = !HDIsStringEmpty(self.inputTF.text);
}

- (HDLabel *)titleLB {
    if (!_titleLB) {
        HDLabel *label = HDLabel.new;
        label.text = WMLocalizedString(@"yGHLNHRF", @"yGHLNHRF");
        label.textColor = HDAppTheme.WMColor.B6;
        label.font = [HDAppTheme.WMFont wm_ForSize:14];
        _titleLB = label;
    }
    return _titleLB;
}

- (UITextField *)inputTF {
    if (!_inputTF) {
        _inputTF = UITextField.new;
        _inputTF.font = [HDAppTheme.WMFont wm_ForSize:16 weight:UIFontWeightMedium];
        _inputTF.keyboardType = UIKeyboardTypeDefault;
        _inputTF.returnKeyType = UIReturnKeyDone;
        _inputTF.leftViewMode = UITextFieldViewModeAlways;
        _inputTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kRealWidth(12), 10)];
        _inputTF.textColor = HDAppTheme.WMColor.B3;
        _inputTF.tintColor = HDAppTheme.WMColor.mainRed;
        _inputTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _inputTF.layer.backgroundColor = HDAppTheme.WMColor.F6F6F6.CGColor;
        [_inputTF addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventEditingChanged];
        _inputTF.attributedPlaceholder =
            [[NSAttributedString alloc] initWithString:WMLocalizedString(@"P82qTdqX", @"P82qTdqX")
                                            attributes:@{NSFontAttributeName: [HDAppTheme.WMFont wm_ForSize:14], NSForegroundColorAttributeName: HDAppTheme.WMColor.CCCCCC}];
    }
    return _inputTF;
}

- (HDUIButton *)notUseBTN {
    if (!_notUseBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.layer.backgroundColor = UIColor.whiteColor.CGColor;
        button.layer.cornerRadius = kRealWidth(22);
        button.layer.borderColor = HDAppTheme.WMColor.mainRed.CGColor;
        button.layer.borderWidth = 1;
        [button setTitleColor:HDAppTheme.WMColor.mainRed forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        button.titleLabel.font = [HDAppTheme.WMFont wm_boldForSize:16];
        [button setTitle:WMLocalizedString(@"not_use", @"Cancel") forState:UIControlStateNormal];
        [button sizeToFit];
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.clickedConfirmBlock) {
                self.clickedConfirmBlock(nil);
            }
        }];
        _notUseBTN = button;
    }
    return _notUseBTN;
}

- (HDUIButton *)submitBTN {
    if (!_submitBTN) {
        SAOperationButton *btn = [SAOperationButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [btn setTitle:WMLocalizedStringFromTable(@"submit", @"提交", @"Buttons") forState:UIControlStateNormal];
        btn.titleLabel.font = [HDAppTheme.WMFont wm_boldForSize:16];
        btn.adjustsButtonWhenHighlighted = false;
        btn.layer.backgroundColor = HDAppTheme.WMColor.mainRed.CGColor;
        btn.layer.cornerRadius = kRealWidth(22);
        [btn applyPropertiesWithBackgroundColor:HDAppTheme.WMColor.mainRed];
        btn.enabled = NO;
        @HDWeakify(self)[btn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self) if (self.clickedConfirmBlock) {
                self.clickedConfirmBlock(self.inputTF.text);
            }
        }];
        _submitBTN = btn;
    }
    return _submitBTN;
}

@end
