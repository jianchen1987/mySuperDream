//
//  WMStoreReviewsRepModel.m
//  SuperApp
//
//  Created by Chaos on 2020/6/13.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreReviewsRepModel.h"
#import "WMStoreProductReviewModel.h"


@implementation WMStoreReviewsRepModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"comments": WMStoreProductReviewModel.class,
    };
}

@end
