//
//  WMOrderSubmitBottomDock.h
//  SuperApp
//
//  Created by VanJay on 2020/6/17.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import "WMOperationButton.h"

@class SAMoneyModel;

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderSubmitBottomDock : SAView
/// 点击了提交
@property (nonatomic, copy) void (^clickedSubmitBTNBlock)(void (^)(void));
/// 提交按钮
@property (nonatomic, strong, readonly) WMOperationButton *submitBTN;
/// 应付
@property (nonatomic, strong, readonly) SAMoneyModel *payablePrice;
/// 实付
@property (nonatomic, strong, readonly) SAMoneyModel *actualPayPrice;
/// 设置实付金额
- (void)setActualPayPrice:(SAMoneyModel *_Nullable)actualPayPrice;

/// 设置应付金额
- (void)setPayablePrice:(SAMoneyModel *_Nullable)payablePrice;

@end

NS_ASSUME_NONNULL_END
