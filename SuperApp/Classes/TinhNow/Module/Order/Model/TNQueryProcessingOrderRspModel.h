//
//  TNQueryProcessingOrderRspModel.h
//  SuperApp
//
//  Created by seeu on 2020/7/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNQueryProcessingOrderRspModel : TNRspModel
/// number
@property (nonatomic, strong) NSNumber *orderNum;

//************电商接口用 字段********************/
///待发货数量
@property (nonatomic, strong) NSNumber *shipmentCount;
///待审核数量
@property (nonatomic, strong) NSNumber *reviewCount;
///待收货数量
@property (nonatomic, strong) NSNumber *shippedCount;
///待付款数量
@property (nonatomic, strong) NSNumber *paymentCount;

/// 获取全部订单数量
- (NSInteger)getTotalOrderNum;
@end

NS_ASSUME_NONNULL_END
