//
//  TNIncomeRspModel.m
//  SuperApp
//
//  Created by xixi_wen on 2021/12/15.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNIncomeRspModel.h"


@implementation TNIncomeRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list": [TNIncomeRecordItemModel class]};
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


@implementation TNIncomeRecordItemModel

@end
