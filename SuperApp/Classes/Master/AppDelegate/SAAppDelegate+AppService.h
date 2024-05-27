//
//  SAAppDelegate+AppService.h
//  SuperApp
//
//  Created by VanJay on 2020/3/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAAppDelegate.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAAppDelegate (AppService)
/**
 初始化第三方服务
 */
- (void)initThirdPartyServiceWithApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
@end

NS_ASSUME_NONNULL_END
