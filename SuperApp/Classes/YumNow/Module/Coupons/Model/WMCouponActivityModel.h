//
//  WMCouponActivityModel.h
//  SuperApp
//
//  Created by wmz on 2022/7/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMCouponActivityContentModel.h"
#import "WMRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMCouponActivityModel : WMRspModel
///是否还能领券
@property (nonatomic, assign) BOOL canReceiveCoupon;
///领券活动相关信息
@property (nonatomic, copy) NSArray<WMCouponActivityContentModel *> *activityContents;

@end

NS_ASSUME_NONNULL_END
