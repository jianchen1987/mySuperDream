//
//  GNOrderPagingRspModel.m
//  SuperApp
//
//  Created by wmz on 2021/6/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNOrderPagingRspModel.h"


@implementation GNOrderPagingRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"list": GNOrderCellModel.class,
    };
}
@end
