//
//  WMChooseGoodsPropertyAndSkuView.m
//  SuperApp
//
//  Created by VanJay on 2020/5/14.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMChooseGoodsPropertyAndSkuView.h"
#import "SAModifyShoppingCountView.h"
#import "SAOperationButton.h"
#import "WMChooseGoodsPropertyView.h"
#import "WMChooseGoodsSpecificationView.h"
#import "WMOperationButton.h"
#import "WMPromotionLabel.h"
#import "WMPropertyTagButton.h"
#import "WMStoreDetailPromotionModel.h"
#import "WMStoreGoodsItem.h"
#import "SAMoneyTools.h"

#define kMarginTitle2Top kRealWidth(15)
#define kMarginLine1_2Title kRealWidth(15)
#define kMarginSkuTitle2Line1 kRealWidth(15)
#define kMarginFloatLayout2Title kRealWidth(10)
#define kMarginSkuContainer2SkuTitle kRealWidth(8)
#define kMarginOptionTitle2LastView kRealWidth(15)
#define kMarginOptionMaxCount2OptionTitle kRealWidth(5)
#define kMarginOptionContainer2OptionMaxcount kRealWidth(5)
#define kMarginLine2_2OptionContainer kRealWidth(15)
#define kMarginAddToCartBTNVSide kRealWidth(15)
#define KLineHeight PixelOne


@interface WMChooseGoodsPropertyAndSkuView ()
/// 模型
@property (nonatomic, strong) WMStoreGoodsItem *model;
/// 今日可购买特价商品数量
@property (nonatomic, assign) NSUInteger availableBestSaleCount;
/// 标题
@property (nonatomic, strong) SALabel *titleLB;
/// 关闭按钮
@property (nonatomic, strong) HDUIButton *closeBTN;
/// 滚动容器
@property (nonatomic, strong) UIScrollView *scrollView;
/// 分割线
@property (nonatomic, strong) UIView *sepLine1;
/// 优惠信息
@property (nonatomic, strong) HDFloatLayoutView *floatLayoutView;
/// 规格标题
@property (nonatomic, strong) SALabel *skuTitleLB;
/// 规格容器
@property (nonatomic, strong) HDGridView *skuContainer;
/// 规格必选
@property (nonatomic, strong) SALabel *skuRequireLB;
/// 分割线
@property (nonatomic, strong) UIView *sepLine2;
/// 修改数量 View
@property (nonatomic, strong) SAModifyShoppingCountView *countView;
/// 删除按钮
@property (nonatomic, strong) WMOperationButton *addToCartBTN;
/// 所有的属性标题
@property (nonatomic, strong) NSMutableArray<SALabel *> *optionLBList;
/// 所有的属性是否必选Label
@property (nonatomic, strong) NSMutableArray<SALabel *> *optionRequireLBList;
/// 所有的属性最大选择几个Label
@property (nonatomic, strong) NSMutableArray<SALabel *> *optionMaxCountLBList;
/// 所有的属性容器
@property (nonatomic, strong) NSMutableArray<HDGridView *> *optionContainerList;
/// 当前选中的规格
@property (nonatomic, strong) WMChooseGoodsSpecificationView *selectedSpecificationView;
/// 当前属性选中的按钮记录
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray<WMChooseGoodsPropertyView *> *> *selectedOptionViewDict;
/// 价格
@property (nonatomic, strong) SALabel *priceLB;
@end


@implementation WMChooseGoodsPropertyAndSkuView

- (instancetype)initWithStoreGoodsItem:(WMStoreGoodsItem *)model availableBestSaleCount:(NSUInteger)availableBestSaleCount {
    if (self = [super init]) {
        // 清空规格属性选择
        [model.specificationList enumerateObjectsUsingBlock:^(WMStoreGoodsProductSpecification *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            obj.isSelected = false;
        }];
        [model.propertyList enumerateObjectsUsingBlock:^(WMStoreGoodsProductProperty *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            [obj.optionList enumerateObjectsUsingBlock:^(WMStoreGoodsProductPropertyOption *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                obj.isSelected = false;
            }];
        }];

        self.model = model;
        self.availableBestSaleCount = availableBestSaleCount;
        self.allowTapBackgroundDismiss = true;
        self.transitionStyle = HDActionAlertViewTransitionStyleSlideFromBottom;
        [self configPromotions];
    }
    return self;
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
            [self.floatLayoutView addSubview:obj];
        }];
    }
    [self setNeedsUpdateConstraints];
}

#pragma mark - HDActionAlertViewOverridable
- (void)layoutContainerView {
    CGFloat containerHeight = 0;

    containerHeight += kMarginTitle2Top;
    containerHeight += self.titleLBSize.height;
    containerHeight += kMarginLine1_2Title;
    containerHeight += KLineHeight;
    if (!self.floatLayoutView.isHidden) {
        containerHeight += kMarginFloatLayout2Title;
        CGFloat width = kScreenWidth - 2 * HDAppTheme.value.padding.left;
        CGSize size = [self.floatLayoutView sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
        containerHeight += size.height;
    }
    containerHeight += kMarginSkuTitle2Line1;
    containerHeight += self.skuTitleLBSize.height;
    containerHeight += kMarginSkuContainer2SkuTitle;
    containerHeight += [self sizeWithContainer:self.skuContainer].height;
    containerHeight += KLineHeight;

    containerHeight += kiPhoneXSeriesSafeBottomHeight;

    containerHeight += (kMarginOptionTitle2LastView * self.model.propertyList.count);

    for (SALabel *optionTitleLB in self.optionLBList) {
        CGFloat maxTitleWidth = self.containerViewWidth - UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding);
        CGSize size = [optionTitleLB sizeThatFits:CGSizeMake(maxTitleWidth, CGFLOAT_MAX)];
        containerHeight += size.height;
    }
    for (SALabel *optionMaxCountLB in self.optionMaxCountLBList) {
        if (optionMaxCountLB.isHidden) {
            break;
        }
        CGFloat maxTitleWidth = self.containerViewWidth - UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding);
        CGSize size = [optionMaxCountLB sizeThatFits:CGSizeMake(maxTitleWidth, CGFLOAT_MAX)];
        containerHeight += (kMarginOptionMaxCount2OptionTitle + size.height + kMarginOptionContainer2OptionMaxcount);
    }
    for (HDGridView *containerView in self.optionContainerList) {
        containerHeight += [self sizeWithContainer:containerView].height;
    }
    containerHeight += kMarginLine2_2OptionContainer;
    containerHeight += self.addToCartBTN.height;
    containerHeight += 2 * kMarginAddToCartBTNVSide;

    // 最大不超过屏幕 80%
    if (containerHeight > kScreenHeight * 0.8) {
        containerHeight = kScreenHeight * 0.8;
    }

    CGFloat top = kScreenHeight - containerHeight;
    CGFloat left = (kScreenWidth - self.containerViewWidth) * 0.5;
    self.containerView.frame = CGRectMake(left, top, self.containerViewWidth, containerHeight);

    if (!CGSizeEqualToSize(self.containerView.frame.size, CGSizeZero)) {
        [self.containerView setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:10];
    }
}

- (void)setupContainerViewAttributes {
    // 设置containerview的属性,比如切边啥的
    self.containerView.layer.masksToBounds = YES;
}

- (void)setupContainerSubViews {
    [self.containerView addSubview:self.titleLB];
    [self.containerView addSubview:self.closeBTN];
    [self.containerView addSubview:self.floatLayoutView];
    [self.containerView addSubview:self.sepLine1];
    [self.containerView addSubview:self.scrollView];
    [self.scrollView addSubview:self.skuRequireLB];
    [self.scrollView addSubview:self.skuTitleLB];
    [self.scrollView addSubview:self.skuContainer];
    [self.containerView addSubview:self.sepLine2];
    [self.containerView addSubview:self.countView];
    [self.containerView addSubview:self.addToCartBTN];
    [self.containerView addSubview:self.priceLB];

    self.titleLB.text = self.model.name;
    self.skuTitleLB.text = WMLocalizedString(@"specification", @"Specification");
    [self.skuContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (WMStoreGoodsProductSpecification *specificationModel in self.model.specificationList) {
        WMChooseGoodsSpecificationView *specificationView = WMChooseGoodsSpecificationView.new;

        specificationModel.isSelected = [self.model.specificationList indexOfObject:specificationModel] == 0;
        if (specificationModel.isSelected) {
            self.selectedSpecificationView = specificationView;
        }
        specificationModel.isLast = [self.model.specificationList indexOfObject:specificationModel] == self.model.specificationList.count - 1;
        specificationView.model = specificationModel;
        [self.skuContainer addSubview:specificationView];
        @HDWeakify(self);
        @HDWeakify(specificationView);
        specificationView.clickedSelectBTNBlock = ^(HDUIButton *_Nonnull button) {
            @HDStrongify(self);
            @HDStrongify(specificationView);
            [specificationView setSelectBtnSelected:true];
            [self.selectedSpecificationView setSelectBtnSelected:false];
            self.selectedSpecificationView = specificationView;
            NSUInteger otherSkuCount = self.model.currentCountInShoppingCart;
            NSUInteger avaialbeStock = self.model.availableStock - otherSkuCount > 0 ? (self.model.availableStock - otherSkuCount > 150 ? 150 : self.model.availableStock - otherSkuCount) : 0;
            self.countView.maxCount = avaialbeStock;
            [self updatePriceText];
        };
    }
    [self.optionLBList removeAllObjects];
    [self.optionRequireLBList removeAllObjects];
    [self.optionMaxCountLBList removeAllObjects];
    [self.optionContainerList removeAllObjects];
    [self.selectedOptionViewDict removeAllObjects];
    // 添加属性
    for (WMStoreGoodsProductProperty *propertyModel in self.model.propertyList) {
        SALabel *titleLB = SALabel.new;
        titleLB.textColor = HDAppTheme.color.G1;
        titleLB.font = HDAppTheme.font.standard2Bold;
        titleLB.text = propertyModel.name;
        titleLB.numberOfLines = 0;
        [self.scrollView addSubview:titleLB];
        [self.optionLBList addObject:titleLB];

        SALabel *requireLB = SALabel.new;
        requireLB.textColor = HDAppTheme.color.G2;
        requireLB.font = HDAppTheme.font.standard4;
        requireLB.text
            = propertyModel.required ? [NSString stringWithFormat:WMLocalizedString(@"7c8ZBMsK", @"%zd Required"), propertyModel.requiredSelection] : WMLocalizedString(@"708ZBMsK", @"Optional");
        [self.scrollView addSubview:requireLB];
        [self.optionRequireLBList addObject:requireLB];

        SALabel *maxCountLB = SALabel.new;
        maxCountLB.textColor = HDAppTheme.color.G2;
        maxCountLB.font = HDAppTheme.font.standard4;
        maxCountLB.text = [NSString stringWithFormat:WMLocalizedString(@"7m8ZBMsK", @"Select up to %zd"), propertyModel.maxSelection];
        maxCountLB.hidden = propertyModel.maxSelection == 0 || propertyModel.required;
        [self.scrollView addSubview:maxCountLB];
        [self.optionMaxCountLBList addObject:maxCountLB];

        // 添加
        HDGridView *container = HDGridView.new;
        container.columnCount = 1;
        container.rowHeight = 44;
        [self.scrollView addSubview:container];
        [self.optionContainerList addObject:container];

        for (WMStoreGoodsProductPropertyOption *optionModel in propertyModel.optionList) {
            WMChooseGoodsPropertyView *propertyView = WMChooseGoodsPropertyView.new;
            // 必选默认勾选前n个
            if (propertyModel.required) {
                optionModel.isSelected = [propertyModel.optionList indexOfObject:optionModel] < propertyModel.requiredSelection;
            }
            // 已选加入字典中
            if (optionModel.isSelected) {
                NSMutableArray *propertyViews = self.selectedOptionViewDict[optionModel.propertyId] ?: @[].mutableCopy;
                [propertyViews addObject:propertyView];
                self.selectedOptionViewDict[optionModel.propertyId] = propertyViews;
            }
            propertyView.model = optionModel;
            [container addSubview:propertyView];
            @HDWeakify(self);
            @HDWeakify(propertyView);
            propertyView.clickedSelectBTNBlock = ^BOOL(HDUIButton *_Nonnull button) {
                @HDStrongify(self);
                @HDStrongify(propertyView);
                NSUInteger chooseCount = !self.selectedOptionViewDict[optionModel.propertyId] ? 0 : self.selectedOptionViewDict[optionModel.propertyId].count;
                NSUInteger maxSelection = propertyModel.required ? propertyModel.requiredSelection : propertyModel.maxSelection;
                if (!button.isSelected && chooseCount >= maxSelection && maxSelection > 1) {
                    // 已选属性个数大于最大选择个数，无法选择
                    [NAT showToastWithTitle:nil content:[NSString stringWithFormat:WMLocalizedString(@"7m8ZBMsK", @"Select up to %zd"), maxSelection] type:HDTopToastTypeInfo];
                    return NO;
                } else {
                    if (maxSelection == 1 && propertyModel.required && button.isSelected) { // 必选一项时无法取消选中
                        return NO;
                    }
                    if (maxSelection == 1 && !button.isSelected) { // 只能选择一项时，直接切换
                        [self.selectedOptionViewDict[optionModel.propertyId] enumerateObjectsUsingBlock:^(WMChooseGoodsPropertyView *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                            [obj setSelectBtnSelected:false];
                        }];
                        self.selectedOptionViewDict[optionModel.propertyId] = @[propertyView].mutableCopy;
                    } else {
                        NSMutableArray *propertyViews = self.selectedOptionViewDict[optionModel.propertyId] ?: @[].mutableCopy;
                        self.selectedOptionViewDict[optionModel.propertyId] = propertyViews;
                        if (button.isSelected) { // 取消选择
                            [propertyViews removeObject:propertyView];
                        } else { // 选择
                            [propertyViews addObject:propertyView];
                        }
                    }
                    [self updatePriceText];
                    return YES;
                }
            };
        }
    }
    NSUInteger otherSkuCount = self.model.currentCountInShoppingCart;
    NSUInteger avaialbeStock = self.model.availableStock - otherSkuCount > 0 ? (self.model.availableStock - otherSkuCount > 150 ? 150 : self.model.availableStock - otherSkuCount) : 0;
    self.countView.maxCount = avaialbeStock;

    [self updatePriceText];
}

- (void)layoutContainerViewSubViews {
    [self.titleLB hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(HDAppTheme.value.padding.left);
        make.top.hd_equalTo(kMarginTitle2Top);
        make.size.hd_equalTo(self.titleLBSize);
    }];

    [self.closeBTN sizeToFit];
    [self.closeBTN hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.centerY.hd_equalTo(self.titleLB.centerY);
        make.right.hd_equalTo(self.containerView.right).offset(-kRealWidth(10));
    }];

    [self.floatLayoutView hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        if (!self.floatLayoutView.isHidden) {
            CGFloat width = kScreenWidth - 2 * HDAppTheme.value.padding.left;
            make.top.hd_equalTo(self.titleLB.bottom).offset(kMarginFloatLayout2Title);
            make.left.hd_equalTo(HDAppTheme.value.padding.left);
            CGSize size = [self.floatLayoutView sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
            make.size.hd_equalTo(size);
        }
    }];

    [self.sepLine1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        UIView *view = self.floatLayoutView.isHidden ? self.titleLB : self.floatLayoutView;
        make.height.hd_equalTo(KLineHeight);
        make.left.hd_equalTo(HDAppTheme.value.padding.left);
        make.right.hd_equalTo(self.containerView.right).offset(-HDAppTheme.value.padding.right);
        make.top.hd_equalTo(view.bottom).offset(kMarginLine1_2Title);
    }];

    [self.addToCartBTN sizeToFit];
    [self.addToCartBTN hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.bottom.hd_equalTo(self.containerView.height).offset(-(kiPhoneXSeriesSafeBottomHeight + kMarginAddToCartBTNVSide));
        make.right.hd_equalTo(self.containerView.right).offset(-HDAppTheme.value.padding.right);
    }];

    [self updateCountViewFrame];
    [self updatePriceFrame];

    [self.sepLine2 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.height.hd_equalTo(KLineHeight);
        make.left.hd_equalTo(0);
        make.right.hd_equalTo(self.containerView.right);
        make.bottom.hd_equalTo(self.addToCartBTN.top).offset(-kMarginAddToCartBTNVSide);
    }];

    [self.scrollView hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(HDAppTheme.value.padding.left);
        make.right.hd_equalTo(self.containerView.right).offset(-HDAppTheme.value.padding.right);
        make.top.hd_equalTo(self.sepLine1.bottom);
        make.height.hd_equalTo(self.sepLine2.top - self.sepLine1.bottom);
    }];
    [self.skuTitleLB hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(0);
        make.top.hd_equalTo(kMarginSkuTitle2Line1);
        make.size.hd_equalTo(self.skuTitleLBSize);
    }];
    [self.skuContainer hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.top.hd_equalTo(self.skuTitleLB.bottom).offset(kMarginSkuContainer2SkuTitle);
        make.left.hd_equalTo(0);
        make.size.hd_equalTo([self sizeWithContainer:self.skuContainer]);
    }];
    [self.skuRequireLB hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.right.hd_equalTo(self.scrollView.width);
        make.centerY.hd_equalTo(self.skuTitleLB.centerY);
    }];
    SALabel *lastOptionTitleLB;
    HDGridView *lastGridView = self.skuContainer;
    CGFloat maxFlowLayoutViewWidth = self.containerViewWidth - UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding);
    for (SALabel *optionTitleLB in self.optionLBList) {
        NSUInteger index = [self.optionLBList indexOfObject:optionTitleLB];
        SALabel *optionRequirdLB = self.optionRequireLBList[index];
        [optionRequirdLB sizeToFit];

        CGFloat maxTitleWidth = self.containerViewWidth - HDAppTheme.value.padding.left - optionRequirdLB.width - kRealWidth(10);
        [optionTitleLB hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            make.left.hd_equalTo(0);
            make.top.hd_equalTo(lastGridView.bottom).offset(kMarginOptionTitle2LastView);
            make.size.hd_equalTo([optionTitleLB sizeThatFits:CGSizeMake(maxTitleWidth, CGFLOAT_MAX)]);
        }];
        lastOptionTitleLB = optionTitleLB;

        [optionRequirdLB hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            make.right.hd_equalTo(self.scrollView.width);
            make.centerY.hd_equalTo(optionTitleLB.centerY);
        }];

        SALabel *optionMaxcountLB = self.optionMaxCountLBList[index];
        if (!optionMaxcountLB.isHidden) {
            [optionMaxcountLB hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
                make.left.hd_equalTo(optionTitleLB.left);
                make.top.hd_equalTo(optionTitleLB.bottom).offset(kMarginOptionMaxCount2OptionTitle);
            }];
        }

        HDGridView *gridView = self.optionContainerList[[self.optionLBList indexOfObject:optionTitleLB]];
        [gridView hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            UIView *view = optionMaxcountLB.isHidden ? optionTitleLB : optionMaxcountLB;
            CGFloat margin = optionMaxcountLB.isHidden ? kMarginOptionContainer2OptionMaxcount + kMarginOptionContainer2OptionMaxcount : kMarginOptionContainer2OptionMaxcount;
            make.left.hd_equalTo(0);
            make.top.hd_equalTo(view.bottom).offset(margin);
            make.size.hd_equalTo([gridView sizeThatFits:CGSizeMake(maxFlowLayoutViewWidth, CGFLOAT_MAX)]);
        }];
        lastGridView = gridView;
    }
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, lastGridView.bottom + kMarginLine2_2OptionContainer);
}

- (void)updateCountViewFrame {
    [self.countView hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.right.hd_equalTo(self.addToCartBTN.left).offset(-kRealWidth(25));
        make.centerY.hd_equalTo(self.addToCartBTN.centerY);
        make.size.hd_equalTo([self.countView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize]);
    }];
}

- (void)updatePriceFrame {
    [self.priceLB hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(HDAppTheme.value.padding.left);
        make.centerY.hd_equalTo(self.addToCartBTN.centerY);
        make.right.hd_equalTo(self.countView.left).offset(-kRealWidth(5));
        make.height.hd_equalTo(40);
    }];
}

- (void)updatePriceText {
    if (self.model.bestSale && self.model.currentCountInShoppingCart < self.availableBestSaleCount) {
        [self updateBestSaleGoodsPriceText];
    } else {
        [self updateNormalGoodsPriceText];
    }

    [self updatePriceFrame];
    [self updateAddToCartBTN];
}

// 更新普通商品价格文字（去除特价商品）
- (void)updateNormalGoodsPriceText {
    NSDecimalNumber *salePrice = [NSDecimalNumber decimalNumberWithString:self.selectedSpecificationView.model.salePrice];
    salePrice = [salePrice decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"100"]];
    SAMoneyModel *singleSaleMoney = [SAMoneyModel modelWithAmount:salePrice.stringValue currency:@"USD"];
    if (!singleSaleMoney) { // 未选择，显示0
        singleSaleMoney = SAMoneyModel.new;
        singleSaleMoney.cent = @"0";
    }
    __block long cent = singleSaleMoney.cent.integerValue;
    for (WMStoreGoodsProductProperty *propertyModel in self.model.propertyList) {
        [self.selectedOptionViewDict[propertyModel.propertyId] enumerateObjectsUsingBlock:^(WMChooseGoodsPropertyView *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
//            cent += obj.model.additionalPrice.cent.integerValue;
            cent += (long)(obj.model.additionalPrice.doubleValue * 100);
        }];
    }
    singleSaleMoney.cent = [NSString stringWithFormat:@"%ld", cent];

    SAMoneyModel *singleShowMoney = [WMStoreGoodsPromotionModel calculateShowPriceWithProductPromotions:self.model.productPromotion salePrice:singleSaleMoney];

    SAMoneyModel *singleLineMoney = [WMStoreGoodsPromotionModel calculateLinePriceWithProductPromotions:self.model.productPromotion salePrice:singleSaleMoney];

    long showMoney = singleSaleMoney.cent.integerValue * self.countView.count;
    NSInteger promotionCount = 0;
    if (!HDIsObjectNil(self.model.productPromotion) && self.model.productPromotion.limitValue > 0) {
        // 当前可优惠的商品数量
        promotionCount = MIN(self.countView.count, MAX(0, (NSInteger)self.model.productPromotion.limitValue - (NSInteger)self.model.currentCountInShoppingCart));
        if (promotionCount > 0) {
            showMoney = singleShowMoney.cent.integerValue * promotionCount + singleSaleMoney.cent.integerValue * (self.countView.count - promotionCount);
        }
    }

    singleShowMoney.cent = [NSString stringWithFormat:@"%ld", showMoney];

    NSMutableAttributedString *priceAttributedString =
        [[NSMutableAttributedString alloc] initWithString:singleShowMoney.thousandSeparatorAmount
                                               attributes:@{NSFontAttributeName: HDAppTheme.font.standard2Bold, NSForegroundColorAttributeName: HDAppTheme.color.money}];

    if (singleLineMoney && promotionCount > 0) {
        [priceAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
        singleLineMoney.cent = [NSString stringWithFormat:@"%ld", singleLineMoney.cent.integerValue * self.countView.count];
        NSString *linePriceStr = singleLineMoney.thousandSeparatorAmount;
        NSAttributedString *linePriceAttributedString = [[NSAttributedString alloc] initWithString:linePriceStr attributes:@{
            NSFontAttributeName: HDAppTheme.font.standard3,
            NSForegroundColorAttributeName: HDAppTheme.color.G3,
            NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle | NSUnderlinePatternSolid),
            NSStrikethroughColorAttributeName: HDAppTheme.color.G3
        }];
        [priceAttributedString appendAttributedString:linePriceAttributedString];
    }

    self.priceLB.attributedText = priceAttributedString;
}

// 更新特价商品价格文字
- (void)updateBestSaleGoodsPriceText {
//    SAMoneyModel *singleMoney = self.selectedSpecificationView.model.salePrice.copy;
    NSString *amount = [NSString stringWithFormat:@"%ld",(NSInteger)(self.selectedSpecificationView.model.salePrice.doubleValue * 100)];
    SAMoneyModel *singleMoney = [SAMoneyModel modelWithAmount:amount currency:@"USD"];
    if (!singleMoney) { // 未选择，显示0
        singleMoney = SAMoneyModel.new;
        singleMoney.cent = @"0";
    }
    __block long cent = singleMoney.cent.integerValue;
    for (WMStoreGoodsProductProperty *propertyModel in self.model.propertyList) {
        [self.selectedOptionViewDict[propertyModel.propertyId] enumerateObjectsUsingBlock:^(WMChooseGoodsPropertyView *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
//            cent += obj.model.additionalPrice.cent.integerValue;
            cent += (long)(obj.model.additionalPrice.doubleValue * 100);
        }];
    }
    singleMoney.cent = [NSString stringWithFormat:@"%ld", cent];

    SAMoneyModel *totalMoney = SAMoneyModel.new;
    totalMoney.cy = singleMoney.cy;
    totalMoney.cent = [NSString stringWithFormat:@"%ld", singleMoney.cent.integerValue * self.countView.count];

    NSMutableAttributedString *priceAttributedString =
//        [[NSMutableAttributedString alloc] initWithString:self.model.discountPrice.thousandSeparatorAmount
//    [[NSMutableAttributedString alloc] initWithString:self.model.discountPrice
    [[NSMutableAttributedString alloc] initWithString:[SAMoneyTools thousandSeparatorAmountYuan:self.model.discountPrice currencyCode:@"USD"]
                                               attributes:@{NSFontAttributeName: HDAppTheme.font.standard2Bold, NSForegroundColorAttributeName: HDAppTheme.color.money}];
    [priceAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    NSAttributedString *linePriceAttributedString = [[NSAttributedString alloc] initWithString:totalMoney.thousandSeparatorAmount attributes:@{
        NSFontAttributeName: HDAppTheme.font.standard3,
        NSForegroundColorAttributeName: HDAppTheme.color.G3,
        NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle | NSUnderlinePatternSolid),
        NSStrikethroughColorAttributeName: HDAppTheme.color.G3
    }];
    [priceAttributedString appendAttributedString:linePriceAttributedString];

    self.priceLB.attributedText = priceAttributedString;
}

- (void)updateAddToCartBTN {
    // 判断规格是否选择
    if (!self.selectedSpecificationView) {
        self.addToCartBTN.enabled = false;
        return;
    }
    // 判断属性是否选择
    for (WMStoreGoodsProductProperty *propertyModel in self.model.propertyList) {
        NSArray *optionList = [self.selectedOptionViewDict[propertyModel.propertyId] mapObjectsUsingBlock:^id _Nonnull(WMChooseGoodsPropertyView *_Nonnull obj, NSUInteger idx) {
            return obj.model;
        }];
        if (propertyModel.required && optionList.count < propertyModel.requiredSelection) {
            self.addToCartBTN.enabled = false;
            return;
        }
    }

    self.addToCartBTN.enabled = true;
}

#pragma mark - event response
- (void)clickedCloseBTNHandler {
    [self dismiss];
}

- (void)clickedAddToCartBTNHandler {
    NSUInteger count = self.countView.count;
    WMStoreGoodsProductSpecification *skuModel = self.selectedSpecificationView.model;
    NSUInteger maxCount = self.model.availableStock > 150 ? 150 : self.model.availableStock;
    maxCount -= self.model.currentCountInShoppingCart;
    // 先判断库存
    if (count > maxCount) {
        [NAT showToastWithTitle:nil content:WMLocalizedString(@"temporarily_out_of_stock", @"库存不足") type:HDTopToastTypeWarning];
        return;
    }

    // 判断属性是否选择
    NSMutableArray<WMStoreGoodsProductPropertyOption *> *propertyOptionList = [NSMutableArray array];
    for (WMStoreGoodsProductProperty *propertyModel in self.model.propertyList) {
        NSArray *optionList = [self.selectedOptionViewDict[propertyModel.propertyId] mapObjectsUsingBlock:^id _Nonnull(WMChooseGoodsPropertyView *_Nonnull obj, NSUInteger idx) {
            return obj.model;
        }];
        if (propertyModel.required && optionList.count != propertyModel.requiredSelection) {
            [NAT showToastWithTitle:nil content:[NSString stringWithFormat:WMLocalizedString(@"7G8ZBMsK", @"%@属性必须选%zd项"), propertyModel.name, propertyModel.requiredSelection]
                               type:HDTopToastTypeInfo];
            return;
        }
        [propertyOptionList addObjectsFromArray:optionList];
    }

    WMManage.shareInstance.selectGoodId = self.model.goodId;
    if ([WMStoreGoodsPromotionModel isJustOverMaxStockWithProductPromotions:self.model.productPromotion currentCount:count otherSkuCount:self.model.currentCountInShoppingCart]) {
        if (self.model.productPromotion.type != WMStoreGoodsPromotionLimitTypeDayProNum && self.model.productPromotion.type != WMStoreGoodsPromotionLimitTypeActivityTotalNum) {
            [NAT showToastWithTitle:nil content:[NSString stringWithFormat:WMLocalizedString(@"668ZBMsK", @"Only %zd items can enjoy discounted prices."), self.model.productPromotion.limitValue]
                               type:HDTopToastTypeInfo];
        }
    }
    if (self.model.bestSale) {
        NSUInteger otherBestSaleGoodsPurchaseQuantity = !self.otherBestSaleGoodsPurchaseQuantityInStoreShoppingCart ? 0 : self.otherBestSaleGoodsPurchaseQuantityInStoreShoppingCart(self.model);
        NSArray<WMStoreDetailPromotionModel *> *promotions = !self.storeShoppingCartPromotions ? @[] : self.storeShoppingCartPromotions();
        if ([WMPromotionLabel showToastWithMaxCount:self.availableBestSaleCount currentCount:count otherSkuCount:self.model.currentCountInShoppingCart + otherBestSaleGoodsPurchaseQuantity
                                         promotions:promotions]) {
            [NAT showToastWithTitle:nil content:[NSString stringWithFormat:WMLocalizedString(@"668ZBMsK", @"Only %zd items can enjoy discounted prices."), self.availableBestSaleCount]
                               type:HDTopToastTypeInfo];
        }
    }
    !self.addToCartBlock ?: self.addToCartBlock(count, skuModel, propertyOptionList);
    [self clickedCloseBTNHandler];
}

#pragma mark - private methods
- (CGFloat)containerViewWidth {
    return kScreenWidth;
}

- (CGSize)titleLBSize {
    CGFloat maxTitleWidth
        = self.containerViewWidth - UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding) - UIEdgeInsetsGetHorizontalValue(self.closeBTN.imageEdgeInsets) - self.closeBTN.imageView.image.size.width;
    return [self.titleLB sizeThatFits:CGSizeMake(maxTitleWidth, CGFLOAT_MAX)];
}

- (CGSize)skuTitleLBSize {
    CGFloat maxTitleWidth = self.containerViewWidth - UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding);
    return [self.skuTitleLB sizeThatFits:CGSizeMake(maxTitleWidth, CGFLOAT_MAX)];
}

- (CGSize)sizeWithContainer:(UIView *)container {
    CGFloat width = self.containerViewWidth - UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding);
    return [container sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
}

#pragma mark - lazy load
- (SALabel *)titleLB {
    if (!_titleLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard2Bold;
        label.textColor = HDAppTheme.color.G1;
        label.numberOfLines = 0;
        _titleLB = label;
    }
    return _titleLB;
}

- (HDUIButton *)closeBTN {
    if (!_closeBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        button.imageEdgeInsets = UIEdgeInsetsMake(15, 30, 15, 15);
        [button addTarget:self action:@selector(clickedCloseBTNHandler) forControlEvents:UIControlEventTouchUpInside];
        _closeBTN = button;
    }
    return _closeBTN;
}

- (UIView *)sepLine1 {
    if (!_sepLine1) {
        _sepLine1 = UIView.new;
        _sepLine1.backgroundColor = HDAppTheme.color.G4;
    }
    return _sepLine1;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = UIScrollView.new;
        _scrollView.showsVerticalScrollIndicator = false;
        _scrollView.alwaysBounceVertical = true;
    }
    return _scrollView;
}

- (HDFloatLayoutView *)floatLayoutView {
    if (!_floatLayoutView) {
        _floatLayoutView = [[HDFloatLayoutView alloc] init];
        _floatLayoutView.itemMargins = UIEdgeInsetsMake(0, 0, 8, 5);
    }
    return _floatLayoutView;
}

- (SALabel *)skuTitleLB {
    if (!_skuTitleLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard2Bold;
        label.textColor = HDAppTheme.color.G1;
        label.numberOfLines = 0;
        _skuTitleLB = label;
    }
    return _skuTitleLB;
}

- (SALabel *)skuRequireLB {
    if (!_skuRequireLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard4;
        label.textColor = HDAppTheme.color.G2;
        label.numberOfLines = 0;
        label.text = [NSString stringWithFormat:WMLocalizedString(@"7c8ZBMsK", @"%zd Required"), 1];
        _skuRequireLB = label;
    }
    return _skuRequireLB;
}

- (HDGridView *)skuContainer {
    if (!_skuContainer) {
        _skuContainer = HDGridView.new;
        _skuContainer.columnCount = 1;
        _skuContainer.rowHeight = 44;
    }
    return _skuContainer;
}

- (UIView *)sepLine2 {
    if (!_sepLine2) {
        _sepLine2 = UIView.new;
        _sepLine2.backgroundColor = HDAppTheme.color.G4;
    }
    return _sepLine2;
}

- (SAModifyShoppingCountView *)countView {
    if (!_countView) {
        _countView = SAModifyShoppingCountView.new;
        _countView.minusIcon = @"yn_store_minus";
        _countView.plusIcon = @"yn_store_plus";
        [_countView updateCount:1];
        @HDWeakify(self);
        _countView.changedCountHandler = ^(SAModifyShoppingCountViewOperationType type, NSUInteger count) {
            @HDStrongify(self);
            
            if(count <= 0){
                [self dismiss];
            }else{
                [self updateCountViewFrame];
                [self updatePriceText];
                if (type == SAModifyShoppingCountViewOperationTypePlus) {
                    WMManage.shareInstance.selectGoodId = self.model.goodId;
                    [WMStoreGoodsPromotionModel isJustOverMaxStockWithProductPromotions:self.model.productPromotion currentCount:count otherSkuCount:self.model.currentCountInShoppingCart];
                    if (self.model.bestSale) {
                        NSUInteger otherBestSaleGoodsPurchaseQuantity
                        = !self.otherBestSaleGoodsPurchaseQuantityInStoreShoppingCart ? 0 : self.otherBestSaleGoodsPurchaseQuantityInStoreShoppingCart(self.model);
                        NSArray<WMStoreDetailPromotionModel *> *promotions = !self.storeShoppingCartPromotions ? @[] : self.storeShoppingCartPromotions();
                        [WMPromotionLabel showToastWithMaxCount:self.availableBestSaleCount currentCount:count otherSkuCount:self.model.currentCountInShoppingCart + otherBestSaleGoodsPurchaseQuantity
                                                     promotions:promotions];
                    }
                }
            }
        };
        _countView.maxCountLimtedHandler = ^(NSUInteger count) {
            [NAT showToastWithTitle:nil content:WMLocalizedString(@"temporarily_out_of_stock", @"库存不足") type:HDTopToastTypeWarning];
        };
        _countView.minCount = 0;
    }
    return _countView;
}

- (WMOperationButton *)addToCartBTN {
    if (!_addToCartBTN) {
        WMOperationButton *button = [WMOperationButton buttonWithStyle:WMOperationButtonStyleSolid];
        button.titleEdgeInsets = UIEdgeInsetsMake(10, 30, 10, 30);
        button.titleLabel.font = HDAppTheme.font.standard2Bold;
        [button setTitle:WMLocalizedStringFromTable(@"add_to_cart", @"Add to Cart", @"Buttons") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickedAddToCartBTNHandler) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        button.enabled = false;
        _addToCartBTN = button;
    }
    return _addToCartBTN;
}

- (NSMutableArray<SALabel *> *)optionLBList {
    if (!_optionLBList) {
        _optionLBList = [NSMutableArray arrayWithCapacity:self.model.propertyList.count];
    }
    return _optionLBList;
}

- (NSMutableArray<SALabel *> *)optionRequireLBList {
    if (!_optionRequireLBList) {
        _optionRequireLBList = [NSMutableArray arrayWithCapacity:self.model.propertyList.count];
    }
    return _optionRequireLBList;
}

- (NSMutableArray<SALabel *> *)optionMaxCountLBList {
    if (!_optionMaxCountLBList) {
        _optionMaxCountLBList = [NSMutableArray arrayWithCapacity:self.model.propertyList.count];
    }
    return _optionMaxCountLBList;
}

- (NSMutableArray<HDGridView *> *)optionContainerList {
    if (!_optionContainerList) {
        _optionContainerList = [NSMutableArray arrayWithCapacity:self.model.propertyList.count];
    }
    return _optionContainerList;
}

- (NSMutableDictionary<NSString *, NSMutableArray<WMChooseGoodsPropertyView *> *> *)selectedOptionViewDict {
    if (!_selectedOptionViewDict) {
        _selectedOptionViewDict = [NSMutableDictionary dictionaryWithCapacity:self.model.propertyList.count];
    }
    return _selectedOptionViewDict;
}

- (SALabel *)priceLB {
    if (!_priceLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard2Bold;
        label.textColor = HDAppTheme.color.money;
        label.numberOfLines = 2;
        _priceLB = label;
    }
    return _priceLB;
}

@end
