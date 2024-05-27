//
//  WMOrderDetailRefundInfoModel.m
//  SuperApp
//
//  Created by VanJay on 2020/6/27.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderDetailRefundInfoModel.h"


@implementation WMOrderDetailRefundInfoModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"refundEventList": WMOrderDetailRefundEventModel.class,
    };
}
@end
