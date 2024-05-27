//
//  WMStoreShoppingCartProductCell.m
//  SuperApp
//
//  Created by Chaos on 2020/9/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreShoppingCartPromotionInfoView.h"


@interface WMStoreShoppingCartPromotionInfoView ()

/// 色块容器
@property (nonatomic, strong) UIView *topContainer;
/// 优惠信息
@property (nonatomic, strong) SALabel *promotionInfoLB;

@end


@implementation WMStoreShoppingCartPromotionInfoView

- (void)hd_setupViews {
    self.hidden = true;
    [self addSubview:self.topContainer];
    [self.topContainer addSubview:self.promotionInfoLB];

    self.topContainer.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:10];
    };
}

#pragma mark - layout
- (void)updateConstraints {
    [self.topContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.top.equalTo(self);
    }];
    [self.promotionInfoLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.topContainer).offset(-2 * kRealWidth(5));
        make.centerX.equalTo(self.topContainer);
        make.top.equalTo(self.topContainer.mas_top).offset(kRealWidth(7));
    }];

    [super updateConstraints];
}

#pragma mark - public methods
- (void)updateUIWithPayFeeTrialCalRspModel:(WMShoppingItemsPayFeeTrialCalRspModel *)payFeeTrialCalRspModel isStoreResting:(BOOL)isStoreResting {
    // 过滤减配送费的活动
    NSArray<WMStoreDetailPromotionModel *> *noneReduceDeliveryPromotions = [payFeeTrialCalRspModel.promotions hd_filterWithBlock:^BOOL(WMStoreDetailPromotionModel *_Nonnull item) {
        return item.marketingType != WMStorePromotionMarketingTypeDelievry;
    }];

    __block double money = payFeeTrialCalRspModel.freeProductDiscountAmount ? payFeeTrialCalRspModel.freeProductDiscountAmount.cent.doubleValue : 0.0;
    // 爆款商品活动不与平台折扣/平台满减/门店满减同享
    if (payFeeTrialCalRspModel.freeBestSaleDiscountAmount.cent.integerValue != 0) {
        money += payFeeTrialCalRspModel.freeBestSaleDiscountAmount.cent.integerValue;
        SAMoneyModel *model = SAMoneyModel.new;
        model.cy = payFeeTrialCalRspModel.freeBestSaleDiscountAmount.cy;
        model.cent = [NSString stringWithFormat:@"%f", money];
        NSString *moneyStr = @"";
        if (money > 0) {
            moneyStr = [NSString stringWithFormat:WMLocalizedString(@"wm_discount", @"节省%@。"), model.thousandSeparatorAmount];
        }
        self.promotionInfoLB.text = moneyStr;
        self.hidden = isStoreResting || money <= 0;
        return;
    }
    // 其他活动优惠
    if (!HDIsArrayEmpty(noneReduceDeliveryPromotions)) {
        NSMutableArray *showTipsArr = [NSMutableArray array];
        SAMoneyModel *model = SAMoneyModel.new;
        [noneReduceDeliveryPromotions enumerateObjectsUsingBlock:^(WMStoreDetailPromotionModel *_Nonnull promotionModel, NSUInteger idx, BOOL *_Nonnull stop) {
            double currentMoney = 0.0;
            if (promotionModel.marketingType == WMStorePromotionMarketingTypeDiscount) {
                model.cy = payFeeTrialCalRspModel.freeDiscountAmount.cy;
                // 取折扣减免金额
                currentMoney = payFeeTrialCalRspModel.freeDiscountAmount.cent.doubleValue;
            } else if (promotionModel.marketingType == WMStorePromotionMarketingTypeLabber || promotionModel.marketingType == WMStorePromotionMarketingTypeStoreLabber) {
                /// 平台满减
                model.cy = payFeeTrialCalRspModel.freeFullReductionAmount.cy;
                WMStoreLadderRuleModel *inUseLadderRuleModel = promotionModel.inUseLadderRuleModel;
                if (inUseLadderRuleModel) {
                    // 取满减减免金额
                    currentMoney = payFeeTrialCalRspModel.freeFullReductionAmount.cent.doubleValue;
                }
            } else if (promotionModel.marketingType == WMStorePromotionMarketingTypeCoupon) {
                /// 门店满减
                model.cy = payFeeTrialCalRspModel.freeFullReductionAmount.cy;
                WMStoreLadderRuleModel *inUseLadderRuleModel = promotionModel.inUseLadderRuleModel;
                if (inUseLadderRuleModel) {
                    // 取满减减免金额
                    currentMoney = payFeeTrialCalRspModel.freeFullReductionAmount.cent.doubleValue;
                }
            }
            money += currentMoney;

            BOOL isHidePromotions = currentMoney <= 0 && HDIsObjectNil(promotionModel.nextLadder);
            if (!isHidePromotions) {
                NSString *promotionDesc = @"";
                if (promotionModel.marketingType == WMStorePromotionMarketingTypeDiscount) {
                    // 折扣
                    // 产品2.0需求，不再显示活动描述
                    promotionDesc = @"";
                } else if (promotionModel.marketingType == WMStorePromotionMarketingTypeLabber || promotionModel.marketingType == WMStorePromotionMarketingTypeStoreLabber
                           || promotionModel.marketingType == WMStorePromotionMarketingTypeCoupon) {
                    // 平台满减&门店满减
                    WMStoreLadderRuleModel *nextLadderRuleModel = promotionModel.nextLadder;
                    if (nextLadderRuleModel) {
                        NSString *discountAmtStr = nextLadderRuleModel.discountAmt.thousandSeparatorAmount;
                        // 门槛金额 - 商品金额 - 打包费
                        NSUInteger balance
                            = nextLadderRuleModel.thresholdAmt.cent.integerValue - payFeeTrialCalRspModel.totalAmount.cent.integerValue - payFeeTrialCalRspModel.packageFee.cent.integerValue;
                        SAMoneyModel *balanceModel = [SAMoneyModel modelWithAmount:[NSString stringWithFormat:@"%zd", balance] currency:payFeeTrialCalRspModel.totalAmount.cy];
                        if (balanceModel.cent.integerValue > 0) {
                            NSString *balanceAmtStr = balanceModel.thousandSeparatorAmount;
                            promotionDesc = [NSString stringWithFormat:WMLocalizedString(@"buy_some_discount_some", @"再买%@，优惠%@。 "), balanceAmtStr, discountAmtStr];
                        }
                    } else {
                        HDLog(@"优惠类型为满减优惠，但后台未标识使用了哪个梯度优惠");
                    }
                } else if (promotionModel.marketingType == WMStorePromotionMarketingTypeDelievry) {
                    promotionDesc = [NSString stringWithFormat:@"%@", WMLocalizedString(@"wm_free_delivery", @"减免配送费")];
                } else if (promotionModel.marketingType == WMStorePromotionMarketingTypeFirst) {
                    promotionDesc = [NSString stringWithFormat:WMLocalizedString(@"off_first_order", @"%@ Off 1st Order"), payFeeTrialCalRspModel.freeFirstOrderAmount.thousandSeparatorAmount];
                } else if (promotionModel.marketingType == WMStorePromotionMarketingTypeCoupon) {
                }
                if (HDIsStringNotEmpty(promotionDesc)) {
                    [showTipsArr addObject:promotionDesc];
                }
            }
        }];
        // 需要显示下一个阶梯金额
        if (money > 0 || !HDIsArrayEmpty(showTipsArr)) {
            model.cent = [NSString stringWithFormat:@"%f", money];
            NSString *tips = [[showTipsArr mapObjectsUsingBlock:^id _Nonnull(id _Nonnull obj, NSUInteger idx) {
                return obj;
            }] componentsJoinedByString:@"，"];
            NSString *moneyStr = @"";
            if (money > 0) {
                moneyStr = [NSString stringWithFormat:WMLocalizedString(@"wm_discount", @"节省%@。"), model.thousandSeparatorAmount];
            }
            NSString *info = [NSString stringWithFormat:@"%@ %@", moneyStr, tips];
            self.promotionInfoLB.text = info;
        }
        self.hidden = isStoreResting || (money <= 0 && HDIsArrayEmpty(showTipsArr));
    } else {
        self.hidden = YES;
    }
}

#pragma mark - lazy load
- (UIView *)topContainer {
    if (!_topContainer) {
        _topContainer = UIView.new;
        _topContainer.backgroundColor = HexColor(0xFEE8EB);
    }
    return _topContainer;
}

- (SALabel *)promotionInfoLB {
    if (!_promotionInfoLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard4;
        label.textColor = HDAppTheme.color.G1;
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"Money off:20%off, Saved: $3.00";
        _promotionInfoLB = label;
    }
    return _promotionInfoLB;
}

@end
