//
//  WMTimeBucketsRecommandRspModel.m
//  SuperApp
//
//  Created by seeu on 2020/8/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMTimeBucketsRecommandRspModel.h"
#import "WMTimeBucketsAreaModel.h"


@implementation WMTimeBucketsRecommandRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"list": WMTimeBucketsAreaModel.class,
    };
}
@end
