//
//  SAAppDelegate+WebViewHost.m
//  SuperApp
//
//  Created by seeu on 2020/7/1.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAAppDelegate+WebViewHost.h"
#import "SABaseCapacityResponse.h"
#import "SANavigateCapacityResponse.h"
#import "SAPaymentCapacityResponse.h"
#import "TNNavgationCapacityResponse.h"
#import "TNPaymentCapacityResponse.h"
#import "WMAddressHostResponse.h"
#import <HDServiceKit/HDServiceKit.h>


@implementation SAAppDelegate (WebViewHost)

- (void)initWebViewHost:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[HDWHResponseManager defaultManager] addCustomResponse:SAPaymentCapacityResponse.class];
    [[HDWHResponseManager defaultManager] addCustomResponse:SANavigateCapacityResponse.class];
    [[HDWHResponseManager defaultManager] addCustomResponse:SABaseCapacityResponse.class];
    [[HDWHResponseManager defaultManager] addCustomResponse:TNPaymentCapacityResponse.class];
    [[HDWHResponseManager defaultManager] addCustomResponse:TNNavgationCapacityResponse.class];
    [[HDWHResponseManager defaultManager] addCustomResponse:WMAddressHostResponse.class];
}
@end
