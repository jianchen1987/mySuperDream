//
//  TNSellerOrderCell.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNSellerOrderCell.h"
#import "HDAppTheme+TinhNow.h"
#import "TNMultiLanguageManager.h"
#import "TNSellerOrderModel.h"


@interface TNSellerOrderCell ()
@property (strong, nonatomic) UIImageView *productImageView; ///< 商品图片
@property (strong, nonatomic) UILabel *productNameLabel;     ///< 商品文字
@property (strong, nonatomic) UILabel *specLabel;            ///< 规格
@property (strong, nonatomic) UILabel *priceLabel;           ///< 售价
@property (strong, nonatomic) UILabel *inComeLabel;          ///< 预估收益
@end


@implementation TNSellerOrderCell
- (void)hd_setupViews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.productImageView];
    [self.contentView addSubview:self.productNameLabel];
    [self.contentView addSubview:self.specLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.inComeLabel];
}
- (void)setOverseaChannel:(NSString *)overseaChannel {
    _overseaChannel = overseaChannel;
}
- (void)setModel:(TNSellerOrderProductsModel *)model {
    _model = model;
    [HDWebImageManager setImageWithURL:model.thumbnail placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(90), kRealWidth(90))] imageView:self.productImageView];
    [self setGoodNameLabelText];
    self.specLabel.text = [model.specsList componentsJoinedByString:@","];
    self.priceLabel.text = [NSString stringWithFormat:@"%@ x%@", model.price.thousandSeparatorAmount, model.quantity];

    self.inComeLabel.text = [NSString
        stringWithFormat:@"%@:%@", model.profitType == 1 ? TNLocalizedString(@"real_income", @"结算收益") : TNLocalizedString(@"rhn0c4KT", @"预估收益"), model.supplierProfit.thousandSeparatorAmount];
}
#pragma mark - private methods
- (void)setGoodNameLabelText {
    if (HDIsStringNotEmpty(self.overseaChannel)) {
        UIImage *globalImage = [UIImage imageNamed:@"tn_global_k"];
        NSString *name = [NSString stringWithFormat:@" %@", self.model.productName];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:name];
        NSTextAttachment *imageMent = [[NSTextAttachment alloc] init];
        imageMent.image = globalImage;
        UIFont *font = [HDAppTheme.TinhNowFont fontSemibold:14];
        CGFloat paddingTop = font.lineHeight - font.pointSize;
        imageMent.bounds = CGRectMake(0, -paddingTop, globalImage.size.width, globalImage.size.height);
        NSAttributedString *attachment = [NSAttributedString attributedStringWithAttachment:imageMent];
        [text insertAttributedString:attachment atIndex:0];
        [text addAttributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: HDAppTheme.TinhNowColor.G1} range:NSMakeRange(0, name.length)];
        self.productNameLabel.attributedText = text;
    } else {
        self.productNameLabel.text = self.model.productName;
    }
}
- (void)updateConstraints {
    [self.productImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(10));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(10));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(90), kRealWidth(90)));
    }];
    [self.productNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productImageView.mas_top);
        make.left.equalTo(self.productImageView.mas_right).offset(kRealWidth(10));
        make.right.lessThanOrEqualTo(self.contentView.mas_right).offset(-kRealWidth(15));
    }];
    [self.specLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productNameLabel.mas_bottom).offset(kRealWidth(8));
        make.leading.equalTo(self.productNameLabel.mas_leading);
        make.right.lessThanOrEqualTo(self.contentView.mas_right).offset(-kRealWidth(15));
    }];
    [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.productImageView.mas_bottom);
        make.leading.equalTo(self.productNameLabel.mas_leading);
        make.right.lessThanOrEqualTo(self.inComeLabel.mas_left).offset(-kRealWidth(10));
    }];

    [self.inComeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.priceLabel.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
    }];

    [super updateConstraints];
}
/** @lazy productImageView */
- (UIImageView *)productImageView {
    if (!_productImageView) {
        _productImageView = [[UIImageView alloc] init];
        _productImageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:8];
        };
    }
    return _productImageView;
}
/** @lazy productNameLabel */
- (UILabel *)productNameLabel {
    if (!_productNameLabel) {
        _productNameLabel = [[UILabel alloc] init];
        _productNameLabel.font = [HDAppTheme.TinhNowFont fontMedium:14];
        _productNameLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _productNameLabel.numberOfLines = 2;
    }
    return _productNameLabel;
}
/** @lazy specLabel */
- (UILabel *)specLabel {
    if (!_specLabel) {
        _specLabel = [[UILabel alloc] init];
        _specLabel.font = [HDAppTheme.TinhNowFont fontRegular:12];
        _specLabel.textColor = HDAppTheme.TinhNowColor.G2;
    }
    return _specLabel;
}
/** @lazy priceLabel */
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [HDAppTheme.TinhNowFont fontMedium:12];
        _priceLabel.textColor = HDAppTheme.TinhNowColor.G1;
    }
    return _priceLabel;
}
/** @lazy inComeLabel */
- (UILabel *)inComeLabel {
    if (!_inComeLabel) {
        _inComeLabel = [[UILabel alloc] init];
        _inComeLabel.font = [HDAppTheme.TinhNowFont fontMedium:12];
        _inComeLabel.textColor = HDAppTheme.TinhNowColor.C1;
    }
    return _inComeLabel;
}
@end
