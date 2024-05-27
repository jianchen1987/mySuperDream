//
//  PNWalletBalanceCell.m
//  SuperApp
//
//  Created by xixi_wen on 2023/2/2.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNWalletBalanceCell.h"
#import "PNWalletAcountModel.h"
#import <YYLabel.h>


@interface PNWalletBalanceCell ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) UIImageView *wownowIconImgView;
@property (nonatomic, strong) HDUIButton *detailBtn;
@property (nonatomic, strong) UIView *customerBgView;
@property (nonatomic, strong) SALabel *customerNoLabel;
@property (nonatomic, strong) HDUIButton *cpBtn;
@property (nonatomic, strong) UIImageView *usdIconImgView;
@property (nonatomic, strong) YYLabel *usdBalanceLabel;
@property (nonatomic, strong) SALabel *usdNonCashBalanceLabel;
@property (nonatomic, strong) HDUIButton *usdNonCashBalanceDesBtn;
@property (nonatomic, strong) UIImageView *khrIconImgView;
@property (nonatomic, strong) YYLabel *khrBalanceLabel;
@property (nonatomic, strong) SALabel *khrNonCashBalanceLabel;
@property (nonatomic, strong) HDUIButton *khrNonCashBalanceDesBtn;
@property (nonatomic, strong) UIImageView *coolcashImgView;
@end


@implementation PNWalletBalanceCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.bgImgView];
    [self.bgView addSubview:self.wownowIconImgView];
    [self.bgView addSubview:self.detailBtn];

    [self.bgView addSubview:self.customerBgView];
    [self.customerBgView addSubview:self.customerNoLabel];
    [self.customerBgView addSubview:self.cpBtn];

    [self.bgView addSubview:self.usdIconImgView];
    [self.bgView addSubview:self.usdBalanceLabel];
    [self.bgView addSubview:self.usdNonCashBalanceLabel];
    [self.bgView addSubview:self.usdNonCashBalanceDesBtn];

    [self.bgView addSubview:self.khrIconImgView];
    [self.bgView addSubview:self.khrBalanceLabel];
    [self.bgView addSubview:self.khrNonCashBalanceLabel];
    [self.bgView addSubview:self.khrNonCashBalanceDesBtn];

    [self.bgView addSubview:self.coolcashImgView];
}

- (void)updateConstraints {
    [super updateConstraints];

    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(kRealWidth(12));
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kRealWidth(12));
        make.top.mas_equalTo(self.contentView.mas_top);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-kRealWidth(12));
    }];

    [self.bgImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgView);
    }];

    [self.wownowIconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(12));
        make.top.mas_equalTo(self.bgView.mas_top).offset(kRealWidth(12));
        make.width.mas_equalTo(self.wownowIconImgView.image.size.width * 0.35);
        make.height.mas_equalTo(self.wownowIconImgView.image.size.height * 0.35);
    }];

    [self.detailBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bgView.mas_right).offset(-kRealWidth(12));
        //        make.top.mas_equalTo(self.bgView.mas_top);
        make.centerY.mas_equalTo(self.customerNoLabel.mas_centerY);
    }];

    [self.customerBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgView.mas_centerX);
        make.centerY.mas_equalTo(self.wownowIconImgView.mas_centerY);
    }];

    [self.customerNoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.mas_equalTo(self.customerBgView);
    }];

    [self.cpBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.customerBgView.mas_right);
        make.top.bottom.equalTo(self.customerBgView);
        make.left.mas_equalTo(self.customerNoLabel.mas_right).offset(kRealWidth(12));
    }];

    [self.usdIconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.usdIconImgView.image.size);
        make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(12));
        make.top.mas_equalTo(self.customerBgView.mas_bottom).offset(kRealWidth(26));
    }];

    [self.khrIconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.khrIconImgView.image.size);
        make.left.equalTo(self.usdIconImgView.mas_left);
        make.top.mas_equalTo(self.usdIconImgView.mas_bottom).offset(kRealWidth(26));
    }];

    [self.usdBalanceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.usdIconImgView.mas_right).offset(kRealWidth(12));
        make.top.mas_equalTo(self.usdIconImgView.mas_top);
    }];

    [self.usdNonCashBalanceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bgView.mas_right).offset(-kRealWidth(12));
        make.top.mas_equalTo(self.usdBalanceLabel.mas_bottom).offset(kRealWidth(8));
    }];

    [self.usdNonCashBalanceDesBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.usdNonCashBalanceLabel.mas_left);
        make.centerY.mas_equalTo(self.usdNonCashBalanceLabel.mas_centerY);
    }];

    [self.khrBalanceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.khrIconImgView.mas_right).offset(kRealWidth(12));
        make.top.mas_equalTo(self.khrIconImgView.mas_top);
    }];

    [self.khrNonCashBalanceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.usdNonCashBalanceLabel.mas_right);
        make.top.mas_equalTo(self.khrBalanceLabel.mas_bottom).offset(kRealWidth(8));
    }];

    [self.khrNonCashBalanceDesBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.khrNonCashBalanceLabel.mas_left);
        make.centerY.mas_equalTo(self.khrNonCashBalanceLabel.mas_centerY);
    }];

    [self.coolcashImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bgView.mas_right).offset(-kRealWidth(12));
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-kRealWidth(12));
        make.width.mas_equalTo(self.coolcashImgView.image.size.width * 0.35);
        make.height.mas_equalTo(self.coolcashImgView.image.size.height * 0.35);
    }];
}

#pragma mark
- (void)setModel:(PNWalletAcountModel *)model {
    _model = model;

    self.detailBtn.hidden = ![VipayUser hasWalletOrder];

    self.customerNoLabel.text = [NSString stringWithFormat:@"%@: %@", PNLocalizedString(@"TF_TITLE_LOGINNAME", @"账号"), VipayUser.shareInstance.customerNo ?: @""];

    NSMutableAttributedString *usdAttrStr = [[NSMutableAttributedString alloc] initWithString:self.model.USD.balance.thousandSeparatorAmount];
    usdAttrStr.yy_font = [HDAppTheme.PayNowFont fontDINBold:18];
    usdAttrStr.yy_underlineStyle = NSUnderlineStyleSingle;
    usdAttrStr.yy_underlineColor = HDAppTheme.PayNowColor.cFFFFFF;
    [usdAttrStr yy_setTextHighlightRange:usdAttrStr.yy_rangeOfAll color:HDAppTheme.PayNowColor.cFFFFFF backgroundColor:[UIColor clearColor]
                               tapAction:^(UIView *_Nonnull containerView, NSAttributedString *_Nonnull text, NSRange range, CGRect rect) {
                                   [self goToWalletOrderList:PNCurrencyTypeUSD];
                               }];

    self.usdBalanceLabel.attributedText = usdAttrStr;
    self.usdNonCashBalanceLabel.text = [NSString stringWithFormat:@"%@: %@", PNLocalizedString(@"Non_withdrawable_balance", @"不可提现余额"), self.model.USD.nonCashBalance.thousandSeparatorAmount];

    NSMutableAttributedString *khrAttrStr = [[NSMutableAttributedString alloc] initWithString:self.model.KHR.balance.thousandSeparatorAmount];
    khrAttrStr.yy_font = [HDAppTheme.PayNowFont fontDINBold:18];
    khrAttrStr.yy_underlineStyle = NSUnderlineStyleSingle;
    khrAttrStr.yy_underlineColor = HDAppTheme.PayNowColor.cFFFFFF;
    [khrAttrStr yy_setTextHighlightRange:khrAttrStr.yy_rangeOfAll color:HDAppTheme.PayNowColor.cFFFFFF backgroundColor:[UIColor clearColor]
                               tapAction:^(UIView *_Nonnull containerView, NSAttributedString *_Nonnull text, NSRange range, CGRect rect) {
                                   [self goToWalletOrderList:PNCurrencyTypeKHR];
                               }];

    self.khrBalanceLabel.attributedText = khrAttrStr;
    self.khrBalanceLabel.text = self.model.KHR.balance.thousandSeparatorAmount;
    self.khrNonCashBalanceLabel.text = [NSString stringWithFormat:@"%@: %@", PNLocalizedString(@"Non_withdrawable_balance", @"不可提现余额"), self.model.KHR.nonCashBalance.thousandSeparatorAmount];

    [self setNeedsUpdateConstraints];
}

- (void)goToWalletOrderList:(PNCurrencyType)type {
    if ([VipayUser hasWalletOrder]) {
        [HDMediator.sharedInstance navigaveToWalletOrderListVC:@{
            @"currency": type,
        }];
    }
}

#pragma mark
- (void)showDesAlert {
    [NAT showAlertWithTitle:PNLocalizedString(@"What_is_a_non_withdrawable_balance", @"") message:PNLocalizedString(@"What_is_a_non_withdrawable_balance_des", @"")
                buttonTitle:SALocalizedString(@"i_know", @"我知道了") handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                    [alertView dismiss];
                }];
}

#pragma mark
- (UIView *)bgView {
    if (!_bgView) {
        UIView *view = [[UIView alloc] init];
        //        view.backgroundColor = HDAppTheme.PayNowColor.mainThemeColor;
        view.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(10)];
        };
        _bgView = view;
    }
    return _bgView;
}

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"pn_wallet_balance_bg"];
        _bgImgView = imageView;
    }
    return _bgImgView;
}

- (UIImageView *)wownowIconImgView {
    if (!_wownowIconImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"pn_wownow_logo"];
        _wownowIconImgView = imageView;
    }
    return _wownowIconImgView;
}

- (HDUIButton *)detailBtn {
    if (!_detailBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsButtonWhenHighlighted = false;
        [button setImage:[UIImage imageNamed:@"pn_record_white"] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 5);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [self goToWalletOrderList:@""];
        }];

        _detailBtn = button;
    }
    return _detailBtn;
}

- (UIView *)customerBgView {
    if (!_customerBgView) {
        UIView *view = [[UIView alloc] init];
        _customerBgView = view;
    }
    return _customerBgView;
}

- (SALabel *)customerNoLabel {
    if (!_customerNoLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.cFFFFFF;
        label.font = HDAppTheme.PayNowFont.standard14M;
        _customerNoLabel = label;
    }
    return _customerNoLabel;
}

- (HDUIButton *)cpBtn {
    if (!_cpBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"pn_copy_white"] forState:UIControlStateNormal];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard14;
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = VipayUser.shareInstance.customerNo ?: @"";
            [NAT showToastWithTitle:nil content:PNLocalizedString(@"pn_copy_success", @"复制成功") type:HDTopToastTypeSuccess];
        }];

        _cpBtn = button;
    }
    return _cpBtn;
}

- (UIImageView *)usdIconImgView {
    if (!_usdIconImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"ic_english"];
        _usdIconImgView = imageView;
    }
    return _usdIconImgView;
}

- (UIImageView *)khrIconImgView {
    if (!_khrIconImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"ic-khmer"];
        _khrIconImgView = imageView;
    }
    return _khrIconImgView;
}

- (YYLabel *)usdBalanceLabel {
    if (!_usdBalanceLabel) {
        YYLabel *label = [[YYLabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.cFFFFFF;
        label.font = [HDAppTheme.PayNowFont fontDINBold:18];
        _usdBalanceLabel = label;
    }
    return _usdBalanceLabel;
}

- (SALabel *)usdNonCashBalanceLabel {
    if (!_usdNonCashBalanceLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.cFFFFFF;
        label.font = [HDAppTheme.PayNowFont fontDINMedium:14];
        _usdNonCashBalanceLabel = label;
    }
    return _usdNonCashBalanceLabel;
}

- (HDUIButton *)usdNonCashBalanceDesBtn {
    if (!_usdNonCashBalanceDesBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsButtonWhenHighlighted = false;
        [button setImage:[UIImage imageNamed:@"explain"] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 5);

        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self showDesAlert];
        }];

        _usdNonCashBalanceDesBtn = button;
    }
    return _usdNonCashBalanceDesBtn;
}

- (YYLabel *)khrBalanceLabel {
    if (!_khrBalanceLabel) {
        YYLabel *label = [[YYLabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.cFFFFFF;
        label.font = [HDAppTheme.PayNowFont fontDINBold:18];
        _khrBalanceLabel = label;
    }
    return _khrBalanceLabel;
}

- (SALabel *)khrNonCashBalanceLabel {
    if (!_khrNonCashBalanceLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.cFFFFFF;
        label.font = [HDAppTheme.PayNowFont fontDINMedium:14];
        _khrNonCashBalanceLabel = label;
    }
    return _khrNonCashBalanceLabel;
}

- (HDUIButton *)khrNonCashBalanceDesBtn {
    if (!_khrNonCashBalanceDesBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsButtonWhenHighlighted = false;
        [button setImage:[UIImage imageNamed:@"explain"] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 5);
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self showDesAlert];
        }];

        _khrNonCashBalanceDesBtn = button;
    }
    return _khrNonCashBalanceDesBtn;
}

- (UIImageView *)coolcashImgView {
    if (!_coolcashImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"pn_coolcash_logo"];
        _coolcashImgView = imageView;
    }
    return _coolcashImgView;
}
@end
