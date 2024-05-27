//
//  TNProductDetailsRspModel.m
//  SuperApp
//
//  Created by seeu on 2020/7/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNProductDetailsRspModel.h"
#import "TNDecimalTool.h"


@implementation TNProductDetailsRspModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"skus": [TNProductSkuModel class],
        @"specs": [TNProductSpecificationModel class],
        @"productImages": TNImageModel.class,
        @"servicesGuaranteeList": [TNProductServiceModel class],
        @"promotionList": [TNPromotionModel class],
        @"productActivityList": [TNProductActivityModel class],
        @"productDetailPublicImgDTO": [TNProductDetailPublicImg class],
    };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"freightCurrency": @"currency", @"isBuyLimitGood": @"canBuy", @"_id": @"id", @"registNewTips": @"newClientMsg", @"clientNumberMsg": @"newClientNumberMsg"};
}
- (NSString *)getPriceRange {
    SAMoneyModel *lowestMoney = nil;
    SAMoneyModel *highestMoney = nil;

    for (TNProductSkuModel *sku in self.skus) {
        if (!lowestMoney || lowestMoney.cent.integerValue > sku.price.cent.integerValue) {
            lowestMoney = sku.price;
        }
        if (!highestMoney || highestMoney.cent.integerValue < sku.price.cent.integerValue) {
            highestMoney = sku.price;
        }
    }

    if ([lowestMoney isEqual:highestMoney]) {
        return lowestMoney.thousandSeparatorAmount;
    } else {
        return [lowestMoney.thousandSeparatorAmount stringByAppendingFormat:@" - %@", highestMoney.thousandSeparatorAmount];
    }
}
- (NSNumber *)getMaxStock {
    NSNumber *maxStock = @0;
    for (TNProductSkuModel *sku in self.skus) {
        if (sku.stock.integerValue > maxStock.integerValue) {
            maxStock = sku.stock;
        }
    }
    return maxStock;
}
- (NSString *)showDisCount {
    if (HDIsObjectNil(self.price) || HDIsObjectNil(self.marketPrice)) {
        return nil;
    }
    NSString *disCount = nil;
    double price = self.price.cent.doubleValue;
    double marketPrice = self.marketPrice.cent.doubleValue;
    if (marketPrice <= 0) {
        return nil; //市场价未设置 也不显示
    }
    if (price > marketPrice) {
        return nil; //高于市场价 不计算折扣
    }
    NSDecimalNumber *disCountValue = [TNDecimalTool decimslDisCountNumber:self.price.cent num2:self.marketPrice.cent];
    if (disCountValue.doubleValue > 0.0) {
        disCount = [NSString stringWithFormat:@"-%ld%%", disCountValue.integerValue];
    }
    return disCount;
}

- (TNProductSkuModel *)getSkuModelWithKey:(NSString *)key {
    TNProductSkuModel *bingo = nil;
    for (TNProductSkuModel *skuModel in self.skus) {
        if ([skuModel.specValueKey isEqualToString:key]) {
            bingo = skuModel;
            break;
        }
    }
    return bingo;
}
- (BOOL)checkSkuSoldOutWithKey:(NSString *)key {
    BOOL bingo = YES;
    for (TNProductSkuModel *skuModel in self.skus) {
        if ([skuModel.specValueKey containsString:key] && skuModel.stock.integerValue > 0 && !skuModel.isOutOfStock) {
            bingo = NO;
            break;
        }
    }
    return bingo;
}

- (void)setSpecDefaultSku {
    if (HDIsArrayEmpty(self.skus) == NO) {
        for (TNProductSkuModel *model in self.skus) {
            if (model.isDefault == YES && model.isOutOfStock == NO) {
                //如果是默认的且有库存 就设置默认规格
                if (HDIsStringNotEmpty(model.specValueKey)) {
                    NSArray *specKeys = [model.specValueKey componentsSeparatedByString:@","];
                    for (int i = 0; i < specKeys.count; i++) {
                        NSString *key = specKeys[i];
                        if (i < self.specs.count) {
                            TNProductSpecificationModel *specModel = self.specs[i];
                            for (TNProductSpecPropertieModel *specValueModel in specModel.specValues) {
                                if ([key isEqualToString:specValueModel.propId]) {
                                    specValueModel.isDefault = YES;
                                    break;
                                }
                            }
                        }
                    }
                }
                break;
            }
        }
    }
}

@end
