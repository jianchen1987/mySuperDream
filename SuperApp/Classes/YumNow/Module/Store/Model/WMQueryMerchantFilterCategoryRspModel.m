//
//  WMQueryMerchantFilterCategoryRspModel.m
//  SuperApp
//
//  Created by seeu on 2020/8/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMQueryMerchantFilterCategoryRspModel.h"
#import "WMCategoryItem.h"


@implementation WMQueryMerchantFilterCategoryRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"list": WMCategoryItem.class,
    };
}
@end
