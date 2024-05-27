//
//  WMeatOnTimeThemeModel.m
//  SuperApp
//
//  Created by wmz on 2022/3/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMeatOnTimeThemeModel.h"


@implementation WMeatOnTimeThemeModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"rel": WMeatOnTimeModel.class,
    };
}
@end
