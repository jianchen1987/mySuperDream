//
//  SAQueryPaymentAvailableActivityRspMode.m
//  SuperApp
//
//  Created by seeu on 2022/5/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAQueryPaymentAvailableActivityRspModel.h"


@implementation SAQueryPaymentAvailableActivityRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"list": SAPaymentToolsActivityModel.class,
    };
}
@end
