//
//  GNArticlePagingRspModel.m
//  SuperApp
//
//  Created by wmz on 2022/5/31.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNArticlePagingRspModel.h"


@implementation GNArticlePagingRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"list": GNArticleModel.class,
    };
}
@end
