//
//  TNGoodSpecsAndSkusModel.m
//  SuperApp
//
//  Created by 张杰 on 2022/6/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNGoodInfoModel.h"
#import "TNProductSkuModel.h"
#import "TNProductSpecificationModel.h"


@implementation TNGoodInfoModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"showPurchaseTipsStore": @[@"storeTips"]};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"skus": [TNProductSkuModel class], @"specs": [TNProductSpecificationModel class]};
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
@end
