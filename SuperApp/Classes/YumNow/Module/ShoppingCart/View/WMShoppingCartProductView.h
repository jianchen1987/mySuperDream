//
//  WMShoppingCartProductView.h
//  SuperApp
//
//  Created by VanJay on 2020/5/13.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"

@class WMShoppingCartStoreProduct;

NS_ASSUME_NONNULL_BEGIN

/// 每项商品
@interface WMShoppingCartProductView : SAView
/// 模型
@property (nonatomic, strong) WMShoppingCartStoreProduct *model;
/// 是否处于编辑状态  编辑状态
@property (nonatomic, assign) BOOL onEditing;
/// 点击了商品
@property (nonatomic, copy) void (^clickedProductViewBlock)(void);
/// 点击了删除按钮
@property (nonatomic, copy) void (^clickedDeleteBTNBlock)(void);
/// 数量是否允许变化
@property (nonatomic, copy) BOOL (^countShouldChangeBlock)(BOOL isIncrease, NSUInteger count);
/// 数量变化（内部有节流操作）
@property (nonatomic, copy) void (^countChangedBlock)(BOOL isIncrease, NSUInteger changedTo, void (^afterSuccessBlock)(void));
/// 减少商品数量（实时调用）
@property (nonatomic, copy) void (^clickedMinusBTNHandler)(void);
/// 点击加时数量达到最大事件回调
@property (nonatomic, copy) void (^maxCountLimtedHandler)(NSUInteger count);
/// 点击了选中按钮
@property (nonatomic, copy) void (^clickedSelectBTNBlock)(BOOL isSelected, WMShoppingCartStoreProduct *productModel);

///*********************************以下是编辑状态下的点击回调  为了尽量不与原逻辑混杂****************************/ / /
/// 编辑状态下选中商品 点击商品和选中框全部响应该方法
@property (nonatomic, copy) void (^onEditingSelectedProductBlock)(WMShoppingCartStoreProduct *productModel);
/// 设置按钮选中状态
- (void)setSelectBtnSelected:(BOOL)selected;
@end

NS_ASSUME_NONNULL_END
