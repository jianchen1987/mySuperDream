//
//  PNSelectPayAmountView.m
//  SuperApp
//
//  Created by xixi_wen on 2023/2/7.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNSelectPayAmountView.h"
#import "PNInfoView.h"
#import "PNPaymentComfirmViewModel.h"


@interface PNSelectPayAmountView ()
@property (nonatomic, strong) HDUIButton *usdCheckBtn;
@property (nonatomic, strong) SALabel *usdAmountLabel;
@property (nonatomic, strong) HDUIButton *khrCheckBtn;
@property (nonatomic, strong) SALabel *khrAmountLabel;
@property (nonatomic, strong) SALabel *rateTitleLabel;
@property (nonatomic, strong) SALabel *rateValueLabel;
@property (nonatomic, strong) PNInfoView *payInfoView;
@property (nonatomic, strong) PNView *balanceBgView;
@property (nonatomic, strong) PNInfoView *payUsdBalanceInfoView;
@property (nonatomic, strong) PNInfoView *payKhrBalanceInfoView;
@property (nonatomic, strong) SALabel *tipsLabel;

@property (nonatomic, strong) PNPaymentComfirmViewModel *viewModel;
@end


@implementation PNSelectPayAmountView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
    [self addSubview:self.usdCheckBtn];
    [self addSubview:self.usdAmountLabel];

    [self addSubview:self.khrCheckBtn];
    [self addSubview:self.khrAmountLabel];
    [self addSubview:self.rateTitleLabel];
    [self addSubview:self.rateValueLabel];

    [self addSubview:self.payInfoView];

    [self addSubview:self.balanceBgView];
    [self.balanceBgView addSubview:self.payUsdBalanceInfoView];
    [self.balanceBgView addSubview:self.payKhrBalanceInfoView];
    [self.balanceBgView addSubview:self.tipsLabel];
}

- (void)updateConstraints {
    [self.usdCheckBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(20));
        make.top.mas_equalTo(self.mas_top).offset(kRealWidth(12));
    }];

    [self.usdAmountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-kRealWidth(12));
        make.centerY.mas_equalTo(self.usdCheckBtn.mas_centerY);
    }];

    [self.khrCheckBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.usdCheckBtn.mas_left);
        make.top.mas_equalTo(self.usdCheckBtn.mas_bottom).offset(kRealWidth(12));
    }];

    [self.khrAmountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.usdAmountLabel);
        make.centerY.mas_equalTo(self.khrCheckBtn.mas_centerY);
    }];

    if (!self.rateTitleLabel.hidden) {
        [self.rateTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.khrCheckBtn.mas_left).offset(kRealWidth(18));
            make.top.mas_equalTo(self.khrCheckBtn.mas_bottom).offset(kRealWidth(12));
        }];

        [self.rateValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.khrAmountLabel.mas_right);
            make.left.mas_equalTo(self.rateTitleLabel.mas_right);
            make.top.bottom.mas_equalTo(self.rateTitleLabel);
        }];
    }

    [self.payInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        if (!self.rateTitleLabel.hidden) {
            make.top.mas_equalTo(self.rateTitleLabel.mas_bottom).offset(kRealWidth(16));
        } else {
            make.top.mas_equalTo(self.khrCheckBtn.mas_bottom).offset(kRealWidth(16));
        }
    }];

    [self.balanceBgView removeConstraints:self.balanceBgView.constraints];
    [self.balanceBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.top.mas_equalTo(self.payInfoView.mas_bottom);
    }];

    NSArray<UIView *> *visableInfoViews = [self.balanceBgView.subviews hd_filterWithBlock:^BOOL(UIView *_Nonnull item) {
        return !item.isHidden;
    }];

    UIView *lastInfoView;
    for (UIView *infoView in visableInfoViews) {
        [infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (lastInfoView) {
                make.top.equalTo(lastInfoView.mas_bottom);
            } else {
                if ([infoView isMemberOfClass:PNInfoView.class]) {
                    make.top.equalTo(self.balanceBgView);
                } else {
                    make.top.equalTo(self.balanceBgView).offset(kRealWidth(20));
                }
            }

            make.left.right.equalTo(self.balanceBgView);
            if (infoView == visableInfoViews.lastObject) {
                if ([infoView isMemberOfClass:PNInfoView.class]) {
                    PNInfoView *lastV = (PNInfoView *)infoView;
                    lastV.model.lineWidth = 0;
                    [lastV setNeedsUpdateContent];

                    make.bottom.mas_equalTo(self.balanceBgView.mas_bottom);
                } else {
                    make.bottom.mas_equalTo(self.balanceBgView.mas_bottom).offset(-kRealWidth(20));
                    ;
                }
            }
        }];
        lastInfoView = infoView;
    }

    [super updateConstraints];
}

#pragma mark
- (void)setModel:(PNPaymentComfirmRspModel *)model {
    _model = model;

    PNWalletBalanceType type = model.balanceTypeEnum.code.integerValue;
    if (type == PNWalletBalanceType_USD_BALANCE) {
        self.usdCheckBtn.selected = YES;
        self.khrCheckBtn.selected = NO;
    } else if (type == PNWalletBalanceType_KHR_BALANCE) {
        self.usdCheckBtn.selected = NO;
        self.khrCheckBtn.selected = YES;
    } else if (type == PNWalletBalanceType_USD_KHR_BALANCE) {
        self.usdCheckBtn.selected = YES;
        self.khrCheckBtn.selected = YES;
    } else {
        self.usdCheckBtn.selected = NO;
        self.khrCheckBtn.selected = NO;
    }

    self.usdAmountLabel.text = self.model.usdBalance.thousandSeparatorAmount;
    self.khrAmountLabel.text = self.model.khrBalance.thousandSeparatorAmount;

    if (self.model.rate.doubleValue > 0) {
        self.rateValueLabel.text = [NSString stringWithFormat:@"$1=៛%@", self.model.rate];
        self.rateValueLabel.hidden = NO;
        self.rateTitleLabel.hidden = NO;
    } else {
        self.rateValueLabel.hidden = YES;
        self.rateTitleLabel.hidden = YES;
    }

    if (self.model.balanceEnough) {
        self.tipsLabel.hidden = YES;

        if (!WJIsObjectNil(self.model.accountUsd)) {
            self.payUsdBalanceInfoView.hidden = NO;

            NSString *amount = self.model.accountUsd.thousandSeparatorAmount;
            if (!WJIsObjectNil(self.model.exchangeAmount) && ![self.model.exchangeAmount.cy isEqualToString:self.model.accountUsd.cy]) {
                amount = [amount stringByAppendingFormat:@"(%@)", self.model.exchangeAmount.thousandSeparatorAmount];
            }
            self.payUsdBalanceInfoView.model.valueText = amount;
            [self.payUsdBalanceInfoView setNeedsUpdateContent];
        } else {
            self.payUsdBalanceInfoView.hidden = YES;
        }

        if (!WJIsObjectNil(self.model.accountKhr)) {
            self.payKhrBalanceInfoView.hidden = NO;

            NSString *amount = self.model.accountKhr.thousandSeparatorAmount;
            if (!WJIsObjectNil(self.model.exchangeAmount) && ![self.model.exchangeAmount.cy isEqualToString:self.model.accountKhr.cy]) {
                amount = [amount stringByAppendingFormat:@"(%@)", self.model.exchangeAmount.thousandSeparatorAmount];
            }
            self.payKhrBalanceInfoView.model.valueText = amount;
            [self.payKhrBalanceInfoView setNeedsUpdateContent];
        } else {
            self.payKhrBalanceInfoView.hidden = YES;
        }
    } else {
        self.tipsLabel.text = PNLocalizedString(@"wu0BFgDi", @"账户余额不足");
        self.tipsLabel.hidden = NO;
        self.payUsdBalanceInfoView.hidden = YES;
        self.payKhrBalanceInfoView.hidden = YES;
    }

    [self setNeedsUpdateConstraints];
}

- (void)btnSelect:(HDUIButton *)btn {
    ///
    if ([self rultLimt:btn]) {
        PNWalletBalanceType type;
        ///已知的规则必然会选中一个
        BOOL selectAction = !btn.selected;
        if (btn.tag == 10) {
            if (selectAction) {
                if (self.khrCheckBtn.selected) {
                    type = PNWalletBalanceType_USD_KHR_BALANCE;
                } else {
                    type = PNWalletBalanceType_USD_BALANCE;
                }
            } else {
                if (self.khrCheckBtn.selected) {
                    type = PNWalletBalanceType_KHR_BALANCE;
                } else {
                    ///理论上不会走到这判断
                    type = PNWalletBalanceType_Non;
                }
            }
        } else {
            if (selectAction) {
                if (self.usdCheckBtn.selected) {
                    type = PNWalletBalanceType_USD_KHR_BALANCE;
                } else {
                    type = PNWalletBalanceType_KHR_BALANCE;
                }
            } else {
                if (self.usdCheckBtn.selected) {
                    type = PNWalletBalanceType_USD_BALANCE;
                } else {
                    ///理论上不会走到这判断
                    type = PNWalletBalanceType_Non;
                }
            }
        }
        [self.viewModel getData:type];
    }
}

- (BOOL)rultLimt:(HDUIButton *)btn {
    /// 假设要做的动作
    BOOL selectAction = !btn.selected;

    /// 假设是 USD
    if (btn.tag == 10) {
        /// 取消 选中
        if (!selectAction && !self.khrCheckBtn.selected) {
            return NO;
        } else {
            return YES;
        }
    } else {
        /// 取消 选中
        if (!selectAction && !self.usdCheckBtn.selected) {
            return NO;
        } else {
            return YES;
        }
    }
}

#pragma mark
- (HDUIButton *)usdCheckBtn {
    if (!_usdCheckBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:PNLocalizedString(@"OhU54vkx", @" USD账户余额：") forState:UIControlStateNormal];
        [button setTitleColor:HDAppTheme.PayNowColor.c333333 forState:0];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard14;
        [button setImage:[UIImage imageNamed:@"pn_check_nor"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"pn_check_sel"] forState:UIControlStateSelected];
        button.spacingBetweenImageAndTitle = kRealWidth(4);
        button.contentEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(12), kRealWidth(5), kRealWidth(12));
        [button addTarget:self action:@selector(btnSelect:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 10;

        _usdCheckBtn = button;
    }
    return _usdCheckBtn;
}

- (HDUIButton *)khrCheckBtn {
    if (!_khrCheckBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:PNLocalizedString(@"xpelIs48", @" KHR账户余额：") forState:UIControlStateNormal];
        [button setTitleColor:HDAppTheme.PayNowColor.c333333 forState:0];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard14;
        [button setImage:[UIImage imageNamed:@"pn_check_nor"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"pn_check_sel"] forState:UIControlStateSelected];
        button.spacingBetweenImageAndTitle = kRealWidth(4);
        button.contentEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(12), kRealWidth(5), kRealWidth(12));
        [button addTarget:self action:@selector(btnSelect:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 20;

        _khrCheckBtn = button;
    }
    return _khrCheckBtn;
}

- (SALabel *)usdAmountLabel {
    if (!_usdAmountLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = [HDAppTheme.PayNowFont fontDINBold:16];
        _usdAmountLabel = label;
    }
    return _usdAmountLabel;
}

- (SALabel *)khrAmountLabel {
    if (!_khrAmountLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = [HDAppTheme.PayNowFont fontDINBold:16];
        _khrAmountLabel = label;
    }
    return _khrAmountLabel;
}

- (SALabel *)rateTitleLabel {
    if (!_rateTitleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard14;
        label.text = PNLocalizedString(@"Epqp59t7", @"当前汇率");
        label.hidden = YES;
        _rateTitleLabel = label;
    }
    return _rateTitleLabel;
}

- (SALabel *)rateValueLabel {
    if (!_rateValueLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard14;
        label.hidden = YES;
        _rateValueLabel = label;
    }
    return _rateValueLabel;
}

- (PNInfoView *)payInfoView {
    if (!_payInfoView) {
        PNInfoView *view = PNInfoView.new;

        PNInfoViewModel *model = PNInfoViewModel.new;

        model.keyText = PNLocalizedString(@"Ubs28BGa", @"支付信息");
        model.keyFont = HDAppTheme.PayNowFont.standard16B;
        model.keyColor = HDAppTheme.PayNowColor.c333333;

        model.contentEdgeInsets = UIEdgeInsetsMake(12, 12, 8, 12);
        model.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;

        model.lineWidth = 0;

        view.model = model;
        _payInfoView = view;
    }
    return _payInfoView;
}

- (PNView *)balanceBgView {
    if (!_balanceBgView) {
        PNView *view = [[PNView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        _balanceBgView = view;
    }
    return _balanceBgView;
}

- (PNInfoView *)payUsdBalanceInfoView {
    if (!_payUsdBalanceInfoView) {
        PNInfoView *view = PNInfoView.new;

        PNInfoViewModel *model = PNInfoViewModel.new;

        model.keyText = PNLocalizedString(@"Ieqh3s7V", @"USD账户");
        model.keyFont = HDAppTheme.PayNowFont.standard16;
        model.keyColor = HDAppTheme.PayNowColor.c333333;

        model.valueFont = [HDAppTheme.PayNowFont fontDINBold:17];
        model.valueColor = HDAppTheme.PayNowColor.mainThemeColor;

        model.contentEdgeInsets = UIEdgeInsetsMake(12, 12, 8, 12);
        model.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;

        model.lineWidth = 1;

        view.model = model;
        _payUsdBalanceInfoView = view;
        _payUsdBalanceInfoView.hidden = YES;
    }
    return _payUsdBalanceInfoView;
}

- (PNInfoView *)payKhrBalanceInfoView {
    if (!_payKhrBalanceInfoView) {
        PNInfoView *view = PNInfoView.new;

        PNInfoViewModel *model = PNInfoViewModel.new;

        model.keyText = PNLocalizedString(@"u2mfN9xc", @"KHR账户");
        model.keyFont = HDAppTheme.PayNowFont.standard16;
        model.keyColor = HDAppTheme.PayNowColor.c333333;

        model.valueFont = [HDAppTheme.PayNowFont fontDINBold:17];
        model.valueColor = HDAppTheme.PayNowColor.mainThemeColor;

        model.contentEdgeInsets = UIEdgeInsetsMake(12, 12, 8, 12);
        model.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;

        model.lineWidth = 1;

        view.model = model;
        _payKhrBalanceInfoView = view;
        _payKhrBalanceInfoView.hidden = YES;
    }
    return _payKhrBalanceInfoView;
}

- (SALabel *)tipsLabel {
    if (!_tipsLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.mainThemeColor;
        label.font = HDAppTheme.PayNowFont.standard18B;
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.hidden = YES;

        _tipsLabel = label;
    }
    return _tipsLabel;
}

@end
