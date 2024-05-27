//
//  TNModifyShoppingCountView.h
//  SuperApp
//
//  Created by 张杰 on 2022/3/4.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNView.h"
#import <HDKitCore/HDFunctionThrottle.h>
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, TNModifyShoppingCountViewOperationType) {
    TNModifyShoppingCountViewOperationTypeMinus = 0, ///< 减操作
    TNModifyShoppingCountViewOperationTypePlus = 1,  ///< 加操作

};


@interface TNModifyShoppingCountView : TNView
/// 数量变化回调
@property (nonatomic, copy) void (^changedCountHandler)(TNModifyShoppingCountViewOperationType type, NSUInteger count);
///// 是否可以变化
@property (nonatomic, copy) BOOL (^countShouldChange)(TNModifyShoppingCountViewOperationType type, NSUInteger count);
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
/// 点击加时数量达到最大事件回调
@property (nonatomic, copy) void (^maxCountLimtedHandler)(NSUInteger count);
/// 禁用减逻辑
@property (nonatomic, assign) BOOL disableMinusLogic;
/// 禁用加逻辑
@property (nonatomic, assign) BOOL disablePlusLogic;
/// 减图标 默认 shopping_minus
@property (nonatomic, copy) NSString *minusIcon;
/// 加图标 默认 goods_add_icon
@property (nonatomic, copy) NSString *plusIcon;
/// 输入框
@property (strong, nonatomic, readonly) HDUITextField *textField;

/// 是否需要弹窗修改数量  默认不需要
@property (nonatomic, assign) BOOL needShowModifyCountAlertView;
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
