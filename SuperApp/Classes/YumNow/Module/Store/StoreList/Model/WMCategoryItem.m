//
//  WMCategoryItem.m
//  SuperApp
//
//  Created by VanJay on 2020/4/27.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMCategoryItem.h"


@implementation WMCategoryItem
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"subClassifications": WMCategoryItem.class,
    };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"message": @"classificationName"};
}
@end
