//
//  WMOrderDetailDeliveryRiderRspModel.h
//  SuperApp
//
//  Created by VanJay on 2020/5/20.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderDetailDeliveryRiderRspModel : WMRspModel
/// 纬度
@property (nonatomic, strong) NSNumber *lat;
/// 经度
@property (nonatomic, strong) NSNumber *lon;
/// 进行中的订单数量
@property (nonatomic, assign) NSUInteger processingOrderCount;
/// 骑手id
@property (nonatomic, copy) NSString *riderId;
@end

NS_ASSUME_NONNULL_END
