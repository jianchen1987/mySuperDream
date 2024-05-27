//
//  WMChooseGoodsPropertyAndSkuView.h
//  SuperApp
//
//  Created by VanJay on 2020/5/14.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"

@class WMStoreGoodsItem;
@class WMStoreGoodsProductSpecification;
@class WMStoreGoodsProductPropertyOption;
@class WMStoreDetailPromotionModel;

NS_ASSUME_NONNULL_BEGIN

/// 选择商品规格和属性界面
@interface WMChooseGoodsPropertyAndSkuView : HDActionAlertView
- (instancetype)initWithStoreGoodsItem:(WMStoreGoodsItem *)model availableBestSaleCount:(NSUInteger)availableBestSaleCount;
/// 点击了添加进购物车
@property (nonatomic, copy) void (^addToCartBlock)(NSUInteger count, WMStoreGoodsProductSpecification *specificationModel, NSArray<WMStoreGoodsProductPropertyOption *> *propertyOptionList);
/// 门店购物车中其他爆款商品的加购数量
@property (nonatomic, copy) NSUInteger (^otherBestSaleGoodsPurchaseQuantityInStoreShoppingCart)(WMStoreGoodsItem *model);
/// 门店购物车中已享受的活动
@property (nonatomic, copy) NSArray<WMStoreDetailPromotionModel *> * (^storeShoppingCartPromotions)(void);
@end

NS_ASSUME_NONNULL_END
