//
//  WMOrderSubmitOrderInfoView.m
//  SuperApp
//
//  Created by VanJay on 2020/5/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderSubmitOrderInfoView.h"
#import "GNTheme.h"
#import "HDPopViewManager.h"
#import "SAAppEnvManager.h"
#import "SAInfoView.h"
#import "SAShadowBackgroundView.h"
#import "WMCalculateProductPriceRspModel.h"
#import "WMCustomViewActionView.h"
#import "WMFillGiftView.h"
#import "WMOrderBoxView.h"
#import "WMOrderSubmitCalDeliveryFeeRspModel.h"
#import "WMOrderSubmitCouponModel.h"
#import "WMOrderSubmitFullGiftRspModel.h"
#import "WMOrderSubmitPayFeeTrialCalRspModel.h"
#import "WMOrderSubmitProductView.h"
#import "WMOrderSubmitPromotionItemView.h"
#import "WMOrderSubmitPromotionModel.h"
#import "WMOrderSubmitViewPromotionsView.h"
#import "WMPromoCodeRspModel.h"
#import "WMShoppingCartStoreItem.h"
#import "WMShoppingCartStoreProduct.h"
#import "WMShoppingItemsPayFeeTrialCalRspModel.h"
#import "WMTipAlertView.h"

#define kInfoViewContentEdgeInsets UIEdgeInsetsMake(kRealWidth(12), kRealWidth(15), kRealWidth(12), kRealWidth(15))


@interface WMOrderSubmitOrderInfoView ()
/// 商品信息背景视图
@property (nonatomic, strong) UIView *goodsInfoView;
/// 价格信息背景视图
@property (nonatomic, strong) UIView *priceInfoView;
/// 门店icon
@property (nonatomic, strong) UIImageView *iconIV;
/// 门店名称
@property (nonatomic, strong) SALabel *titleLB;
/// 门店点击
@property (nonatomic, strong) UIControl *storeControl;
/// 分割线
@property (nonatomic, strong) UIView *sepLine1;
/// 门店箭头
@property (nonatomic, strong) UIImageView *storeIntoIV;
/// 商品容器
@property (nonatomic, strong) UIView *goodsContainer;
/// 赠品容器
@property (nonatomic, strong) UIView *giftsContainer;
/// 配送费费率容器
@property (nonatomic, strong) UIView *vatAndDeveliyContainer;
/// 分割线
@property (nonatomic, strong) UIView *sepLine2;
/// 分割线
@property (nonatomic, strong) UIView *sepLine3;
/// 所有的属性
@property (nonatomic, strong) NSMutableArray *infoViewList;
/// 备注
@property (nonatomic, strong) SAInfoView *noteView;
/// 增值税
@property (nonatomic, strong) SAInfoView *vatFeeView;
/// 打包费
@property (nonatomic, strong) SAInfoView *packingFeeView;
/// 配送费
@property (nonatomic, strong) SAInfoView *deliveryFeeView;
/// 配送费解析说明
@property (nonatomic, strong) SAInfoView *deliveryFeeDetailView;
/// 活动金额
@property (nonatomic, strong) SAInfoView *promotionFeeView;
/// 满赠
@property (nonatomic, strong) SAInfoView *fullGiftView;
/// 总优惠
@property (nonatomic, strong) SAInfoView *totalDiscountView;
/// 打折
@property (nonatomic, strong) WMOrderSubmitPromotionItemView *lessFeeView;
/// 满减
@property (nonatomic, strong) WMOrderSubmitPromotionItemView *offFeeView;
/// 首单减免
@property (nonatomic, strong) WMOrderSubmitPromotionItemView *firstFeeView;
/// 优惠券
@property (nonatomic, strong) WMOrderSubmitPromotionItemView *couponFeeView;
/// 优惠券
@property (nonatomic, strong) SAInfoView *couponView;
/// 运费券
@property (nonatomic, strong) SAInfoView *freightView;
/// 小计金额
@property (nonatomic, strong) SAInfoView *subTotalMoneyView;
/// 当前优惠券模型
@property (nonatomic, strong) WMOrderSubmitCouponModel *couponModel;
/// 当前运费券模型
@property (nonatomic, strong) WMOrderSubmitCouponModel *freightModel;
/// 活动列表，不包含减配送费活动
@property (nonatomic, copy) NSArray<WMOrderSubmitPromotionModel *> *noneDeliveryPromotionList;
/// 使用促销码
@property (nonatomic, strong) SAInfoView *promoCodeView;
/// 配送费不为0
@property (nonatomic, assign, getter=isNeedDelivery) BOOL needDelivery;
/// 点击过找零提醒
@property (nonatomic, copy, readwrite) NSString *changeReminderText;
/// 慢必赔
@property (nonatomic, strong) HDUIButton *slowPayBTN;
/// 慢必赔
@property (nonatomic, strong) UIView *slowPayView;
/// 慢必赔
@property (nonatomic, strong) UIImageView *slowPayIcon;
@end


@implementation WMOrderSubmitOrderInfoView
- (void)hd_setupViews {
    self.backgroundColor = UIColor.clearColor;
    [self addSubview:self.goodsInfoView];
    [self addSubview:self.vatAndDeveliyContainer];
    [self addSubview:self.priceInfoView];
    [self addSubview:self.noteView];

    [self.goodsInfoView addSubview:self.storeControl];
    [self.goodsInfoView addSubview:self.iconIV];
    [self.goodsInfoView addSubview:self.titleLB];
    [self.goodsInfoView addSubview:self.sepLine1];
    [self.goodsInfoView addSubview:self.goodsContainer];
    [self.goodsInfoView addSubview:self.sepLine2];
    [self.goodsInfoView addSubview:self.packingFeeView];
    [self.goodsInfoView addSubview:self.subTotalMoneyView];
    [self.goodsInfoView addSubview:self.slowPayView];
    [self.slowPayView addSubview:self.slowPayBTN];
    [self.slowPayView addSubview:self.slowPayIcon];

    [self.vatAndDeveliyContainer addSubview:self.deliveryFeeView];
    [self.vatAndDeveliyContainer addSubview:self.deliveryFeeDetailView];
    [self.vatAndDeveliyContainer addSubview:self.vatFeeView];

    [self.priceInfoView addSubview:self.fullGiftView];
    [self.priceInfoView addSubview:self.giftsContainer];
    [self.priceInfoView addSubview:self.promotionFeeView];
    [self.priceInfoView addSubview:self.lessFeeView];
    [self.priceInfoView addSubview:self.offFeeView];
    [self.priceInfoView addSubview:self.firstFeeView];
    [self.priceInfoView addSubview:self.couponFeeView];
    [self.priceInfoView addSubview:self.couponView];
    [self.priceInfoView addSubview:self.freightView];
    [self.priceInfoView addSubview:self.promoCodeView];
    [self.priceInfoView addSubview:self.sepLine3];
    [self.priceInfoView addSubview:self.totalDiscountView];

    [self.infoViewList addObject:self.fullGiftView];
    [self.infoViewList addObject:self.giftsContainer];
    [self.infoViewList addObject:self.promotionFeeView];
    [self.infoViewList addObject:self.firstFeeView];
    [self.infoViewList addObject:self.lessFeeView];
    [self.infoViewList addObject:self.couponFeeView];
    [self.infoViewList addObject:self.offFeeView];
    [self.infoViewList addObject:self.couponView];
    [self.infoViewList addObject:self.freightView];
    [self.infoViewList addObject:self.promoCodeView];
}

- (void)pushStoreDetailAction {
    [HDMediator.sharedInstance navigaveToStoreDetailViewController:@{@"storeNo": self.storeModel.storeNo}];
}

#pragma mark - 默认商品列表
- (void)configureWithStoreItem:(WMShoppingCartStoreItem *)model productList:(NSArray<WMShoppingCartStoreProduct *> *)productList {
    self.storeModel = model;
    self.titleLB.text = model.storeName.desc;
    [self.goodsContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    for (WMShoppingCartStoreProduct *product in productList) {
        WMOrderSubmitProductView *productView = WMOrderSubmitProductView.new;
        product.storeStatus = model.merchantStoreStatus;
        productView.model = product;
        [self.goodsContainer addSubview:productView];
    }

    [self setNeedsUpdateConstraints];
}
#pragma mark - 聚合商品列表
- (void)configureWithProductList:(NSArray<WMShoppingCartStoreProduct *> *)productList {
    [self.goodsContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    for (WMShoppingCartStoreProduct *product in productList) {
        ///拆分优惠商品和原价商品
        if (product.discountCount && product.purchaseQuantity > product.discountCount && product.totalDiscountAmount.cent.doubleValue > 0) {
            WMOrderSubmitProductView *discountProductView = WMOrderSubmitProductView.new;
            WMShoppingCartStoreProduct *discountModel = [self copyWithStoreProductModel:product];
            discountModel.purchaseQuantity = product.discountCount;
            discountProductView.model = discountModel;
            [self.goodsContainer addSubview:discountProductView];

            WMOrderSubmitProductView *productView = WMOrderSubmitProductView.new;
            WMShoppingCartStoreProduct *normalModel = [self copyWithStoreProductModel:product];
            normalModel.purchaseQuantity = product.purchaseQuantity - product.discountCount;
            normalModel.showOriginal = YES;
            productView.model = normalModel;
            [self.goodsContainer addSubview:productView];
        } else {
            WMOrderSubmitProductView *productView = WMOrderSubmitProductView.new;
            productView.model = product;
            [self.goodsContainer addSubview:productView];
        }
    }

    [self setNeedsUpdateConstraints];
}

- (WMShoppingCartStoreProduct *)copyWithStoreProductModel:(WMShoppingCartStoreProduct *)model {
    WMShoppingCartStoreProduct *returnModel = WMShoppingCartStoreProduct.new;
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([WMShoppingCartStoreProduct class], &count);
    for (int i = 0; i < count; i++) {
        const char *name = property_getName(properties[i]);
        NSString *propertyName = [NSString stringWithUTF8String:name];
        id propertyValue = [model valueForKey:propertyName];
        if (propertyValue) {
            [returnModel setValue:propertyValue forKey:propertyName];
        }
    }
    free(properties);
    return returnModel;
}

#pragma mark - 小计和打包费
- (void)configureWithPayFeeTrialCalRspModel:(WMShoppingItemsPayFeeTrialCalRspModel *)payFeeTrialCalRspModel productList:(NSArray<WMShoppingCartStoreProduct *> *)productList {
    double money = 0.0;
    for (WMShoppingCartStoreProduct *product in productList) {
        money += product.salePrice.cent.doubleValue * product.purchaseQuantity;
    }
    self.subTotalMoneyView.hidden = HDIsObjectNil(payFeeTrialCalRspModel);
    if (!self.subTotalMoneyView.isHidden) {
        // 计算小计金额, 小计金额＝当前商品价格合计＋包装费-商品优惠-爆款优惠
        SAMoneyModel *subTotalMoney = SAMoneyModel.new;
        subTotalMoney.cy = payFeeTrialCalRspModel.totalAmount.cy;
        long subTotalMoneyAmount = money + payFeeTrialCalRspModel.packageFee.cent.integerValue - payFeeTrialCalRspModel.freeProductDiscountAmount.cent.integerValue
                                   - payFeeTrialCalRspModel.freeBestSaleDiscountAmount.cent.integerValue;
        subTotalMoney.cent = [NSString stringWithFormat:@"%zd", subTotalMoneyAmount];

        SAMoneyModel *subTotalNormalMoney = SAMoneyModel.new;
        subTotalNormalMoney.cy = subTotalMoney.cy;
        long subTotalNormalMoneyAmount = money + payFeeTrialCalRspModel.packageFee.cent.integerValue;
        subTotalNormalMoney.cent = [NSString stringWithFormat:@"%zd", subTotalNormalMoneyAmount];

        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
        ///原小计
        if (subTotalNormalMoney.cent.doubleValue > subTotalMoney.cent.doubleValue) {
            NSMutableAttributedString *originalDeliveryFeeStr = [[NSMutableAttributedString alloc] initWithString:subTotalNormalMoney.thousandSeparatorAmount attributes:@{
                NSFontAttributeName: [HDAppTheme.WMFont wm_ForSize:11 fontName:@"DINPro-Regular"],
                NSForegroundColorAttributeName: HDAppTheme.WMColor.B9,
                NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle | NSUnderlinePatternSolid),
                NSStrikethroughColorAttributeName: HDAppTheme.WMColor.B9
            }];
            [text appendAttributedString:originalDeliveryFeeStr];
            // 空格
            NSAttributedString *whiteSpace = [[NSAttributedString alloc] initWithString:@" "];
            [text appendAttributedString:whiteSpace];
        }

        NSMutableAttributedString *afterPromotionDeliveryFeeStr = [[NSMutableAttributedString alloc] initWithString:subTotalMoney.thousandSeparatorAmount attributes:@{
            NSFontAttributeName: [HDAppTheme.WMFont wm_ForSize:16 fontName:@"DINPro-Bold"],
            NSForegroundColorAttributeName: HDAppTheme.WMColor.B3,
            NSStrikethroughStyleAttributeName: @(NSUnderlineStyleNone)
        }];
        [afterPromotionDeliveryFeeStr addAttributes:@{NSFontAttributeName: [HDAppTheme.WMFont wm_ForSize:11 fontName:@"DINPro-Bold"], NSForegroundColorAttributeName: HDAppTheme.WMColor.B3}
                                              range:[afterPromotionDeliveryFeeStr.string rangeOfString:subTotalMoney.currencySymbol]];

        [text appendAttributedString:afterPromotionDeliveryFeeStr];
        self.subTotalMoneyView.model.associatedObject = payFeeTrialCalRspModel.totalAmount.cy;
        self.subTotalMoneyView.model.attrValue = text;
        [self.subTotalMoneyView setNeedsUpdateContent];
    }

    self.packingFeeView.hidden = payFeeTrialCalRspModel.packageFee.cent.doubleValue <= 0;
    if (!self.packingFeeView.isHidden) {
        self.packingFeeView.model.valueText = payFeeTrialCalRspModel.packageFee.thousandSeparatorAmount;
        self.packingFeeView.model.keyImage = [UIImage imageNamed:@"yn_submit_help"];
        self.packingFeeView.model.clickedKeyButtonHandler = ^{
            WMOrderBoxView *contenView = [[WMOrderBoxView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
            [contenView configureWithSubmitRspModel:payFeeTrialCalRspModel];
            [contenView layoutyImmediately];
            WMCustomViewActionView *actionView = [WMCustomViewActionView actionViewWithContentView:contenView block:^(HDCustomViewActionViewConfig *_Nullable config) {
                config.title = WMLocalizedString(@"wm_total_packing_fee_remark", @"使用说明");
            }];
            [actionView show];
        };
        [self.packingFeeView setNeedsUpdateContent];
    }
    [self updateSepLineStateAndInfoViewConstraints];
}
#pragma mark - vat
- (void)configureWithShoppingItemsPayFeeTrialCalRspModel:(WMShoppingItemsPayFeeTrialCalRspModel *)model {
    self.vatFeeView.hidden = model.vat.cent.doubleValue <= 0;
    if (!self.vatFeeView.isHidden) {
        self.vatFeeView.model.keyText = [NSString stringWithFormat:@"%@(%@%%)", WMLocalizedString(@"vat_fee", @"VAT"), model.vatRate];
        self.vatFeeView.model.valueText = model.vat.thousandSeparatorAmount;
        [self.vatFeeView setNeedsUpdateContent];
    }
    [self updateSepLineStateAndInfoViewConstraints];
}
#pragma mark - 配送费
- (void)configureWithDeliveryFeeRspModel:(WMOrderSubmitCalDeliveryFeeRspModel *)model deliveryFeeReductionMoney:(SAMoneyModel *)deliveryFeeReductionMoney {
    self.deliveryFeeView.model.clickedKeyButtonHandler = nil;
    self.deliveryFeeView.model.attrKey = nil;
    self.deliveryFeeView.model.attrValue = nil;
    self.deliveryFeeView.model.contentEdgeInsets
        = UIEdgeInsetsMake(self.vatFeeView.isHidden ? kRealWidth(12) : kRealWidth(16), kRealWidth(15), self.vatFeeView.isHidden ? kRealWidth(12) : kRealWidth(8), kRealWidth(15));
    self.deliveryFeeView.hidden = false;
    self.deliveryFeeDetailView.hidden = true;

    if ((!deliveryFeeReductionMoney || deliveryFeeReductionMoney.cent.doubleValue <= 0) && model.specialAreaDeliveryFee.cent.doubleValue <= 0) {
        self.deliveryFeeView.model.valueFont = [HDAppTheme.WMFont wm_ForSize:14 fontName:@"DINPro-Regular"];
        self.deliveryFeeView.model.valueText = model.deliverFee.thousandSeparatorAmount;
        self.needDelivery = model.deliverFee.cent.intValue > 0;
    } else {
        // 计算优惠后的配送费
        SAMoneyModel *afterPromotionDeliveryFee = SAMoneyModel.new;
        afterPromotionDeliveryFee.cy = model.deliverFee.cy;
        afterPromotionDeliveryFee.cent = [NSString stringWithFormat:@"%zd", model.deliverFee.cent.integerValue - deliveryFeeReductionMoney.cent.integerValue];


        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];


        //活动减免 + 特殊区域加收
        if (deliveryFeeReductionMoney.cent.doubleValue > 0 && model.specialAreaDeliveryFee.cent.doubleValue > 0) {
            NSAttributedString *originalDeliveryFeeStr = [[NSAttributedString alloc] initWithString:model.deliverFee.thousandSeparatorAmount attributes:@{
                NSFontAttributeName: [HDAppTheme.WMFont wm_ForSize:11 fontName:@"DINPro-Regular"],
                NSForegroundColorAttributeName: HDAppTheme.WMColor.B9,
                NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle | NSUnderlinePatternSolid),
                NSStrikethroughColorAttributeName: HDAppTheme.WMColor.B9
            }];
            [text appendAttributedString:originalDeliveryFeeStr];
            NSMutableString *afterStr =
                [NSString stringWithFormat:WMLocalizedString(@"wm_promotion_deduct_delivery_fee", @"活动减%@配送费"), deliveryFeeReductionMoney.thousandSeparatorAmount].mutableCopy;
            [afterStr appendString:@","];
            [afterStr appendString:[NSString stringWithFormat:WMLocalizedString(@"wm_promotion_deduct_delivery_fee2", @"加收%@配送费"), model.specialAreaDeliveryFee.thousandSeparatorAmount]];
            NSMutableAttributedString *keyStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", afterStr]];
            keyStr.yy_lineSpacing = kRealWidth(4);
            keyStr.yy_font = [HDAppTheme.WMFont wm_ForSize:14];
            keyStr.yy_color = HDAppTheme.WMColor.B6;
            [keyStr yy_setFont:[HDAppTheme.WMFont wm_ForSize:11] range:[keyStr.string rangeOfString:afterStr]];
            self.deliveryFeeDetailView.model.attrKey = keyStr;
            self.deliveryFeeDetailView.hidden = false;
            self.deliveryFeeDetailView.model.contentEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(15), kRealWidth(8), kRealWidth(15));

            // 空格
            NSAttributedString *whiteSpace = [[NSAttributedString alloc] initWithString:@" "];
            [text appendAttributedString:whiteSpace];

            //活动减免
        } else if (deliveryFeeReductionMoney.cent.doubleValue > 0) {
            NSAttributedString *originalDeliveryFeeStr = [[NSAttributedString alloc] initWithString:model.deliverFee.thousandSeparatorAmount attributes:@{
                NSFontAttributeName: [HDAppTheme.WMFont wm_ForSize:11 fontName:@"DINPro-Regular"],
                NSForegroundColorAttributeName: HDAppTheme.WMColor.B9,
                NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle | NSUnderlinePatternSolid),
                NSStrikethroughColorAttributeName: HDAppTheme.WMColor.B9
            }];
            [text appendAttributedString:originalDeliveryFeeStr];
            NSString *afterStr = [NSString stringWithFormat:WMLocalizedString(@"wm_promotion_deduct_delivery_fee", @"活动减%@配送费"), deliveryFeeReductionMoney.thousandSeparatorAmount];
            NSMutableAttributedString *keyStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", afterStr]];
            keyStr.yy_lineSpacing = kRealWidth(4);
            keyStr.yy_font = [HDAppTheme.WMFont wm_ForSize:14];
            keyStr.yy_color = HDAppTheme.WMColor.B6;
            [keyStr yy_setFont:[HDAppTheme.WMFont wm_ForSize:11] range:[keyStr.string rangeOfString:afterStr]];
            self.deliveryFeeDetailView.model.attrKey = keyStr;
            self.deliveryFeeDetailView.hidden = false;
            self.deliveryFeeDetailView.model.contentEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(15), kRealWidth(8), kRealWidth(15));

            // 空格
            NSAttributedString *whiteSpace = [[NSAttributedString alloc] initWithString:@" "];
            [text appendAttributedString:whiteSpace];

            //特殊区域加收
        } else if (model.specialAreaDeliveryFee.cent.doubleValue > 0) {
            //            NSAttributedString *originalDeliveryFeeStr = [[NSAttributedString alloc] initWithString:deliveryFeeReductionMoney.thousandSeparatorAmount attributes:@{
            //                NSFontAttributeName: [HDAppTheme.WMFont wm_ForSize:11 fontName:@"DINPro-Regular"],
            //                NSForegroundColorAttributeName: HDAppTheme.WMColor.B9,
            //                NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle | NSUnderlinePatternSolid),
            //                NSStrikethroughColorAttributeName: HDAppTheme.WMColor.B9
            //            }];
            //            [text appendAttributedString:originalDeliveryFeeStr];
            NSString *afterStr = [NSString stringWithFormat:WMLocalizedString(@"wm_promotion_deduct_delivery_fee2", @"加收%@配送费"), model.specialAreaDeliveryFee.thousandSeparatorAmount];
            NSMutableAttributedString *keyStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", afterStr]];
            keyStr.yy_lineSpacing = kRealWidth(4);
            keyStr.yy_font = [HDAppTheme.WMFont wm_ForSize:14];
            keyStr.yy_color = HDAppTheme.WMColor.B6;
            [keyStr yy_setFont:[HDAppTheme.WMFont wm_ForSize:11] range:[keyStr.string rangeOfString:afterStr]];
            self.deliveryFeeDetailView.model.attrKey = keyStr;
            self.deliveryFeeDetailView.hidden = false;
            self.deliveryFeeDetailView.model.contentEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(15), kRealWidth(8), kRealWidth(15));
        }


        if (HDIsStringNotEmpty(afterPromotionDeliveryFee.thousandSeparatorAmount)) {
            NSAttributedString *afterPromotionDeliveryFeeStr = [[NSAttributedString alloc] initWithString:afterPromotionDeliveryFee.thousandSeparatorAmount attributes:@{
                NSFontAttributeName: [HDAppTheme.WMFont wm_ForSize:14 fontName:@"DINPro-Regular"],
                NSForegroundColorAttributeName: HDAppTheme.WMColor.B3,
                NSStrikethroughStyleAttributeName: @(NSUnderlineStyleNone)
            }];
            [text appendAttributedString:afterPromotionDeliveryFeeStr];
        }
        self.needDelivery = afterPromotionDeliveryFee.cent.intValue > 0;
        self.deliveryFeeView.model.attrValue = text;
    }
    //    if ([model.inDeliveryStr isKindOfClass:NSString.class] && model.inDeliveryStr.length) {
    //        self.deliveryFeeView.model.clickedKeyButtonHandler = ^{
    //            HDAlertView *alertView = [WMCustomViewActionView showTitle:nil message:model.inDeliveryStr confirm:SALocalizedStringFromTable(@"confirm", @"确认", @"Buttons")
    //                                                               handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
    //                                                                   [alertView dismiss];
    //                                                               }
    //                                                                config:nil];
    //            [alertView show];
    //        };
    //    } else {
    self.deliveryFeeView.model.clickedKeyButtonHandler = ^{
        WMTipAlertView *view = [[WMTipAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealWidth(100))];
        view.tip = WMLocalizedString(@"wm_submit_order_delevery_tip", @"配送费受配送距离");
        [view layoutyImmediately];
        WMCustomViewActionView *actionView = [WMCustomViewActionView actionViewWithContentView:view block:^(HDCustomViewActionViewConfig *_Nullable config) {
            config.title = WMLocalizedString(@"notice", @"提示");
            config.containerMinHeight = kRealWidth(28);
        }];
        [actionView show];
    };
    //    }

    if (!self.deliveryFeeDetailView.hidden && HDIsStringNotEmpty(model.specialAreaDeliveryFee.thousandSeparatorAmount) && HDIsStringNotEmpty(model.specialAreaDeliveryFeeRemark.desc)) {
        self.deliveryFeeDetailView.model.keyImage = [UIImage imageNamed:@"yn_submit_help"];
        self.deliveryFeeDetailView.model.clickedKeyButtonHandler = ^{
            WMTipAlertView *view = [[WMTipAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealWidth(100))];
            view.tip = model.specialAreaDeliveryFeeRemark.desc;
            [view layoutyImmediately];
            WMCustomViewActionView *actionView = [WMCustomViewActionView actionViewWithContentView:view block:^(HDCustomViewActionViewConfig *_Nullable config) {
                config.title = WMLocalizedString(@"notice", @"提示");
                config.containerMinHeight = kRealWidth(28);
            }];
            [actionView show];
        };
    } else {
        self.deliveryFeeDetailView.model.keyImage = nil;
        self.deliveryFeeDetailView.model.clickedKeyButtonHandler = nil;
    }

    [self.deliveryFeeView setNeedsUpdateContent];
    [self.deliveryFeeView setNeedsUpdateConstraints];
    [self.deliveryFeeView updateConstraints];
    if (!self.deliveryFeeDetailView.isHidden) {
        [self.deliveryFeeDetailView setNeedsUpdateContent];
        [self.deliveryFeeDetailView setNeedsUpdateConstraints];
        [self.deliveryFeeDetailView updateConstraints];
    }
    [self updateSepLineStateAndInfoViewConstraints];
}

- (void)configureWithHiddenDeliveryFeeViewAndFreightView {
    self.deliveryFeeView.hidden = YES;
    self.deliveryFeeDetailView.hidden = YES;
    self.freightView.hidden = YES;
    [self updateSepLineStateAndInfoViewConstraints];
}
#pragma mark - 现金券
- (void)configureWithCouponModel:(WMOrderSubmitCouponModel *)model usableCouponCount:(NSUInteger)usableCouponCount shouldChangeDiscountView:(BOOL)change {
    self.couponView.hidden = NO;
    if (!self.couponView.isHidden) {
        self.couponModel = model;
        self.couponView.userInteractionEnabled = true;
        self.couponView.model.valueColor = HDAppTheme.WMColor.B9;
        self.couponView.model.valueFont = [HDAppTheme.WMFont wm_ForSize:14];
        self.couponView.model.valueBackGroundColor = nil;
        self.couponView.model.valueImage = nil;
        self.couponView.model.valueTitleEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(5), 0, 0);
        self.couponView.model.rightButtonImage = [UIImage imageNamed:@"yn_submit_gengd_small"];
        self.couponView.model.resetValueImage = YES;
        if (HDIsObjectNil(model) && usableCouponCount <= 0) {
            self.couponView.model.valueText = WMLocalizedString(@"wm_no_delivery", @"无可用优惠券");
        } else {
            if (usableCouponCount > 0 && !HDIsObjectNil(model)) {
                self.couponView.model.valueText = [NSString stringWithFormat:@"-%@", model.discountAmount.thousandSeparatorAmount];
                self.couponView.model.valueColor = HDAppTheme.WMColor.mainRed;
                self.couponView.model.valueFont = [HDAppTheme.WMFont wm_ForSize:14 fontName:@"DINPro-Regular"];
                if (change) {
                    self.totalDiscountMoney += model.discountAmount.cent.integerValue;
                }
            } else {
                self.couponView.model.valueText = [NSString stringWithFormat:WMLocalizedString(@"wm_coupon_use", @"您有%d张优惠券可用"), usableCouponCount];
                self.couponView.model.valueColor = UIColor.whiteColor;
                self.couponView.model.valueTitleEdgeInsets = UIEdgeInsetsMake(kRealWidth(3), kRealWidth(12), kRealWidth(3), 0);
                self.couponView.model.valueImage = [[UIImage imageNamed:@"yn_submit_gengd_small"] hd_imageWithTintColor:UIColor.whiteColor];
                self.couponView.model.rightButtonImage = nil;
                self.couponView.model.valueImagePosition = HDUIButtonImagePositionRight;
                [self.couponView setNeedsUpdateContent];
                CGFloat width = [self.couponView.model.valueText boundingRectWithSize:CGSizeMake(kScreenWidth, CGFLOAT_MAX)
                                                                              options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                                           attributes:@{NSFontAttributeName: self.couponView.model.valueFont}
                                                                              context:nil]
                                    .size.width
                                + self.couponView.model.valueImage.size.width + self.couponView.model.valueTitleEdgeInsets.left;
                self.couponView.model.valueBackGroundColor = [HDAppTheme.color
                    gn_ColorGradientChangeWithSize:CGSizeMake(width + self.couponView.model.valueContentEdgeInsets.left + self.couponView.model.valueContentEdgeInsets.right, kRealWidth(24))
                                         direction:GNGradientChangeDirectionLevel
                                            colors:@[HexColor(0xFE4374), HDAppTheme.WMColor.mainRed]];
            }
        }
        [self.couponView setNeedsUpdateContent];
    }
    [self updateSepLineStateAndInfoViewConstraints];
}
#pragma mark - 运费券
- (void)configureWithFreightCouponModel:(WMOrderSubmitCouponModel *)model usableCouponCount:(NSUInteger)usableFreightCouponCount shouldChangeDiscountView:(BOOL)change {
    self.freightView.hidden = NO;
    if (!self.freightView.isHidden) {
        self.freightModel = model;
        self.freightView.userInteractionEnabled = true;
        self.freightView.model.valueColor = HDAppTheme.WMColor.B9;
        self.freightView.model.valueFont = [HDAppTheme.WMFont wm_ForSize:14];
        self.freightView.model.valueBackGroundColor = nil;
        self.freightView.model.valueTitleEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(5), 0, 0);
        self.freightView.model.rightButtonImage = [UIImage imageNamed:@"yn_submit_gengd_small"];
        self.freightView.model.valueImage = nil;
        self.freightView.model.resetValueImage = YES;
        if (!self.cartFeeModel.useShippingCoupon) {
            if (HDIsObjectNil(model) && usableFreightCouponCount <= 0) {
                self.freightView.model.valueText = WMLocalizedString(@"wm_no_delivery_fee", @"无可用运费券");
            } else {
                if (self.isNeedDelivery) {
                    if (usableFreightCouponCount > 0 && !HDIsObjectNil(model)) {
                        self.freightView.model.valueText = [NSString stringWithFormat:@"-%@", model.discountAmount.thousandSeparatorAmount];
                        self.freightView.model.valueColor = HDAppTheme.WMColor.mainRed;
                        self.freightView.model.valueFont = [HDAppTheme.WMFont wm_ForSize:14 fontName:@"DINPro-Regular"];
                        if (change) {
                            self.totalDiscountMoney += model.discountAmount.cent.integerValue;
                        }
                    } else {
                        self.freightView.model.valueText = [NSString stringWithFormat:WMLocalizedString(@"wm_delivery_coupon_use", @"您有%d张运费券可用"), usableFreightCouponCount];
                        self.freightView.model.valueColor = UIColor.whiteColor;
                        self.freightView.model.valueTitleEdgeInsets = UIEdgeInsetsMake(kRealWidth(3), kRealWidth(12), kRealWidth(3), 0);
                        self.freightView.model.valueImage = [[UIImage imageNamed:@"yn_submit_gengd_small"] hd_imageWithTintColor:UIColor.whiteColor];
                        self.freightView.model.rightButtonImage = nil;
                        self.freightView.model.valueImagePosition = HDUIButtonImagePositionRight;
                        [self.freightView setNeedsUpdateContent];
                        CGFloat width = [self.freightView.model.valueText boundingRectWithSize:CGSizeMake(kScreenWidth, CGFLOAT_MAX)
                                                                                       options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                                                    attributes:@{NSFontAttributeName: self.freightView.model.valueFont}
                                                                                       context:nil]
                                            .size.width
                                        + self.freightView.model.valueImage.size.width + self.freightView.model.valueTitleEdgeInsets.left;
                        self.freightView.model.valueBackGroundColor = [HDAppTheme.color
                            gn_ColorGradientChangeWithSize:CGSizeMake(width + self.freightView.model.valueContentEdgeInsets.left + self.freightView.model.valueContentEdgeInsets.right, kRealWidth(24))
                                                 direction:GNGradientChangeDirectionLevel
                                                    colors:@[HexColor(0xFE4374), HDAppTheme.WMColor.mainRed]];
                    }
                } else {
                    self.freightView.model.valueText = WMLocalizedString(@"wm_no_use_delivery_fee", @"无需使用运费券");
                }
            }
        } else {
            self.freightView.model.valueText = WMLocalizedString(@"wm_unuse_delivery", @"不可用运费券");
        }
        [self.freightView setNeedsUpdateContent];
    }

    [self updateSepLineStateAndInfoViewConstraints];
}
#pragma mark - 营销活动
- (void)configureWithPromotionList:(NSArray<WMOrderSubmitPromotionModel *> *)promotionList
    activityMoneyExceptDeliveryFeeReduction:(SAMoneyModel *)activityMoneyExceptDeliveryFeeReduction
                    cartFeeTrialCalRspModel:(WMShoppingItemsPayFeeTrialCalRspModel *)cartFeeModel {
    self.cartFeeModel = cartFeeModel;
    // 过滤减配送费优惠
    NSArray<WMOrderSubmitPromotionModel *> *noneDeliveryPromotionList = [promotionList hd_filterWithBlock:^BOOL(WMOrderSubmitPromotionModel *_Nonnull item) {
        return item.marketingType != WMStorePromotionMarketingTypeDelievry;
    }];
    BOOL promotionHide = HDIsArrayEmpty(noneDeliveryPromotionList);
    self.promotionFeeView.hidden = promotionHide;
    self.promotionFeeView.hidden = YES;
    self.noneDeliveryPromotionList = noneDeliveryPromotionList;
    if (!promotionHide) {
        // 1.5 版本不会同时存在满减和折扣活动，取第一个活动的类型设置活动标题
        [noneDeliveryPromotionList enumerateObjectsUsingBlock:^(WMOrderSubmitPromotionModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            double currentMoney = 0.0;
            if (obj.marketingType == WMStorePromotionMarketingTypeDiscount) {
                // 取折扣减免金额
                currentMoney = cartFeeModel.freeDiscountAmount.cent.doubleValue;
            } else if (obj.marketingType == WMStorePromotionMarketingTypeLabber || obj.marketingType == WMStorePromotionMarketingTypeStoreLabber) {
                WMStoreLadderRuleModel *inUseLadderRuleModel = obj.inUseLadderRuleModel;
                if (inUseLadderRuleModel) {
                    // 取满减减免金额
                    currentMoney = cartFeeModel.freeFullReductionAmount.cent.doubleValue;
                }
            } else if (obj.marketingType == WMStorePromotionMarketingTypeFirst) {
                currentMoney = cartFeeModel.freeFirstOrderAmount.cent.doubleValue;
            } else if (obj.marketingType == WMStorePromotionMarketingTypeCoupon) {
                WMStoreLadderRuleModel *inUseLadderRuleModel = obj.inUseLadderRuleModel;
                if (inUseLadderRuleModel) {
                    // 取满减减免金额
                    currentMoney = cartFeeModel.freeFullReductionAmount.cent.doubleValue;
                }
            }

            NSString *promitionTitle = obj.promotionDesc;
            BOOL hasBestSalePromotion = cartFeeModel.freeBestSaleDiscountAmount.cent.integerValue != 0;
            if (obj.marketingType == WMStorePromotionMarketingTypeDiscount && !hasBestSalePromotion) {
                self.lessFeeView.hidden = NO || obj.discountAmount.cent.integerValue == 0;
                self.lessFeeView.leftTitle = promitionTitle;
                self.lessFeeView.rightTitle = [NSString stringWithFormat:@"-%@", cartFeeModel.freeDiscountAmount.thousandSeparatorAmount];
                [self.promotionFeeView setNeedsUpdateContent];
                self.totalDiscountMoney += cartFeeModel.freeDiscountAmount.cent.integerValue;
            } else if ((obj.marketingType == WMStorePromotionMarketingTypeLabber || obj.marketingType == WMStorePromotionMarketingTypeStoreLabber) && !hasBestSalePromotion) {
                if (cartFeeModel.freeFullReductionAmount.cent.doubleValue > 0) {
                    self.offFeeView.hidden = NO || obj.discountAmount.cent.integerValue == 0;
                    self.offFeeView.leftTitle = promitionTitle;
                    self.offFeeView.rightTitle = [NSString stringWithFormat:@"-%@", cartFeeModel.freeFullReductionAmount.thousandSeparatorAmount];
                    [self.promotionFeeView setNeedsUpdateContent];
                    self.totalDiscountMoney += cartFeeModel.freeFullReductionAmount.cent.integerValue;
                }
            } else if (obj.marketingType == WMStorePromotionMarketingTypeFirst && !hasBestSalePromotion) {
                self.firstFeeView.hidden = NO || obj.discountAmount.cent.integerValue == 0;
                self.firstFeeView.leftTitle = promitionTitle;
                self.firstFeeView.rightTitle = [NSString stringWithFormat:@"-%@", cartFeeModel.freeFirstOrderAmount.thousandSeparatorAmount];
                self.totalDiscountMoney += cartFeeModel.freeFirstOrderAmount.cent.integerValue;
            } else if (obj.marketingType == WMStorePromotionMarketingTypeCoupon) {
                if (cartFeeModel.freeFullReductionAmount.cent.doubleValue > 0) {
                    self.couponFeeView.hidden = NO || obj.discountAmount.cent.integerValue == 0;
                    self.couponFeeView.leftTitle = promitionTitle;
                    self.couponFeeView.rightTitle = [NSString stringWithFormat:@"-%@", cartFeeModel.freeFullReductionAmount.thousandSeparatorAmount];
                    self.totalDiscountMoney += cartFeeModel.freeFullReductionAmount.cent.integerValue;
                }
            }
            self.promotionFeeView.model.keyText = promitionTitle;
            self.promotionFeeView.model.valueText = [NSString stringWithFormat:@"-%@", activityMoneyExceptDeliveryFeeReduction.thousandSeparatorAmount];
            [self.promotionFeeView setNeedsUpdateContent];
        }];
    } else {
        self.lessFeeView.hidden = YES;
        self.offFeeView.hidden = YES;
        self.firstFeeView.hidden = YES;
        self.couponFeeView.hidden = YES;
    }
    [self setNeedsUpdateConstraints];
    [self updateSepLineStateAndInfoViewConstraints];
}

- (void)configureWithSlowToPay:(SABoolValue)slowToPay {
    self.slowPayView.hidden = YES;

    if ([@[@"1", @"true", @"yes"] containsObject:slowToPay]) {
        self.slowPayView.hidden = NO;
    }
    [self updateSepLineStateAndInfoViewConstraints];
}

#pragma mark - 备注
- (void)configureWithUserInputNote:(nullable NSString *)content changeRemind:(nullable NSString *)changeReminder {
    __block NSString *text = [[NSString alloc] initWithString:content ?: @""];
    [self.tagArray enumerateObjectsUsingBlock:^(WMWriteNoteTagRspModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (!obj.codeStr) {
            obj.infactStr = changeReminder;
        }
    }];
    [self.tagArray enumerateObjectsUsingBlock:^(WMWriteNoteTagRspModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (text) {
            if (obj.codeStr) {
                NSString *pattern = [NSString stringWithFormat:@"%@", obj.infactStr ?: @""];
                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
                NSArray<NSTextCheckingResult *> *matches = [regex matchesInString:text options:0 range:NSMakeRange(0, text.length)];
                if (!HDIsArrayEmpty(matches)) {
                    text = [text stringByReplacingOccurrencesOfString:pattern withString:[NSString stringWithFormat:@"{%@%@%@}", @"@", obj.codeStr, @"@"]];
                }
            } else { ///找零  有$符号没法直接正则匹配
                if ([text containsString:obj.infactStr] && !obj.codeStr) {
                    NSString *regular = @"[៛$](\\d+(?:\\.\\d+)?)";
                    NSRange range = [obj.infactStr rangeOfString:regular options:NSRegularExpressionSearch];
                    text = [text stringByReplacingOccurrencesOfString:obj.infactStr withString:[NSString stringWithFormat:@"{%@%@%@}", @"@", [obj.infactStr substringWithRange:range], @"@"]];
                }
            }
        }
    }];
    self.noteView.model.associatedObject = text;
    self.changeReminderText = changeReminder;
    if (HDIsStringNotEmpty(content)) {
        self.noteView.model.valueColor = HDAppTheme.WMColor.B3;
        self.noteView.model.valueText = content;
        self.noteView.selected = YES;
    } else {
        self.noteView.model.valueColor = HDAppTheme.WMColor.B9;
        self.noteView.selected = NO;
        self.noteView.model.valueText = WMLocalizedString(@"order_submit_note", @"口味、偏好等要求");
    }

    [self.noteView setNeedsUpdateContent];
    [self updateSepLineStateAndInfoViewConstraints];
}

+ (BOOL)matchPriceStr:(NSString *)priceStr {
    NSError *error = nil;
    NSString *pattern = @"[៛$](\\d+(?:\\.\\d+)?)";
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    if (!error) {
        NSArray<NSTextCheckingResult *> *result = [regular matchesInString:priceStr options:NSMatchingWithoutAnchoringBounds range:NSMakeRange(0, priceStr.length)];
        if (result) {
            for (NSTextCheckingResult *checkingRes in result) {
                if (checkingRes.range.location == NSNotFound) {
                    continue;
                }
                NSLog(@"%@", [priceStr substringWithRange:checkingRes.range]);
                // NSLog(@"%@",[priceStr substringWithRange:[res rangeAtIndex:1]]);
            }
        }
        return YES;
    }
    NSLog(@"匹配失败,Error: %@", error);
    return NO;
}

#pragma mark - 优惠码
- (void)configureWithUserInputPromoCode:(NSString *)promoCode rspModel:(WMPromoCodeRspModel *)promoCodeRspModel {
    self.promoCodeView.model.associatedObject = promoCode;
    self.promoCodeView.userInteractionEnabled = true;
    self.promoCodeView.model.rightButtonImage = nil;
    self.promoCodeView.model.valueFont = [HDAppTheme.WMFont wm_ForSize:14];
    self.promoCodeView.model.valueColor = HDAppTheme.WMColor.B9;
    self.promoCodeView.model.attrKey = nil;
    self.promoCodeView.model.rightButtonImage = [UIImage imageNamed:@"yn_submit_gengd_small"];
    self.promoCodeView.model.keyText = WMLocalizedString(@"OkaO8L5F", @"优惠码");
    self.promoCodeView.model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(6), kRealWidth(15), kRealWidth(12), kRealWidth(15));
    @HDWeakify(self);
    self.promoCodeView.model.eventHandler = ^{
        @HDStrongify(self);
        !self.clickedPromoCodeBlock ?: self.clickedPromoCodeBlock();
    };
    if (!self.cartFeeModel.usePromoCode) {
        if (HDIsStringNotEmpty(promoCode) && !HDIsObjectNil(promoCodeRspModel) && promoCodeRspModel.discountAmount.cent.integerValue > 0) {
            self.promoCodeView.model.valueText = [NSString stringWithFormat:@"-%@", promoCodeRspModel.discountAmount.thousandSeparatorAmount];
            self.promoCodeView.model.valueColor = HDAppTheme.WMColor.mainRed;
            self.promoCodeView.model.valueFont = [HDAppTheme.WMFont wm_ForSize:14 fontName:@"DINPro-Regular"];
            NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
            [paragraphStyle setLineSpacing:kRealWidth(4)];
            NSMutableAttributedString *mstr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", WMLocalizedString(@"OkaO8L5F", @"优惠码"), promoCode]
                                                                                     attributes:@{
                                                                                         NSFontAttributeName: [HDAppTheme.WMFont wm_ForSize:14],
                                                                                         NSForegroundColorAttributeName: HDAppTheme.WMColor.B6,
                                                                                         NSParagraphStyleAttributeName: paragraphStyle,
                                                                                     }];
            [mstr addAttributes:@{
                NSFontAttributeName: [HDAppTheme.WMFont wm_ForSize:11],
                NSForegroundColorAttributeName: HDAppTheme.WMColor.mainRed,
            }
                          range:[mstr.string rangeOfString:promoCode]];
            self.promoCodeView.model.attrKey = mstr;
            self.promoCodeView.model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), kRealWidth(15), kRealWidth(12), kRealWidth(15));
            self.totalDiscountMoney += promoCodeRspModel.discountAmount.cent.integerValue;
        } else {
            self.promoCodeView.model.valueText = WMLocalizedString(@"wm_use_promo_code", @"可使用优惠码");
        }
    } else {
        self.promoCodeView.model.eventHandler = nil;
        self.promoCodeView.model.rightButtonImage = nil;
        self.promoCodeView.model.valueText = WMLocalizedString(@"wm_unuse_promo_code", @"不可用优惠码");
    }
    [self.promoCodeView setNeedsUpdateContent];
    [self.promoCodeView updateConstraints];
    [self updateSepLineStateAndInfoViewConstraints];
}
#pragma mark - 满赠
- (void)configureWithFillGiftRspModel:(WMOrderSubmitFullGiftRspModel *_Nullable)fullGiftRspModel {
    self.fullGiftView.model.associatedObject = fullGiftRspModel;
    self.fullGiftView.hidden = self.giftsContainer.hidden = HDIsObjectNil(fullGiftRspModel);
    [self.giftsContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (!HDIsObjectNil(fullGiftRspModel)) {
        if (fullGiftRspModel.result) {
            for (int i = 0; i < fullGiftRspModel.giftListResps.count; i++) {
                NSMutableString *mstr = NSMutableString.new;
                WMStoreFillGiftRuleModel *gift = fullGiftRspModel.giftListResps[i];
                [mstr appendFormat:@"%@\tx%ld\n", gift.giftName, gift.quantity];
                NSString *content = WMLocalizedString(@"wm_fill_gift_firstcome", @"赠品数量有限，先到先得");
                [mstr appendString:content];
                NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:mstr];
                [attr addAttributes:@{NSFontAttributeName: HDAppTheme.font.standard3, NSForegroundColorAttributeName: HDAppTheme.WMColor.B3} range:[mstr rangeOfString:mstr]];
                [attr addAttributes:@{NSFontAttributeName: HDAppTheme.font.standard5, NSForegroundColorAttributeName: HDAppTheme.WMColor.B9} range:[mstr rangeOfString:content]];
                SAInfoView *productView = SAInfoView.new;
                SAInfoViewModel *model = SAInfoViewModel.new;
                model.leftImageSize = CGSizeMake(kRealWidth(55), kRealWidth(55));
                model.leftImageURL = (gift.imagePath && [gift.imagePath isKindOfClass:[NSString class]] && [gift.imagePath length]) ? gift.imagePath : @" ";
                model.leftPlaceholderImage = [UIImage imageNamed:@"order_gift"];
                model.attrValue = attr;
                model.rightButtonImage = nil;
                model.lineWidth = 0;
                model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(20), kRealWidth(15), kRealWidth(20), kRealWidth(15));
                productView.model = model;
                [self.giftsContainer addSubview:productView];
            }
            self.fullGiftView.model.attrValue = nil;
            self.fullGiftView.model.rightButtonImage = nil;
            self.fullGiftView.model.eventHandler = nil;
            self.fullGiftView.model.contentEdgeInsets = kInfoViewContentEdgeInsets;
        } else {
            self.fullGiftView.model.contentEdgeInsets = kInfoViewContentEdgeInsets;
            self.fullGiftView.model.attrValue = nil;
            self.fullGiftView.model.valueColor = HDAppTheme.WMColor.B9;
            self.fullGiftView.model.valueText = WMLocalizedString(@"wm_fill_gift_fail_join", @"未达到参与资格");
            self.fullGiftView.model.rightButtonImage = [UIImage imageNamed:@"store_fill_gift_info"];
            self.fullGiftView.model.rightButtonImageEdgeInsets = UIEdgeInsetsMake(10, 5, 10, 0);
            @HDWeakify(self);
            self.fullGiftView.model.eventHandler = ^{
                @HDStrongify(self);
                const CGFloat width = kScreenWidth - 10 * 2;
                WMOrderSubmitFullGiftRspModel *model = self.fullGiftView.model.associatedObject;
                WMFillGiftView *giftView = [[WMFillGiftView alloc] initWithFrame:CGRectMake(0, 0, width, kScreenHeight)];
                giftView.model = model;
                [giftView layoutyImmediately];
                WMCustomViewActionView *actionView = [WMCustomViewActionView actionViewWithContentView:giftView block:^(HDCustomViewActionViewConfig *_Nullable config) {
                    config.title = WMLocalizedString(@"wm_gift_order_detail", @"说明");
                    config.contentHorizontalEdgeMargin = 10;
                }];
                [actionView show];
                giftView.clickedWriteBlock = ^{
                    @HDStrongify(self);
                    [actionView dismiss];
                    [HDMediator.sharedInstance navigaveToMyInfomationController:@{@"clickedAgeBlock": self.clickedAgeBlock}];
                };
            };
        }
    }
    [self.fullGiftView setNeedsUpdateContent];
    [self updateSepLineStateAndInfoViewConstraints];
}

#pragma mark - private methods
- (SAInfoViewModel *)infoViewModelWithKey:(NSString *)key {
    SAInfoViewModel *model = SAInfoViewModel.new;
    model.keyColor = HDAppTheme.WMColor.B6;
    model.valueColor = HDAppTheme.WMColor.B3;
    model.valueFont = [HDAppTheme.WMFont wm_ForSize:14];
    model.keyText = key;
    model.lineWidth = 0;
    model.rightButtonContentEdgeInsets = UIEdgeInsetsZero;
    model.rightButtonImageEdgeInsets = UIEdgeInsetsZero;
    model.lineColor = HDAppTheme.WMColor.lineColorE9;
    return model;
}

- (void)updateSepLineStateAndInfoViewConstraints {
    SAMoneyModel *money = SAMoneyModel.new;
    money.cy = self.subTotalMoneyView.model.associatedObject;
    money.cent = [NSString stringWithFormat:@"%zd", self.totalDiscountMoney];
    self.totalDiscountView.hidden = (money.cent.doubleValue <= 0);
    if (!self.totalDiscountView.hidden) {
        self.totalDiscountView.model.valueText = [NSString stringWithFormat:@"-%@", money.thousandSeparatorAmount];
        [self.totalDiscountView setNeedsUpdateContent];
    }
    self.sepLine3.hidden = self.totalDiscountView.hidden;
    self.sepLine2.hidden = self.subTotalMoneyView.hidden;
    [self setNeedsUpdateConstraints];
}

- (void)showPromotionsView {
    WMOrderSubmitViewPromotionsView *view = [[WMOrderSubmitViewPromotionsView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    view.noneDeliveryPromotionList = self.noneDeliveryPromotionList;
    [view layoutyImmediately];
    ;
    WMCustomViewActionView *actionView = [WMCustomViewActionView actionViewWithContentView:view block:^(HDCustomViewActionViewConfig *_Nullable config) {
        config.title = WMLocalizedString(@"promotions", @"优惠活动");
        config.containerMinHeight = kRealWidth(28);
        config.needTopSepLine = true;
    }];
    [actionView show];
}

#pragma mark - getter
- (NSString *)noteText {
    return self.noteView.isSelected ? self.noteView.model.valueText : nil;
}

- (NSString *)requestNoteText {
    return self.noteView.model.associatedObject;
}

#pragma mark - layout
- (void)updateConstraints {
    [self.goodsInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.bottom.mas_lessThanOrEqualTo(-kRealWidth(16));
    }];

    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.iconIV.image.size);
        make.centerY.equalTo(self.titleLB);
        make.left.equalTo(self.goodsInfoView).offset(kRealWidth(15));
    }];

    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsInfoView).offset(kRealWidth(12));
        make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(4));
        if (self.slowPayView.isHidden) {
            make.right.equalTo(self.goodsInfoView).offset(-kRealWidth(15));
        } else {
            make.right.equalTo(self.slowPayView.mas_left).offset(-kRealWidth(12));
        }
    }];
    [self.slowPayView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.slowPayView.isHidden) {
            make.centerY.equalTo(self.titleLB);
            make.right.equalTo(self.goodsInfoView).offset(-kRealWidth(15));
        }
    }];

    [self.slowPayIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.slowPayView.isHidden) {
            make.right.mas_equalTo(0);
            make.centerY.mas_equalTo(0);
        }
    }];

    [self.slowPayBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.slowPayView.isHidden) {
            make.left.top.bottom.mas_equalTo(0);
            make.right.equalTo(self.slowPayIcon.mas_left).offset(-2);
        }
    }];

    [self.titleLB setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    [self.titleLB setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];

    [self.sepLine1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(HDAppTheme.WMValue.line);
        make.left.equalTo(self.iconIV);
        make.right.mas_equalTo(-kRealWidth(15));
        make.top.equalTo(self.titleLB.mas_bottom).offset(kRealWidth(12));
    }];

    [self.storeControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.bottom.equalTo(self.sepLine1.mas_bottom);
    }];

    NSArray<SAInfoView *> *visableInfoViews = [self.infoViewList hd_filterWithBlock:^BOOL(SAInfoView *_Nonnull item) {
        return !item.isHidden;
    }];

    [self.goodsContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.goodsInfoView);
        make.top.equalTo(self.sepLine1.mas_bottom);
        if (HDIsArrayEmpty(self.goodsContainer.subviews)) {
            make.height.mas_equalTo(CGFLOAT_MIN);
        }
        make.bottom.mas_lessThanOrEqualTo(-kRealWidth(16));
    }];
    WMOrderSubmitProductView *lastProductView;
    for (WMOrderSubmitProductView *productView in self.goodsContainer.subviews) {
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

    [self.packingFeeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.packingFeeView.isHidden) {
            make.left.right.equalTo(self.goodsInfoView);
            make.top.equalTo(self.goodsContainer.mas_bottom).offset(kRealWidth(15));
            make.bottom.mas_lessThanOrEqualTo(0);
        }
    }];

    [self.sepLine2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.sepLine2.isHidden) {
            make.left.right.height.equalTo(self.sepLine1);
            if (self.packingFeeView.isHidden) {
                make.top.equalTo(self.goodsContainer.mas_bottom).offset(kRealWidth(15));
            } else {
                make.top.equalTo(self.packingFeeView.mas_bottom);
            }
        }
    }];

    [self.subTotalMoneyView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.subTotalMoneyView.isHidden) {
            make.left.right.equalTo(self.goodsInfoView);
            make.top.equalTo(self.sepLine2.mas_bottom);
            make.bottom.mas_lessThanOrEqualTo(0);
        }
    }];

    self.vatAndDeveliyContainer.hidden = (self.deliveryFeeView.hidden && self.vatFeeView.hidden && self.deliveryFeeDetailView.hidden);
    [self.vatAndDeveliyContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.vatAndDeveliyContainer.isHidden) {
            make.top.equalTo(self.goodsInfoView.mas_bottom).offset(kRealWidth(8));
            make.left.right.mas_equalTo(0);
            make.bottom.mas_lessThanOrEqualTo(-kRealWidth(16));
        }
    }];

    [self.deliveryFeeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.deliveryFeeView.isHidden) {
            make.top.left.right.mas_equalTo(0);
            make.bottom.mas_lessThanOrEqualTo(0);
        }
    }];

    [self.deliveryFeeDetailView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.deliveryFeeDetailView.hidden && !self.deliveryFeeView.hidden) {
            make.top.equalTo(self.deliveryFeeView.mas_bottom);
            make.left.right.mas_equalTo(0);
            make.bottom.mas_lessThanOrEqualTo(0);
        }
    }];

    [self.vatFeeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.vatFeeView.isHidden) {
            make.left.right.mas_equalTo(0);
            if (!self.deliveryFeeDetailView.isHidden) {
                make.top.equalTo(self.deliveryFeeDetailView.mas_bottom);
            } else if (!self.deliveryFeeView.isHidden) {
                make.top.equalTo(self.deliveryFeeView.mas_bottom);
            } else {
                make.top.mas_equalTo(16);
            }
            make.bottom.mas_lessThanOrEqualTo(0);
        }
    }];

    self.priceInfoView.hidden = HDIsArrayEmpty(visableInfoViews);
    [self.priceInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.priceInfoView.isHidden) {
            make.left.right.equalTo(self.goodsInfoView);
            if (self.vatAndDeveliyContainer.isHidden) {
                make.top.equalTo(self.goodsInfoView.mas_bottom).offset(kRealWidth(8));
            } else {
                make.top.equalTo(self.vatAndDeveliyContainer.mas_bottom).offset(kRealWidth(8));
            }
            make.bottom.mas_lessThanOrEqualTo(-kRealWidth(16));
        }
    }];
    SAInfoView *lastInfoView;
    BOOL first = NO;
    for (SAInfoView *infoView in visableInfoViews) {
        if ([infoView isKindOfClass:SAInfoView.class] && !first) {
            first = YES;
            UIEdgeInsets edge = infoView.model.contentEdgeInsets;
            if (![visableInfoViews.firstObject isKindOfClass:WMOrderSubmitPromotionItemView.class]) {
                edge.top = kRealWidth(16);
            } else {
                edge.top = kRealWidth(8);
            }
            infoView.model.contentEdgeInsets = edge;
            [infoView setNeedsUpdateContent];
        }
        if (infoView == visableInfoViews.lastObject) {
            infoView.model.lineWidth = 0;
        }
        [infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (lastInfoView) {
                make.top.equalTo(lastInfoView.mas_bottom);
            } else {
                make.top.equalTo(self.priceInfoView);
            }
            make.left.right.equalTo(self.priceInfoView);
            if (infoView == visableInfoViews.lastObject) {
                make.bottom.mas_lessThanOrEqualTo(0);
            }
        }];
        lastInfoView = infoView;
    }

    [self.sepLine3 mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.sepLine3.isHidden) {
            make.left.right.height.equalTo(self.sepLine1);
            make.top.equalTo(lastInfoView.mas_bottom).offset(kRealWidth(10));
            make.bottom.mas_lessThanOrEqualTo(0);
        }
    }];

    [self.totalDiscountView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.totalDiscountView.isHidden) {
            make.left.right.equalTo(self.priceInfoView);
            make.top.equalTo(self.sepLine3.mas_bottom);
            make.bottom.mas_lessThanOrEqualTo(0);
        }
    }];

    UIView *lastGiftView;
    for (UIView *giftView in self.giftsContainer.subviews) {
        [giftView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (lastGiftView) {
                make.top.equalTo(lastGiftView.mas_bottom);
            } else {
                make.top.equalTo(self.giftsContainer);
            }
            make.left.equalTo(self.giftsContainer);
            make.right.equalTo(self.giftsContainer);
            if (giftView == self.giftsContainer.subviews.lastObject) {
                make.bottom.equalTo(self.giftsContainer);
            }
        }];
        lastGiftView = giftView;
    }

    [self.noteView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.noteView.isHidden) {
            if (!self.priceInfoView.isHidden) {
                make.top.equalTo(self.priceInfoView.mas_bottom).offset(kRealWidth(8));
            } else {
                make.top.equalTo(self.goodsInfoView.mas_bottom).offset(kRealWidth(8));
            }
            make.left.right.mas_equalTo(0);
            make.bottom.mas_lessThanOrEqualTo(-kRealWidth(16));
        }
    }];

    [super updateConstraints];
}

#pragma mark - lazy load
- (UIImageView *)iconIV {
    if (!_iconIV) {
        UIImageView *imageView = UIImageView.new;
        imageView.image = [UIImage imageNamed:@"yn_submit_shop"];
        _iconIV = imageView;
    }
    return _iconIV;
}

- (UIView *)sepLine1 {
    if (!_sepLine1) {
        _sepLine1 = UIView.new;
        _sepLine1.backgroundColor = HDAppTheme.WMColor.lineColorE9;
    }
    return _sepLine1;
}

- (UIView *)goodsContainer {
    if (!_goodsContainer) {
        _goodsContainer = UIView.new;
    }
    return _goodsContainer;
}

- (UIView *)giftsContainer {
    if (!_giftsContainer) {
        _giftsContainer = UIView.new;
        _giftsContainer.hidden = true;
    }
    return _giftsContainer;
}

- (UIView *)sepLine2 {
    if (!_sepLine2) {
        _sepLine2 = UIView.new;
        _sepLine2.backgroundColor = HDAppTheme.WMColor.lineColorE9;
        _sepLine2.hidden = true;
    }
    return _sepLine2;
}

- (UIView *)sepLine3 {
    if (!_sepLine3) {
        _sepLine3 = UIView.new;
        _sepLine3.backgroundColor = HDAppTheme.WMColor.lineColorE9;
        _sepLine3.hidden = true;
    }
    return _sepLine3;
}

- (SALabel *)titleLB {
    if (!_titleLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard2Bold;
        label.textColor = HDAppTheme.color.G1;
        label.numberOfLines = 1;
        _titleLB = label;
    }
    return _titleLB;
}

- (NSMutableArray *)infoViewList {
    if (!_infoViewList) {
        _infoViewList = [NSMutableArray arrayWithCapacity:7];
    }
    return _infoViewList;
}

- (SAInfoView *)noteView {
    if (!_noteView) {
        SAInfoView *view = SAInfoView.new;
        view.model = [self infoViewModelWithKey:WMLocalizedString(@"remark_title", @"备注")];
        view.model.valueText = WMLocalizedString(@"describe_your_requirements", @"你的要求（口味、偏好等）");
        view.model.valueNumbersOfLines = 1;
        view.model.keyToValueWidthRate = 0.4;
        view.model.enableTapRecognizer = true;
        view.model.rightButtonImage = [UIImage imageNamed:@"yn_submit_gengd_small"];
        view.model.rightButtonImageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        view.model.contentEdgeInsets = kInfoViewContentEdgeInsets;
        view.model.backgroundColor = HDAppTheme.WMColor.bg3;
        @HDWeakify(self);
        view.model.eventHandler = ^{
            @HDStrongify(self);
            !self.clickedNoteBlock ?: self.clickedNoteBlock();
        };
        [view setNeedsUpdateContent];
        _noteView = view;
    }
    return _noteView;
}

- (SAInfoView *)vatFeeView {
    if (!_vatFeeView) {
        SAInfoView *view = SAInfoView.new;
        view.model = [self infoViewModelWithKey:WMLocalizedString(@"vat_fee", @"增值税")];
        view.model.keyImage = [UIImage imageNamed:@"yn_submit_help"];
        view.model.valueFont = [HDAppTheme.WMFont wm_ForSize:14 fontName:@"DINPro-Regular"];
        view.model.leftImageSize = CGSizeMake(14, 14 * (view.model.leftImage.size.height / view.model.leftImage.size.width));
        view.model.contentEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(15), kRealWidth(16), kRealWidth(15));
        view.model.clickedKeyButtonHandler = ^{
            WMTipAlertView *view = [[WMTipAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealWidth(100))];
            view.tip = WMLocalizedString(@"calculate_tips", @"Calculate based on the total amount of item.");
            [view layoutyImmediately];
            WMCustomViewActionView *actionView = [WMCustomViewActionView actionViewWithContentView:view block:^(HDCustomViewActionViewConfig *_Nullable config) {
                config.title = WMLocalizedString(@"notice", @"Notice");
                config.containerMinHeight = kRealWidth(28);
            }];
            [actionView show];
        };
        [view setNeedsUpdateContent];
        view.hidden = true;
        _vatFeeView = view;
    }
    return _vatFeeView;
}

- (SAInfoView *)packingFeeView {
    if (!_packingFeeView) {
        SAInfoView *view = SAInfoView.new;
        view.model = [self infoViewModelWithKey:WMLocalizedString(@"packing_fee", @"包装费")];
        view.model.lineWidth = 0;
        view.model.valueFont = [HDAppTheme.WMFont wm_ForSize:14 fontName:@"DINPro-Regular"];
        view.model.contentEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(15), kRealWidth(16), kRealWidth(15));
        view.hidden = true;
        [view setNeedsUpdateContent];
        _packingFeeView = view;
    }
    return _packingFeeView;
}

- (SAInfoView *)deliveryFeeView {
    if (!_deliveryFeeView) {
        SAInfoView *view = SAInfoView.new;
        view.model = [self infoViewModelWithKey:WMLocalizedString(@"delivery_fee", @"配送费")];
        view.model.leftImageSize = CGSizeMake(14, 14 * (view.model.leftImage.size.height / view.model.leftImage.size.width));
        view.model.contentEdgeInsets = kInfoViewContentEdgeInsets;
        [view setNeedsUpdateContent];
        view.model.keyImage = [UIImage imageNamed:@"yn_submit_help"];
        _deliveryFeeView = view;
    }
    return _deliveryFeeView;
}

- (SAInfoView *)deliveryFeeDetailView {
    if (!_deliveryFeeDetailView) {
        SAInfoView *view = SAInfoView.new;
        view.model = [self infoViewModelWithKey:WMLocalizedString(@"", @"")];
        view.model.leftImageSize = CGSizeMake(14, 14 * (view.model.leftImage.size.height / view.model.leftImage.size.width));
        view.model.contentEdgeInsets = kInfoViewContentEdgeInsets;
        [view setNeedsUpdateContent];
        view.model.keyImage = [UIImage imageNamed:@"yn_submit_help"];
        _deliveryFeeDetailView = view;
        _deliveryFeeDetailView.hidden = YES;
    }
    return _deliveryFeeDetailView;
}

- (SAInfoView *)fullGiftView {
    if (!_fullGiftView) {
        SAInfoView *view = SAInfoView.new;
        view.model = [self infoViewModelWithKey:WMLocalizedString(@"wm_fill_gift_activity", @"满赠活动")];
        view.model.leftImageSize = CGSizeMake(14, 14 * (view.model.leftImage.size.height / view.model.leftImage.size.width));
        view.model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(13), kRealWidth(15), kRealWidth(14), kRealWidth(15));
        view.hidden = true;
        view.model.enableTapRecognizer = true;
        [view setNeedsUpdateContent];
        _fullGiftView = view;
    }
    return _fullGiftView;
}

- (SAInfoView *)promotionFeeView {
    if (!_promotionFeeView) {
        SAInfoView *view = SAInfoView.new;
        view.model = [self infoViewModelWithKey:WMLocalizedString(@"promotions", @"优惠活动")];
        view.model.leftImage = [UIImage imageNamed:@"store_info_promotion_discount"];
        view.model.leftImageSize = CGSizeMake(14, 14 * (view.model.leftImage.size.height / view.model.leftImage.size.width));
        view.model.rightButtonImage = [UIImage imageNamed:@"yn_submit_gengd_small"];
        view.model.lineWidth = 0;
        view.model.keyToValueWidthRate = 2;
        view.model.enableTapRecognizer = true;
        @HDWeakify(self);
        view.model.eventHandler = ^{
            @HDStrongify(self);
            [self showPromotionsView];
        };
        view.model.contentEdgeInsets = kInfoViewContentEdgeInsets;
        view.hidden = true;
        [view setNeedsUpdateContent];
        _promotionFeeView = view;
    }
    return _promotionFeeView;
}

- (WMOrderSubmitPromotionItemView *)lessFeeView {
    if (!_lessFeeView) {
        _lessFeeView = [[WMOrderSubmitPromotionItemView alloc] init];
        _lessFeeView.from = 1;
        _lessFeeView.marketingType = WMStorePromotionMarketingTypeDiscount;
        _lessFeeView.hidden = YES;
        [_lessFeeView setBlockOnClickPromotion:^{
            WMTipAlertView *view = [[WMTipAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealWidth(100))];
            view.tip = WMLocalizedString(@"wm_reduce_deductvatfees", @"wm_reduce_deductvatfees");
            [view layoutyImmediately];
            WMCustomViewActionView *actionView = [WMCustomViewActionView actionViewWithContentView:view block:^(HDCustomViewActionViewConfig *_Nullable config) {
                config.title = WMLocalizedString(@"notice", @"Notice");
                config.containerMinHeight = kRealWidth(28);
            }];
            [actionView show];
        }];
    }
    return _lessFeeView;
}

- (WMOrderSubmitPromotionItemView *)offFeeView {
    if (!_offFeeView) {
        _offFeeView = [[WMOrderSubmitPromotionItemView alloc] init];
        _offFeeView.from = YES;
        _offFeeView.marketingType = WMStorePromotionMarketingTypeLabber;
        _offFeeView.hidden = YES;
        [_offFeeView setBlockOnClickPromotion:^{
            WMTipAlertView *view = [[WMTipAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealWidth(100))];
            view.tip = WMLocalizedString(@"wm_reduce_deductvatfees", @"wm_reduce_deductvatfees");
            [view layoutyImmediately];
            WMCustomViewActionView *actionView = [WMCustomViewActionView actionViewWithContentView:view block:^(HDCustomViewActionViewConfig *_Nullable config) {
                config.title = WMLocalizedString(@"notice", @"Notice");
                config.containerMinHeight = kRealWidth(28);
            }];
            [actionView show];
        }];
    }
    return _offFeeView;
}

- (WMOrderSubmitPromotionItemView *)firstFeeView {
    if (!_firstFeeView) {
        _firstFeeView = [[WMOrderSubmitPromotionItemView alloc] init];
        _firstFeeView.from = YES;
        _firstFeeView.marketingType = WMStorePromotionMarketingTypeFirst;
        _firstFeeView.hidden = YES;
        [_firstFeeView setBlockOnClickPromotion:^{
            WMTipAlertView *view = [[WMTipAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealWidth(100))];
            view.tip = WMLocalizedString(@"wm_first_deductvatfees", @"wm_first_deductvatfees");
            [view layoutyImmediately];
            WMCustomViewActionView *actionView = [WMCustomViewActionView actionViewWithContentView:view block:^(HDCustomViewActionViewConfig *_Nullable config) {
                config.title = WMLocalizedString(@"notice", @"Notice");
                config.containerMinHeight = kRealWidth(28);
            }];
            [actionView show];
        }];
    }
    return _firstFeeView;
}

- (WMOrderSubmitPromotionItemView *)couponFeeView {
    if (!_couponFeeView) {
        _couponFeeView = [[WMOrderSubmitPromotionItemView alloc] init];
        _couponFeeView.from = YES;
        _couponFeeView.marketingType = WMStorePromotionMarketingTypeCoupon;
        _couponFeeView.hidden = YES;
        @HDWeakify(self);
        [_couponFeeView setBlockOnClickPromotion:^{
            @HDStrongify(self);
            [self showPromotionsView];
        }];
    }
    return _couponFeeView;
}

- (SAInfoView *)couponView {
    if (!_couponView) {
        SAInfoView *view = SAInfoView.new;
        view.model = [self infoViewModelWithKey:WMLocalizedString(@"order_sumit_coupon", @"优惠券")];
        view.model.leftImageSize = CGSizeMake(14, 14 * (view.model.leftImage.size.height / view.model.leftImage.size.width));
        view.model.rightButtonaAlignKey = YES;
        view.model.keyImage = [UIImage imageNamed:@"yn_submit_help"];
        view.model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(6), kRealWidth(15), kRealWidth(6), kRealWidth(15));
        view.model.valueCornerRadio = kRealWidth(12);
        view.model.clickedKeyButtonHandler = ^{
            WMTipAlertView *view = [[WMTipAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealWidth(100))];
            view.tip = WMLocalizedString(@"wm_coupons_deductvatfees", @"优惠券不扣减税费和配送费");
            [view layoutyImmediately];
            WMCustomViewActionView *actionView = [WMCustomViewActionView actionViewWithContentView:view block:^(HDCustomViewActionViewConfig *_Nullable config) {
                config.title = WMLocalizedString(@"order_sumit_coupon", @"优惠券");
                config.containerMinHeight = kRealWidth(28);
            }];
            [actionView show];
        };
        view.userInteractionEnabled = false;
        @HDWeakify(self);
        view.model.clickedValueButtonHandler = ^{
            @HDStrongify(self);
            !self.chooseCouponBlock ?: self.chooseCouponBlock(self.couponModel);
        };
        view.model.clickedRightButtonHandler = ^{
            @HDStrongify(self);
            !self.chooseCouponBlock ?: self.chooseCouponBlock(self.couponModel);
        };
        [view setNeedsUpdateContent];
        _couponView = view;
    }
    return _couponView;
}

- (SAInfoView *)freightView {
    if (!_freightView) {
        SAInfoView *view = SAInfoView.new;
        view.model = [self infoViewModelWithKey:WMLocalizedString(@"wm_delivery_fee_coupon", @"运费券")];
        view.model.leftImageSize = CGSizeMake(14, 14 * (view.model.leftImage.size.height / view.model.leftImage.size.width));
        view.model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(6), kRealWidth(15), kRealWidth(6), kRealWidth(15));
        view.model.valueCornerRadio = kRealWidth(12);
        view.userInteractionEnabled = false;
        @HDWeakify(self);
        view.model.clickedValueButtonHandler = ^{
            @HDStrongify(self);
            !self.chooseFreightCouponBlock ?: self.chooseFreightCouponBlock(self.freightModel);
        };
        view.model.clickedRightButtonHandler = ^{
            @HDStrongify(self);
            !self.chooseFreightCouponBlock ?: self.chooseFreightCouponBlock(self.freightModel);
        };
        [view setNeedsUpdateContent];
        _freightView = view;
    }
    return _freightView;
}

- (SAInfoView *)subTotalMoneyView {
    if (!_subTotalMoneyView) {
        SAInfoView *view = SAInfoView.new;
        view.model = [self infoViewModelWithKey:WMLocalizedString(@"sub_total", @"小计")];
        view.model.keyFont = [HDAppTheme.WMFont wm_boldForSize:14];
        view.model.keyColor = HDAppTheme.WMColor.B3;
        view.model.valueFont = [HDAppTheme.WMFont wm_ForSize:16 fontName:@"DINPro-Bold"];
        view.model.valueColor = HDAppTheme.WMColor.B3;
        view.model.contentEdgeInsets = kInfoViewContentEdgeInsets;
        view.hidden = true;
        [view setNeedsUpdateContent];
        _subTotalMoneyView = view;
    }
    return _subTotalMoneyView;
}

- (SAInfoView *)promoCodeView {
    if (!_promoCodeView) {
        SAInfoView *view = SAInfoView.new;
        view.model = [self infoViewModelWithKey:WMLocalizedString(@"OkaO8L5F", @"优惠码")];
        view.model.valueColor = HDAppTheme.color.G3;
        view.model.keyImage = [UIImage imageNamed:@"yn_submit_help"];
        view.model.valueNumbersOfLines = 1;
        view.model.keyToValueWidthRate = 0.4;
        view.model.enableTapRecognizer = true;
        view.model.rightButtonaAlignKey = YES;
        view.model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(6), kRealWidth(15), kRealWidth(12), kRealWidth(15));
        view.model.clickedKeyButtonHandler = ^{
            WMTipAlertView *view = [[WMTipAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealWidth(100))];
            view.tip = [NSString stringWithFormat:@"%@\n%@", WMLocalizedString(@"ewg4ldyU", @"ewg4ldyU"), WMLocalizedString(@"wm_promocode_deductvatfees", @"wm_promocode_deductvatfees")];
            [view layoutyImmediately];
            WMCustomViewActionView *actionView = [WMCustomViewActionView actionViewWithContentView:view block:^(HDCustomViewActionViewConfig *_Nullable config) {
                config.title = WMLocalizedString(@"EdvP49Dy", @"使用说明");
                config.containerMinHeight = kRealWidth(28);
            }];
            [actionView show];
        };
        [view setNeedsUpdateContent];
        view.keyButton.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        _promoCodeView = view;
    }
    return _promoCodeView;
}

- (SAInfoView *)totalDiscountView {
    if (!_totalDiscountView) {
        SAInfoView *view = SAInfoView.new;
        view.model = [self infoViewModelWithKey:nil];
        view.model.lineWidth = 0;
        view.model.keyText = WMLocalizedString(@"wm_submit_discount", @"合计优惠");
        view.model.keyColor = HDAppTheme.WMColor.B3;
        view.model.contentEdgeInsets = kInfoViewContentEdgeInsets;
        view.model.valueColor = HDAppTheme.WMColor.mainRed;
        view.model.valueFont = [HDAppTheme.WMFont wm_ForSize:14 fontName:@"DINPro-Bold"];
        view.model.keyFont = [HDAppTheme.WMFont wm_boldForSize:14];
        view.hidden = true;
        _totalDiscountView = view;
    }
    return _totalDiscountView;
}

- (UIView *)goodsInfoView {
    if (!_goodsInfoView) {
        _goodsInfoView = UIView.new;
        _goodsInfoView.backgroundColor = HDAppTheme.WMColor.bg3;
    }
    return _goodsInfoView;
}

- (UIView *)vatAndDeveliyContainer {
    if (!_vatAndDeveliyContainer) {
        _vatAndDeveliyContainer = UIView.new;
        _vatAndDeveliyContainer.backgroundColor = HDAppTheme.WMColor.bg3;
        _vatAndDeveliyContainer.hidden = true;
    }
    return _vatAndDeveliyContainer;
}

- (UIView *)priceInfoView {
    if (!_priceInfoView) {
        _priceInfoView = UIView.new;
        _priceInfoView.backgroundColor = HDAppTheme.WMColor.bg3;
        _priceInfoView.hidden = true;
    }
    return _priceInfoView;
}

- (UIControl *)storeControl {
    if (!_storeControl) {
        _storeControl = UIControl.new;
        _storeControl.userInteractionEnabled = NO;
        //        [_storeControl addTarget:self action:@selector(pushStoreDetailAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _storeControl;
}

- (HDUIButton *)slowPayBTN {
    if (!_slowPayBTN) {
        HDUIButton *button = HDUIButton.new;
        [button setTitleColor:HDAppTheme.WMColor.white forState:UIControlStateNormal];
        [button setTitle:WMLocalizedString(@"wm_later_to_pay", @"") forState:UIControlStateNormal];
        button.titleLabel.font = [HDAppTheme.WMFont wm_ForSize:11];
        button.layer.backgroundColor = HDAppTheme.WMColor.mainRed.CGColor;
        button.layer.cornerRadius = 2;
        button.userInteractionEnabled = NO;
        button.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(4), kRealWidth(8), kRealWidth(4), kRealWidth(8));
        _slowPayBTN = button;
    }
    return _slowPayBTN;
}

- (UIView *)slowPayView {
    if (!_slowPayView) {
        _slowPayView = UIView.new;
        _slowPayView.hidden = YES;
        UITapGestureRecognizer *slowTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(slowHelpAction)];
        [_slowPayView addGestureRecognizer:slowTap];
    }
    return _slowPayView;
}

- (void)slowHelpAction {
    HDWebViewHostViewController *vc = HDWebViewHostViewController.new;
    SAAppEnvConfig *model = SAAppEnvManager.sharedInstance.appEnvConfig;
    NSString *path = @"/mobile-h5/marketing/slow-pay";
    vc.url = [NSString stringWithFormat:@"%@%@%@", model.h5URL, [path hasPrefix:@"/"] ? @"" : @"/", path];
    [SAWindowManager navigateToViewController:vc parameters:@{}];
}

- (UIImageView *)slowPayIcon {
    if (!_slowPayIcon) {
        _slowPayIcon = UIImageView.new;
        _slowPayIcon.image = [UIImage imageNamed:@"yn_submit_help"];
    }
    return _slowPayIcon;
}


@end
