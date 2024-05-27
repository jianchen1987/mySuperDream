//
//  GNCommentPagingRspModel.m
//  SuperApp
//
//  Created by wmz on 2021/9/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNCommentPagingRspModel.h"


@implementation GNCommentPagingRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"list": GNCommentModel.class,
    };
}
@end
