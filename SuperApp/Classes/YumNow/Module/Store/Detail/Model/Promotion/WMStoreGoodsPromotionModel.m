//
//  WMStoreGoodsPromotionModel.m
//  SuperApp
//
//  Created by Chaos on 2020/9/10.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreGoodsPromotionModel.h"
#import "HDAppTheme+YumNow.h"
#import "WMPromotionLabel.h"


@implementation WMStoreGoodsPromotionModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"type": @"limitType", @"mode": @"discountMode"};
}

+ (NSArray<WMUIButton *> *)configProductPromotions:(WMStoreGoodsPromotionModel *)productPromotions backGroundColor:(nullable UIColor *)bgColor {
    NSMutableArray<WMUIButton *> *btnArray = [NSMutableArray array];
    if (HDIsObjectNil(productPromotions)) {
        return btnArray.copy;
    }
    WMStoreGoodsPromotionModel *model = productPromotions;

    if (model.type == WMStoreGoodsPromotionLimitTypeBestSale) {
        [btnArray addObject:[WMPromotionLabel createBtnWithBackGroundColor:bgColor titleColor:HDAppTheme.WMColor.mainRed title:[self preferentialLabelTextWithProductPromotions:productPromotions]
                                                                     alpha:1
                                                                    border:HDAppTheme.WMColor.mainRed]];
    } else {
        [btnArray addObject:[WMPromotionLabel createBtnWithBackGroundColor:bgColor titleColor:HDAppTheme.WMColor.mainRed title:[self preferentialLabelTextWithProductPromotions:productPromotions]
                                                                     alpha:1
                                                                    border:HDAppTheme.WMColor.mainRed]];
        if (model.type != WMStoreGoodsPromotionLimitTypeNone) {
            NSString *title = nil;
            if (model.type == WMStoreGoodsPromotionLimitTypeDayProNum) {
                title = [NSString stringWithFormat:WMLocalizedString(@"wm_items_off_per_day_only", @"每日限 %zd 份优惠"), model.limitValue];
            } else {
                if (model.type != WMStoreGoodsPromotionLimitTypeActivityTotalNum) {
                    title = [NSString stringWithFormat:WMLocalizedString(@"K08ZBMsK1", @"%zd items off per order only"), model.limitValue];
                }
            }
            if (title)
                [btnArray addObject:[WMPromotionLabel createBtnWithBackGroundColor:bgColor titleColor:HDAppTheme.WMColor.mainRed title:title alpha:1 border:HDAppTheme.WMColor.mainRed]];
        }
    }

    return btnArray.copy;
}

+ (NSArray<WMUIButton *> *)configProductPromotions:(WMStoreGoodsPromotionModel *)productPromotions {
    return [self configProductPromotions:productPromotions backGroundColor:HDAppTheme.WMColor.bg3];
}

+ (SAMoneyModel *)calculateShowPriceWithProductPromotions:(WMStoreGoodsPromotionModel *)productPromotions salePrice:(SAMoneyModel *)salePrice {
    if (HDIsObjectNil(productPromotions)) {
        return salePrice;
    }
    WMStoreGoodsPromotionModel *productPromotion = productPromotions;
    if (productPromotion.type == WMStoreGoodsPromotionLimitTypeBestSale) {
        return salePrice;
    }
    SAMoneyModel *model = salePrice.copy;
    long money = model.cent.integerValue;

    switch (productPromotion.mode) {
        case WMStoreGoodsPromotionModeDiscount:
            money = ceilf(money * ((100 - productPromotion.value.doubleValue) / 100.0));
            break;
        case WMStoreGoodsPromotionModeSale:
            money -= productPromotion.value.doubleValue * 100;
            break;
    }
    money = MAX(0, money);
    model.cent = [NSString stringWithFormat:@"%zd", money];

    return model;
}

+ (SAMoneyModel *)calculateLinePriceWithProductPromotions:(WMStoreGoodsPromotionModel *)productPromotions salePrice:(SAMoneyModel *)salePrice {
    if (HDIsObjectNil(productPromotions)) {
        return nil;
    }
    WMStoreGoodsPromotionModel *productPromotion = productPromotions;
    if (productPromotion.type == WMStoreGoodsPromotionLimitTypeBestSale) {
        return nil;
    }
    return salePrice;
}

+ (NSString *)preferentialLabelTextWithProductPromotions:(WMStoreGoodsPromotionModel *)productPromotions {
    if (HDIsObjectNil(productPromotions)) {
        return nil;
    }
    WMStoreGoodsPromotionModel *productPromotion = productPromotions;
    if (productPromotion.mode == WMStoreGoodsPromotionModeDiscount) {
        if (SAMultiLanguageManager.isCurrentLanguageCN) {
            //原来折扣
            NSDecimalNumber *salePrice = [NSDecimalNumber decimalNumberWithString:productPromotion.value.stringValue];
            //取整
            NSDecimalNumber *totalPrice = [NSDecimalNumber decimalNumberWithString:@"100"];
            //保留整数设置，NSRoundPlain，四舍五入，scale:0，只保留整数位，
            NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:0 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
            //除以10，确保保留一位小数
            NSDecimalNumber *valueCent = [[totalPrice decimalNumberBySubtracting:salePrice withBehavior:roundUp] decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"10"]];
            return [NSString stringWithFormat:WMLocalizedString(@"product_discount", @"%@折"), valueCent.stringValue];
        } else {
            return [NSString stringWithFormat:WMLocalizedString(@"product_discount", @"%@%% OFF"), productPromotion.value.doubleValue];
        }
    } else if (productPromotion.mode == WMStoreGoodsPromotionModeSale) {
        SAMoneyModel *moneyModel = SAMoneyModel.new;
        moneyModel.cent = [NSString stringWithFormat:@"%.2f", productPromotion.value.doubleValue * 100];
        return [NSString stringWithFormat:WMLocalizedString(@"628ZBMsK", @"$%@ OFF"), moneyModel.thousandSeparatorAmount];
    } else if (productPromotion.mode == WMStoreGoodsPromotionModeHot) {
        return WMLocalizedString(@"oQsKUL51", @"每日秒杀");
    }
    return nil;
}

+ (BOOL)isJustOverMaxStockWithProductPromotions:(WMStoreGoodsPromotionModel *)productPromotions currentCount:(NSUInteger)currentCount otherSkuCount:(NSUInteger)otherSkuCount {
    if (HDIsObjectNil(productPromotions)) {
        return NO;
    }
    WMStoreGoodsPromotionModel *productPromotion = productPromotions;
    if (productPromotion.type == WMStoreGoodsPromotionLimitTypeBestSale) {
        return NO;
    }
    if (productPromotion.type == WMStoreGoodsPromotionLimitTypeNone || productPromotion.limitValue == 0) {
        return NO;
    }

    if (currentCount + otherSkuCount == productPromotion.limitValue + 1) {
        if (productPromotion.type != WMStoreGoodsPromotionLimitTypeDayProNum && productPromotion.type != WMStoreGoodsPromotionLimitTypeActivityTotalNum) {
            [NAT showToastWithTitle:nil content:[NSString stringWithFormat:WMLocalizedString(@"668ZBMsK", @"Only %zd items can enjoy discounted prices."), productPromotion.limitValue]
                               type:HDTopToastTypeInfo];
        }
        return NO;
    } else if ((currentCount + otherSkuCount) > (productPromotion.limitValue + 1) && otherSkuCount <= productPromotion.limitValue) {
        return YES;
    }
    return NO;
}

@end
