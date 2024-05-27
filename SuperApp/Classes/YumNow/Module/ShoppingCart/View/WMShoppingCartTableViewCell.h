//
//  WMShoppingCartTableViewCell.h
//  SuperApp
//
//  Created by VanJay on 2020/5/13.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"

@class WMShoppingCartStoreItem;
@class WMShoppingCartStoreProduct;
@class WMShoppingItemsPayFeeTrialCalRspModel;

NS_ASSUME_NONNULL_BEGIN


@interface WMShoppingCartTableViewCell : SATableViewCell
/// 模型
@property (nonatomic, strong) WMShoppingCartStoreItem *model;
/// 是否处于编辑状态  编辑状态
@property (nonatomic, assign) BOOL onEditing;
/// 点击了商品
@property (nonatomic, copy) void (^clickedProductViewBlock)(WMShoppingCartStoreProduct *productModel);
/// 删除单个商品回调
@property (nonatomic, copy) void (^deleteSingleGoodsBlock)(WMShoppingCartStoreProduct *productModel);
/// 删除门店购物项回调
@property (nonatomic, copy) void (^deleteStoreGoodsBlock)(NSString *merchantDisplayNo, NSString *storeNO);
/// 增加单个商品数量回调
@property (nonatomic, copy) void (^plusGoodsCountBlock)(WMShoppingCartStoreProduct *productModel, NSUInteger addDelta, void (^afterPlusSuccessBlock)(void));
/// 减少单个商品数量回调
@property (nonatomic, copy) void (^minusGoodsCountBlock)(WMShoppingCartStoreProduct *productModel, NSUInteger deleteDelta, void (^afterMinusSuccessBlock)(void));
/// 是否可以增加
@property (nonatomic, copy) BOOL (^goodsCountShouldChange)(WMShoppingCartStoreProduct *productModel, BOOL isIncrease, NSUInteger count);
/// 商品数量变化回调
@property (nonatomic, copy) void (^goodsCountChangedBlock)(WMShoppingCartStoreProduct *productModel, NSUInteger count, void (^afterSuccessBlock)(void));
/// 点击了门店标题
@property (nonatomic, copy) void (^clickedStoreTitleBlock)(NSString *storeNo);
/// 获取选中项商品模型数组
@property (nonatomic, copy, readonly) NSArray<WMShoppingCartStoreProduct *> *selectedProductList;
/// 任何一项商品（包括门店选中按钮状态变化）选中按钮状态变化触发
@property (nonatomic, copy) void (^anyProductSelectStateChangedHandler)(BOOL needUpdatePrice);
/// 删除了最后一项商品，告诉外部删除该 cell
@property (nonatomic, copy) void (^deletedLastProductBlock)(NSString *merchantDisplayNo);
/// 告诉外部该 cell 应该 reload
@property (nonatomic, copy) void (^reloadBlock)(NSString *storeNo);
/// 用户在界面上做了某些动作，比如点击选中按钮，点击标题等
@property (nonatomic, copy) void (^userDidDoneSomeActionBlock)(void);
/// 点击了下单
@property (nonatomic, copy) void (^clickedOrderNowBTNBlock)(void);

///*********************************以下是编辑状态下的点击回调  为了尽量不与原逻辑混杂****************************/ / /
/// 编辑状态下选中商品 点击商品和选中框全部响应该方法
@property (nonatomic, copy) void (^onEditingSelectedProductBlock)(WMShoppingCartStoreItem *item, WMShoppingCartStoreProduct *productModel);
/// 编辑状态下点击了门店标题和门店选中框全部响应该方法
@property (nonatomic, copy) void (^onEditingSelectedStoreBlock)(WMShoppingCartStoreItem *item);

/// 从选择的商品中删除目标商品模型，如果是最后一个，会触发 deletedLastProductBlock
- (void)removeSelectedProductModelFromSelectedProductList:(WMShoppingCartStoreProduct *)productModel;
@end

NS_ASSUME_NONNULL_END
