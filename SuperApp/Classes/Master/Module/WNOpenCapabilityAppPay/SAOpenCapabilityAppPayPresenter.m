//
//  SAOpenCapabilityAppPayPresenter.m
//  SuperApp
//
//  Created by seeu on 2021/11/30.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAOpenCapabilityAppPayPresenter.h"
#import "SAAppPayViewController.h"

WNOpenCapability const WNOpenCapabilityAppPay = @"WNOpenCapabilityAppPay"; ///< WOWNOW开放能力，App支付


@implementation SAOpenCapabilityAppPayPresenter

+ (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    return [self processUniversalLink:url];
}

+ (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *_Nullable))restorationHandler {
    return [self processUniversalLink:userActivity.webpageURL];
}

+ (BOOL)processUniversalLink:(NSURL *)incomeUrl {
    NSURLComponents *components = [NSURLComponents componentsWithURL:incomeUrl resolvingAgainstBaseURL:YES];
    NSArray<NSURLQueryItem *> *appId = [components.queryItems hd_filterWithBlock:^BOOL(NSURLQueryItem *_Nonnull item) {
        return [item.name isEqualToString:@"appId"];
    }];
    NSArray<NSURLQueryItem *> *reqType = [components.queryItems hd_filterWithBlock:^BOOL(NSURLQueryItem *_Nonnull item) {
        return [item.name isEqualToString:@"type"];
    }];

    if (!appId.count || !reqType.count) {
        return NO;
    }

    if ([reqType.firstObject.value isEqualToString:WNOpenCapabilityAppPay]) {
        void (^startToPay)(void) = ^void(void) {
            // app支付
            NSArray<NSURLQueryItem *> *body = [components.queryItems hd_filterWithBlock:^BOOL(NSURLQueryItem *_Nonnull item) {
                return [item.name isEqualToString:@"body"];
            }];
            SAAppPayReqModel *reqModel = SAAppPayReqModel.new;
            reqModel.appId = appId.firstObject.value;
            reqModel.body = body.firstObject.value;

            SAAppPayViewController *vc = SAAppPayViewController.new;
            [vc payWithReqModel:reqModel];
        };

        if (![SAUser hasSignedIn]) {
            [SAWindowManager switchWindowToLoginViewControllerWithLoginToDoEvent:startToPay];
            return YES;
        } else {
            startToPay();
        }
    }

    return YES;
}

@end
