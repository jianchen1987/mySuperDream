//
//  WMStoreShoppingCartProductCell.h
//  SuperApp
//
//  Created by VanJay on 2020/6/10.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class WMShoppingCartStoreProduct;


@interface WMStoreShoppingCartProductCell : SATableViewCell
/// 模型
@property (nonatomic, strong) WMShoppingCartStoreProduct *model;
/// 减少商品数量（实时调用）
@property (nonatomic, copy) void (^clickedMinusBTNBlock)(void);
/// 数量变化
@property (nonatomic, copy) void (^goodsCountChangedBlock)(WMShoppingCartStoreProduct *_Nonnull productModel, BOOL isIncrease, NSUInteger count);
/// 数量是否可以变化
@property (nonatomic, copy) BOOL (^goodsCountShouldChangeBlock)(WMShoppingCartStoreProduct *_Nonnull productModel, BOOL isIncrease, NSUInteger count);

@end

NS_ASSUME_NONNULL_END
