//
//  SAOrderDetailRefundEventModel.h
//  SuperApp
//
//  Created by Chaos on 2020/7/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAModel.h"

typedef NS_ENUM(NSUInteger, SAOrderEventType) {
    SAOrderEventTypeRefundApplying = 26,       ///< 申请退款
    SAOrderEventTypeMerchantAcceptRefund = 27, ///< 同意退款
    SAOrderEventTypeRefundSuccess = 34,        ///< 退款成功
};

NS_ASSUME_NONNULL_BEGIN


@interface SAOrderDetailRefundEventModel : SAModel

/// 事件描述
@property (nonatomic, copy) NSString *eventDesc;
/// 事件触发时间
@property (nonatomic, assign) NSTimeInterval eventTime;
/// 操作员登录名
@property (nonatomic, copy) NSString *loginName;
// 事件类型,
@property (nonatomic, assign) SAOrderEventType eventType;
/// 操作角色
//@property (nonatomic, assign) WMOrderEventOperatorPlatform operatePlatform;
///// 操作角色
//@property (nonatomic, copy) NSString *operateRole;
/// 订单号
@property (nonatomic, copy) NSString *orderNo;
/// 图片
@property (nonatomic, copy) NSArray<NSString *> *pictureIds;

#pragma mark - 绑定属性
/// 是否第一个
@property (nonatomic, assign) BOOL isFirstCell;
/// 是否最后一个
@property (nonatomic, assign) BOOL isLastCell;

@end

NS_ASSUME_NONNULL_END
