//
//  TNProductDetailsIntroTableViewCell.m
//  SuperApp
//
//  Created by seeu on 2020/7/24.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNProductDetailsIntroTableViewCell.h"
#import "HDAppTheme+TinhNow.h"
#import "SASingleImageCollectionViewCell.h"
#import "SAUser.h"
#import "TNImageModel.h"
#import "TNProductDTO.h"
#import "TNSingleVideoCollectionViewCell.h"
#import "TNView.h"
#import <YYText.h>

///价格相关显示视图  抽离出来
@interface TNProductDetailPriceView : TNView
/// 价格区间  普通商品详情的时候  就是销售价格   选品详情  就是收益或者批发价显示
@property (nonatomic, strong) UILabel *priceRangeLabel;
///  原价
@property (nonatomic, strong) UILabel *originalPriceLabel;
///  折扣
@property (nonatomic, strong) HDLabel *discountLabel;
/// 收藏按钮
@property (nonatomic, strong) HDUIButton *favoriteButton;
/// 限购一件
@property (strong, nonatomic) UILabel *limitLabel;
/// 已售数量
@property (strong, nonatomic) UILabel *soldLabel;
/// 销售价价
@property (strong, nonatomic) UILabel *salePriceLabel;
/// 批发价
@property (strong, nonatomic) UILabel *wholesalePriceLabel;
/// model
@property (nonatomic, strong) TNProductDetailsIntroTableViewCellModel *model;
///// dto
@property (nonatomic, strong) TNProductDTO *productDTO;
@end


@implementation TNProductDetailPriceView

- (void)hd_setupViews {
    [self addSubview:self.priceRangeLabel];
    [self addSubview:self.originalPriceLabel];
    [self addSubview:self.discountLabel];
    [self addSubview:self.limitLabel];
    [self addSubview:self.favoriteButton];
    [self addSubview:self.salePriceLabel];
    [self addSubview:self.wholesalePriceLabel];
    [self addSubview:self.soldLabel];
}
- (void)setModel:(TNProductDetailsIntroTableViewCellModel *)model {
    _model = model;
    self.priceRangeLabel.text = model.price;
    self.priceRangeLabel.textColor = HDAppTheme.TinhNowColor.C3;
    if (model.detailViewType == TNProductDetailViewTypeSupplyAndMarketing) {
        self.favoriteButton.hidden = NO;
        self.originalPriceLabel.hidden = YES;
        self.discountLabel.hidden = YES;
        if (model.isJoinSales) {
            self.salePriceLabel.hidden = NO;
            self.wholesalePriceLabel.hidden = NO;
            self.priceRangeLabel.text = [NSString stringWithFormat:@"%@: %@", TNLocalizedString(@"1dh32q2n", @"收益"), model.revenue];
            self.priceRangeLabel.textColor = HDAppTheme.TinhNowColor.C1;
            self.salePriceLabel.text = [NSString stringWithFormat:@"%@: %@", TNLocalizedString(@"vg0PzsXn", @"销售价"), model.price];
            self.wholesalePriceLabel.text = [NSString stringWithFormat:@"%@: %@", TNLocalizedString(@"QWjyhTSY", @"批发价"), model.tradePrice];
        } else {
            self.salePriceLabel.hidden = YES;
            self.wholesalePriceLabel.hidden = YES;
            self.priceRangeLabel.text = [NSString stringWithFormat:@"%@: %@", TNLocalizedString(@"QWjyhTSY", @"批发价"), model.tradePrice];
            self.priceRangeLabel.textColor = HexColor(0xFF2323);
        }
    } else if (model.detailViewType == TNProductDetailViewTypeBargain) {
        self.originalPriceLabel.hidden = YES;
        self.favoriteButton.hidden = YES;
        self.discountLabel.hidden = YES;
        self.salePriceLabel.hidden = YES;
        self.wholesalePriceLabel.hidden = YES;
    } else {
        self.salePriceLabel.hidden = YES;
        self.wholesalePriceLabel.hidden = YES;
        //微店
        //        if (model.detailViewType == TNProductDetailViewTypeMicroShop) {
        //            self.favoriteButton.hidden = YES;
        //        }
        self.originalPriceLabel.hidden = HDIsStringEmpty(_model.originalPrice);
        if (!self.originalPriceLabel.isHidden) {
            NSAttributedString *originalPrice = [[NSAttributedString alloc] initWithString:_model.originalPrice attributes:@{
                NSFontAttributeName: self.originalPriceLabel.font,
                NSForegroundColorAttributeName: self.originalPriceLabel.textColor,
                NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle | NSUnderlinePatternSolid),
                NSStrikethroughColorAttributeName: self.originalPriceLabel.textColor
            }];
            self.originalPriceLabel.attributedText = originalPrice;
        }
        self.discountLabel.hidden = HDIsStringEmpty(_model.discount);
        if (!self.discountLabel.isHidden) {
            self.discountLabel.text = _model.discount;
        }
    }
    [self.favoriteButton setSelected:_model.isCollected];
    self.limitLabel.hidden = !_model.goodsLimitBuy;
    if (_model.goodsLimitBuy) {
        self.limitLabel.hidden = false;
        self.limitLabel.text = [NSString stringWithFormat:TNLocalizedString(@"tn_limit_goods_num", @"限购%ld件"), _model.maxLimit];
    } else {
        self.limitLabel.hidden = true;
    }
    self.soldLabel.hidden = HDIsStringEmpty(model.salesLabel);
    if (!self.soldLabel.isHidden) {
        NSString *str = TNLocalizedString(@"tn_text_sold_title", @"Sold ");
        self.soldLabel.text = [str stringByAppendingFormat:@"%@", _model.salesLabel];
    }

    [self setNeedsUpdateConstraints];
}
// 点击收藏按钮
- (void)clickOnFavoriteButton:(HDUIButton *)button {
    if (![SAUser hasSignedIn]) {
        [SAWindowManager switchWindowToLoginViewController];
        return;
    }

    @HDWeakify(self);
    [self.viewController.view showloading];
    if (self.favoriteButton.isSelected) {
        [self.productDTO removeProdutFromFavoriteWithProductId:self.model.productId sp:self.model.sp success:^{
            @HDStrongify(self);
            [self.viewController.view dismissLoading];
            [self.favoriteButton setSelected:NO];
            self.model.isCollected = NO;
            [HDTips showWithText:TNLocalizedString(@"tn_remove_favorite", @"取消收藏成功")];
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self.viewController.view dismissLoading];
        }];
    } else {
        [self.productDTO addProductIntoFavoriteWithProductId:self.model.productId sp:self.model.sp success:^{
            @HDStrongify(self);
            [self.viewController.view dismissLoading];
            [self.favoriteButton setSelected:YES];
            self.model.isCollected = YES;
            [HDTips showWithText:TNLocalizedString(@"tn_add_favorite", @"收藏成功")];
            [SATalkingData trackEvent:[self.model.trackPrefixName stringByAppendingString:@"商品详情页_点击收藏"]];
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self.viewController.view dismissLoading];
        }];
    }
}
- (void)updateConstraints {
    [self.priceRangeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(kRealWidth(15));
        make.left.equalTo(self.mas_left).offset(kRealWidth(15));
    }];
    //第一行 最右边视图  可能是收藏按钮  也可能是销量
    UIView *topRightView = self.soldLabel;

    if (!self.favoriteButton.isHidden) {
        topRightView = self.favoriteButton;
        [self.favoriteButton sizeToFit];
        [self.favoriteButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right);
            make.centerY.equalTo(self.priceRangeLabel.mas_centerY);
        }];
    }

    if (!self.soldLabel.isHidden) {
        [self.soldLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-kRealWidth(15));
            if (!self.favoriteButton.isHidden) {
                make.top.equalTo(self.priceRangeLabel.mas_bottom).offset(kRealWidth(7));
            } else {
                make.centerY.equalTo(self.priceRangeLabel.mas_centerY);
            }
        }];
    }

    if (!self.limitLabel.isHidden) {
        [self.limitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (!topRightView.isHidden) {
                make.centerY.equalTo(topRightView.mas_centerY);
                make.right.equalTo(topRightView.mas_left).offset(3);
            } else {
                make.right.equalTo(self.mas_right).offset(-kRealWidth(15));
                make.centerY.equalTo(self.priceRangeLabel.mas_centerY);
            }
        }];
    }

    UIView *bottomView = self.priceRangeLabel;

    if (!self.originalPriceLabel.isHidden) {
        bottomView = self.originalPriceLabel;
        [self.originalPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.priceRangeLabel);
            make.top.equalTo(self.priceRangeLabel.mas_bottom).offset(kRealWidth(7));
        }];
        if (!self.discountLabel.isHidden) {
            [self.discountLabel sizeToFit];
            [self.discountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.originalPriceLabel.mas_right).offset(kRealWidth(15));
                make.centerY.equalTo(self.originalPriceLabel);
            }];
        }
    }

    if (!self.salePriceLabel.isHidden) {
        bottomView = self.salePriceLabel;
        [self.salePriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.priceRangeLabel);
            make.top.equalTo(self.priceRangeLabel.mas_bottom).offset(kRealWidth(7));
        }];

        [self.wholesalePriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.salePriceLabel.mas_centerY);
            make.left.equalTo(self.salePriceLabel.mas_right).offset(kRealWidth(20));
        }];
    }

    if (self.favoriteButton.isHidden == NO && self.originalPriceLabel.isHidden == YES && self.salePriceLabel.isHidden == YES && self.soldLabel.isHidden == NO) {
        bottomView = self.soldLabel;
    }
    //更新底部视图
    [bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-kRealWidth(10));
    }];

    [super updateConstraints];
}

/** @lazy priceRangLabel */
- (UILabel *)priceRangeLabel {
    if (!_priceRangeLabel) {
        _priceRangeLabel = [[UILabel alloc] init];
        _priceRangeLabel.font = HDAppTheme.TinhNowFont.standard20;
        _priceRangeLabel.textColor = HDAppTheme.TinhNowColor.C3;
    }
    return _priceRangeLabel;
}
/** @lazy favotiteButton */
- (HDUIButton *)favoriteButton {
    if (!_favoriteButton) {
        _favoriteButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_favoriteButton setImage:[UIImage imageNamed:@"tinhnow_store_favorite_normal"] forState:UIControlStateNormal];
        [_favoriteButton setImage:[UIImage imageNamed:@"tinhnow_store_favorite_selected"] forState:UIControlStateSelected];
        [_favoriteButton addTarget:self action:@selector(clickOnFavoriteButton:) forControlEvents:UIControlEventTouchUpInside];
        _favoriteButton.imageEdgeInsets = UIEdgeInsetsMake(kRealWidth(15), kRealWidth(15), kRealWidth(15), kRealWidth(12));
    }
    return _favoriteButton;
}
/** @lazy limitLabel */
- (UILabel *)limitLabel {
    if (!_limitLabel) {
        _limitLabel = [[UILabel alloc] init];
        _limitLabel.textColor = [UIColor hd_colorWithHexString:@"#7E7E7E"];
        _limitLabel.font = HDAppTheme.TinhNowFont.standard12B;
        _limitLabel.hidden = true;
    }
    return _limitLabel;
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
/** @lazy discountLabel */
- (HDLabel *)discountLabel {
    if (!_discountLabel) {
        _discountLabel = [[HDLabel alloc] init];
        _discountLabel.textColor = [UIColor hd_colorWithHexString:@"#FA7D00"];
        _discountLabel.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:136 / 255.0 blue:18 / 255.0 alpha:0.11];
        _discountLabel.font = HDAppTheme.TinhNowFont.standard12;
        _discountLabel.hd_edgeInsets = UIEdgeInsetsMake(2, 8, 2, 8);
        _discountLabel.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.cornerRadius = precedingFrame.size.height / 2.0;
            view.layer.masksToBounds = YES;
        };
    }
    return _discountLabel;
}
/** @lazy originalPriceLabel */
- (UILabel *)originalPriceLabel {
    if (!_originalPriceLabel) {
        _originalPriceLabel = [[UILabel alloc] init];
        _originalPriceLabel.font = HDAppTheme.TinhNowFont.standard15;
        _originalPriceLabel.textColor = HDAppTheme.TinhNowColor.G3;
    }
    return _originalPriceLabel;
}
/** @lazy salePriceLabel */
- (UILabel *)salePriceLabel {
    if (!_salePriceLabel) {
        _salePriceLabel = [[UILabel alloc] init];
        _salePriceLabel.textColor = HexColor(0xFF2323);
        _salePriceLabel.font = HDAppTheme.TinhNowFont.standard12;
    }
    return _salePriceLabel;
}
/** @lazy salePriceLabel */
- (UILabel *)wholesalePriceLabel {
    if (!_wholesalePriceLabel) {
        _wholesalePriceLabel = [[UILabel alloc] init];
        _wholesalePriceLabel.textColor = HexColor(0xFF2323);
        _wholesalePriceLabel.font = HDAppTheme.TinhNowFont.standard12;
    }
    return _wholesalePriceLabel;
}
/** @lazy productDTO */
- (TNProductDTO *)productDTO {
    if (!_productDTO) {
        _productDTO = [[TNProductDTO alloc] init];
    }
    return _productDTO;
}
@end


@interface TNProductDetailsIntroTableViewCell () <HDCyclePagerViewDelegate, HDCyclePagerViewDataSource>
/// banner
@property (nonatomic, strong) HDCyclePagerView *bannerView;
/// 轮播数据源
@property (nonatomic, strong) NSMutableArray *dataSource;
/// 产品名称
@property (nonatomic, strong) UILabel *productNameLabel;
/// 页码
@property (nonatomic, strong) HDLabel *pageNoLabel;
/// 全网公告
@property (nonatomic, strong) UILabel *announcementLabel;
///
@property (nonatomic, strong) UIView *announcementBgView;
/// 包邮图片
@property (strong, nonatomic) UIImageView *freeShippingImageView;
///
@property (strong, nonatomic) TNProductDetailPriceView *priceView;
/// 荣誉标识
@property (strong, nonatomic) UIImageView *honorLogoImageView;
@end


@implementation TNProductDetailsIntroTableViewCell

- (void)hd_setupViews {
    self.dataSource = NSMutableArray.new;

    [self.contentView addSubview:self.bannerView];
    [self.contentView addSubview:self.pageNoLabel];
    [self.contentView addSubview:self.productNameLabel];
    [self.contentView addSubview:self.announcementBgView];
    [self.contentView addSubview:self.announcementLabel];
    [self.bannerView addSubview:self.freeShippingImageView];
    [self.contentView addSubview:self.priceView];
    [self.contentView addSubview:self.honorLogoImageView];
}

- (void)updateConstraints {
    [self.bannerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.height.equalTo(self.bannerView.mas_width).multipliedBy(1);
    }];
    [self.freeShippingImageView sizeToFit];
    [self.freeShippingImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.bannerView);
    }];

    if (!self.pageNoLabel.isHidden) {
        [self.pageNoLabel sizeToFit];
        [self.pageNoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bannerView.mas_centerX);
            make.bottom.equalTo(self.bannerView.mas_bottom).offset(-15);
        }];
    }

    [self.priceView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bannerView.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];

    if (!self.honorLogoImageView.isHidden) {
        [self.honorLogoImageView sizeToFit];
        [self.honorLogoImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
            make.top.equalTo(self.priceView.mas_bottom).offset(kRealWidth(10));
        }];
    }

    [self.productNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        if (!self.honorLogoImageView.isHidden) {
            make.top.equalTo(self.honorLogoImageView.mas_bottom).offset(kRealWidth(10));
        } else {
            make.top.equalTo(self.priceView.mas_bottom);
        }

        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        if (self.announcementLabel.hidden) {
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(15));
        } else {
            make.bottom.equalTo(self.announcementLabel.mas_top).offset(-kRealWidth(13));
        }
    }];

    [self.announcementLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(25.f);
        //        make.top.mas_equalTo(self.productNameLabel.mas_bottom).offset(13.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-20.f);
    }];

    [self.announcementBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.announcementLabel.mas_left).offset(-10.f);
        make.right.mas_equalTo(self.announcementLabel.mas_right).offset(10.f);
        make.top.mas_equalTo(self.announcementLabel.mas_top).offset(-4.f);
        make.bottom.mas_equalTo(self.announcementLabel.mas_bottom).offset(5.f);
    }];

    [super updateConstraints];
}
#pragma mark - setter
- (void)setModel:(TNProductDetailsIntroTableViewCellModel *)model {
    _model = model;
    self.priceView.model = model;
    [self setGoodNameLabelText];

    [self.dataSource removeAllObjects];
    //添加视频模型进去
    if (!HDIsArrayEmpty(model.videoList)) {
        TNImageModel *imageModel = model.images.firstObject;
        for (NSString *videoUrl in model.videoList) {
            TNSingleVideoCollectionViewCellModel *videoModel = TNSingleVideoCollectionViewCellModel.new;
            if (HDIsStringNotEmpty(imageModel.medium)) {
                videoModel.coverImageUrl = imageModel.medium;
            }
            videoModel.videoUrl = videoUrl;
            //            @"https://dh2.v.netease.com/2017/cg/fxtpty.mp4";
            videoModel.placholderImage = [HDHelper placeholderImageWithBgColor:HDAppTheme.color.G5 cornerRadius:0 size:CGSizeMake(kScreenWidth, kScreenWidth)
                                                                     logoImage:[UIImage imageNamed:@"sa_placeholder_image"]
                                                                      logoSize:CGSizeMake(100, 100)];
            videoModel.cornerRadius = 0;
            [self.dataSource addObject:videoModel];
        }
    }
    for (TNImageModel *image in _model.images) {
        SASingleImageCollectionViewCellModel *bannerModel = SASingleImageCollectionViewCellModel.new;
        bannerModel.url = image.medium;
        bannerModel.associatedObj = image;
        bannerModel.placholderImage = [HDHelper placeholderImageWithBgColor:HDAppTheme.color.G5 cornerRadius:0 size:CGSizeMake(kScreenWidth, kScreenWidth)
                                                                  logoImage:[UIImage imageNamed:@"sa_placeholder_image"]
                                                                   logoSize:CGSizeMake(100, 100)];
        bannerModel.cornerRadius = 0;
        [self.dataSource addObject:bannerModel];
    }

    [self.bannerView reloadData];

    if (self.dataSource.count > 1) {
        [self.pageNoLabel setHidden:NO];
        [self setPageNoWithIndex:self.model.currentPageIndex];
    } else {
        [self.pageNoLabel setHidden:YES];
    }

    if (HDIsStringNotEmpty(model.announcement)) {
        self.announcementBgView.hidden = false;
        self.announcementLabel.hidden = false;
        self.announcementLabel.text = model.announcement;
        self.announcementLabel.preferredMaxLayoutWidth = kScreenWidth - 50.f;
    } else {
        self.announcementBgView.hidden = true;
        self.announcementLabel.hidden = true;
    }
    self.freeShippingImageView.hidden = !([self.model.type isEqualToString:TNGoodsTypeOverseas] && model.isFreeShipping);
    self.honorLogoImageView.hidden = !model.isHonor;
    [self setNeedsUpdateConstraints];
}
#pragma mark - private methods
- (void)setGoodNameLabelText {
    if ([self.model.type isEqualToString:TNGoodsTypeOverseas]) {
        UIImage *globalImage = [UIImage imageNamed:@"tn_global_k"];
        NSString *name = [NSString stringWithFormat:@" %@", self.model.productName];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:name];
        NSTextAttachment *imageMent = [[NSTextAttachment alloc] init];
        imageMent.image = globalImage;
        UIFont *font = [HDAppTheme.TinhNowFont fontSemibold:15];
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
// 设置页码
- (void)setPageNoWithIndex:(NSUInteger)index {
    NSString *start = [NSString stringWithFormat:@"%zd", index];
    NSString *end = [NSString stringWithFormat:@"/%zd", self.dataSource.count];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[start stringByAppendingString:end]];
    [str addAttributes:@{NSFontAttributeName: HDAppTheme.TinhNowFont.standard15B, NSForegroundColorAttributeName: UIColor.whiteColor} range:NSMakeRange(0, start.length)];
    [str addAttributes:@{NSFontAttributeName: HDAppTheme.TinhNowFont.standard12, NSForegroundColorAttributeName: UIColor.whiteColor} range:NSMakeRange(start.length, end.length)];
    self.pageNoLabel.attributedText = str;
}

- (void)clickedImageHandler:(UITapGestureRecognizer *)recognizer {
    UIImageView *imageView = (UIImageView *)recognizer.view;
    if (imageView && [imageView isKindOfClass:UIImageView.class]) {
        NSInteger index = ((NSNumber *)(imageView.hd_associatedObject)).integerValue;
        [self showImageBrowserWithInitialProjectiveView:imageView index:index];
    }
}

#pragma mark - private methods
/// 展示图片浏览器
/// @param projectiveView 默认投影 View
/// @param index 默认起始索引
- (void)showImageBrowserWithInitialProjectiveView:(UIView *)projectiveView index:(NSUInteger)index {
    NSMutableArray<YBIBImageData *> *datas = [NSMutableArray array];

    for (TNImageModel *image in self.model.images) {
        YBIBImageData *data = [YBIBImageData new];
        data.imageURL = [NSURL URLWithString:image.source];
        // 这里固定只是从此处开始投影，滑动时会更新投影控件
        data.projectiveView = projectiveView;
        [datas addObject:data];
    }

    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = datas;
    browser.currentPage = index;
    browser.autoHideProjectiveView = false;
    browser.backgroundColor = HexColor(0x343B4C);

    HDImageBrowserToolViewHandler *toolViewHandler = HDImageBrowserToolViewHandler.new;
    toolViewHandler.sourceView = self.bannerView;
    toolViewHandler.saveImageResultBlock = ^(UIImage *_Nonnull image, NSError *_Nullable error) {
        if (error != NULL) {
            [NAT showToastWithTitle:nil content:WMLocalizedString(@"discover_show_image_save_failed", @"图片保存失败") type:HDTopToastTypeError];
        } else {
            [NAT showToastWithTitle:nil content:WMLocalizedString(@"discover_show_image_save_success", @"图片保存成功") type:HDTopToastTypeSuccess];
        }
    };
    //    toolViewHandler.updateProjectiveViewBlock = ^UIView *_Nonnull(NSUInteger index) {
    //        return index < self.model.images.count ? self.model.subviews[index] : self.imageContainer.subviews.lastObject;
    //    };
    browser.toolViewHandlers = @[toolViewHandler];

    [browser show];
}

#pragma mark - HDCylePageViewDelegate
- (NSInteger)numberOfItemsInPagerView:(HDCyclePagerView *)pageView {
    return self.dataSource.count;
}

- (UICollectionViewCell *)pagerView:(HDCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    id model = self.dataSource[index];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    if ([model isKindOfClass:[TNSingleVideoCollectionViewCellModel class]]) {
        TNSingleVideoCollectionViewCell *cell = [TNSingleVideoCollectionViewCell cellWithCollectionView:pagerView.collectionView forIndexPath:indexPath];
        cell.videoContentView.contentMode = UIViewContentModeScaleAspectFit;
        @HDWeakify(self);
        cell.videoPlayClickCallBack = ^(NSURL *_Nonnull url) {
            @HDStrongify(self);
            if (self.videoTapClick) {
                self.videoTapClick(pagerView, indexPath, model);
            }
        };
        cell.videoAutoPlayCallBack = ^(NSURL *_Nonnull url) {
            @HDStrongify(self);
            if (!self.model.hasAutoPLay) {
                self.model.hasAutoPLay = YES;
                if (self.videoTapClick) {
                    self.videoTapClick(pagerView, indexPath, model);
                }
            }
        };
        cell.model = model;
        return cell;
    } else {
        SASingleImageCollectionViewCell *cell = [SASingleImageCollectionViewCell cellWithCollectionView:pagerView.collectionView forIndexPath:indexPath];
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.model = model;
        return cell;
    }
}

- (void)pagerView:(HDCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index {
    if ([cell isKindOfClass:[SASingleImageCollectionViewCell class]]) {
        NSInteger currentIndex = index - self.model.videoList.count;
        SASingleImageCollectionViewCell *trueCell = (SASingleImageCollectionViewCell *)cell;
        [self showImageBrowserWithInitialProjectiveView:trueCell.imageView index:currentIndex];
    }
}

- (HDCyclePagerViewLayout *)layoutForPagerView:(HDCyclePagerView *)pageView {
    HDCyclePagerViewLayout *layout = [[HDCyclePagerViewLayout alloc] init];
    layout.layoutType = HDCyclePagerTransformLayoutNormal;
    const CGFloat width = self.bannerView.size.width;
    const CGFloat height = self.bannerView.size.height;
    layout.itemSpacing = 0;
    layout.itemSize = CGSizeMake(width, height);

    return layout;
}

- (void)pagerView:(HDCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    if (!self.pageNoLabel.isHidden) {
        [self setPageNoWithIndex:toIndex + 1];
        self.model.currentPageIndex = toIndex + 1;
    }
    if (self.pagerViewChangePage) {
        self.pagerViewChangePage(toIndex);
    }
}

#pragma mark - lazy load
- (HDCyclePagerView *)bannerView {
    if (!_bannerView) {
        _bannerView = HDCyclePagerView.new;
        _bannerView.autoScrollInterval = 0;
        _bannerView.isInfiniteLoop = NO;
        _bannerView.dataSource = self;
        _bannerView.delegate = self;
        [_bannerView registerClass:SASingleImageCollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(SASingleImageCollectionViewCell.class)];
    }
    return _bannerView;
}

/** @lazy pageNolabel */
- (HDLabel *)pageNoLabel {
    if (!_pageNoLabel) {
        _pageNoLabel = [[HDLabel alloc] init];
        _pageNoLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _pageNoLabel.hd_edgeInsets = UIEdgeInsetsMake(2, 8, 2, 8);
        _pageNoLabel.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.cornerRadius = precedingFrame.size.height / 2.0;
            view.layer.masksToBounds = YES;
        };
    }
    return _pageNoLabel;
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

- (UILabel *)announcementLabel {
    if (!_announcementLabel) {
        _announcementLabel = [[UILabel alloc] init];
        _announcementLabel.textColor = HDAppTheme.TinhNowColor.cFA3A18;
        _announcementLabel.font = HDAppTheme.TinhNowFont.standard12M;
        _announcementLabel.numberOfLines = 0;
        _announcementLabel.hidden = true;
    }
    return _announcementLabel;
}

- (UIView *)announcementBgView {
    if (!_announcementBgView) {
        _announcementBgView = [[UIView alloc] init];
        _announcementBgView.backgroundColor = [HDAppTheme.TinhNowColor.cFF8824 colorWithAlphaComponent:0.1f];
        _announcementBgView.hidden = true;
        _announcementBgView.layer.cornerRadius = 4.f;
    }
    return _announcementBgView;
}
/** @lazy freeShippingImageView */
- (UIImageView *)freeShippingImageView {
    if (!_freeShippingImageView) {
        _freeShippingImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tn_freeshipping"]];
        _freeShippingImageView.hidden = YES;
    }
    return _freeShippingImageView;
}

/** @lazy priceView */
- (TNProductDetailPriceView *)priceView {
    if (!_priceView) {
        _priceView = [[TNProductDetailPriceView alloc] init];
    }
    return _priceView;
}
/** @lazy honorLogoImageView */
- (UIImageView *)honorLogoImageView {
    if (!_honorLogoImageView) {
        NSString *imageName = [NSString stringWithFormat:@"%@_%@", @"tn_highquality_store", [TNMultiLanguageManager currentLanguage]];
        _honorLogoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        _honorLogoImageView.hidden = YES;
    }
    return _honorLogoImageView;
}
@end


@implementation TNProductDetailsIntroTableViewCellModel

@end
