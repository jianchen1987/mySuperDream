//
//  WMThemeModel.m
//  SuperApp
//
//  Created by wmz on 2022/3/10.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMThemeModel.h"


@implementation WMThemeModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"brand": WMBrandThemeModel.class,
        @"store": WMStoreThemeModel.class,
        @"product": WMProductThemeModel.class,
    };
}
@end
