//
//  WMStoreProductModel.m
//  SuperApp
//
//  Created by VanJay on 2020/4/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreProductModel.h"


@implementation WMStoreProductModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"productId": @"id", @"nameEn": @"name"};
}
@end
