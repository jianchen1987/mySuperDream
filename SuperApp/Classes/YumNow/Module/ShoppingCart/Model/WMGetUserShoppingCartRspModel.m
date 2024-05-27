//
//  WMGetUserShoppingCartRspModel.m
//  SuperApp
//
//  Created by VanJay on 2020/5/13.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMGetUserShoppingCartRspModel.h"


@implementation WMGetUserShoppingCartRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"list": WMShoppingCartStoreItem.class,
    };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"list": @"merchantCartDTOS"};
}
@end
