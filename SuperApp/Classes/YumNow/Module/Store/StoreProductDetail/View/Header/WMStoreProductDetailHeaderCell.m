//
//  WMStoreProductDetailHeaderCell.m
//  SuperApp
//
//  Created by VanJay on 2020/6/12.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreProductDetailHeaderCell.h"
#import "SAModifyShoppingCountView.h"
#import "SAOperationButton.h"
#import "WMFoodCustomizeButton.h"
#import "WMPromotionLabel.h"
#import "WMStoreProductDetailRspModel.h"
#import <YYText/YYText.h>

#define kMarginContent2Icon kRealWidth(10)
#define kIconWidth kRealWidth(16)


@interface WMStoreProductDetailHeaderCell ()
/// 名称
@property (nonatomic, strong) SALabel *nameLB;
/// 描述 icon
@property (nonatomic, strong) UIImageView *iconIV;
/// 描述
@property (nonatomic, strong) YYLabel *descLB;
/// 已售
@property (nonatomic, strong) SALabel *soldLB;
/// 展示价
@property (nonatomic, strong) SALabel *showPriceLB;
/// 划线价
@property (nonatomic, strong) SALabel *linePriceLB;
/// 优惠信息
@property (nonatomic, strong) HDFloatLayoutView *floatLayoutView;
/// 添加按钮
@property (nonatomic, strong) WMOperationButton *addBTN;
/// 修改数量 View
@property (nonatomic, strong) SAModifyShoppingCountView *countView;
/// 自定义按钮
@property (nonatomic, strong) WMFoodCustomizeButton *customizeBTN;
/// 分隔View
@property (nonatomic, strong) UIView *sepView;
/// 记录旧数量
@property (nonatomic, assign) NSUInteger oldCount;
/// 文字最宽宽度
@property (nonatomic, assign, readonly) CGFloat contentLabelPreferredMaxLayoutWidth;
/// 限制叠加使用
@property (nonatomic, strong) HDLabel *stackUsageLB;

@end


@implementation WMStoreProductDetailHeaderCell

#pragma mark - SATableViewCellProtocol
- (void)hd_setupViews {
    self.contentView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:self.nameLB];
    [self.contentView addSubview:self.showPriceLB];
    [self.contentView addSubview:self.linePriceLB];
    [self.contentView addSubview:self.floatLayoutView];
    [self.contentView addSubview:self.iconIV];
    [self.contentView addSubview:self.descLB];
    [self.contentView addSubview:self.soldLB];
    [self.contentView addSubview:self.addBTN];
    [self.contentView addSubview:self.customizeBTN];
    [self.contentView addSubview:self.countView];
    [self.contentView addSubview:self.sepView];
    [self.contentView addSubview:self.stackUsageLB];

    [self.showPriceLB setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];

    self.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:10];
    };
}

#pragma mark - setter
- (void)setModel:(WMStoreProductDetailRspModel *)model {
    _model = model;

    self.nameLB.text = model.name;
    NSString *sold;
    if ([SAMultiLanguageManager.currentLanguage isEqualToString:SALanguageTypeCN]) {
        sold = [NSString stringWithFormat:@"%@ %zd", WMLocalizedString(@"wm_sold", @"Sold"), self.model.sold];
    } else {
        sold = [NSString stringWithFormat:@"%zd %@", self.model.sold, WMLocalizedString(@"wm_sold", @"Sold")];
    }
    self.soldLB.text = sold;
    [self updateProductDescLBText];

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
        } else {
            if (isStoreResting) {
                [self.addBTN applyPropertiesWithStyle:WMOperationButtonStyleSolid];
                [self.addBTN applyPropertiesWithBackgroundColor:HDAppTheme.color.G4];
            } else {
                [self.addBTN applyPropertiesWithStyle:WMOperationButtonStyleSolid];
                [self.addBTN applyPropertiesWithBackgroundColor:HDAppTheme.WMColor.mainRed];
            }
            [self.addBTN setTitle:WMLocalizedString(@"add_product", @"添加 +") forState:UIControlStateNormal];
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

    self.showPriceLB.text = model.showPrice.thousandSeparatorAmount;
    NSAttributedString *priceStr = [[NSAttributedString alloc] initWithString:model.linePrice.thousandSeparatorAmount attributes:@{
        NSFontAttributeName: HDAppTheme.font.standard3,
        NSForegroundColorAttributeName: HDAppTheme.color.G3,
        NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle | NSUnderlinePatternSolid),
        NSStrikethroughColorAttributeName: HDAppTheme.color.G3
    }];
    self.linePriceLB.attributedText = priceStr;

    self.floatLayoutView.hidden = HDIsObjectNil(model.productPromotion) && HDIsArrayEmpty(model.serviceLabel);

    if (!self.floatLayoutView.isHidden) {
        [self.floatLayoutView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        NSMutableArray *arr = [WMStoreGoodsPromotionModel configProductPromotions:self.model.productPromotion].mutableCopy;
        if (model.serviceLabel.count) {
            [arr addObjectsFromArray:[WMStoreDetailPromotionModel configserviceLabel:self.model.serviceLabel]];
        }

        [arr enumerateObjectsUsingBlock:^(HDUIGhostButton *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            [self.floatLayoutView addSubview:obj];
        }];
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

#pragma mark - public methods

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

- (void)updateProductDescLBText {
    self.iconIV.hidden = HDIsStringEmpty(self.model.desc);
    self.descLB.hidden = self.iconIV.isHidden;

    if (self.descLB.isHidden)
        return;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
    NSAttributedString *appendingStr = [[NSMutableAttributedString alloc] initWithString:self.model.desc
                                                                              attributes:@{NSForegroundColorAttributeName: HDAppTheme.color.G2, NSFontAttributeName: HDAppTheme.font.standard3}];

    YYTextLayout *textLayout = [YYTextLayout layoutWithContainerSize:CGSizeMake(self.contentLabelPreferredMaxLayoutWidth, CGFLOAT_MAX) text:appendingStr];
    NSUInteger maxRowCount = self.model.productDescMaxRowCount;
    BOOL isProductDescExpanded = self.model.isProductDescExpanded;
    if (maxRowCount > 0 && textLayout.rowCount > maxRowCount) {
        if (isProductDescExpanded) {
            [text appendAttributedString:appendingStr];
            // 查看更少
            NSAttributedString *readLessStr = [[NSMutableAttributedString alloc] initWithString:WMLocalizedString(@"read_less", @"收起")
                                                                                     attributes:@{NSForegroundColorAttributeName: HDAppTheme.color.C1, NSFontAttributeName: HDAppTheme.font.standard3}];
            [text appendAttributedString:readLessStr];

            @HDWeakify(self);
            [text yy_setTextHighlightRange:NSMakeRange(appendingStr.length, text.length - appendingStr.length) color:HDAppTheme.color.C1 backgroundColor:UIColor.clearColor
                                 tapAction:^(UIView *_Nonnull containerView, NSAttributedString *_Nonnull text, NSRange range, CGRect rect) {
                                     @HDStrongify(self);
                                     !self.clickedProductDescReadMoreOrReadLessBlock ?: self.clickedProductDescReadMoreOrReadLessBlock();
                                 }];
        } else {
            // 查看更多
            NSAttributedString *readMoreStr = [[NSMutableAttributedString alloc] initWithString:WMLocalizedString(@"read_more", @"展开")
                                                                                     attributes:@{NSForegroundColorAttributeName: HDAppTheme.color.C3, NSFontAttributeName: HDAppTheme.font.standard3}];
            // 省略号
            NSAttributedString *rellipsisStr =
                [[NSMutableAttributedString alloc] initWithString:@" ... " attributes:@{NSForegroundColorAttributeName: HDAppTheme.color.G2, NSFontAttributeName: HDAppTheme.font.standard3}];

            // 获取前 maxRowCount 行内容
            YYTextLine *thirdLine = textLayout.lines[maxRowCount - 1];
            appendingStr = [appendingStr attributedSubstringFromRange:NSMakeRange(0, thirdLine.range.location + thirdLine.range.length)];

            [text appendAttributedString:appendingStr];
            [text appendAttributedString:rellipsisStr];

            // 查看更多之前
            NSAttributedString *strBeforeReadMore;
            [text appendAttributedString:readMoreStr];

            // 取了前 maxRowCount 行，拼接内容肯定超过 maxRowCount 行
            BOOL isNewRowCountLessThanMaxRowCount = false;
            // 循环判断拼接后的内容是否在 maxRowCount 行以内，超过 maxRowCount 行内容减 1，兼容了 emoji 字符情况
            while (!isNewRowCountLessThanMaxRowCount) {
                NSMutableAttributedString *newText = [[NSMutableAttributedString alloc] init];
                NSString *newAppendingStr = [appendingStr.string hd_substringAvoidBreakingUpCharacterSequencesToIndex:appendingStr.string.length - 1 lessValue:true
                                                                                       countingNonASCIICharacterAsTwo:false];

                appendingStr = [[NSMutableAttributedString alloc] initWithString:newAppendingStr
                                                                      attributes:@{NSForegroundColorAttributeName: HDAppTheme.color.G2, NSFontAttributeName: HDAppTheme.font.standard3}];

                [newText appendAttributedString:appendingStr];
                [newText appendAttributedString:rellipsisStr];

                strBeforeReadMore = newText.mutableCopy;
                [newText appendAttributedString:readMoreStr];

                YYTextLayout *newTextLayout = [YYTextLayout layoutWithContainerSize:CGSizeMake(self.contentLabelPreferredMaxLayoutWidth, CGFLOAT_MAX) text:newText];
                isNewRowCountLessThanMaxRowCount = newTextLayout.rowCount <= maxRowCount;
                text = newText;
            }

            @HDWeakify(self);
            [text yy_setTextHighlightRange:NSMakeRange(strBeforeReadMore.length, text.length - strBeforeReadMore.length) color:HDAppTheme.color.C1 backgroundColor:UIColor.clearColor
                                 tapAction:^(UIView *_Nonnull containerView, NSAttributedString *_Nonnull text, NSRange range, CGRect rect) {
                                     @HDStrongify(self);
                                     !self.clickedProductDescReadMoreOrReadLessBlock ?: self.clickedProductDescReadMoreOrReadLessBlock();
                                 }];
        }
    } else {
        self.descLB.numberOfLines = self.model.numberOfLinesOfProductDescLabel;
        [text appendAttributedString:appendingStr];
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = [SAMultiLanguageManager isCurrentLanguageCN] ? 9 : 7.2;
    NSRange range = NSMakeRange(0, [text length]);
    [text addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];

    self.descLB.attributedText = text;
}

#pragma mark - layout
- (void)updateConstraints {
    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(kRealWidth(15));
        make.left.equalTo(self.contentView).offset(HDAppTheme.value.padding.left);
        make.right.equalTo(self.contentView).offset(-HDAppTheme.value.padding.right);
    }];

    [self.showPriceLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLB);
        make.top.equalTo(self.nameLB.mas_bottom).offset(kRealWidth(10));
    }];

    [self.linePriceLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.showPriceLB.mas_right).offset(kRealWidth(7));
        make.centerY.equalTo(self.showPriceLB.mas_centerY);
    }];
    [self.soldLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLB);
        make.top.equalTo(self.showPriceLB.mas_bottom).offset(kRealWidth(6));
    }];

    [self.floatLayoutView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.floatLayoutView.isHidden) {
            CGFloat width = kScreenWidth - 2 * HDAppTheme.value.padding.left;
            make.top.equalTo(self.soldLB.mas_bottom).offset(kRealWidth(6));
            make.left.equalTo(self.contentView.mas_left).offset(HDAppTheme.value.padding.left);
            CGSize size = [self.floatLayoutView sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
            make.size.mas_equalTo(size);
        }
    }];

    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.iconIV.isHidden) {
            UIView *view = self.floatLayoutView.isHidden ? self.soldLB : self.floatLayoutView;
            make.left.equalTo(self.nameLB);
            make.size.mas_equalTo(CGSizeMake(kIconWidth, kIconWidth));
            make.top.equalTo(view.mas_bottom).offset(kRealWidth(15));
        }
    }];

    [self.descLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.descLB.isHidden) {
            make.left.equalTo(self.iconIV.mas_right).offset(kMarginContent2Icon);
            make.top.equalTo(self.iconIV);
        }
    }];

    [self.addBTN sizeToFit];
    [self.addBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.addBTN.isHidden) {
            make.size.mas_equalTo(self.addBTN.bounds.size);
            make.centerY.equalTo(self.showPriceLB);
            make.right.equalTo(self.contentView).offset(-HDAppTheme.value.padding.right);
        }
    }];

    [self.countView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.countView.isHidden) {
            make.bottom.equalTo(self.showPriceLB);
            make.right.equalTo(self.contentView).offset(-HDAppTheme.value.padding.right);
        }
    }];

    [self.customizeBTN sizeToFit];
    [self.customizeBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.customizeBTN.isHidden) {
            make.size.mas_equalTo(self.customizeBTN.bounds.size);
            make.centerY.equalTo(self.showPriceLB);
            make.right.equalTo(self.contentView).offset(-HDAppTheme.value.padding.right);
        }
    }];

    [self.stackUsageLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.stackUsageLB.isHidden) {
            make.left.equalTo(self.nameLB);
            make.right.equalTo(self.nameLB);
            if (!self.iconIV.isHidden) {
                make.top.greaterThanOrEqualTo(self.iconIV.mas_bottom).offset(kRealWidth(8));
                make.top.greaterThanOrEqualTo(self.descLB.mas_bottom).offset(kRealWidth(8));
            } else {
                UIView *view = self.floatLayoutView.isHidden ? self.soldLB : self.floatLayoutView;
                make.top.greaterThanOrEqualTo(view.mas_bottom).offset(kRealWidth(20));
                if (!self.countView.isHidden) {
                    make.top.greaterThanOrEqualTo(self.countView.mas_bottom).offset(kRealWidth(8));
                }
                if (!self.addBTN.isHidden) {
                    make.top.greaterThanOrEqualTo(self.addBTN.mas_bottom).offset(kRealWidth(8));
                }
            }
        }
    }];

    [self.sepView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.stackUsageLB.isHidden) {
            if (!self.iconIV.isHidden) {
                // icon 与 descLB 同时显示或者隐藏
                make.top.greaterThanOrEqualTo(self.iconIV.mas_bottom).offset(kRealWidth(12));
                make.top.greaterThanOrEqualTo(self.descLB.mas_bottom).offset(kRealWidth(12));
            } else {
                UIView *view = self.floatLayoutView.isHidden ? self.soldLB : self.floatLayoutView;
                make.top.greaterThanOrEqualTo(view.mas_bottom).offset(kRealWidth(12));
                if (!self.countView.isHidden) {
                    make.top.greaterThanOrEqualTo(self.countView.mas_bottom).offset(kRealWidth(12));
                }
                if (!self.addBTN.isHidden) {
                    make.top.greaterThanOrEqualTo(self.addBTN.mas_bottom).offset(kRealWidth(12));
                }
            }
        } else {
            make.top.equalTo(self.stackUsageLB.mas_bottom).offset(kRealWidth(12));
        }
        make.left.width.equalTo(self.contentView);
        make.height.mas_equalTo(6);
        make.bottom.equalTo(self.contentView);
    }];

    [super updateConstraints];
}

#pragma mark - lazy load
- (UIImageView *)iconIV {
    if (!_iconIV) {
        UIImageView *imageView = UIImageView.new;
        imageView.image = [UIImage imageNamed:@"store_product_detail_promotion"];
        _iconIV = imageView;
    }
    return _iconIV;
}

- (SALabel *)nameLB {
    if (!_nameLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard2Bold;
        label.textColor = HDAppTheme.color.G1;
        label.numberOfLines = 0;
        _nameLB = label;
    }
    return _nameLB;
}

- (YYLabel *)descLB {
    if (!_descLB) {
        YYLabel *label = YYLabel.new;
        label.numberOfLines = 0;
        label.preferredMaxLayoutWidth = self.contentLabelPreferredMaxLayoutWidth;
        _descLB = label;
    }
    return _descLB;
}

- (SALabel *)showPriceLB {
    if (!_showPriceLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard2Bold;
        label.textColor = HDAppTheme.color.money;
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

- (SALabel *)soldLB {
    if (!_soldLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard4;
        label.textColor = HDAppTheme.color.G2;
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

- (WMOperationButton *)addBTN {
    if (!_addBTN) {
        WMOperationButton *button = [WMOperationButton buttonWithStyle:WMOperationButtonStyleSolid];
        [button setTitle:WMLocalizedString(@"add_product", @"添加 +") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(addBTNClickedHandler) forControlEvents:UIControlEventTouchUpInside];
        button.titleEdgeInsets = UIEdgeInsetsMake(5, 16, 5, 16);
        button.titleLabel.font = HDAppTheme.font.standard3Bold;
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
        button.titleEdgeInsets = UIEdgeInsetsMake(5, 16, 5, 16);
        button.titleLabel.font = HDAppTheme.font.standard3Bold;
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
            if (self.shouldShowChooseSkuAndPropertyView) {
                [self invokeChooseGoodsPropertyAndSkuViewBlock];
                return NO;
            }
            return self.goodsCountShouldChangeBlock ? self.goodsCountShouldChangeBlock(self.model, type, count) : YES;
        };
        _countView.changedCountHandler = ^(SAModifyShoppingCountViewOperationType type, NSUInteger count) {
            @HDStrongify(self);
            !self.goodsCountChangedBlock ?: self.goodsCountChangedBlock(self.model, type, count);
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
        self.oldCount = _countView.count;
    }
    return _countView;
}

- (UIView *)sepView {
    if (!_sepView) {
        _sepView = UIView.new;
        _sepView.backgroundColor = HDAppTheme.color.G5;
    }
    return _sepView;
}

- (HDLabel *)stackUsageLB {
    if (!_stackUsageLB) {
        _stackUsageLB = HDLabel.new;
        _stackUsageLB.numberOfLines = 0;
        _stackUsageLB.hd_edgeInsets = UIEdgeInsetsMake(kRealWidth(4), kRealWidth(8), kRealWidth(4), kRealWidth(8));
        _stackUsageLB.textColor = HDAppTheme.WMColor.B9;
        _stackUsageLB.font = [HDAppTheme.WMFont wm_ForSize:11];
        _stackUsageLB.layer.backgroundColor = [HDAppTheme.WMColor.B6 colorWithAlphaComponent:0.05].CGColor;
        _stackUsageLB.layer.cornerRadius = kRealWidth(8);
    }
    return _stackUsageLB;
}

- (CGFloat)contentLabelPreferredMaxLayoutWidth {
    return kScreenWidth - UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding) - kMarginContent2Icon - kIconWidth;
}
@end
