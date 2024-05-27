//
//  TNGetShippingMethodsRspModel.m
//  SuperApp
//
//  Created by seeu on 2020/7/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNGetShippingMethodsRspModel.h"
#import "TNShippingMethodModel.h"


@implementation TNGetShippingMethodsRspModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"shippingMethods": [TNShippingMethodModel class]};
}

@end
