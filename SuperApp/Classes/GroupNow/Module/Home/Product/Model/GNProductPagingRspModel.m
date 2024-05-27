//
//  GNProductPagingRspModel.m
//  SuperApp
//
//  Created by wmz on 2022/6/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNProductPagingRspModel.h"


@implementation GNProductPagingRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"list": GNProductModel.class,
    };
}
@end
