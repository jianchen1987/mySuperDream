//
//  PNPagingRspModel.m
//  SuperApp
//
//  Created by 张杰 on 2022/6/28.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPagingRspModel.h"


@implementation PNPagingRspModel
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    if (self.pageNum >= self.pages) {
        self.hasNextPage = NO;
    } else {
        self.hasNextPage = YES;
    }
    return YES;
}
@end
