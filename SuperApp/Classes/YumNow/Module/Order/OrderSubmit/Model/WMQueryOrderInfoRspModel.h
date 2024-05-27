//
//  WMQueryOrderInfoRspModel.h
//  SuperApp
//
//  Created by VanJay on 2020/6/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMRspModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 预约时间
@interface WMOrderSubscribeTimeModel : WMModel
/// 时间
@property (nonatomic, copy) NSString *date;
/// 时间类型
@property (nonatomic, copy) WMOrderDeliveryTimeType type;
@end


@interface WMQueryOrderInfoRspModel : WMRspModel
/// 付款方式
@property (nonatomic, copy) NSArray<WMOrderAvailablePaymentType> *paymentMethods;
/// 时间
@property (nonatomic, copy) NSArray<WMOrderSubscribeTimeModel *> *availableTime;

@property (nonatomic, assign) double lat;

@property (nonatomic, assign) double lon;

@property (nonatomic, copy) NSString *address;

@end

NS_ASSUME_NONNULL_END
