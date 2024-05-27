//
//  SACouponRedemptionViewModel.h
//  SuperApp
//
//  Created by Chaos on 2021/1/14.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAViewModel.h"
#import "SACouponTicketModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SACouponRedemptionViewModel : SAViewModel

/// 数据源
@property (nonatomic, strong) NSArray<SACouponTicketModel *> *dataSource;

@end

NS_ASSUME_NONNULL_END
