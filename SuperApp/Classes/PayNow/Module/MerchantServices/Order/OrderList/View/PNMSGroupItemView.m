//
//  PNMSGroupItemView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSGroupItemView.h"
#import "PNCommonUtils.h"


@interface PNMSGroupItemView ()
@property (nonatomic, strong) SALabel *titleLabel;
@property (nonatomic, strong) SALabel *usdAmountLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) SALabel *khrAmountLabel;
@end


@implementation PNMSGroupItemView

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
    [self addSubview:self.titleLabel];
    [self addSubview:self.usdAmountLabel];
    [self addSubview:self.lineView];
    [self addSubview:self.khrAmountLabel];
}

- (void)updateConstraints {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.mas_right).offset(-kRealWidth(12));
        make.top.mas_equalTo(self.mas_top).offset(kRealWidth(8));
    }];

    [self.usdAmountLabel sizeToFit];
    [self.usdAmountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(12));
        make.top.mas_equalTo(self.titleLabel.mas_bottom);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-kRealWidth(8));
    }];

    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.usdAmountLabel.mas_right).offset(kRealWidth(8));
        make.width.equalTo(@(PixelOne));
        make.height.equalTo(@(7));
        make.centerY.mas_equalTo(self.usdAmountLabel.mas_centerY);
    }];

    [self.khrAmountLabel sizeToFit];
    [self.khrAmountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.lineView.mas_right).offset(kRealWidth(8));
        make.right.mas_greaterThanOrEqualTo(self.mas_right).offset(-kRealWidth(12));
        make.centerY.mas_equalTo(self.usdAmountLabel.mas_centerY);
    }];

    [self.usdAmountLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    [super updateConstraints];
}

- (void)setTitle:(NSString *)title usdAmount:(NSNumber *)usdAmount khrAmount:(NSNumber *)khrAmount {
    self.titleLabel.text = title;
    self.usdAmountLabel.text = [NSString stringWithFormat:@"%@", [PNCommonUtils thousandSeparatorAmount:[PNCommonUtils fenToyuan:usdAmount.stringValue] currencyCode:PNCurrencyTypeUSD]];

    self.khrAmountLabel.text = [NSString stringWithFormat:@"%@", [PNCommonUtils thousandSeparatorAmount:[PNCommonUtils fenToyuan:khrAmount.stringValue] currencyCode:PNCurrencyTypeKHR]];

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (SALabel *)titleLabel {
    if (!_titleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c999999;
        label.font = HDAppTheme.PayNowFont.standard12;
        label.text = PNLocalizedString(@"pn_Income", @"收入");
        _titleLabel = label;
    }
    return _titleLabel;
}

- (SALabel *)usdAmountLabel {
    if (!_usdAmountLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard12M;
        _usdAmountLabel = label;
    }
    return _usdAmountLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HDAppTheme.PayNowColor.lineColor;
    }
    return _lineView;
}

- (SALabel *)khrAmountLabel {
    if (!_khrAmountLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard12M;
        _khrAmountLabel = label;
    }
    return _khrAmountLabel;
}
@end
