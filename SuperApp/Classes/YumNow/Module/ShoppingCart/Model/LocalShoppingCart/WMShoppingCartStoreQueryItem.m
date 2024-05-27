//
//  WMShoppingCartStoreQueryItem.m
//  SuperApp
//
//  Created by VanJay on 2020/6/1.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMShoppingCartStoreQueryItem.h"


@implementation WMShoppingCartStoreQueryItem
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"shopCartItemBOS": WMShoppingCartStoreQueryProduct.class,
    };
}
@end
