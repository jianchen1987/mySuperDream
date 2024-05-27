//
//  WMShoppingItemsPayFeeTrialCalRspModel.m
//  SuperApp
//
//  Created by VanJay on 2020/5/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMShoppingItemsPayFeeTrialCalRspModel.h"
#import <HDKitCore/HDKitCore.h>


@implementation WMShoppingItemsPayFeeTrialCalRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"products": WMShoppingCartPayFeeCalProductModel.class, @"promotions": WMStoreDetailPromotionModel.class};
}

- (SAMoneyModel *)originalPrice {
    // 计算原价和优惠价（都包含打包费），优惠价是减去优惠后的价格
    SAMoneyModel *originalPrice = SAMoneyModel.new;
    originalPrice.cy = self.totalAmount.cy;
    long originalMoneyCent = self.packageFee.cent.integerValue;
    for (WMShoppingCartPayFeeCalProductModel *productModel in self.products) {
        originalMoneyCent += (productModel.salePrice.cent.integerValue * productModel.count);
    }
    originalPrice.cent = [NSString stringWithFormat:@"%zd", originalMoneyCent];
    return originalPrice;
}

- (SAMoneyModel *)showPrice {
    if (self.promotionMoney.cent.integerValue == 0) {
        return self.originalPrice;
    }
    //    如果有优惠就减去优惠价格，不包括减配送费优惠类型
    SAMoneyModel *promotionMoney = self.promotionMoney;
    long discountMoneyCent = self.originalPrice.cent.integerValue;
    if (promotionMoney && promotionMoney.cent.integerValue != 0) {
        discountMoneyCent -= promotionMoney.cent.integerValue;
    }

    SAMoneyModel *discountPrice = SAMoneyModel.new;
    discountPrice.cy = self.originalPrice.cy;
    discountPrice.cent = [NSString stringWithFormat:@"%zd", discountMoneyCent];
    return discountPrice;
}

- (SAMoneyModel *)linePrice {
    if (self.promotionMoney.cent.integerValue != 0) {
        return self.originalPrice;
    }
    return nil;
}

#pragma mark - private methods
- (SAMoneyModel *)promotionMoney {
    SAMoneyModel *promotionMoney = SAMoneyModel.new;
    // 过滤减配送费的活动
    NSArray<WMStoreDetailPromotionModel *> *noneReduceDeliveryPromotions = [self.promotions hd_filterWithBlock:^BOOL(WMStoreDetailPromotionModel *_Nonnull item) {
        return item.marketingType != WMStorePromotionMarketingTypeDelievry;
    }];

    // 计算全部活动加起来的金额，1.6.0支持多活动
    long currentMoney = 0;
    // 爆款商品活动不与平台折扣/平台满减/门店满减同享
    if (self.freeBestSaleDiscountAmount.cent.integerValue != 0) {
        promotionMoney.cy = self.freeBestSaleDiscountAmount.cy;
        currentMoney += self.freeBestSaleDiscountAmount.cent.doubleValue;
    } else {
        for (WMStoreDetailPromotionModel *obj in noneReduceDeliveryPromotions) {
            if (obj.marketingType == WMStorePromotionMarketingTypeDiscount) {
                // 取折扣减免金额
                promotionMoney.cy = self.freeDiscountAmount.cy;
                currentMoney += self.freeDiscountAmount.cent.doubleValue;
            } else if (obj.marketingType == WMStorePromotionMarketingTypeLabber || obj.marketingType == WMStorePromotionMarketingTypeStoreLabber) {
                WMStoreLadderRuleModel *inUseLadderRuleModel = obj.inUseLadderRuleModel;
                if (inUseLadderRuleModel) {
                    // 取满减减免金额
                    promotionMoney.cy = self.freeFullReductionAmount.cy;
                    currentMoney += self.freeFullReductionAmount.cent.doubleValue;
                }
            } else if (obj.marketingType == WMStorePromotionMarketingTypeCoupon) {
                WMStoreLadderRuleModel *inUseLadderRuleModel = obj.inUseLadderRuleModel;
                if (inUseLadderRuleModel) {
                    // 取满减减免金额
                    promotionMoney.cy = self.freeFullReductionAmount.cy;
                    currentMoney += self.freeFullReductionAmount.cent.doubleValue;
                }
            }
        }
    }
    if (self.freeProductDiscountAmount) {
        promotionMoney.cy = self.freeProductDiscountAmount.cy;
        currentMoney += self.freeProductDiscountAmount.cent.doubleValue;
    }
    promotionMoney.cent = [NSString stringWithFormat:@"%zd", currentMoney];
    return promotionMoney;
}
@end
