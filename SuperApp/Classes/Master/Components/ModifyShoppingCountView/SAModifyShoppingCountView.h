//
//  SAModifyShoppingCountView.h
//  SuperApp
//
//  Created by VanJay on 2020/5/12.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SAModifyShoppingCountViewOperationType) {
    SAModifyShoppingCountViewOperationTypeMinus = 0, ///< 减操作
    SAModifyShoppingCountViewOperationTypePlus = 1,  ///< 加操作

};

/// 修改商品数量 View
@interface SAModifyShoppingCountView : SAView
/// 数量变化回调
@property (nonatomic, copy) void (^changedCountHandler)(SAModifyShoppingCountViewOperationType type, NSUInteger count);
/// 是否可以变化
@property (nonatomic, copy) BOOL (^countShouldChange)(SAModifyShoppingCountViewOperationType type, NSUInteger count);
/// 点击加时数量达到最大事件回调
@property (nonatomic, copy) void (^maxCountLimtedHandler)(NSUInteger count);
/// 当前数量
@property (nonatomic, assign, readonly) NSUInteger count;
/// 设置步进值，默认 1，即每次变化数量（内部处理 firstStepCount）
@property (nonatomic, assign) NSUInteger step;
/// 第一步最小值，默认 1（用于起订数量场景）
@property (nonatomic, assign) NSUInteger firstStepCount;
/// 最大值，默认 NSUIntegerMax
@property (nonatomic, assign) NSUInteger maxCount;
/// 最小值，默认 0
@property (nonatomic, assign) NSUInteger minCount;
/// 点击了减号
@property (nonatomic, copy) void (^clickedMinusBTNHandler)(void);
/// 点击了加号
@property (nonatomic, copy) void (^clickedPlusBTNHandler)(void);
/// 禁用减逻辑
@property (nonatomic, assign) NSUInteger disableMinusLogic;
/// 禁用加逻辑
@property (nonatomic, assign) NSUInteger disablePlusLogic;
/// 减图标 默认 shopping_minus
@property (nonatomic, copy) NSString *minusIcon;
/// 加图标 默认 goods_add_icon
@property (nonatomic, copy) NSString *plusIcon;
/// 自定义数量文本
@property (nonatomic, copy) void (^customCountLB)(SALabel *countLb);
/// 回调时间 default 0.3
@property (nonatomic, assign) CGFloat blockTime;
/// 开启或关闭按钮可用状态
- (void)enableOrDisableButton:(BOOL)yor;

/// 开启或关闭加按钮可用状态
- (void)enableOrDisablePlusButton:(BOOL)yor;

/// 开启或关闭减按钮可用状态
- (void)enableOrDisableMinusButton:(BOOL)yor;
/// 设置当前数量
- (void)updateCount:(NSUInteger)count;
@end

NS_ASSUME_NONNULL_END
