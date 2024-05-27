//
//  GNRefundModel.h
//  SuperApp
//
//  Created by wmz on 2022/3/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAOrderModel.h"
#import "GNCellModel.h"
#import "WMOrderRelatedEnum.h"
#import "GNMessageCode.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNRefundModel : GNCellModel
/// 实际退款金额
@property (nonatomic, strong) SAMoneyModel *actualRefundAmount;
/// 申请退款金额
@property (nonatomic, strong) SAMoneyModel *applyRefundAmount;
/// 退款状态, 10: 退款中, 11: 退款成功
@property (nonatomic, assign) SAOrderListAfterSaleState refundOrderState;
/// 聚合订单号
@property (nonatomic, copy) NSString *aggregateOrderNo;
/// 业务订单号
@property (nonatomic, copy) NSString *businessOrderId;
/// 创建时间
@property (nonatomic, assign) NSTimeInterval createTime;
/// 更新时间
@property (nonatomic, assign) NSTimeInterval updateTime;
/// 退回方式 1 原路退回 2 线下退款
@property (nonatomic, strong) GNMessageCode *refundWay;

@end

NS_ASSUME_NONNULL_END
