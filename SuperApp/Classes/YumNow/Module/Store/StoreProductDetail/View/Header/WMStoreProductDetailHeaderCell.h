//
//  WMStoreProductDetailHeaderCell.h
//  SuperApp
//
//  Created by VanJay on 2020/6/12.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class WMStoreProductDetailRspModel;


@interface WMStoreProductDetailHeaderCell : SATableViewCell
/// 模型
@property (nonatomic, strong) WMStoreProductDetailRspModel *model;
/// 添加商品（规则和属性只有一种时触发）
@property (nonatomic, copy) void (^plusGoodsToShoppingCartBlock)(WMStoreProductDetailRspModel *model, NSUInteger forwardCount);
/// 是否应该改变数量
@property (nonatomic, copy) BOOL (^goodsCountShouldChangeBlock)(WMStoreProductDetailRspModel *model, BOOL isIncrease, NSUInteger count);
/// 更新商品数量（规则和属性只有一种时触发）
@property (nonatomic, copy) void (^goodsCountChangedBlock)(WMStoreProductDetailRspModel *model, BOOL isIncrease, NSUInteger count);
/// 显示选择规格和属性界面
@property (nonatomic, copy) void (^showChooseGoodsPropertyAndSkuViewBlock)(WMStoreProductDetailRspModel *model);
/// 点击了商品介绍查看更多或更少
@property (nonatomic, copy) void (^clickedProductDescReadMoreOrReadLessBlock)(void);
@end

NS_ASSUME_NONNULL_END
