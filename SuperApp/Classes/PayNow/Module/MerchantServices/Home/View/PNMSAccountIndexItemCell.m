//
//  PNMSAccountIndexItemCell.m
//  SuperApp
//
//  Created by xixi_wen on 2022/6/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSAccountIndexItemCell.h"
#import "PNCommonUtils.h"


@interface PNMSAccountIndexItemCell ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *bgImage;
// 总余额
@property (nonatomic, strong) SALabel *titleLB;
@property (nonatomic, strong) UIImageView *CSymbolImage;
@property (nonatomic, strong) SALabel *balanceLB;
@property (nonatomic, strong) UIImageView *currencyImage;
@property (nonatomic, strong) SALabel *currencyLB;

//可用余额
@property (nonatomic, strong) UIView *usableBalanceBgView;
@property (nonatomic, strong) SALabel *usableBalanceTitleLabel;
@property (nonatomic, strong) UIImageView *usableBalanceImgView;
@property (nonatomic, strong) SALabel *usableBalanceLabel;

@end


@implementation PNMSAccountIndexItemCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.bgImage];
    [self.bgImage addSubview:self.titleLB];
    [self.bgImage addSubview:self.CSymbolImage];
    [self.bgImage addSubview:self.balanceLB];
    [self.bgImage addSubview:self.currencyImage];
    [self.bgImage addSubview:self.currencyLB];

    [self.bgImage addSubview:self.usableBalanceBgView];
    [self.usableBalanceBgView addSubview:self.usableBalanceTitleLabel];
    [self.usableBalanceBgView addSubview:self.usableBalanceImgView];
    [self.usableBalanceBgView addSubview:self.usableBalanceLabel];

    self.bgImage.userInteractionEnabled = YES;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark - layout
- (void)updateConstraints {
    [self.bgImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];

    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImage).offset(kRealWidth(15));
        make.centerY.equalTo(self.currencyImage);
    }];

    [self.currencyLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgImage.mas_right).offset(-kRealWidth(15));
        make.centerY.equalTo(self.currencyImage);
    }];

    [self.currencyImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.currencyLB.mas_left).offset(-kRealWidth(5));
        make.top.equalTo(self.bgImage).offset(kRealWidth(15));
        make.width.mas_equalTo(kRealWidth(30));
        make.height.mas_equalTo(kRealWidth(30));
    }];

    [self.balanceLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLB.mas_bottom).offset(kRealWidth(2));
        make.left.equalTo(self.CSymbolImage.mas_right).offset(kRealWidth(5));
        make.right.mas_equalTo(self.bgImage.mas_right).offset(kRealWidth(-15));
    }];

    [self.CSymbolImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.titleLB.mas_leading);
        make.centerY.equalTo(self.balanceLB);
        make.size.mas_equalTo(self.CSymbolImage.image.size);
    }];

    if (!self.usableBalanceBgView.hidden) {
        [self.usableBalanceBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.bgImage.mas_left);
            make.right.mas_equalTo(self.bgImage.mas_right);
            make.top.mas_equalTo(self.balanceLB.mas_bottom).offset(kRealWidth(10));
            make.bottom.mas_equalTo(self.bgImage.mas_bottom);
        }];
    }

    [self.usableBalanceTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.usableBalanceBgView).offset(kRealWidth(15));
        make.top.equalTo(self.usableBalanceBgView.mas_top);
    }];

    [self.usableBalanceImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.usableBalanceLabel);
        make.left.mas_equalTo(self.usableBalanceTitleLabel.mas_left);
        make.size.mas_equalTo(self.usableBalanceImgView.image.size);
    }];

    [self.usableBalanceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.usableBalanceImgView.mas_right).offset(kRealWidth(3));
        make.top.mas_equalTo(self.usableBalanceTitleLabel.mas_bottom).offset(kRealWidth(2));
        make.right.mas_equalTo(self.usableBalanceBgView.mas_right).offset(kRealWidth(-5));
    }];

    [super updateConstraints];
}

#pragma mark - getters and setters
- (void)setModel:(PNAcountCellModel *)model {
    _model = model;

    self.bgImage.image = [UIImage imageNamed:model.bgImageName];
    self.currencyImage.image = [UIImage imageNamed:model.currencyImageName];
    self.CSymbolImage.image = [UIImage imageNamed:model.CSymbolImageNmae];

    self.currencyLB.text = model.currency;
    self.balanceLB.text = model.balance;

    self.usableBalanceImgView.image = [UIImage imageNamed:model.CSymbolImageNmae];
    self.usableBalanceLabel.text = model.usableBalance;
    if (_model.usableBalance.doubleValue <= 0) {
        self.usableBalanceBgView.hidden = YES;
    } else {
        self.usableBalanceBgView.hidden = NO;
    }

    [self setNeedsUpdateConstraints];
}

- (UIImageView *)bgImage {
    if (!_bgImage) {
        _bgImage = UIImageView.new;
        _bgImage.contentMode = UIViewContentModeScaleAspectFill;
        _bgImage.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:12];
        };
    }
    return _bgImage;
}

- (SALabel *)titleLB {
    if (!_titleLB) {
        SALabel *label = SALabel.new;
        label.text = PNLocalizedString(@"Balance", @"余额");
        label.font = [HDAppTheme.font forSize:13];
        label.textColor = [UIColor hd_colorWithHexString:@"#DBEBF3"];
        _titleLB = label;
    }
    return _titleLB;
}

- (UIImageView *)CSymbolImage {
    if (!_CSymbolImage) {
        _CSymbolImage = UIImageView.new;
    }
    return _CSymbolImage;
}

- (SALabel *)balanceLB {
    if (!_balanceLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.PayNowFont fontDINBold:40];
        label.textColor = [UIColor whiteColor];
        _balanceLB = label;
    }
    return _balanceLB;
}

- (UIImageView *)currencyImage {
    if (!_currencyImage) {
        _currencyImage = UIImageView.new;
    }
    return _currencyImage;
}

- (SALabel *)currencyLB {
    if (!_currencyLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.PayNowFont fontSemibold:17];
        label.textColor = [UIColor whiteColor];
        _currencyLB = label;
    }
    return _currencyLB;
}

- (SALabel *)usableBalanceTitleLabel {
    if (!_usableBalanceTitleLabel) {
        SALabel *label = SALabel.new;
        label.text = PNLocalizedString(@"pn_ms_available_balance", @"可用余额");
        label.font = [HDAppTheme.font forSize:13];
        label.textColor = [UIColor hd_colorWithHexString:@"#DBEBF3"];
        _usableBalanceTitleLabel = label;
    }
    return _usableBalanceTitleLabel;
}

- (UIImageView *)usableBalanceImgView {
    if (!_usableBalanceImgView) {
        _usableBalanceImgView = UIImageView.new;
    }
    return _usableBalanceImgView;
}

- (SALabel *)usableBalanceLabel {
    if (!_usableBalanceLabel) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.PayNowFont fontDINBold:20];
        label.textColor = [UIColor whiteColor];
        label.adjustsFontSizeToFitWidth = YES;
        _usableBalanceLabel = label;
    }
    return _usableBalanceLabel;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = UIView.new;
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:12];
        };
    }
    return _bgView;
}

- (UIView *)usableBalanceBgView {
    if (!_usableBalanceBgView) {
        _usableBalanceBgView = [[UIView alloc] init];
    }
    return _usableBalanceBgView;
}

@end
