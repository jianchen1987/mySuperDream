//
//  TNShoppingCarStoreModel.m
//  SuperApp
//
//  Created by seeu on 2020/7/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNShoppingCarStoreModel.h"
#import "SAMoneyModel.h"
#import "SAMoneyTools.h"
#import "TNItemModel.h"
#import "TNShoppingCarBatchGoodsModel.h"
#import "TNShoppingCarItemModel.h"


@implementation TNShoppingCarStoreModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"storeShoppingCarDisplayNo": @"merchantDisplayNo", @"shopCarItems": @"shopCartItemDTOS", @"batchShopCarItems": @"shopCartGoodsItemRspDTOS"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"shopCarItems": [TNShoppingCarItemModel class], @"batchShopCarItems": [TNShoppingCarBatchGoodsModel class]};
}

//- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
//
//    id totalPrice = [dic objectForKey:@"totalPrice"];
//    if (!HDIsObjectNil(totalPrice) && [totalPrice isKindOfClass:NSString.class]) {
//        self.totalPrice = [SAMoneyModel modelWithAmount:[SAMoneyTools yuanTofen:totalPrice] currency:@"USD"];
//    }
//
//    return YES;
//}

//- (TNShoppingCarItemModel *)getShoppingCarItemWithItem:(TNItemModel *)item {
//    __block TNShoppingCarItemModel *model = nil;
//    [self.shopCarItems enumerateObjectsUsingBlock:^(TNShoppingCarItemModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
//        if ([obj.goodsId isEqualToString:item.goodsId] && [obj.goodsSkuId isEqualToString:item.goodsSkuId]) {
//            model = obj;
//            *stop = YES;
//        }
//    }];
//
//    return model;
//}
- (NSString *)singleCalcTotalPayPriceStr {
    NSString *totalStr;
    __block NSInteger amount = 0;
    __block SACurrencyType cy;
    [self.shopCarItems enumerateObjectsUsingBlock:^(TNShoppingCarItemModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        //取第一个item 的币种
        if (idx == 0) {
            cy = obj.salePrice.cy;
        }
        if (obj.isSelected) {
            amount += (obj.salePrice.cent.integerValue * obj.quantity.integerValue);
        }
    }];
    if (amount > 0) {
        totalStr = [SAMoneyTools thousandSeparatorNoCurrencySymbolWithAmountYuan:[SAMoneyTools fenToyuan:[NSString stringWithFormat:@"%zd", amount]] currencyCode:cy];
    }
    return totalStr;
}
- (NSString *)batchCalcTotalPayPriceStr {
    NSString *totalStr;
    __block NSInteger amount = 0;
    __block SACurrencyType cy;
    [self.batchList enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([obj isKindOfClass:[TNShoppingCarItemModel class]]) {
            TNShoppingCarItemModel *item = obj;
            if (HDIsStringEmpty(cy)) {
                cy = item.salePrice.cy;
            }
            if (item.isSelected && item.goodModel.isExceedTotalStartQuantity) {
                amount += (item.salePrice.cent.integerValue * item.quantity.integerValue);
            }
        }
    }];
    if (amount > 0) {
        totalStr = [SAMoneyTools thousandSeparatorNoCurrencySymbolWithAmountYuan:[SAMoneyTools fenToyuan:[NSString stringWithFormat:@"%zd", amount]] currencyCode:cy];
    }
    return totalStr;
}
@end
