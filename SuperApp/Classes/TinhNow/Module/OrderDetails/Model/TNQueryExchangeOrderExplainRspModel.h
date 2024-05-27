//
//  TNQueryExchangeOrderExplainRspModel.h
//  SuperApp
//
//  Created by seeu on 2020/7/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNQueryExchangeOrderExplainRspModel : TNRspModel

/// 电话号码
@property (nonatomic, strong) NSArray<NSString *> *servicePhones;
/// 介绍
@property (nonatomic, strong) NSArray<NSString *> *instructions;

@end

NS_ASSUME_NONNULL_END
