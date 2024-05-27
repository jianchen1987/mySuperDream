//
//  SAWindowRepModel.m
//  SuperApp
//
//  Created by Chaos on 2020/7/23.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAWindowRspModel.h"
#import "SAWindowModel.h"


@implementation SAWindowRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"list": SAWindowModel.class,
    };
}
@end
