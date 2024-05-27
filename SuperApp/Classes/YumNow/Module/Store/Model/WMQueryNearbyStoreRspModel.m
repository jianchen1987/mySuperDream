//
//  WMQueryNearbyStoreRspModel.m
//  SuperApp
//
//  Created by VanJay on 2020/6/22.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMQueryNearbyStoreRspModel.h"


@implementation WMQueryNearbyStoreRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"list": WMStoreModel.class,
    };
}
@end

@implementation WMQueryNearbyStoreNewRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"list": WMNewStoreModel.class,
    };
}
@end

