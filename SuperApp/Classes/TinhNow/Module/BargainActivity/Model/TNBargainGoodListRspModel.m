//
//  TNBargainGoodListRspModel.m
//  SuperApp
//
//  Created by 张杰 on 2020/11/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNBargainGoodListRspModel.h"
#import "TNBargainGoodModel.h"


@implementation TNBargainGoodListRspModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"pageSize": @"size", @"pageNum": @"current"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"records": [TNBargainGoodModel class]};
}
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    if (self.pageNum >= self.pages) {
        self.hasNextPage = NO;
    } else {
        self.hasNextPage = YES;
    }

    return YES;
}
@end
