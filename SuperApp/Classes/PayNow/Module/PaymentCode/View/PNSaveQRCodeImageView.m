//
//  PNSaveQRCodeImageView.m
//  SuperApp
//
//  Created by xixi_wen on 2021/12/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNSaveQRCodeImageView.h"
#import "PNQRCodeModel.h"
#import "UIImage+PNExtension.h"


@interface PNSaveQRCodeImageView ()
@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) SALabel *titleLabel;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) SALabel *nameLabel;
@property (nonatomic, strong) UIImageView *qrCodeImgView;
@property (nonatomic, strong) SALabel *moneyLabel;

@property (nonatomic, strong) UIImage *centerLogo;
@end


@implementation PNSaveQRCodeImageView

- (void)hd_setupViews {
    //    self.backgroundColor = HDAppTheme.PayNowColor.cFD7127;

    //    [self addSubview:self.titleLabel];
    //    [self addSubview:self.bgView];
    [self addSubview:self.bgImgView];
    [self.bgImgView addSubview:self.qrCodeImgView];
    [self.bgImgView addSubview:self.nameLabel];
    //    [self.bgImgView addSubview:self.moneyLabel];
}

- (void)setModel:(PNQRCodeModel *)model {
    _model = model;

    self.nameLabel.text = model.payeeName;
    //    self.moneyLabel.text = [NSString stringWithFormat:@"%@ %@", model.currency, model.amount];

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (void)updateConstraints {
    //    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.size.equalTo(@(self.bgImgView.image.size));
    //        make.left.top.right.equalTo(self);
    //    }];

    [self.bgImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(@(self.bgImgView.image.size));
        //        make.left.top.equalTo(self);

        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    //    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(15));
    //        make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-15));
    //        make.top.mas_equalTo(self.mas_top).offset(kRealWidth(25));
    //    }];
    //
    //    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.left.mas_equalTo(self.mas_left).offset(kRealWidth(65));
    //        make.right.mas_equalTo(self.mas_right).offset(kRealWidth(-65));
    //        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(20));
    //        make.bottom.mas_equalTo(self.mas_bottom).offset(kRealWidth(-30));
    //    }];
    //

    if ([self.model.currency isEqualToString:PNCurrencyTypeKHR]) {
        self.centerLogo = [UIImage imageNamed:@"pn_qrcode_khr"];
    } else {
        self.centerLogo = [UIImage imageNamed:@"pn_qrcode_usd"];
    }
    self.qrCodeImgView.image = [UIImage imageQRCodeContent:self.model.qrCode withSize:376 centerImage:self.centerLogo centerImageSize:88];
    [self.qrCodeImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImgView).offset(566);
        make.left.equalTo(self.bgImgView).offset(312);
        make.right.equalTo(self.bgImgView).offset(-312);
        make.height.width.equalTo(@(376));
    }];

    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgImgView.mas_left).offset(30);
        make.right.mas_equalTo(self.bgImgView.mas_right).offset(-30);
        make.top.equalTo(self.bgImgView).offset(1008);
    }];

    //    [self.moneyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.left.mas_equalTo(self.bgImgView.mas_left).offset(30);
    //        make.right.mas_equalTo(self.bgImgView.mas_right).offset(-30);
    //        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
    //    }];

    [super updateConstraints];
}

#pragma mark
- (SALabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[SALabel alloc] init];
        _titleLabel.textColor = HDAppTheme.PayNowColor.cFFFFFF;
        _titleLabel.font = [HDAppTheme.PayNowFont fontSemibold:20];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = PNLocalizedString(@"scan_with_wownow_to_pay", @"使用WOWNOW APP扫一扫，向我付款");
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
    }
    return _bgView;
}

- (SALabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[SALabel alloc] init];
        _nameLabel.textColor = HDAppTheme.PayNowColor.c000000;
        _nameLabel.font = [HDAppTheme.PayNowFont nunitoSansRegular:90];
        _nameLabel.adjustsFontSizeToFitWidth = YES;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (UIImageView *)qrCodeImgView {
    if (!_qrCodeImgView) {
        _qrCodeImgView = [[UIImageView alloc] init];
    }
    return _qrCodeImgView;
}

- (SALabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[SALabel alloc] init];
        _moneyLabel.textColor = HDAppTheme.PayNowColor.c333333;
        _moneyLabel.font = [HDAppTheme.PayNowFont fontMedium:50];
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _moneyLabel;
}

- (UIImage *)centerLogo {
    if (!_centerLogo) {
        _centerLogo = [UIImage imageNamed:@"pn_qrcode_usd"];
    }
    return _centerLogo;
}

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"pn_save_qrCode_image_bg"];
        _bgImgView = imageView;
    }
    return _bgImgView;
}
@end
