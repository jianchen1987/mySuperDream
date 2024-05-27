//
//  PNBillAmountView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/3/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNBillAmountView.h"


@interface PNBillAmountView ()
@property (nonatomic, strong) UIView *lastView;
@property (nonatomic, strong) SALabel *leftLabel;

//只读的时候显示
@property (nonatomic, strong) SALabel *amountLabel;
// 输入的时候显示
@property (nonatomic, strong) UIView *amountBgView;
@property (nonatomic, strong) HDUITextField *amountTextField;

@property (nonatomic, strong) SALabel *feeLabel;
@property (nonatomic, strong) SALabel *marketingLabel;
@property (nonatomic, strong) SALabel *feeTypeLabel;
@property (nonatomic, strong) UIView *lineView;
@end


@implementation PNBillAmountView

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
    [self addSubview:self.leftLabel];
    [self addSubview:self.amountLabel];
    [self addSubview:self.amountBgView];
    [self.amountBgView addSubview:self.amountTextField];
    [self addSubview:self.feeLabel];
    [self addSubview:self.marketingLabel];
    [self addSubview:self.feeTypeLabel];
    [self addSubview:self.lineView];
}

- (void)updateConstraints {
    [self.leftLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(15));
        make.top.mas_equalTo(self.mas_top).offset(kRealWidth(15));
        make.right.mas_equalTo(self.canEdit ? self.amountBgView.mas_left : self.amountLabel.mas_left).offset(kRealWidth(-15));
    }];

    if (self.canEdit) {
        [self.amountBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-15));
            make.height.mas_equalTo(@(kRealWidth(32)));
            make.width.mas_equalTo(@(kRealWidth(160)));
            make.top.mas_equalTo(self.mas_top).offset(kRealWidth(9));
        }];

        [self.amountTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.amountBgView.mas_left).offset(kRealWidth(5));
            make.right.mas_equalTo(self.amountBgView.mas_right).offset(kRealWidth(-10));
            make.height.mas_equalTo(@(kRealWidth(28)));
            make.centerY.mas_equalTo(self.amountBgView.mas_centerY).offset(kRealWidth(-6));
        }];
        self.lastView = self.amountBgView;
    } else {
        [self.amountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-15));
            make.centerY.mas_equalTo(self.leftLabel.mas_centerY);
            make.left.mas_equalTo(self.leftLabel.mas_right).offset(kRealWidth(15));
        }];
        self.lastView = self.amountLabel;
    }

    if (!self.feeLabel.hidden) {
        [self.feeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.lastView.mas_bottom).offset(kRealWidth(5));
            make.left.mas_equalTo(self.mas_left).offset(kRealWidth(15));
            make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-15));
        }];
        self.lastView = self.feeLabel;
    }

    if (!self.marketingLabel.hidden) {
        [self.marketingLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.lastView.mas_bottom).offset(kRealWidth(5));
            make.left.mas_equalTo(self.mas_left).offset(kRealWidth(15));
            make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-15));
        }];
        self.lastView = self.marketingLabel;
    }

    if (!self.feeTypeLabel.hidden) {
        [self.feeTypeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.lastView.mas_bottom).offset(kRealWidth(5));
            make.left.mas_equalTo(self.mas_left).offset(kRealWidth(15));
            make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-15));
        }];
        self.lastView = self.feeTypeLabel;
    }

    [self.lastView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).offset(kRealWidth(-15));
    }];

    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-15));
        make.height.equalTo(@(PixelOne));
        make.bottom.mas_equalTo(self.mas_bottom).offset(kRealWidth(-1));
    }];

    [super updateConstraints];
}

#pragma mark
- (void)setCanEdit:(BOOL)canEdit {
    _canEdit = canEdit;
    if (_canEdit) {
        self.amountBgView.hidden = NO;
        self.amountLabel.hidden = YES;
    } else {
        self.amountBgView.hidden = YES;
        self.amountLabel.hidden = NO;
    }
    [self setNeedsUpdateConstraints];
}

- (void)setBalancesInfoModel:(PNBalancesInfoModel *)balancesInfoModel {
    _balancesInfoModel = balancesInfoModel;

    [self.amountTextField setTextFieldText:self.balancesInfoModel.billAmount.amount];
    self.amountLabel.text = self.balancesInfoModel.billAmount.thousandSeparatorAmount;

    if (self.balancesInfoModel.feeAmount.amount.doubleValue <= 0) {
        self.feeLabel.hidden = YES;
    } else {
        self.feeLabel.hidden = NO;
        self.feeLabel.text = [NSString stringWithFormat:@"%@: %@", PNLocalizedString(@"fee", @"fee"), self.balancesInfoModel.feeAmount.thousandSeparatorAmount];
    }

    if (WJIsStringNotEmpty(self.balancesInfoModel.feeType)) {
        self.feeTypeLabel.hidden = NO;
        self.feeTypeLabel.text = [NSString stringWithFormat:@"%@: %@", PNLocalizedString(@"fee_type", @"fee_type"), self.balancesInfoModel.feeType];
    } else {
        self.feeTypeLabel.hidden = YES;
    }

    if (self.balancesInfoModel.marketingBreaks.amount <= 0) {
        self.marketingLabel.hidden = YES;
    } else {
        self.marketingLabel.hidden = NO;
        self.marketingLabel.text = [NSString stringWithFormat:@"%@: %@", PNLocalizedString(@"promotion", @"promotion"), self.balancesInfoModel.marketingBreaks.thousandSeparatorAmount];
    }
    [self setNeedsUpdateConstraints];
}

#pragma mark
- (SALabel *)leftLabel {
    if (!_leftLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.cC4C5C8;
        label.font = HDAppTheme.PayNowFont.standard15;
        label.text = PNLocalizedString(@"bill_amount", @"Bill Amount");
        _leftLabel = label;
    }
    return _leftLabel;
}

- (UIView *)amountBgView {
    if (!_amountBgView) {
        UIView *view = [[UIView alloc] init];
        view.hidden = YES;
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        view.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(5) borderWidth:kRealWidth(1) borderColor:HDAppTheme.PayNowColor.cC4C5C8];
        };
        _amountBgView = view;
    }
    return _amountBgView;
}

- (HDUITextField *)amountTextField {
    if (!_amountTextField) {
        _amountTextField = [[HDUITextField alloc] initWithPlaceholder:@"" leftLabelString:@""];
        HDUITextFieldConfig *config = [_amountTextField getCurrentConfig];

        config.placeholderFont = HDAppTheme.PayNowFont.standard15;
        config.placeholderColor = HDAppTheme.PayNowColor.c9599A2;
        config.leftLabelString = @"$";
        config.leftLabelFont = HDAppTheme.PayNowFont.standard15M;
        config.leftLabelColor = HDAppTheme.PayNowColor.c343B4D;
        config.font = HDAppTheme.PayNowFont.standard15M;
        config.textColor = HDAppTheme.PayNowColor.c343B4D;
        config.leftViewEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(10), 0, kRealWidth(10));
        config.floatingText = @" ";

        config.maxDecimalsCount = 2;
        config.keyboardType = UIKeyboardTypeDecimalPad;

        config.characterSetString = kCharacterSetStringAmount;
        config.bottomLineNormalHeight = 0;
        config.bottomLineSelectedHeight = 0;
        config.textAlignment = NSTextAlignmentRight;

        [_amountTextField setConfig:config];
        //        __weak __typeof(self) weakSelf = self;
        _amountTextField.textFieldDidChangeBlock = ^(NSString *text) {
            //            __strong __typeof(weakSelf) strongSelf = weakSelf;
            //            [strongSelf ruleButton];
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

- (SALabel *)feeLabel {
    if (!_feeLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c9599A2;
        label.font = HDAppTheme.PayNowFont.standard12;
        label.textAlignment = NSTextAlignmentRight;
        _feeLabel = label;
    }
    return _feeLabel;
}

- (SALabel *)marketingLabel {
    if (!_marketingLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c9599A2;
        label.font = HDAppTheme.PayNowFont.standard12;
        label.textAlignment = NSTextAlignmentRight;
        _marketingLabel = label;
    }
    return _marketingLabel;
}

- (SALabel *)feeTypeLabel {
    if (!_feeTypeLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c9599A2;
        label.font = HDAppTheme.PayNowFont.standard12;
        label.textAlignment = NSTextAlignmentRight;
        _feeTypeLabel = label;
    }
    return _feeTypeLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.lineColor;
        _lineView = view;
    }
    return _lineView;
}

- (SALabel *)amountLabel {
    if (!_amountLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c343B4D;
        label.font = HDAppTheme.PayNowFont.standard15M;
        label.hidden = YES;
        _amountLabel = label;
    }
    return _amountLabel;
}
@end
