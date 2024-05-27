//
//  WMSpecialBrandPagingModel.m
//  SuperApp
//
//  Created by wmz on 2022/3/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMSpecialBrandPagingModel.h"


@implementation WMSpecialBrandPagingModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"list": WMSpecialBrandModel.class,
    };
}
@end
