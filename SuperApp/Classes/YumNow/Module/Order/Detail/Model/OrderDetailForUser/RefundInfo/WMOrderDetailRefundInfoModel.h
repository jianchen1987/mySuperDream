//
//  WMOrderDetailRefundInfoModel.h
//  SuperApp
//
//  Created by VanJay on 2020/6/27.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAMoneyModel.h"
#import "WMModel.h"
#import "WMOrderDetailRefundEventModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderDetailRefundInfoModel : WMModel
/// 实际退款金额
@property (nonatomic, strong) SAMoneyModel *actualRefundAmount;
/// 申请退款金额
@property (nonatomic, strong) SAMoneyModel *applyRefundAmount;
/// 退款方式, 10: 原路返回, 20: 线下退款
@property (nonatomic, assign) WMOrderRefundMethod refundMethod;
/// 退款状态, 10: 退款中, 11: 退款成功
@property (nonatomic, assign) WMOrderDetailRefundState refundState;
/// 退款流程
@property (nonatomic, copy) NSArray<WMOrderDetailRefundEventModel *> *refundEventList;
@end

NS_ASSUME_NONNULL_END
