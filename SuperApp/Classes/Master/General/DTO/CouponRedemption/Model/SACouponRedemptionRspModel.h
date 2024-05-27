//
//  SACouponRedemptionRspModel.h
//  SuperApp
//
//  Created by Chaos on 2021/1/12.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SARspModel.h"
#import "SACouponTicketModel.h"
#import "SAInternationalizationModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SACouponRedemptionRspModel : SARspModel

/// 活动名称
@property (nonatomic, strong) SAInternationalizationModel *activityName;
/// 列表
@property (nonatomic, strong) NSArray<SACouponTicketModel *> *list;

@end

NS_ASSUME_NONNULL_END
