//
//  WMOrderDetailMainInfoView.m
//  SuperApp
//
//  Created by VanJay on 2020/5/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderDetailMainInfoView.h"
#import "HDPopViewManager.h"
#import "SAInfoView.h"
#import "SAShadowBackgroundView.h"
#import "WMCustomViewActionView.h"
#import "WMOrderBoxView.h"
#import "WMOrderDetailCouponModel.h"
#import "WMOrderDetailPromotionModel.h"
#import "WMOrderDetailRspModel.h"
#import "WMOrderSubmitProductView.h"
#import "WMOrderSubmitPromotionItemView.h"
#import "WMOrderSubmitPromotionModel.h"
#import "WMShoppingCartStoreProduct.h"
#import "WMTipAlertView.h"
#import "GNAlertUntils.h"

static NSUInteger const kMaxDefaultShowProductCount = 3;


@interface WMOrderDetailMainInfoView ()
/// 门店icon
@property (nonatomic, strong) UIImageView *iconIV;
/// 门店名称
@property (nonatomic, strong) SALabel *titleLB;
/// 门店跳转view
@property (nonatomic, strong) UIView *titleBgView;
/// 箭头
@property (nonatomic, strong) UIImageView *arrowIV;

/// 导航按钮
@property (nonatomic, strong) HDUIButton *storeNaviBtn;
/// 分割线
@property (nonatomic, strong) UIView *sepLine1;
/// 分割线
@property (nonatomic, strong) UIView *sepLine2;
/// 分割线
@property (nonatomic, strong) UIView *sepLine3;
/// 所有的属性
@property (nonatomic, strong) NSMutableArray *infoViewList;
/// 增值税
@property (nonatomic, strong) SAInfoView *vatFeeView;
/// 打包费
@property (nonatomic, strong) SAInfoView *packingFeeView;
/// 配送费
@property (nonatomic, strong, readwrite) SAInfoView *deliveryFeeView;
/// 满赠
@property (nonatomic, strong) SAInfoView *fullGiftView;
/// 活动金额
// @property (nonatomic, strong) SAInfoView *promotionFeeView;
/// 优惠券
@property (nonatomic, strong) SAInfoView *couponView;
/// 优惠券
@property (nonatomic, strong) SAInfoView *freightView;
/// 促销码
@property (nonatomic, strong) SAInfoView *promoCodeView;

/// 打折
@property (nonatomic, strong) WMOrderSubmitPromotionItemView *lessFeeView;
/// 满减
@property (nonatomic, strong) WMOrderSubmitPromotionItemView *offFeeView;
/// 首单减免
@property (nonatomic, strong) WMOrderSubmitPromotionItemView *firstFeeView;
/// 优惠券
@property (nonatomic, strong) WMOrderSubmitPromotionItemView *couponFeeView;

/// 小计金额
@property (nonatomic, strong) SAInfoView *subTotalMoneyView;
/// 总金额
@property (nonatomic, strong) SAInfoView *totalMoneyView;
/// 汇率
@property (nonatomic, strong) SAInfoView *exchangeRateView;
/// 总的优惠金额
@property (nonatomic, strong) SAInfoView *totalDiscountView;

///< 支付营销减免
@property (nonatomic, strong) SAInfoView *paymentDiscountView;
///< 实付金额
@property (nonatomic, strong) SAInfoView *actuallyPaidAmountView;

/// 收起、展开按钮
@property (nonatomic, strong) HDUIButton *expandBTN;
/// 商品容器
@property (nonatomic, strong) UIView *goodsContainer;
/// 赠品容器
@property (nonatomic, strong) UIView *giftsContainer;
/// model
@property (nonatomic, strong) WMOrderDetailRspModel *model;
///总优惠
@property (nonatomic, assign) NSInteger distotalAmout;
/// 慢必赔
@property (nonatomic, strong) HDUIButton *slowPayBTN;
/// 慢必赔
@property (nonatomic, strong) UIView *slowPayView;
/// 慢必赔
@property (nonatomic, strong) UIImageView *slowPayIcon;
///< viewmodel
@property (nonatomic, strong) SAViewModel *viewModel;
@end


@implementation WMOrderDetailMainInfoView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    self = [super initWithViewModel:viewModel];
    return self;
}

- (void)hd_setupViews {
    self.layer.backgroundColor = HDAppTheme.WMColor.bg3.CGColor;
    self.layer.cornerRadius = kRealWidth(8);
    [self addSubview:self.titleBgView];
    [self addSubview:self.iconIV];
    [self addSubview:self.titleLB];
    [self addSubview:self.arrowIV];
    [self addSubview:self.storeNaviBtn];
    [self addSubview:self.sepLine1];
    [self addSubview:self.goodsContainer];
    [self addSubview:self.expandBTN];
    [self addSubview:self.sepLine2];
    [self addSubview:self.sepLine3];
    [self addSubview:self.packingFeeView];
    [self addSubview:self.subTotalMoneyView];
    [self addSubview:self.lessFeeView];
    [self addSubview:self.offFeeView];
    [self addSubview:self.firstFeeView];
    [self addSubview:self.couponFeeView];
    [self addSubview:self.fullGiftView];
    [self addSubview:self.couponView];
    [self addSubview:self.freightView];
    [self addSubview:self.promoCodeView];
    [self addSubview:self.deliveryFeeView];
    [self addSubview:self.vatFeeView];
    [self addSubview:self.totalMoneyView];
    [self addSubview:self.exchangeRateView];
    [self addSubview:self.giftsContainer];
    [self addSubview:self.giftsContainer];
    [self addSubview:self.paymentDiscountView];
    [self addSubview:self.actuallyPaidAmountView];
    [self addSubview:self.totalDiscountView];
    [self addSubview:self.slowPayView];
    [self.slowPayView addSubview:self.slowPayBTN];
    [self.slowPayView addSubview:self.slowPayIcon];

    [self.infoViewList addObject:self.fullGiftView];
    [self.infoViewList addObject:self.giftsContainer];

    [self.infoViewList addObject:self.packingFeeView];
    [self.infoViewList addObject:self.subTotalMoneyView];
    [self.infoViewList addObject:self.deliveryFeeView];
    [self.infoViewList addObject:self.vatFeeView];

    [self.infoViewList addObject:self.lessFeeView];
    [self.infoViewList addObject:self.couponFeeView];
    [self.infoViewList addObject:self.offFeeView];
    [self.infoViewList addObject:self.firstFeeView];

    [self.infoViewList addObject:self.couponView];
    [self.infoViewList addObject:self.freightView];
    [self.infoViewList addObject:self.promoCodeView];

    [self.infoViewList addObject:self.totalDiscountView];
    [self.infoViewList addObject:self.totalMoneyView];
    [self.infoViewList addObject:self.exchangeRateView];

    [self.infoViewList addObject:self.paymentDiscountView];
    [self.infoViewList addObject:self.actuallyPaidAmountView];

    [self.storeNaviBtn setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)updateConstraints {
    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.iconIV.image.size);
        make.centerY.equalTo(self.titleLB);
        make.left.equalTo(self).offset(kRealWidth(12));
    }];
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kRealWidth(12));
        make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(4));
        make.height.mas_greaterThanOrEqualTo(kRealWidth(24));
        make.right.equalTo(self.arrowIV.mas_left).offset(-kRealWidth(12));
    }];
    [self.titleBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self.iconIV);
        make.right.equalTo(self);
        make.bottom.equalTo(self.sepLine1.mas_top);
    }];

    [self.arrowIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.arrowIV.isHidden) {
            make.height.equalTo(self.titleLB);
            make.width.mas_equalTo(self.arrowIV.image.size.width);
            make.centerY.equalTo(self.titleLB);
            if (self.slowPayView.isHidden) {
                make.right.mas_equalTo(-kRealWidth(12));
            } else {
                make.right.lessThanOrEqualTo(self.slowPayView.mas_left);
            }
        }
    }];

    [self.storeNaviBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.storeNaviBtn.isHidden) {
            make.centerY.equalTo(self.titleLB);
            if (self.slowPayView.isHidden) {
                make.right.mas_equalTo(-kRealWidth(12));
            } else {
                make.right.lessThanOrEqualTo(self.slowPayView.mas_left);
            }
        }
    }];

    [self.slowPayView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.slowPayView.isHidden) {
            make.centerY.equalTo(self.titleLB);
            make.right.mas_equalTo(-kRealWidth(12));
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

    const CGFloat lineHeight = HDAppTheme.WMValue.line;
    [self.sepLine1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(lineHeight);
        make.left.equalTo(self).offset(kRealWidth(12));
        make.right.equalTo(self).offset(-kRealWidth(12));
        make.top.equalTo(self.titleLB.mas_bottom).offset(kRealWidth(13));
    }];

    [self.goodsContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.left.right.mas_equalTo(0);
        make.top.equalTo(self.sepLine1.mas_bottom);
        if (HDIsArrayEmpty(self.goodsContainer.subviews)) {
            make.height.mas_equalTo(CGFLOAT_MIN);
        }
    }];
    WMOrderSubmitProductView *lastProductView;
    UIView *lastViewNotHidden;
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
        if (!productView.isHidden) {
            lastViewNotHidden = productView;
        }
        lastProductView = productView;
    }
    lastViewNotHidden = lastViewNotHidden ?: self.sepLine1;

    [self.expandBTN sizeToFit];
    [self.expandBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.expandBTN.isHidden) {
            make.size.mas_equalTo(self.expandBTN.bounds.size);
            make.centerX.equalTo(self.goodsContainer);
            make.top.equalTo(lastViewNotHidden.mas_bottom).offset(kRealWidth(10));
        }
    }];
    [self.sepLine2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.sepLine2.isHidden) {
            make.height.mas_equalTo(lineHeight);
            make.left.equalTo(self).offset(kRealWidth(12));
            make.right.equalTo(self).offset(-kRealWidth(12));
            UIView *view = self.expandBTN.isHidden ? self.goodsContainer : self.expandBTN;
            make.top.equalTo(view.mas_bottom).offset(kRealWidth(12));
        }
    }];

    NSArray<SAInfoView *> *visableInfoViews = [self.infoViewList hd_filterWithBlock:^BOOL(SAInfoView *_Nonnull item) {
        return !item.isHidden;
    }];
    SAInfoView *lastInfoView;
    for (SAInfoView *infoView in visableInfoViews) {
        if (infoView == visableInfoViews.lastObject) {
            infoView.model.lineWidth = 0;
        }
        [infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (lastInfoView) {
                make.top.equalTo(lastInfoView.mas_bottom);
            } else {
                make.top.equalTo(self.sepLine2.mas_bottom);
            }
            make.left.equalTo(self);
            make.right.equalTo(self);
            if (infoView == visableInfoViews.lastObject) {
                make.bottom.equalTo(self);
            }
        }];
        if (infoView == self.totalMoneyView) {
            [self.sepLine3 mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(lineHeight);
                make.left.equalTo(self).offset(kRealWidth(12));
                make.right.equalTo(self).offset(-kRealWidth(12));
                if (lastInfoView) {
                    make.top.equalTo(lastInfoView.mas_bottom).offset(kRealWidth(13));
                } else {
                    make.top.equalTo(self.sepLine2.mas_bottom);
                }
            }];

            [infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.sepLine3.mas_bottom).offset(kRealWidth(6));
                make.left.equalTo(self);
                make.right.equalTo(self);
            }];
        }
        lastInfoView = infoView;
    }

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

    [super updateConstraints];
}

#pragma mark - public methods
- (void)configureWithOrderDetailRspModel:(WMOrderDetailRspModel *)model {
    ///总优惠
    self.distotalAmout = 0;
    self.model = model;
    self.titleLB.text = model.merchantStoreDetail.storeName.desc;

    NSMutableArray *giftArr = NSMutableArray.new;

    [self.goodsContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    // 商品默认最多显示3个，超过三个显示展开按钮，点击可展开收缩
    self.expandBTN.hidden = model.orderDetailForUser.commodity.commodityList.count <= kMaxDefaultShowProductCount;
    for (NSUInteger i = 0; i < model.orderDetailForUser.commodity.commodityList.count; i++) {
        WMOrderDetailProductModel *product = model.orderDetailForUser.commodity.commodityList[i];
        if (product.commodityType == WMGoodsCommodityTypeGift) {
            [giftArr addObject:product];
        } else {
            WMOrderSubmitProductView *productView = WMOrderSubmitProductView.new;
            productView.hidden = i >= kMaxDefaultShowProductCount;
            product.storeStatus = model.merchantStoreDetail.storeStatus;
            WMShoppingCartStoreProduct *shoppingCartProduct = [WMShoppingCartStoreProduct modelWithOrderDetailProductModel:product];
            productView.model = shoppingCartProduct;
            productView.fromOrderDetail = YES;
            [self.goodsContainer addSubview:productView];
        }
    }

    self.vatFeeView.hidden = model.orderDetailForUser.commodity.vat.cent.doubleValue <= 0;
    if (!self.vatFeeView.isHidden) {
        SAInfoViewModel *infoModel = self.vatFeeView.model;
        infoModel.keyText = [NSString stringWithFormat:@"%@(%@%%)", WMLocalizedString(@"cart_vat_fee", @"增值税"), model.orderDetailForUser.commodity.vatRate];
        infoModel.valueText = model.orderDetailForUser.commodity.vat.thousandSeparatorAmount;
        self.vatFeeView.model = infoModel;
        [self.vatFeeView setNeedsUpdateContent];
    }
    self.packingFeeView.hidden = model.orderDetailForUser.commodity.totalPackageFee.cent.doubleValue <= 0;
    if (!self.packingFeeView.isHidden) {
        self.packingFeeView.model.valueText = model.orderDetailForUser.commodity.totalPackageFee.thousandSeparatorAmount;
        self.packingFeeView.model.keyImage = [UIImage imageNamed:@"yn_submit_help"];
        self.packingFeeView.model.clickedKeyButtonHandler = ^{
            WMOrderBoxView *contenView = [[WMOrderBoxView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
            [contenView configureWithOrderDetailRspModel:model.orderDetailForUser.commodity];
            [contenView layoutyImmediately];
            WMCustomViewActionView *actionView = [WMCustomViewActionView actionViewWithContentView:contenView block:^(HDCustomViewActionViewConfig *_Nullable config) {
                config.title = WMLocalizedString(@"wm_total_packing_fee_remark", @"使用说明");
            }];
            [actionView show];
        };
        [self.packingFeeView setNeedsUpdateContent];
    }

    // 根据是否有减配送费活动计算配送费
    NSArray<WMOrderDetailPromotionModel *> *activityDiscountInfo = model.discountInfo.activityDiscountInfo;
    /// 减免的配送费
    SAMoneyModel *reduceDeliveryFee;
    for (WMOrderDetailPromotionModel *promotionModel in activityDiscountInfo) {
        if (promotionModel.marketingType == WMStorePromotionMarketingTypeDelievry) {
            reduceDeliveryFee = promotionModel.discountAmt;
            break;
        }
    }
    if (model.orderDetailForUser.serviceType == 20) {
        self.deliveryFeeView.hidden = YES;
    } else {
        if (reduceDeliveryFee) {
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
            if (HDIsStringNotEmpty(model.orderDetailForUser.commodity.deliverFee.thousandSeparatorAmount)) {
                NSAttributedString *originalDeliveryFeeStr = [[NSAttributedString alloc] initWithString:model.orderDetailForUser.commodity.deliverFee.thousandSeparatorAmount attributes:@{
                    NSFontAttributeName: [HDAppTheme.WMFont wm_ForSize:11 fontName:@"DINPro-Regular"],
                    NSForegroundColorAttributeName: HDAppTheme.WMColor.B9,
                    NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle | NSUnderlinePatternSolid),
                    NSStrikethroughColorAttributeName: HDAppTheme.WMColor.B9
                }];
                [text appendAttributedString:originalDeliveryFeeStr];
            }
            // 空格
            NSAttributedString *whiteSpace = [[NSAttributedString alloc] initWithString:@" "];
            [text appendAttributedString:whiteSpace];

            // 计算优惠后的配送费
            SAMoneyModel *afterPromotionDeliveryFee = SAMoneyModel.new;
            afterPromotionDeliveryFee.cy = model.orderDetailForUser.commodity.deliverFee.cy;
            afterPromotionDeliveryFee.cent = [NSString stringWithFormat:@"%zd", model.orderDetailForUser.commodity.deliverFee.cent.integerValue - reduceDeliveryFee.cent.integerValue];
            self.deliveryFeeView.hidden = false;

            if (HDIsStringNotEmpty(afterPromotionDeliveryFee.thousandSeparatorAmount)) {
                NSAttributedString *afterPromotionDeliveryFeeStr = [[NSAttributedString alloc] initWithString:afterPromotionDeliveryFee.thousandSeparatorAmount attributes:@{
                    NSFontAttributeName: [HDAppTheme.WMFont wm_ForSize:14 fontName:@"DINPro-Regular"],
                    NSForegroundColorAttributeName: HDAppTheme.WMColor.B3,
                    NSStrikethroughStyleAttributeName: @(NSUnderlineStyleNone)
                }];
                [text appendAttributedString:afterPromotionDeliveryFeeStr];
            }
            self.deliveryFeeView.model.associatedObject = afterPromotionDeliveryFee;
            self.deliveryFeeView.model.attrValue = text;
        } else {
            SAMoneyModel *deliverFee = model.orderDetailForUser.commodity.deliverFee;
            self.deliveryFeeView.model.valueText = deliverFee.thousandSeparatorAmount;
            self.deliveryFeeView.model.associatedObject = deliverFee;
            self.deliveryFeeView.hidden = deliverFee.cent.integerValue < 0;
        }
        [self.deliveryFeeView setNeedsUpdateContent];
    }

    model.discountInfo.couponDiscountInfo = [model.discountInfo.couponDiscountInfo hd_filterWithBlock:^BOOL(WMOrderDetailCouponModel *_Nonnull item) {
        return item.couponType != SACouponTicketTypeFreight;
    }];
    self.couponView.hidden = HDIsArrayEmpty(model.discountInfo.couponDiscountInfo);
    if (!self.couponView.isHidden) {
        SAMoneyModel *totalCouponAmountMoney = SAMoneyModel.new;
        NSUInteger totalCouponAmountMoneyCent = 0;
        // 累加优惠券金额
        for (WMOrderDetailCouponModel *couponModel in model.discountInfo.couponDiscountInfo) {
            totalCouponAmountMoney.cy = couponModel.discountAmt.cy;
            totalCouponAmountMoneyCent += couponModel.discountAmt.cent.integerValue;
        }
        self.couponView.hidden = totalCouponAmountMoneyCent <= 0;
        if (!self.couponView.isHidden) {
            totalCouponAmountMoney.cent = [NSString stringWithFormat:@"%zd", totalCouponAmountMoneyCent];
            self.couponView.model.valueText = [NSString stringWithFormat:@"-%@", totalCouponAmountMoney.thousandSeparatorAmount];
            [self.couponView setNeedsUpdateContent];
        }
        self.distotalAmout += totalCouponAmountMoneyCent;
    }

    self.freightView.hidden = HDIsObjectNil(model.orderDetailForUser.commodity.freightCouponAmount);
    if (!self.freightView.isHidden) {
        self.freightView.hidden = model.orderDetailForUser.commodity.freightCouponAmount.cent.integerValue <= 0;
        if (!self.freightView.isHidden) {
            self.freightView.model.valueText = [NSString stringWithFormat:@"-%@", model.orderDetailForUser.commodity.freightCouponAmount.thousandSeparatorAmount];
            [self.freightView setNeedsUpdateContent];
            self.distotalAmout += model.orderDetailForUser.commodity.freightCouponAmount.cent.integerValue;
        }
    }

    [self configureWithPromotionList:model.discountInfo.activityDiscountInfo];

    self.promoCodeView.hidden = HDIsArrayEmpty(model.discountInfo.promotionCodeDiscountInfo);
    if (!self.promoCodeView.isHidden) {
        SAMoneyModel *totalpromoCodeAmountMoney = SAMoneyModel.new;
        NSUInteger totalpromoCodeAmountMoneyCent = 0;
        // 累加优惠券金额
        for (WMOrderDetailPromoCodeModel *promoCodeModel in model.discountInfo.promotionCodeDiscountInfo) {
            totalpromoCodeAmountMoney.cy = promoCodeModel.discountAmt.cy;
            totalpromoCodeAmountMoneyCent += promoCodeModel.discountAmt.cent.integerValue;
        }
        self.promoCodeView.hidden = totalpromoCodeAmountMoneyCent <= 0;
        if (!self.promoCodeView.isHidden) {
            totalpromoCodeAmountMoney.cent = [NSString stringWithFormat:@"%zd", totalpromoCodeAmountMoneyCent];
            self.promoCodeView.model.valueText = [NSString stringWithFormat:@"-%@", totalpromoCodeAmountMoney.thousandSeparatorAmount];
            [self.promoCodeView setNeedsUpdateContent];
            self.distotalAmout += totalpromoCodeAmountMoneyCent;
        }
    }

    self.subTotalMoneyView.hidden = HDIsObjectNil(model.orderDetailForUser.payableAmount);
    self.subTotalMoneyView.hidden = YES;
    if (!self.subTotalMoneyView.isHidden) {
        __block long totalMoneyCent = 0;
        [model.orderDetailForUser.commodity.commodityList enumerateObjectsUsingBlock:^(WMOrderDetailProductModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            totalMoneyCent += obj.afterDiscountTotalPrice.cent.integerValue;
        }];

        SAMoneyModel *totalPrice = SAMoneyModel.new;
        totalPrice.cy = model.orderDetailForUser.commodity.commodityList.firstObject.afterDiscountTotalPrice.cy;
        totalPrice.cent = [NSString stringWithFormat:@"%zd", totalMoneyCent];

        // 计算小计金额, 小计金额＝当前商品价格合计＋包装费
        SAMoneyModel *subTotalMoney = SAMoneyModel.new;
        subTotalMoney.cy = model.orderDetailForUser.payableAmount.cy;
        long subTotalMoneyAmount = model.orderDetailForUser.commodity.totalPackageFee.cent.integerValue + totalPrice.cent.integerValue;
        subTotalMoney.cent = [NSString stringWithFormat:@"%zd", subTotalMoneyAmount];
        self.subTotalMoneyView.model.valueText = subTotalMoney.thousandSeparatorAmount;
        [self.subTotalMoneyView setNeedsUpdateContent];
    }

    self.totalMoneyView.hidden = HDIsObjectNil(model.orderDetailForUser.actualAmount);
    if (!self.totalMoneyView.isHidden) {
        [self updateTotalMoneyWithMoneyText:model.orderDetailForUser.actualAmount.thousandSeparatorAmount];
    }

    self.exchangeRateView.hidden = model.orderDetailForUser.exchangeRate <= 0;
    if (!self.exchangeRateView.isHidden) {
        self.exchangeRateView.model.valueText = [NSString stringWithFormat:@"%@ 1:%zd", WMLocalizedString(@"exchange_rate", @"兑换汇率"), model.orderDetailForUser.exchangeRate];
        [self.exchangeRateView setNeedsUpdateContent];
    }
    // 支付营销
    self.paymentDiscountView.hidden = (HDIsObjectNil(model.orderInfo.payDiscountAmount) || model.orderInfo.payDiscountAmount.cent.integerValue == 0);
    self.actuallyPaidAmountView.hidden = self.paymentDiscountView.isHidden;
    if (!self.paymentDiscountView.isHidden) {
        self.paymentDiscountView.model.valueText = [NSString stringWithFormat:@"-%@", model.orderInfo.payDiscountAmount.thousandSeparatorAmount];
        [self.paymentDiscountView setNeedsUpdateContent];
        [self updateActuallyPaidAmountViewWithText:model.orderInfo.payActualPayAmount.thousandSeparatorAmount];
    }

    NSArray *giftList = NSArray.new;
    if (model.orderDetailForUser.commodity.giftList.count) {
        giftList = [NSArray arrayWithArray:model.orderDetailForUser.commodity.giftList];
    } else {
        giftList = [NSArray arrayWithArray:giftArr];
    }
    self.fullGiftView.hidden = self.giftsContainer.hidden = HDIsArrayEmpty(giftList);
    [self.giftsContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (!HDIsArrayEmpty(giftList)) {
        for (WMStoreFillGiftRuleModel *gift in giftList) {
            SAInfoView *infoView = SAInfoView.new;
            SAInfoViewModel *infoModel = SAInfoViewModel.new;
            infoModel.leftImageURL = gift.commodityPictureIds && gift.commodityPictureIds.count ? gift.commodityPictureIds.firstObject : @" ";
            infoModel.leftImageSize = CGSizeMake(kRealWidth(55), kRealWidth(55));
            infoModel.leftPlaceholderImage = [UIImage imageNamed:@"order_gift"];
            NSString *str = @"";
            if ([gift isKindOfClass:WMStoreFillGiftRuleModel.class]) {
                str = [NSString stringWithFormat:@"%@\tx%ld", gift.commodityName, gift.quantity];
                infoModel.keyText = gift.commodityName ?: @"";
                infoModel.valueText = [NSString stringWithFormat:@"x%ld", (long)gift.quantity];
            } else if ([gift isKindOfClass:WMOrderDetailProductModel.class]) {
                infoModel.keyText = gift.commodityName ?: @"";
                infoModel.valueText = [NSString stringWithFormat:@"x%ld", (long)gift.quantity];
            }
            infoModel.keyFont = [HDAppTheme.WMFont wm_ForSize:12];
            infoModel.valueFont = [HDAppTheme.WMFont wm_ForSize:12 fontName:@"DINPro-Regular"];
            infoModel.keyColor = HDAppTheme.WMColor.B3;
            infoModel.valueColor = HDAppTheme.WMColor.mainRed;
            infoModel.lineWidth = 0;
            infoView.model = infoModel;
            infoModel.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(30), kRealWidth(15), kRealWidth(30), kRealWidth(15));
            [self.giftsContainer addSubview:infoView];
        }
        self.fullGiftView.model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(10), kRealWidth(15), kRealWidth(18), kRealWidth(15));
        [self.fullGiftView setNeedsUpdateContent];
    }

    ///总优惠
    SAMoneyModel *totalDiscountMoney = SAMoneyModel.new;
    totalDiscountMoney.cy = model.orderDetailForUser.payableAmount.cy;
    totalDiscountMoney.cent = [NSString stringWithFormat:@"%zd", self.distotalAmout];
    self.totalDiscountView.hidden = (self.distotalAmout <= 0);
    if (!self.totalDiscountView.hidden) {
        self.totalDiscountView.model.valueText = [NSString stringWithFormat:@"-%@", totalDiscountMoney.thousandSeparatorAmount];
    }
    [self.totalDiscountView setNeedsUpdateContent];
    self.slowPayView.hidden = !self.model.orderDetailForUser.slowPayMark;


    self.storeNaviBtn.hidden = model.orderDetailForUser.serviceType != 20;
    self.arrowIV.hidden = !self.storeNaviBtn.hidden;

    //自取隐藏慢必赔
    if (model.orderDetailForUser.serviceType == 20) {
        self.slowPayView.hidden = YES;
    }

    [self updateSepLineStateAndInfoViewConstraints];
}

- (void)configureWithPromotionList:(NSArray<WMOrderDetailPromotionModel *> *)promotionList {
    // 过滤减配送费优惠
    NSArray<WMOrderDetailPromotionModel *> *noneDeliveryPromotionList = [promotionList hd_filterWithBlock:^BOOL(WMOrderDetailPromotionModel *_Nonnull item) {
        return item.marketingType != WMStorePromotionMarketingTypeDelievry;
    }];
    BOOL promotionHide = HDIsArrayEmpty(noneDeliveryPromotionList);
    if (!promotionHide) {
        // 1.5 版本不会同时存在满减和折扣活动，取第一个活动的类型设置活动标题
        [noneDeliveryPromotionList enumerateObjectsUsingBlock:^(WMOrderDetailPromotionModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            NSString *promitionTitle = WMLocalizedString(@"promotions", @"优惠活动");
            if (obj.discountAmt.cent.doubleValue > 0) {
                if (obj.marketingType == WMStorePromotionMarketingTypeDiscount) {
                    promitionTitle = obj.promotionDesc;
                    self.lessFeeView.hidden = NO;
                    self.lessFeeView.leftTitle = promitionTitle;
                    self.lessFeeView.rightTitle = [NSString stringWithFormat:@"-%@", obj.discountAmt.thousandSeparatorAmount];
                    self.distotalAmout += obj.discountAmt.cent.integerValue;
                } else if (obj.marketingType == WMStorePromotionMarketingTypeLabber || obj.marketingType == WMStorePromotionMarketingTypeStoreLabber) {
                    promitionTitle = obj.promotionDesc;
                    self.offFeeView.hidden = NO;
                    self.offFeeView.leftTitle = promitionTitle;
                    self.offFeeView.rightTitle = [NSString stringWithFormat:@"-%@", obj.discountAmt.thousandSeparatorAmount];
                    self.distotalAmout += obj.discountAmt.cent.integerValue;
                } else if (obj.marketingType == WMStorePromotionMarketingTypeFirst) {
                    promitionTitle = obj.promotionDesc;
                    self.firstFeeView.hidden = NO;
                    self.firstFeeView.leftTitle = promitionTitle;
                    self.firstFeeView.rightTitle = [NSString stringWithFormat:@"-%@", obj.discountAmt.thousandSeparatorAmount];
                    self.distotalAmout += obj.discountAmt.cent.integerValue;
                } else if (obj.marketingType == WMStorePromotionMarketingTypeCoupon) {
                    promitionTitle = obj.promotionDesc;
                    self.couponFeeView.hidden = NO;
                    self.couponFeeView.leftTitle = promitionTitle;
                    self.couponFeeView.rightTitle = [NSString stringWithFormat:@"-%@", obj.discountAmt.thousandSeparatorAmount];
                    self.distotalAmout += obj.discountAmt.cent.integerValue;
                }
            }
        }];
        [self setNeedsUpdateConstraints];
    }
}

#pragma mark - private methods
- (SAInfoViewModel *)infoViewModelWithKey:(NSString *)key {
    SAInfoViewModel *model = SAInfoViewModel.new;
    model.keyColor = HDAppTheme.WMColor.B9;
    model.keyFont = [HDAppTheme.WMFont wm_ForSize:14];
    model.valueColor = HDAppTheme.WMColor.B3;
    model.valueFont = [HDAppTheme.WMFont wm_ForSize:14 fontName:@"DINPro-Regular"];
    model.keyText = key;
    model.lineWidth = 0;
    model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(4), kRealWidth(12), kRealWidth(4), kRealWidth(12));
    return model;
}

- (void)updateSepLineStateAndInfoViewConstraints {
    NSArray<SAInfoView *> *visableInfoViews = [self.infoViewList hd_filterWithBlock:^BOOL(SAInfoView *_Nonnull item) {
        return !item.isHidden;
    }];
    self.sepLine2.hidden = HDIsArrayEmpty(visableInfoViews);

    [self setNeedsUpdateConstraints];
}

- (void)updateActuallyPaidAmountViewWithText:(NSString *)moneyText {
    NSAttributedString *totalStr = [[NSAttributedString alloc] initWithString:SALocalizedString(@"checksd_actuallyPaid", @"实付")
                                                                   attributes:@{NSFontAttributeName: [HDAppTheme.WMFont wm_boldForSize:14], NSForegroundColorAttributeName: HDAppTheme.WMColor.B3}];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString:totalStr];
    [text appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    NSAttributedString *moneyStr =
        [[NSAttributedString alloc] initWithString:moneyText
                                        attributes:@{NSFontAttributeName: [HDAppTheme.WMFont wm_ForSize:16 fontName:@"DINPro-Bold"], NSForegroundColorAttributeName: HDAppTheme.WMColor.B3}];
    [text appendAttributedString:moneyStr];
    self.actuallyPaidAmountView.model.attrValue = text;
    [self.actuallyPaidAmountView setNeedsUpdateContent];
}

- (void)updateTotalMoneyWithMoneyText:(NSString *)moneyText {
    NSMutableAttributedString *totalStr =
        [[NSMutableAttributedString alloc] initWithString:WMLocalizedString(@"cart_total", @"总计")
                                               attributes:@{NSFontAttributeName: [HDAppTheme.WMFont wm_boldForSize:14], NSForegroundColorAttributeName: HDAppTheme.WMColor.B3}];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString:totalStr];
    [text appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    NSMutableAttributedString *moneyStr =
        [[NSMutableAttributedString alloc] initWithString:moneyText
                                               attributes:@{NSFontAttributeName: [HDAppTheme.WMFont wm_ForSize:16 fontName:@"DINPro-Bold"], NSForegroundColorAttributeName: HDAppTheme.WMColor.B3}];
    [moneyStr addAttributes:@{NSFontAttributeName: [HDAppTheme.WMFont wm_ForSize:11 fontName:@"DINPro-Bold"], NSForegroundColorAttributeName: HDAppTheme.WMColor.B3}
                      range:[moneyStr.string rangeOfString:self.model.orderDetailForUser.actualAmount.currencySymbol]];
    [text appendAttributedString:moneyStr];
    self.totalMoneyView.model.attrValue = text;
    [self.totalMoneyView setNeedsUpdateContent];
}

#pragma mark - event response
- (void)clickedExpandBTNHandler:(HDUIButton *)button {
    button.selected = !button.isSelected;

    if (button.isSelected) {
        for (UIView *view in self.goodsContainer.subviews) {
            view.hidden = false;
        }
    } else {
        for (NSUInteger i = 0; i < self.goodsContainer.subviews.count; i++) {
            UIView *view = self.goodsContainer.subviews[i];
            view.hidden = i >= kMaxDefaultShowProductCount;
        }
    }

    [self setNeedsUpdateConstraints];
    [self layoutIfNeeded];
}

- (void)clickStoreTitleHandler {
    if (HDIsObjectNil(self.model)) {
        return;
    }
    [HDMediator.sharedInstance navigaveToStoreDetailViewController:@{
        @"storeNo": self.model.merchantStoreDetail.storeNo,
        @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|订单详情.门店标题"] : @"订单详情.门店标题",
        @"associatedId" : self.viewModel.associatedId
    }];
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
        _sepLine1.backgroundColor = HDAppTheme.WMColor.lineColor;
    }
    return _sepLine1;
}

- (UIView *)sepLine3 {
    if (!_sepLine3) {
        _sepLine3 = UIView.new;
        _sepLine3.backgroundColor = HDAppTheme.WMColor.lineColor;
    }
    return _sepLine3;
}

- (UIView *)sepLine2 {
    if (!_sepLine2) {
        _sepLine2 = UIView.new;
        _sepLine1.backgroundColor = HDAppTheme.WMColor.lineColor;
        _sepLine2.hidden = true;
    }
    return _sepLine2;
}

- (SALabel *)titleLB {
    if (!_titleLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.WMFont wm_boldForSize:16];
        label.textColor = HDAppTheme.WMColor.B3;
        label.numberOfLines = 1;
        _titleLB = label;
    }
    return _titleLB;
}

- (NSMutableArray *)infoViewList {
    if (!_infoViewList) {
        _infoViewList = [NSMutableArray arrayWithCapacity:9];
    }
    return _infoViewList;
}

- (SAInfoView *)vatFeeView {
    if (!_vatFeeView) {
        SAInfoView *view = SAInfoView.new;
        view.model = [self infoViewModelWithKey:WMLocalizedString(@"vat_fee", @"增值税")];
        view.model.keyImage = [UIImage imageNamed:@"yn_submit_help"];
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
        view.hidden = true;
        _vatFeeView = view;
    }
    return _vatFeeView;
}

- (SAInfoView *)packingFeeView {
    if (!_packingFeeView) {
        SAInfoView *view = SAInfoView.new;
        view.model = [self infoViewModelWithKey:WMLocalizedString(@"packing_fee", @"包装费")];
        view.hidden = true;
        _packingFeeView = view;
    }
    return _packingFeeView;
}

- (SAInfoView *)deliveryFeeView {
    if (!_deliveryFeeView) {
        SAInfoView *view = SAInfoView.new;
        view.model = [self infoViewModelWithKey:WMLocalizedString(@"delivery_fee", @"配送费")];
        view.hidden = true;
        view.model.keyImage = [UIImage imageNamed:@"yn_submit_help"];
        view.model.clickedKeyButtonHandler = ^{
            WMTipAlertView *view = [[WMTipAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealWidth(100))];
            view.tip = WMLocalizedString(@"wm_submit_order_delevery_tip", @"配送费受配送距离");
            [view layoutyImmediately];
            WMCustomViewActionView *actionView = [WMCustomViewActionView actionViewWithContentView:view block:^(HDCustomViewActionViewConfig *_Nullable config) {
                config.title = WMLocalizedString(@"notice", @"提示");
                config.containerMinHeight = kRealWidth(28);
            }];
            [actionView show];
        };
        _deliveryFeeView = view;
    }
    return _deliveryFeeView;
}

- (SAInfoView *)couponView {
    if (!_couponView) {
        SAInfoView *view = SAInfoView.new;
        view.model = [self infoViewModelWithKey:WMLocalizedString(@"order_sumit_coupon", @"优惠券")];
        view.model.valueColor = HDAppTheme.WMColor.mainRed;
        view.model.keyImage = [UIImage imageNamed:@"yn_submit_help"];
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
        _couponView = view;
    }
    return _couponView;
}

- (SAInfoView *)freightView {
    if (!_freightView) {
        SAInfoView *view = SAInfoView.new;
        view.model = [self infoViewModelWithKey:WMLocalizedString(@"wm_delivery_fee_coupon", @"运费券")];
        view.model.valueColor = HDAppTheme.WMColor.mainRed;
        _freightView = view;
    }
    return _freightView;
}

- (SAInfoView *)promoCodeView {
    if (!_promoCodeView) {
        SAInfoView *view = SAInfoView.new;
        view.model = [self infoViewModelWithKey:WMLocalizedString(@"OkaO8L5F", @"promo code")];
        view.model.valueColor = HDAppTheme.WMColor.mainRed;
        view.hidden = true;
        view.model.keyImage = [UIImage imageNamed:@"yn_submit_help"];
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
        _promoCodeView = view;
    }
    return _promoCodeView;
}

- (WMOrderSubmitPromotionItemView *)lessFeeView {
    if (!_lessFeeView) {
        _lessFeeView = [[WMOrderSubmitPromotionItemView alloc] init];
        _lessFeeView.marketingType = WMStorePromotionMarketingTypeDiscount;
        _lessFeeView.from = 2;
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
        _offFeeView.marketingType = WMStorePromotionMarketingTypeLabber;
        _offFeeView.from = 2;
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
        _firstFeeView.marketingType = WMStorePromotionMarketingTypeFirst;
        _firstFeeView.from = 2;
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
        _couponFeeView.marketingType = WMStorePromotionMarketingTypeCoupon;
        _couponFeeView.from = 2;
        _couponFeeView.hidden = YES;
    }
    return _couponFeeView;
}

- (SAInfoView *)subTotalMoneyView {
    if (!_subTotalMoneyView) {
        SAInfoView *view = SAInfoView.new;
        view.model = [self infoViewModelWithKey:WMLocalizedString(@"sub_total", @"小计")];
        view.model.keyFont = [HDAppTheme.WMFont wm_boldForSize:14];
        view.model.keyColor = HDAppTheme.WMColor.B3;
        view.model.valueFont = [HDAppTheme.WMFont wm_ForSize:14 fontName:@"DINPro-Bold"];
        view.model.valueColor = HDAppTheme.WMColor.mainRed;
        view.hidden = true;
        [view setNeedsUpdateContent];
        _subTotalMoneyView = view;
    }
    return _subTotalMoneyView;
}

- (SAInfoView *)totalMoneyView {
    if (!_totalMoneyView) {
        SAInfoView *view = SAInfoView.new;
        view.model = [self infoViewModelWithKey:nil];
        view.model.lineWidth = 0;
        view.model.valueColor = HDAppTheme.WMColor.B3;
        view.hidden = true;
        _totalMoneyView = view;
    }
    return _totalMoneyView;
}

- (SAInfoView *)totalDiscountView {
    if (!_totalDiscountView) {
        SAInfoView *view = SAInfoView.new;
        view.model = [self infoViewModelWithKey:nil];
        view.model.lineWidth = 0;
        view.model.keyText = WMLocalizedString(@"wm_submit_discount", @"Total discount");
        view.model.keyColor = HDAppTheme.WMColor.B3;
        view.model.valueColor = HDAppTheme.WMColor.mainRed;
        view.model.valueFont = [HDAppTheme.WMFont wm_ForSize:16 fontName:@"DINPro-Bold"];
        view.hidden = true;
        _totalDiscountView = view;
    }
    return _totalDiscountView;
}

- (SAInfoView *)exchangeRateView {
    if (!_exchangeRateView) {
        SAInfoView *view = SAInfoView.new;
        view.model = [self infoViewModelWithKey:nil];
        view.model.contentEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(12), kRealWidth(12), kRealWidth(12));
        view.model.valueColor = HDAppTheme.WMColor.B9;
        view.model.valueFont = [HDAppTheme.WMFont wm_ForSize:11];
        view.hidden = true;
        _exchangeRateView = view;
    }
    return _exchangeRateView;
}

- (SAInfoView *)paymentDiscountView {
    if (!_paymentDiscountView) {
        SAInfoView *view = SAInfoView.new;
        view.model = [self infoViewModelWithKey:SALocalizedString(@"payment_coupon", @"支付优惠")];
        view.model.contentEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(12), kRealWidth(4), kRealWidth(12));
        view.model.valueColor = HDAppTheme.WMColor.mainRed;
        view.model.lineWidth = 0;
        view.hidden = true;
        _paymentDiscountView = view;
    }
    return _paymentDiscountView;
}

- (SAInfoView *)actuallyPaidAmountView {
    if (!_actuallyPaidAmountView) {
        SAInfoView *view = SAInfoView.new;
        view.model = [self infoViewModelWithKey:nil];
        view.model.lineWidth = 0;
        view.model.valueColor = HDAppTheme.WMColor.B3;
        view.hidden = true;
        _actuallyPaidAmountView = view;
    }
    return _actuallyPaidAmountView;
}

- (HDUIButton *)expandBTN {
    if (!_expandBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        //        button.hd_eventTimeInterval = CGFLOAT_MIN;
        [button setTitleColor:HDAppTheme.WMColor.B9 forState:UIControlStateNormal];
        [button setTitle:WMLocalizedString(@"show_all", @"展开") forState:UIControlStateNormal];
        [button setTitle:WMLocalizedString(@"hide", @"收起") forState:UIControlStateSelected];
        button.adjustsButtonWhenHighlighted = false;
        button.titleLabel.font = [HDAppTheme.WMFont wm_ForSize:14];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [button setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"arrow_up"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(clickedExpandBTNHandler:) forControlEvents:UIControlEventTouchUpInside];
        button.hidden = true;
        _expandBTN = button;
    }
    return _expandBTN;
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
    }
    return _giftsContainer;
}

- (UIView *)titleBgView {
    if (!_titleBgView) {
        _titleBgView = UIView.new;
        [_titleBgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickStoreTitleHandler)]];
    }
    return _titleBgView;
}

- (UIImageView *)arrowIV {
    if (!_arrowIV) {
        UIImageView *imageView = UIImageView.new;
        imageView.image = [UIImage imageNamed:@"yn_submit_gengd"];
        imageView.contentMode = UIViewContentModeCenter;
        _arrowIV = imageView;
    }
    return _arrowIV;
}

- (HDUIButton *)storeNaviBtn {
    if (!_storeNaviBtn) {
        _storeNaviBtn = HDUIButton.new;
        _storeNaviBtn.imagePosition = HDUIButtonImagePositionLeft;
        [_storeNaviBtn setImage:[UIImage imageNamed:@"yn_icon_daohang_s"] forState:UIControlStateNormal];
        [_storeNaviBtn setTitleColor:UIColor.sa_C333 forState:UIControlStateNormal];
        _storeNaviBtn.titleLabel.font = HDAppTheme.font.sa_standard12M;
        _storeNaviBtn.spacingBetweenImageAndTitle = 1;
        [_storeNaviBtn setTitle:WMLocalizedString(@"wm_pickup_Navigation", @"导航") forState:UIControlStateNormal];
        @HDWeakify(self);
        [_storeNaviBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            //导航
            @HDStrongify(self);
            [GNAlertUntils navigation:self.model.merchantStoreDetail.address lat:self.model.merchantStoreDetail.latitude.doubleValue lon:self.model.merchantStoreDetail.longitude.doubleValue];
        }];
        _storeNaviBtn.hidden = YES;
    }
    return _storeNaviBtn;
}


- (SAInfoView *)fullGiftView {
    if (!_fullGiftView) {
        SAInfoView *view = SAInfoView.new;
        view.model = [self infoViewModelWithKey:WMLocalizedString(@"wm_gift_free_item", @"【赠品】")];
        view.model.keyFont = [HDAppTheme.WMFont wm_ForSize:14];
        view.model.keyColor = HDAppTheme.WMColor.B3;
        view.model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(16), kRealWidth(12), kRealWidth(14), kRealWidth(12));
        view.hidden = true;
        [view setNeedsUpdateContent];
        _fullGiftView = view;
    }
    return _fullGiftView;
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
    [HDMediator.sharedInstance navigaveToWebViewViewController:@{@"path": @"/mobile-h5/marketing/slow-pay"}];
}

- (UIImageView *)slowPayIcon {
    if (!_slowPayIcon) {
        _slowPayIcon = UIImageView.new;
        _slowPayIcon.image = [UIImage imageNamed:@"yn_submit_help"];
    }
    return _slowPayIcon;
}

@end
