//
//  WMStoreProductDetailRspModel.m
//  SuperApp
//
//  Created by VanJay on 2020/6/12.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreProductDetailRspModel.h"


@interface WMStoreProductDetailRspModel ()
/// 当前在购物车中的数量
@property (nonatomic, assign) NSUInteger currentCountInShoppingCart;

@end


@implementation WMStoreProductDetailRspModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.productDescMaxRowCount = 3;
        self.numberOfLinesOfProductDescLabel = 3;
    }
    return self;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"descriptionEn": @"description", @"goodId": @"id", @"status": @"shelfStatus", @"propertyList": @"props", @"specificationList": @"specs", @"inEffectVersionId": @"effectVersion"};
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

#pragma mark - getter
- (SAMoneyModel *)showPrice {
    return self.discountPrice;
}

- (SAMoneyModel *)linePrice {
    if (self.salePrice.cent.integerValue == self.discountPrice.cent.integerValue) {
        return nil;
    }
    return self.salePrice;
}

@end
