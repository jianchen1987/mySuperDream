//
//  PNOpenPaymentCodeView.m
//  SuperApp
//
//  Created by xixi_wen on 2021/12/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNOpenPaymentCodeView.h"


@interface PNOpenPaymentCodeView ()
@property (nonatomic, strong) UIImageView *topLeftIcon;
@property (nonatomic, strong) SALabel *topTitle;
@property (nonatomic, strong) UIImageView *merchantLogoImgView;
@property (nonatomic, strong) SALabel *tipsLabel;
@property (nonatomic, strong) SALabel *openTipsLabel;
@property (nonatomic, strong) HDUIButton *enableBtn;
@property (nonatomic, strong) HDUIButton *unEnableBtn;
@property (nonatomic, strong) HDUIButton *openNowBtn;
@property (nonatomic, strong) SALabel *enableTipsLabel;
@property (nonatomic, assign) BOOL selectFlag;
@end


@implementation PNOpenPaymentCodeView

- (void)hd_setupViews {
    [self addSubview:self.topLeftIcon];
    [self addSubview:self.topTitle];
    [self addSubview:self.merchantLogoImgView];
    [self addSubview:self.tipsLabel];
    [self addSubview:self.openTipsLabel];
    [self addSubview:self.enableBtn];
    [self addSubview:self.unEnableBtn];
    [self addSubview:self.enableTipsLabel];
    [self addSubview:self.openNowBtn];

    [self selectAction:self.enableBtn];
}

- (void)updateConstraints {
    [self.topLeftIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(15));
        make.top.mas_equalTo(self.mas_top).offset(kRealWidth(20));
        make.size.mas_equalTo(self.topLeftIcon.image.size);
    }];
    [self.topTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topLeftIcon.mas_right).offset(kRealWidth(10));
        make.centerY.mas_equalTo(self.topLeftIcon.mas_centerY);
        make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-15));
    }];
    [self.merchantLogoImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).offset(kRealWidth(104));
        //        make.size.mas_equalTo(self.merchantLogoImgView.image.size);
        make.size.mas_equalTo(@(CGSizeMake(kRealWidth(50), kRealWidth(50))));
    }];
    [self.tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(45));
        make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-45));
        make.top.mas_equalTo(self.merchantLogoImgView.mas_bottom).offset(kRealWidth(25));
    }];
    [self.openTipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(45));
        make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-45));
        make.top.mas_equalTo(self.tipsLabel.mas_bottom).offset(kRealWidth(30));
    }];

    [self.enableBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(45));
        make.top.mas_equalTo(self.openTipsLabel.mas_bottom).offset(kRealWidth(15));
    }];

    [self.unEnableBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.enableBtn.mas_right).offset(kRealWidth(20));
        make.top.mas_equalTo(self.enableBtn.mas_top);
    }];

    [self.enableTipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(45));
        make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-45));
        make.top.mas_equalTo(self.enableBtn.mas_bottom).offset(kRealWidth(5));
    }];

    [self.openNowBtn sizeToFit];
    [self.openNowBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.equalTo(@(self.openNowBtn.width + kRealWidth(30)));
        make.height.equalTo(@(kRealWidth(50)));
        make.bottom.mas_equalTo(self.mas_bottom).offset(kRealWidth(-25));
        make.top.mas_equalTo(self.enableBtn.mas_bottom).offset(kRealWidth(88));
    }];

    [super updateConstraints];
}

#pragma mark
- (void)selectAction:(UIButton *)btn {
    if (btn.tag == 100) {
        self.selectFlag = YES;
        [self.enableBtn setImage:[UIImage imageNamed:@"pay_checked"] forState:0];
        [self.unEnableBtn setImage:[UIImage imageNamed:@"pay_Unchecked"] forState:0];
    } else {
        self.selectFlag = NO;
        [self.enableBtn setImage:[UIImage imageNamed:@"pay_Unchecked"] forState:0];
        [self.unEnableBtn setImage:[UIImage imageNamed:@"pay_checked"] forState:0];
    }
}

#pragma mark
- (UIImageView *)topLeftIcon {
    if (!_topLeftIcon) {
        _topLeftIcon = [[UIImageView alloc] init];
        _topLeftIcon.image = [UIImage imageNamed:@"pn_paycode_icon"];
    }
    return _topLeftIcon;
}

- (SALabel *)topTitle {
    if (!_topTitle) {
        _topTitle = [[SALabel alloc] init];
        _topTitle.textColor = HDAppTheme.PayNowColor.cFD7127;
        _topTitle.font = HDAppTheme.PayNowFont.standard15;
        _topTitle.text = PNLocalizedString(@"make_payment_to_merchant", @"向商家付款");
    }
    return _topTitle;
}

- (UIImageView *)merchantLogoImgView {
    if (!_merchantLogoImgView) {
        _merchantLogoImgView = [[UIImageView alloc] init];
        _merchantLogoImgView.image = [UIImage imageNamed:@"CoolCash"];
    }
    return _merchantLogoImgView;
}

- (SALabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[SALabel alloc] init];
        _tipsLabel.textColor = HDAppTheme.PayNowColor.c343B4D;
        _tipsLabel.font = HDAppTheme.PayNowFont.standard15;
        _tipsLabel.text = PNLocalizedString(@"after_show_code", @"开启后向商家出示付款码，即可付款。");
        _tipsLabel.numberOfLines = 0;
    }
    return _tipsLabel;
}

- (SALabel *)openTipsLabel {
    if (!_openTipsLabel) {
        _openTipsLabel = [[SALabel alloc] init];
        _openTipsLabel.textColor = HDAppTheme.PayNowColor.c343B4D;
        _openTipsLabel.font = HDAppTheme.PayNowFont.standard15;
        _openTipsLabel.text = PNLocalizedString(@"sure_open_one_set_payment", @"是否开通免密支付：");
        _openTipsLabel.numberOfLines = 0;
    }
    return _openTipsLabel;
}

- (HDUIButton *)enableBtn {
    if (!_enableBtn) {
        _enableBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_enableBtn setTitle:PNLocalizedString(@"Select_Yes", @"是") forState:0];
        [_enableBtn setTitleColor:HDAppTheme.PayNowColor.c343B4D forState:0];
        _enableBtn.titleLabel.font = HDAppTheme.PayNowFont.standard15;
        [_enableBtn setImage:[UIImage imageNamed:@"pay_Unchecked"] forState:0];
        _enableBtn.spacingBetweenImageAndTitle = kRealWidth(5);
        _enableBtn.tag = 100;
        @HDWeakify(self);
        [_enableBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            HDLog(@"click");
            [self selectAction:btn];
        }];

        _enableBtn.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(7)];
        };
    }
    return _enableBtn;
}

- (HDUIButton *)unEnableBtn {
    if (!_unEnableBtn) {
        _unEnableBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_unEnableBtn setTitle:PNLocalizedString(@"Select_NO", @"否") forState:0];
        [_unEnableBtn setTitleColor:HDAppTheme.PayNowColor.c343B4D forState:0];
        _unEnableBtn.titleLabel.font = HDAppTheme.PayNowFont.standard15;
        [_unEnableBtn setImage:[UIImage imageNamed:@"pay_Unchecked"] forState:0];
        _unEnableBtn.spacingBetweenImageAndTitle = kRealWidth(5);
        _unEnableBtn.tag = 200;
        @HDWeakify(self);
        [_unEnableBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self selectAction:btn];
        }];

        _unEnableBtn.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(7)];
        };
    }
    return _unEnableBtn;
}

- (SALabel *)enableTipsLabel {
    if (!_enableTipsLabel) {
        _enableTipsLabel = [[SALabel alloc] init];
        _enableTipsLabel.textColor = [HDAppTheme.PayNowColor.c343B4D colorWithAlphaComponent:0.6];
        _enableTipsLabel.font = HDAppTheme.PayNowFont.standard12;
        _enableTipsLabel.numberOfLines = 0;
        _enableTipsLabel.text = PNLocalizedString(@"enable_tips", @"(即每次打开付款码支付，无需输入支付密码)");
    }
    return _enableTipsLabel;
}

- (HDUIButton *)openNowBtn {
    if (!_openNowBtn) {
        _openNowBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_openNowBtn setTitle:PNLocalizedString(@"Confirm_Open", @"确认开启") forState:0];
        _openNowBtn.backgroundColor = HDAppTheme.PayNowColor.cFD7127;
        [_openNowBtn setTitleColor:HDAppTheme.PayNowColor.cFFFFFF forState:0];
        _openNowBtn.titleLabel.font = HDAppTheme.PayNowFont.standard15;
        @HDWeakify(self);
        [_openNowBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.secretFlagBlock ?: self.secretFlagBlock(self.selectFlag);
        }];

        _openNowBtn.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(7)];
        };
    }
    return _openNowBtn;
}

@end
