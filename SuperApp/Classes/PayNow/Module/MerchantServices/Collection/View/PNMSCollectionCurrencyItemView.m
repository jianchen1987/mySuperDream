//
//  PNMSCollectionCurrencyItemView.m
//  SuperApp
//
//  Created by xixi on 2022/6/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSCollectionCurrencyItemView.h"
#import "NSMutableAttributedString+Highlight.h"


@interface PNMSCollectionCurrencyItemView ()
@property (nonatomic, strong) UIImageView *currencyImgView;
@property (nonatomic, strong) SALabel *totalMoneyLabel;
@property (nonatomic, strong) SALabel *totalLabel;
@end


@implementation PNMSCollectionCurrencyItemView

- (void)hd_setupViews {
    [self addSubview:self.currencyImgView];
    [self addSubview:self.totalMoneyLabel];
    [self addSubview:self.totalLabel];
}

- (void)updateConstraints {
    [self.currencyImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(12));
        make.top.mas_equalTo(self.mas_top).offset(kRealWidth(8));
        make.bottom.mas_equalTo(self.mas_bottom).offset(kRealWidth(-8));
        make.size.mas_equalTo(@(self.currencyImgView.image.size));
    }];

    [self.totalMoneyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.currencyImgView.mas_right).offset(kRealWidth(8));
        make.right.mas_equalTo(self.totalLabel.mas_left).offset(kRealWidth(-8));
        make.centerY.mas_equalTo(self.mas_centerY);
    }];

    [self.totalLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-12));
        make.centerY.mas_equalTo(self.totalMoneyLabel.mas_centerY);
    }];

    [super updateConstraints];
}

- (void)setModel:(PNMSCollectionCurrencyItemModel *)model {
    _model = model;

    NSString *hightStr = model.money;
    if ([self.model.currency isEqualToString:PNCurrencyTypeKHR]) {
        self.currencyImgView.image = [UIImage imageNamed:@"currency_icon_khr"];
    } else {
        self.currencyImgView.image = [UIImage imageNamed:@"currency_icon_usd"];
    }

    NSString *allStr = [NSString stringWithFormat:@"%@%@", hightStr, model.currency];
    self.totalMoneyLabel.attributedText = [NSMutableAttributedString highLightString:hightStr inWholeString:allStr highLightFont:[HDAppTheme.PayNowFont fontDINBold:28]
                                                                      highLightColor:HDAppTheme.PayNowColor.cFFFFFF
                                                                             norFont:HDAppTheme.PayNowFont.standard12
                                                                            norColor:HDAppTheme.PayNowColor.cFFFFFF];

    self.totalLabel.text = [NSString stringWithFormat:PNLocalizedString(@"pn_ms_money_count", @"共%@笔"), model.count];

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (UIImageView *)currencyImgView {
    if (!_currencyImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];

        _currencyImgView = imageView;
    }
    return _currencyImgView;
}

- (SALabel *)totalMoneyLabel {
    if (!_totalMoneyLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.cFFFFFF;
        label.font = [HDAppTheme.PayNowFont fontDINBold:28];
        _totalMoneyLabel = label;
    }
    return _totalMoneyLabel;
}

- (SALabel *)totalLabel {
    if (!_totalLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.cFFFFFF;
        label.font = HDAppTheme.PayNowFont.standard12;
        _totalLabel = label;
    }
    return _totalLabel;
}
@end


@implementation PNMSCollectionCurrencyItemModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.count = @"0";
        self.money = @"0";
        self.currency = PNCurrencyTypeUSD;
    }
    return self;
}

@end
