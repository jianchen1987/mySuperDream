//
//  WMStoreDetailPromotionModel.m
//  SuperApp
//
//  Created by Chaos on 2020/6/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreDetailPromotionModel.h"
#import "SAMoneyModel.h"
#import "SAView.h"
#import "WMPromotionLabel.h"


@interface WMStoreDetailPromotionModel ()
/// 折扣描述
@property (nonatomic, copy) NSString *discountRadioStr;
@end


@implementation WMStoreDetailPromotionModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"ladderRules": WMStoreLadderRuleModel.class,
        @"activityContentResps": WMStoreFillGiftRuleModel.class,
    };
}

+ (NSArray<WMUIButton *> *)configPromotions:(NSArray *)promotions productPromotion:(nullable NSArray *)productPromotion hasFastService:(BOOL)hasFastService shouldAddStoreCoupon:(BOOL)shouldAdd {
    return [self configPromotions:promotions productPromotion:productPromotion hasFastService:hasFastService shouldAddStoreCoupon:shouldAdd newStyle:NO];
}

+ (NSArray<WMUIButton *> *)configPromotions:(NSArray *)promotions
                           productPromotion:(nullable NSArray *)productPromotion
                             hasFastService:(BOOL)hasFastService
                       shouldAddStoreCoupon:(BOOL)shouldAdd
                                   newStyle:(BOOL)newStyle {
    NSMutableArray *btnArray = [NSMutableArray array];
    if (!HDIsArrayEmpty(productPromotion)) {
        [productPromotion enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            if (newStyle) {
                [btnArray addObject:[self createBtnWithTitle:obj]];
            } else {
                [btnArray addObject:[self createBtnWithBackGroundColor:HDAppTheme.WMColor.bg3 titleColor:HDAppTheme.WMColor.mainRed title:obj alpha:1 border:HDAppTheme.WMColor.mainRed]];
            }
        }];
    }
    if (hasFastService) {
        if (newStyle) {
            [btnArray addObject:[WMPromotionLabel createFastServiceBtnWithNewStyle]];
        } else {
            [btnArray addObject:[WMPromotionLabel createFastServiceBtn]];
        }
    }
    if (!HDIsArrayEmpty(promotions)) {
        __block BOOL hadWMStorePromotionMarketingTypePromoCode = NO;
        [promotions enumerateObjectsUsingBlock:^(WMStoreDetailPromotionModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            switch (obj.marketingType) {
                case WMStorePromotionMarketingTypeDiscount: {
                    if (obj.discountRatio > 0) {
                        NSString *showText = nil;
                        if (SAMultiLanguageManager.isCurrentLanguageCN) {
                            showText = [NSString stringWithFormat:WMLocalizedString(@"store_discount", @"%@折"), obj.discountRadioStr];
                        } else {
                            showText = [NSString stringWithFormat:WMLocalizedString(@"store_discount", @"%.0f%%off"), obj.discountRatio.doubleValue];
                        }
                        if (!HDIsStringEmpty(showText)) {
                            if (newStyle) {
                                [btnArray addObject:[self createBtnWithTitle:showText]];
                            } else {
                                [btnArray addObject:[self createBtnWithBackGroundColor:HDAppTheme.WMColor.bg3 titleColor:HDAppTheme.WMColor.mainRed title:showText alpha:1
                                                                                border:HDAppTheme.WMColor.mainRed]];
                            }
                        }
                    }
                } break;
                case WMStorePromotionMarketingTypeLabber:
                case WMStorePromotionMarketingTypeStoreLabber: {
                    WMStoreLadderRuleModel *firstLadder = obj.ladderRules.firstObject;
                    if (!HDIsArrayEmpty(obj.ladderRules)) {
                        NSString *labber = [NSString stringWithFormat:WMLocalizedString(@"store_money_off_content", @"满%@减%@ "),
                                                                      firstLadder.thresholdAmt.thousandSeparatorAmount,
                                                                      firstLadder.discountAmt.thousandSeparatorAmount];
                        if (HDIsStringNotEmpty(labber)) {
                            if (newStyle) {
                                [btnArray addObject:[self createBtnWithTitle:labber]];
                            } else {
                                [btnArray addObject:[self createBtnWithBackGroundColor:HDAppTheme.WMColor.bg3 titleColor:HDAppTheme.WMColor.mainRed title:labber alpha:1
                                                                                border:HDAppTheme.WMColor.mainRed]];
                            }
                        }
                    }
                } break;
                case WMStorePromotionMarketingTypeDelievry: {
                    //                    double cent = 0;
                    //                    if (!HDIsArrayEmpty(obj.ladderRules)) {
                    //                        NSArray *proArr = [obj.ladderRules hd_filterWithBlock:^BOOL(WMStoreLadderRuleModel *_Nonnull item) {
                    //                            return item.preferentialRatio > 0;
                    //                        }];
                    //                        if (proArr.count > 0) {
                    //                            ///占位为减
                    //                            cent = 1;
                    //                            for (WMStoreLadderRuleModel *ladderModel in proArr) {
                    //                                if (ladderModel.preferentialRatio == 100) {
                    //                                    cent = 0;
                    //                                }
                    //                            }
                    //                        } else {
                    //                            cent = obj.ladderRules.firstObject.discountAmt.cent.doubleValue;
                    //                        }
                    //                    }
                    //                    NSString *title = (cent > 0) ? WMLocalizedString(@"wm_free_fee", @"减配送费") : WMLocalizedString(@"free_delivery", @"免配送费");
                    BOOL free = YES;
                    if (!HDIsArrayEmpty(obj.ladderRules)) {
                        NSArray *proArr = [obj.ladderRules hd_filterWithBlock:^BOOL(WMStoreLadderRuleModel *_Nonnull item) {
                            return item.preferentialRatio > 0;
                        }];
                        if (proArr.count) {
                            for (WMStoreLadderRuleModel *item in proArr) {
                                if (item.preferentialRatio != 100) {
                                    free = NO;
                                    break;
                                } else if (item.preferentialRatio == 100) {
                                    free = YES;
                                }
                            }
                        } else {
                            free = obj.ladderRules.firstObject.discountAmt.cent.doubleValue <= 0;
                        }
                    }
                    NSString *title = !free ? WMLocalizedString(@"wm_free_fee", @"减配送费") : WMLocalizedString(@"wm_free_delivery", @"减免配送费");
                    if (newStyle) {
                        [btnArray addObject:[self createBtnWithTitle:title]];
                    } else {
                        [btnArray addObject:[self createBtnWithBackGroundColor:HDAppTheme.WMColor.bg3 titleColor:HDAppTheme.WMColor.mainRed title:title alpha:1 border:HDAppTheme.WMColor.mainRed]];
                    }
                } break;
                case WMStorePromotionMarketingTypeFirst: {
                    NSString *showTips = [NSString stringWithFormat:WMLocalizedString(@"off_first_order", @"%@ Off 1st Order"), obj.firstOrderReductionAmount.thousandSeparatorAmount];
                    if (newStyle) {
                        [btnArray addObject:[self createBtnWithTitle:showTips]];
                    } else {
                        [btnArray addObject:[self createBtnWithBackGroundColor:HDAppTheme.WMColor.bg3 titleColor:HDAppTheme.WMColor.mainRed title:showTips alpha:1 border:HDAppTheme.WMColor.mainRed]];
                    }
                } break;
                case WMStorePromotionMarketingTypeCoupon: {
                    if (obj.isStoreCoupon && !HDIsArrayEmpty(obj.storeCouponActivitys.coupons)) {
                        if (shouldAdd) {
                            if (newStyle) {
                                [btnArray addObject:[self createBtnWithTitle:WMLocalizedString(@"wm_get_storecoupon", @"领取门店优惠券")]];
                            } else {
                                [btnArray addObject:[self createBtnWithBackGroundColor:HDAppTheme.WMColor.bg3 titleColor:HDAppTheme.WMColor.mainRed
                                                                                 title:WMLocalizedString(@"wm_get_storecoupon", @"领取门店优惠券")
                                                                                 alpha:1
                                                                                border:HDAppTheme.WMColor.mainRed]];
                            }
                        }
                    } else {
                        [obj.ladderRules enumerateObjectsUsingBlock:^(WMStoreLadderRuleModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                            NSString *labber = @"";
                            labber = [NSString
                                stringWithFormat:WMLocalizedString(@"store_money_off_content", @"满%@减%@ "), obj.thresholdAmt.thousandSeparatorAmount, obj.discountAmt.thousandSeparatorAmount];

                            if (HDIsStringNotEmpty(labber)) {
                                if (newStyle) {
                                    [btnArray addObject:[self createBtnWithTitle:labber]];
                                } else {
                                    [btnArray addObject:[self createBtnWithBackGroundColor:HDAppTheme.WMColor.bg3 titleColor:HDAppTheme.WMColor.mainRed title:labber alpha:1
                                                                                    border:HDAppTheme.WMColor.mainRed]];
                                }
                            }
                        }];
                    }
                } break;
                case WMStorePromotionMarketingTypeFillGift: {
                    NSString *showTips = obj.title;
                    if (newStyle) {
                        [btnArray addObject:[self createBtnWithTitle:showTips]];
                    } else {
                        [btnArray addObject:[self createBtnWithBackGroundColor:HDAppTheme.WMColor.bg3 titleColor:HDAppTheme.WMColor.mainRed title:showTips alpha:1 border:HDAppTheme.WMColor.mainRed]];
                    }
                } break;
                case WMStorePromotionMarketingTypePromoCode: {
                    if (!hadWMStorePromotionMarketingTypePromoCode) {
                        NSString *showTips = WMLocalizedString(@"wm_use_promo_code", @"可使用优惠码");
                        if (newStyle) {
                            [btnArray addObject:[self createBtnWithTitle:showTips]];
                        } else {
                            [btnArray addObject:[self createBtnWithBackGroundColor:HDAppTheme.WMColor.bg3 titleColor:HDAppTheme.WMColor.mainRed title:showTips alpha:1
                                                                            border:HDAppTheme.WMColor.mainRed]];
                        }
                        hadWMStorePromotionMarketingTypePromoCode = YES;
                    }
                } break;
                case WMStorePromotionMarketingTypeBestSale: {
                    NSString *showTips = obj.title;
                    if (newStyle) {
                        [btnArray addObject:[self createBtnWithTitle:showTips]];
                    } else {
                        [btnArray addObject:[self createBtnWithBackGroundColor:HDAppTheme.WMColor.bg3 titleColor:HDAppTheme.WMColor.mainRed title:showTips alpha:1 border:HDAppTheme.WMColor.mainRed]];
                    }
                } break;

                case WMStorePromotionMarketingTypeProductPromotions: {
                    NSString *showTips = obj.title;
                    if (newStyle) {
                        [btnArray addObject:[self createBtnWithTitle:showTips]];
                    } else {
                        [btnArray addObject:[self createBtnWithBackGroundColor:HDAppTheme.WMColor.bg3 titleColor:HDAppTheme.WMColor.mainRed title:showTips alpha:1 border:HDAppTheme.WMColor.mainRed]];
                    }
                } break;

                case WMStorePromotionMarketingTypePlatform: {
                    NSString *showTips = obj.title;
                    if (newStyle) {
                        [btnArray addObject:[self createBtnWithTitle:showTips]];
                    } else {
                        [btnArray addObject:[self createBtnWithBackGroundColor:HDAppTheme.WMColor.bg3 titleColor:HDAppTheme.WMColor.mainRed title:showTips alpha:1 border:HDAppTheme.WMColor.mainRed]];
                    }
                } break;
                default:
                    break;
            }
        }];
    }
    return btnArray.copy;
}

+ (NSArray<WMUIButton *> *)configNewPromotions:(NSArray *)promotions productPromotion:(nullable NSArray *)productPromotion hasFastService:(BOOL)hasFastService shouldAddStoreCoupon:(BOOL)shouldAdd {
    return [self configNewPromotions:promotions productPromotion:productPromotion hasFastService:hasFastService shouldAddStoreCoupon:shouldAdd newStyle:NO];
}

+ (NSArray<WMUIButton *> *)configNewPromotions:(NSArray *)promotions
                              productPromotion:(nullable NSArray *)productPromotion
                                hasFastService:(BOOL)hasFastService
                          shouldAddStoreCoupon:(BOOL)shouldAdd
                                      newStyle:(BOOL)newStyle {
    NSMutableArray *btnArray = [NSMutableArray array];
    if (!HDIsArrayEmpty(productPromotion)) {
        [productPromotion enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            if (newStyle) {
                [btnArray addObject:[self createBtnWithTitle:obj]];
            } else {
                [btnArray addObject:[self createBtnWithBackGroundColor:HDAppTheme.WMColor.bg3 titleColor:HDAppTheme.WMColor.mainRed title:obj alpha:1 border:HDAppTheme.WMColor.mainRed]];
            }
        }];
    }
    if (hasFastService) {
        if (newStyle) {
            [btnArray addObject:[WMPromotionLabel createFastServiceBtnWithNewStyle]];
        } else {
            [btnArray addObject:[WMPromotionLabel createFastServiceBtn]];
        }
    }
    if (!HDIsArrayEmpty(promotions)) {
        for (NSString *str in promotions) {
            if(HDIsStringNotEmpty(str)) {
                if (newStyle) {
                    [btnArray addObject:[self createBtnWithTitle:str]];
                } else {
                    [btnArray addObject:[self createBtnWithBackGroundColor:HDAppTheme.WMColor.bg3 titleColor:HDAppTheme.WMColor.mainRed title:str alpha:1
                                                                    border:HDAppTheme.WMColor.mainRed]];
                }
            }
        }
    }
    return btnArray.copy;
}


+ (NSArray<WMUIButton *> *)configPromotions:(NSArray *)promotions productPromotion:(nullable NSArray *)productPromotion hasFastService:(BOOL)hasFastService {
    return [self configPromotions:promotions productPromotion:productPromotion hasFastService:hasFastService shouldAddStoreCoupon:YES];
}

+ (NSArray<WMUIButton *> *)configNewPromotions:(NSArray<NSString *>*)promotions productPromotion:(nullable NSArray *)productPromotion hasFastService:(BOOL)hasFastService {
    return [self configNewPromotions:promotions productPromotion:productPromotion hasFastService:hasFastService shouldAddStoreCoupon:YES];
}

+ (WMUIButton *)createBtnWithBackGroundColor:(UIColor *)bgColor titleColor:(UIColor *)titleColor title:(NSString *)title alpha:(CGFloat)alpha {
    return [WMPromotionLabel createBtnWithBackGroundColor:bgColor titleColor:titleColor title:title alpha:alpha];
}

+ (WMUIButton *)createBtnWithBackGroundColor:(UIColor *)bgColor titleColor:(UIColor *)titleColor title:(NSString *)title alpha:(CGFloat)alpha border:(nullable UIColor *)borderColor {
    return [WMPromotionLabel createBtnWithBackGroundColor:bgColor titleColor:titleColor title:title alpha:alpha border:borderColor];
}

+ (NSArray<WMUIButton *> *)configserviceLabel:(NSArray *)serviceLabel {
    return [self configserviceLabel:serviceLabel newStyle:NO];
}

+ (WMUIButton *)createBtnWithTitle:(NSString *)title {
    return [WMPromotionLabel createBtnWithTitle:title];
}

+ (NSArray<WMUIButton *> *)configserviceLabel:(NSArray *)serviceLabel newStyle:(BOOL)newStyle {
    if (!serviceLabel.count)
        return nil;
    NSMutableArray *btnArray = [NSMutableArray array];
    for (NSString *str in serviceLabel) {
        if ([str isKindOfClass:NSString.class] && str.length) {
            if (newStyle) {
                [btnArray addObject:[self createBtnWithTitle:str]];
            } else {
                [btnArray addObject:[self createBtnWithBackGroundColor:HDAppTheme.WMColor.bg3 titleColor:HDAppTheme.WMColor.mainRed title:str alpha:1 border:HDAppTheme.WMColor.mainRed]];
            }
        }
    }
    return btnArray;
}

- (NSString *)promotionDesc {
    NSString *desc = @"";
    switch (self.marketingType) {
        case WMStorePromotionMarketingTypeDiscount: {
            if (self.discountRatio > 0) {
                if (WMMultiLanguageManager.isCurrentLanguageCN) {
                    desc = [NSString stringWithFormat:WMLocalizedString(@"store_discount", @"%@折"), self.discountRadioStr];
                } else {
                    desc = [NSString stringWithFormat:WMLocalizedString(@"store_discount", @"%.0f%%off"), self.discountRatio.doubleValue];
                }
            }
        } break;

        case WMStorePromotionMarketingTypeLabber:
        case WMStorePromotionMarketingTypeStoreLabber:
        case WMStorePromotionMarketingTypeCoupon: {
            __block NSMutableString *ladderRules = [NSMutableString string];
            [self.ladderRules enumerateObjectsUsingBlock:^(WMStoreLadderRuleModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                NSString *thresholdAmtStr = obj.thresholdAmt.thousandSeparatorAmount;
                NSString *discountAmtStr = obj.discountAmt.thousandSeparatorAmount;
                NSString *labber;
                labber = [NSString stringWithFormat:WMLocalizedString(@"store_money_off_content", @"满%@减%@ "), thresholdAmtStr, discountAmtStr];
            }];
            if (ladderRules.length) {
                desc = ladderRules;
            }
        } break;
        case WMStorePromotionMarketingTypeDelievry:
            desc = WMLocalizedString(@"free_delivery", @"Free delivery");
            break;
        case WMStorePromotionMarketingTypeFirst:
            desc = [NSString stringWithFormat:WMLocalizedString(@"off_first_order", @"%@ Off 1st Order"), self.firstOrderReductionAmount.thousandSeparatorAmount];
            break;
        case WMStorePromotionMarketingTypeProductPromotions:
            desc = self.title;
            break;
        case WMStorePromotionMarketingTypeBestSale:
            desc = self.title;
            break;
        case WMStorePromotionMarketingTypeFillGift:
            desc = self.title;
            break;
        case WMStorePromotionMarketingTypePromoCode:
            desc = self.title;
            break;
        case WMStorePromotionMarketingTypePlatform:
            desc = self.title;
            break;
    }
    return desc;
}

- (void)setDiscountRatio:(NSNumber *)discountRatio {
    _discountRatio = discountRatio;

    NSNumber *discountRatioCent = [NSNumber numberWithDouble:(100 - discountRatio.doubleValue) / 10.0];
    if (discountRatioCent.integerValue != discountRatioCent.doubleValue) {
        // 判断小数位数
        NSString *stringValue = discountRatioCent.stringValue;
        if ([stringValue rangeOfString:@"."].location != NSNotFound) {
            NSArray<NSString *> *subStrArr = [stringValue componentsSeparatedByString:@"."];
            if (subStrArr.count >= 1) {
                NSString *pointStr = subStrArr[1];
                if (pointStr.length == 1) {
                    _discountRadioStr = [NSString stringWithFormat:@"%.1f", discountRatioCent.doubleValue];
                } else {
                    // 最多两位
                    _discountRadioStr = [NSString stringWithFormat:@"%.2f", discountRatioCent.doubleValue];
                }
            } else {
                _discountRadioStr = [NSString stringWithFormat:@"%zd", discountRatioCent.integerValue];
            }
        }
    } else {
        _discountRadioStr = [NSString stringWithFormat:@"%zd", discountRatioCent.integerValue];
    }
}

- (NSString *)openingTimes {
    if (!_openingTimes) {
        _openingTimes = @"";
    }
    return _openingTimes;
}

- (WMStoreLadderRuleModel *)inUseLadderRuleModel {
    if (self.marketingType != WMStorePromotionMarketingTypeLabber && self.marketingType != WMStorePromotionMarketingTypeStoreLabber && self.marketingType != WMStorePromotionMarketingTypeCoupon) {
        return nil;
    }

    WMStoreLadderRuleModel *inUseLadderRuleModel;
    for (WMStoreLadderRuleModel *ladderRuleModel in self.ladderRules) {
        //        if (ladderRuleModel.inUse) {
        inUseLadderRuleModel = ladderRuleModel;
        //            break;
        //        }
    }
    return inUseLadderRuleModel;
}
@end
