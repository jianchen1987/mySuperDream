//
//  Target_NoTargetAction.m
//  SuperApp
//
//  Created by VanJay on 2020/3/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "Target_NoTargetAction.h"
#import "SATalkingData.h"

#import <HDKitCore/HDLog.h>


@implementation Target_NoTargetAction
- (void)action_response:(NSDictionary *)params {
    HDLog(@"无 target 或者 无 action 响应，%@", params);
    NSString *target = params[@"targetString"];
    NSString *selector = params[@"selectorString"];
    [SATalkingData trackEvent:@"无效的路由" label:@"" parameters:@{@"target": (target && target.length > 0) ? target : @"", @"selector": (selector && selector.length > 0) ? selector : @""}];
}
@end
