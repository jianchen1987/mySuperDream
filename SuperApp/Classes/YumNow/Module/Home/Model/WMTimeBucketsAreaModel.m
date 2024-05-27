//
//  WMTimeBucketsAreaModel.m
//  SuperApp
//
//  Created by seeu on 2020/8/25.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMTimeBucketsAreaModel.h"
#import "WMTimeBucketsModel.h"


@implementation WMTimeBucketsAreaModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"recommendStores": WMTimeBucketsModel.class,
    };
}
@end
