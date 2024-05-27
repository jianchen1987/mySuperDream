//
//  TNMyNotReviewListRspModel.m
//  SuperApp
//
//  Created by 张杰 on 2021/3/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNMyNotReviewListRspModel.h"
#import "TNMyNotReviewModel.h"


@implementation TNMyNotReviewListRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list": [TNMyNotReviewModel class]};
}
@end
