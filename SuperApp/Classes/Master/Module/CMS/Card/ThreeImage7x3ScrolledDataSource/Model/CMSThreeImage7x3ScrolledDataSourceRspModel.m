//
//  CMSThreeImage7x3ScrolledDataSourceRspModel.m
//  SuperApp
//
//  Created by Chaos on 2021/7/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "CMSThreeImage7x3ScrolledDataSourceRspModel.h"
#import "CMSThreeImage7x3ItemConfig.h"


@implementation CMSThreeImage7x3ScrolledDataSourceRspModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"nodes": CMSThreeImage7x3ItemConfig.class,
    };
}

@end
