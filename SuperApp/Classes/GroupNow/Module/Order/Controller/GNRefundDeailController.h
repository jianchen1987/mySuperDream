//
//  GNRefundDeailController.h
//  SuperApp
//
//  Created by wmz on 2022/3/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNViewController.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNRefundDeailController : GNViewController
///订单编号
@property (nonatomic, copy) NSString *orderNo;
///订单编号 聚合
@property (nonatomic, copy) NSString *aggregateOrderNo;
///取消原因
@property (nonatomic, strong, nullable) GNOrderCancelType cancelState;
///电话
@property (nonatomic, strong, nonnull) NSString *businessPhone;
///取消时间
@property (nonatomic, assign) NSTimeInterval cancelTime;

@end

NS_ASSUME_NONNULL_END
