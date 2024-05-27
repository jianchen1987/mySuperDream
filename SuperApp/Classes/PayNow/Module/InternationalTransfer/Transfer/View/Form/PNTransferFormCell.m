//
//  PNTransferFormCell.m
//  SuperApp
//
//  Created by 张杰 on 2022/6/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNTransferFormCell.h"
#import "NSString+extend.h"


@interface PNTransferFormCell () <HDUITextFieldDelegate>
/// 左边文字
@property (strong, nonatomic) UILabel *leftKeyLabel;
/// 右边提示按钮
@property (strong, nonatomic) HDUIButton *rightTipBtn;
/// 输入框
@property (strong, nonatomic) HDUITextField *textfeild;
/// 输入框左边占位文字
@property (strong, nonatomic) UILabel *leftTextfeildLabel;
/// 分割线
@property (strong, nonatomic) UIView *lineView;
/// PNSTransferFormValueEditTypeShow  纯展示的时候 用这个可以换行
@property (strong, nonatomic) HDTextView *textView;
@end


@implementation PNTransferFormCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.leftKeyLabel];
    [self.contentView addSubview:self.rightTipBtn];
    [self.contentView addSubview:self.textfeild];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.textView];

    @HDWeakify(self);
    self.textfeild.textFieldDidChangeBlock = ^(NSString *text) {
        @HDStrongify(self);
        self.config.valueText = text;
        !self.config.valueChangedCallBack ?: self.config.valueChangedCallBack(self.config);
    };
}

- (void)setConfig:(PNTransferFormConfig *)config {
    _config = config;
    HDUITextFieldConfig *textfeildConfig = config.textfeildConfig;

    if (config.editType == PNSTransferFormValueEditTypeShow) {
        self.textView.text = config.valueText;
        self.textView.font = textfeildConfig.font;
        self.textView.textColor = textfeildConfig.textColor;
        self.textView.hidden = NO;
        self.textfeild.hidden = YES;
    } else {
        [self.textfeild setConfig:textfeildConfig];
        if (HDIsObjectNil(textfeildConfig.rightIconImage)) { //解决复用问题
            [self.textfeild setRightImageViewImage:nil];
        }

        self.leftTextfeildLabel.text = config.leftLabelString;
        [self.leftTextfeildLabel sizeToFit];
        [self.textfeild setCustomLeftView:self.leftTextfeildLabel];

        [self.textfeild setTextFieldText:HDIsStringNotEmpty(config.valueText) ? config.valueText : @""];
        self.textView.hidden = YES;
        self.textfeild.hidden = NO;

        if (config.useWOWNOWKeyboard) {
            HDKeyBoardTheme *theme = HDKeyBoardTheme.new;
            theme.enterpriseText = @"";
            HDKeyBoard *kb = [HDKeyBoard keyboardWithType:config.wownowKeyBoardType theme:theme];

            kb.inputSource = self.textfeild.inputTextField;
            self.textfeild.inputTextField.inputView = kb;
        } else {
            self.textfeild.inputTextField.inputView = nil;
        }
    }

    if (HDIsStringNotEmpty(config.rightTipText) || HDIsStringNotEmpty(config.rightTipImageStr)) {
        self.rightTipBtn.hidden = NO;

        if (HDIsStringNotEmpty(config.rightTipText)) {
            [self.rightTipBtn setTitle:config.rightTipText forState:UIControlStateNormal];
        }

        if (HDIsStringNotEmpty(config.rightTipImageStr)) {
            [self.rightTipBtn setImage:[UIImage imageNamed:config.rightTipImageStr] forState:UIControlStateNormal];
        }
    } else {
        self.rightTipBtn.hidden = YES;
    }

    if (config.onlyShow) {
        //纯展示  不能编辑
        self.leftKeyLabel.textColor = HDAppTheme.PayNowColor.c999999;
        self.textfeild.inputTextField.textColor = HDAppTheme.PayNowColor.c999999;
        self.textfeild.userInteractionEnabled = NO;
    } else {
        self.leftKeyLabel.textColor = HDAppTheme.PayNowColor.c333333;
        self.textfeild.inputTextField.textColor = textfeildConfig.textColor;
        self.textfeild.userInteractionEnabled = YES;
    }

    self.leftKeyLabel.font = config.keyFont;

    NSString *keyStr = config.keyText;
    NSString *starName = @"*";
    if (config.showKeyStar) {
        keyStr = [NSString stringWithFormat:@"%@%@", starName, keyStr];
    }

    if (WJIsStringNotEmpty(config.subKeyText)) {
        keyStr = [NSString stringWithFormat:@"%@ %@", keyStr, config.subKeyText];
    }

    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:keyStr];
    if (config.showKeyStar) {
        NSRange range = [keyStr rangeOfString:starName];
        if (range.location != NSNotFound) {
            [attr addAttribute:NSForegroundColorAttributeName value:HDAppTheme.PayNowColor.mainThemeColor range:NSMakeRange(range.location, starName.length)];
            [attr addAttribute:NSFontAttributeName value:self.leftKeyLabel.font range:NSMakeRange(range.location, starName.length)];
        }
    }

    if (WJIsStringNotEmpty(config.subKeyText)) {
        NSString *subKeyText = config.subKeyText;
        NSRange range = [keyStr rangeOfString:subKeyText];
        if (range.location != NSNotFound) {
            [attr addAttribute:NSForegroundColorAttributeName value:config.subKeyColor range:NSMakeRange(range.location, subKeyText.length)];
            [attr addAttribute:NSFontAttributeName value:config.subKeyFont range:NSMakeRange(range.location, subKeyText.length)];
        }
    }

    self.leftKeyLabel.attributedText = attr;

    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    [self.leftKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(12));
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(15));
        if (self.rightTipBtn.isHidden) {
            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(12));
        } else {
            make.right.lessThanOrEqualTo(self.rightTipBtn.mas_left).offset(kRealWidth(10));
        }
    }];

    if (!self.rightTipBtn.isHidden) {
        [self.rightTipBtn sizeToFit];
        [self.rightTipBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.leftKeyLabel.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(12));
        }];
    }

    [self.textfeild mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(12));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(12));
        make.top.equalTo(self.leftKeyLabel.mas_bottom).offset(kRealWidth(10));
        make.height.mas_equalTo(HDIsObjectNil(self.config) ? kRealWidth(40) : self.config.valueContainerHeight);
    }];

    [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(12));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(12));
        make.top.equalTo(self.leftKeyLabel.mas_bottom).offset(kRealWidth(10));
        make.height.mas_equalTo(HDIsObjectNil(self.config) ? kRealWidth(40) : self.config.valueContainerHeight);
    }];

    UIView *topView = self.textfeild.isHidden ? self.textView : self.textfeild;

    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(12));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(12));
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.top.equalTo(topView.mas_bottom).offset(kRealWidth(15));
        make.height.mas_equalTo(HDIsObjectNil(self.config) ? 0 : self.config.lineHeight);
    }];

    [super updateConstraints];
}

#pragma mark -HDUITextFieldDelegate
- (BOOL)hd_textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.config.editType == PNSTransferFormValueEditTypeDrop | self.config.editType == PNSTransferFormValueEditTypeJump) {
        !self.config.valueContainerClickCallBack ?: self.config.valueContainerClickCallBack(self.config);
        return NO;
    } else if (self.config.editType == PNSTransferFormValueEditTypeShow) {
        return NO;
    }
    self.config.isEditing = YES;
    return YES;
}
- (void)hd_textFieldDidEndEditing:(UITextField *)textField {
    if (self.config.editType == PNSTransferFormValueEditTypeEnter) {
        !self.config.textFiledShouldEndEditCallBack ?: self.config.textFiledShouldEndEditCallBack(self.config);
    }
}
- (BOOL)hd_textFieldShouldEndEditing:(UITextField *)textField {
    self.config.isEditing = NO;
    return YES;
}
/** @lazy leftKeyLabel */
- (UILabel *)leftKeyLabel {
    if (!_leftKeyLabel) {
        _leftKeyLabel = [[UILabel alloc] init];
        _leftKeyLabel.font = [HDAppTheme.PayNowFont fontBold:14];
        _leftKeyLabel.numberOfLines = 0;
    }
    return _leftKeyLabel;
}

/** @lazy  rightTipBtn*/
- (HDUIButton *)rightTipBtn {
    if (!_rightTipBtn) {
        _rightTipBtn = [[HDUIButton alloc] init];
        _rightTipBtn.hidden = YES;
        _rightTipBtn.titleLabel.font = HDAppTheme.PayNowFont.standard12;
        [_rightTipBtn setTitleColor:HDAppTheme.PayNowColor.mainThemeColor forState:UIControlStateNormal];
        _rightTipBtn.spacingBetweenImageAndTitle = 5;
        _rightTipBtn.imagePosition = HDUIButtonImagePositionRight;
        @HDWeakify(self);
        [_rightTipBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.config.rightTipClickCallBack ?: self.config.rightTipClickCallBack(self.config);
        }];
    }
    return _rightTipBtn;
}

- (HDUITextField *)textfeild {
    if (!_textfeild) {
        HDUITextField *textField = [[HDUITextField alloc] init];
        textField.delegate = self;
        textField.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
        textField.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:4];
        };
        @HDWeakify(self);
        textField.clickRightImageViewBlock = ^{
            @HDStrongify(self);
            !self.config.valueContainerClickCallBack ?: self.config.valueContainerClickCallBack(self.config);
        };
        _textfeild = textField;
    }
    return _textfeild;
}

/** @lazy lineView */
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HDAppTheme.PayNowColor.lineColor;
    }
    return _lineView;
}

/** @lazy textView */
- (HDTextView *)textView {
    if (!_textView) {
        _textView = [[HDTextView alloc] init];
        _textView.hidden = YES;
        _textView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
        _textView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:4];
        };
        _textView.userInteractionEnabled = NO;
        _textView.textContainerInset = UIEdgeInsetsMake(12, 8, 10, 8);
    }
    return _textView;
}

/** @lazy leftTextfeildLabel */
- (UILabel *)leftTextfeildLabel {
    if (!_leftTextfeildLabel) {
        _leftTextfeildLabel = [[UILabel alloc] init];
        _leftTextfeildLabel.textColor = HDAppTheme.PayNowColor.c333333;
        _leftTextfeildLabel.font = HDAppTheme.PayNowFont.standard14;
    }
    return _leftTextfeildLabel;
}
@end
