//
//  SAAppDelegate+URLProtocol.h
//  SuperApp
//
//  Created by Tia on 2022/7/5.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAAppDelegate.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAAppDelegate (URLProtocol)

- (void)initCustomURLProtocol:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

@end

NS_ASSUME_NONNULL_END
