//
//  WMShoppingGoodTableViewCell.h
//  SuperApp
//
//  Created by VanJay on 2020/5/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"
#import "WMStoreGoodsItem.h"

#define kShoppingGoodTableViewCellSize kRealWidth(80)
#define kShoppingGoodTableViewCellTopMargin kRealWidth(15)
#define kShoppingGoodTableViewCellBottomMargin kRealWidth(15)

NS_ASSUME_NONNULL_BEGIN


@interface WMShoppingGoodTableViewCell : SATableViewCell <HDSkeletonLayerLayoutProtocol>
/// 模型
@property (nonatomic, strong) WMStoreGoodsItem *model;
/// 视图点击回调
@property (nonatomic, copy) void (^cellClickedEventBlock)(WMStoreGoodsItem *model);
/// 商品数量是否可以变化
@property (nonatomic, copy) BOOL (^goodsFromShoppingCartShouldChangeBlock)(WMStoreGoodsItem *model, BOOL isIncreate, NSUInteger count);
/// 商品数量变化 （规则和属性只有一种时触发
@property (nonatomic, copy) void (^goodsFromShoppingCartChangedBlock)(WMStoreGoodsItem *model, BOOL isIncreate, NSUInteger count);
/// 添加商品（规则和属性只有一种时触发）
@property (nonatomic, copy) void (^plusGoodsToShoppingCartBlock)(WMStoreGoodsItem *model, NSUInteger forwardCount);
/// 减少商品（实时调用）
@property (nonatomic, copy) void (^minusGoodsToShoppingCartBlock)(void);
/// 显示选择规格和属性界面
@property (nonatomic, copy) void (^showChooseGoodsPropertyAndSkuViewBlock)(WMStoreGoodsItem *model);

/// 闪动
- (void)flash;
@end

NS_ASSUME_NONNULL_END
