//
//  WMStoreGoodsItem.m
//  SuperApp
//
//  Created by VanJay on 2020/5/12.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreGoodsItem.h"
#import "WMStoreDetailPromotionModel.h"
#import "WMStoreGoodsPromotionModel.h"
#import "WMStoreProductDetailRspModel.h"


@interface WMStoreGoodsItem ()
/// 当前在购物车中的数量
@property (nonatomic, assign) NSUInteger currentCountInShoppingCart;
@end


@implementation WMStoreGoodsItem
+ (instancetype)modelWithProductDetailRspModel:(WMStoreProductDetailRspModel *)productDetailRspModel {
    WMStoreGoodsItem *item = WMStoreGoodsItem.new;
    item.desc = productDetailRspModel.desc;
    item.goodId = productDetailRspModel.goodId;
    item.imagePaths = productDetailRspModel.imagePaths;
    item.menuId = productDetailRspModel.menuId;
    item.name = productDetailRspModel.name;
    item.status = productDetailRspModel.status;
    item.storeNo = productDetailRspModel.storeNo;
    item.propertyList = productDetailRspModel.propertyList;
    item.specificationList = productDetailRspModel.specificationList;
    item.skuCountModelList = productDetailRspModel.skuCountModelList;
    item.inEffectVersionId = productDetailRspModel.inEffectVersionId;
    item.availableStock = productDetailRspModel.availableStock;
    item.initStock = productDetailRspModel.initStock;
    item.packageFee = productDetailRspModel.packageFee;
    item.productPromotion = productDetailRspModel.productPromotion;
    item.bestSale = productDetailRspModel.bestSale;
//    item.discountPrice = productDetailRspModel.discountPrice;
//    item.salePrice = productDetailRspModel.salePrice;
    item.discountPrice = productDetailRspModel.discountPrice.centFace;
    item.salePrice = productDetailRspModel.salePrice.centFace;
    return item;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"descriptionEn": @"description",
        @"goodId": @"id",
        @"nameEn": @"name",
        @"status": @"shelfStatus",
        @"propertyList": @"props",
        @"specificationList": @"specs",
        @"inEffectVersionId": @"effectVersion",
        @"salePriceCent" : @"salePrice.cent",
        @"discountPriceCent" : @"discountPrice.cent",
    };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"propertyList": WMStoreGoodsProductProperty.class,
        @"specificationList": WMStoreGoodsProductSpecification.class,
        @"promotions": WMStoreDetailPromotionModel.class,
    };
}

#pragma mark - setter
- (void)setSkuCountModelList:(NSArray<WMStoreGoodsSkuCountModel *> *)skuCountModelList {
    _skuCountModelList = skuCountModelList;

    __block NSUInteger count = 0;
    [skuCountModelList enumerateObjectsUsingBlock:^(WMStoreGoodsSkuCountModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        count += obj.countInCart;
    }];
    self.currentCountInShoppingCart = count;
}
- (void)setStatusEnums:(NSArray *)statusEnums {
    _statusEnums = statusEnums;

    for (NSNumber *obj in statusEnums) {
        if (obj.integerValue == WMStoreGoodsStatusOnNewItem) {
            _isNew = YES;
            break;
        }
    }
}

- (void)setProductPromotion:(WMStoreGoodsPromotionModel *)productPromotion {
    _productPromotion = productPromotion;
    if (_specificationList) {
        [_specificationList enumerateObjectsUsingBlock:^(WMStoreGoodsProductSpecification *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            obj.productPromotion = productPromotion;
        }];
    }
}

- (void)setSpecificationList:(NSArray<WMStoreGoodsProductSpecification *> *)specificationList {
    _specificationList = specificationList;
    if (_productPromotion) {
        [_specificationList enumerateObjectsUsingBlock:^(WMStoreGoodsProductSpecification *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            obj.productPromotion = _productPromotion;
        }];
    }
}

#pragma mark - lazy load

#pragma mark - getter
//- (SAMoneyModel *)showPrice {
//    return self.discountPrice;
//}
//
//- (SAMoneyModel *)linePrice {
//    if (self.salePrice.cent.integerValue == self.discountPrice.cent.integerValue) {
//        return nil;
//    }
//    return self.salePrice;
//}


- (NSString *)salePrice {
    if(!_salePrice && _salePriceCent >= 0) {
        return [NSString stringWithFormat:@"%.2f", _salePriceCent / 100.0];
    }
    return _salePrice;
}

- (NSString *)discountPrice {
    if(!_discountPrice && _discountPriceCent >= 0) {
        return [NSString stringWithFormat:@"%.2f", _discountPriceCent / 100.0];
    }
    return _discountPrice;
}


- (NSString *)showPrice{
    return self.discountPrice;
}

- (NSString *)linePrice {
    if ([self.salePrice isEqualToString:self.discountPrice]) {
        return nil;
    }
    return self.salePrice;
}

@end
