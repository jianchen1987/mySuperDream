//
//  WMShoppingCartTableViewCell.m
//  SuperApp
//
//  Created by VanJay on 2020/5/13.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMShoppingCartTableViewCell.h"
#import "HDPopViewManager.h"
#import "SAInfoView.h"
#import "SAOperationButton.h"
#import "SAShadowBackgroundView.h"
#import "WMOrderSubmitPromotionItemView.h"
#import "WMPromotionLabel.h"
#import "WMShoppingCartProductView.h"
#import "WMShoppingCartStoreItem.h"
#import "WMShoppingItemsPayFeeTrialCalRspModel.h"


@interface WMShoppingCartTableViewCell ()
/// 背景
@property (nonatomic, strong) UIView *bgView;
/// 选择状态按钮
@property (nonatomic, strong) HDUIButton *selectBTN;
/// 门店名称
@property (nonatomic, strong) SALabel *titleLB;
/// 分割线
@property (nonatomic, strong) UIView *sepLine1;
/// 商品容器
@property (nonatomic, strong) UIView *goodsContainer;
/// 分割线
@property (nonatomic, strong) UIView *sepLine2;
/// 增值税
@property (nonatomic, strong) SAInfoView *vatFeeView;
/// 打包费
@property (nonatomic, strong) SAInfoView *packingFeeView;
/// 活动金额
@property (nonatomic, strong) SAInfoView *promotionFeeView;
/// 打折
@property (nonatomic, strong) WMOrderSubmitPromotionItemView *lessFeeView;
/// 满减
@property (nonatomic, strong) WMOrderSubmitPromotionItemView *offFeeView;
/// 首单减免
@property (nonatomic, strong) WMOrderSubmitPromotionItemView *firstFeeView;
/// 优惠券
@property (nonatomic, strong) WMOrderSubmitPromotionItemView *couponFeeView;
/// 金额
@property (nonatomic, strong) SALabel *moneyLB;
/// 操作按钮
@property (nonatomic, strong) SAOperationButton *operationBTN;
/// 获取选中项商品模型数组
@property (nonatomic, strong) NSMutableArray<WMShoppingCartStoreProduct *> *selectedProducts;
/// 所有的属性
@property (nonatomic, strong) NSMutableArray *infoViewList;
/// 优惠活动
@property (nonatomic, strong) YYLabel *floatLayoutLB;

@end


@implementation WMShoppingCartTableViewCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.selectBTN];
    [self.contentView addSubview:self.titleLB];
    [self.contentView addSubview:self.sepLine1];
    [self.contentView addSubview:self.goodsContainer];
    [self.contentView addSubview:self.sepLine2];
    [self.contentView addSubview:self.vatFeeView];
    [self.contentView addSubview:self.packingFeeView];
    [self.contentView addSubview:self.promotionFeeView];
    [self.contentView addSubview:self.lessFeeView];
    [self.contentView addSubview:self.offFeeView];
    [self.contentView addSubview:self.firstFeeView];
    [self.contentView addSubview:self.couponFeeView];
    [self.contentView addSubview:self.moneyLB];
    [self.contentView addSubview:self.operationBTN];
    [self.contentView addSubview:self.floatLayoutLB];

    [self.infoViewList addObject:self.vatFeeView];
    [self.infoViewList addObject:self.packingFeeView];
    //    [self.infoViewList addObject:self.promotionFeeView];

    [self.infoViewList addObject:self.lessFeeView];
    [self.infoViewList addObject:self.couponFeeView];
    [self.infoViewList addObject:self.offFeeView];
    [self.infoViewList addObject:self.firstFeeView];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (CGRectIsEmpty(self.frame))
        return;

    [self.bgView setNeedsDisplay];
}
- (void)setOnEditing:(BOOL)onEditing {
    _onEditing = onEditing;
}
- (void)setModel:(WMShoppingCartStoreItem *)model {
    _model = model;

    const BOOL isStoreClosed = [model.merchantStoreStatus isEqualToString:WMShopppingCartStoreStatusClosed];
    const BOOL isStoreResting = [model.merchantStoreStatus isEqualToString:WMShopppingCartStoreStatusResting];
    const BOOL isStoreOpening = [model.merchantStoreStatus isEqualToString:WMShopppingCartStoreStatusOpening];
    ///爆单不可接单
    const BOOL isFullOrder = (model.fullOrderState == WMStoreFullOrderStateFullAndStop);
    if (self.onEditing) {
        self.selectBTN.selected = model.isDeleteSelected;
        self.selectBTN.enabled = YES;
    } else {
        self.selectBTN.selected = model.isSelected;
        self.selectBTN.enabled = isStoreOpening;
    }

    self.titleLB.text = model.storeName.desc;

    [self.goodsContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.selectedProducts removeAllObjects];
    for (WMShoppingCartStoreProduct *product in model.goodsList) {
        product.storeStatus = model.merchantStoreStatus;
        WMShoppingCartProductView *productView = WMShoppingCartProductView.new;
        if (product.isSelected && product.canSelected) {
            // 如果是选中的（试算里面只会有选中的商品信息），从试算数据中获取最新商品价格更新本地显示
            WMShoppingCartPayFeeCalProductModel *destFeeCalProductModel;
            for (WMShoppingCartPayFeeCalProductModel *feeCalProductModel in model.feeTrialCalRspModel.products) {
                if ([feeCalProductModel.productId isEqualToString:product.goodsId] && [feeCalProductModel.specId isEqualToString:product.goodsSkuId]) {
                    destFeeCalProductModel = feeCalProductModel;
                    break;
                }
            }
            if (!HDIsObjectNil(destFeeCalProductModel)) {
                //                product.salePrice = destFeeCalProductModel.salePrice.copy;
                //                product.discountPrice = destFeeCalProductModel.discountPrice.copy;
                product.inEffectVersionId = destFeeCalProductModel.inEffectVersionId;
            }
            [self.selectedProducts addObject:product];
        } else {
            product.isSelected = false;
            [self.selectedProducts removeObject:product];
        }
        product.needShowBottomLine = product == model.goodsList.lastObject ? true : false;
        productView.onEditing = self.onEditing;
        productView.model = product;
        [self dealingWithProductViewBlock:productView];
        [self.goodsContainer addSubview:productView];
    }

    [self updateCouponActivity];

    //如果是处于编辑状态  就不用处理以下的视图 全部隐藏
    if (self.onEditing) {
        self.vatFeeView.hidden = YES;
        self.packingFeeView.hidden = YES;
        self.promotionFeeView.hidden = YES;
        self.offFeeView.hidden = YES;
        self.lessFeeView.hidden = YES;
        self.couponFeeView.hidden = YES;
        self.firstFeeView.hidden = YES;
        self.operationBTN.hidden = YES;
        self.moneyLB.hidden = YES;
        [self setNeedsUpdateConstraints];
        return;
    } else {
        self.offFeeView.hidden = NO;
        self.lessFeeView.hidden = NO;
        self.couponFeeView.hidden = NO;
        self.firstFeeView.hidden = NO;
        self.operationBTN.hidden = NO;
        self.moneyLB.hidden = NO;
    }

    SAMoneyModel *promotionMoney = [self configPromotions:self.model];
    // 计算小计金额
    SAMoneyModel *totalMoney = HDIsObjectNil(model.feeTrialCalRspModel.totalAmount) ? model.totalProductMoney.copy : model.feeTrialCalRspModel.totalAmount.copy;
    // 加上打包费，减去优惠价格
    totalMoney.cent = [NSString stringWithFormat:@"%zd", totalMoney.cent.integerValue + model.feeTrialCalRspModel.packageFee.cent.integerValue - promotionMoney.cent.integerValue];

    const BOOL hasSelectedProduct = !HDIsArrayEmpty(self.selectedProducts);
    BOOL isReachRequiredPrice = totalMoney.cent.doubleValue >= model.realRequiredPrice.cent.doubleValue;
    self.operationBTN.userInteractionEnabled = isStoreClosed || (isStoreOpening && !HDIsArrayEmpty(self.selectedProducts) && isReachRequiredPrice);
    self.operationBTN.borderWidth = isStoreClosed ? 1 : 0;
    self.operationBTN.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(6), kRealWidth(16), kRealWidth(6), kRealWidth(16));
    // 操作按钮处理
    if (isStoreClosed) {
        [self.operationBTN applyPropertiesWithStyle:SAOperationButtonStyleHollow];
        [self.operationBTN setTitleColor:HDAppTheme.color.G1 forState:UIControlStateNormal];
        self.operationBTN.borderColor = HDAppTheme.color.G4;
        [self.operationBTN setTitle:WMLocalizedStringFromTable(@"delete", @"删除", @"Buttons") forState:UIControlStateNormal];
    } else if (isStoreResting) {
        [self.operationBTN applyPropertiesWithStyle:SAOperationButtonStyleSolid];
        [self.operationBTN applyPropertiesWithBackgroundColor:HDAppTheme.color.G4];
        [self.operationBTN setTitle:WMLocalizedString(@"cart_resting", @"休息中") forState:UIControlStateNormal];
    } else if (isStoreOpening) {
        ///爆单停止接单
        if (isFullOrder) {
            NSString *text = [NSString stringWithFormat:WMLocalizedString(@"wm_store_busy_before", @"%@分钟后可下单"), @"30"];
            [self.operationBTN applyPropertiesWithStyle:SAOperationButtonStyleSolid];
            [self.operationBTN applyPropertiesWithBackgroundColor:[HDAppTheme.color.mainColor colorWithAlphaComponent:0.2]];
            [self.operationBTN setTitle:[NSString stringWithFormat:@"%@·%@", WMLocalizedString(@"wm_store_busy", @"繁忙"), text] forState:UIControlStateNormal];
            self.operationBTN.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(6), kRealWidth(12), kRealWidth(6), kRealWidth(12));
        } else {
            // 判断已有可选并且超过起送价
            if (!hasSelectedProduct || !isReachRequiredPrice) {
                [self.operationBTN applyPropertiesWithStyle:SAOperationButtonStyleSolid];
                [self.operationBTN applyPropertiesWithBackgroundColor:[HDAppTheme.color.mainColor colorWithAlphaComponent:0.2]];
                [self.operationBTN setTitle:[NSString stringWithFormat:WMLocalizedString(@"some_money_to_send", @"%@起送"), model.realRequiredPrice.thousandSeparatorAmount]
                                   forState:UIControlStateNormal];
                self.operationBTN.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(6), kRealWidth(12), kRealWidth(6), kRealWidth(12));
            } else {
                // self.operationBTN.backgroundColor = HDAppTheme.color.mainColor;
                [self.operationBTN applyPropertiesWithStyle:SAOperationButtonStyleSolid];
                [self.operationBTN applyPropertiesWithBackgroundColor:[HDAppTheme.color.mainColor colorWithAlphaComponent:1.0]];
                [self.operationBTN setTitle:WMLocalizedString(@"cart_order_now", @"结算") forState:UIControlStateNormal];
            }
        }
    }
    // 设置 VAT
    SAMoneyModel *vatMoney = HDIsObjectNil(model.feeTrialCalRspModel.vat) ? model.valueAddedTax : model.feeTrialCalRspModel.vat;
    NSNumber *vatRate = HDIsObjectNil(model.feeTrialCalRspModel.vatRate) ? model.vatRate : [NSNumber numberWithDouble:model.feeTrialCalRspModel.vatRate.doubleValue];
    [self updateVATContentWithVATMoney:vatMoney vatRate:vatRate];

    // 设置包装费
    SAMoneyModel *packingFee = HDIsObjectNil(model.feeTrialCalRspModel.packageFee) ? model.packingFee : model.feeTrialCalRspModel.packageFee;
    [self updatePackageFeeContentWithPackageFee:packingFee];

    // 设置金额
    self.moneyLB.hidden = !isStoreClosed && ((isStoreResting || !hasSelectedProduct) || HDIsObjectNil(model.feeTrialCalRspModel));
    if (!self.moneyLB.isHidden) {
        if (isStoreClosed) {
            self.moneyLB.textColor = HDAppTheme.color.G1;
            self.moneyLB.font = HDAppTheme.font.standard4;
            self.moneyLB.text = WMLocalizedString(@"the_store_have_stopped_operation", @"门店已停止营业");
        } else if (isStoreOpening) {
            [self updateTotalMoneyTextWithTotalMoney:totalMoney];
        }
    }
    if (HDIsArrayEmpty(self.selectedProducts)) {
        self.offFeeView.hidden = YES;
        self.lessFeeView.hidden = YES;
        self.couponFeeView.hidden = YES;
        self.firstFeeView.hidden = YES;
    }
    // setModel 之后调用一次以在界面初次加载后正确决定是否发起试算
    if (HDIsObjectNil(model.feeTrialCalRspModel)) {
        BOOL needUpdatePrice = false;
        for (WMShoppingCartStoreProduct *product in self.selectedProductList) {
            if (product.bestSale) {
                needUpdatePrice = true;
                break;
            }
        }
        [self adjustShouldInvokeFeeTrialBlockNeedUpdatePrice:needUpdatePrice needShowRequiredPriceChangeToast:false];
    }

    [self setNeedsUpdateConstraints];
}

- (void)updateCouponActivity {
    ///优惠活动
    self.floatLayoutLB.hidden = HDIsArrayEmpty(self.model.couponActivtyModel.coupons);
    if (!self.floatLayoutLB.isHidden) {
        NSMutableArray *arr = NSMutableArray.new;
        WMUIButton *btn = [WMPromotionLabel createBtnWithBackGroundColor:HDAppTheme.WMColor.bg3 titleColor:HDAppTheme.WMColor.mainRed title:WMLocalizedString(@"wm_get_storecoupon", @"领取门店优惠券")
                                                                   alpha:1
                                                                  border:HDAppTheme.WMColor.mainRed];
        [arr addObject:btn];
        NSMutableAttributedString *tagString = NSMutableAttributedString.new;
        [arr enumerateObjectsUsingBlock:^(HDUIGhostButton *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            NSMutableAttributedString *objStr = [NSMutableAttributedString yy_attachmentStringWithContent:obj contentMode:UIViewContentModeCenter attachmentSize:obj.frame.size
                                                                                              alignToFont:obj.titleLabel.font
                                                                                                alignment:YYTextVerticalAlignmentCenter];
            if (idx != arr.count - 1) {
                NSMutableAttributedString *spaceText = [NSMutableAttributedString yy_attachmentStringWithContent:[[UIImage alloc] init] contentMode:UIViewContentModeScaleToFill
                                                                                                  attachmentSize:CGSizeMake(kRealWidth(4), 1)
                                                                                                     alignToFont:[UIFont systemFontOfSize:0]
                                                                                                       alignment:YYTextVerticalAlignmentCenter];
                [objStr appendAttributedString:spaceText];
            }
            [tagString appendAttributedString:objStr];
        }];
        tagString.yy_lineSpacing = kRealWidth(4);
        self.floatLayoutLB.attributedText = tagString;
    } else {
        self.floatLayoutLB.attributedText = nil;
    }
}

- (SAMoneyModel *)configPromotions:(WMShoppingCartStoreItem *)model {
    // 过滤减配送费的活动
    NSArray<WMStoreDetailPromotionModel *> *noneReduceDeliveryPromotions = [model.feeTrialCalRspModel.promotions hd_filterWithBlock:^BOOL(WMStoreDetailPromotionModel *_Nonnull item) {
        return item.marketingType != WMStorePromotionMarketingTypeDelievry;
    }];

    self.offFeeView.hidden = YES;
    self.lessFeeView.hidden = YES;
    self.couponFeeView.hidden = YES;
    self.firstFeeView.hidden = YES;
    __block double money = [model.feeTrialCalRspModel.freeProductDiscountAmount.cent doubleValue];
    if (!HDIsArrayEmpty(self.selectedProducts)) {
        // 爆款商品活动不与平台折扣/平台满减/门店满减同享
        if (model.feeTrialCalRspModel.freeBestSaleDiscountAmount.cent.integerValue != 0) {
            money += model.feeTrialCalRspModel.freeBestSaleDiscountAmount.cent.doubleValue;
        } else if (!HDIsArrayEmpty(noneReduceDeliveryPromotions)) {
            [noneReduceDeliveryPromotions enumerateObjectsUsingBlock:^(WMStoreDetailPromotionModel *_Nonnull promotionModel, NSUInteger idx, BOOL *_Nonnull stop) {
                double currentMoney = 0.0;
                if (promotionModel.marketingType == WMStorePromotionMarketingTypeDiscount) {
                    // 取折扣减免金额
                    currentMoney = model.feeTrialCalRspModel.freeDiscountAmount.cent.doubleValue;
                } else if (promotionModel.marketingType == WMStorePromotionMarketingTypeLabber || promotionModel.marketingType == WMStorePromotionMarketingTypeStoreLabber) {
                    WMStoreLadderRuleModel *inUseLadderRuleModel = promotionModel.inUseLadderRuleModel;
                    if (inUseLadderRuleModel) {
                        // 取满减减免金额
                        currentMoney = model.feeTrialCalRspModel.freeFullReductionAmount.cent.doubleValue;
                    }
                } else if (promotionModel.marketingType == WMStorePromotionMarketingTypeCoupon) {
                    WMStoreLadderRuleModel *inUseLadderRuleModel = promotionModel.inUseLadderRuleModel;
                    if (inUseLadderRuleModel) {
                        // 取满减减免金额
                        currentMoney = model.feeTrialCalRspModel.freeFullReductionAmount.cent.doubleValue;
                    }
                }
                money += currentMoney;
                // 优惠
                BOOL isHidePromotions = currentMoney <= 0 || HDIsArrayEmpty(self.selectedProducts);
                if (!isHidePromotions) {
                    NSString *promotionDesc = @"";
                    if (promotionModel.marketingType == WMStorePromotionMarketingTypeDiscount) {
                        promotionDesc = [NSString stringWithFormat:@"%@", promotionModel.promotionDesc];
                        self.lessFeeView.hidden = NO;
                        self.lessFeeView.leftTitle = promotionDesc;
                        self.lessFeeView.rightTitle = [NSString stringWithFormat:@"-%@", model.feeTrialCalRspModel.freeDiscountAmount.thousandSeparatorAmount];
                    } else if (promotionModel.marketingType == WMStorePromotionMarketingTypeLabber || promotionModel.marketingType == WMStorePromotionMarketingTypeCoupon
                               || promotionModel.marketingType == WMStorePromotionMarketingTypeStoreLabber) {
                        WMStoreLadderRuleModel *inUseLadderRuleModel = promotionModel.inUseLadderRuleModel;
                        if (inUseLadderRuleModel) {
                            NSString *thresholdAmtStr = inUseLadderRuleModel.thresholdAmt.thousandSeparatorAmount;
                            NSString *discountAmtStr = inUseLadderRuleModel.discountAmt.thousandSeparatorAmount;
                            promotionDesc = [NSString stringWithFormat:WMLocalizedString(@"store_money_off_content", @"满%@减%@ "), thresholdAmtStr, discountAmtStr];
                            if (promotionModel.marketingType == WMStorePromotionMarketingTypeLabber || promotionModel.marketingType == WMStorePromotionMarketingTypeStoreLabber) {
                                self.offFeeView.hidden = NO;
                                self.offFeeView.leftTitle = promotionDesc;
                                self.offFeeView.rightTitle = [NSString stringWithFormat:@"-%@", model.feeTrialCalRspModel.freeFullReductionAmount.thousandSeparatorAmount];
                            } else {
                                self.couponFeeView.hidden = NO;
                                self.couponFeeView.leftTitle = promotionDesc;
                                self.couponFeeView.rightTitle = [NSString stringWithFormat:@"-%@", model.feeTrialCalRspModel.freeFullReductionAmount.thousandSeparatorAmount];
                            }
                        } else {
                            HDLog(@"优惠类型为满减优惠，但后台未标识使用了哪个梯度优惠");
                        }
                    } else if (promotionModel.marketingType == WMStorePromotionMarketingTypeDelievry) {
                        promotionDesc = [NSString stringWithFormat:@"%@", WMLocalizedString(@"wm_free_delivery", @"减免配送费")];
                    } else if (promotionModel.marketingType == WMStorePromotionMarketingTypeCoupon) {
                        promotionDesc = [NSString stringWithFormat:WMLocalizedString(@"wm_coupon_format", @"Coupon %@"), model.feeTrialCalRspModel.freeFirstOrderAmount.thousandSeparatorAmount];
                        self.couponFeeView.hidden = NO;
                        self.couponFeeView.leftTitle = promotionDesc;
                        self.couponFeeView.rightTitle = [NSString stringWithFormat:@"-%@", model.feeTrialCalRspModel.freeFirstOrderAmount.thousandSeparatorAmount];
                    }
                }
            }];
        }
    }

    SAMoneyModel *promotionMoney = SAMoneyModel.new;
    promotionMoney.cy = model.totalProductMoney.cy;
    promotionMoney.cent = [NSString stringWithFormat:@"%f", money];
    return promotionMoney;
}

#pragma mark - public methods
- (BOOL)isSelected {
    return self.model.isSelected;
}

- (NSArray<WMShoppingCartStoreProduct *> *)selectedProductList {
    return self.selectedProducts;
}

- (void)removeSelectedProductModelFromSelectedProductList:(WMShoppingCartStoreProduct *)productModel {
    [self.selectedProducts removeObject:productModel];

    if (self.goodsContainer.subviews.count <= 1) {
        !self.deletedLastProductBlock ?: self.deletedLastProductBlock(self.model.merchantDisplayNo);
    }
}

#pragma mark - private methods
- (void)setSelectBtnSelected:(BOOL)selected {
    self.selectBTN.selected = selected;
    self.model.isSelected = selected;
}

- (void)adjustSelectBTNState {
    BOOL isAllItemSelected = true;
    for (WMShoppingCartProductView *view in self.goodsContainer.subviews) {
        if ([view isKindOfClass:WMShoppingCartProductView.class]) {
            if (!view.model.isSelected) {
                isAllItemSelected = false;
                break;
            }
        }
    }
    [self setSelectBtnSelected:isAllItemSelected];
}

/// 单个商品选中状态变化触发选中列表统计
/// @param isSelected 是否选中
/// @param productModel 单个的商品模型
- (void)statisticSelectedProductsListWithSingleItemSelected:(BOOL)isSelected model:(WMShoppingCartStoreProduct *)productModel {
    if (isSelected) {
        [self.selectedProducts addObject:productModel];
    } else {
        [self.selectedProducts removeObject:productModel];
    }
    if (isSelected && productModel.bestSale) {
        // 判断是否包含互斥活动 currentCount、otherSkuCount值无效
        [WMPromotionLabel showToastWithMaxCount:self.model.availableBestSaleCount currentCount:0 otherSkuCount:0 promotions:self.model.feeTrialCalRspModel.promotions];
    }
    [self adjustShouldInvokeFeeTrialBlockNeedUpdatePrice:productModel.bestSale needShowRequiredPriceChangeToast:true];
}

- (void)updateTotalMoneyTextWithTotalMoney:(SAMoneyModel *)totalMoney {
    self.moneyLB.hidden = false;

    NSAttributedString *totalStr = [[NSAttributedString alloc] initWithString:WMLocalizedString(@"sub_total", @"小计")
                                                                   attributes:@{NSFontAttributeName: HDAppTheme.font.standard2Bold, NSForegroundColorAttributeName: HDAppTheme.color.G1}];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString:totalStr];
    [text appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    if (HDIsStringNotEmpty(totalMoney.thousandSeparatorAmount)) {
        NSAttributedString *moneyStr = [[NSAttributedString alloc] initWithString:totalMoney.thousandSeparatorAmount
                                                                       attributes:@{NSFontAttributeName: HDAppTheme.font.standard2Bold, NSForegroundColorAttributeName: HDAppTheme.color.money}];
        [text appendAttributedString:moneyStr];
    }
    self.moneyLB.attributedText = text;
}

- (void)dealingWithProductViewBlock:(WMShoppingCartProductView *)productView {
    @HDWeakify(self);
    @HDWeakify(productView);
    productView.clickedDeleteBTNBlock = ^{
        @HDStrongify(self);
        @HDStrongify(productView);

        // 弹窗确认
        [NAT showAlertWithMessage:WMLocalizedString(@"do_you_want_to_delete_item", @"确认删除商品吗？") confirmButtonTitle:WMLocalizedString(@"cart_not_now", @"暂时不")
            confirmButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                [alertView dismiss];
            }
            cancelButtonTitle:WMLocalizedStringFromTable(@"delete", @"删除", @"Buttons") cancelButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                [alertView dismiss];
                !self.deleteSingleGoodsBlock ?: self.deleteSingleGoodsBlock(productView.model);

                if (self.goodsContainer.subviews.count <= 1) {
                    !self.deletedLastProductBlock ?: self.deletedLastProductBlock(self.model.merchantDisplayNo);
                }
            }];
    };
    productView.countShouldChangeBlock = ^BOOL(BOOL isIncrease, NSUInteger count) {
        @HDStrongify(self);
        @HDStrongify(productView);
        return self.goodsCountShouldChange ? self.goodsCountShouldChange(productView.model, isIncrease, count) : YES;
    };
    productView.countChangedBlock = ^(BOOL isIncrease, NSUInteger changedTo, void (^_Nonnull afterSuccessBlock)(void)) {
        @HDStrongify(self);
        @HDStrongify(productView);
        if (isIncrease) {
            WMManage.shareInstance.selectGoodId = productView.model.goodsId;
            [WMStoreGoodsPromotionModel isJustOverMaxStockWithProductPromotions:productView.model.productPromotion currentCount:[self chooseCountWithCurrentProduct:productView.model] + changedTo
                                                                  otherSkuCount:0];
            if (productView.model.bestSale) {
                [WMPromotionLabel showToastWithMaxCount:self.model.availableBestSaleCount currentCount:[self chooseCountWithCurrentProduct:productView.model] + changedTo
                                          otherSkuCount:[self otherBestSaleGoodsCountInStoreShoppingCartWithOutGoods:productView.model]
                                             promotions:self.model.feeTrialCalRspModel.promotions];
            }
        }
        !self.goodsCountChangedBlock ?: self.goodsCountChangedBlock(productView.model, changedTo, afterSuccessBlock);
    };

    productView.maxCountLimtedHandler = ^(NSUInteger count) {
        [NAT showToastWithTitle:nil content:[NSString stringWithFormat:WMLocalizedString(@"Only_left_in_stock", @"库存仅剩 %zd 件"), count] type:HDTopToastTypeWarning];
    };
    productView.clickedSelectBTNBlock = ^(BOOL isSelected, WMShoppingCartStoreProduct *_Nonnull productModel) {
        @HDStrongify(self);
        !self.userDidDoneSomeActionBlock ?: self.userDidDoneSomeActionBlock();
        [self adjustSelectBTNState];
        [self statisticSelectedProductsListWithSingleItemSelected:isSelected model:productModel];
    };
    productView.clickedProductViewBlock = ^{
        @HDStrongify(self);
        @HDStrongify(productView);
        !self.clickedProductViewBlock ?: self.clickedProductViewBlock(productView.model);
    };
    ///编辑状态下点击商品回调
    productView.onEditingSelectedProductBlock = ^(WMShoppingCartStoreProduct *_Nonnull productModel) {
        @HDStrongify(self);
        !self.userDidDoneSomeActionBlock ?: self.userDidDoneSomeActionBlock();
        !self.onEditingSelectedProductBlock ?: self.onEditingSelectedProductBlock(self.model, productModel);
    };
    // 点击减号后，结算按钮不可点击，试算完成后会恢复，防止跳过起送价限制
    productView.clickedMinusBTNHandler = ^{
        @HDStrongify(self);
        self.operationBTN.userInteractionEnabled = false;
    };
}

- (void)updateVATContentWithVATMoney:(SAMoneyModel *)vatMoney vatRate:(NSNumber *)vatRate {
    self.model.valueAddedTax = vatMoney;
    self.model.vatRate = vatRate;

    // 1.5 版本隐藏统一购物车税费显示，暂时关闭显示，日后确定不需要再删除相关代码
    self.vatFeeView.hidden = true;
    // self.vatFeeView.hidden = vatMoney.cent.doubleValue <= 0 || HDIsArrayEmpty(self.selectedProducts);
    if (!self.vatFeeView.isHidden) {
        self.vatFeeView.model.keyText = [NSString stringWithFormat:@"%@(%@%%)", WMLocalizedString(@"vat_fee", @"VAT"), vatRate.stringValue];
        self.vatFeeView.model.valueText = vatMoney.thousandSeparatorAmount;
        [self.vatFeeView setNeedsUpdateContent];
    }
}

- (void)updatePackageFeeContentWithPackageFee:(SAMoneyModel *)packingFee {
    self.model.packingFee = packingFee;

    self.packingFeeView.hidden = packingFee.cent.doubleValue <= 0 || HDIsArrayEmpty(self.selectedProducts);
    if (!self.packingFeeView.isHidden) {
        self.packingFeeView.model.valueText = packingFee.thousandSeparatorAmount;
        [self.packingFeeView setNeedsUpdateContent];
    }
}

- (void)adjustShouldInvokeFeeTrialBlockNeedUpdatePrice:(BOOL)needUpdatePrice needShowRequiredPriceChangeToast:(BOOL)needShowRequiredPriceChangeToast {
    self.model.needShowRequiredPriceChangeToast = needShowRequiredPriceChangeToast;
    if (HDIsArrayEmpty(self.selectedProducts)) {
        if (!HDIsObjectNil(self.model.feeTrialCalRspModel)) {
            self.model.feeTrialCalRspModel = nil;
            !self.reloadBlock ?: self.reloadBlock(self.model.storeNo);
        }
    } else {
        if (![self.model.merchantStoreStatus isEqualToString:WMShopppingCartStoreStatusClosed] && ![self.model.merchantStoreStatus isEqualToString:WMShopppingCartStoreStatusResting]) {
            !self.anyProductSelectStateChangedHandler ?: self.anyProductSelectStateChangedHandler(needUpdatePrice);
        }
    }
}

- (SAInfoViewModel *)infoViewModelWithKey:(NSString *)key {
    SAInfoViewModel *model = SAInfoViewModel.new;
    model.keyColor = HDAppTheme.color.G3;
    model.valueColor = HDAppTheme.color.G1;
    model.keyText = key;
    return model;
}

// 当前购物车中该商品的其他规格选择数量
- (NSUInteger)chooseCountWithCurrentProduct:(WMShoppingCartStoreProduct *)product {
    __block NSUInteger count = 0;
    [self.model.goodsList enumerateObjectsUsingBlock:^(WMShoppingCartStoreProduct *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([obj.identifyObj.goodsId isEqual:product.identifyObj.goodsId] && ![obj.itemDisplayNo isEqualToString:product.itemDisplayNo]) {
            count += obj.purchaseQuantity;
        }
    }];
    return count;
}
// 门店购物车中其他爆款商品数量
- (NSUInteger)otherBestSaleGoodsCountInStoreShoppingCartWithOutGoods:(WMShoppingCartStoreProduct *)currentGoods {
    NSUInteger otherCount = 0;
    for (WMShoppingCartStoreProduct *goods in self.model.goodsList) {
        if (goods.bestSale && ![goods.identifyObj isEqual:currentGoods.identifyObj]) {
            otherCount += goods.purchaseQuantity;
        }
    }
    return otherCount;
}

#pragma mark - event response
- (void)clickedSelectBTNHandler:(HDUIButton *)button {
    !self.userDidDoneSomeActionBlock ?: self.userDidDoneSomeActionBlock();

    button.selected = !button.isSelected;
    if (self.onEditing) {
        self.model.isDeleteSelected = !self.model.isDeleteSelected;
        !self.onEditingSelectedStoreBlock ?: self.onEditingSelectedStoreBlock(self.model);
    } else {
        self.model.isSelected = button.isSelected;

        for (WMShoppingCartProductView *view in self.goodsContainer.subviews) {
            if ([view isKindOfClass:WMShoppingCartProductView.class]) {
                [view setSelectBtnSelected:button.isSelected];
            }
        }
        // 点击了组选择按钮才重新统计，否则应该单个添加\删除
        // 节约性能，防止频繁创建数组
        [self.selectedProducts removeAllObjects];
        for (WMShoppingCartProductView *view in self.goodsContainer.subviews) {
            if ([view isKindOfClass:WMShoppingCartProductView.class]) {
                if (view.model.isSelected) {
                    [self.selectedProducts addObject:view.model];
                }
            }
        }
        BOOL needUpdatePrice = false;
        for (WMShoppingCartStoreProduct *product in self.selectedProductList) {
            if (product.bestSale) {
                needUpdatePrice = true;
                break;
            }
        }
        [self adjustShouldInvokeFeeTrialBlockNeedUpdatePrice:needUpdatePrice needShowRequiredPriceChangeToast:true];
    }
}

- (void)clickedOperationBTNHandler {
    if ([self.model.merchantStoreStatus isEqualToString:WMShopppingCartStoreStatusOpening]) {
        if (!HDIsArrayEmpty(self.selectedProducts)) {
            !self.clickedOrderNowBTNBlock ?: self.clickedOrderNowBTNBlock();
        }
    } else if ([self.model.merchantStoreStatus isEqualToString:WMShopppingCartStoreStatusClosed]) {
        !self.deleteStoreGoodsBlock ?: self.deleteStoreGoodsBlock(self.model.merchantDisplayNo, self.model.storeNo);
    }
}

- (void)clickedStoreTitleHandler {
    !self.userDidDoneSomeActionBlock ?: self.userDidDoneSomeActionBlock();
    if (self.onEditing) {
        self.model.isDeleteSelected = !self.model.isDeleteSelected;
        !self.onEditingSelectedStoreBlock ?: self.onEditingSelectedStoreBlock(self.model);
    } else {
        if ([self.model.merchantStoreStatus isEqualToString:WMShopppingCartStoreStatusClosed]) {
            return;
        }
        !self.clickedStoreTitleBlock ?: self.clickedStoreTitleBlock(self.model.storeNo);
    }
}

#pragma mark - layout
- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(kRealWidth(self.model.isFirstCell ? kRealWidth(12) : kRealWidth(6)));
        make.left.equalTo(self.contentView).offset(kRealWidth(12));
        make.right.equalTo(self.contentView).offset(-kRealWidth(12));
        make.bottom.equalTo(self.contentView).offset(-kRealWidth(self.model.isLastCell ? kRealWidth(12) : kRealWidth(6)));
    }];

    [self.selectBTN sizeToFit];
    [self.selectBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(kRealWidth(12));
        make.top.equalTo(self.bgView).offset(kRealWidth(12));
        make.size.mas_equalTo(self.selectBTN.size);
    }];
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.selectBTN);
        make.left.equalTo(self.selectBTN.mas_right).offset(kRealWidth(8));
        make.right.mas_equalTo(-kRealWidth(12));
        make.height.mas_greaterThanOrEqualTo(kRealWidth(24));
    }];

    [self.floatLayoutLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.floatLayoutLB.isHidden) {
            make.top.hd_equalTo(self.titleLB.mas_bottom).offset(kRealWidth(4));
            make.left.right.equalTo(self.titleLB);
        }
    }];

    const CGFloat lineHeight = PixelOne;
    [self.sepLine1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(lineHeight);
        make.left.right.equalTo(self.bgView);
        if (self.floatLayoutLB.isHidden) {
            make.top.equalTo(self.titleLB.mas_bottom).offset(kRealWidth(12));
        } else {
            make.top.equalTo(self.floatLayoutLB.mas_bottom).offset(kRealWidth(12));
        }
    }];

    [self.goodsContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.top.equalTo(self.sepLine1.mas_bottom);
        if (HDIsArrayEmpty(self.goodsContainer.subviews)) {
            make.height.mas_equalTo(CGFLOAT_MIN);
        }
        if (self.onEditing) {
            make.bottom.equalTo(self.bgView).offset(-kRealWidth(15));
        }
    }];
    WMShoppingCartProductView *lastProductView;
    for (WMShoppingCartProductView *productView in self.goodsContainer.subviews) {
        [productView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (lastProductView) {
                make.top.equalTo(lastProductView.mas_bottom);
            } else {
                make.top.equalTo(self.goodsContainer);
            }
            make.left.equalTo(self.goodsContainer);
            make.right.equalTo(self.goodsContainer);
            if (productView == self.goodsContainer.subviews.lastObject) {
                make.bottom.equalTo(self.goodsContainer);
            }
        }];
        lastProductView = productView;
    }
    if (self.onEditing) { //编辑状态就不管下面的
        [super updateConstraints];
        return;
    }
    [self.sepLine2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.sepLine2.isHidden) {
            make.height.mas_equalTo(lineHeight);
            make.left.equalTo(self.bgView).offset(kRealWidth(10));
            make.right.equalTo(self.bgView).offset(-kRealWidth(10));
            make.top.equalTo(self.goodsContainer.mas_bottom).offset(kRealWidth(15));
        }
    }];
    NSArray<SAInfoView *> *visableInfoViews = [self.infoViewList hd_filterWithBlock:^BOOL(SAInfoView *_Nonnull item) {
        return !item.isHidden;
    }];
    UIView *infoViewRefView = lastProductView ?: self.sepLine2;
    infoViewRefView = infoViewRefView.isHidden ? self.goodsContainer : infoViewRefView;

    SAInfoView *lastInfoView;
    for (SAInfoView *infoView in visableInfoViews) {
        [infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (lastInfoView) {
                make.top.equalTo(lastInfoView.mas_bottom);
            } else {
                make.top.equalTo(infoViewRefView.mas_bottom);
            }
            make.left.equalTo(self.bgView);
            make.right.equalTo(self.bgView);
        }];
        lastInfoView = infoView;
    }

    UIView *moneyRefView = lastInfoView ?: lastProductView;
    moneyRefView = moneyRefView ?: self.sepLine2;
    moneyRefView = moneyRefView.isHidden ? self.goodsContainer : moneyRefView;

    [self.operationBTN sizeToFit];
    [self.operationBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyRefView.mas_bottom).offset(kRealWidth(13));
        make.right.equalTo(self.bgView).offset(-kRealWidth(10));
        make.bottom.lessThanOrEqualTo(self.bgView).offset(-kRealWidth(15));
    }];
    [self.moneyLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.moneyLB.isHidden) {
            make.left.equalTo(self.bgView).offset(kRealWidth(15));
            make.top.greaterThanOrEqualTo(moneyRefView.mas_bottom).offset(kRealWidth(13));
            make.centerY.equalTo(self.operationBTN);
            make.bottom.lessThanOrEqualTo(self.bgView).offset(-kRealWidth(15));
        }
    }];

    [super updateConstraints];
}

#pragma mark - lazy load
- (UIView *)bgView {
    if (!_bgView) {
        UIView *view = UIView.new;
        _bgView = view;
        _bgView.layer.cornerRadius = kRealWidth(8);
        _bgView.layer.backgroundColor = UIColor.whiteColor.CGColor;
    }
    return _bgView;
}

- (HDUIButton *)selectBTN {
    if (!_selectBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        //        button.hd_eventTimeInterval = CGFLOAT_MIN;
        [button setImage:[UIImage imageNamed:@"yn_car_select_nor"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"yn_car_select_sel"] forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:@"yn_car_select_disable"] forState:UIControlStateDisabled];
        button.adjustsButtonWhenHighlighted = false;
        [button addTarget:self action:@selector(clickedSelectBTNHandler:) forControlEvents:UIControlEventTouchUpInside];
        _selectBTN = button;
    }
    return _selectBTN;
}

- (SALabel *)titleLB {
    if (!_titleLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.WMFont wm_boldForSize:16];
        label.textColor = HDAppTheme.WMColor.B3;
        label.numberOfLines = 1;
        label.userInteractionEnabled = true;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedStoreTitleHandler)];
        [label addGestureRecognizer:recognizer];
        _titleLB = label;
    }
    return _titleLB;
}

- (UIView *)sepLine1 {
    if (!_sepLine1) {
        _sepLine1 = UIView.new;
        _sepLine1.backgroundColor = HDAppTheme.color.G4;
    }
    return _sepLine1;
}

- (UIView *)goodsContainer {
    if (!_goodsContainer) {
        _goodsContainer = UIView.new;
    }
    return _goodsContainer;
}

- (UIView *)sepLine2 {
    if (!_sepLine2) {
        _sepLine2 = UIView.new;
        _sepLine2.backgroundColor = HDAppTheme.color.G4;
        _sepLine2.hidden = true;
    }
    return _sepLine2;
}

- (SAInfoView *)vatFeeView {
    if (!_vatFeeView) {
        SAInfoView *view = SAInfoView.new;
        view.model = [self infoViewModelWithKey:WMLocalizedString(@"vat_fee", @"增值税")];
        view.model.keyImage = [UIImage imageNamed:@"wm_shopping_cart_info"];
        @HDWeakify(view);
        view.model.clickedKeyButtonHandler = ^{
            @HDStrongify(view);

            HDPopViewConfig *config = HDPopViewConfig.new;
            config.identifier = @"delivery_service_fee_tip";
            config.text = WMLocalizedString(@"calculate_accord_to_goods_total_money", @"根据商品总金额计算");
            config.sourceView = view.keyButton.imageView;

            [HDPopViewManager showPopTipInView:nil configs:@[config]];
        };
        view.hidden = true;
        [view setNeedsUpdateContent];
        _vatFeeView = view;
    }
    return _vatFeeView;
}

- (SAInfoView *)packingFeeView {
    if (!_packingFeeView) {
        SAInfoView *view = SAInfoView.new;
        view.model = [self infoViewModelWithKey:WMLocalizedString(@"packing_fee", @"包装费")];
        view.model.keyColor = HDAppTheme.WMColor.B9;
        view.model.keyFont = [HDAppTheme.WMFont wm_ForSize:14];
        view.model.valueFont = [HDAppTheme.WMFont wm_ForSize:14 fontName:@"DINPro-Regular"];
        view.hidden = true;
        [view setNeedsUpdateContent];
        _packingFeeView = view;
    }
    return _packingFeeView;
}

- (SAInfoView *)promotionFeeView {
    if (!_promotionFeeView) {
        SAInfoView *view = SAInfoView.new;
        view.model = [self infoViewModelWithKey:WMLocalizedString(@"promotions", @"优惠活动")];
        view.model.leftImage = [UIImage imageNamed:@"store_info_promotion_discount"];
        view.hidden = true;
        [view setNeedsUpdateContent];
        _promotionFeeView = view;
    }
    return _promotionFeeView;
}

- (WMOrderSubmitPromotionItemView *)lessFeeView {
    if (!_lessFeeView) {
        _lessFeeView = [[WMOrderSubmitPromotionItemView alloc] init];
        _lessFeeView.marketingType = WMStorePromotionMarketingTypeDiscount;
        _lessFeeView.hidden = YES;
    }
    return _lessFeeView;
}

- (WMOrderSubmitPromotionItemView *)offFeeView {
    if (!_offFeeView) {
        _offFeeView = [[WMOrderSubmitPromotionItemView alloc] init];
        _offFeeView.marketingType = WMStorePromotionMarketingTypeLabber;
        _offFeeView.hidden = YES;
    }
    return _offFeeView;
}

- (WMOrderSubmitPromotionItemView *)firstFeeView {
    if (!_firstFeeView) {
        _firstFeeView = [[WMOrderSubmitPromotionItemView alloc] init];
        _firstFeeView.marketingType = WMStorePromotionMarketingTypeFirst;
        _firstFeeView.hidden = YES;
    }
    return _firstFeeView;
}

- (WMOrderSubmitPromotionItemView *)couponFeeView {
    if (!_couponFeeView) {
        _couponFeeView = [[WMOrderSubmitPromotionItemView alloc] init];
        _couponFeeView.marketingType = WMStorePromotionMarketingTypeCoupon;
        _couponFeeView.hidden = YES;
    }
    return _couponFeeView;
}

- (SALabel *)moneyLB {
    if (!_moneyLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard2Bold;
        label.textColor = HDAppTheme.WMColor.mainRed;
        label.numberOfLines = 1;
        label.text = WMLocalizedString(@"sub_total", @"小计");
        _moneyLB = label;
    }
    return _moneyLB;
}

- (SAOperationButton *)operationBTN {
    if (!_operationBTN) {
        SAOperationButton *button = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        button.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(6), kRealWidth(16), kRealWidth(6), kRealWidth(16));
        [button addTarget:self action:@selector(clickedOperationBTNHandler) forControlEvents:UIControlEventTouchUpInside];
        button.normalBackgroundColor = HDAppTheme.color.mainColor;
        _operationBTN = button;
    }
    return _operationBTN;
}

- (NSMutableArray<WMShoppingCartStoreProduct *> *)selectedProducts {
    return _selectedProducts ?: ({ _selectedProducts = NSMutableArray.array; });
}

- (NSMutableArray *)infoViewList {
    if (!_infoViewList) {
        _infoViewList = [NSMutableArray arrayWithCapacity:6];
    }
    return _infoViewList;
}

- (YYLabel *)floatLayoutLB {
    if (!_floatLayoutLB) {
        _floatLayoutLB = YYLabel.new;
        _floatLayoutLB.numberOfLines = 0;
        _floatLayoutLB.userInteractionEnabled = NO;
        _floatLayoutLB.preferredMaxLayoutWidth = kScreenWidth - kRealWidth(25);
    }
    return _floatLayoutLB;
}

@end
