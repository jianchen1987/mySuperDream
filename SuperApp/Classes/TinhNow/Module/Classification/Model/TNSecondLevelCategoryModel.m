//
//  TNSecondLevelCategoryModel.m
//  SuperApp
//
//  Created by 谢泽锋 on 2020/10/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNSecondLevelCategoryModel.h"


@implementation TNSecondLevelCategoryModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"categoryId": @"id", @"productCategories": @[@"productCategories", @"children"]}; //兼容字段
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"productCategories": [TNCategoryModel class],
        @"brands": [TNCategoryModel class]

    };
}
@end
