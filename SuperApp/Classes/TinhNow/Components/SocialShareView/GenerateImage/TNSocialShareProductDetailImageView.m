//
//  TNSocialShareGenerateImageView.m
//  SuperApp
//
//  Created by 张杰 on 2022/4/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNSocialShareProductDetailImageView.h"
#import "HDAppTheme+TinhNow.h"
#import "TNDecimalTool.h"


@interface TNSocialShareProductDetailImageView ()
/// 分享模型
@property (nonatomic, strong) TNShareWebpageObject *shareObject;
/// 内容视图
@property (strong, nonatomic) UIView *contentView;
/// 分享图片
@property (strong, nonatomic) UIImageView *shareImageView;
/// logo图
@property (strong, nonatomic) UIImageView *logoImageView;
/// 二维码图片
@property (strong, nonatomic) UIImageView *QRImageView;
/// 价格背景图
@property (strong, nonatomic) UIView *priceView;
/// 销售价
@property (strong, nonatomic) UILabel *priceLabel;
/// 市场价
@property (strong, nonatomic) UILabel *marketPriceLabel;
/// 折扣
@property (nonatomic, strong) HDUIButton *discountTag;
/// 底部视图
@property (strong, nonatomic) UIView *bottomView;
/// 商品名称
@property (strong, nonatomic) HDLabel *productNameLabel;
@end


@implementation TNSocialShareProductDetailImageView
- (instancetype)initWithShareObject:(TNShareWebpageObject *)shareObject {
    if (self = [super init]) {
        self.shareObject = shareObject;
    }
    return self;
}
- (void)hd_setupViews {
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.shareImageView];
    [self.contentView addSubview:self.logoImageView];
    [self.contentView addSubview:self.QRImageView];
    [self.contentView addSubview:self.priceView];
    [self.priceView addSubview:self.priceLabel];
    [self.priceView addSubview:self.marketPriceLabel];
    [self.priceView addSubview:self.discountTag];
    [self.contentView addSubview:self.bottomView];
    [self.contentView addSubview:self.productNameLabel];
}
- (void)updateConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.width.mas_equalTo(kScreenWidth - kRealWidth(30));
        make.height.equalTo(self.contentView.mas_width);
    }];
    [self.shareImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.logoImageView sizeToFit];
    [self.logoImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shareImageView.mas_top).offset(kRealWidth(10));
        make.left.equalTo(self.shareImageView.mas_left).offset(kRealWidth(10));
    }];
    [self.priceView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.logoImageView.mas_leading);
        make.bottom.equalTo(self.bottomView.mas_top).offset(-kRealWidth(10));
    }];
    if (!self.discountTag.isHidden) {
        [self.discountTag sizeToFit];
        [self.discountTag mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self.priceView);
        }];
    }
    [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceView.mas_left).offset(kRealWidth(5));
        if (!self.discountTag.isHidden) {
            make.top.equalTo(self.discountTag.mas_bottom).offset(kRealWidth(8));
        } else {
            make.top.equalTo(self.priceView.mas_top).offset(kRealWidth(5));
        }
        make.right.equalTo(self.priceView.mas_right).offset(-kRealWidth(30));
        if (self.marketPriceLabel.isHidden) {
            make.bottom.equalTo(self.priceView.mas_bottom).offset(-kRealWidth(5));
        }
    }];
    if (!self.marketPriceLabel.isHidden) {
        [self.marketPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.priceLabel.mas_leading);
            make.top.equalTo(self.priceLabel.mas_bottom).offset(kRealWidth(5));
            make.bottom.equalTo(self.priceView.mas_bottom).offset(-kRealWidth(5));
        }];
    }
    [self.QRImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.priceView.mas_centerY);
        make.right.equalTo(self.shareImageView.mas_right).offset(-kRealWidth(10));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(40), kRealWidth(40)));
    }];
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.shareImageView);
    }];
    [self.productNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView.mas_left).offset(kRealWidth(10));
        make.right.equalTo(self.bottomView.mas_right).offset(-kRealWidth(10));
        make.top.equalTo(self.bottomView.mas_top).offset(kRealWidth(10));
        make.bottom.equalTo(self.bottomView.mas_bottom).offset(-kRealWidth(10));
    }];
    [super updateConstraints];
}
- (void)setShareObject:(TNShareWebpageObject *)shareObject {
    _shareObject = shareObject;
    self.productNameLabel.text = shareObject.title;
    if ([shareObject.thumbImage isKindOfClass:NSString.class]) {
        [HDWebImageManager setImageWithURL:shareObject.thumbImage
                          placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kScreenWidth - kRealWidth(30), kScreenWidth - kRealWidth(30)) logoWidth:80]
                                 imageView:self.shareImageView completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
                                     [self setNeedsUpdateConstraints];
                                 }];
    } else {
        self.shareImageView.image = shareObject.thumbImage;
    }

    if ([shareObject.associationModel isKindOfClass:TNSocialShareProductDetailModel.class]) {
        TNSocialShareProductDetailModel *model = shareObject.associationModel;
        self.priceLabel.text = model.price.thousandSeparatorAmount;
        if (HDIsStringNotEmpty(model.showDiscount)) {
            self.discountTag.hidden = NO;
            [self.discountTag setTitle:model.showDiscount forState:UIControlStateNormal];
        } else {
            self.discountTag.hidden = YES;
        }

        //判断市场价格是否隐藏 如商户端设置的默认SKU『市场价 ≤ 销售价』，则用户端商品隐藏市场价（划线价）
        NSComparisonResult result = [[TNDecimalTool toDecimalNumber:model.marketPrice.amount] compare:[TNDecimalTool toDecimalNumber:model.price.amount]];
        if (model.marketPrice.amount.doubleValue > 0 && result == NSOrderedDescending) {
            NSAttributedString *originalPrice = [[NSAttributedString alloc] initWithString:model.marketPrice.thousandSeparatorAmount attributes:@{
                NSFontAttributeName: self.marketPriceLabel.font,
                NSForegroundColorAttributeName: self.marketPriceLabel.textColor,
                NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle | NSUnderlinePatternSolid),
                NSStrikethroughColorAttributeName: self.marketPriceLabel.textColor
            }];
            self.marketPriceLabel.hidden = NO;
            self.marketPriceLabel.attributedText = originalPrice;
        } else {
            self.marketPriceLabel.hidden = YES;
        }
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *qrCodeImage = [HDCodeGenerator qrCodeImageForStr:shareObject.webpageUrl size:CGSizeMake(40, 40) level:HDInputCorrectionLevelL];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.QRImageView.image = qrCodeImage;
        });
    });

    [self setNeedsUpdateConstraints];
}

- (UIImage *)generateImageWithChannel:(SAShareChannel)channel {
    if ([channel isEqualToString:SAShareChannelFacebook] || [channel isEqualToString:SAShareChannelMessenger]) {
        NSString *url = HDIsStringNotEmpty(self.shareObject.facebookWebpageUrl) ? self.shareObject.facebookWebpageUrl : self.shareObject.webpageUrl;
        self.QRImageView.image = [HDCodeGenerator qrCodeImageForStr:url size:CGSizeMake(40, 40) level:HDInputCorrectionLevelL];
    }
    return [super generateImageWithChannel:channel];
}
/** @lazy contentView */
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:8];
        };
    }
    return _contentView;
}
/** @lazy logoImageView */
- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tn_share_logo"]];
    }
    return _logoImageView;
}
/** @lazy shareImageView */
- (UIImageView *)shareImageView {
    if (!_shareImageView) {
        _shareImageView = [[UIImageView alloc] init];
        _shareImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _shareImageView;
}
/** @lazy priceView */
- (UIView *)priceView {
    if (!_priceView) {
        _priceView = [[UIView alloc] init];
        _priceView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        _priceView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:8];
        };
    }
    return _priceView;
}
/** @lazy QRImageView */
- (UIImageView *)QRImageView {
    if (!_QRImageView) {
        _QRImageView = [[UIImageView alloc] init];
    }
    return _QRImageView;
}
/** @lazy priceLabel */
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = HDAppTheme.TinhNowColor.cFF2323;
        _priceLabel.font = [HDAppTheme.TinhNowFont fontMedium:12];
    }
    return _priceLabel;
}
/** @lazy marketPriceLabel */
- (UILabel *)marketPriceLabel {
    if (!_marketPriceLabel) {
        _marketPriceLabel = [[UILabel alloc] init];
        _marketPriceLabel.textColor = HDAppTheme.TinhNowColor.cADB6C8;
        _marketPriceLabel.font = [HDAppTheme.TinhNowFont fontRegular:10];
    }
    return _marketPriceLabel;
}
/** @lazy discountTag */
- (HDUIButton *)discountTag {
    if (!_discountTag) {
        _discountTag = [[HDUIButton alloc] init];
        _discountTag.titleLabel.font = [HDAppTheme.TinhNowFont fontSemibold:10];
        [_discountTag setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_discountTag setBackgroundImage:[UIImage imageNamed:@"tn_discount_tag"] forState:UIControlStateNormal];
        _discountTag.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 3);
        _discountTag.hidden = true;
    }
    return _discountTag;
}
/** @lazy productNameLabel */
- (HDLabel *)productNameLabel {
    if (!_productNameLabel) {
        _productNameLabel = [[HDLabel alloc] init];
        _productNameLabel.textColor = [UIColor whiteColor];
        _productNameLabel.font = [HDAppTheme.TinhNowFont fontMedium:12];
        _productNameLabel.numberOfLines = 0;
    }
    return _productNameLabel;
}
/** @lazy bottomView */
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [HDAppTheme.TinhNowColor.C1 colorWithAlphaComponent:0.5];
    }
    return _bottomView;
}
@end


@implementation TNSocialShareProductDetailModel

@end
