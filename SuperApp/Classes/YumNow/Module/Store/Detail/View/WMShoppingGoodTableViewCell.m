//
//  WMShoppingGoodTableViewCell.m
//  SuperApp
//
//  Created by VanJay on 2020/5/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMShoppingGoodTableViewCell.h"
#import "SAModifyShoppingCountView.h"
#import "SAOperationButton.h"
#import "WMFoodCustomizeButton.h"
#import "WMPromotionLabel.h"
#import "WMStoreDetailPromotionModel.h"
#import "SAMoneyTools.h"


@interface WMShoppingGoodTableViewCell () <CAAnimationDelegate>
/// logo
@property (nonatomic, strong) UIImageView *iconIV;
/// 新标签背景
@property (nonatomic, strong) UIView *logoTagBgView;
/// 新标签
@property (nonatomic, strong) SALabel *logoTagLabel;
/// 名称
@property (nonatomic, strong) SALabel *nameLB;
/// 描述
@property (nonatomic, strong) SALabel *descLB;
/// 已售
@property (nonatomic, strong) SALabel *soldLB;
/// 优惠信息
@property (nonatomic, strong) HDFloatLayoutView *floatLayoutView;
/// 展示价
@property (nonatomic, strong) SALabel *showPriceLB;
/// 划线价
@property (nonatomic, strong) SALabel *linePriceLB;
/// 添加按钮
@property (nonatomic, strong) WMOperationButton *addBTN;
@property (nonatomic, strong) UIView *countViewMask; ///< 数量View的遮罩
/// 修改数量 View
@property (nonatomic, strong) SAModifyShoppingCountView *countView;
/// 自定义按钮
@property (nonatomic, strong) WMFoodCustomizeButton *customizeBTN;
/// 发光 View
@property (nonatomic, strong) UIImageView *flashIV;
/// 发光 View 是否在执行动画的标志
@property (nonatomic, assign) BOOL isFlashIVAnimating;
/// 记录旧数量
@property (nonatomic, assign) NSUInteger oldCount;
/// 底部线
@property (nonatomic, strong) UIView *bottomLineView;

@property (nonatomic, assign) BOOL shouldInvokeClickedProductViewBlock; ///< 是否需要响应点击
/// 限制叠加使用
@property (nonatomic, strong) HDLabel *stackUsageLB;
/// 闪送标签
@property (nonatomic, strong) UIImageView *speedServiceView;

@end


@implementation WMShoppingGoodTableViewCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.iconIV];
    [self.contentView addSubview:self.speedServiceView];
    [self.contentView addSubview:self.logoTagBgView];
    [self.contentView addSubview:self.logoTagLabel];
    [self.contentView addSubview:self.nameLB];
    [self.contentView addSubview:self.descLB];
    [self.contentView addSubview:self.soldLB];
    [self.contentView addSubview:self.floatLayoutView];
    [self.contentView addSubview:self.showPriceLB];
    [self.contentView addSubview:self.linePriceLB];
    [self.contentView addSubview:self.addBTN];
    [self.contentView addSubview:self.customizeBTN];
    [self.contentView addSubview:self.countViewMask];
    [self.contentView addSubview:self.countView];
    [self.contentView addSubview:self.flashIV];
    [self.contentView addSubview:self.bottomLineView];
    [self.contentView addSubview:self.stackUsageLB];

    [self.linePriceLB setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];

    self.iconIV.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(8)];
    };
}

- (void)updateConstraints {
    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kShoppingGoodTableViewCellSize, kShoppingGoodTableViewCellSize));
        make.left.equalTo(self.contentView).offset(kRealWidth(12));
        make.top.equalTo(self.contentView).offset(kRealWidth(9));
        make.bottom.lessThanOrEqualTo(self.contentView.mas_bottom).offset(-kRealWidth(9));
    }];

    [self.speedServiceView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.iconIV).offset(-2);
    }];

    [self.logoTagBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.iconIV);
    }];

    [self.logoTagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoTagBgView.mas_left).offset(kRealWidth(5));
        make.top.equalTo(self.logoTagBgView.mas_top);
        make.bottom.equalTo(self.logoTagBgView.mas_bottom);
        make.right.equalTo(self.logoTagBgView.mas_right).offset(kRealWidth(-5));
    }];

    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconIV).offset(-kRealWidth(4));
        make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(8));
        make.right.equalTo(self.contentView).offset(-kRealWidth(12));
        if (!HDIsStringEmpty(self.nameLB.text)) {
            make.height.mas_greaterThanOrEqualTo(kRealWidth(24));
        }
    }];
    [self.descLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.descLB.isHidden) {
            make.left.equalTo(self.nameLB);
            make.right.equalTo(self.contentView).offset(-kRealWidth(12));
            make.top.equalTo(self.nameLB.mas_bottom).offset(kRealWidth(4));
            make.height.mas_greaterThanOrEqualTo(kRealWidth(18));
        }
    }];
    [self.soldLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLB);
        make.right.equalTo(self.contentView).offset(-kRealWidth(12));
        if (self.descLB.isHidden) {
            make.top.equalTo(self.nameLB.mas_bottom).offset(kRealWidth(4));
        } else {
            make.top.equalTo(self.descLB.mas_bottom).offset(kRealWidth(4));
        }
        make.height.mas_greaterThanOrEqualTo(kRealWidth(18));
    }];

    [self.floatLayoutView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.floatLayoutView.isHidden) {
            make.top.equalTo(self.soldLB.mas_bottom).offset(kRealWidth(6));
            make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(8));
            CGFloat width = kScreenWidth - kRealWidth(130);
            if (SAMultiLanguageManager.isCurrentLanguageCN) {
                width = kRealWidth(190);
            }
            CGSize size = [self.floatLayoutView sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
            make.size.mas_equalTo(size);
            make.bottom.mas_lessThanOrEqualTo(-kRealWidth(9));
        }
    }];

    [self.showPriceLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        UIView *topView = self.floatLayoutView.isHidden ? self.soldLB : self.floatLayoutView;
        make.left.equalTo(self.nameLB);
        make.height.mas_equalTo(kRealWidth(24));
        make.top.greaterThanOrEqualTo(topView.mas_bottom).offset(kRealWidth(4));
        make.bottom.greaterThanOrEqualTo(self.iconIV);
        make.bottom.mas_lessThanOrEqualTo(-kRealWidth(9));
    }];
    [self.linePriceLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.showPriceLB);
        make.left.equalTo(self.showPriceLB.mas_right).offset(kRealWidth(5));
        UIView *view = self.customizeBTN.isHidden ? (self.countView.isHidden ? self.addBTN : self.countView) : self.customizeBTN;
        if (view == self.countView && SAMultiLanguageManager.isCurrentLanguageCN) {
            make.right.lessThanOrEqualTo(view.mas_left);
        } else {
            make.right.lessThanOrEqualTo(view.mas_left).offset(-5);
        }
    }];
    [self.addBTN sizeToFit];
    [self.addBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.addBTN.isHidden) {
            if (!UIEdgeInsetsEqualToEdgeInsets(self.addBTN.titleEdgeInsets, UIEdgeInsetsZero)) {
                make.size.mas_equalTo(self.addBTN.bounds.size);
                make.centerY.equalTo(self.showPriceLB);
            } else {
                //                make.size.mas_equalTo(CGSizeMake(kRealWidth(20), kRealWidth(20)));
                make.bottom.equalTo(self.showPriceLB);
            }
            make.right.equalTo(self.contentView).offset(-HDAppTheme.value.padding.right);
        }
    }];
    [self.countView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.countView.isHidden) {
            make.bottom.equalTo(self.showPriceLB);
            make.right.equalTo(self.contentView).offset(-HDAppTheme.value.padding.right);
        }
    }];
    if (!self.countView.isHidden) {
        [self.countViewMask mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.countView.mas_left).offset(-20);
            make.right.equalTo(self.countView.mas_right).offset(20);
            make.top.equalTo(self.countView.mas_top).offset(-5);
            make.bottom.equalTo(self.countView.mas_bottom).offset(5);
        }];
    }
    [self.customizeBTN sizeToFit];
    [self.customizeBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.customizeBTN.isHidden) {
            make.size.mas_equalTo(self.customizeBTN.bounds.size);
            make.centerY.equalTo(self.showPriceLB);
            make.right.equalTo(self.contentView).offset(-HDAppTheme.value.padding.right);
        }
    }];
    [self.flashIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];

    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self.contentView.mas_right).offset(-HDAppTheme.value.padding.right);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(PixelOne);
    }];

    [self.stackUsageLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.stackUsageLB.isHidden) {
            if (SAMultiLanguageManager.isCurrentLanguageCN) {
                make.left.equalTo(self.iconIV);
            } else {
                make.left.equalTo(self.nameLB);
            }
            make.right.equalTo(self.nameLB);
            make.top.equalTo(self.showPriceLB.mas_bottom).offset(kRealWidth(4));
            make.bottom.mas_lessThanOrEqualTo(-kRealWidth(9));
        }
    }];
    [super updateConstraints];
}

#pragma mark - setter
- (void)setModel:(WMStoreGoodsItem *)model {
    _model = model;
    [self.iconIV sd_setImageWithURL:[NSURL URLWithString:model.imagePaths.firstObject] placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(70, 70)]];


    self.speedServiceView.hidden = YES;
    self.logoTagBgView.hidden = self.logoTagLabel.hidden = YES;
    if (model.isSpeedService) {
        self.speedServiceView.hidden = NO;
    } else if (model.isNew) {
        self.logoTagBgView.hidden = self.logoTagLabel.hidden = NO;
    }

    NSString *lowerCaseStoreName = model.name.lowercaseString;
    NSString *lowerCaseKeyWord = model.keyWord.lowercaseString;

    NSString *pattern = [NSString stringWithFormat:@"%@", lowerCaseKeyWord];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    NSArray *matches = @[];
    if (lowerCaseStoreName) {
        matches = [regex matchesInString:lowerCaseStoreName options:0 range:NSMakeRange(0, lowerCaseStoreName.length)];
    }

    if (HDIsStringNotEmpty(lowerCaseKeyWord) && matches.count > 0) {
        NSMutableAttributedString *attrStr =
            [[NSMutableAttributedString alloc] initWithString:model.name attributes:@{NSForegroundColorAttributeName: HDAppTheme.color.G1, NSFontAttributeName: HDAppTheme.font.standard2Bold}];
        for (NSTextCheckingResult *result in [matches objectEnumerator]) {
            [attrStr addAttributes:@{NSForegroundColorAttributeName: HDAppTheme.color.mainColor, NSFontAttributeName: HDAppTheme.font.standard2Bold} range:[result range]];
        }
        self.nameLB.attributedText = attrStr;
    } else {
        self.nameLB.font = HDAppTheme.font.standard3Bold;
        self.nameLB.textColor = HDAppTheme.color.G1;
        self.nameLB.text = model.name;
    }

    self.descLB.hidden = false;
    self.descLB.text = model.desc;
    if (![model.desc isKindOfClass:NSString.class] || ([model.desc isKindOfClass:NSString.class] && (!model.desc.length || [model.desc isEqualToString:@" "]))) {
        self.descLB.hidden = true;
    }

    NSString *sold;
    if ([SAMultiLanguageManager.currentLanguage isEqualToString:SALanguageTypeCN]) {
        sold = [NSString stringWithFormat:@"%@ %zd", WMLocalizedString(@"wm_sold", @"Sold"), self.model.sold];
    } else {
        sold = [NSString stringWithFormat:@"%zd %@", self.model.sold, WMLocalizedString(@"wm_sold", @"Sold")];
    }
    self.soldLB.text = sold;

    //    self.showPriceLB.text = model.showPrice.thousandSeparatorAmount;
    //    self.showPriceLB.text = model.showPrice;
    self.showPriceLB.text = [SAMoneyTools thousandSeparatorAmountYuan:model.showPrice currencyCode:@"USD"];
    self.linePriceLB.hidden = YES;
    if (!HDIsObjectNil(model.linePrice)) {
        self.linePriceLB.hidden = NO;
        //        NSAttributedString *originalPriceStr = [[NSAttributedString alloc] initWithString:model.linePrice.thousandSeparatorAmount
        //        NSAttributedString *originalPriceStr = [[NSAttributedString alloc] initWithString:model.linePrice

        NSAttributedString *originalPriceStr = [[NSAttributedString alloc] initWithString:[SAMoneyTools thousandSeparatorAmountYuan:model.linePrice currencyCode:@"USD"] attributes:@{
            NSFontAttributeName: [HDAppTheme.WMFont wm_ForSize:12],
            NSForegroundColorAttributeName: HDAppTheme.WMColor.B9,
            NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle | NSUnderlinePatternSolid),
            NSStrikethroughColorAttributeName: HDAppTheme.WMColor.B9
        }];
        self.linePriceLB.attributedText = originalPriceStr;
    }

    BOOL isStoreResting = [model.storeStatus.status isEqualToString:WMStoreStatusResting];

    // 单规格单属性
    BOOL isSingleSkuAndPropertyProduct = !self.shouldShowChooseSkuAndPropertyView;
    self.addBTN.hidden = self.totalAvailableStock > 0 && (!isSingleSkuAndPropertyProduct || model.currentCountInShoppingCart > 0);
    self.addBTN.userInteractionEnabled = !isStoreResting && self.totalAvailableStock > 0;
    if (!self.addBTN.isHidden) {
        // 判断是否已售完
        if (self.totalAvailableStock <= 0) {
            [self.addBTN applyPropertiesWithStyle:WMOperationButtonStyleSolid];
            [self.addBTN applyPropertiesWithBackgroundColor:HDAppTheme.color.G4];
            [self.addBTN setTitle:WMLocalizedString(@"sold_out", @"卖完了") forState:UIControlStateNormal];
            [self.addBTN setImage:nil forState:UIControlStateNormal];
            self.addBTN.titleEdgeInsets = UIEdgeInsetsMake(5, 16, 5, 16);
            self.addBTN.imageEdgeInsets = UIEdgeInsetsZero;
        } else {
            [self.addBTN setTitle:nil forState:UIControlStateNormal];
            [self.addBTN applyPropertiesWithBackgroundColor:UIColor.clearColor];
            self.addBTN.titleEdgeInsets = UIEdgeInsetsZero;
            self.addBTN.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
            self.addBTN.backgroundColor = UIColor.clearColor;
            [self.addBTN setImage:[UIImage imageNamed:isStoreResting ? @"shopping_add_disabled" : @"yn_store_plus"] forState:UIControlStateNormal];
        }
    }

    self.countView.hidden = !isSingleSkuAndPropertyProduct || !self.addBTN.isHidden;
    NSUInteger avaialbeStock = model.availableStock > 150 ? 150 : model.availableStock;
    self.countView.maxCount = avaialbeStock;
    [self.countView updateCount:model.currentCountInShoppingCart];
    [self.countView enableOrDisableButton:!isStoreResting];

    self.oldCount = self.countView.count;
    self.customizeBTN.hidden = isSingleSkuAndPropertyProduct || !self.addBTN.isHidden;
    self.customizeBTN.userInteractionEnabled = !isStoreResting;
    if (!self.customizeBTN.isHidden) {
        [self.customizeBTN updateUIWithCount:model.currentCountInShoppingCart storeStatus:model.storeStatus.status];
        if (isStoreResting) {
            [self.customizeBTN applyPropertiesWithStyle:WMOperationButtonStyleSolid];
            [self.customizeBTN applyPropertiesWithBackgroundColor:HDAppTheme.color.G4];
        } else {
            [self.customizeBTN applyPropertiesWithStyle:WMOperationButtonStyleSolid];
            [self.customizeBTN applyPropertiesWithBackgroundColor:HDAppTheme.WMColor.mainRed];
        }
    }
    self.bottomLineView.hidden = self.model.needHideBottomLine;

    [self configPromotions];

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

- (void)configPromotions {
    self.floatLayoutView.hidden = HDIsObjectNil(self.model.productPromotion) && HDIsArrayEmpty(self.model.serviceLabel);

    if (!self.floatLayoutView.isHidden) {
        [self.floatLayoutView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        NSMutableArray *arr = [WMStoreGoodsPromotionModel configProductPromotions:self.model.productPromotion].mutableCopy;
        if (self.model.serviceLabel.count) {
            [arr addObjectsFromArray:[WMStoreDetailPromotionModel configserviceLabel:self.model.serviceLabel]];
        }
        [arr enumerateObjectsUsingBlock:^(HDUIGhostButton *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            obj.backgroundColor = UIColor.clearColor;
            [self.floatLayoutView addSubview:obj];
        }];
    }
}

#pragma mark - public methods
- (void)flash {
    if (self.isFlashIVAnimating)
        return;

    self.flashIV.hidden = false;
    CAAnimation *animation = [CAAnimation animationWithDuration:0.4 repeatCount:4 keyPath:@"opacity" fromValue:@(1.0) toValue:@(0.5)];
    animation.delegate = self;
    [self.flashIV.layer addAnimation:animation forKey:@"flashAnimation"];
    self.isFlashIVAnimating = true;
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    // if ([[self.flashIV.layer animationForKey:@"flashAnimation"] isEqual:anim]) {
    [self.flashIV.layer removeAnimationForKey:@"flashAnimation"];
    self.flashIV.hidden = true;
    self.isFlashIVAnimating = false;
    // }
}

#pragma mark - event response
- (void)addBTNClickedHandler {
    if (!self.shouldShowChooseSkuAndPropertyView) {
        self.addBTN.hidden = true;
        self.countView.hidden = false;
        [self setNeedsUpdateConstraints];
        [self.countView updateCount:1];
        !self.plusGoodsToShoppingCartBlock ?: self.plusGoodsToShoppingCartBlock(self.model, self.countView.count);
    } else {
        [self invokeChooseGoodsPropertyAndSkuViewBlock];
    }
}

- (void)customizeBTNClickedHandler {
    !self.showChooseGoodsPropertyAndSkuViewBlock ?: self.showChooseGoodsPropertyAndSkuViewBlock(self.model);
}

#pragma mark - private methods
- (void)invokeChooseGoodsPropertyAndSkuViewBlock {
    !self.showChooseGoodsPropertyAndSkuViewBlock ?: self.showChooseGoodsPropertyAndSkuViewBlock(self.model);
}

- (NSUInteger)totalCombinationCount {
    // 计算规格和属性组合种数
    NSUInteger skuCount = self.model.specificationList.count;
    skuCount = skuCount <= 0 ? 1 : skuCount;

    NSUInteger propertyOptionCombinationCount = 1;
    for (WMStoreGoodsProductProperty *propertyModel in self.model.propertyList) {
        NSUInteger propertyOptionCount = propertyModel.optionList.count;
        propertyOptionCount = propertyOptionCount <= 0 ? 1 : propertyOptionCount;
        if (!propertyModel.required) {
            propertyOptionCount += 1;
        }
        propertyOptionCombinationCount = propertyOptionCombinationCount * propertyOptionCount;
    }
    NSUInteger totalCombinationCount = propertyOptionCombinationCount * skuCount;
    return totalCombinationCount;
}

- (BOOL)shouldShowChooseSkuAndPropertyView {
    return self.totalCombinationCount > 1;
}

- (NSUInteger)totalAvailableStock {
    return self.model.availableStock;
}

- (void)showOnlyChooseSomeItemToastWithCount:(NSUInteger)count {
}

#pragma mark - override
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.shouldInvokeClickedProductViewBlock) {
        !self.cellClickedEventBlock ?: self.cellClickedEventBlock(self.model);
    }
}
// 判断点击区域
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [touches.anyObject locationInView:self];
    if (CGRectContainsPoint(self.countViewMask.frame, point)) {
        self.shouldInvokeClickedProductViewBlock = false;
        return;
    }
    self.shouldInvokeClickedProductViewBlock = true;
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

- (UIView *)logoTagBgView {
    if (!_logoTagBgView) {
        _logoTagBgView = [[UIView alloc] init];
        _logoTagBgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            view.layer.backgroundColor = HDAppTheme.WMColor.mainRed.CGColor;
            [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerBottomRight radius:5];
        };
    }
    return _logoTagBgView;
}

- (SALabel *)logoTagLabel {
    if (!_logoTagLabel) {
        _logoTagLabel = [[SALabel alloc] init];
        _logoTagLabel.textColor = UIColor.whiteColor;
        _logoTagLabel.font = HDAppTheme.font.standard5Bold;
        _logoTagLabel.text = WMLocalizedString(@"is_new_product", @"New");
    }
    return _logoTagLabel;
}

- (SALabel *)nameLB {
    if (!_nameLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.WMFont wm_boldForSize:16];
        label.textColor = HDAppTheme.WMColor.B3;
        label.numberOfLines = 2;
        _nameLB = label;
    }
    return _nameLB;
}

- (SALabel *)descLB {
    if (!_descLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.WMFont wm_ForSize:12];
        label.textColor = HDAppTheme.WMColor.B9;
        label.numberOfLines = SAMultiLanguageManager.isCurrentLanguageCN ? 2 : 1;
        label.hd_lineSpace = SAMultiLanguageManager.isCurrentLanguageCN ? 7 : 5;
        _descLB = label;
    }
    return _descLB;
}

- (SALabel *)soldLB {
    if (!_soldLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.WMFont wm_ForSize:12];
        label.textColor = HDAppTheme.WMColor.B9;
        label.numberOfLines = 1;
        label.hd_lineSpace = SAMultiLanguageManager.isCurrentLanguageCN ? 7 : 5;
        _soldLB = label;
    }
    return _soldLB;
}

- (HDFloatLayoutView *)floatLayoutView {
    if (!_floatLayoutView) {
        _floatLayoutView = [[HDFloatLayoutView alloc] init];
        _floatLayoutView.itemMargins = UIEdgeInsetsMake(0, 0, 8, 5);
    }
    return _floatLayoutView;
}

- (SALabel *)showPriceLB {
    if (!_showPriceLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.WMFont wm_boldForSize:SAMultiLanguageManager.isCurrentLanguageCN ? 14 : 16];
        label.textColor = HDAppTheme.WMColor.mainRed;
        label.numberOfLines = 1;
        _showPriceLB = label;
    }
    return _showPriceLB;
}

- (SALabel *)linePriceLB {
    if (!_linePriceLB) {
        _linePriceLB = SALabel.new;
    }
    return _linePriceLB;
}

- (WMOperationButton *)addBTN {
    if (!_addBTN) {
        WMOperationButton *button = [WMOperationButton buttonWithStyle:WMOperationButtonStyleSolid];
        [button setImage:[UIImage imageNamed:@"yn_store_plus"] forState:UIControlStateNormal];
        button.titleEdgeInsets = UIEdgeInsetsZero;
        button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        button.titleLabel.font = [HDAppTheme.WMFont wm_ForSize:12 weight:UIFontWeightMedium];
        [button addTarget:self action:@selector(addBTNClickedHandler) forControlEvents:UIControlEventTouchUpInside];
        button.hidden = true;
        _addBTN = button;
    }
    return _addBTN;
}

- (WMFoodCustomizeButton *)customizeBTN {
    if (!_customizeBTN) {
        WMFoodCustomizeButton *button = [WMFoodCustomizeButton buttonWithStyle:WMOperationButtonStyleSolid];
        [button setTitle:WMLocalizedString(@"customize_product", @"选规格") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(customizeBTNClickedHandler) forControlEvents:UIControlEventTouchUpInside];
        button.titleEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
        button.titleLabel.font = [HDAppTheme.WMFont wm_ForSize:12 weight:UIFontWeightMedium];
        button.hidden = true;
        _customizeBTN = button;
    }
    return _customizeBTN;
}

- (SAModifyShoppingCountView *)countView {
    if (!_countView) {
        _countView = SAModifyShoppingCountView.new;
        _countView.hidden = true;
        _countView.minusIcon = @"yn_store_minus";
        _countView.plusIcon = @"yn_store_plus";
        @HDWeakify(self);
        _countView.countShouldChange = ^BOOL(SAModifyShoppingCountViewOperationType type, NSUInteger count) {
            @HDStrongify(self);
            if ((type == SAModifyShoppingCountViewOperationTypePlus) && self.shouldShowChooseSkuAndPropertyView) {
                [self invokeChooseGoodsPropertyAndSkuViewBlock];
                return NO;
            }
            return self.goodsFromShoppingCartShouldChangeBlock ? self.goodsFromShoppingCartShouldChangeBlock(self.model, type, count) : YES;
        };
        _countView.changedCountHandler = ^(SAModifyShoppingCountViewOperationType type, NSUInteger count) {
            @HDStrongify(self);

            !self.goodsFromShoppingCartChangedBlock ?: self.goodsFromShoppingCartChangedBlock(self.model, type, count);

            if (type == SAModifyShoppingCountViewOperationTypeMinus && count <= 0) {
                self.addBTN.hidden = false;
                self.countView.hidden = true;
                [self setNeedsUpdateConstraints];
            }
            self.oldCount = count;
        };

        _countView.maxCountLimtedHandler = ^(NSUInteger count) {
            [NAT showToastWithTitle:nil content:[NSString stringWithFormat:WMLocalizedString(@"Only_left_in_stock", @"库存仅剩 %zd 件"), count] type:HDTopToastTypeWarning];
        };
        _countView.clickedMinusBTNHandler = ^{
            @HDStrongify(self);
            !self.minusGoodsToShoppingCartBlock ?: self.minusGoodsToShoppingCartBlock();
        };
        self.oldCount = _countView.count;
    }
    return _countView;
}

- (UIImageView *)flashIV {
    if (!_flashIV) {
        UIImageView *imageView = UIImageView.new;
        UIImage *image = [UIImage imageNamed:@"goodsSelectEffect"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 30, 20) resizingMode:UIImageResizingModeTile];
        imageView.image = image;
        imageView.hidden = true;
        _flashIV = imageView;
    }
    return _flashIV;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = HDAppTheme.color.G4;
    }
    return _bottomLineView;
}
- (UIView *)countViewMask {
    if (!_countViewMask) {
        _countViewMask = UIView.new;
    }
    return _countViewMask;
}

- (HDLabel *)stackUsageLB {
    if (!_stackUsageLB) {
        _stackUsageLB = HDLabel.new;
        _stackUsageLB.numberOfLines = 0;
        _stackUsageLB.hd_edgeInsets = UIEdgeInsetsMake(kRealWidth(4), kRealWidth(8), kRealWidth(4), kRealWidth(8));
        _stackUsageLB.textColor = HDAppTheme.WMColor.B9;
        _stackUsageLB.font = [HDAppTheme.WMFont wm_ForSize:11];
        _stackUsageLB.layer.backgroundColor = [HDAppTheme.WMColor.B6 colorWithAlphaComponent:0.05].CGColor;
        _stackUsageLB.layer.cornerRadius = kRealWidth(4);
    }
    return _stackUsageLB;
}

- (UIImageView *)speedServiceView {
    if (!_speedServiceView) {
        _speedServiceView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yn_store_produce_speedService_zh"]];
        if (SAMultiLanguageManager.isCurrentLanguageEN) {
            _speedServiceView.image = [UIImage imageNamed:@"yn_store_produce_speedService_en"];
        } else if (SAMultiLanguageManager.isCurrentLanguageKH) {
            _speedServiceView.image = [UIImage imageNamed:@"yn_store_produce_speedService_kh"];
        }
    }
    return _speedServiceView;
}

@end
