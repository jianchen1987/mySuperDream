//
//  SAOrderRefundInfoModel.h
//  SuperApp
//
//  Created by Chaos on 2020/7/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAModel.h"

@class SAMoneyModel, SAOrderDetailRefundEventModel;

/// 订单详情页退款状态
typedef NS_ENUM(NSUInteger, SAOrderDetailRefundState) {
    SAOrderDetailRefundStateUnknown = 0,
    SAOrderDetailRefundStateApplying = 10, ///< 退款中,
    SAOrderDetailRefundStateSuccess = 11,  ///< 退款成功
};

/// 售后退款方式
typedef NS_ENUM(NSUInteger, SAOrderRefundMethod) {
    SAOrderRefundMethodUnknown = 0,
    SAOrderRefundMethodOriginalMethod = 10, ///< 原路返回
    SAOrderRefundMethodOffline = 20,        ///< 线下退款
};

NS_ASSUME_NONNULL_BEGIN


@interface SAOrderRefundInfoModel : SAModel

/// 退款状态
@property (nonatomic, assign) SAOrderDetailRefundState refundState;
/// 实际退款金额
@property (nonatomic, strong) SAMoneyModel *actualRefundAmount;
/// 申请退款金额
@property (nonatomic, strong) SAMoneyModel *applyRefundAmount;
/// 退款方式, 10: 原路返回, 20: 线下退款
@property (nonatomic, assign) SAOrderRefundMethod refundMethod;
/// 退款流程
@property (nonatomic, copy) NSArray<SAOrderDetailRefundEventModel *> *refundEventList;

@end

NS_ASSUME_NONNULL_END
