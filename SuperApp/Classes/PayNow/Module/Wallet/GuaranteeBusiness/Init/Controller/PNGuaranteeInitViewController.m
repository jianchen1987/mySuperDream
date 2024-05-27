//
//  PNGuaranteeInitViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2023/1/6.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNGuaranteeInitViewController.h"


@interface PNGuaranteeInitViewController ()
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) HDUIButton *salerBtn;
@property (nonatomic, strong) HDUIButton *buyerBtn;

@property (nonatomic, strong) SALabel *label1;
@property (nonatomic, strong) SALabel *label2;
@end


@implementation PNGuaranteeInitViewController

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"aEvpZcFf", @"发起交易");
    self.hd_navTitleColor = HDAppTheme.PayNowColor.c333333;
    self.hd_backButtonImage = [UIImage imageNamed:@"pn_icon_back_black"];
}

- (void)hd_getNewData {
    [self setHd_statusBarStyle:UIStatusBarStyleDefault];
}

- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleTransparent;
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return YES;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (void)hd_setupViews {
    self.view.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self.view addSubview:self.scrollView];
    self.scrollView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self.scrollView addSubview:self.scrollViewContainer];

    [self.scrollViewContainer addSubview:self.iconImgView];
    [self.scrollViewContainer addSubview:self.salerBtn];
    [self.scrollViewContainer addSubview:self.buyerBtn];
    [self.scrollViewContainer addSubview:self.label1];
    [self.scrollViewContainer addSubview:self.label2];
}

- (void)updateViewConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.width.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    [self.iconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.iconImgView.image.size);
        make.top.mas_equalTo(self.scrollViewContainer.mas_top).offset(kRealWidth(37));
        make.centerX.mas_equalTo(self.scrollViewContainer.mas_centerX);
    }];

    [self.salerBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(40));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(40));
        make.top.mas_equalTo(self.iconImgView.mas_bottom).offset(kRealWidth(60));
    }];

    [self.buyerBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.salerBtn);
        make.top.mas_equalTo(self.salerBtn.mas_bottom).offset(kRealWidth(12));
    }];

    [self.label1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.buyerBtn);
        make.top.mas_equalTo(self.buyerBtn.mas_bottom).offset(kRealWidth(40));
    }];

    [self.label2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.label1);
        make.top.mas_equalTo(self.label1.mas_bottom).offset(kRealWidth(4));
        make.bottom.mas_equalTo(self.scrollViewContainer.mas_bottom).offset(-kRealWidth(50));
    }];

    [super updateViewConstraints];
}

#pragma mark
- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"pn_guarantee_init_root"];
        _iconImgView = imageView;
    }
    return _iconImgView;
}

- (HDUIButton *)salerBtn {
    if (!_salerBtn) {
        HDUIButton *btn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:PNLocalizedString(@"oVwpPGHd", @"我是卖方") forState:UIControlStateNormal];
        btn.layer.cornerRadius = kRealWidth(4);
        btn.backgroundColor = HDAppTheme.PayNowColor.mainThemeColor;
        btn.titleLabel.font = HDAppTheme.PayNowFont.standard16M;
        [btn setTitleColor:HDAppTheme.PayNowColor.cFFFFFF forState:UIControlStateNormal];
        btn.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(16), kRealWidth(15), kRealWidth(16), kRealWidth(15));

        _salerBtn = btn;

        [_salerBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [HDMediator.sharedInstance navigaveToPayNowGuaranteeSalerInitVC:@{}];
        }];
    }
    return _salerBtn;
}

- (HDUIButton *)buyerBtn {
    if (!_buyerBtn) {
        HDUIButton *btn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:PNLocalizedString(@"fgQEHc8b", @"我是买方") forState:UIControlStateNormal];
        btn.layer.cornerRadius = kRealWidth(4);
        btn.layer.borderColor = HDAppTheme.PayNowColor.c333333.CGColor;
        btn.layer.borderWidth = PixelOne;
        btn.titleLabel.font = HDAppTheme.PayNowFont.standard16M;
        [btn setTitleColor:HDAppTheme.PayNowColor.c333333 forState:UIControlStateNormal];
        btn.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(16), kRealWidth(15), kRealWidth(16), kRealWidth(15));

        _buyerBtn = btn;

        [_buyerBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [HDMediator.sharedInstance navigaveToPayNowGuaranteeBuyerInitVC:@{}];
        }];
    }
    return _buyerBtn;
}

- (SALabel *)label1 {
    if (!_label1) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard11;
        label.text = PNLocalizedString(@"cUPRpTWC", @"说明：");
        _label1 = label;
    }
    return _label1;
}

- (SALabel *)label2 {
    if (!_label2) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c999999;
        label.font = HDAppTheme.PayNowFont.standard11;
        label.numberOfLines = 0;
        label.hd_lineSpace = 5;
        label.text = PNLocalizedString(@"X0waVGy0", @"1、我要收款可点击【我是卖方】，发起交易分享给买方付款\n2、我要付款可点击【我是买方】，向收款方发起交易并付款");
        _label2 = label;
    }
    return _label2;
}

@end
