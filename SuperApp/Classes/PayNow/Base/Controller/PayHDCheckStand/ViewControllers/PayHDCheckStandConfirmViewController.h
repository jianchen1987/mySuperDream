//
//  PayHDCheckstandConfirmViewController.h
//  customer
//
//  Created by VanJay on 2019/5/15.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "PayHDCheckstandBaseViewController.h"
@class PayHDTradeBuildOrderRspModel;

NS_ASSUME_NONNULL_BEGIN


@interface PayHDCheckstandConfirmViewController : PayHDCheckstandBaseViewController

+ (instancetype)checkStandWithTradeBuildModel:(PayHDTradeBuildOrderRspModel *)buildModel;
- (instancetype)initWithTradeBuildModel:(PayHDTradeBuildOrderRspModel *)buildModel;

@property (nonatomic, strong) PayHDTradeBuildOrderRspModel *buildModel; ///< 下单模型

@end

NS_ASSUME_NONNULL_END
