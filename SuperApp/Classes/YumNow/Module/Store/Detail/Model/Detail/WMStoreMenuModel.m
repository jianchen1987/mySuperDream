//
//  WMStoreMenuModel.m
//  SuperApp
//
//  Created by VanJay on 2020/5/13.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreMenuModel.h"


@implementation WMStoreMenuModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"list": WMStoreGoodsItem.class,
    };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"list": @"productList"};
}
@end
