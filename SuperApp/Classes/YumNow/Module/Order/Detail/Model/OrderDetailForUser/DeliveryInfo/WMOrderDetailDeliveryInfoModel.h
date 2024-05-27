//
//  WMOrderDetailDeliveryInfoModel.h
//  SuperApp
//
//  Created by VanJay on 2020/6/27.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"
#import "WMOrderDetailRiderModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderDetailDeliveryInfoModel : WMModel
/// 骑手电话
@property (nonatomic, copy) NSString *riderPhone;
/// 预计到达时间
@property (nonatomic, assign) NSTimeInterval eta;
/// 实际到达时间
@property (nonatomic, assign) NSTimeInterval ata;
/// 配送类型, 10: 商家配送, 11: 平台配送
@property (nonatomic, assign) WMDeliveryType deliverType;
/// 配送状态, 10: 待分配, 20: 待接单, 30: 已接单, 40: 已到店, 50: 配送中, 60: 已送达, 70: 已取消
@property (nonatomic, assign) WMDeliveryStatus deliveryStatus;
/// 派单时间
@property (nonatomic, assign) NSTimeInterval dispatchTime;
/// 骑手信息
@property (nonatomic, strong) WMOrderDetailRiderModel *rider;
/// 骑手接单超时时间
@property (nonatomic, assign) NSTimeInterval riderAcceptTimeoutDate;
/// 骑手到店时间
@property (nonatomic, assign) NSTimeInterval riderArrivedStoreTime;
/// 骑手取餐时间
@property (nonatomic, assign) NSTimeInterval riderPickUpTime;
/// 骑手接单时间
@property (nonatomic, assign) NSTimeInterval riderAcceptTime;

@end

NS_ASSUME_NONNULL_END
