//
//  TNQueryProductReviewListRspModel.m
//  SuperApp
//
//  Created by seeu on 2020/7/27.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNQueryProductReviewListRspModel.h"
#import "TNProductReviewModel.h"


@implementation TNQueryProductReviewListRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"content": [TNProductReviewModel class]};
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"pageNum": @"pageNumber", @"pages": @"totalPages"};
}

@end
