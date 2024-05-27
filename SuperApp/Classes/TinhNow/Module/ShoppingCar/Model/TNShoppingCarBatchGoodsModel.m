//
//  TNShoppingCarBatchGoodsModel.m
//  SuperApp
//
//  Created by 张杰 on 2022/7/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNShoppingCarBatchGoodsModel.h"
#import "TNShoppingCarItemModel.h"


@implementation TNShoppingCarSkuPriceStrategyModel

@end


@implementation TNShoppingCarBatchExtendModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"priceRanges": [TNPriceRangesModel class], @"skuCatDTOList": [TNShoppingCarSkuPriceStrategyModel class]};
}
- (NSInteger)getStartQuantityBySkuId:(NSString *)skuId {
    __block NSInteger startQuantity = 0;
    if (self.quoteType == TNProductQuoteTypeNoSpecByNumber || self.quoteType == TNProductQuoteTypeHasSpecByNumber) {
        //阶梯价
        if (!HDIsArrayEmpty(self.priceRanges)) {
            TNPriceRangesModel *first = self.priceRanges.firstObject;
            startQuantity = first.startQuantity;
        }
    } else {
        //查找对应的sku 起批数
        if (!HDIsArrayEmpty(self.skuCatDTOList)) {
            [self.skuCatDTOList enumerateObjectsUsingBlock:^(TNShoppingCarSkuPriceStrategyModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                if ([obj.skuId isEqualToString:skuId]) {
                    startQuantity = obj.startQuantity;
                    *stop = YES;
                }
            }];
        }
    }
    return startQuantity;
}
- (SAMoneyModel *)getStageSalePriceByCount:(NSInteger)count {
    if (!HDIsArrayEmpty(self.priceRanges) && (self.quoteType == TNProductQuoteTypeNoSpecByNumber || self.quoteType == TNProductQuoteTypeHasSpecByNumber)) {
        __block TNPriceRangesModel *lastRangeModel = self.priceRanges.firstObject;
        [self.priceRanges enumerateObjectsUsingBlock:^(TNPriceRangesModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            if (count < obj.startQuantity) {
                *stop = YES;
            } else {
                lastRangeModel = obj;
            }
        }];
        return lastRangeModel.price;
    } else {
    }
    return nil;
}
@end


@implementation TNShoppingCarBatchGoodsModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"shopCarItems": [TNShoppingCarItemModel class]};
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"shopCarItems": @"shopCartItemDTOS"};
}

- (void)setIsSelected:(BOOL)isSelected {
    //只有没有下架才能设置
    if (self.goodsState == TNStoreItemStateOnSale) {
        _isSelected = isSelected;
    }
}
- (BOOL)isExceedTotalStartQuantity {
    BOOL bingo = YES;
    if (HDIsArrayEmpty(self.shopCarItems)) {
        return NO;
    }
    self.startQuantity = [self.productCatDTO getStartQuantityBySkuId:self.shopCarItems.firstObject.goodsSkuId];
    if (self.productCatDTO.mixWholeSale) {
        //查所有规格的购买数
        __block NSInteger count = 0;
        __block TNShoppingCarItemModel *item;
        [self.shopCarItems enumerateObjectsUsingBlock:^(TNShoppingCarItemModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            count += obj.quantity.integerValue;
            if (HDIsObjectNil(item)) {
                item = obj;
            }
        }];
        if (count < self.startQuantity) {
            bingo = NO;
        }
    }
    return bingo;
}
@end
