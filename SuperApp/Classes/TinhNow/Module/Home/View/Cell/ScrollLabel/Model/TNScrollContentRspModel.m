//
//  TNScrollContentRspModel.m
//  SuperApp
//
//  Created by Chaos on 2020/7/6.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNScrollContentRspModel.h"
#import "TNScrollContentModel.h"


@implementation TNScrollContentRspModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list": [TNScrollContentModel class]};
}
- (CGFloat)cellHeight {
    return 40;
}
@end
