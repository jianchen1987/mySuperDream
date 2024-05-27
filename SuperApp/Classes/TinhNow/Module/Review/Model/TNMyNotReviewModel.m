//
//  TNMyNotReviewModel.m
//  SuperApp
//
//  Created by 张杰 on 2021/3/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNMyNotReviewModel.h"


@implementation TNMyNotReviewStoreInfo

@end


@implementation TNMyNotReviewGoodInfo

@end


@implementation TNMyNotReviewModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"orderId": @"id"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"items": [TNMyNotReviewGoodInfo class]};
}
@end
