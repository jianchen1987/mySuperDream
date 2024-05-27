//
//  HDCheckstandWebViewController.m
//  SuperApp
//
//  Created by seeu on 2020/9/1.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDCheckstandWebViewController.h"
#import "SAWindowManager.h"


@interface HDCheckstandWebViewController ()

@end


@implementation HDCheckstandWebViewController

- (instancetype)init {
    self = [super init];
    self.disableGesture = NO;
    self.backButtonStyle = HDWebViewBakcButtonStyleClose;
    return self;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if ([@"superapp" isEqualToString:navigationAction.request.URL.scheme.lowercaseString]) {
        // superapp://SuperApp/CashierResult
        if ([navigationAction.request.URL.absoluteString.lowercaseString hasPrefix:[@"superapp://SuperApp/CashierResult" lowercaseString]] && self.closeByUser) {
            [self close];
        } else {
            [SAWindowManager openUrl:navigationAction.request.URL.absoluteString withParameters:nil];
        }

        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        [super webView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
    }
}

@end
