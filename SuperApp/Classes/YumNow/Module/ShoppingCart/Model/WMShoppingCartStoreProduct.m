//
//  WMShoppingCartStoreProduct.m
//  SuperApp
//
//  Created by VanJay on 2020/5/13.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMShoppingCartStoreProduct.h"
#import "NSArray+SAExtension.h"
#import "WMOrderDetailProductModel.h"
#import <HDKitCore/NSArray+HDKitCore.h>


@implementation WMShoppingCartStoreIdentifyableProduct
- (NSArray *)propertyArray {
    if (!_propertyArray) {
        _propertyArray = @[];
    }
    return _propertyArray;
}
- (BOOL)isEqual:(WMShoppingCartStoreIdentifyableProduct *)object {
    if (![object isKindOfClass:WMShoppingCartStoreIdentifyableProduct.class])
        return false;
    return [self.goodsId isEqual:object.goodsId] && [self.goodsSkuId isEqual:object.goodsSkuId] && [self.propertyArray isSetFormatEqualTo:object.propertyArray];
}

@end


@interface WMShoppingCartStoreProduct ()
/// 比较对象，用于比较是否同一个商品
//@property (nonatomic, strong) WMShoppingCartStoreIdentifyableProduct *identifyObj;
@end


@implementation WMShoppingCartStoreProduct
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"salePriceCent": @"salePrice",
        @"discountPriceCent": @"discountPrice",
        @"nameEn": @"goodsName",
        @"goodsSkuNameEn": @"goodsSkuName",
        @"goodsSkuPriceCent": @"goodsSkuPrice",
        @"productPromotion": @[@"productPromotion", @"productPromotionRespDTO"],
    };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"properties": WMShoppingCartStoreProductProperty.class,
    };
}

+ (instancetype)modelWithOrderDetailProductModel:(WMOrderDetailProductModel *)model {
    WMShoppingCartStoreProduct *item = WMShoppingCartStoreProduct.new;
    item.storeStatus = model.storeStatus;
    item.name = [SAInternationalizationModel modelWithCN:model.commodityName en:model.commodityName kh:model.commodityName];
    item.picture = model.commodityPictureIds.firstObject;
    item.goodsSkuName = [SAInternationalizationModel modelWithCN:model.specificationName en:model.specificationName kh:model.specificationName];
    item.salePrice = model.originalPrice;
    item.purchaseQuantity = model.quantity;
    item.hideOriginalPrice = true;
    item.properties = [model.propertyList mapObjectsUsingBlock:^id _Nonnull(WMOrderDetailProductPropertyModel *_Nonnull obj, NSUInteger idx) {
        WMShoppingCartStoreProductProperty *propertyModel = WMShoppingCartStoreProductProperty.new;
        propertyModel.name = [SAInternationalizationModel modelWithCN:obj.propertySelectionName en:obj.propertySelectionName kh:obj.propertySelectionName];
        return propertyModel;
    }];
    item.afterDiscountUnitPrice = model.afterDiscountUnitPrice;
    item.afterDiscountTotalPrice = model.afterDiscountTotalPrice;
    return item;
}

#pragma mark - setter

- (void)setNameEn:(NSString *)nameEn {
    _nameEn = nameEn;
    self.name.en_US = nameEn;
}

- (void)setNameKm:(NSString *)nameKm {
    _nameKm = nameKm;
    self.name.km_KH = nameKm;
}

- (void)setNameZh:(NSString *)nameZh {
    _nameZh = nameZh;
    self.name.zh_CN = nameZh;
}

- (void)setGoodsSkuNameEn:(NSString *)goodsSkuNameEn {
    _goodsSkuNameEn = goodsSkuNameEn;
    self.goodsSkuName.en_US = goodsSkuNameEn;
}

- (void)setGoodsSkuNameKM:(NSString *)goodsSkuNameKM {
    _goodsSkuNameKM = goodsSkuNameKM;
    self.goodsSkuName.km_KH = goodsSkuNameKM;
}

- (void)setGoodsSkuNameZH:(NSString *)goodsSkuNameZH {
    _goodsSkuNameZH = goodsSkuNameZH;
    self.goodsSkuName.zh_CN = goodsSkuNameZH;
}

- (void)setSalePriceCent:(NSString *)salePriceCent {
    _salePriceCent = salePriceCent;
    self.salePrice.cent = [NSString stringWithFormat:@"%f", salePriceCent.doubleValue * 100];
}

- (void)setDiscountPriceCent:(NSString *)discountPriceCent {
    _discountPriceCent = discountPriceCent;
    self.discountPrice.cent = [NSString stringWithFormat:@"%f", discountPriceCent.doubleValue * 100];
}

- (void)setGoodsSkuPriceCent:(NSString *)goodsSkuPriceCent {
    _goodsSkuPriceCent = goodsSkuPriceCent;
    self.goodsSkuPrice.cent = [NSString stringWithFormat:@"%f", goodsSkuPriceCent.doubleValue * 100];
}

- (void)setCurrency:(SACurrencyType)currency {
    _currency = currency;
    self.salePrice.cy = currency;
    self.discountPrice.cy = currency;
    self.goodsSkuPrice.cy = currency;
}

- (void)setInEffectVersionId:(NSString *)inEffectVersionId {
    [super setInEffectVersionId:inEffectVersionId];

    self.identifyObj.inEffectVersionId = inEffectVersionId;
}

- (void)setGoodsId:(NSString *)goodsId {
    [super setGoodsId:goodsId];

    self.identifyObj.goodsId = goodsId;
}

- (void)setGoodsSkuId:(NSString *)goodsSkuId {
    [super setGoodsSkuId:goodsSkuId];

    self.identifyObj.goodsSkuId = goodsSkuId;
}

- (void)setProperties:(NSArray<WMShoppingCartStoreProductProperty *> *)properties {
    _properties = properties;
    self.identifyObj.propertyArray = [properties mapObjectsUsingBlock:^id _Nonnull(WMShoppingCartStoreProductProperty *_Nonnull obj, NSUInteger idx) {
        return obj.propertyId;
    }];
}

- (BOOL)canSelected {
    const BOOL isStoreOpening = [self.storeStatus isEqualToString:WMShopppingCartStoreStatusOpening];
    const BOOL isGoodsOnSale = self.goodsState == WMGoodsStatusOn;
    const BOOL isGoodsSoldOut = self.availableStock <= 0;
    // 已选数量超出库存
    const BOOL isGoodsPurchaseQuantityOverAvailableStock = self.purchaseQuantity > self.availableStock;
    return isStoreOpening && isGoodsOnSale && !isGoodsSoldOut && !isGoodsPurchaseQuantityOverAvailableStock;
}

#pragma mark - private methods
- (SAMoneyModel *)totalPrice {
    NSUInteger count = MAX(1, self.purchaseQuantity);
    SAMoneyModel *totalPrice = SAMoneyModel.new;
    totalPrice.cy = self.salePrice.cy;
    totalPrice.cent = [NSString stringWithFormat:@"%zd", self.salePrice.cent.integerValue * count];
    return totalPrice;
}

#pragma mark - getter
- (SAMoneyModel *)showPrice {
    if (self.afterDiscountTotalPrice && ![self.afterDiscountTotalPrice.cent isEqualToString:self.totalPrice.cent]) {
        return self.afterDiscountTotalPrice;
    }
    if (self.totalDiscountAmount && self.totalDiscountAmount.cent.integerValue != 0) {
        SAMoneyModel *showPrice = SAMoneyModel.new;
        showPrice.cy = self.salePrice.cy;
        showPrice.cent = [NSString stringWithFormat:@"%zd", self.totalPrice.cent.integerValue - self.totalDiscountAmount.cent.integerValue];
        return showPrice;
    }
    return self.totalPrice;
}

- (SAMoneyModel *)linePrice {
    if (self.afterDiscountTotalPrice) {
        return self.afterDiscountTotalPrice.cent.integerValue == self.totalPrice.cent.integerValue ? nil : self.totalPrice;
    }
    if (self.totalDiscountAmount && self.totalDiscountAmount.cent.integerValue != 0) {
        return self.totalPrice;
    }
    return nil;
}

#pragma mark - lazy load
- (SAInternationalizationModel *)name {
    if (!_name) {
        _name = SAInternationalizationModel.new;
    }
    return _name;
}

- (SAInternationalizationModel *)goodsSkuName {
    if (!_goodsSkuName) {
        _goodsSkuName = SAInternationalizationModel.new;
    }
    return _goodsSkuName;
}

- (SAMoneyModel *)salePrice {
    if (!_salePrice) {
        _salePrice = SAMoneyModel.new;
    }
    return _salePrice;
}

- (SAMoneyModel *)discountPrice {
    if (!_discountPrice) {
        _discountPrice = SAMoneyModel.new;
    }
    return _discountPrice;
}

- (SAMoneyModel *)goodsSkuPrice {
    if (!_goodsSkuPrice) {
        _goodsSkuPrice = SAMoneyModel.new;
    }
    return _goodsSkuPrice;
}

- (WMShoppingCartStoreIdentifyableProduct *)identifyObj {
    if (!_identifyObj) {
        _identifyObj = WMShoppingCartStoreIdentifyableProduct.new;
    }
    return _identifyObj;
}

- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
}

@end
