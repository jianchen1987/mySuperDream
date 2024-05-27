//
//  AcountCell.m
//  SuperApp
//
//  Created by Quin on 2021/11/19.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNAcountCell.h"
#import "PNCommonUtils.h"


@interface PNAcountCell ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *bgImage;
@property (nonatomic, strong) SALabel *titleLB;
@property (nonatomic, strong) UIImageView *CSymbolImage;
@property (nonatomic, strong) SALabel *balanceLB;
@property (nonatomic, strong) UIImageView *currencyImage;
@property (nonatomic, strong) SALabel *currencyLB;

@property (nonatomic, strong) UIView *nonCashBgView;
@property (nonatomic, strong) SALabel *nonCashtitleLB;
@property (nonatomic, strong) HDUIButton *doubtBtn;
@property (nonatomic, strong) UIImageView *nonCSymbolImage;
@property (nonatomic, strong) SALabel *nonBalanceLB; //不可提现余额

@property (nonatomic, strong) UIView *freezeBgView;
@property (nonatomic, strong) SALabel *freezeTitleLabel;
@property (nonatomic, strong) UIImageView *freezeImgView;
@property (nonatomic, strong) SALabel *freezeLabel; //冻结余额

@end


@implementation PNAcountCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.bgImage];
    [self.bgImage addSubview:self.titleLB];
    [self.bgImage addSubview:self.CSymbolImage];
    [self.bgImage addSubview:self.balanceLB];
    [self.bgImage addSubview:self.currencyImage];
    [self.bgImage addSubview:self.currencyLB];

    [self.bgImage addSubview:self.nonCashBgView];
    [self.nonCashBgView addSubview:self.nonCashtitleLB];
    [self.nonCashBgView addSubview:self.doubtBtn];
    [self.nonCashBgView addSubview:self.nonCSymbolImage];
    [self.nonCashBgView addSubview:self.nonBalanceLB];

    [self.bgImage addSubview:self.freezeBgView];
    [self.freezeBgView addSubview:self.freezeTitleLabel];
    [self.freezeBgView addSubview:self.freezeImgView];
    [self.freezeBgView addSubview:self.freezeLabel];

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
    }];

    [self.CSymbolImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.titleLB.mas_leading);
        make.centerY.equalTo(self.balanceLB);
        make.size.mas_equalTo(self.CSymbolImage.image.size);
    }];

    if (!self.nonCashBgView.hidden) {
        [self.nonCashBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.bgImage.mas_left);
            if (!self.freezeBgView.hidden) {
                make.width.equalTo(self.bgImage.mas_width).multipliedBy(0.5);
            } else {
                make.right.mas_equalTo(self.bgImage.mas_right);
            }
            make.top.mas_equalTo(self.balanceLB.mas_bottom).offset(kRealWidth(10));
            make.bottom.mas_equalTo(self.bgImage.mas_bottom);
        }];
    }

    [self.nonCashtitleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nonCashBgView).offset(kRealWidth(15));
        make.top.equalTo(self.nonCashBgView.mas_top);
    }];

    [self.doubtBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nonCashtitleLB);
        make.left.equalTo(self.nonCashtitleLB.mas_right).offset(kRealWidth(5));
        make.width.mas_equalTo(kRealWidth(20));
        make.height.mas_equalTo(kRealWidth(20));
    }];

    [self.nonBalanceLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nonCSymbolImage.mas_right).offset(kRealWidth(3));
        make.top.mas_equalTo(self.nonCashtitleLB.mas_bottom).offset(kRealWidth(2));
        make.right.mas_equalTo(self.nonCashBgView.mas_right).offset(kRealWidth(-5));
    }];

    [self.nonCSymbolImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nonBalanceLB);
        make.left.mas_equalTo(self.nonCashtitleLB.mas_left);
        make.width.mas_equalTo(kRealWidth(7));
        make.height.mas_equalTo(kRealWidth(12));
    }];

    if (!self.freezeBgView.hidden) {
        [self.freezeBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (!self.nonCashBgView.hidden) {
                make.left.mas_equalTo(self.nonCashBgView.mas_right);
            } else {
                make.left.mas_equalTo(self.bgImage.mas_left);
            }
            make.right.mas_equalTo(self.bgImage.mas_right);
            make.top.mas_equalTo(self.balanceLB.mas_bottom).offset(kRealWidth(10));
            make.bottom.mas_equalTo(self.bgImage.mas_bottom);
        }];
    }

    [self.freezeTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.freezeBgView).offset(kRealWidth(15));
        make.top.equalTo(self.freezeBgView.mas_top);
    }];

    [self.freezeImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.freezeLabel);
        make.left.mas_equalTo(self.freezeTitleLabel.mas_left);
        make.width.mas_equalTo(kRealWidth(7));
        make.height.mas_equalTo(kRealWidth(12));
    }];

    [self.freezeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.freezeImgView.mas_right).offset(kRealWidth(3));
        make.top.mas_equalTo(self.freezeTitleLabel.mas_bottom).offset(kRealWidth(2));
        make.right.mas_equalTo(self.freezeBgView.mas_right).offset(kRealWidth(-5));
    }];

    [super updateConstraints];
}

#pragma mark - getters and setters
- (void)setModel:(PNAcountCellModel *)model {
    _model = model;

    self.bgImage.image = [UIImage imageNamed:model.bgImageName];
    self.currencyImage.image = [UIImage imageNamed:model.currencyImageName];
    self.CSymbolImage.image = [UIImage imageNamed:model.CSymbolImageNmae];
    self.nonCSymbolImage.image = [UIImage imageNamed:model.CSymbolImageNmae];
    self.balanceLB.text = [PNCommonUtils thousandSeparatorNoCurrencySymbolWithAmount:model.balance currencyCode:model.currency];

    self.currencyLB.text = model.currency;
    self.nonBalanceLB.text = [PNCommonUtils thousandSeparatorNoCurrencySymbolWithAmount:model.nonCashBalance currencyCode:model.currency];
    if ([model.nonCashBalance doubleValue] <= 0) {
        self.nonCashBgView.hidden = YES;
    } else {
        self.nonCashBgView.hidden = NO;
    }

    self.freezeImgView.image = [UIImage imageNamed:model.CSymbolImageNmae];
    self.freezeLabel.text = [PNCommonUtils thousandSeparatorNoCurrencySymbolWithAmount:model.freezeBalance currencyCode:model.currency];
    if (_model.freezeBalance.doubleValue <= 0) {
        self.freezeBgView.hidden = YES;
    } else {
        self.freezeBgView.hidden = NO;
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

- (SALabel *)freezeTitleLabel {
    if (!_freezeTitleLabel) {
        SALabel *label = SALabel.new;
        label.text = PNLocalizedString(@"Blocked_amount", @"冻结金额");
        label.font = [HDAppTheme.font forSize:13];
        label.textColor = [UIColor hd_colorWithHexString:@"#DBEBF3"];
        _freezeTitleLabel = label;
    }
    return _freezeTitleLabel;
}

- (UIImageView *)freezeImgView {
    if (!_freezeImgView) {
        _freezeImgView = UIImageView.new;
    }
    return _freezeImgView;
}

- (SALabel *)freezeLabel {
    if (!_freezeLabel) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.PayNowFont fontDINBold:20];
        label.textColor = [UIColor whiteColor];
        label.adjustsFontSizeToFitWidth = YES;
        _freezeLabel = label;
    }
    return _freezeLabel;
}

- (SALabel *)nonCashtitleLB {
    if (!_nonCashtitleLB) {
        SALabel *label = SALabel.new;
        label.text = PNLocalizedString(@"Non_withdrawable_balance", @"不可提现余额");
        label.font = [HDAppTheme.font forSize:13];
        label.textColor = [UIColor hd_colorWithHexString:@"#DBEBF3"];
        _nonCashtitleLB = label;
    }
    return _nonCashtitleLB;
}

- (HDUIButton *)doubtBtn {
    if (!_doubtBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsButtonWhenHighlighted = false;
        [button setImage:[UIImage imageNamed:@"explain"] forState:UIControlStateNormal];
        [button sizeToFit];
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [NAT showAlertWithTitle:PNLocalizedString(@"What_is_a_non_withdrawable_balance", @"") message:PNLocalizedString(@"What_is_a_non_withdrawable_balance_des", @"")
                        buttonTitle:SALocalizedString(@"i_know", @"我知道了") handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                            [alertView dismiss];
                        }];
        }];
        _doubtBtn = button;
    }
    return _doubtBtn;
}

- (UIImageView *)nonCSymbolImage {
    if (!_nonCSymbolImage) {
        _nonCSymbolImage = UIImageView.new;
    }
    return _nonCSymbolImage;
}

- (SALabel *)nonBalanceLB {
    if (!_nonBalanceLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.PayNowFont fontDINBold:20];
        label.textColor = [UIColor whiteColor];
        label.adjustsFontSizeToFitWidth = YES;
        _nonBalanceLB = label;
    }
    return _nonBalanceLB;
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

- (UIView *)nonCashBgView {
    if (!_nonCashBgView) {
        _nonCashBgView = [[UIView alloc] init];
    }
    return _nonCashBgView;
}

- (UIView *)freezeBgView {
    if (!_freezeBgView) {
        _freezeBgView = [[UIView alloc] init];
    }
    return _freezeBgView;
}

@end
