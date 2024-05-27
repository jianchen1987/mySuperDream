//
//  WMOrderDetailReceiverModel.h
//  SuperApp
//
//  Created by VanJay on 2020/6/27.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderDetailReceiverModel : WMModel
/// 收货人地址
@property (nonatomic, copy) NSString *receiverAddress;
/// 收货人名称
@property (nonatomic, copy) NSString *receiverName;
/// 收货人电话
@property (nonatomic, copy) NSString *receiverPhone;
/// 地址编号
@property (nonatomic, copy) NSString *addressNo;
/// 收货人纬度
@property (nonatomic, strong) NSNumber *receiverLat;
/// 收货人经度
@property (nonatomic, strong) NSNumber *receiverLon;
/// 性别
@property (nonatomic, copy) SAGender gender;
/// 收货地址照片
@property (nonatomic, copy) NSArray<NSString *> *receiverPhotos;
@end

NS_ASSUME_NONNULL_END
