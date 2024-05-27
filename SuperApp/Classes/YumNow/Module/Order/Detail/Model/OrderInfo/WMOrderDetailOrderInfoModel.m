//
//  WMOrderDetailOrderInfoModel.m
//  SuperApp
//
//  Created by VanJay on 2020/5/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderDetailOrderInfoModel.h"


@implementation WMOrderDetailOrderInfoModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"operationList": WMOrderDetailOperationEventModel.class,
    };
}
@end
