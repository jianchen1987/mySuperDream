//
//  SANavigateCapacityResponse.m
//  SuperApp
//
//  Created by seeu on 2020/7/1.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SANavigateCapacityResponse.h"
#import "NSDate+SAExtension.h"
#import "SAWindowManager.h"
#import <HDKitCore/HDKitCore.h>


@interface SANavigateCapacityResponse ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *historyRoutes; ///< 历史路由

@end


@implementation SANavigateCapacityResponse
+ (NSDictionary<NSString *, NSString *> *)supportActionList {
    return @{@"navigationToRoute_": kHDWHResponseMethodOn};
}

- (void)navigationToRoute:(NSDictionary *)paramDict {
    if (!self.historyRoutes) {
        self.historyRoutes = [[NSMutableDictionary alloc] initWithCapacity:10];
    }
    NSString *route = [paramDict valueForKey:@"route"];
    NSString *lastTime = [self.historyRoutes objectForKey:route];
    NSString *nowTime = [[NSDate new] stringWithFormatStr:@"MMddHHmmss"];
    // 同一个指令一秒内只能执行一次
    if (nowTime.integerValue - lastTime.integerValue > 1) {
        HDLog(@"跳转路由:%@", route);
        [SAWindowManager openUrl:route withParameters:nil];
        [self.historyRoutes setObject:nowTime forKey:route];
    }
}

#pragma mark - private methods
- (void)removeCurrentWebView {
    if (self.webViewHost.navigationController) {
        [self.webViewHost.navigationController removeSpecificViewControllerClass:self.webViewHost.class onlyOnce:YES];
    }
}

@end
