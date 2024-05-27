//
//  TNProductBaseInfoCell.m
//  SuperApp
//
//  Created by 张杰 on 2022/3/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNProductBaseInfoCell.h"
#import "HDAppTheme+TinhNow.h"
#import "SAOperationButton.h"
#import "SAUser.h"
#import "TNLeftCircleImageButton.h"


@interface TNProductBaseInfoCell ()
/// 产品名称
@property (nonatomic, strong) UILabel *productNameLabel;
/// 全网公告
@property (nonatomic, strong) HDLabel *announcementLabel;
/// 收藏按钮
@property (nonatomic, strong) HDUIButton *favoriteButton;
/// 已售数量
@property (strong, nonatomic) UILabel *soldLabel;
/// 荣誉标识
@property (strong, nonatomic) UIImageView *honorLogoImageView;
///批量标签
@property (nonatomic, strong) HDLabel *mixStagePriceTag;
/// 分割线
@property (strong, nonatomic) UIView *lineView;
/// 普通分享按钮
@property (nonatomic, strong) HDUIButton *normalShareButton;
/// 卖家分享按钮
@property (nonatomic, strong) TNLeftCircleImageButton *sellerShareButton;
/// 加入销售
@property (nonatomic, strong) SAOperationButton *addSellBtn;

@end


@implementation TNProductBaseInfoCell

- (void)setFrame:(CGRect)frame {
    CGRect newFrame = frame;
    newFrame.origin.x = kRealWidth(8);
    newFrame.size.width = kScreenWidth - kRealWidth(16);
    [super setFrame:newFrame];
}

- (void)hd_setupViews {
    [self.contentView addSubview:self.productNameLabel];
    [self.contentView addSubview:self.favoriteButton];
    [self.contentView addSubview:self.soldLabel];
    [self.contentView addSubview:self.honorLogoImageView];
    [self.contentView addSubview:self.announcementLabel];
    [self.contentView addSubview:self.mixStagePriceTag];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.normalShareButton];
    [self.contentView addSubview:self.sellerShareButton];
    [self.contentView addSubview:self.addSellBtn];
}
- (void)setModel:(TNProductBaseInfoCellModel *)model {
    _model = model;
    if ([self.model.storeType isEqualToString:TNStoreTypeSelf] || [self.model.storeType isEqualToString:TNStoreTypeOverseasShopping]) {
        self.productNameLabel.attributedText = [self getGoodNameAttributedText];
    } else {
        self.productNameLabel.text = model.productName;
    }
    self.honorLogoImageView.hidden = !model.isHonor;
    self.mixStagePriceTag.hidden = !model.mixWholeSale;
    self.soldLabel.hidden = HDIsStringEmpty(model.salesLabel);
    if (!self.soldLabel.isHidden) {
        NSString *str = TNLocalizedString(@"tn_text_sold_title", @"Sold ");
        self.soldLabel.text = [str stringByAppendingFormat:@"%@", _model.salesLabel];
    }
    if (HDIsStringNotEmpty(model.announcement)) {
        self.announcementLabel.hidden = NO;
        self.announcementLabel.text = model.announcement;
    } else {
        self.announcementLabel.hidden = YES;
    }

    self.favoriteButton.selected = model.isCollected;
    if (model.detailViewStyle == TNProductDetailViewTypeSupplyAndMarketing) {
        self.addSellBtn.hidden = NO;
        if (model.isJoinSales) {
            [self.addSellBtn applyPropertiesWithBackgroundColor:HDAppTheme.TinhNowColor.cD6DBE8];
            [self.addSellBtn setTitleColor:HDAppTheme.TinhNowColor.G2 forState:UIControlStateNormal];
            [self.addSellBtn setTitle:TNLocalizedString(@"i4h6aHsC", @"取消销售") forState:UIControlStateNormal];
            self.normalShareButton.hidden = YES;
            self.sellerShareButton.hidden = NO;
        } else {
            [self.addSellBtn applyPropertiesWithBackgroundColor:HexColor(0xE12733)];
            [self.addSellBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            [self.addSellBtn setTitle:TNLocalizedString(@"3Sfc8II1", @"加入销售") forState:UIControlStateNormal];
            self.normalShareButton.hidden = NO;
            self.sellerShareButton.hidden = YES;
        }
    } else {
        self.addSellBtn.hidden = YES;
        self.normalShareButton.hidden = NO;
        self.sellerShareButton.hidden = YES;
    }

    [self setNeedsUpdateConstraints];
}
#pragma mark - private methods
- (NSMutableAttributedString *)getGoodNameAttributedText {
    NSString *imageName;
    if ([self.model.storeType isEqualToString:TNStoreTypeSelf]) {
        imageName = @"tn_offcial_k";
    } else {
        imageName = @"tn_global_new_k";
    }
    UIImage *globalImage = [UIImage imageNamed:imageName];
    NSString *name = [NSString stringWithFormat:@" %@", self.model.productName];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:name];
    NSTextAttachment *imageMent = [[NSTextAttachment alloc] init];
    imageMent.image = globalImage;
    UIFont *font = HDAppTheme.TinhNowFont.standard15;
    CGFloat paddingTop = font.lineHeight - font.pointSize;
    imageMent.bounds = CGRectMake(0, -paddingTop, globalImage.size.width, globalImage.size.height);
    NSAttributedString *attachment = [NSAttributedString attributedStringWithAttachment:imageMent];
    [text insertAttributedString:attachment atIndex:0];
    [text addAttributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: HDAppTheme.TinhNowColor.G1} range:NSMakeRange(0, name.length)];
    return text;
}
- (void)updateConstraints {
    [self.productNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(10));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(10));
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(10));
    }];

    UIView *topView = self.productNameLabel;
    if (!self.honorLogoImageView.isHidden) {
        topView = self.honorLogoImageView;
        [self.honorLogoImageView sizeToFit];
        [self.honorLogoImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.productNameLabel.mas_leading);
            make.top.equalTo(self.productNameLabel.mas_bottom).offset(kRealWidth(5));
            make.size.mas_equalTo(self.honorLogoImageView.image.size);
        }];
    }
    if (!self.mixStagePriceTag.isHidden) {
        if (self.honorLogoImageView.isHidden) {
            topView = self.mixStagePriceTag;
        }
        [self.mixStagePriceTag sizeToFit];
        [self.mixStagePriceTag mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (!self.honorLogoImageView.isHidden) {
                make.centerY.equalTo(self.honorLogoImageView.mas_centerY);
                make.left.equalTo(self.honorLogoImageView.mas_right).offset(kRealWidth(5));
            } else {
                make.top.equalTo(self.productNameLabel.mas_bottom).offset(kRealWidth(5));
                make.leading.equalTo(self.productNameLabel.mas_leading);
            }
            make.height.mas_equalTo(kRealWidth(15));
        }];
    }

    if (!self.soldLabel.isHidden) {
        [self.soldLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.productNameLabel.mas_leading);
            make.top.equalTo(topView.mas_bottom).offset(kRealWidth(10));
        }];
        topView = self.soldLabel;
    }

    if (!self.addSellBtn.isHidden) {
        [self.addSellBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.productNameLabel.mas_trailing);
            make.size.mas_equalTo(CGSizeMake(kRealWidth(90), kRealWidth(20)));
            if (!self.soldLabel.isHidden) {
                make.centerY.equalTo(self.soldLabel.mas_centerY);
            } else {
                make.top.equalTo(topView.mas_bottom).offset(kRealWidth(10));
            }
        }];

        if (self.soldLabel.isHidden) {
            topView = self.addSellBtn;
        }
    }

    if (!self.announcementLabel.isHidden) {
        [self.announcementLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.productNameLabel.mas_leading);
            make.right.lessThanOrEqualTo(self.contentView.mas_right).offset(-kRealWidth(15));
            make.top.equalTo(topView.mas_bottom).offset(kRealWidth(10));
        }];
        topView = self.announcementLabel;
    }

    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.productNameLabel.mas_leading);
        make.trailing.equalTo(self.productNameLabel.mas_trailing);
        make.top.equalTo(topView.mas_bottom).offset(kRealWidth(10));
        make.height.mas_equalTo(0.5);
    }];

    [self.favoriteButton sizeToFit];
    [self.favoriteButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(kRealWidth(12));
        make.leading.equalTo(self.productNameLabel.mas_leading);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(12));
        make.height.mas_equalTo(self.favoriteButton.imageView.image.size.height);
    }];
    if (!self.normalShareButton.isHidden) {
        [self.normalShareButton sizeToFit];
        [self.normalShareButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.favoriteButton.mas_centerY);
            make.trailing.equalTo(self.productNameLabel.mas_trailing);
        }];
    }
    if (!self.sellerShareButton.isHidden) {
        [self.sellerShareButton sizeToFit];
        [self.sellerShareButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.favoriteButton.mas_centerY);
            make.trailing.equalTo(self.productNameLabel.mas_trailing);
        }];
    }

    [super updateConstraints];
}
/** @lazy productName */
- (UILabel *)productNameLabel {
    if (!_productNameLabel) {
        _productNameLabel = [[UILabel alloc] init];
        _productNameLabel.font = [HDAppTheme.TinhNowFont fontSemibold:15];
        _productNameLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _productNameLabel.numberOfLines = 0;
    }
    return _productNameLabel;
}
/** @lazy favotiteButton */
- (HDUIButton *)favoriteButton {
    if (!_favoriteButton) {
        _favoriteButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_favoriteButton setImage:[UIImage imageNamed:@"tn_collection_normal"] forState:UIControlStateNormal];
        [_favoriteButton setImage:[UIImage imageNamed:@"tn_collection_selected"] forState:UIControlStateSelected];
        [_favoriteButton setTitle:TNLocalizedString(@"SIWvcs5U", @"收藏") forState:UIControlStateNormal];
        [_favoriteButton setTitleColor:HDAppTheme.TinhNowColor.G1 forState:UIControlStateNormal];
        _favoriteButton.spacingBetweenImageAndTitle = 5;
        _favoriteButton.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:12];
        @HDWeakify(self);
        [_favoriteButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.model.favoriteClickCallBack ?: self.model.favoriteClickCallBack(self.model.isCollected);
        }];
    }
    return _favoriteButton;
}
/** @lazy soldLabel */
- (UILabel *)soldLabel {
    if (!_soldLabel) {
        _soldLabel = [[UILabel alloc] init];
        _soldLabel.font = HDAppTheme.TinhNowFont.standard12;
        _soldLabel.textColor = HDAppTheme.TinhNowColor.G3;
    }
    return _soldLabel;
}
- (HDLabel *)announcementLabel {
    if (!_announcementLabel) {
        _announcementLabel = [[HDLabel alloc] init];
        _announcementLabel.textColor = HDAppTheme.TinhNowColor.cFA3A18;
        _announcementLabel.backgroundColor = [HexColor(0xFD8824) colorWithAlphaComponent:0.1];
        _announcementLabel.font = HDAppTheme.TinhNowFont.standard12M;
        _announcementLabel.numberOfLines = 0;
        _announcementLabel.hd_edgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
        _announcementLabel.hidden = YES;
        _announcementLabel.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:4];
        };
    }
    return _announcementLabel;
}
/** @lazy honorLogoImageView */
- (UIImageView *)honorLogoImageView {
    if (!_honorLogoImageView) {
        NSString *imageName = [NSString stringWithFormat:@"%@_%@", @"tn_highquality_store", [TNMultiLanguageManager currentLanguage]];
        _honorLogoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        //        _honorLogoImageView.hidden = YES;
    }
    return _honorLogoImageView;
}
/** @lazy mixStagePriceTag */
- (HDLabel *)mixStagePriceTag {
    if (!_mixStagePriceTag) {
        _mixStagePriceTag = [[HDLabel alloc] init];
        _mixStagePriceTag.font = [HDAppTheme.TinhNowFont fontSemibold:10];
        _mixStagePriceTag.textColor = HexColor(0xFF2323);
        _mixStagePriceTag.backgroundColor = [UIColor whiteColor];
        _mixStagePriceTag.textAlignment = NSTextAlignmentCenter;
        _mixStagePriceTag.text = TNLocalizedString(@"tn_mix_batch", @"混批");
        _mixStagePriceTag.hd_edgeInsets = UIEdgeInsetsMake(0, 4, 0, 4);
        _mixStagePriceTag.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            if (HDIsArrayEmpty(view.layer.sublayers)) {
                [view setRoundedCorners:UIRectCornerAllCorners radius:2 borderWidth:0.5 borderColor:HexColor(0xFF2323)];
            }
        };
    }
    return _mixStagePriceTag;
}
/** @lazy lineView */
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HDAppTheme.TinhNowColor.G4;
    }
    return _lineView;
}
/** @lazy normalShareButton */
- (HDUIButton *)normalShareButton {
    if (!_normalShareButton) {
        _normalShareButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_normalShareButton setImage:[UIImage imageNamed:@"tinhnow-black-share-new"] forState:UIControlStateNormal];
        [_normalShareButton setTitle:TNLocalizedString(@"tn_share_category_title", @"分享") forState:UIControlStateNormal];
        [_normalShareButton setTitleColor:HDAppTheme.TinhNowColor.G1 forState:UIControlStateNormal];
        _normalShareButton.spacingBetweenImageAndTitle = 5;
        _normalShareButton.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:12];
        @HDWeakify(self);
        [_normalShareButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.shareClickCallBack ?: self.shareClickCallBack();
        }];
    }
    return _normalShareButton;
}
/** @lazy sellerShareButton */
- (TNLeftCircleImageButton *)sellerShareButton {
    if (!_sellerShareButton) {
        _sellerShareButton = [[TNLeftCircleImageButton alloc] init];
        _sellerShareButton.leftCircleImage = [UIImage imageNamed:@"tn_share_make_money"];
        _sellerShareButton.text = TNLocalizedString(@"GSoqaQzH", @"分享赚");
        _sellerShareButton.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:226 / 255.0 blue:93 / 255.0 alpha:0.3000];
        _sellerShareButton.textFont = [HDAppTheme.TinhNowFont fontMedium:12];
        _sellerShareButton.textColor = HexColor(0x923800);
        _sellerShareButton.leftSpace = 3;
        _sellerShareButton.rightSpace = kRealWidth(5);

        @HDWeakify(self);
        _sellerShareButton.addTouchUpInsideHandler = ^(TNLeftCircleImageButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.shareClickCallBack ?: self.shareClickCallBack();
        };
    }
    return _sellerShareButton;
}
/** @lazy buyNowBtn */
- (SAOperationButton *)addSellBtn {
    if (!_addSellBtn) {
        _addSellBtn = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        _addSellBtn.cornerRadius = 10;
        _addSellBtn.titleEdgeInsets = UIEdgeInsetsZero;
        [_addSellBtn setTitle:TNLocalizedString(@"3Sfc8II1", @"加入销售") forState:UIControlStateNormal];
        [_addSellBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _addSellBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontSemibold:12];
        _addSellBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        @HDWeakify(self);
        [_addSellBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.model.addOrCancelSalesClickCallBack ?: self.model.addOrCancelSalesClickCallBack(!self.model.isJoinSales);
        }];
        //        _addSellBtn.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        //            [view setRoundedCorners:UIRectCornerAllCorners radius:10];
        //        };
    }
    return _addSellBtn;
}
@end


@implementation TNProductBaseInfoCellModel

@end
