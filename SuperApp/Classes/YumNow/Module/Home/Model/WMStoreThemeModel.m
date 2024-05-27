//
//  WMStoreThemeModel.m
//  SuperApp
//
//  Created by wmz on 2022/3/10.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMStoreThemeModel.h"


@implementation WMStoreThemeModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"promotions": WMStoreDetailPromotionModel.class,
    };
}
@end
