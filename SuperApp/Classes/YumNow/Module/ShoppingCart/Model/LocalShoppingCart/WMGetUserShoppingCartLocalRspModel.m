//
//  WMGetUserShoppingCartLocalRspModel.m
//  SuperApp
//
//  Created by VanJay on 2020/6/1.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMGetUserShoppingCartLocalRspModel.h"


@implementation WMGetUserShoppingCartLocalRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"list": WMShoppingCartStoreQueryItem.class,
    };
}
@end
