//
//  TNShoppingCartProductView.h
//  SuperApp
//
//  Created by seeu on 2020/7/5.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN
@class TNShoppingCarItemModel;


@interface TNShoppingCartProductView : SAView
/// 模型
@property (nonatomic, strong) TNShoppingCarItemModel *model;
/// 点击了商品
@property (nonatomic, copy) void (^clickedProductViewBlock)(void);
/// 点击了删除按钮
@property (nonatomic, copy) void (^clickedDeleteBTNBlock)(void);
/// 点击了加号
@property (nonatomic, copy) void (^clickedPlusBTNBlock)(NSUInteger addDelta, NSUInteger forwardCount);
/// 点击了减号
@property (nonatomic, copy) void (^clickedMinusBTNBlock)(NSUInteger deleteDelta, NSUInteger currentCount);
/// 点击加时数量达到最大事件回调
@property (nonatomic, copy) void (^maxCountLimtedHandler)(NSUInteger count);
/// 点击了选中按钮
@property (nonatomic, copy) void (^clickedSelectBTNBlock)(BOOL isSelected, TNShoppingCarItemModel *productModel);
/// 设置按钮选中状态
- (void)setSelectBtnSelected:(BOOL)selected;
@end

NS_ASSUME_NONNULL_END
