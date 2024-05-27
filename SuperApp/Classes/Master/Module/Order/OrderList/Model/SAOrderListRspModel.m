//
//  SAOrderListRspModel.m
//  SuperApp
//
//  Created by VanJay on 2020/4/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAOrderListRspModel.h"


@implementation SAOrderListRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list": SAOrderModel.class};
}
@end
