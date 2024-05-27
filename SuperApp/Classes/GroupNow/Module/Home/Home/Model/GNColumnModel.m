//
//  GNColumnModel.m
//  SuperApp
//
//  Created by wmz on 2022/5/30.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNColumnModel.h"


@implementation GNColumnModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"columnType": GNMessageCode.class,
    };
}
@end
