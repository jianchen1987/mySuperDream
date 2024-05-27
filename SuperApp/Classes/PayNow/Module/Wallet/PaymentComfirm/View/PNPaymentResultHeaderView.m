//
//  PNPaymentResultHeaderView.m
//  SuperApp
//
//  Created by xixi_wen on 2023/2/8.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNPaymentResultHeaderView.h"
#import "HDAppTheme+PayNow.h"
#import "PNCommonUtils.h"
#import "SALabel.h"


@interface PNPaymentResultHeaderView ()
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) SALabel *tradeTypeLabel;
@property (nonatomic, strong) SALabel *statusLabel;
@property (nonatomic, strong) SALabel *amountLabel;
@property (nonatomic, strong) UIView *line;
@end


@implementation PNPaymentResultHeaderView

- (void)hd_setupViews {
    [self.contentView addSubview:self.iconImgView];
    [self.contentView addSubview:self.tradeTypeLabel];
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.amountLabel];
    [self.contentView addSubview:self.line];
}

- (void)updateConstraints {
    [self.iconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.iconImgView.image.size);
        make.top.mas_equalTo(self.contentView.mas_top).offset(kRealWidth(15));
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
    }];

    [self.tradeTypeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.top.mas_equalTo(self.iconImgView.mas_bottom).offset(kRealWidth(20));
    }];

    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.top.mas_equalTo(self.tradeTypeLabel.mas_bottom);
    }];

    [self.amountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.statusLabel);
        make.top.mas_equalTo(self.statusLabel.mas_bottom).offset(kRealWidth(16));
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
- (void)setModel:(PNPaymentResultRspModel *)model {
    _model = model;

    NSString *typeStr = @"";
    if (HDIsStringNotEmpty(self.model.subBizEntityString)) {
        typeStr = self.model.subBizEntityString;
    } else {
        typeStr = self.model.bizEntityString;
    }
    self.tradeTypeLabel.text = typeStr;
    self.amountLabel.text = self.model.total.thousandSeparatorAmount;
    self.statusLabel.text = [NSString stringWithFormat:@"(%@)", self.model.statusString];

    self.iconImgView.image = [UIImage imageNamed:[self getImageName:model.status]];

    [self setNeedsUpdateConstraints];
}

- (NSString *)getImageName:(PNWalletBalanceOrderStatus)status {
    NSString *str = @"";
    switch (self.model.status) {
        case PNWalletBalanceOrderStatus_Success:
            str = @"pay_success";
            break;
        case PNWalletBalanceOrderStatus_Fail:
            str = @"pay_fail";
            break;
        case PNWalletBalanceOrderStatus_Processing:
            str = @"pay_processing";
            break;
        default:
            str = @"pay_fail";
            break;
    }

    return str;
}

#pragma mark
- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        _iconImgView = imageView;
    }
    return _iconImgView;
}

- (SALabel *)tradeTypeLabel {
    if (!_tradeTypeLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard18B;
        label.textAlignment = NSTextAlignmentCenter;
        _tradeTypeLabel = label;
    }
    return _tradeTypeLabel;
}

- (SALabel *)statusLabel {
    if (!_statusLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard14;
        label.textAlignment = NSTextAlignmentCenter;
        _statusLabel = label;
    }
    return _statusLabel;
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
