//
//  GNTopicProductCell.m
//  SuperApp
//
//  Created by wmz on 2022/2/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNTopicProductCell.h"
#import "GNCouPonImageView.h"
#import "GNMultiLanguageManager.h"
#import "GNTheme.h"
#import "HDMediator+GroupOn.h"


@interface GNTopicProductCell ()
/// bg
@property (nonatomic, strong) UIView *bgView;
///商品图片
@property (nonatomic, strong) GNCouPonImageView *iconIV;
///商品名字
@property (nonatomic, strong) SALabel *nameLb;
///限购
@property (nonatomic, strong) SALabel *limitLB;
///线
@property (nonatomic, strong) UIView *leftIV;
///线
@property (nonatomic, strong) UIView *bottomIV;
///已售
@property (nonatomic, strong) SALabel *soldLB;
///售价
@property (nonatomic, strong) SALabel *priceLB;
///原价
@property (nonatomic, strong) SALabel *orginLB;
///评分图标
@property (nonatomic, strong) HDUIButton *rateBTN;
///评分内容
@property (nonatomic, strong) SALabel *rateLB;
///商家图片
@property (nonatomic, strong) UIImageView *shopIV;
///商家名字
@property (nonatomic, strong) SALabel *shopLB;

@end


@implementation GNTopicProductCell

- (void)hd_setupViews {
    self.bgView.layer.cornerRadius = kRealWidth(12);
    self.bgView.layer.backgroundColor = HDAppTheme.color.gn_whiteColor.CGColor;
    self.bgView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.bgView];

    [self.bgView addSubview:self.iconIV];
    [self.bgView addSubview:self.nameLb];
    [self.bgView addSubview:self.limitLB];
    [self.bgView addSubview:self.leftIV];
    [self.bgView addSubview:self.soldLB];
    [self.bgView addSubview:self.priceLB];
    [self.bgView addSubview:self.orginLB];
    [self.bgView addSubview:self.rateBTN];
    [self.bgView addSubview:self.rateLB];
    [self.bgView addSubview:self.shopIV];
    [self.bgView addSubview:self.shopLB];
    [self.bgView addSubview:self.bottomIV];
}

- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.mas_equalTo(0);
    }];

    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.equalTo(self.iconIV.mas_width).multipliedBy(1);
    }];

    [self.nameLb mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(10));
        make.right.mas_equalTo(kRealWidth(-10));
        make.top.equalTo(self.iconIV.mas_bottom).offset(kRealWidth(10));
    }];

    [self.priceLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.soldLB.mas_bottom).offset(kRealWidth(6.5));
        make.left.equalTo(self.nameLb);
    }];

    [self.orginLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.priceLB);
        make.left.equalTo(self.priceLB.mas_right).offset(kRealWidth(2));
    }];

    [self.bottomIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0.6);
        make.top.equalTo(self.priceLB.mas_bottom).offset(kRealWidth(6.5));
    }];

    [self.shopIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLb);
        make.top.equalTo(self.bottomIV.mas_bottom).offset(kRealWidth(6.5));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(40), kRealWidth(40)));
    }];

    [self.shopLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shopIV.mas_right).offset(kRealWidth(9));
        make.top.equalTo(self.shopIV.mas_top).offset(kRealWidth(3));
        make.right.mas_offset(-kRealWidth(7.5));
    }];

    [self updateUI];

    [super updateConstraints];
}

- (void)updateUI {
    [self.limitLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.limitLB.isHidden) {
            make.left.equalTo(self.nameLb.mas_left);
            make.top.equalTo(self.nameLb.mas_bottom).offset(kRealWidth(7));
        }
    }];

    [self.leftIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.leftIV.isHidden) {
            make.left.equalTo(self.limitLB.mas_right).offset(kRealWidth(5));
            make.width.mas_equalTo(0.8);
            make.centerY.equalTo(self.limitLB);
            make.height.mas_equalTo(kRealHeight(11));
        }
    }];

    [self.soldLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.leftIV.isHidden) {
            make.left.equalTo(self.leftIV.mas_right).offset(kRealWidth(5));
        } else {
            make.left.equalTo(self.nameLb.mas_left);
        }
        make.top.equalTo(self.nameLb.mas_bottom).offset(kRealWidth(7));
    }];

    [self.rateBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.rateBTN.hidden) {
            make.left.equalTo(self.shopLB);
            make.size.mas_equalTo(self.rateBTN.imageView.image.size);
            make.top.equalTo(self.shopLB.mas_bottom).offset(kRealWidth(5));
        }
    }];

    [self.rateLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.rateLB.hidden) {
            make.left.equalTo(self.rateBTN.mas_right).offset(kRealWidth(4));
            make.centerY.equalTo(self.rateBTN);
        }
    }];
}

- (void)setGNModel:(GNProductModel *)data {
    self.model = data;

    if ([data.type.codeId isEqualToString:GNProductTypeP2]) {
        self.iconIV.image = [UIImage imageNamed:@"gn_storeinfo_coupon"];
    } else {
        [self.iconIV sd_setImageWithURL:[NSURL URLWithString:data.imagePath]
                       placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake((kDeviceWidth - kRealWidth(40)) / 2, (kDeviceWidth - kRealWidth(40)) / 2) logoWidth:kRealWidth(64)]];
    }
    self.limitLB.text = (data.whetherHomePurchaseRestrictions == GNHomePurchaseRestrictionsTypeCan) ?
                            [NSString stringWithFormat:GNLocalizedString(@"gn_store_limited", @"每单限购%ld份"), data.homePurchaseRestrictions] :
                            @"";
    self.nameLb.text = GNFillEmptySpace(data.name.desc);
    self.leftIV.hidden = (data.whetherHomePurchaseRestrictions != GNHomePurchaseRestrictionsTypeCan);
    self.limitLB.hidden = (data.whetherHomePurchaseRestrictions != GNHomePurchaseRestrictionsTypeCan);
    self.soldLB.text = [NSString stringWithFormat:@"%@ %ld", GNLocalizedString(@"gn_store_sold", @"已售"), data.consumptionOrderCodeNum];

    NSMutableAttributedString *priceStr = [[NSMutableAttributedString alloc] initWithString:GNFillMonEmpty(data.price)];
    NSMutableAttributedString *originalPriceStr = [[NSMutableAttributedString alloc] initWithString:GNFillMonEmpty(data.originalPrice)];
    [GNStringUntils attributedString:priceStr color:HDAppTheme.color.gn_mainColor colorRange:priceStr.string];
    [GNStringUntils attributedString:priceStr font:[HDAppTheme.font gn_boldForSize:20] fontRange:priceStr.string];
    [GNStringUntils attributedString:priceStr font:[HDAppTheme.font gn_ForSize:12] fontRange:@"$"];
    [GNStringUntils attributedString:originalPriceStr font:[HDAppTheme.font gn_ForSize:12] fontRange:originalPriceStr.string];
    [GNStringUntils attributedString:originalPriceStr color:[UIColor hd_colorWithHexString:@"#BBBBBB"] colorRange:originalPriceStr.string];
    [GNStringUntils attributedString:originalPriceStr center:YES colorRange:originalPriceStr.string];
    self.orginLB.attributedText = originalPriceStr;
    self.priceLB.attributedText = priceStr;
    self.orginLB.hidden = (!data.originalPrice || [data.originalPrice isKindOfClass:NSNull.class] || data.originalPrice.doubleValue == data.price.doubleValue);

    self.rateLB.text = data.storeScore ? [NSString stringWithFormat:@"%.1f", data.storeScore.doubleValue] : GNLocalizedString(@"gn_no_ratings_yet", @"暂无评分");
    self.shopLB.text = GNFillEmptySpace(data.storeName.desc);
    [self.shopIV sd_setImageWithURL:[NSURL URLWithString:data.storeLogo] placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(40), kRealWidth(40)) logoWidth:kRealWidth(64)]];
    [self updateUI];
}

- (void)storeClickz:(UITapGestureRecognizer *)ta {
    [self.viewController.view endEditing:YES];
    [HDMediator.sharedInstance navigaveToGNStoreProductViewController:@{
        @"storeNo": GNFillEmpty(self.model.storeNo),
        @"productCode": GNFillEmpty(self.model.codeId),
    }];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = UIView.new;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(storeClickz:)];
        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}

- (GNCouPonImageView *)iconIV {
    if (!_iconIV) {
        _iconIV = [GNCouPonImageView new];
        _iconIV.layer.cornerRadius = kRealWidth(4);
        _iconIV.couponLB.hidden = YES;
    }
    return _iconIV;
}

- (SALabel *)nameLb {
    if (!_nameLb) {
        SALabel *la = SALabel.new;
        la.textColor = HDAppTheme.color.gn_333Color;
        la.font = [HDAppTheme.font gn_boldForSize:14];
        la.numberOfLines = 2;
        _nameLb = la;
    }
    return _nameLb;
}

- (SALabel *)limitLB {
    if (!_limitLB) {
        SALabel *la = SALabel.new;
        la.textColor = [UIColor hd_colorWithHexString:@"#A6A6A6"];
        la.font = [HDAppTheme.font gn_ForSize:10];
        _limitLB = la;
    }
    return _limitLB;
}

- (SALabel *)soldLB {
    if (!_soldLB) {
        SALabel *la = SALabel.new;
        la.textColor = [UIColor hd_colorWithHexString:@"#A6A6A6"];
        la.font = [HDAppTheme.font gn_ForSize:10];
        _soldLB = la;
    }
    return _soldLB;
}

- (UIView *)leftIV {
    if (!_leftIV) {
        _leftIV = UIView.new;
        _leftIV.backgroundColor = HDAppTheme.color.gn_lineColor;
    }
    return _leftIV;
}

- (UIView *)bottomIV {
    if (!_bottomIV) {
        _bottomIV = UIView.new;
        _bottomIV.backgroundColor = HDAppTheme.color.gn_lineColor;
    }
    return _bottomIV;
}

- (SALabel *)priceLB {
    if (!_priceLB) {
        _priceLB = SALabel.new;
    }
    return _priceLB;
}

- (SALabel *)orginLB {
    if (!_orginLB) {
        _orginLB = SALabel.new;
    }
    return _orginLB;
}

- (UIImageView *)shopIV {
    if (!_shopIV) {
        _shopIV = [UIImageView new];
        _shopIV.layer.cornerRadius = HDAppTheme.value.gn_radius8;
        _shopIV.layer.masksToBounds = YES;
    }
    return _shopIV;
}

- (SALabel *)shopLB {
    if (!_shopLB) {
        SALabel *la = SALabel.new;
        la.textColor = HDAppTheme.color.gn_333Color;
        la.font = [HDAppTheme.font gn_boldForSize:11.5];
        _shopLB = la;
    }
    return _shopLB;
}

- (SALabel *)rateLB {
    if (!_rateLB) {
        _rateLB = SALabel.new;
        _rateLB.textColor = HDAppTheme.color.gn_mainColor;
        _rateLB.font = [HDAppTheme.font boldForSize:11];
    }
    return _rateLB;
}

- (HDUIButton *)rateBTN {
    if (!_rateBTN) {
        _rateBTN = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_rateBTN setImage:[UIImage imageNamed:@"gn_home_star_sel"] forState:UIControlStateNormal];
    }
    return _rateBTN;
}

@end
