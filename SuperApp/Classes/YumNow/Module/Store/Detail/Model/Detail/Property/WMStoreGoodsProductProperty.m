//
//  WMStoreGoodsProductProperty.m
//  SuperApp
//
//  Created by VanJay on 2020/5/12.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreGoodsProductProperty.h"


@implementation WMStoreGoodsProductProperty
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"propertyId": @"id", @"optionList": @"selections"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"optionList": WMStoreGoodsProductPropertyOption.class,
    };
}

@end
