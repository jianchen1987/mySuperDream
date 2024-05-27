//
//  WMOrderSubmitProductView.m
//  SuperApp
//
//  Created by VanJay on 2020/5/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderSubmitProductView.h"
#import "WMShoppingCartStoreProduct.h"


@interface WMOrderSubmitProductView ()
/// logo
@property (nonatomic, strong) UIImageView *iconIV;
/// 名称
@property (nonatomic, strong) SALabel *nameLB;
/// 描述
@property (nonatomic, strong) SALabel *descLB;
/// 展示价
@property (nonatomic, strong) SALabel *showPriceLB;
/// 划线价
@property (nonatomic, strong) SALabel *linePriceLB;
/// 数量显示
@property (nonatomic, strong) SALabel *countLB;
/// 限制使用
@property (nonatomic, strong) HDLabel *stackUsageLB;

@end


@implementation WMOrderSubmitProductView
- (void)hd_setupViews {
    [self addSubview:self.iconIV];
    [self addSubview:self.nameLB];
    [self addSubview:self.countLB];
    [self addSubview:self.descLB];
    [self addSubview:self.showPriceLB];
    [self addSubview:self.linePriceLB];
    [self addSubview:self.stackUsageLB];

    self.iconIV.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(8)];
    };
}

- (void)setModel:(WMShoppingCartStoreProduct *)model {
    _model = model;

    [HDWebImageManager setImageWithURL:model.picture placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(76), kRealWidth(76))] imageView:self.iconIV];

    self.nameLB.text = model.name.desc;
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = kRealWidth(4);
    self.nameLB.attributedText = [[NSMutableAttributedString alloc] initWithString:self.nameLB.text attributes:@{NSParagraphStyleAttributeName: paragraphStyle}];

    NSArray<NSString *> *propertyNames = [model.properties mapObjectsUsingBlock:^id _Nonnull(WMShoppingCartStoreProductProperty *_Nonnull obj, NSUInteger idx) {
        return obj.name.desc;
    }];
    self.descLB.text =
        [model.goodsSkuName.desc stringByAppendingFormat:@"%@%@", HDIsArrayEmpty(propertyNames) ? @"" : @",", HDIsArrayEmpty(propertyNames) ? @"" : [propertyNames componentsJoinedByString:@"、"]];

    self.countLB.text = [NSString stringWithFormat:@"x%zd", model.purchaseQuantity];
    if (model.showOriginal) {
        self.showPriceLB.text = model.linePrice.thousandSeparatorAmount;
        self.linePriceLB.hidden = YES;
    } else {
        self.showPriceLB.text = model.showPrice.thousandSeparatorAmount;
        NSAttributedString *priceStr = [[NSAttributedString alloc] initWithString:model.linePrice.thousandSeparatorAmount attributes:@{
            NSFontAttributeName: [HDAppTheme.WMFont wm_ForSize:11 fontName:@"DINPro-Regular"],
            NSForegroundColorAttributeName: HDAppTheme.WMColor.B9,
            NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle | NSUnderlinePatternSolid),
            NSStrikethroughColorAttributeName: HDAppTheme.WMColor.B9
        }];
        self.linePriceLB.attributedText = priceStr;
    }

    ///限制叠加使用
    self.stackUsageLB.hidden = YES;
    //    if (model.usePromoCode || model.useVoucherCoupon || model.useShippingCoupon || model.useDeliveryFeeReduce) {
    if (model.usePromoCode || model.useShippingCoupon || model.useDeliveryFeeReduce || model.useStoreVoucherCoupon || model.usePlatformVoucherCoupon) {
        self.stackUsageLB.hidden = NO;
        NSMutableString *mstr = [[NSMutableString alloc] initWithString:WMLocalizedString(@"wm_product_cannot_use", @"该商品不能使用")];
        NSMutableArray *marr = NSMutableArray.new;
        //        if (model.useVoucherCoupon) {
        //            [marr addObject:WMLocalizedString(@"wm_product_cannot_use_cash_coupons", @"现金券")];
        //        }
        if (model.usePlatformVoucherCoupon) {
            [marr addObject:SALocalizedString(@"coupon_match_APPCoupon", @"平台券")];
        }
        if (model.useStoreVoucherCoupon) {
            [marr addObject:SALocalizedString(@"coupon_match_StoreCoupon", @"门店券")];
        }

        if (model.useShippingCoupon) {
            [marr addObject:WMLocalizedString(@"wm_product_cannot_use_shipping_coupons", @"运费券")];
        }
        if (model.usePromoCode) {
            [marr addObject:WMLocalizedString(@"wm_product_cannot_use_cash_promote_code", @"优惠码")];
        }
        if (model.useDeliveryFeeReduce) {
            [marr addObject:WMLocalizedString(@"wm_free_delivery", @"减免配送费")];
        }
        [mstr appendString:[marr componentsJoinedByString:@","]];
        self.stackUsageLB.text = mstr;
    }
    [self setNeedsUpdateConstraints];
}

#pragma mark - layout
- (void)updateConstraints {
    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealWidth(76), kRealWidth(76)));
        make.left.mas_equalTo(kRealWidth(self.fromOrderDetail ? 12 : 15));
        make.top.equalTo(self).offset(kRealWidth(16));
        make.bottom.mas_lessThanOrEqualTo(kRealWidth(0));
    }];
    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconIV);
        make.height.mas_greaterThanOrEqualTo(kRealWidth(20));
        make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(7));
        make.right.equalTo(self).offset(-kRealWidth((self.fromOrderDetail ? 12 : 15)));
    }];
    [self.descLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLB);
        make.top.equalTo(self.nameLB.mas_bottom).offset(kRealWidth(2));
    }];

    [self.countLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLB);
        make.bottom.equalTo(self.iconIV.mas_bottom).offset(-kRealWidth(3));
    }];
    [self.countLB setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    [self.countLB setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];

    [self.stackUsageLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.stackUsageLB.isHidden) {
            make.right.equalTo(self).offset(-kRealWidth(15));
            make.left.equalTo(self).offset(kRealWidth(15));
            make.top.equalTo(self.iconIV.mas_bottom).offset(kRealWidth(7));
            make.bottom.mas_lessThanOrEqualTo(0);
        }
    }];

    [self.showPriceLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.countLB);
        make.right.equalTo(self.nameLB);
    }];

    [self.linePriceLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.showPriceLB.mas_left).offset(-kRealWidth(5));
        make.bottom.equalTo(self.showPriceLB);
    }];

    [super updateConstraints];
}

#pragma mark - lazy load
- (UIImageView *)iconIV {
    if (!_iconIV) {
        UIImageView *imageView = UIImageView.new;
        imageView.image = [HDHelper placeholderImageWithSize:CGSizeMake(70, 70)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconIV = imageView;
    }
    return _iconIV;
}

- (SALabel *)nameLB {
    if (!_nameLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.WMFont wm_ForSize:14 weight:UIFontWeightMedium];
        ;
        label.textColor = HDAppTheme.WMColor.B3;
        label.numberOfLines = 2;
        _nameLB = label;
    }
    return _nameLB;
}

- (SALabel *)countLB {
    if (!_countLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard3;
        label.textColor = HDAppTheme.color.G1;
        label.numberOfLines = 1;
        _countLB = label;
    }
    return _countLB;
}

- (SALabel *)descLB {
    if (!_descLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.WMFont wm_ForSize:12];
        label.textColor = HDAppTheme.WMColor.B9;
        label.numberOfLines = 2;
        _descLB = label;
    }
    return _descLB;
}

- (SALabel *)showPriceLB {
    if (!_showPriceLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.WMFont wm_ForSize:14 fontName:@"DINPro-Bold"];
        label.textColor = HDAppTheme.WMColor.mainRed;
        label.numberOfLines = 1;
        _showPriceLB = label;
    }
    return _showPriceLB;
}

- (SALabel *)linePriceLB {
    if (!_linePriceLB) {
        _linePriceLB = [[SALabel alloc] init];
    }
    return _linePriceLB;
}

- (HDLabel *)stackUsageLB {
    if (!_stackUsageLB) {
        _stackUsageLB = HDLabel.new;
        _stackUsageLB.numberOfLines = 0;
        _stackUsageLB.hd_edgeInsets = UIEdgeInsetsMake(kRealWidth(4), kRealWidth(12), kRealWidth(4), kRealWidth(12));
        _stackUsageLB.textColor = HDAppTheme.WMColor.B9;
        _stackUsageLB.font = [HDAppTheme.WMFont wm_ForSize:11];
        _stackUsageLB.layer.backgroundColor = [HDAppTheme.WMColor.B6 colorWithAlphaComponent:0.05].CGColor;
        _stackUsageLB.layer.cornerRadius = kRealWidth(4);
    }
    return _stackUsageLB;
}
@end
