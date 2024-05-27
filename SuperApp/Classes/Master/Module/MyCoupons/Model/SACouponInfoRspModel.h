//
//  SACouponInfoRspModel.h
//  SuperApp
//
//  Created by VanJay on 2020/4/10.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SARspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SACouponInfoRspModel : SARspModel
/// 现金券数量
@property (nonatomic, strong) NSNumber *cashCouponAmount;
/// 折扣券数量
@property (nonatomic, strong) NSNumber *discountCouponAmount;
@end

NS_ASSUME_NONNULL_END
