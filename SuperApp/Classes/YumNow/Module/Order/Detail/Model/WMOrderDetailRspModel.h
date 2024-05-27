//
//  WMOrderDetailRspModel.h
//  SuperApp
//
//  Created by VanJay on 2020/5/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderDetailDiscountInfoModel.h"
#import "WMOrderDetailModel.h"
#import "WMOrderDetailOrderInfoModel.h"
#import "WMOrderDetailStoreDetailModel.h"
#import "WMRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderDetailRspModel : WMRspModel
/// 订单详情
@property (nonatomic, strong) WMOrderDetailModel *orderDetailForUser;
/// 优惠详情
@property (nonatomic, strong) WMOrderDetailDiscountInfoModel *discountInfo;
/// 订单信息
@property (nonatomic, strong) WMOrderDetailOrderInfoModel *orderInfo;
/// 门店信息
@property (nonatomic, strong) WMOrderDetailStoreDetailModel *merchantStoreDetail;
@end

NS_ASSUME_NONNULL_END
