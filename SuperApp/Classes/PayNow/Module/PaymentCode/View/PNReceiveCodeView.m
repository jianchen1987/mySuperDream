//
//  PNReceiveView.m
//  SuperApp
//
//  Created by xixi_wen on 2021/12/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNReceiveCodeView.h"
#import "NSMutableAttributedString+Highlight.h"
#import "PNCommonUtils.h"
#import "PNQRCodeModel.h"
#import "UIImage+PNExtension.h"


@interface PNReceiveCodeView ()
@property (nonatomic, strong) UIView *topBgView;
@property (nonatomic, strong) UIImageView *topTitleImgView;
@property (nonatomic, strong) UIImageView *rightIconImgView;
@property (nonatomic, strong) SALabel *merchantNameLabel;
@property (nonatomic, strong) SALabel *moneyLabel;
@property (nonatomic, strong) UIView *line1; //扫描二维码，向我付款  这个title下面这条线
@property (nonatomic, strong) UIImageView *qrCodeImgView;

@property (nonatomic, strong) UIView *centerBgView;
@property (nonatomic, strong) HDUIButton *setMoneyButton;
@property (nonatomic, strong) UIView *line2; //设置金额 和 保存二维码 之间的那条线
@property (nonatomic, strong) HDUIButton *saveQRCodeButton;
@property (nonatomic, strong) SALabel *limitLabel;

@property (nonatomic, strong) UIView *downBgView;
@property (nonatomic, strong) UIImageView *downIconImgView;
@property (nonatomic, strong) SALabel *downTitleLabel;
@property (nonatomic, strong) UIImageView *downArrowImgView;
@property (nonatomic, strong) HDUIButton *downActionClickButton;

@property (nonatomic, strong) UIView *recordBgView;
@property (nonatomic, strong) UIImageView *recordIconImgView;
@property (nonatomic, strong) SALabel *recordTitleLabel;
@property (nonatomic, strong) UIImageView *recordArrowImgView;
@property (nonatomic, strong) HDUIButton *recordActionClickButton;

@property (nonatomic, strong) UIView *disclaimerBgView;
@property (nonatomic, strong) UIImageView *disclaimerIconImgView;
@property (nonatomic, strong) SALabel *disclaimerTitleLabel;
@property (nonatomic, strong) UIImageView *disclaimerArrowImgView;
@property (nonatomic, strong) HDUIButton *disclaimerActionClickButton;

@end


@implementation PNReceiveCodeView

- (void)hd_setupViews {
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
    self.scrollView.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;

    [self.scrollViewContainer addSubview:self.bgView];
    [self.bgView addSubview:self.topBgView];
    [self.topBgView addSubview:self.topTitleImgView];
    [self.bgView addSubview:self.rightIconImgView];
    [self.bgView addSubview:self.merchantNameLabel];
    [self.bgView addSubview:self.moneyLabel];

    [self.bgView addSubview:self.line1];
    [self.bgView addSubview:self.qrCodeImgView];

    [self.scrollViewContainer addSubview:self.centerBgView];
    [self.centerBgView addSubview:self.setMoneyButton];
    [self.centerBgView addSubview:self.saveQRCodeButton];
    [self.centerBgView addSubview:self.line2];

    [self.scrollViewContainer addSubview:self.limitLabel];

    [self.scrollViewContainer addSubview:self.downBgView];
    [self.downBgView addSubview:self.downIconImgView];
    [self.downBgView addSubview:self.downTitleLabel];
    [self.downBgView addSubview:self.downArrowImgView];
    [self.downBgView addSubview:self.downActionClickButton];

    [self.scrollViewContainer addSubview:self.recordBgView];
    [self.recordBgView addSubview:self.recordIconImgView];
    [self.recordBgView addSubview:self.recordTitleLabel];
    [self.recordBgView addSubview:self.recordArrowImgView];
    [self.recordBgView addSubview:self.recordActionClickButton];

    [self.scrollViewContainer addSubview:self.disclaimerBgView];
    [self.disclaimerBgView addSubview:self.disclaimerIconImgView];
    [self.disclaimerBgView addSubview:self.disclaimerTitleLabel];
    [self.disclaimerBgView addSubview:self.disclaimerArrowImgView];
    [self.disclaimerBgView addSubview:self.disclaimerActionClickButton];

    [self.bgView bringSubviewToFront:self.setMoneyButton];
    [self.bgView bringSubviewToFront:self.saveQRCodeButton];

    //    [self getFontNames];
}

//- (void)getFontNames
//{
//    NSArray *familyNames = [UIFont familyNames];
//
//    for (NSString *familyName in familyNames) {
//        HDLog(@"familyNames = %s\n",[familyName UTF8String]);
//
//        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
//
//        for (NSString *fontName in fontNames) {
//            HDLog(@"\tfontName = %s\n",[fontName UTF8String]);
//        }
//    }
//}

- (void)updateConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.width.equalTo(self);
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(kRealWidth(-15));
        make.top.mas_equalTo(self.scrollViewContainer.mas_top).offset(kRealWidth(20));
    }];

    [self.topTitleImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.topTitleImgView.image.size);
        make.centerX.equalTo(self.topBgView);
        make.top.mas_equalTo(self.topBgView.mas_top).offset(kRealWidth(15));
        make.bottom.mas_equalTo(self.topBgView.mas_bottom).offset(kRealWidth(-15));
    }];

    [self.topBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.bgView);
    }];

    [self.rightIconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.rightIconImgView.image.size);
        make.right.mas_equalTo(self.topBgView.mas_right);
        make.top.mas_equalTo(self.topBgView.mas_bottom);
    }];

    [self.merchantNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(48));
        make.right.mas_equalTo(self.bgView.mas_right).offset(kRealWidth(-48));
        make.top.mas_equalTo(self.rightIconImgView.mas_bottom);
    }];

    [self.moneyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(48));
        make.right.mas_equalTo(self.bgView.mas_right).offset(kRealWidth(-48));
        make.top.mas_equalTo(self.merchantNameLabel.mas_bottom);
    }];

    [self.line1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left);
        make.right.mas_equalTo(self.bgView.mas_right);
        make.height.equalTo(@(kRealWidth(1)));
        make.top.mas_equalTo(self.moneyLabel.mas_bottom).offset(kRealWidth(25));
    }];

    CGFloat qrCodeWidth = kScreenWidth - kRealWidth(96) - kRealWidth(30);
    self.qrCodeImgView.image = [UIImage imageQRCodeContent:self.model.qrCode withSize:qrCodeWidth];
    [self.qrCodeImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line1.mas_bottom).offset(kRealWidth(35));
        make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(45));
        make.right.mas_equalTo(self.bgView.mas_right).offset(kRealWidth(-45));
        make.width.height.equalTo(@(qrCodeWidth));
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(kRealWidth(-35));
    }];

    [self.centerBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(kRealWidth(-15));
        make.top.mas_equalTo(self.bgView.mas_bottom).offset(kRealWidth(15));
    }];

    [self.setMoneyButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.centerBgView.mas_left);
        make.right.mas_equalTo(self.centerBgView.mas_centerX).offset(kRealWidth(-5));
        make.top.mas_equalTo(self.centerBgView.mas_top).offset(kRealWidth(15));
        make.bottom.mas_equalTo(self.centerBgView.mas_bottom).offset(kRealWidth(-15));
    }];

    [self.saveQRCodeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.centerBgView.mas_centerX).offset(kRealWidth(5));
        make.right.mas_equalTo(self.centerBgView.mas_right);
        make.centerY.mas_equalTo(self.setMoneyButton.mas_centerY);
    }];

    [self.line2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(1));
        make.height.equalTo(@(20));
        make.center.equalTo(self.centerBgView);
    }];

    [self.limitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.top.mas_equalTo(self.centerBgView.mas_bottom).offset(kRealWidth(10));
    }];

    // --
    UIView *preView = self.limitLabel;
    if (!self.downBgView.hidden) {
        preView = self.downBgView;
        [self.downBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
            make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(kRealWidth(-15));
            make.top.mas_equalTo(self.limitLabel.mas_bottom).offset(kRealWidth(15));
            make.height.equalTo(@(kRealWidth(50)));
        }];

        [self.downIconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.downIconImgView.image.size);
            make.left.mas_equalTo(self.downBgView.mas_left).offset(kRealWidth(15));
            make.centerY.mas_equalTo(self.downBgView.mas_centerY);
        }];

        [self.downArrowImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.downArrowImgView.image.size);
            make.right.mas_equalTo(self.downBgView.mas_right).offset(kRealWidth(-15));
            make.centerY.mas_equalTo(self.downBgView.mas_centerY);
        }];

        [self.downTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.downIconImgView.mas_right).offset(kRealWidth(15));
            make.right.mas_equalTo(self.downArrowImgView.mas_left).offset(kRealWidth(-15));
            make.centerY.mas_equalTo(self.downBgView.mas_centerY);
        }];

        [self.downActionClickButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(self.downBgView);
        }];
    }

    // --
    [self.disclaimerBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(kRealWidth(-15));
        make.top.mas_equalTo(preView.mas_bottom).offset(kRealWidth(15));
        make.height.equalTo(@(kRealWidth(50)));
    }];

    [self.disclaimerIconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.disclaimerIconImgView.image.size);
        make.left.mas_equalTo(self.disclaimerBgView.mas_left).offset(kRealWidth(15));
        make.centerY.mas_equalTo(self.disclaimerBgView.mas_centerY);
    }];

    [self.disclaimerArrowImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.disclaimerArrowImgView.image.size);
        make.right.mas_equalTo(self.disclaimerBgView.mas_right).offset(kRealWidth(-15));
        make.centerY.mas_equalTo(self.disclaimerBgView.mas_centerY);
    }];

    [self.disclaimerTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.disclaimerIconImgView.mas_right).offset(kRealWidth(15));
        make.right.mas_equalTo(self.disclaimerArrowImgView.mas_left).offset(kRealWidth(-15));
        make.centerY.mas_equalTo(self.disclaimerBgView.mas_centerY);
    }];

    [self.disclaimerActionClickButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(self.disclaimerBgView);
    }];

    // --
    [self.recordBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.scrollViewContainer.mas_right).offset(kRealWidth(-15));
        make.top.mas_equalTo(self.disclaimerBgView.mas_bottom).offset(kRealWidth(15));
        make.height.equalTo(@(kRealWidth(50)));
        make.bottom.mas_equalTo(self.scrollViewContainer.mas_bottom).offset(kRealWidth(-20));
    }];

    [self.recordIconImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.recordIconImgView.image.size);
        make.left.mas_equalTo(self.recordBgView.mas_left).offset(kRealWidth(15));
        make.centerY.mas_equalTo(self.recordBgView.mas_centerY);
    }];

    [self.recordArrowImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.recordArrowImgView.image.size);
        make.right.mas_equalTo(self.recordBgView.mas_right).offset(kRealWidth(-15));
        make.centerY.mas_equalTo(self.recordBgView.mas_centerY);
    }];

    [self.recordTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.recordIconImgView.mas_right).offset(kRealWidth(15));
        make.right.mas_equalTo(self.recordArrowImgView.mas_left).offset(kRealWidth(-15));
        make.centerY.mas_equalTo(self.recordBgView.mas_centerY);
    }];

    [self.recordActionClickButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(self.recordBgView);
    }];

    [super updateConstraints];
}

#pragma mark
- (void)setModel:(PNQRCodeModel *)model {
    _model = model;

    NSString *moneyStr = model.amount;
    if (moneyStr.doubleValue <= 0) {
        self.moneyLabel.text = model.currency;
    } else {
        if ([model.currency isEqualToString:PNCurrencyTypeKHR]) {
            moneyStr = [PNCommonUtils thousandSeparatorNoCurrencySymbolWithAmount:model.amount currencyCode:model.currency];
        }

        NSString *allStr = [NSString stringWithFormat:@"%@ %@", moneyStr, model.currency];
        self.moneyLabel.attributedText = [NSMutableAttributedString highLightString:moneyStr inWholeString:allStr highLightFont:[HDAppTheme.PayNowFont nunitoSansSemiBold:32]
                                                                     highLightColor:HDAppTheme.PayNowColor.c333333];
    }

    self.merchantNameLabel.text = self.model.payeeName;

    if (!WJIsObjectNil(self.model.usdLimit) || !WJIsObjectNil(self.model.khrLimit)) {
        self.limitLabel.text = [NSString stringWithFormat:@"%@ %@%@/%@%@",
                                                          PNLocalizedString(@"wallet_storage_limit", @"钱包收款限额"),
                                                          [PNCommonUtils thousandSeparatorNoCurrencySymbolWithAmount:self.model.usdLimit.amount currencyCode:self.model.usdLimit.cy],
                                                          self.model.usdLimit.cy,
                                                          [PNCommonUtils thousandSeparatorNoCurrencySymbolWithAmount:self.model.khrLimit.amount currencyCode:self.model.khrLimit.cy],
                                                          self.model.khrLimit.cy];

    } else {
        self.limitLabel.text = @"";
    }

    self.downBgView.hidden = self.model.isHideSaveBtn;

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        _bgView.layer.cornerRadius = kRealWidth(25);
        _bgView.layer.masksToBounds = YES;
        //        _bgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        //            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(10)];
        //        };
    }
    return _bgView;
}

- (UIView *)line1 {
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        _line1.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view drawDashLineWithlineLength:5 lineSpacing:3 lineColor:[UIColor hd_colorWithHexString:@"#818181"]];
        };
    }
    return _line1;
}

- (UIImageView *)qrCodeImgView {
    if (!_qrCodeImgView) {
        _qrCodeImgView = [[UIImageView alloc] init];
    }
    return _qrCodeImgView;
}

- (HDUIButton *)setMoneyButton {
    if (!_setMoneyButton) {
        _setMoneyButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_setMoneyButton setTitle:PNLocalizedString(@"set_amount", @"设置金额") forState:0];
        [_setMoneyButton setTitleColor:HDAppTheme.PayNowColor.c333333 forState:0];
        _setMoneyButton.titleLabel.font = HDAppTheme.PayNowFont.standard15;
        @HDWeakify(self);
        [_setMoneyButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.setAmountBlock ?: self.setAmountBlock();
        }];
    }
    return _setMoneyButton;
}

- (UIView *)line2 {
    if (!_line2) {
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = HDAppTheme.PayNowColor.lineColor;
    }
    return _line2;
}

- (HDUIButton *)saveQRCodeButton {
    if (!_saveQRCodeButton) {
        _saveQRCodeButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_saveQRCodeButton setTitle:PNLocalizedString(@"save_qr_code", @"保存二维码") forState:0];
        [_saveQRCodeButton setTitleColor:HDAppTheme.PayNowColor.c333333 forState:0];
        _saveQRCodeButton.titleLabel.font = HDAppTheme.PayNowFont.standard15;
        @HDWeakify(self);
        [_saveQRCodeButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.saveQRCodeBlock ?: self.saveQRCodeBlock();
        }];
    }
    return _saveQRCodeButton;
}

// ----
- (UIView *)downBgView {
    if (!_downBgView) {
        _downBgView = [[UIView alloc] init];
        _downBgView.hidden = YES;
        _downBgView.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        _downBgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(10)];
        };
    }
    return _downBgView;
}

- (UIImageView *)downIconImgView {
    if (!_downIconImgView) {
        _downIconImgView = [[UIImageView alloc] init];
        _downIconImgView.image = [UIImage imageNamed:@"pn_transaction_down_icon"];
    }
    return _downIconImgView;
}

- (SALabel *)downTitleLabel {
    if (!_downTitleLabel) {
        _downTitleLabel = [[SALabel alloc] init];
        _downTitleLabel.textColor = HDAppTheme.PayNowColor.c333333;
        _downTitleLabel.font = HDAppTheme.PayNowFont.standard15;
        _downTitleLabel.text = PNLocalizedString(@"down_recevie_qr_code", @"下载收款二维码");
    }
    return _downTitleLabel;
}

- (UIImageView *)downArrowImgView {
    if (!_downArrowImgView) {
        _downArrowImgView = [[UIImageView alloc] init];
        _downArrowImgView.image = [UIImage imageNamed:@"pn_arrow_gray_background"];
    }
    return _downArrowImgView;
}

- (HDUIButton *)downActionClickButton {
    if (!_downActionClickButton) {
        _downActionClickButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        @HDWeakify(self);
        [_downActionClickButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.downQRCodeBlock ?: self.downQRCodeBlock();
        }];
    }
    return _downActionClickButton;
}

//---------

- (UIView *)recordBgView {
    if (!_recordBgView) {
        _recordBgView = [[UIView alloc] init];
        _recordBgView.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        _recordBgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(10)];
        };
    }
    return _recordBgView;
}

- (UIImageView *)recordIconImgView {
    if (!_recordIconImgView) {
        _recordIconImgView = [[UIImageView alloc] init];
        _recordIconImgView.image = [UIImage imageNamed:@"pn_transaction_record_icon"];
    }
    return _recordIconImgView;
}

- (SALabel *)recordTitleLabel {
    if (!_recordTitleLabel) {
        _recordTitleLabel = [[SALabel alloc] init];
        _recordTitleLabel.textColor = HDAppTheme.PayNowColor.c333333;
        _recordTitleLabel.font = HDAppTheme.PayNowFont.standard15;
        _recordTitleLabel.text = PNLocalizedString(@"Transaction_record", @"交易记录");
    }
    return _recordTitleLabel;
}

- (UIImageView *)recordArrowImgView {
    if (!_recordArrowImgView) {
        _recordArrowImgView = [[UIImageView alloc] init];
        _recordArrowImgView.image = [UIImage imageNamed:@"pn_arrow_gray_background"];
    }
    return _recordArrowImgView;
}

- (HDUIButton *)recordActionClickButton {
    if (!_recordActionClickButton) {
        _recordActionClickButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_recordActionClickButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [HDMediator.sharedInstance navigaveToPayNowBillListVC:@{}];
        }];
    }
    return _recordActionClickButton;
}

- (UIView *)disclaimerBgView {
    if (!_disclaimerBgView) {
        _disclaimerBgView = [[UIView alloc] init];
        _disclaimerBgView.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        _disclaimerBgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(10)];
        };
    }
    return _disclaimerBgView;
}

- (UIImageView *)disclaimerIconImgView {
    if (!_disclaimerIconImgView) {
        _disclaimerIconImgView = [[UIImageView alloc] init];
        _disclaimerIconImgView.image = [UIImage imageNamed:@"pn_transaction_disclaimer_icon"];
    }
    return _disclaimerIconImgView;
}

- (SALabel *)disclaimerTitleLabel {
    if (!_disclaimerTitleLabel) {
        _disclaimerTitleLabel = [[SALabel alloc] init];
        _disclaimerTitleLabel.textColor = HDAppTheme.PayNowColor.c333333;
        _disclaimerTitleLabel.font = HDAppTheme.PayNowFont.standard15;
        _disclaimerTitleLabel.text = PNLocalizedString(@"disclaimer", @"免责声明");
    }
    return _disclaimerTitleLabel;
}

- (UIImageView *)disclaimerArrowImgView {
    if (!_disclaimerArrowImgView) {
        _disclaimerArrowImgView = [[UIImageView alloc] init];
        _disclaimerArrowImgView.image = [UIImage imageNamed:@"pn_arrow_gray_background"];
    }
    return _disclaimerArrowImgView;
}

- (HDUIButton *)disclaimerActionClickButton {
    if (!_disclaimerActionClickButton) {
        _disclaimerActionClickButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_disclaimerActionClickButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [HDMediator.sharedInstance navigaveToPayNowPayWebViewVC:@{@"htmlName": @"Disclaimer", @"navTitle": PNLocalizedString(@"disclaimer", @"免责声明")}];
        }];
    }
    return _disclaimerActionClickButton;
}

#pragma mark
- (UIView *)topBgView {
    if (!_topBgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor hd_colorWithHexString:@"E11F26"];
        view.layer.masksToBounds = YES;
        view.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:kRealWidth(25)];
        };
        _topBgView = view;
    }
    return _topBgView;
}

- (UIImageView *)topTitleImgView {
    if (!_topTitleImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"pn_khqr_code_icon"];
        _topTitleImgView = imageView;
    }
    return _topTitleImgView;
}

- (UIImageView *)rightIconImgView {
    if (!_rightIconImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"pn_sj_img"];
        _rightIconImgView = imageView;
    }
    return _rightIconImgView;
}

- (SALabel *)merchantNameLabel {
    if (!_merchantNameLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c000000;
        label.font = [HDAppTheme.PayNowFont nunitoSansRegular:15];
        label.numberOfLines = 0;
        _merchantNameLabel = label;
    }
    return _merchantNameLabel;
}

- (SALabel *)moneyLabel {
    if (!_moneyLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c000000;
        label.font = [HDAppTheme.PayNowFont nunitoSansRegular:15];
        _moneyLabel = label;
    }
    return _moneyLabel;
}

- (SALabel *)limitLabel {
    if (!_limitLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard12;
        _limitLabel = label;
    }
    return _limitLabel;
}

- (UIView *)centerBgView {
    if (!_centerBgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        view.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(10)];
        };
        _centerBgView = view;
    }
    return _centerBgView;
}
@end
