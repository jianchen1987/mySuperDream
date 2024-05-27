//
//  WMOrderDetailModel.m
//  SuperApp
//
//  Created by VanJay on 2020/5/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderDetailModel.h"


@implementation WMOrderDetailModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"orderEventList": WMOrderEventModel.class,
    };
}
@end


@implementation WMUpdateAddressRefundInfo

@end
