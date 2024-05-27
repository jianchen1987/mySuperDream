//
//  TNStoreSceneRspModel.m
//  SuperApp
//
//  Created by 张杰 on 2021/1/6.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNStoreSceneRspModel.h"
#import "TNStoreSceneModel.h"


@implementation TNStoreSceneRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"content": [TNStoreSceneModel class]};
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"pageNum": @"pageNumber", @"pages": @"totalPages"};
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
