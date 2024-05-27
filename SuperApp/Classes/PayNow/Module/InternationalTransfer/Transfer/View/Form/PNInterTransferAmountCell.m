//
//  PNInterTransferAmountCell.m
//  SuperApp
//
//  Created by 张杰 on 2022/6/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInterTransferAmountCell.h"


@interface PNInterTransferAmountCell () <HDUITextFieldDelegate>
///
@property (strong, nonatomic) UILabel *leftKeyLabel;
///
@property (strong, nonatomic) UILabel *desLabel;
@property (nonatomic, strong) HDUIButton *rightBtn;
///
@property (strong, nonatomic) HDUITextField *textfeild;
/// 分割线
@property (strong, nonatomic) UIView *lineView;

@end


@implementation PNInterTransferAmountCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.leftKeyLabel];
    [self.contentView addSubview:self.desLabel];
    [self.contentView addSubview:self.rightBtn];
    [self.contentView addSubview:self.textfeild];
    [self.contentView addSubview:self.lineView];

    @HDWeakify(self);
    self.textfeild.textFieldDidChangeBlock = ^(NSString *text) {
        @HDStrongify(self);
        if (self.model.canEdit) {
            self.model.valueText = text;
            !self.model.valueChangedCallBack ?: self.model.valueChangedCallBack(text);
        }
    };
}

- (void)setModel:(PNInterTransferAmountCellModel *)model {
    _model = model;
    self.leftKeyLabel.text = model.keyText;
    self.desLabel.text = model.descriptionText;

    HDUITextFieldConfig *config = [self.textfeild getCurrentConfig];

    config.rightIconImage = model.textFieldRightIconImage;
    if (model.canEdit) {
        config.maxInputLength = 10;
        self.textfeild.layer.borderColor = HDAppTheme.PayNowColor.mainThemeColor.CGColor;
        config.textColor = HDAppTheme.PayNowColor.c2A251F;
        self.textfeild.inputTextField.enabled = YES;
    } else {
        self.textfeild.layer.borderColor = UIColor.clearColor.CGColor;
        config.textColor = HDAppTheme.PayNowColor.mainThemeColor;
        self.textfeild.inputTextField.enabled = NO;
        config.maxInputLength = 30;
    }

    if (!HDIsObjectNil(model.valueColor)) {
        config.textColor = model.valueColor;
    }

    [self.textfeild setConfig:config];

    [self.textfeild setTextFieldText:model.valueText];

    if (HDIsStringEmpty(model.rightBtnTitle) && HDIsObjectNil(model.rightBtnImage)) {
        self.rightBtn.hidden = YES;
    } else {
        self.rightBtn.hidden = NO;

        if (HDIsStringNotEmpty(model.rightBtnTitle)) {
            [self.rightBtn setTitle:model.rightBtnTitle forState:UIControlStateNormal];
        }
        if (!HDIsObjectNil(model.rightBtnImage)) {
            [self.rightBtn setImage:model.rightBtnImage forState:UIControlStateNormal];
        }
        if (!HDIsObjectNil(model.rightBtnTitleColor)) {
            [self.rightBtn setTitleColor:model.rightBtnTitleColor forState:UIControlStateNormal];
        }
        if (!HDIsObjectNil(model.rightBtnTitleFont)) {
            self.rightBtn.titleLabel.font = model.rightBtnTitleFont;
        }
    }

    [self setNeedsUpdateConstraints];
}

- (void)becomeFirstResponder {
    [self.textfeild becomeFirstResponder];
}

#pragma mark -HDUITextFieldDelegate
- (BOOL)hd_textFieldShouldBeginEditing:(UITextField *)textField {
    return self.model.canEdit;
}

- (void)hd_textFieldDidEndEditing:(UITextField *)textField {
    HDLog(@"停止输入了，键盘收起来");
    !self.model.endEditingBlock ?: self.model.endEditingBlock();
}

#pragma mark
- (void)updateConstraints {
    [self.leftKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(12));
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(15));
        if (self.rightBtn.hidden) {
            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(12));
        } else {
            make.right.equalTo(self.rightBtn.mas_left).offset(-kRealWidth(12));
        }
    }];

    CGFloat topSpace = kRealWidth(5);
    if (HDIsStringEmpty(self.model.descriptionText)) {
        topSpace = 0;
    }

    [self.desLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(12));
        make.top.equalTo(self.leftKeyLabel.mas_bottom).offset(topSpace);
        if (self.rightBtn.hidden) {
            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(12));
        } else {
            make.right.equalTo(self.rightBtn.mas_left).offset(-kRealWidth(12));
        }
    }];

    if (!self.rightBtn.hidden) {
        [self.rightBtn sizeToFit];
        [self.rightBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-kRealWidth(12));
            make.size.mas_equalTo(self.rightBtn.size);
            if (HDIsStringEmpty(self.desLabel.text)) {
                make.centerY.mas_equalTo(self.leftKeyLabel.mas_centerY);
            } else {
                make.top.mas_equalTo(self.leftKeyLabel.mas_top);
            }
        }];
    }

    [self.textfeild mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(12));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(12));
        make.top.equalTo(self.desLabel.mas_bottom).offset(kRealWidth(15));
        make.height.mas_equalTo(kRealWidth(60));
    }];

    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(12));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(12));
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.top.equalTo(self.textfeild.mas_bottom).offset(kRealWidth(15));
        make.height.mas_equalTo(0.5);
    }];

    [super updateConstraints];
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

/** @lazy desLabel */
- (UILabel *)desLabel {
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.font = HDAppTheme.PayNowFont.standard11;
        _desLabel.textColor = HDAppTheme.PayNowColor.mainThemeColor;
        _desLabel.numberOfLines = 0;
    }
    return _desLabel;
}

- (HDUIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setTitleColor:HDAppTheme.PayNowColor.mainThemeColor forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = [HDAppTheme.PayNowFont fontBold:14];
        _rightBtn.imagePosition = HDUIButtonImagePositionTop;
        _rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _rightBtn.hidden = YES;
        @HDWeakify(self);
        [_rightBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.model.rightBtnClickBlock ?: self.model.rightBtnClickBlock(self.model.tag ?: @"");
        }];
    }
    return _rightBtn;
}

- (HDUITextField *)textfeild {
    if (!_textfeild) {
        HDUITextField *textField = [[HDUITextField alloc] init];
        textField.delegate = self;
        textField.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
        textField.layer.masksToBounds = YES;
        textField.layer.cornerRadius = 4;
        textField.layer.borderWidth = 1;

        HDUITextFieldConfig *config = [HDUITextFieldConfig defaultConfig];
        config.font = [HDAppTheme.PayNowFont fontRegular:25];
        config.rightViewEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
        config.maxInputLength = 100;
        config.maxDecimalsCount = 2;
        config.marginFloatingLabelToTextField = 0;
        config.floatingText = @"";
        config.floatingLabelFont = [UIFont systemFontOfSize:0];
        config.clearButtonMode = UITextFieldViewModeNever;
        config.placeholderColor = HDAppTheme.PayNowColor.cCCCCCC;
        config.placeholderFont = HDAppTheme.PayNowFont.standard14;
        config.bottomLineNormalHeight = 0;
        config.bottomLineSelectedHeight = 0;
        config.keyboardType = UIKeyboardTypeDecimalPad;
        config.maxDecimalsCount = 2;
        config.characterSetString = kCharacterSetStringAmount;
        config.shouldAppendDecimalAfterEndEditing = YES;
        [textField setConfig:config];

        [textField setCustomLeftView:UIView.new];

        HDKeyBoardTheme *theme = HDKeyBoardTheme.new;
        theme.enterpriseText = @"";
        HDKeyBoard *kb = [HDKeyBoard keyboardWithType:HDKeyBoardTypeDecimalPad theme:theme];

        kb.inputSource = textField.inputTextField;
        textField.inputTextField.inputView = kb;
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
@end


@implementation PNInterTransferAmountCellModel

@end
