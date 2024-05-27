//
//  HDBaseHtmlVC.m
//  ViPayMerchant
//
//  Created by 谢 on 2018/7/9.
//  Copyright © 2018年 混沌网络科技. All rights reserved.
//

#import "HDBaseHtmlVC.h"
//#import "SAAppEnvManager.h"
#import "HDAppTheme.h"
//#import "HDCommonMacro.h"
#import "HDTalkingData.h"
#import "HDWebResponseModel.h"
#import "HDWebServiceClass.h"
#import "InternationalManager.h"
#import "NSDate+Extension.h"
#import "PNMultiLanguageManager.h" //语言
#import "TalkingData.h"
#import "UIColor+HDKitCore.h"
#import "UIView+HD_Placeholder.h"
#import "WalletVC.h"
#import "payTypedef.h"


@interface HDBaseHtmlVC ()
@property (nonatomic, strong) HDWebServiceClass *webSer;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, assign) BOOL navhiddenState;
@property (nonatomic, strong) NSMutableURLRequest *request; ///< 请求
@end


@implementation HDBaseHtmlVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(back) name:kNOTIFICATIONSuccessWebPay object:nil];
}
- (void)back {
    [self.navigationController popToViewControllerClass:WalletVC.class animated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 设置返回按钮为 X
    //    [self setNavLeftBtnImage:[UIImage imageNamed:@"x"] title:nil];
}
- (void)hd_setupNavigation {
    self.hd_backButtonImage = [UIImage imageNamed:@"x"];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    //    self.navhiddenState = self.navigationController.navigationBarHidden;
    //    [self.navigationController setNavigationBarHidden:NO];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNOTIFICATIONSuccessWebPay object:nil];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];

    if (self.request) {
        self.request = nil;
    }

    if (self.webView) {
        self.webView = nil;
    }
}

- (BOOL)shouldHideNavigationBarBottomShadow {
    return NO;
}

- (void)updateViewConstraints {
    [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];

    [self.progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1.5);
    }];

    [super updateViewConstraints];
}

/** 初始化 */
- (void)initialize {
    self.allServiceArray = [NSMutableArray array];

    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];

    NSArray<NSString *> *data = @[LANGUAGE_ENGLISH, LANGUAGE_KHR, LANGUAGE_CHINESE];
    NSDictionary *Dic;
    for (int i = 0; i < 3; i++) {
        if ([PNLocalizedString(@"languageName", @"") isEqualToString:data[i]]) {
            Dic = @{
                @"lang": [NSString stringWithFormat:@"%d", i],
            };
            break;
        }
    }

    if ([self.url rangeOfString:@"?"].length) {
        self.url = [NSString stringWithFormat:@"%@&lang=%@", self.url, Dic[@"lang"]];

    } else {
        self.url = [NSString stringWithFormat:@"%@?lang=%@", self.url, Dic[@"lang"]];
    }

    // 2.创建URL
    NSURL *url = [NSURL URLWithString:self.url];
    // 3.创建Request
    self.request = [NSMutableURLRequest requestWithURL:url];
    self.request.timeoutInterval = 10;
    [self.request setValue:SAMultiLanguageManager.currentLanguage forHTTPHeaderField:@"Accept-Language"];

    NSString *ua = [NSString stringWithFormat:@" vipay/%@ ", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];

    if (@available(iOS 12.0, *)) {
        NSString *baseAgent = [self.webView valueForKey:@"applicationNameForUserAgent"];
        NSString *userAgent = [NSString stringWithFormat:@"%@%@", baseAgent, ua];
        [self.webView setValue:userAgent forKey:@"applicationNameForUserAgent"];
    }

    if (@available(iOS 9.0, *)) {
        __weak __typeof(self) weakSelf = self;
        [self.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable result, NSError *_Nullable error) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (!error) {
                HDLog(@"获取UA成功:%@", result);
                if ([result rangeOfString:ua].location == NSNotFound) {
                    [strongSelf.webView setCustomUserAgent:[result stringByAppendingString:ua]];
                }
            } else {
                [strongSelf.webView setCustomUserAgent:ua];
            }
            [strongSelf.webView loadRequest:strongSelf.request];
        }];
    } else {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:ua, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dic];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.webView setValue:ua forKey:@"applicationNameForUserAgent"];
        [self.webView loadRequest:self.request];
    }
}

#pragma mark - 测试用
/** 摇晃刷新 */
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
#ifdef DEBUG
    //#if EnableDebug
    if (UIEventSubtypeMotionShake == motion) {
        [NAT showAlertWithMessage:@"刷新网页 ？(Debug 才会出现)" confirmButtonTitle:@"刷" confirmButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
            [alertView dismiss];
            [self.webView reload];
        } cancelButtonTitle:nil cancelButtonHandler:nil];
    }
//#endif
#endif
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    HDLog(@"页面导航决策: %@", navigationAction.request.URL.absoluteString);

    if (@available(iOS 9, *)) {
        // HDLog(@"customUserAgent: %@", webView.customUserAgent);
    }

    // HDLog(@"请求头: %@", navigationAction.request.allHTTPHeaderFields);
    // 非vipay指令放行，非 vipay 协议头开头直接打开
    if (![@"vipay" isEqualToString:navigationAction.request.URL.scheme.lowercaseString]) {
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }

    // 能到这里都是 vipay 协议头，进行数据处理
    NSString *queryString = [navigationAction.request.URL query];
    //    HDLog(@"queryString: %@", queryString);
    NSString *parameterString = [queryString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    HDLog(@"type: %@", navigationAction.request.URL.host);

    NSString *callBackId;
    NSDictionary *data;
    NSDictionary *paramDictionary;

    if (HDIsStringNotEmpty(parameterString)) {
        data = [self queryStringToDictionary:parameterString];
        if (!data) {
            HDLog(@"无参数无需处理");
            decisionHandler(WKNavigationActionPolicyAllow);
            return;
        }
        if (![data.allKeys containsObject:@"callBackId"]) {
            decisionHandler(WKNavigationActionPolicyAllow);
            return;
        }
        callBackId = data[@"callBackId"];
        NSString *param = data[@"param"];
        NSData *jsonData = [param dataUsingEncoding:NSUTF8StringEncoding];
        paramDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    NSString *type = navigationAction.request.URL.host;
    HDWebResponseModel *model = [[HDWebResponseModel alloc] init];
    model.callBackId = callBackId;
    model.resFnName = data[@"resFnName"];
    model.param = paramDictionary;
    model.ServiceCode = type;

    // 根据type生成处理一级指令的对象
    HDWebServiceClass *webService = [HDWebServiceClass webServiceParameter:model viewController:self];

    if (webService) {
        // 创建成功，加入处理队列
        [self.allServiceArray addObject:webService.webFeatureClass];

        __weak __typeof(self) weakSelf = self;

        // 开始执行指令
        [webService.webFeatureClass webFeatureResponseAction:^(HDWebFeatureClass *webFeature, NSString *responseString) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;

            if (webFeature.isCompleteResponseDestroyMonitor) { // 当为YES时候可以抛弃
                [strongSelf.allServiceArray removeObject:webFeature];
            }
            [strongSelf.webView evaluateJavaScript:responseString completionHandler:^(id _Nullable response, NSError *_Nullable error) {
                HDLog(@"webView 执行 %@ 结果：%@", responseString, error ? @"失败" : @"成功");
            }];
        }];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    self.boldTitle = @"Loading";
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if ([self.boldTitle isEqualToString:@"Loading"] || HDIsStringEmpty(self.boldTitle)) {
        self.boldTitle = webView.title;
    }
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    [HDTalkingData trackEvent:@"H5请求失败" label:webView.URL.absoluteString];
    if ([webView.URL.absoluteString hasPrefix:@"http"]) {
        [self showLoadingFailedPage];
        [self cleanCacheAndCookie];
    } else {
        HDLog(@"异常跳转，不处理:%@", webView.URL.absoluteString);
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    // 重复发起请求会cancel掉上一次，cancel掉的请求也会进来这里，需要做判断过滤掉
    if ([webView.URL.absoluteString hasPrefix:@"http"] && error.code != NSURLErrorCancelled) {
        [self showLoadingFailedPage];
        [self cleanCacheAndCookie];
    } else {
        HDLog(@"异常跳转，不处理:%@", webView.URL.absoluteString);
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        } else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}

#pragma mark - private methods
- (void)reloadPage {
    [self.webView loadRequest:self.request];
}
/** 展示网络失败 */
- (void)showLoadingFailedPage {
    UIViewPlaceholderViewModel *model = [[UIViewPlaceholderViewModel alloc] init];
    model.title = HDLocalizedString(@"ERROR_MSG_NETWORK_FAIL", @"网络连接失败", nil);
    model.needRefreshBtn = true;
    [self.webView hd_showPlaceholderViewWithModel:model];
    __weak __typeof(self) weakSelf = self;
    self.webView.hd_tappedRefreshBtnHandler = ^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf reloadPage];
    };
}

// get参数转字典
- (NSMutableDictionary *)queryStringToDictionary:(NSString *)string {
    HDLog(@"指令参数 = = = = = = = %@", string);
    NSMutableDictionary *retval;
    if ([string rangeOfString:@"&"].location != NSNotFound) {
        NSMutableArray *elements = (NSMutableArray *)[string componentsSeparatedByString:@"&"];
        retval = [NSMutableDictionary dictionaryWithCapacity:[elements count]];
        for (NSString *e in elements) {
            NSRange range = [e rangeOfString:@"="];
            NSString *key = [e substringWithRange:NSMakeRange(0, range.location)];
            NSString *value = [e substringWithRange:NSMakeRange(range.location + 1, e.length - range.location - 1)];
            [retval setObject:value forKey:key];
        }
    } else if ([string rangeOfString:@"="].location != NSNotFound) { // 只有一组参数
        NSArray *arr = [string componentsSeparatedByString:@"="];
        retval = [NSMutableDictionary dictionaryWithCapacity:1];
        if (arr.count > 1) {
            [retval setObject:arr[0] forKey:arr[1]];
        }
    }
    return retval;
}

/**
 获取url的所有参数
 @param url 需要提取参数的url
 @return NSDictionary
 */
- (NSDictionary *)parameterWithURL:(NSURL *)url {
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];

    // 传入url创建url组件类
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:url.absoluteString];

    // 回调遍历所有参数，添加入字典
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [parm setObject:obj.value forKey:obj.name];
    }];

    return parm;
}

/**清除缓存和cookie*/
- (void)cleanCacheAndCookie {
    if (@available(iOS 9.0, *)) {
        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        // Date from
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        // Execute
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            // Done
        }];
    } else {
        // 清除cookies
        NSHTTPCookie *cookie;
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [storage cookies]) {
            [storage deleteCookie:cookie];
        }
        // 清除WebView的缓存
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        NSURLCache *cache = [NSURLCache sharedURLCache];
        [cache removeAllCachedResponses];
        [cache setDiskCapacity:0];
        [cache setMemoryCapacity:0];
    }
}

#pragma mark - lazy load
- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
        _progressView.tintColor = [UIColor hd_colorWithHexString:@"#FD7127"];
        _progressView.trackTintColor = [UIColor whiteColor];
    }
    return _progressView;
}

- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
        configuration.allowsInlineMediaPlayback = YES;

        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGRectGetHeight(self.view.frame)) configuration:configuration];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.allowsBackForwardNavigationGestures = YES;
        _webView.scrollView.bounces = NO;
    }

    return _webView;
}
@end
