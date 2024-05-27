//
//  WMOrderDetailProductModel.m
//  SuperApp
//
//  Created by VanJay on 2020/6/27.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderDetailProductModel.h"


@implementation WMOrderDetailProductModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"propertyList": WMOrderDetailProductPropertyModel.class,
    };
}
@end
