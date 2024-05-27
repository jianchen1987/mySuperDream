//
//  TNProductDetailsIntroductionTableViewCell.m
//  SuperApp
//
//  Created by seeu on 2020/7/24.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNProductDetailsIntroductionTableViewCell.h"
#import "SAAppEnvManager.h"


@interface TNProductDetailsIntroductionTableViewCell () <WKNavigationDelegate, UIScrollViewDelegate>
/// webview
@property (nonatomic, strong) WKWebView *webView;
/// 是否已经加载过
@property (nonatomic, assign) BOOL hasLoaded;
@end


@implementation TNProductDetailsIntroductionTableViewCell
- (void)dealloc {
    self.webView.scrollView.delegate = nil;
}
- (void)hd_setupViews {
    NSMutableString *jScript = [NSMutableString string];
    //    [jScript appendString:@"document.documentElement.style.webkitTouchCallout='none';"]; //禁止长按preview
    //    [jScript appendString:@"document.documentElement.style.webkitUserSelect='none';"];//禁止选择
    [jScript appendString:@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width, initial-scale=1, maximum-scale=1, "
                          @"user-scalable=no, viewport-fit=cover'); document.getElementsByTagName('head')[0].appendChild(meta); var imgs = document.getElementsByTagName('img');for (var i in "
                          @"imgs){imgs[i].style.maxWidth='100%';imgs[i].style.height='auto';}; "];

    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];

    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    WKWebViewConfiguration *config = WKWebViewConfiguration.new;
    config.userContentController = wkUController;
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MIN) configuration:config];
    self.webView.navigationDelegate = self;
    self.webView.scrollView.delegate = self;
    self.webView.scrollView.scrollEnabled = NO;
    self.webView.scrollView.userInteractionEnabled = NO; //直接禁止所有点击
    [self.contentView addSubview:self.webView];
}

- (void)hd_bindViewModel {
    //通过监听网页的loading来获取高度  监听contentSize回调过多 且上下滑动 也会回调
    @HDWeakify(self);
    [self.KVOController hd_observe:self.webView keyPath:@"loading" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        [self.webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(NSNumber *_Nullable value, NSError *_Nullable error) {
            @HDStrongify(self);
            if (value != nil) {
                CGFloat heightValue = [value doubleValue];
                self.model.webViewHeight = heightValue;
                if (heightValue > 0) {
                    [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(heightValue);
                    }];
                }
                if (self.getWebViewHeightCallBack) {
                    self.getWebViewHeightCallBack();
                }
            }
        }];
    }];
}

- (void)updateConstraints {
    [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
        make.height.mas_equalTo(self.model != nil ? self.model.webViewHeight : 0);
    }];
    [super updateConstraints];
}
- (void)setModel:(TNProductDetailsIntroductionTableViewCellModel *)model {
    _model = model;
    if (HDIsStringNotEmpty(model.htmlStr) && !self.hasLoaded) {
        self.hasLoaded = YES;
        NSString *html = model.htmlStr;
        // 京东店铺 SIT：storeId=TN2852  UAT：storeId =TN2952  生产：storeId === 'TN204760'
        if ([model.storeId isEqualToString:@"TN204760"] || [model.storeId isEqualToString:@"TN2852"] ||
            [model.storeId isEqualToString:@"TN2952"]) { //京东的商品详情要重新处理  过度版本  之后这些处理应该放在后台
            html = [self regularExpressionHtml:model.htmlStr];
        }
        [self.webView loadHTMLString:html baseURL:[NSURL URLWithString:SAAppEnvManager.sharedInstance.appEnvConfig.tinhNowHost]];
    }
}
#pragma mark - 处理Html文本
- (NSString *)regularExpressionHtml:(NSString *)originalHtml {
    //拉取所有图片资源 重新组成图片标签  因为京东等第三方  有些不是图片便签 样式不统一
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:@"(//[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|](.gif|.png|.jpg|.jpeg|.bmp|.webp))" options:0 error:nil];
    NSMutableArray *resultArr = [NSMutableArray array];
    [regular enumerateMatchesInString:originalHtml options:NSMatchingReportProgress range:NSMakeRange(0, originalHtml.length)
                           usingBlock:^(NSTextCheckingResult *_Nullable result, NSMatchingFlags flags, BOOL *_Nonnull stop) {
                               if (result) {
                                   NSString *subStr = [originalHtml substringWithRange:result.range];
                                   [resultArr addObject:subStr];
                               }
                           }];
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    for (NSString *imgUrl in resultArr) {
        NSString *imgtag = @"<img src = imgUrl width = %100 height = auto/>";
        imgtag = [imgtag stringByReplacingOccurrencesOfString:@"imgUrl" withString:imgUrl];
        [resultStr appendFormat:@"%@ \n", imgtag];
    }
    if (resultStr.length <= 0) {
        resultStr = originalHtml.mutableCopy;
    }
    return resultStr;
}
/// 禁用web的双指放大缩小功能
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    scrollView.panGestureRecognizer.enabled = false;
    scrollView.pinchGestureRecognizer.enabled = false;
}
@end


@implementation TNProductDetailsIntroductionTableViewCellModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.webViewHeight = 0;
    }
    return self;
}
@end
