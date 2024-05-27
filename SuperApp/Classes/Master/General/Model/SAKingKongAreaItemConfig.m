//
//  SAKingKongAreaItemConfig.m
//  SuperApp
//
//  Created by VanJay on 2020/4/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAKingKongAreaItemConfig.h"


@implementation SAKingKongAreaItemConfig
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"iconURL": @"icon",
        @"guideDesc": @"appFuncGuide",
        @"index": @"serial",
        @"cornerIconStyle": @"subIcon",
        @"cornerIconStartTime": @"startTime",
        @"cornerIconEndTime": @"endTime",
        @"name": @"appFuncName",
        @"url": @"location",
        @"cornerIconText": @"subIconText",
        @"cornerIconState": @"subIconState",
        @"identifier": @[@"identifier", @"id"]
    };
}

- (instancetype)init {
    if (self = [super init]) {
        _type = SAHomeDynamicShowTypeTwo;
    }
    return self;
}

@end
