//
//  PayWebViewVC.m
//  SuperApp
//
//  Created by Quin on 2021/11/28.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNWebViewController.h"
#import "PNCommonUtils.h"


@interface PNWebViewController ()
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, copy) NSString *htmlName;
@property (nonatomic, copy) NSString *navTitle;
@property (nonatomic, copy) NSString *url;
@end


@implementation PNWebViewController
#pragma mark - SAViewControllerRoutableProtocol
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;
    self.navTitle = [parameters objectForKey:@"navTitle"];

    self.htmlName = [parameters objectForKey:@"htmlName"];
    self.url = [parameters objectForKey:@"url"];

    return self;
}

#pragma mark - SAViewControllerProtocol
- (void)hd_setupViews {
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, HD_STATUSBAR_NAVBAR_HEIGHT, kScreenWidth, kScreenHeight - HD_STATUSBAR_NAVBAR_HEIGHT)];
    [self.view addSubview:self.webView];

    /// 优先 根据htmlName 来读取 url [多数是协议]
    NSString *urlStr = @"";
    if (WJIsStringNotEmpty(self.htmlName)) {
        urlStr = [PNCommonUtils getURLWithName:self.htmlName];
    }

    if (WJIsStringEmpty(urlStr) && WJIsStringNotEmpty(self.url)) {
        urlStr = self.url;
    }

    HDLog(@"🐱🐱加载了： %@", urlStr);

    if (urlStr.length > 0) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    }
}

#pragma mark - layout
- (void)updateViewConstraints {
    [super updateViewConstraints];
}

- (void)hd_setupNavigation {
    self.boldTitle = self.navTitle;
}

#pragma mark - HDViewControllerNavigationBarStyle
- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleWhite;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return NO;
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return NO;
}

@end
