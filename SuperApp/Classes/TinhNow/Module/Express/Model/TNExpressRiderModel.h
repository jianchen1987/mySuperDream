//
//  TNExpressRiderModel.h
//  SuperApp
//
//  Created by 张杰 on 2021/6/8.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN
// 骑手配送状态
typedef NS_ENUM(NSUInteger, TNDeliveryStatus) {
    ///商家已发货，骑手正在取货
    TNDeliveryStatusReady = 0,
    /// 配送中
    TNDeliveryStatusSending = 1,
    /// 已完成
    TNDeliveryStatusDone = 2,
    /// 已取消
    TNDeliveryStatusCancel = 3
};


@interface TNExpressRiderModel : TNModel
/// 订单号
@property (nonatomic, copy) NSString *orderCode;
/// 配送状态 0-商家已发货，骑手正在取货 1-配送中 2-已完成 3-已取消
@property (nonatomic, assign) TNDeliveryStatus deliveryStatus;
/// 配送状态国际化化文案
@property (nonatomic, copy) NSString *deliveryStatusMsg;
///  配送站城市
@property (nonatomic, copy) NSString *city;
/// stationName
@property (nonatomic, copy) NSString *stationName;

/// 骑手ID
@property (nonatomic, copy) NSString *riderId;
/// 骑手名称
@property (nonatomic, copy) NSString *riderName;
/// riderPhone
@property (nonatomic, copy) NSString *riderPhone;
/// 自动派单标记 true=机派
@property (nonatomic, assign) BOOL autoFlag;
/// 起点经度
@property (nonatomic, copy) NSNumber *startLongitude;
/// 起点纬度
@property (nonatomic, copy) NSNumber *startLatitude;
/// 终点经度
@property (nonatomic, copy) NSNumber *endLongitude;
/// 终点纬度
@property (nonatomic, copy) NSNumber *endLatitude;
/// 目前经度
@property (nonatomic, copy) NSNumber *currentLongitude;
/// 目前纬度
@property (nonatomic, copy) NSNumber *currentLatitude;
///
@property (nonatomic, copy) NSString *riderOperatorNo;
@end

NS_ASSUME_NONNULL_END
