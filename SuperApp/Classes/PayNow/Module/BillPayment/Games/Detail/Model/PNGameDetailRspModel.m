//
//  PNGameDetailRspModel.m
//  SuperApp
//
//  Created by 张杰 on 2022/12/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNGameDetailRspModel.h"


@implementation PNGameItemModel
- (void)setGroup:(NSString *)group {
    _group = group;
    if ([group isEqualToString:@"direct"]) {
        self.isPinless = YES;
    } else {
        self.isPinless = NO;
    }
}
@end


@implementation PNGameDetailRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"item": [PNGameItemModel class]};
}
@end
