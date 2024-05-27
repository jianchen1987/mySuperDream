//
//  TNNewIncomeRspModel.m
//  SuperApp
//
//  Created by 张杰 on 2022/9/28.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNNewIncomeRspModel.h"


@implementation TNNewIncomeRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list": [TNNewIncomeItemModel class]};
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"list": @[@"list", @"content"], @"pageNum": @[@"pageNumber", @"pageNum"], @"pages": @[@"totalPages", @"pages"]};
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


@implementation TNNewIncomeItemModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"objId": @"id"};
}
@end
