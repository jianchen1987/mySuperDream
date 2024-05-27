//
//  PNWaterBillModel.h
//  SuperApp
//  账单返回的model
//  Created by xixi_wen on 2022/3/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNBalancesInfoModel.h"
#import "PNCustomerInfoModel.h"
#import "PNModel.h"
#import "PNSupplierInfoModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface PNGamePasswordModel : PNModel
/// 外部流水号
@property (nonatomic, copy) NSString *refNo;
/// 卡密
@property (nonatomic, copy) NSString *customerName;
/// 游戏区域
@property (nonatomic, copy) NSString *zoneId;
/// 娱乐缴费组别 10为pinBase 11为pinLess
@property (nonatomic, assign) NSInteger group;
@end


@interface PNWaterBillModel : PNModel

@property (nonatomic, strong) PNSupplierInfoModel *supplier;
@property (nonatomic, strong) PNCustomerInfoModel *customer;
@property (nonatomic, strong) NSArray<PNBalancesInfoModel *> *balances;
/// 娱乐缴费卡密
@property (strong, nonatomic) PNGamePasswordModel *cardPasswordEntertainmentRespDTO;
@end

NS_ASSUME_NONNULL_END
