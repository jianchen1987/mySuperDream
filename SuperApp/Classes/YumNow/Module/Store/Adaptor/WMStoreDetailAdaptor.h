//
//  WMStoreDetailAdaptor.h
//  SuperApp
//
//  Created by VanJay on 2020/6/12.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HDKitCore/HDKitCore.h>

NS_ASSUME_NONNULL_BEGIN

@class WMGetUserShoppingCartRspModel;
@class WMShoppingCartStoreItem;
@class WMShoppingCartStoreProduct;


@interface WMStoreDetailAdaptor : NSObject
/// 根据商品 id 获取在购物车中的商品项
/// @param storeItem 门店在购物车项中查找该门店购物项
/// @param goodsId 商品 id
+ (NSArray<WMShoppingCartStoreProduct *> *_Nullable)shoppingCardStoreProductListInStoreItem:(WMShoppingCartStoreItem *)storeItem goodsId:(NSString *)goodsId;

/// 根据门店号在购物车项中查找该门店购物项
/// @param storeNo 门店号
/// @param shoppingCartRspModel 购物车返回模型
+ (WMShoppingCartStoreItem *_Nullable)shoppingCardStoreItemWithStoreNo:(NSString *)storeNo inUserShoppingCartRspModel:(WMGetUserShoppingCartRspModel *)shoppingCartRspModel;
@end

NS_ASSUME_NONNULL_END
