//
//  GNReserveBuinessModel.h
//  SuperApp
//
//  Created by wmz on 2022/9/16.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface GNReserveBuinessModel : GNModel
///营业时间-天
@property (nonatomic, copy) NSArray<NSString *> *businessDay;
///营业时间-小时
@property (nonatomic, copy) NSArray<NSString *> *businessHours;

@end

NS_ASSUME_NONNULL_END
