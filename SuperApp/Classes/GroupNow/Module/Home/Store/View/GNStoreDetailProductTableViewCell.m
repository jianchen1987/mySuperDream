//
//  GNStoreDetailProductTableViewCell.m
//  SuperApp
//
//  Created by wmz on 2021/6/7.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNStoreDetailProductTableViewCell.h"


@interface GNStoreDetailProductTableViewCell ()

///商品图片
@property (nonatomic, strong) UIImageView *iconIV;
///商品名字
@property (nonatomic, strong) HDLabel *nameLB;
///限购
@property (nonatomic, strong) HDLabel *limitLB;
///已售数量
@property (nonatomic, strong) HDLabel *amountLB;
///价格
@property (nonatomic, strong) HDLabel *priceLB;
///实际价格
@property (nonatomic, strong) HDLabel *saleLB;
///购买
@property (nonatomic, strong) HDUIButton *buyBtn;
///背景图片
@property (nonatomic, strong) UIImageView *bgIV;

@end


@implementation GNStoreDetailProductTableViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.bgIV];
    [self.bgIV addSubview:self.iconIV];
    [self.bgIV addSubview:self.nameLB];
    [self.bgIV addSubview:self.amountLB];
    [self.bgIV addSubview:self.limitLB];
    [self.bgIV addSubview:self.priceLB];
    [self.bgIV addSubview:self.saleLB];
    [self.bgIV addSubview:self.buyBtn];
}

- (void)updateConstraints {
    [self.bgIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(kRealWidth(8));
        make.bottom.mas_equalTo(-kRealWidth(4));
    }];

    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealWidth(80), kRealWidth(80)));
        make.left.mas_equalTo(kRealWidth(12));
        make.top.mas_equalTo(kRealWidth(8));
        make.bottom.mas_equalTo(-kRealWidth(8));
    }];

    [self.buyBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-kRealWidth(12));
        make.height.mas_equalTo(kRealWidth(28));
    }];

    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(8));
        make.top.equalTo(self.iconIV.mas_top);
        make.height.mas_equalTo(kRealWidth(24));
        make.right.mas_equalTo(-HDAppTheme.value.gn_marginL);
    }];

    [self.limitLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLB);
        make.top.equalTo(self.nameLB.mas_bottom);
        make.right.equalTo(self.buyBtn.mas_left).offset(-kRealWidth(12));
    }];

    [self.saleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLB);
        make.width.lessThanOrEqualTo(self.mas_width).multipliedBy(0.35);
        make.bottom.equalTo(self.iconIV.mas_bottom);
    }];

    [self.priceLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.saleLB.mas_right).offset(kRealWidth(4));
        make.width.lessThanOrEqualTo(self.mas_width).multipliedBy(0.35);
        make.centerY.equalTo(self.saleLB);
    }];

    [self.amountLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.buyBtn);
        make.top.equalTo(self.buyBtn.mas_bottom).offset(kRealHeight(2));
        make.height.mas_equalTo(kRealWidth(18));
    }];

    [self.limitLB setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    [self.limitLB setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    [self.priceLB setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];

    [super updateConstraints];
}

- (void)setGNModel:(GNProductModel *)data {
    self.model = data;
    self.amountLB.text = [NSString stringWithFormat:@"%@ %ld", GNLocalizedString(@"gn_store_sold", @"已售"), data.consumptionOrderCodeNum];
    self.nameLB.text = data.name.desc;
    self.limitLB.text = (data.whetherHomePurchaseRestrictions == GNHomePurchaseRestrictionsTypeCan) ?
                            [NSString stringWithFormat:GNLocalizedString(@"gn_store_limited", @"每单限购%ld份"), data.homePurchaseRestrictions] :
                            @"";
    self.saleLB.text = GNFillMonEmpty(data.price);
    BOOL enable = data.isTermOfValidity;
    NSString *showTitle = enable ? GNLocalizedString(@"gn_store_buying", @"抢购") : GNLocalizedString(@"gn_not_active", @"未生效");
    if (data.isTermOfValidity && data.isSoldOut) {
        enable = NO;
        showTitle = GNLocalizedString(@"gn_sold_out", @"已售罄");
    }
    [self.buyBtn setTitle:showTitle forState:UIControlStateNormal];
    self.buyBtn.userInteractionEnabled = enable;
    self.buyBtn.layer.backgroundColor = enable ? HDAppTheme.color.gn_mainColor.CGColor : HDAppTheme.color.gn_mainColor70.CGColor;
    self.buyBtn.titleLabel.font = [HDAppTheme.font gn_ForSize:14 weight:UIFontWeightHeavy];
    NSDictionary *attribtDic1 = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr1 = [[NSMutableAttributedString alloc] initWithString:GNFillMonEmpty(data.originalPrice) attributes:attribtDic1];
    self.priceLB.attributedText = attribtStr1;
    self.priceLB.hidden = (!data.originalPrice || [data.originalPrice isKindOfClass:NSNull.class] || data.originalPrice.doubleValue == data.price.doubleValue);

    BOOL GP002 = (self.model.type && [self.model.type.codeId isEqualToString:GNProductTypeP2]);
    if (GP002) {
        self.iconIV.image = [UIImage imageNamed:@"gn_storeinfo_coupon"];
    } else {
        [self.iconIV sd_setImageWithURL:[NSURL URLWithString:data.imagePath] placeholderImage:HDHelper.placeholderImage];
    }
    [self setNeedsUpdateConstraints];
}

- (void)buyAction:(HDUIButton *)sender {
    [GNEvent eventResponder:self target:sender key:@"buyAction" indexPath:nil info:[NSDictionary dictionaryWithObjectsAndKeys:self.model.codeId, @"code", nil]];
}

- (HDLabel *)amountLB {
    if (!_amountLB) {
        _amountLB = HDLabel.new;
        _amountLB.textAlignment = NSTextAlignmentCenter;
        _amountLB.textColor = HDAppTheme.color.gn_333Color;
        _amountLB.font = HDAppTheme.font.gn_12;
    }
    return _amountLB;
}

- (HDLabel *)priceLB {
    if (!_priceLB) {
        _priceLB = HDLabel.new;
        _priceLB.textColor = HDAppTheme.color.gn_999Color;
        _priceLB.font = [HDAppTheme.font gn_ForSize:12];
    }
    return _priceLB;
}

- (HDLabel *)limitLB {
    if (!_limitLB) {
        _limitLB = HDLabel.new;
        _limitLB.numberOfLines = 2;
        _limitLB.textColor = HDAppTheme.color.gn_999Color;
        _limitLB.font = [HDAppTheme.font gn_ForSize:12];
    }
    return _limitLB;
}

- (HDLabel *)nameLB {
    if (!_nameLB) {
        _nameLB = HDLabel.new;
        _nameLB.textColor = HDAppTheme.color.gn_333Color;
        _nameLB.font = [HDAppTheme.font gn_boldForSize:16];
    }
    return _nameLB;
}

- (UIImageView *)iconIV {
    if (!_iconIV) {
        _iconIV = UIImageView.new;
        _iconIV.layer.cornerRadius = HDAppTheme.value.gn_radius8;
        _iconIV.clipsToBounds = YES;
    }
    return _iconIV;
}

- (HDUIButton *)buyBtn {
    if (!_buyBtn) {
        _buyBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _buyBtn.layer.cornerRadius = kRealWidth(14);
        _buyBtn.contentEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(16), 0, kRealWidth(16));
        [_buyBtn setTitleColor:HDAppTheme.color.gn_whiteColor forState:UIControlStateNormal];
        _buyBtn.layer.backgroundColor = HDAppTheme.color.gn_mainColor.CGColor;
        [_buyBtn addTarget:self action:@selector(buyAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buyBtn;
}

- (HDLabel *)saleLB {
    if (!_saleLB) {
        _saleLB = HDLabel.new;
        _saleLB.textColor = HDAppTheme.color.gn_mainColor;
        _saleLB.font = [HDAppTheme.font gn_ForSize:14 weight:UIFontWeightHeavy];
    }
    return _saleLB;
}

- (UIImageView *)bgIV {
    if (!_bgIV) {
        _bgIV = UIImageView.new;
        _bgIV.userInteractionEnabled = YES;
    }
    return _bgIV;
}

#pragma mark - HDSkeletonLayerLayoutProtocol
- (NSArray<HDSkeletonLayer *> *)skeletonLayoutViews {
    const CGFloat iconW = kRealHeight(100);
    CGFloat margin = 10;

    HDSkeletonLayer *circle = [[HDSkeletonLayer alloc] init];
    circle.skeletonCornerRadius = 8;
    [circle hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(iconW);
        make.height.hd_equalTo(iconW);
        make.top.hd_equalTo(15);
        make.left.hd_equalTo(15);
    }];

    HDSkeletonLayer *r1 = [[HDSkeletonLayer alloc] init];
    [r1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(150);
        make.height.hd_equalTo(20);
        make.left.hd_equalTo(circle.hd_right + margin);
        make.top.hd_equalTo(circle.hd_top + margin);
    }];

    HDSkeletonLayer *r2 = [[HDSkeletonLayer alloc] init];
    [r2 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(r1.hd_left);
        make.width.hd_equalTo(150);
        make.top.hd_equalTo(r1.hd_bottom + margin);
        make.height.hd_equalTo(20);
    }];

    HDSkeletonLayer *r3 = [[HDSkeletonLayer alloc] init];
    [r3 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(r1.hd_left);
        make.width.hd_equalTo(150);
        make.top.hd_equalTo(r2.hd_bottom + margin);
        make.height.hd_equalTo(20);
    }];

    HDSkeletonLayer *r4 = [[HDSkeletonLayer alloc] init];
    [r4 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.right.hd_equalTo(self.hd_width - 5);
        make.width.hd_equalTo(50);
        make.top.hd_equalTo(r1.hd_bottom + margin);
        make.height.hd_equalTo(20);
    }];
    return @[circle, r1, r2, r3, r4];
}

+ (CGFloat)skeletonViewHeight {
    return 120;
}

@end
