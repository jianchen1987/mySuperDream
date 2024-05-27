//
//  WMOrderEventModel.h
//  SuperApp
//
//  Created by VanJay on 2020/5/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"
#import "WMOrderCancelReasonModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderEventModel : WMModel
/// 事件描述
@property (nonatomic, copy) NSString *eventDesc;
/// 事件触发时间
@property (nonatomic, copy) NSString *eventTime;
/// 事件类型
@property (nonatomic, assign) WMOrderEventType eventType;
/// 操作平台
@property (nonatomic, assign) WMOrderEventOperatorPlatform operatePlatform;
/// 操作角色
@property (nonatomic, copy) NSString *operateRole;
/// 操作员名称
@property (nonatomic, copy) NSString *operatorName;
/// 操作员号
@property (nonatomic, copy) NSString *operatorNo;
/// 订单号
@property (nonatomic, copy) NSString *orderNo;
/// 取消原因
@property (nonatomic, strong) WMOrderCancelReasonModel *orderCancelReason;
@end

NS_ASSUME_NONNULL_END
