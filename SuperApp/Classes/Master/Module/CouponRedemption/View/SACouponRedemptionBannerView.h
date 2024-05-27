//
//  SACouponRedemptionView.h
//  SuperApp
//
//  Created by Chaos on 2021/1/14.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN
@class SACouponRedemptionRspModel;


@interface SACouponRedemptionBannerView : SAView

/// 业务线类型
@property (nonatomic, copy) SAClientType clientType;
@property (nonatomic, strong) SACouponRedemptionRspModel *model;

@end

NS_ASSUME_NONNULL_END
