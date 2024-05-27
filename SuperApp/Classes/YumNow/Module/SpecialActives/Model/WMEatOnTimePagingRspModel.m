//
//  WMEatOnTimePagingRspModel.m
//  SuperApp
//
//  Created by wmz on 2022/3/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMEatOnTimePagingRspModel.h"


@implementation WMEatOnTimePagingRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"list": WMSpecialActivesProductModel.class,
    };
}
@end
