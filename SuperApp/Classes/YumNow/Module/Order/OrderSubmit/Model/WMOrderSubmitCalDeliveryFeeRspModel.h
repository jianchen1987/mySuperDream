//
//  WMOrderSubmitCalDeliveryFeeRspModel.h
//  SuperApp
//
//  Created by VanJay on 2020/5/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAMoneyModel.h"
#import "WMRspModel.h"
#import "SAInternationalizationModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface WMOrderSubmitCalDeliveryFeeRspModel : WMRspModel
/// 配送费
@property (nonatomic, strong) SAMoneyModel *deliverFee;
/// 配送时长
@property (nonatomic, assign) NSTimeInterval deliveryTime;
/// 距离
@property (nonatomic, assign) double distance;
/// 预计送达时间
@property (nonatomic, copy) NSString *estimatedArrivalTime;
/// 预计出餐时间
@property (nonatomic, copy) NSString *estimatedPreparedTime;
/// 是否在配送范围内
@property (nonatomic, copy) SABoolValue inRange;
/// 是否支持极速达配送服务
@property (nonatomic, copy) SABoolValue speedDelivery;
/// 增加配送费提示
@property (nonatomic, copy) NSString *inDeliveryStr;
/// 特殊区域配送费
@property (nonatomic, strong) SAMoneyModel *specialAreaDeliveryFee;
/// 特殊区域原因, 10: 配送高峰, 20: 天气异常, 30: 交通管制, 40: 疫情影响, 50: 小区复杂, 60: 其他
@property (nonatomic, copy) NSString *specialAreaReason;
/// 特殊区域配送费三语备注
@property (nonatomic, strong) SAInternationalizationModel *specialAreaDeliveryFeeRemark;
@end

NS_ASSUME_NONNULL_END
