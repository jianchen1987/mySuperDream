//
//  TNFirstLevelCategoryModel.m
//  SuperApp
//
//  Created by 谢泽锋 on 2020/10/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNFirstLevelCategoryModel.h"


@implementation TNFirstLevelCategoryModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"categoryId": @"id"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"children": [TNSecondLevelCategoryModel class]};
}
@end
