//
//  PNMSBillListCountView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/30.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSBillListCountView.h"
#import "HDAppTheme+PayNow.h"
#import "NSMutableAttributedString+Highlight.h"
#import "PNMultiLanguageManager.h"
#import "SALabel.h"


@interface PNMSBillListCountView ()
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) SALabel *titleLabel;
@property (nonatomic, strong) SALabel *usdCountLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) SALabel *khrCountLabel;
@end


@implementation PNMSBillListCountView

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
    [self addSubview:self.topLineView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.usdCountLabel];
    [self addSubview:self.lineView];
    [self addSubview:self.khrCountLabel];
}

- (void)updateConstraints {
    [self.topLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.mas_right).offset(-kRealWidth(12));
        make.height.equalTo(@(PixelOne));
        make.top.mas_equalTo(self.mas_top);
    }];

    [self.titleLabel sizeToFit];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(12));
        make.top.mas_equalTo(self.topLineView.mas_top).offset(kRealWidth(8));
        make.bottom.mas_equalTo(self.mas_bottom).offset(-kRealWidth(8));
        make.width.equalTo(self.mas_width).multipliedBy(0.5);
    }];

    [self.usdCountLabel sizeToFit];
    [self.usdCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.lineView.mas_left).offset(-kRealWidth(8));
        make.left.mas_equalTo(self.titleLabel.mas_right);
        make.top.equalTo(self.khrCountLabel);
    }];

    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.usdCountLabel.mas_right).offset(kRealWidth(8));
        make.width.equalTo(@(PixelOne));
        make.height.equalTo(@(7));
        make.centerY.mas_equalTo(self.khrCountLabel.mas_centerY);
    }];

    [self.khrCountLabel sizeToFit];
    [self.khrCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
        make.left.mas_equalTo(self.lineView.mas_right).offset(kRealWidth(8));
    }];

    [super updateConstraints];
}

- (void)setUsdTimes:(NSInteger)usdTimes khrTimes:(NSInteger)khrTimes {
    NSString *usdHightStr = [NSString stringWithFormat:@"%zd", usdTimes];
    NSString *usdAllStr = [NSString stringWithFormat:@"%@ %@%@", PNCurrencyTypeUSD, usdHightStr, PNLocalizedString(@"pn_trans_count", @"笔")];

    NSString *khrHightStr = [NSString stringWithFormat:@"%zd", khrTimes];
    NSString *khrAllStr = [NSString stringWithFormat:@"%@ %@%@", PNCurrencyTypeKHR, khrHightStr, PNLocalizedString(@"pn_trans_count", @"笔")];

    self.usdCountLabel.attributedText = [NSMutableAttributedString highLightString:usdHightStr inWholeString:usdAllStr highLightFont:HDAppTheme.PayNowFont.standard12
                                                                    highLightColor:HDAppTheme.PayNowColor.c999999
                                                                           norFont:HDAppTheme.PayNowFont.standard12
                                                                          norColor:HDAppTheme.PayNowColor.cCCCCCC];
    self.khrCountLabel.attributedText = [NSMutableAttributedString highLightString:khrHightStr inWholeString:khrAllStr highLightFont:HDAppTheme.PayNowFont.standard12
                                                                    highLightColor:HDAppTheme.PayNowColor.c999999
                                                                           norFont:HDAppTheme.PayNowFont.standard12
                                                                          norColor:HDAppTheme.PayNowColor.cCCCCCC];

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (UIView *)topLineView {
    if (!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    }
    return _topLineView;
}

- (SALabel *)titleLabel {
    if (!_titleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c999999;
        label.font = HDAppTheme.PayNowFont.standard12;
        label.text = PNLocalizedString(@"pn_trans_Record_count", @"交易记录笔数");
        _titleLabel = label;
    }
    return _titleLabel;
}

- (SALabel *)usdCountLabel {
    if (!_usdCountLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard12;
        label.text = @"0笔";
        _usdCountLabel = label;
    }
    return _usdCountLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HDAppTheme.PayNowColor.lineColor;
    }
    return _lineView;
}

- (SALabel *)khrCountLabel {
    if (!_khrCountLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard12;
        label.text = @"10笔";
        _khrCountLabel = label;
    }
    return _khrCountLabel;
}
@end
