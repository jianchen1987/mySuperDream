//
//  GNNewsPagingRspModel.m
//  SuperApp
//
//  Created by wmz on 2021/7/12.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNNewsPagingRspModel.h"


@implementation GNNewsPagingRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"list": GNNewsCellModel.class,
    };
}
@end
