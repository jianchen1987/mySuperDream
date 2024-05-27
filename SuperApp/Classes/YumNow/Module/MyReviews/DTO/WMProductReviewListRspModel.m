//
//  WMProductReviewListRspModel.m
//  SuperApp
//
//  Created by VanJay on 2020/6/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMProductReviewListRspModel.h"


@implementation WMProductReviewListRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"list": WMStoreProductReviewModel.class,
    };
}
@end
