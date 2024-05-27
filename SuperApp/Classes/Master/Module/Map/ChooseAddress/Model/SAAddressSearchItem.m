//
//  SAAddressSearchItem.m
//  SuperApp
//
//  Created by VanJay on 2020/5/8.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAAddressSearchItem.h"


@implementation SAAddressSearchItemComponent
@end


@implementation SAAddressSearchItemGeometryLocation
@end


@implementation SAAddressSearchItemGeometryViewport
@end


@implementation SAAddressSearchItemGeometry
@end


@implementation SAAddressSearchItemPlusCode
@end


@implementation SAAddressSearchItem
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"address_components": SAAddressSearchItemComponent.class,
    };
}
@end
