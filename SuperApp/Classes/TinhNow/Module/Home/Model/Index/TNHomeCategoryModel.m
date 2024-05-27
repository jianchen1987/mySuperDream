//
//  TNHomeCategoryModel.m
//  SuperApp
//
//  Created by 张杰 on 2021/2/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNHomeCategoryModel.h"


@implementation TNHomeCategoryModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"categoryId": @"id"};
}
@end
