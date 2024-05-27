//
//  WMStoreShoppingCartViewController.h
//  SuperApp
//
//  Created by VanJay on 2020/6/10.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SANonePresentAnimationViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class WMShoppingCartStoreItem;
@class WMShoppingItemsPayFeeTrialCalRspModel;


@interface WMStoreShoppingCartViewController : SANonePresentAnimationViewController
/// 展示
/// @param bottomMargin 需要留出的底部间距
/// @param shopppingCartStoreItem 该店在购物车中的数据
/// @param payFeeTrialCalRspModel 试算返回
- (void)showWithBottomMargin:(CGFloat)bottomMargin
      shopppingCartStoreItem:(WMShoppingCartStoreItem *)shopppingCartStoreItem
      payFeeTrialCalRspModel:(WMShoppingItemsPayFeeTrialCalRspModel *)payFeeTrialCalRspModel;

/// 消失
- (void)dismiss;

/// 根据最新的购物车数据和试算数据更新 UI
- (void)updateUIWithShopppingCartStoreItem:(WMShoppingCartStoreItem *)shopppingCartStoreItem payFeeTrialCalRspModel:(WMShoppingItemsPayFeeTrialCalRspModel *)payFeeTrialCalRspModel;
/// 是否可以展开
@property (nonatomic, assign, readonly) BOOL canExpand;
/// 将要隐藏
@property (nonatomic, copy) void (^willDissmissHandler)(void);
/// 门店购物车内商品数量变化回调
@property (nonatomic, copy) void (^storeCartGoodsDidChangedBlock)(void);
/// 门店购物车内删减了商品
@property (nonatomic, copy) void (^storeCartMinusGoodsBlock)(void);
/// 所属页面重新刷新回调
@property (nonatomic, copy) void (^refreshDataBlock)(void);
@end

NS_ASSUME_NONNULL_END
