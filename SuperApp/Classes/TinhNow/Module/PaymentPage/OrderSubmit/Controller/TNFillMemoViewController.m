//
//  TNFillMemoViewController.m
//  SuperApp
//
//  Created by seeu on 2020/8/24.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNFillMemoViewController.h"


@interface TNFillMemoViewController () <UITextViewDelegate>
/// 输入框
@property (nonatomic, strong) UITextView *textField;
/// 字数Label
@property (nonatomic, strong) UILabel *characterNumber;
/// 提交按钮
@property (nonatomic, strong) SAOperationButton *submitButton;
/// 背景图
@property (nonatomic, strong) UIView *backgroundView;
@end


@implementation TNFillMemoViewController

- (void)hd_setupViews {
    [self.view addSubview:self.backgroundView];
    [self.backgroundView addSubview:self.textField];
    [self.view addSubview:self.characterNumber];
    [self.view addSubview:self.submitButton];

    if (HDIsStringNotEmpty(self.memo)) {
        self.textField.text = self.memo;
        [self updateCharacterNumberWithNumber:self.memo.length];
    } else {
        self.textField.text = TNLocalizedString(@"tn_order_submit_memo_placehol", @"选填");
        [self updateCharacterNumberWithNumber:0];
    }
    //    [self fixButtonState];
    [self.submitButton setFollowKeyBoardConfigEnable:YES margin:20 refView:self.textField];
}

- (void)updateViewConstraints {
    [self.backgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(kRealWidth(15));
        make.top.equalTo(self.hd_navigationBar.mas_bottom).offset(kRealWidth(20));
        make.right.equalTo(self.view.mas_right).offset(-kRealWidth(15));
    }];

    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backgroundView.mas_left).offset(kRealWidth(15));
        make.top.equalTo(self.backgroundView.mas_top).offset(kRealWidth(15));
        make.right.equalTo(self.backgroundView.mas_right).offset(-kRealWidth(15));
        make.height.mas_equalTo(self.textField.mas_width).multipliedBy(123 / 345.0);
        make.bottom.equalTo(self.backgroundView.mas_bottom).offset(-kRealWidth(15));
    }];

    [self.characterNumber mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backgroundView.mas_right);
        make.top.equalTo(self.backgroundView.mas_bottom).offset(kRealWidth(15));
    }];

    [self.submitButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-kiPhoneXSeriesSafeBottomHeight);
        make.height.mas_equalTo(50);
    }];

    [super updateViewConstraints];
}

- (void)hd_setupNavigation {
    self.boldTitle = TNLocalizedString(@"tn_order_submit_memo_title", @"Note");
}

#pragma mark - private methods
- (void)clickOnSubmit:(SAOperationButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(memoDidChanged:)]) {
        [self.delegate memoDidChanged:self.textField.text];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateCharacterNumberWithNumber:(NSUInteger)number {
    self.characterNumber.text = [NSString stringWithFormat:@"%zd/300", number];
}
//不需要校验
//- (void)fixButtonState {
//    if (![self.textField.text isEqualToString:TNLocalizedString(@"tn_order_submit_memo_placehol", @"选填")] && self.textField.text.length > 0) {
//        [self.submitButton setEnabled:YES];
//    } else {
//        [self.submitButton setEnabled:NO];
//    }
//}

#pragma mark - UITextFieldDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *str = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (str.length > 300) {
        return NO;
    }

    [self updateCharacterNumberWithNumber:str.length];
    //    [self performSelector:@selector(fixButtonState) withObject:nil afterDelay:0.3];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:TNLocalizedString(@"tn_order_submit_memo_placehol", @"选填")]) {
        textView.text = @"";
        [self updateCharacterNumberWithNumber:0];
    }
}

#pragma mark - lazy load
/** @lazy backgroundView */
- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = HDAppTheme.TinhNowColor.G5;
        _backgroundView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.cornerRadius = 10.0f;
            view.layer.masksToBounds = YES;
        };
    }
    return _backgroundView;
}
/** @lazy textfield */
- (UITextView *)textField {
    if (!_textField) {
        _textField = [[UITextView alloc] init];
        _textField.delegate = self;
        _textField.backgroundColor = HDAppTheme.TinhNowColor.G5;
        _textField.font = HDAppTheme.TinhNowFont.standard15;
        _textField.textColor = HDAppTheme.TinhNowColor.G2;
    }
    return _textField;
}
/** @lazy characterNumber */
- (UILabel *)characterNumber {
    if (!_characterNumber) {
        _characterNumber = [[UILabel alloc] init];
        _characterNumber.font = HDAppTheme.TinhNowFont.standard12;
        _characterNumber.textColor = HDAppTheme.TinhNowColor.G3;
    }
    return _characterNumber;
}
/** @lazy submitButton */
- (SAOperationButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_submitButton applyPropertiesWithBackgroundColor:HDAppTheme.TinhNowColor.C1];
        _submitButton.titleLabel.font = HDAppTheme.TinhNowFont.standard17B;
        [_submitButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_submitButton setTitle:TNLocalizedString(@"tn_button_submit", @"Submit") forState:UIControlStateNormal];
        [_submitButton addTarget:self action:@selector(clickOnSubmit:) forControlEvents:UIControlEventTouchUpInside];
        _submitButton.cornerRadius = 0;
    }
    return _submitButton;
}

@end
