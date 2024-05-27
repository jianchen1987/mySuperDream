//
//  PNBillModifyAmountItemView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/3/25.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNBillModifyAmountItemView.h"


@interface PNBillModifyAmountItemView ()

@property (nonatomic, strong) SALabel *titleLabel;
@property (nonatomic, strong) SALabel *valueLabel;
@property (nonatomic, strong) UIButton *modifyButton;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) SALabel *feeKeyLabel;
@property (nonatomic, strong) SALabel *feeValueLabel;

@property (nonatomic, strong) SALabel *marketingBreaksKeyLabel;
@property (nonatomic, strong) SALabel *marketingBreaksValueLabel;

@property (nonatomic, strong) SALabel *chargeTypeKeyLabel;
@property (nonatomic, strong) SALabel *chargeTypeValueLabel;

@property (nonatomic, strong) SALabel *totalAmountKeyLabel;
@property (nonatomic, strong) SALabel *totalAmountValueLabel;

@property (nonatomic, strong) SALabel *otherTotalAmountKeyLabel;
@property (nonatomic, strong) SALabel *otherTotalAmountValueLabel;
@end


@implementation PNBillModifyAmountItemView

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
    [self addSubview:self.titleLabel];
    [self addSubview:self.valueLabel];
    [self addSubview:self.modifyButton];

    [self addSubview:self.feeKeyLabel];
    [self addSubview:self.feeValueLabel];

    [self addSubview:self.marketingBreaksKeyLabel];
    [self addSubview:self.marketingBreaksValueLabel];

    //    [self addSubview:self.chargeTypeKeyLabel];
    //    [self addSubview:self.chargeTypeValueLabel];

    [self addSubview:self.lineView];

    [self addSubview:self.totalAmountKeyLabel];
    [self addSubview:self.totalAmountValueLabel];

    [self addSubview:self.otherTotalAmountKeyLabel];
    [self addSubview:self.otherTotalAmountValueLabel];

    [self.feeValueLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.marketingBreaksValueLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    //    [self.chargeTypeKeyLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)updateConstraints {
    //    [self.titleLabel sizeToFit];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.valueLabel.mas_left).offset(kRealWidth(-15));
        make.top.mas_equalTo(self.mas_top).offset(kRealWidth(15));
    }];

    [self.valueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.modifyButton.hidden) {
            make.right.mas_equalTo(self.modifyButton.mas_left).offset(kRealWidth(-10));
        } else {
            make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-15));
        }
        make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
    }];

    if (!self.modifyButton.hidden) {
        [self.modifyButton sizeToFit];
        [self.modifyButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-15));
            make.width.equalTo(@(self.modifyButton.width + kRealWidth(20)));
            make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
            make.top.mas_equalTo(self.mas_top).mas_equalTo(kRealWidth(13));
        }];
    }

    [self.feeKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(10));
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(15));
    }];

    [self.feeValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.feeKeyLabel.mas_right).offset(kRealWidth(15));
        make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-15));
        make.top.bottom.equalTo(self.feeKeyLabel);
    }];

    UIView *lastView = self.feeValueLabel;

    if (!self.marketingBreaksKeyLabel.hidden) {
        lastView = self.marketingBreaksKeyLabel;
        [self.marketingBreaksKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.feeKeyLabel.mas_bottom).offset(kRealWidth(10));
            make.left.mas_equalTo(self.mas_left).offset(kRealWidth(15));
        }];

        [self.marketingBreaksValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.marketingBreaksKeyLabel.mas_right).offset(kRealWidth(15));
            make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-15));
            make.top.bottom.equalTo(self.marketingBreaksKeyLabel);
        }];
    }

    //    [self.chargeTypeKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.top.mas_equalTo(lastView.mas_bottom).offset(kRealWidth(10));
    //        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(15));
    //    }];
    //
    //    [self.chargeTypeValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.left.mas_equalTo(self.chargeTypeKeyLabel.mas_right).offset(kRealWidth(15));
    //        make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-15));
    //        make.top.equalTo(self.chargeTypeKeyLabel);
    //    }];

    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-15));
        //        make.bottom.mas_equalTo(self.mas_bottom);
        make.top.mas_equalTo(lastView.mas_bottom).offset(kRealWidth(15));
        make.height.equalTo(@(PixelOne));
    }];

    [self.totalAmountKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(kRealWidth(10));
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(15));
    }];

    [self.totalAmountValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.totalAmountKeyLabel.mas_right).offset(kRealWidth(15));
        make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-15));
        make.top.equalTo(self.totalAmountKeyLabel);
        if (!self.otherTotalAmountKeyLabel.hidden) {
            make.bottom.equalTo(self.totalAmountKeyLabel);
        } else {
            make.bottom.mas_equalTo(self.mas_bottom).offset(kRealWidth(-15));
        }
    }];

    if (!self.otherTotalAmountKeyLabel.hidden) {
        [self.otherTotalAmountKeyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.totalAmountKeyLabel.mas_bottom).offset(kRealWidth(10));
            make.left.mas_equalTo(self.mas_left).offset(kRealWidth(15));
            make.bottom.mas_equalTo(self.mas_bottom).offset(kRealWidth(-15));
        }];

        [self.otherTotalAmountValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.otherTotalAmountKeyLabel.mas_right).offset(kRealWidth(15));
            make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-15));
            make.top.bottom.equalTo(self.otherTotalAmountKeyLabel);
        }];
    }

    [super updateConstraints];
}

#pragma mark
- (void)setBalancesInfoModel:(PNBalancesInfoModel *)balancesInfoModel {
    _balancesInfoModel = balancesInfoModel;
    self.valueLabel.text = self.balancesInfoModel.billAmount.thousandSeparatorAmount;

    if (self.balancesInfoModel.marketingBreaks.amount.doubleValue > 0) {
        self.marketingBreaksKeyLabel.hidden = NO;
        self.marketingBreaksValueLabel.hidden = NO;
        self.marketingBreaksValueLabel.text = [NSString stringWithFormat:@"-%@", self.balancesInfoModel.marketingBreaks.thousandSeparatorAmount];
    } else {
        self.marketingBreaksKeyLabel.hidden = YES;
        self.marketingBreaksValueLabel.hidden = YES;
    }

    self.feeValueLabel.text = self.balancesInfoModel.feeAmount.thousandSeparatorAmount;
    //    self.chargeTypeValueLabel.text = self.balancesInfoModel.chargeType;

    self.totalAmountValueLabel.text = self.balancesInfoModel.totalAmount.thousandSeparatorAmount;

    if ([self.balancesInfoModel.currency isEqualToString:PNCurrencyTypeKHR]) {
        self.otherTotalAmountKeyLabel.hidden = NO;
        self.otherTotalAmountValueLabel.hidden = NO;
        self.otherTotalAmountValueLabel.text = self.balancesInfoModel.otherCurrencyAmounts.thousandSeparatorAmount;
    } else {
        self.otherTotalAmountKeyLabel.hidden = YES;
        self.otherTotalAmountValueLabel.hidden = YES;
    }

    [self setNeedsUpdateConstraints];
}

- (void)setIsShowModifyButton:(BOOL)isShowModifyButton {
    _isShowModifyButton = isShowModifyButton;

    self.modifyButton.hidden = !self.isShowModifyButton;

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (SALabel *)titleLabel {
    if (!_titleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c9599A2;
        label.font = HDAppTheme.PayNowFont.standard14;
        label.text = PNLocalizedString(@"bill_amount", @"Bill Amount");
        _titleLabel = label;
    }
    return _titleLabel;
}

- (SALabel *)valueLabel {
    if (!_valueLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c343B4D;
        label.font = HDAppTheme.PayNowFont.standard15;
        _valueLabel = label;
    }
    return _valueLabel;
}

- (UIButton *)modifyButton {
    if (!_modifyButton) {
        _modifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_modifyButton setTitle:PNLocalizedString(@"Modify", @"Modify") forState:0];
        _modifyButton.titleLabel.font = HDAppTheme.PayNowFont.standard12;
        [_modifyButton setTitleColor:HDAppTheme.PayNowColor.cFD7127 forState:0];
        _modifyButton.layer.borderColor = HDAppTheme.PayNowColor.cFD7127.CGColor;
        _modifyButton.layer.borderWidth = PixelOne;
        _modifyButton.layer.cornerRadius = kRealWidth(5);
        //        [_modifyButton sizeToFit];
        //        _modifyButton.hd_frameDidChangeBlock = ^(__kindof UIView * _Nonnull view, CGRect precedingFrame) {
        //            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(5) borderWidth:PixelOne borderColor:HDAppTheme.PayNowColor.cFD7127];
        //        };

        @HDWeakify(self);
        [_modifyButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.modifyAccountBlock ?: self.modifyAccountBlock();
        }];
    }
    return _modifyButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.lineColor;
        _lineView = view;
    }
    return _lineView;
}

- (SALabel *)feeKeyLabel {
    if (!_feeKeyLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c9599A2;
        label.font = HDAppTheme.PayNowFont.standard14;
        label.text = PNLocalizedString(@"fee", @"fee");
        _feeKeyLabel = label;
    }
    return _feeKeyLabel;
}

- (SALabel *)feeValueLabel {
    if (!_feeValueLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c343B4D;
        label.font = HDAppTheme.PayNowFont.standard15;
        label.textAlignment = NSTextAlignmentRight;
        _feeValueLabel = label;
    }
    return _feeValueLabel;
}

- (SALabel *)marketingBreaksKeyLabel {
    if (!_marketingBreaksKeyLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c9599A2;
        label.font = HDAppTheme.PayNowFont.standard14;
        label.text = PNLocalizedString(@"promotion", @"promotion");
        label.hidden = YES;
        _marketingBreaksKeyLabel = label;
    }
    return _marketingBreaksKeyLabel;
}

- (SALabel *)marketingBreaksValueLabel {
    if (!_marketingBreaksValueLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.cFD7127;
        label.font = HDAppTheme.PayNowFont.standard15;
        label.textAlignment = NSTextAlignmentRight;
        label.hidden = YES;
        _marketingBreaksValueLabel = label;
    }
    return _marketingBreaksValueLabel;
}

- (SALabel *)chargeTypeKeyLabel {
    if (!_chargeTypeKeyLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c9599A2;
        label.font = HDAppTheme.PayNowFont.standard14;
        label.text = PNLocalizedString(@"charge_type", @"charge type");
        _chargeTypeKeyLabel = label;
    }
    return _chargeTypeKeyLabel;
}

- (SALabel *)chargeTypeValueLabel {
    if (!_chargeTypeValueLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.cFD7127;
        label.font = HDAppTheme.PayNowFont.standard15;
        label.textAlignment = NSTextAlignmentRight;
        label.numberOfLines = 0;
        _chargeTypeValueLabel = label;
    }
    return _chargeTypeValueLabel;
}

- (SALabel *)totalAmountKeyLabel {
    if (!_totalAmountKeyLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c9599A2;
        label.font = HDAppTheme.PayNowFont.standard14B;
        label.text = PNLocalizedString(@"total_amount", @"Total Amount");
        _totalAmountKeyLabel = label;
    }
    return _totalAmountKeyLabel;
}

- (SALabel *)totalAmountValueLabel {
    if (!_totalAmountValueLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c343B4D;
        label.font = HDAppTheme.PayNowFont.standard15B;
        label.textAlignment = NSTextAlignmentRight;
        _totalAmountValueLabel = label;
    }
    return _totalAmountValueLabel;
}

- (SALabel *)otherTotalAmountKeyLabel {
    if (!_otherTotalAmountKeyLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c9599A2;
        label.font = HDAppTheme.PayNowFont.standard14B;
        label.text = PNLocalizedString(@"total_Amount_exchange_USD", @"支付合计（换算为USD）");
        _otherTotalAmountKeyLabel = label;
    }
    return _otherTotalAmountKeyLabel;
}

- (SALabel *)otherTotalAmountValueLabel {
    if (!_otherTotalAmountValueLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c343B4D;
        label.font = HDAppTheme.PayNowFont.standard15B;
        label.textAlignment = NSTextAlignmentRight;
        _otherTotalAmountValueLabel = label;
    }
    return _otherTotalAmountValueLabel;
}
@end
