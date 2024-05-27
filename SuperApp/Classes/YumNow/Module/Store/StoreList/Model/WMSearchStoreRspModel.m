//
//  WMSearchStoreRspModel.m
//  SuperApp
//
//  Created by VanJay on 2020/6/22.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMSearchStoreRspModel.h"


@implementation WMSearchStoreRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"list": WMStoreListItemModel.class,
    };
}
@end

@implementation WMSearchStoreNewRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"list": WMStoreListNewItemModel.class,
    };
}
@end
