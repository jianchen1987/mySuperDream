//
//  TNMyHadReviewListRspModel.m
//  SuperApp
//
//  Created by 张杰 on 2021/3/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNMyHadReviewListRspModel.h"
#import "TNMyHadReviewModel.h"
#import "TNProductReviewModel.h"


@implementation TNMyHadReviewListRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list": [TNMyHadReviewModel class]};
}
- (NSArray<TNProductReviewModel *> *)getTransformProductReviewList {
    NSMutableArray *arr = [NSMutableArray array];
    if (!HDIsArrayEmpty(self.list)) {
        for (TNMyHadReviewModel *model in self.list) {
            TNProductReviewModel *reviewModel = [TNProductReviewModel transformModelWithMyReviewModel:model];
            [arr addObject:reviewModel];
        }
    }
    return arr;
}
@end
