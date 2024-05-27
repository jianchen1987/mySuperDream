//
//  GNReserveRspModel.h
//  SuperApp
//
//  Created by wmz on 2022/9/16.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNReserveRspModel : GNModel
///订单编号
@property (nonatomic, copy) NSString *orderNo;
///预约时间
@property (nonatomic, copy) NSString *reservationTime;
///预约人数
@property (nonatomic, copy) NSString *reservationNum;
///预约人名称
@property (nonatomic, copy) NSString *reservationUser;
///预约手机号
@property (nonatomic, copy) NSString *reservationPhone;

@end

NS_ASSUME_NONNULL_END
