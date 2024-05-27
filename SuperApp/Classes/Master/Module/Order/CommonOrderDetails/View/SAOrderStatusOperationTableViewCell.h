//
//  SAOrderStatusOperationTableViewCell.h
//  SuperApp
//
//  Created by seeu on 2022/4/26.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAModel.h"
#import "SATableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class SAOrderStatusOperationTableViewCellModel;


@interface SAOrderStatusOperationTableViewCell : SATableViewCell
///< model
@property (nonatomic, strong) SAOrderStatusOperationTableViewCellModel *model;
/// 支付倒计时结束回调
@property (nonatomic, copy) void (^timerInvalidateHandler)(SAOrderStatusOperationTableViewCellModel *model);

/// 支付按钮点击回调
@property (nonatomic, copy) void (^payNowClickedHandler)(SAOrderStatusOperationTableViewCellModel *model);

@end


@interface SAOrderStatusOperationTableViewCellModel : SAModel
///< 操作列表
@property (nonatomic, strong) NSArray<NSString *> *operationList;
///< 下单时间
@property (nonatomic, strong) NSNumber *createTime;
///< 聚合订单状态
@property (nonatomic, assign) SAAggregateOrderState aggregateOrderState;
///< 聚合订单终态
@property (nonatomic, assign) SAAggregateOrderFinalState aggregateOrderFinalState;
///< 支付超时时间（分钟）
@property (nonatomic, assign) NSUInteger expireTime;

@end

NS_ASSUME_NONNULL_END
