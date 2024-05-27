//
//  WMOrderSubmitCouponRspModel.h
//  SuperApp
//
//  Created by VanJay on 2020/5/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACommonPagingRspModel.h"
#import "WMOrderSubmitCouponModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderSubmitCouponRspModel : SACommonPagingRspModel
/// 优惠券列表
@property (nonatomic, copy) NSArray<WMOrderSubmitCouponModel *> *list;
@end

NS_ASSUME_NONNULL_END
