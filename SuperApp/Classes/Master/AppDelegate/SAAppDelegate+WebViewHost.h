//
//  SAAppDelegate+WebViewHost.h
//  SuperApp
//
//  Created by seeu on 2020/7/1.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAAppDelegate.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAAppDelegate (WebViewHost)
- (void)initWebViewHost:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
@end

NS_ASSUME_NONNULL_END
