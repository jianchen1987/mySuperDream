//
//  SACheckUserStatusRspModel.m
//  SuperApp
//
//  Created by VanJay on 2020/4/9.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SACheckUserStatusRspModel.h"


@implementation SACheckUserStatusRspModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"isActive": @"active", @"isRegistered": @"register"};
}
@end
