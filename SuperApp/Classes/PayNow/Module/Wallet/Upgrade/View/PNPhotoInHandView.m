//
//  PNPhotoInHandView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/1/7.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPhotoInHandView.h"
#import "NSMutableAttributedString+Highlight.h"
#import "SAInfoView.h"


@interface PNPhotoInHandView ()

@property (nonatomic, strong) SALabel *titleLabel;
@property (nonatomic, strong) HDUIButton *rightBtn;
@property (nonatomic, strong) UIView *line;

/// 升级到尊享的提示
@property (nonatomic, strong) SALabel *platinumAccountTipsLabel;
@property (nonatomic, strong) SALabel *tipsLabel;
@end


@implementation PNPhotoInHandView

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
    [self addSubview:self.titleLabel];
    [self addSubview:self.rightBtn];
    [self addSubview:self.platinumAccountTipsLabel];
    [self addSubview:self.line];
    [self addSubview:self.tipsLabel];
}

- (void)updateConstraints {
    [self.rightBtn sizeToFit];
    [self.rightBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-15));
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.platinumAccountTipsLabel.mas_top);
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(kRealWidth(10));
        make.width.equalTo(@(self.rightBtn.width));
    }];

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(15));
        make.top.mas_equalTo(self.mas_top).offset(kRealWidth(15));
    }];

    [self.platinumAccountTipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.right.mas_equalTo(self.mas_right).offset(-kRealWidth(15));
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(12));
    }];

    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(PixelOne));
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-15));
        make.top.mas_equalTo(self.platinumAccountTipsLabel.mas_bottom).offset(kRealWidth(15));
    }];

    [self.tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(15));
        make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-15));
        make.top.mas_equalTo(self.line.mas_bottom).offset(kRealWidth(15));
        make.bottom.mas_equalTo(self.mas_bottom).offset(kRealWidth(-15));
    }];

    [super updateConstraints];
}

- (void)setUrlStr:(NSString *)urlStr {
    _urlStr = urlStr;
    if (WJIsStringNotEmpty(urlStr)) {
        [self.rightBtn setTitle:PNLocalizedString(@"Uploaded", @"已上传") forState:0];
        [self.rightBtn setTitleColor:HDAppTheme.PayNowColor.c343B4D forState:0];
    }
}

#pragma mark
- (SALabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[SALabel alloc] init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = HDAppTheme.PayNowColor.c343B4D;
        _titleLabel.font = HDAppTheme.PayNowFont.standard15;

        NSString *highlight = [NSString stringWithFormat:@"(%@)", PNLocalizedString(@"Optional_tips", @"可选")];
        NSString *wholeStr = [NSString stringWithFormat:@"%@ %@", PNLocalizedString(@"Photo_legal_in_hand", @"手持证件照"), highlight];
        _titleLabel.attributedText = [NSMutableAttributedString highLightString:highlight inWholeString:wholeStr highLightFont:HDAppTheme.PayNowFont.standard15
                                                                 highLightColor:HDAppTheme.PayNowColor.placeholderColor];
    }
    return _titleLabel;
}

- (HDUIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setImage:[UIImage imageNamed:@"pn_arrow_gray_small"] forState:0];
        [_rightBtn setTitle:PNLocalizedString(@"please_upload", @"请上传") forState:0];
        _rightBtn.imagePosition = HDUIButtonImagePositionRight;
        _rightBtn.spacingBetweenImageAndTitle = kRealWidth(15);
        [_rightBtn setTitleColor:HDAppTheme.PayNowColor.cADB6C8 forState:0];
        _rightBtn.titleLabel.font = HDAppTheme.PayNowFont.standard15B;
        _rightBtn.adjustsButtonWhenHighlighted = NO;

        @HDWeakify(self);
        void (^callback)(NSString *) = ^(NSString *resultStr) {
            HDLog(@"结果是：%@", resultStr);
            @HDStrongify(self);
            self.urlStr = resultStr;
            !self.refreshResultBlock ?: self.refreshResultBlock(resultStr);
            [self.rightBtn setTitle:PNLocalizedString(@"Uploaded", @"已上传") forState:0];
            [self.rightBtn setTitleColor:HDAppTheme.PayNowColor.c343B4D forState:0];
        };

        [_rightBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            HDLog(@"click");
            @HDStrongify(self);

            if (self.cardType <= 0) {
                [NAT showAlertWithMessage:PNLocalizedString(@"pn_select_Legal_document_type", @"请先选择【证件类型】") buttonTitle:PNLocalizedString(@"BUTTON_TITLE_DONE", @"确定")
                                  handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                                      [alertView dismiss];
                                  }];
                return;
            }

            [HDMediator.sharedInstance navigaveToPayNowUploadImageVC:@{
                @"callback": callback,
                @"viewType": @(1),
                @"url": self.urlStr,
                @"cardType": @(self.cardType),
            }];
        }];
    }
    return _rightBtn;
}

- (SALabel *)platinumAccountTipsLabel {
    if (!_platinumAccountTipsLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.mainThemeColor;
        label.font = HDAppTheme.PayNowFont.standard12;
        label.numberOfLines = 0;
        label.text = PNLocalizedString(@"pn_To_upgrade_to_Platinum_account_tips", @"* 如需升级尊享账户及使用国际转账功能，则手持证件照为必填项");
        _platinumAccountTipsLabel = label;
    }
    return _platinumAccountTipsLabel;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = HDAppTheme.PayNowColor.lineColor;
    }
    return _line;
}

- (SALabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[SALabel alloc] init];
        _tipsLabel.textColor = HDAppTheme.PayNowColor.c9599A2;
        _tipsLabel.font = HDAppTheme.PayNowFont.standard15;
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.text = PNLocalizedString(@"tips_nbc_photo", @"根据NBC要求，请提供本人真实有效的证件，信息仅用于身份验证，CoolCash保障您的信息安全。");
    }
    return _tipsLabel;
}

@end
