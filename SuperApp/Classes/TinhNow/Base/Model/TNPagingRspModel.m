//
//  TNPagingRspModel.m
//  SuperApp
//
//  Created by seeu on 2020/6/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNPagingRspModel.h"


@implementation TNPagingRspModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"pageNum": @[@"pageNumber", @"pageNum"], @"pages": @[@"totalPages", @"pages", @"total"]};
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
