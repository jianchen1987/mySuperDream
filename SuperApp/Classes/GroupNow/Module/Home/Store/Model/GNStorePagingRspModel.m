//
//  GNStorePagingRspModel.m
//  SuperApp
//
//  Created by wmz on 2021/6/11.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNStorePagingRspModel.h"


@implementation GNStorePagingRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"list": GNStoreCellModel.class,
    };
}
@end
