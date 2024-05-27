//
//  WMStoreDetailAdaptor.m
//  SuperApp
//
//  Created by VanJay on 2020/6/12.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreDetailAdaptor.h"
#import "WMGetUserShoppingCartRspModel.h"


@implementation WMStoreDetailAdaptor
/// 根据商品 id 获取在购物车中的商品项
/// @param storeItem 门店在购物车项中查找该门店购物项
/// @param goodsId 商品 id
+ (NSArray<WMShoppingCartStoreProduct *> *_Nullable)shoppingCardStoreProductListInStoreItem:(WMShoppingCartStoreItem *)storeItem goodsId:(NSString *)goodsId {
    if (!storeItem)
        return nil;

    NSMutableArray<WMShoppingCartStoreProduct *> *productList = [NSMutableArray arrayWithCapacity:storeItem.goodsList.count];
    BOOL hasFindStoreProduct = false;
    for (WMShoppingCartStoreProduct *storeProduct in storeItem.goodsList) {
        if ([storeProduct.goodsId isEqualToString:goodsId]) {
            [productList addObject:storeProduct];
            hasFindStoreProduct = true;
        }
    }
    if (!hasFindStoreProduct)
        return nil;
    return productList;
}

/// 根据门店号在购物车项中查找该门店购物项
/// @param storeNo 门店号
+ (WMShoppingCartStoreItem *_Nullable)shoppingCardStoreItemWithStoreNo:(NSString *)storeNo inUserShoppingCartRspModel:(WMGetUserShoppingCartRspModel *)shoppingCartRspModel {
    if (!shoppingCartRspModel || HDIsArrayEmpty(shoppingCartRspModel.list)) {
        return nil;
    }
    WMShoppingCartStoreItem *storeItem;
    BOOL hasFindStore = false;
    for (WMShoppingCartStoreItem *item in shoppingCartRspModel.list) {
        if ([item.storeNo isEqualToString:storeNo]) {
            storeItem = item;
            hasFindStore = true;
            break;
        }
    }
    if (!hasFindStore) {
        return nil;
    }
    return storeItem;
}
@end
