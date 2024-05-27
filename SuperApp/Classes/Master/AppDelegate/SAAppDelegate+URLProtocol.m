//
//  SAAppDelegate+URLProtocol.m
//  SuperApp
//
//  Created by Tia on 2022/7/5.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAAppDelegate+URLProtocol.h"
#import "SAHTTPSURLProtocol.h"
#import <HDServiceKit/HDNetworkSessionConfigurationManager.h>


@implementation SAAppDelegate (URLProtocol)

- (void)initCustomURLProtocol:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //网络请求注入协议
    [[HDNetworkSessionConfigurationManager sharedManager] addCustomURLProtocolClass:SAHTTPSURLProtocol.class];
}

@end
