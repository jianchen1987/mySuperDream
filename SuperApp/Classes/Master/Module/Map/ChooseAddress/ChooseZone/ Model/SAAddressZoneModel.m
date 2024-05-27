//
//  SAAddressZoneModel.m
//  SuperApp
//
//  Created by Chaos on 2021/3/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAAddressZoneModel.h"


@implementation SAAddressZoneModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"children": SAAddressZoneModel.class,
    };
}

@end
