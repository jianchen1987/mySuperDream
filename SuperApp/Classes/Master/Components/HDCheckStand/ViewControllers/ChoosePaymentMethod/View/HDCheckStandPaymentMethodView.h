//
//  HDCheckStandPaymentMethodView.h
//  SuperApp
//
//  Created by seeu on 2022/5/12.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "HDCheckStandPaymentMethodCellModel.h"
#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface HDCheckStandPaymentMethodView : SAView
/// 模型
@property (nonatomic, strong) HDCheckStandPaymentMethodCellModel *model;

/// 点击了view回调
@property (nonatomic, copy, nullable) void (^clickedHandler)(HDCheckStandPaymentMethodView *view, HDCheckStandPaymentMethodCellModel *model);
/// 点击了活动按钮
@property (nonatomic, copy, nullable) void (^clickedActivityHandler)(HDCheckStandPaymentMethodView *view, HDCheckStandPaymentMethodCellModel *model);

// 设置选中
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

/// 数据发生了变化，主动刷新，设置model也会刷新
- (void)updateUI;

@end

NS_ASSUME_NONNULL_END
