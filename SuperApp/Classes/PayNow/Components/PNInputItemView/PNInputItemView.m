//
//  PNInputItemView.m
//  SuperApp
//
//  Created by xixi_wen on 2021/12/27.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNInputItemView.h"


@interface PNInputItemView () <UITextFieldDelegate>
@property (nonatomic, strong) SALabel *titleLabel;
@property (nonatomic, strong) SALabel *leftLabel;
@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, strong) UIView *bottomLine;
@end


@implementation PNInputItemView

- (void)hd_setupViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.inputTextField];
    [self addSubview:self.leftLabel];
    [self addSubview:self.bottomLine];
}

- (void)updateConstraints {
    if (self.model.style == PNInputStypeRow_One) {
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(self.model.contentEdgeInsets.left);
            make.right.mas_equalTo(self.inputTextField.mas_left).offset(kRealWidth(-15));
            make.top.mas_equalTo(self.mas_top).offset(self.model.contentEdgeInsets.top);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-self.model.contentEdgeInsets.bottom);
        }];

        [self.inputTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-self.model.contentEdgeInsets.right);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];

        [self.titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    } else {
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(self.model.contentEdgeInsets.left);
            make.right.mas_equalTo(self.mas_right).offset(-self.model.contentEdgeInsets.right);
            make.top.mas_equalTo(self.mas_top).offset(self.model.contentEdgeInsets.top);
        }];

        [self.leftLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(self.model.contentEdgeInsets.left);
            make.centerY.mas_equalTo(self.inputTextField.mas_centerY);
        }];

        [self.inputTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (self.leftLabel.hidden) {
                make.left.mas_equalTo(self.mas_left).offset(self.model.contentEdgeInsets.left);
            } else {
                make.left.mas_equalTo(self.leftLabel.mas_right).offset(kRealWidth(12));
            }
            make.right.mas_equalTo(self.mas_right).offset(-self.model.contentEdgeInsets.right);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-self.model.contentEdgeInsets.bottom);
        }];

        [self.leftLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.inputTextField setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    }

    [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.model.bottomLineHeight));
        make.bottom.mas_equalTo(self.mas_bottom).offset(-self.model.bottomLineHeight);
        make.left.mas_equalTo(self.mas_left).offset(self.model.bottomLineSpaceToLeft);
        make.right.mas_equalTo(self.mas_right).offset(-self.model.bottomLineSpaceToRight);
    }];

    [super updateConstraints];
}

#pragma mark
- (NSString *)inputText {
    return self.inputTextField.text;
}

- (void)update {
    self.model = self.model;
}
#pragma mark
- (void)setModel:(PNInputItemModel *)model {
    _model = model;

    /// backgroundColor
    self.backgroundColor = self.model.backgroundColor;

    self.inputTextField.enabled = self.model.enabled;

    if (!WJIsObjectNil(self.model.titleColor)) {
        self.titleLabel.textColor = self.model.titleColor;
    } else {
        self.titleLabel.textColor = HDAppTheme.PayNowColor.c343B4D;
    }

    if (!WJIsObjectNil(self.model.titleFont)) {
        self.titleLabel.font = self.model.titleFont;
    } else {
        self.titleLabel.font = HDAppTheme.PayNowFont.standard15;
    }

    /// title
    if (WJIsObjectNil(self.model.attributedTitle)) {
        if (WJIsStringNotEmpty(self.model.title)) {
            self.titleLabel.text = self.model.title;
        }
    } else {
        self.titleLabel.attributedText = self.model.attributedTitle;
    }

    /// input textFiled
    if (WJIsStringNotEmpty(self.model.placeholder)) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
        if (!WJIsObjectNil(self.model.placeholderColor)) {
            [dict setObject:self.model.placeholderColor forKey:NSForegroundColorAttributeName];
        } else {
            [dict setObject:HDAppTheme.PayNowColor.cADB6C8 forKey:NSForegroundColorAttributeName];
        }

        if (!WJIsObjectNil(self.model.placeholderFont)) {
            [dict setObject:self.model.placeholderFont forKey:NSFontAttributeName];
        } else {
            [dict setObject:HDAppTheme.PayNowFont.standard15 forKey:NSFontAttributeName];
        }
        NSAttributedString *attPlaceholder = [[NSAttributedString alloc] initWithString:self.model.placeholder attributes:dict];
        self.inputTextField.attributedPlaceholder = attPlaceholder;
    }

    self.inputTextField.textAlignment = self.model.valueAlignment;
    if (!WJIsObjectNil(self.model.valueColor)) {
        self.inputTextField.textColor = self.model.valueColor;
    } else {
        self.inputTextField.textColor = HDAppTheme.PayNowColor.c343B4D;
    }

    if (!WJIsObjectNil(self.model.valueFont)) {
        self.inputTextField.font = self.model.valueFont;
    } else {
        self.inputTextField.font = HDAppTheme.PayNowFont.standard15M;
    }
    self.inputTextField.tintColor = HDAppTheme.PayNowColor.mainThemeColor;

    /// leftLabel
    if (WJIsStringNotEmpty(self.model.leftLabelString)) {
        self.leftLabel.hidden = NO;
        self.leftLabel.font = self.model.leftLabelFont;
        self.leftLabel.textColor = self.model.leftLabelColor;
        self.leftLabel.text = self.model.leftLabelString;
    } else {
        self.leftLabel.hidden = YES;
    }

    /// 线条
    if (!WJIsObjectNil(self.model.bottomLineColor)) {
        self.bottomLine.backgroundColor = self.model.bottomLineColor;
    } else {
        self.bottomLine.backgroundColor = HDAppTheme.PayNowColor.lineColor;
    }

    self.inputTextField.keyboardType = self.model.keyboardType;

    if (WJIsStringNotEmpty(self.model.value)) {
        NSString *tempValue = self.model.value;
        if (self.model.isUppercaseString) {
            tempValue = tempValue.uppercaseString;
        }

        if (self.model.coverUp > PNInputCoverUpNone) {
            self.inputTextField.text = [self deSensitive:tempValue type:self.model.coverUp];
        } else {
            self.inputTextField.text = tempValue;
        }
    } else {
        self.inputTextField.text = @"";
    }

    [self setNeedsUpdateConstraints];
}

#pragma mark textFiled delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    /// 强行左对齐
    if (self.model.fixWhenInputSpace) {
        self.textFiled.textAlignment = NSTextAlignmentLeft;
    }

    if (self.model.coverUp == PNInputCoverUpNone) {
        self.textFiled.text = self.model.value;
    } else {
        self.textFiled.text = @"";
        self.model.value = @"";
    }

    if (self.model.isWhenEidtClearValue) {
        textField.text = @"";
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(pn_textFieldShouldBeginEditing:view:)]) {
        return [self.delegate pn_textFieldShouldBeginEditing:textField view:self];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pn_textFieldDidBeginEditing:view:)]) {
        [self.delegate pn_textFieldDidBeginEditing:textField view:self];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pn_textFieldShouldEndEditing:view:)]) {
        return [self.delegate pn_textFieldShouldEndEditing:textField view:self];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pn_textFieldDidEndEditing:view:)]) {
        [self.delegate pn_textFieldDidEndEditing:textField view:self];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason {
    NSString *tempValue = textField.text;
    if (self.model.isUppercaseString) {
        tempValue = tempValue.uppercaseString;
        /// 如果是需要大写，则重新赋值
        self.textFiled.text = tempValue;
    }
    self.model.value = tempValue;

    if (self.model.fixWhenInputSpace) {
        /// 结束第一响应者恢复回去
        self.textFiled.textAlignment = self.model.valueAlignment;
    }

    //    if (self.model.coverUp > PNInputCoverUpNone) {
    //        /// 如果是需要遮掩，则重新赋值
    //        self.textFiled.text = [self deSensitive:tempValue type:self.model.coverUp];
    //    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(pn_textFieldDidEndEditing:reason:view:)]) {
        [self.delegate pn_textFieldDidEndEditing:textField reason:reason view:self];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.model.firstDigitCanNotEnterZero == YES) {
        if (range.location == 0 && [string isEqualToString:@"0"]) {
            return NO;
        }
    }

    if (!self.model.canInputMoreSpace) {
        NSError *error = nil;

        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\s{2,}" options:NSRegularExpressionCaseInsensitive error:&error];
        NSArray *arr = [regex matchesInString:self.textFiled.text options:NSMatchingReportCompletion range:NSMakeRange(0, [self.textFiled.text length])];
        arr = [[arr reverseObjectEnumerator] allObjects];

        for (NSTextCheckingResult *str in arr) {
            self.textFiled.text = [self.textFiled.text stringByReplacingCharactersInRange:[str range] withString:@" "];
        }
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(pn_textField:shouldChangeCharactersInRange:replacementString:view:)]) {
        return [self.delegate pn_textField:textField shouldChangeCharactersInRange:range replacementString:string view:self];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pn_textFieldShouldClear:view:)]) {
        return [self.delegate pn_textFieldShouldClear:textField view:self];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pn_textFieldShouldReturn:view:)]) {
        return [self.delegate pn_textFieldShouldReturn:textField view:self];
    }
    return YES;
}

#pragma mark
//监听textfield的字数长度的变化
- (void)limitLength:(UITextField *)sender {
    !self.valueChangedBlock ?: self.valueChangedBlock(self.inputTextField.text);

    if (self.model.maxInputLength <= 0)
        return;

    //判断当前输入法是否是中文
    bool isChinese;

    if ([[sender.textInputMode primaryLanguage] isEqualToString:@"en-US"]) {
        isChinese = false;
    } else {
        isChinese = true;
    }

    // self.model.maxInputLength
    NSString *str = [[self.inputTextField text] stringByReplacingOccurrencesOfString:@"?" withString:@""];
    if (isChinese) { //中文输入法下
        UITextRange *selectedRange = [self.inputTextField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [self.inputTextField positionFromPosition:selectedRange.start offset:0];

        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (str.length > self.model.maxInputLength) { //长度大于8时进行截取
                NSString *strNew = [NSString stringWithString:str];
                [self.inputTextField setText:[strNew substringToIndex:self.model.maxInputLength]];
            }
        } else {
            //                NSLog(@"输入的英文还没有转化为汉字的状态");
        }
    } else { //非中文输入法下
        if ([str length] > self.model.maxInputLength) {
            NSString *strNew = [NSString stringWithString:str];
            [self.inputTextField setText:[strNew substringToIndex:self.model.maxInputLength]];
        }
    }
}

/// 遮掩脱敏
- (NSString *)deSensitive:(NSString *)value type:(PNInputCoverUpType)type {
    NSString *tempName = [value hd_trim];
    NSString *result = @"";

    if (type == PNInputCoverUpName) {
        if (tempName.length > 0) {
            result = [[tempName substringToIndex:1] stringByAppendingString:@"***"];
        }
    }

    if (type == PNInputCoverUpNumber) {
        if (tempName.length > 2) {
            result = [tempName stringByReplacingCharactersInRange:NSMakeRange(1, tempName.length - 2) withString:@"***"];
        }
    }

    return result;
}

#pragma mark
- (SALabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[SALabel alloc] init];
    }
    return _titleLabel;
}

- (SALabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[SALabel alloc] init];
        _leftLabel.hidden = YES;
    }
    return _leftLabel;
}

- (UITextField *)inputTextField {
    if (!_inputTextField) {
        _inputTextField = [[UITextField alloc] init];
        _inputTextField.delegate = self;
        [_inputTextField addTarget:self action:@selector(limitLength:) forControlEvents:UIControlEventEditingChanged];
        _inputTextField.tintColor = HDAppTheme.PayNowColor.mainThemeColor;

        //        @HDWeakify(self);
        //        _inputTextField.limitBlock = ^{
        //            @HDStrongify(self);
        //            if (self.model.maxInputLength > 0) {
        //                if (self.inputTextField.text.length > self.model.maxInputLength) {
        //                    self.inputTextField.text = [self.inputTextField.text substringToIndex:self.model.maxInputLength];
        //                }
        //            }
        //        };
    }
    return _inputTextField;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = HDAppTheme.PayNowColor.cECECEC;
    }
    return _bottomLine;
}

- (UITextField *)textFiled {
    return self.inputTextField;
}

@end
