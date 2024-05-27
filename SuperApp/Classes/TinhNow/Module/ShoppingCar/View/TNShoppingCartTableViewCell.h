//
//  TNShoppingCartTableViewCell.h
//  SuperApp
//
//  Created by seeu on 2020/7/5.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
NS_ASSUME_NONNULL_BEGIN
@class TNShoppingCarStoreModel;
@class TNShoppingCarItemModel;


@interface TNShoppingCartTableViewCell : SATableViewCell
/// 模型
@property (nonatomic, strong) TNShoppingCarStoreModel *model;
/// 点击了商品
@property (nonatomic, copy) void (^clickedProductViewBlock)(TNShoppingCarItemModel *productModel);
/// 删除单个商品回调
@property (nonatomic, copy) void (^deleteSingleGoodsBlock)(TNShoppingCarItemModel *productModel);
/// 删除门店购物项回调
@property (nonatomic, copy) void (^deleteStoreGoodsBlock)(NSString *merchantDisplayNo);
/// 增加单个商品数量回调
@property (nonatomic, copy) void (^plusGoodsCountBlock)(TNShoppingCarItemModel *productModel, NSUInteger addDelta);
/// 减少单个商品数量回调
@property (nonatomic, copy) void (^minusGoodsCountBlock)(TNShoppingCarItemModel *productModel, NSUInteger deleteDelta);
/// 点击了门店标题
@property (nonatomic, copy) void (^clickedStoreTitleBlock)(NSString *storeNo);
/// 获取选中项商品模型数组
@property (nonatomic, copy, readonly) NSArray<TNShoppingCarItemModel *> *selectedProductList;
/// 任何一项商品（包括门店选中按钮状态变化）选中按钮状态变化触发
@property (nonatomic, copy) void (^anyProductSelectStateChangedHandler)(void);
/// 删除了最后一项商品，告诉外部删除该 cell
@property (nonatomic, copy) void (^deletedLastProductBlock)(NSString *merchantDisplayNo);
/// 告诉外部该 cell 应该 reload
@property (nonatomic, copy) void (^reloadBlock)(NSString *storeNo);
/// 用户在界面上做了某些动作，比如点击选中按钮，点击标题等
@property (nonatomic, copy) void (^userDidDoneSomeActionBlock)(void);
/// 点击了下单
@property (nonatomic, copy) void (^clickedOrderNowBTNBlock)(void);

/// 勾选了商品埋点回调回到
@property (nonatomic, copy) void (^selectedItemTrackEventBlock)(TNShoppingCarItemModel *productModel);
/// 从选择的商品中删除目标商品模型，如果是最后一个，会触发 deletedLastProductBlock
- (void)removeSelectedProductModelFromSelectedProductList:(TNShoppingCarItemModel *)productModel;
@end

NS_ASSUME_NONNULL_END
