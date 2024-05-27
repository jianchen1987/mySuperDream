//
//  TNProductIntroduceAlertView.m
//  SuperApp
//
//  Created by 张杰 on 2022/8/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNProductIntroduceAlertView.h"
#import "HDAppTheme+TinhNow.h"
#import "SAAppEnvManager.h"
#import "TNAdaptHeightImagesView.h"
#import "TNMultiLanguageManager.h"
#import <HDKitCore/HDKitCore.h>
#import <Masonry/Masonry.h>
#import <UIKit/UIKit.h>


@interface TNProductIntroduceAlertView () <WKNavigationDelegate>
///
@property (strong, nonatomic) UIView *headerView;
///
@property (strong, nonatomic) UILabel *titleLabel;
///
@property (strong, nonatomic) HDUIButton *closeBTN;
///
@property (strong, nonatomic) WKWebView *webView;
///
@property (strong, nonatomic) UIProgressView *progressorView;
///
@property (strong, nonatomic) TNAdaptHeightImagesView *imageView;
///
@property (nonatomic, copy) NSString *html;
/// 如果网页没有数据  就放图片
@property (nonatomic, copy) NSString *imageStr;
///  店铺id 过滤用的
@property (nonatomic, copy) NSString *storeId;
@end


@implementation TNProductIntroduceAlertView
- (void)dealloc {
    if (HDIsStringNotEmpty(self.html)) {
        [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    }
}
- (instancetype)initWithHtml:(NSString *)html storeId:(NSString *)storeId image:(NSString *)image {
    self = [super init];
    if (self) {
        self.html = html;
        self.imageStr = image;
        self.transitionStyle = HDActionAlertViewTransitionStyleBounce;
    }
    return self;
}
#pragma mark - HDActionAlertViewOverridable
- (void)layoutContainerView {
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kRealWidth(10));
        make.right.equalTo(self.mas_right).offset(-kRealWidth(10));
        make.centerY.equalTo(self);
        make.height.mas_equalTo(kScreenHeight * 0.75);
    }];
}
- (void)setupContainerViewAttributes {
    // 设置containerview的属性,比如切边啥的
    self.containerView.layer.masksToBounds = YES;
    self.allowTapBackgroundDismiss = YES;
    self.containerView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerAllCorners radius:8];
    };
}

- (void)setupContainerSubViews {
    [self.containerView addSubview:self.headerView];
    [self.headerView addSubview:self.titleLabel];
    [self.headerView addSubview:self.closeBTN];
    if (HDIsStringNotEmpty(self.html)) {
        [self.containerView addSubview:self.webView];
        NSString *tempHtml = self.html;
        if ([self.storeId isEqualToString:@"TN204760"] || [self.storeId isEqualToString:@"TN2852"] ||
            [self.storeId isEqualToString:@"TN2952"]) { //京东的商品详情要重新处理  过度版本  之后这些处理应该放在后台
            tempHtml = [self regularExpressionHtml:self.html];
        }
        [self.webView loadHTMLString:tempHtml baseURL:[NSURL URLWithString:SAAppEnvManager.sharedInstance.appEnvConfig.tinhNowHost]];

        [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [self.containerView addSubview:self.progressorView];

    } else {
        [self.containerView addSubview:self.imageView];
        TNAdaptImageModel *itemModel = TNAdaptImageModel.new;
        itemModel.imgUrl = self.imageStr;
        self.imageView.images = @[itemModel];
        @HDWeakify(self);
        self.imageView.getRealImageSizeAndIndexCallBack = ^(NSInteger index, CGFloat imageHeight) {
            @HDStrongify(self);
            [self updateImageViewLayout];
        };
    }
}

- (void)layoutContainerViewSubViews {
    [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.containerView);
        make.height.mas_equalTo(kRealWidth(45));
    }];

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headerView.mas_centerY);
        make.centerX.equalTo(self.headerView.mas_centerX);
    }];
    [self.closeBTN sizeToFit];
    [self.closeBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headerView.mas_centerY);
        make.right.equalTo(self.headerView.mas_right).offset(-kRealWidth(15));
    }];
    if (HDIsStringNotEmpty(self.html)) {
        [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.containerView);
            make.top.equalTo(self.headerView.mas_bottom);
        }];

        [self.progressorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.containerView);
            make.top.equalTo(self.headerView.mas_bottom);
            make.height.mas_equalTo(1.5);
        }];
    } else {
        [self updateImageViewLayout];
    }
}
- (void)updateImageViewLayout {
    if (!HDIsArrayEmpty(self.imageView.images)) {
        TNAdaptImageModel *itemModel = self.imageView.images.firstObject;
        [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.containerView);
            make.top.equalTo(self.headerView.mas_bottom);
            make.height.mas_equalTo(itemModel.imageHeight);
        }];
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress >= 1) {
            // 0.25s 后消失
            [CATransaction begin];
            [CATransaction setCompletionBlock:^{
                dispatch_after(0.25, dispatch_get_main_queue(), ^{
                    self.progressorView.hidden = YES;
                    [self.progressorView setProgress:0 animated:NO];
                });
            }];
            self.progressorView.hidden = NO;
            [self.progressorView setProgress:1 animated:NO];
            [CATransaction commit];
        } else {
            self.progressorView.hidden = NO;
            [self.progressorView setProgress:newprogress animated:YES];
        }
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
/** @lazy headerView */
- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
    }
    return _headerView;
}
/** @lazy  */
- (TNAdaptHeightImagesView *)imageView {
    if (!_imageView) {
        _imageView = [[TNAdaptHeightImagesView alloc] init];
    }
    return _imageView;
}
/** @lazy titleLabel */
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:15];
        _titleLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _titleLabel.text = TNLocalizedString(@"1PvveLDi", @"商品详情");
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (HDUIButton *)closeBTN {
    if (!_closeBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self dismiss];
        }];
        _closeBTN = button;
    }
    return _closeBTN;
}
/** @lazy <#name#> */
- (WKWebView *)webView {
    if (!_webView) {
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
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MIN) configuration:config];
        _webView.navigationDelegate = self;
    }
    return _webView;
}
/** @lazy progressorView */
- (UIProgressView *)progressorView {
    if (!_progressorView) {
        _progressorView = [[UIProgressView alloc] init];
        _progressorView.progressTintColor = [UIColor grayColor];
        _progressorView.trackTintColor = [UIColor whiteColor];
        _progressorView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _progressorView;
}
@end
