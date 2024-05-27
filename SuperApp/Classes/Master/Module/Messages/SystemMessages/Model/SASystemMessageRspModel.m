//
//  SASystemMessageRspModel.m
//  SuperApp
//
//  Created by VanJay on 2020/5/9.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SASystemMessageRspModel.h"


@implementation SASystemMessageRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"list": SASystemMessageModel.class,
    };
}
@end
