//
//  TNOrderDetailsShippingInfoModel.h
//  SuperApp
//
//  Created by seeu on 2020/7/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNCodingModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNOrderDetailsShippingInfoModel : TNCodingModel
/// 地址
@property (nonatomic, copy) NSString *address;
/// 电话
@property (nonatomic, copy) NSString *phone;
/// 配送方式
@property (nonatomic, copy) NSString *shippingMethodName;
/// 联系人
@property (nonatomic, copy) NSString *consignee;
/// 配送费
@property (nonatomic, strong) SAMoneyModel *freight;
/// 地区
@property (nonatomic, copy) NSString *areaName;
/// 邮编
@property (nonatomic, copy) NSString *zipCode;
@end

NS_ASSUME_NONNULL_END
