//
//  WMOrderDetailRefundEventModel.h
//  SuperApp
//
//  Created by VanJay on 2020/6/27.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderDetailRefundEventModel : WMModel
/// 事件描述
@property (nonatomic, copy) NSString *eventDesc;
/// 事件触发时间
@property (nonatomic, assign) NSTimeInterval eventTime;
/// 操作员登录名
@property (nonatomic, copy) NSString *loginName;
// 事件类型,
@property (nonatomic, assign) WMOrderEventType eventType;
/// 操作角色
@property (nonatomic, assign) WMOrderEventOperatorPlatform operatePlatform;
/// 操作角色
@property (nonatomic, copy) NSString *operateRole;
/// 订单号
@property (nonatomic, copy) NSString *orderNo;
/// 图片
@property (nonatomic, copy) NSArray<NSString *> *pictureIds;

#pragma mark - 绑定属性
/// 是否第一个
@property (nonatomic, assign) BOOL isFirstCell;
@end

NS_ASSUME_NONNULL_END
