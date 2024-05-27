//
//  PNWalletOrderDetailHeaderView.m
//  SuperApp
//
//  Created by xixi_wen on 2023/2/6.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNWalletOrderDetailHeaderView.h"
#import "HDAppTheme+PayNow.h"
#import "SALabel.h"


@interface PNWalletOrderDetailHeaderView ()
@property (nonatomic, strong) SALabel *tradeTypeLabel;
@property (nonatomic, strong) SALabel *amountLabel;
@property (nonatomic, strong) UIView *line;
@end


@implementation PNWalletOrderDetailHeaderView

- (void)hd_setupViews {
    [self.contentView addSubview:self.tradeTypeLabel];
    [self.contentView addSubview:self.amountLabel];
    [self.contentView addSubview:self.line];
}

- (void)updateConstraints {
    [self.tradeTypeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.top.mas_equalTo(self.contentView.mas_top).offset(kRealWidth(15));
    }];

    [self.amountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.tradeTypeLabel);
        make.top.mas_equalTo(self.tradeTypeLabel.mas_bottom).offset(kRealWidth(16));
    }];

    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.top.mas_equalTo(self.amountLabel.mas_bottom).offset(kRealWidth(30));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-kRealWidth(15));
        make.height.equalTo(@(1));
    }];

    [super updateConstraints];
}

#pragma mark
- (void)setModel:(PNWalletOrderDetailModel *)model {
    _model = model;

    self.tradeTypeLabel.text = model.orderType;
    self.amountLabel.text = model.orderAmt.thousandSeparatorAmount;

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (SALabel *)tradeTypeLabel {
    if (!_tradeTypeLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard16;
        label.textAlignment = NSTextAlignmentCenter;
        _tradeTypeLabel = label;
    }
    return _tradeTypeLabel;
}

- (SALabel *)amountLabel {
    if (!_amountLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = [HDAppTheme.PayNowFont fontDINBold:30];
        label.textAlignment = NSTextAlignmentCenter;
        _amountLabel = label;
    }
    return _amountLabel;
}

- (UIView *)line {
    if (!_line) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.lineColor;

        _line = view;
    }
    return _line;
}

@end
