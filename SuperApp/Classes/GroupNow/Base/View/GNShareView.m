//
//  GNShareView.m
//  SuperApp
//
//  Created by wmz on 2022/4/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNShareView.h"
#import "GNCouPonImageView.h"
#import "SAAddressModel.h"
#import <HDKitCore/HDKitCore.h>


@interface GNShareView ()
/// contentView
@property (nonatomic, strong) UIView *contentView;

@end


@implementation GNShareView

- (void)addSharePorductView {
    self.contentView = UIView.new;
    self.contentView.backgroundColor = HDAppTheme.color.gn_whiteColor;
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
    }];

    GNCouPonImageView *logoView = GNCouPonImageView.new;
    logoView.contentMode = UIViewContentModeScaleAspectFill;
    logoView.clipsToBounds = YES;
    [self.contentView addSubview:logoView];
    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.width.height.mas_equalTo(kScreenWidth - kRealWidth(80));
    }];
    if ([self.productModel.type.codeId isEqualToString:GNProductTypeP2]) {
        logoView.couponLB.text = GNFillEmpty(self.productModel.name.desc);
        logoView.couponLB.font = [HDAppTheme.font gn_boldForSize:26];
        logoView.couponLB.textColor = [UIColor hd_colorWithHexString:@"#C5591A"];
        logoView.image = [UIImage imageNamed:@"gn_product_share"];
        logoView.couponLB.hidden = NO;
    } else {
        logoView.couponLB.text = @"";
        [logoView sd_setImageWithURL:[NSURL URLWithString:self.productModel.imagePathArr.firstObject] placeholderImage:HDHelper.placeholderImage];
        logoView.couponLB.hidden = YES;
    }

    UIView *cover = UIView.new;
    cover.backgroundColor = [HDAppTheme.color gn_ColorGradientChangeWithSize:CGSizeMake(kScreenWidth - kRealWidth(80), kScreenWidth - kRealWidth(80)) direction:GNGradientChangeDirectionVertical
                                                                  startColor:[UIColor hd_colorWithHexString:@"#33000000"]
                                                                    endColor:HDAppTheme.color.gn_000000];
    [self.contentView addSubview:cover];
    [cover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(logoView);
    }];

    HDLabel *normalPrice = HDLabel.new;
    normalPrice.textColor = [UIColor hd_colorWithHexString:@"#FFFCFC"];
    normalPrice.font = [HDAppTheme.font gn_ForSize:15];
    [self.contentView addSubview:normalPrice];
    [normalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(kRealWidth(-15));
        make.bottom.equalTo(logoView.mas_bottom).offset(-kRealWidth(24));
    }];
    NSMutableAttributedString *priceMstr = nil;
    if ((!self.productModel.originalPrice || [self.productModel.originalPrice isKindOfClass:NSNull.class] || self.productModel.originalPrice.doubleValue == self.productModel.price.doubleValue)) {
        priceMstr = [[NSMutableAttributedString alloc] initWithString:GNFillMonEmpty(self.productModel.price)];
        [GNStringUntils attributedString:priceMstr color:HDAppTheme.color.gn_mainColor colorRange:priceMstr.string];
        [GNStringUntils attributedString:priceMstr font:[HDAppTheme.font gn_boldForSize:30] fontRange:priceMstr.string];
        [GNStringUntils attributedString:priceMstr font:[HDAppTheme.font gn_ForSize:12] fontRange:@"$"];
    } else {
        NSString *priceStr = GNFillMonEmpty(self.productModel.price);
        NSString *originStr = GNFillMonEmpty(self.productModel.originalPrice);
        priceMstr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", priceStr, originStr]];
        [GNStringUntils attributedString:priceMstr color:HDAppTheme.color.gn_mainColor colorRange:priceStr];
        [GNStringUntils attributedString:priceMstr font:[HDAppTheme.font gn_boldForSize:30] fontRange:priceStr];
        [GNStringUntils attributedString:priceMstr font:[HDAppTheme.font gn_ForSize:12] fontRange:@"$"];
        [GNStringUntils attributedString:priceMstr color:HDAppTheme.color.gn_BBBBBB colorRange:originStr];
        [GNStringUntils attributedString:priceMstr center:YES colorRange:originStr];
        [GNStringUntils attributedString:priceMstr font:[HDAppTheme.font gn_ForSize:15] fontRange:@"$"];
    }
    normalPrice.attributedText = priceMstr;

    UIView *line = UIView.new;
    line.backgroundColor = HDAppTheme.color.gn_whiteColor;
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(normalPrice.mas_left).offset(-kRealWidth(18));
        make.centerY.equalTo(normalPrice.mas_centerY);
        make.width.mas_equalTo(0.5);
        make.height.mas_equalTo(kRealWidth(30));
    }];

    HDLabel *productNameLB = HDLabel.new;
    productNameLB.numberOfLines = 3;
    productNameLB.textColor = HDAppTheme.color.gn_whiteColor;
    productNameLB.font = [HDAppTheme.font gn_ForSize:14];
    productNameLB.text = self.productModel.name.desc;
    [self.contentView addSubview:productNameLB];
    [productNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(15));
        make.right.equalTo(line.mas_left).offset(-kRealWidth(18));
        make.centerY.equalTo(normalPrice.mas_centerY);
    }];

    [productNameLB setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    [productNameLB setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];

    UIView *storeView = UIView.new;
    storeView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:storeView];
    [storeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(15));
        make.right.mas_equalTo(kRealWidth(-15));
        make.top.equalTo(logoView.mas_bottom).offset(kRealWidth(25));
        make.bottom.mas_equalTo(-1);
    }];
    storeView.layer.borderWidth = 1;
    storeView.layer.borderColor = [UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:0.86].CGColor;
    storeView.layer.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:0.6].CGColor;
    storeView.layer.shadowColor = [UIColor colorWithRed:216 / 255.0 green:216 / 255.0 blue:216 / 255.0 alpha:0.26].CGColor;
    storeView.layer.shadowOffset = CGSizeMake(0, 2);
    storeView.layer.shadowOpacity = 1;
    storeView.layer.cornerRadius = kRealWidth(4);
    storeView.layer.shadowRadius = kRealWidth(4);

    UIImageView *storeLogo = UIImageView.new;
    [storeLogo sd_setImageWithURL:[NSURL URLWithString:self.storeModel.logo] placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(50), kRealWidth(50))]];
    [storeView addSubview:storeLogo];
    [storeLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(kRealWidth(10));
        make.width.mas_equalTo(kRealWidth(50));
        make.height.equalTo(storeLogo.mas_width);
    }];
    [storeLogo setHd_frameDidChangeBlock:^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        view.layer.cornerRadius = kRealWidth(8);
        view.clipsToBounds = YES;
    }];

    HDLabel *storeNameLB = HDLabel.new;
    storeNameLB.textColor = HDAppTheme.color.gn_333Color;
    storeNameLB.font = [HDAppTheme.font gn_ForSize:12];
    storeNameLB.text = GNFillEmpty(self.storeModel.storeName.desc);
    [storeView addSubview:storeNameLB];
    [storeNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(storeLogo.mas_right).offset(kRealWidth(10));
        make.top.equalTo(storeLogo);
        make.right.mas_equalTo(-kRealWidth(15));
    }];

    HDUIButton *starBTN = [HDUIButton buttonWithType:UIButtonTypeCustom];
    [starBTN setImage:[UIImage imageNamed:@"gn_home_star_sel"] forState:UIControlStateNormal];
    starBTN.titleLabel.font = [HDAppTheme.font gn_ForSize:12];
    [starBTN setTitleColor:HDAppTheme.color.gn_333Color forState:UIControlStateNormal];
    [starBTN setTitle:self.storeModel.score ? [NSString stringWithFormat:@"%.1f", self.storeModel.score.doubleValue] : GNLocalizedString(@"gn_no_ratings_yet", @"暂无评分")
             forState:UIControlStateNormal];
    starBTN.imagePosition = HDUIButtonImagePositionLeft;
    starBTN.spacingBetweenImageAndTitle = kRealWidth(2);
    [storeView addSubview:starBTN];
    [starBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(storeNameLB);
        make.bottom.equalTo(storeLogo.mas_bottom).offset(-kRealWidth(5.5));
    }];

    HDLabel *persionLB = HDLabel.new;
    persionLB.textColor = HDAppTheme.color.gn_999Color;
    persionLB.font = [HDAppTheme.font gn_ForSize:12];
    if (self.storeModel.perCapita) {
        persionLB.text = [GNLocalizedString(@"gn_per_capita", @"人均") stringByAppendingString:GNFillMonEmpty(self.storeModel.perCapita)];
    } else {
        persionLB.text = @" ";
    }
    [storeView addSubview:persionLB];
    [persionLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(storeNameLB);
        make.top.equalTo(starBTN.mas_bottom).offset(kRealWidth(5));
        make.bottom.mas_equalTo(-kRealWidth(10));
    }];

    HDLabel *areaLB = HDLabel.new;
    areaLB.textColor = HDAppTheme.color.gn_999Color;
    areaLB.font = [HDAppTheme.font gn_ForSize:12];
    areaLB.text = GNFillEmpty(self.storeModel.commercialDistrictName.desc);
    [storeView addSubview:areaLB];
    [areaLB mas_makeConstraints:^(MASConstraintMaker *make) {
        if (!self.storeModel.perCapita) {
            make.left.equalTo(storeNameLB);
        } else {
            make.left.equalTo(persionLB.mas_right).offset(kRealWidth(10));
        }
        make.right.equalTo(storeView.mas_right).offset(-kRealWidth(5));
        make.centerY.equalTo(persionLB);
    }];
    [persionLB setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [persionLB setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self addBottomView:GNShareViewTypeProduct];
}

- (void)addShareStoreView {
    self.contentView = UIView.new;
    self.contentView.backgroundColor = HDAppTheme.color.gn_whiteColor;
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
    }];

    CGSize size = CGSizeMake(kScreenWidth - kRealWidth(80), (kScreenWidth - kRealWidth(80)) / 2.0);
    UIImageView *logoView = UIImageView.new;
    [logoView sd_setImageWithURL:[NSURL URLWithString:self.storeModel.signboardPhoto] placeholderImage:[HDHelper placeholderImageWithCornerRadius:0 size:size logoSize:CGSizeMake(30, 30)]];
    logoView.contentMode = UIViewContentModeScaleAspectFill;
    logoView.clipsToBounds = YES;
    [self.contentView addSubview:logoView];
    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.size.mas_equalTo(size);
    }];

    HDLabel *storeNameLB = HDLabel.new;
    storeNameLB.textColor = HDAppTheme.color.gn_333Color;
    storeNameLB.font = [HDAppTheme.font gn_ForSize:12];
    storeNameLB.text = GNFillEmpty(self.storeModel.storeName.desc);
    storeNameLB.numberOfLines = 2;
    [self.contentView addSubview:storeNameLB];
    [storeNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(15));
        make.top.equalTo(logoView.mas_bottom).offset(kRealWidth(25));
        make.right.mas_equalTo(-kRealWidth(15));
    }];

    HDUIButton *starBTN = [HDUIButton buttonWithType:UIButtonTypeCustom];
    [starBTN setImage:[UIImage imageNamed:@"gn_home_star_sel"] forState:UIControlStateNormal];
    starBTN.titleLabel.font = [HDAppTheme.font gn_ForSize:12];
    [starBTN setTitleColor:HDAppTheme.color.gn_333Color forState:UIControlStateNormal];
    [starBTN setTitle:self.storeModel.score ? [NSString stringWithFormat:@"%.1f", self.storeModel.score.doubleValue] : GNLocalizedString(@"gn_no_ratings_yet", @"暂无评分")
             forState:UIControlStateNormal];
    starBTN.imagePosition = HDUIButtonImagePositionLeft;
    starBTN.spacingBetweenImageAndTitle = kRealWidth(2);
    [self.contentView addSubview:starBTN];
    [starBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(storeNameLB);
        make.top.equalTo(storeNameLB.mas_bottom).offset(kRealWidth(7.5));
        make.bottom.mas_equalTo(-1);
    }];

    HDLabel *areaLB = HDLabel.new;
    areaLB.textColor = HDAppTheme.color.gn_999Color;
    areaLB.font = [HDAppTheme.font gn_ForSize:12];
    areaLB.text = GNFillEmpty(self.storeModel.commercialDistrictName.desc);
    [self.contentView addSubview:areaLB];
    [areaLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(storeNameLB);
        make.centerY.equalTo(starBTN.mas_centerY);
    }];
    [areaLB setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [starBTN setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    HDLabel *persionLB = HDLabel.new;
    persionLB.textColor = HDAppTheme.color.gn_999Color;
    persionLB.font = [HDAppTheme.font gn_ForSize:12];
    if (self.storeModel.perCapita) {
        persionLB.text = [GNLocalizedString(@"gn_per_capita", @"人均") stringByAppendingString:GNFillMonEmpty(self.storeModel.perCapita)];
    } else {
        persionLB.text = @"";
    }
    [self.contentView addSubview:persionLB];
    [persionLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(starBTN.mas_right).offset(kRealWidth(8));
        make.right.equalTo(areaLB.mas_left).offset(-kRealWidth(5));
        make.centerY.equalTo(starBTN.mas_centerY);
    }];

    [self addBottomView:GNShareViewTypeStore];
}

- (void)addBottomView:(GNShareViewType)type {
    UIView *bottomView = UIView.new;
    bottomView.backgroundColor = HDAppTheme.color.gn_whiteColor;
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];

    UIImageView *codeIV = UIImageView.new;
    [bottomView addSubview:codeIV];
    [codeIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(22));
        make.top.mas_equalTo(kRealWidth(30));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(46), kRealWidth(46)));
    }];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *qrCodeImage = [HDCodeGenerator qrCodeImageForStr:self.codeURL ?: @"" size:CGSizeMake(kRealWidth(50), kRealWidth(50)) level:HDInputCorrectionLevelL];
        dispatch_async(dispatch_get_main_queue(), ^{
            codeIV.image = qrCodeImage;
        });
    });

    UIImageView *logoIV = UIImageView.new;
    logoIV.image = [UIImage imageNamed:@"AppIcon"];
    logoIV.layer.cornerRadius = kRealWidth(4);
    logoIV.clipsToBounds = YES;
    [bottomView addSubview:logoIV];
    [logoIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kRealWidth(22));
        make.centerY.equalTo(codeIV);
        make.size.mas_equalTo(CGSizeMake(kRealWidth(48), kRealWidth(48)));
    }];

    HDLabel *oneLB = HDLabel.new;
    oneLB.numberOfLines = 0;
    oneLB.textColor = [UIColor hd_colorWithHexString:@"#99333333"];
    ;
    oneLB.font = [HDAppTheme.font gn_ForSize:11];
    oneLB.text = GNLocalizedString(@"gn_share_pictures", @"① 分享图片给朋友");
    [bottomView addSubview:oneLB];
    [oneLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRealWidth(28));
        make.left.equalTo(codeIV.mas_right).offset(kRealWidth(20));
        make.right.equalTo(logoIV.mas_left).offset(-kRealWidth(5));
    }];

    HDLabel *twoLB = HDLabel.new;
    twoLB.textColor = [UIColor hd_colorWithHexString:@"#99333333"];
    ;
    twoLB.numberOfLines = 0;
    twoLB.font = [HDAppTheme.font gn_ForSize:11];
    twoLB.text = GNLocalizedString(@"gn_friend_qr", @"② 好友识别图中二维码");
    [bottomView addSubview:twoLB];
    [twoLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oneLB.mas_bottom).offset(kRealWidth(6.5));
        make.left.right.equalTo(oneLB);
    }];

    HDLabel *threeLB = HDLabel.new;
    threeLB.numberOfLines = 0;
    threeLB.textColor = [UIColor hd_colorWithHexString:@"#99333333"];
    ;
    threeLB.font = [HDAppTheme.font gn_ForSize:11];
    threeLB.text = GNLocalizedString(@"gn_open_wownow", @"③ 打开WOWNOW");
    [bottomView addSubview:threeLB];
    [threeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(twoLB.mas_bottom).offset(kRealWidth(6.5));
        make.left.right.equalTo(oneLB);
        make.bottom.mas_equalTo(-kRealWidth(25));
    }];

    [threeLB layoutIfNeeded];
    [bottomView layoutIfNeeded];
    self.frame = CGRectMake(0, 0, kScreenWidth - kRealWidth(80), CGRectGetMaxY(bottomView.frame));
    self.layer.cornerRadius = kRealWidth(10);
    self.layer.masksToBounds = YES;
    if (self.productModel) {
        self.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } else {
        self.transform = CGAffineTransformMakeScale(0.9, 0.9);
    }
}

@end
