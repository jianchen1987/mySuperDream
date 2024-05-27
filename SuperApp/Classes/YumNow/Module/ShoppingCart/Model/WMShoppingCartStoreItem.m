//
//  WMShoppingCartStoreItem.m
//  SuperApp
//
//  Created by VanJay on 2020/5/13.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMShoppingCartStoreItem.h"
#import "WMStoreDetailPromotionModel.h"
#import "WMShoppingItemsPayFeeTrialCalRspModel.h"


@implementation WMShoppingCartStoreItem
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"storeNameEn": @"storeName", @"goodsList": @"shopCartItemDTOS"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"goodsList": WMShoppingCartStoreProduct.class,
    };
}

#pragma mark - private methods
// 更新起送价
- (void)updateRequiredPrice {
    SAMoneyModel *requiredPrice = self.requiredPrice.copy;
    for (WMStoreDetailPromotionModel *promotion in self.feeTrialCalRspModel.promotions) {
        if (promotion.requiredPrice.cent.integerValue > requiredPrice.cent.integerValue) {
            requiredPrice = promotion.requiredPrice.copy;
        }
    }
    if (!HDIsObjectNil(self.realRequiredPrice) && requiredPrice.cent.integerValue > self.realRequiredPrice.cent.integerValue && self.needShowRequiredPriceChangeToast) {
        [NAT showToastWithTitle:nil content:[NSString stringWithFormat:WMLocalizedString(@"IBjwzhJw", @"该优惠活动商品的起送价为%@"), requiredPrice.thousandSeparatorAmount] type:HDTopToastTypeInfo];
    }
    self.needShowRequiredPriceChangeToast = false;
    self.realRequiredPrice = requiredPrice;
}

#pragma mark - getter
- (SAMoneyModel *)realRequiredPrice {
    if (!_realRequiredPrice) {
        _realRequiredPrice = self.requiredPrice.copy;
    }
    return _realRequiredPrice;
}

#pragma mark - setter
- (void)setStoreNameEn:(NSString *)storeNameEn {
    _storeNameEn = storeNameEn;
    self.storeName.en_US = storeNameEn;
}

- (void)setStoreNameKm:(NSString *)storeNameKm {
    _storeNameKm = storeNameKm;
    self.storeName.km_KH = storeNameKm;
}

- (void)setStoreNameZh:(NSString *)storeNameZh {
    _storeNameZh = storeNameZh;
    self.storeName.zh_CN = storeNameZh;
}

- (void)setFeeTrialCalRspModel:(WMShoppingItemsPayFeeTrialCalRspModel *)feeTrialCalRspModel {
    _feeTrialCalRspModel = feeTrialCalRspModel;
    [self updateRequiredPrice];
}

#pragma mark - lazy load
- (SAInternationalizationModel *)storeName {
    if (!_storeName) {
        _storeName = SAInternationalizationModel.new;
    }
    return _storeName;
}
@end
