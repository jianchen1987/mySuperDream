//
//  TNProductDetailCardCell.m
//  SuperApp
//
//  Created by 张杰 on 2022/8/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNProductDetailCardCell.h"
#import "HDAppTheme+TinhNow.h"
#import "SAAppEnvManager.h"
#import "SAOperationButton.h"
#import "TNProductIntroduceAlertView.h"


@interface TNProductDetailCardCell () <WKNavigationDelegate>
/// 标题
@property (strong, nonatomic) UILabel *nameLabel;
///
@property (strong, nonatomic) UIImageView *productImageView;
///
@property (strong, nonatomic) UIImageView *blurImageView;
/// 购物按钮
@property (nonatomic, strong) SAOperationButton *watchAllBtn;
/// webview
@property (strong, nonatomic) WKWebView *webView;
/// 是否已经加载过
@property (nonatomic, assign) BOOL hasLoaded;
/// 是否要展开
@property (nonatomic, assign) BOOL isExpanded;
/// webView默认高度
@property (nonatomic, assign) CGFloat webviewHeight;
/// 展开高度
@property (nonatomic, assign) CGFloat webviewMaxHeight;
@end


@implementation TNProductDetailCardCell
- (void)setFrame:(CGRect)frame {
    CGRect newFrame = frame;
    newFrame.origin.x = kRealWidth(8);
    newFrame.size.width = kScreenWidth - kRealWidth(16);
    [super setFrame:newFrame];
}
- (void)hd_bindViewModel {
    @HDWeakify(self);
    [self.KVOController hd_observe:self.webView keyPath:@"loading" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        [self.webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(NSNumber *_Nullable value, NSError *_Nullable error) {
            @HDStrongify(self);
            if (value != nil) {
                CGFloat heightValue = [value doubleValue];
                self.webviewMaxHeight = heightValue;
                if (self.isExpanded && self.webView.height != heightValue) {
                    !self.webViewHeightCallBack ?: self.webViewHeightCallBack();
                }
            }
        }];
    }];
}
- (void)hd_setupViews {
    self.webviewHeight = 100;
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.webView];

    [self.contentView addSubview:self.blurImageView];
    [self.contentView addSubview:self.watchAllBtn];
}
- (void)setModel:(TNProductDetailCardCellModel *)model {
    _model = model;

    if (HDIsStringNotEmpty(model.html) && !self.hasLoaded) {
        self.hasLoaded = YES;
        NSString *tempHtml = model.html;
        if ([model.storeId isEqualToString:@"TN204760"] || [model.storeId isEqualToString:@"TN2852"] ||
            [model.storeId isEqualToString:@"TN2952"]) { //京东的商品详情要重新处理  过度版本  之后这些处理应该放在后台
            tempHtml = [self regularExpressionHtml:model.html];
        }
        [self.webView loadHTMLString:tempHtml baseURL:[NSURL URLWithString:SAAppEnvManager.sharedInstance.appEnvConfig.tinhNowHost]];

        if (![model.type isEqualToString:TNGoodsTypeOverseas]) {
            //快消品的直接展示全部
            self.isExpanded = YES;
            self.blurImageView.hidden = YES;
            self.watchAllBtn.hidden = YES;
            self.webviewHeight = kScreenHeight / 2;
        } else {
            self.webviewHeight = kScreenHeight;
        }
    }

    [self setNeedsUpdateConstraints];
}
- (void)showDetail {
    /// 点击查看全部展开 【将查看全部按钮、蒙层 都隐藏】
    self.isExpanded = YES;
    self.blurImageView.hidden = YES;
    self.watchAllBtn.hidden = YES;
    !self.webViewHeightCallBack ?: self.webViewHeightCallBack();
}
- (void)updateConstraints {
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(10));
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(10));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(10));
    }];
    [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(kRealWidth(20));
        make.left.right.equalTo(self.contentView);
        if (self.isExpanded) {
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.height.mas_equalTo(self.model != nil ? self.webviewMaxHeight : 0);
        } else {
            make.height.mas_equalTo(self.model != nil ? self.webviewHeight : 0);
        }
    }];
    if (!self.blurImageView.isHidden) {
        [self.blurImageView sizeToFit];
        [self.blurImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.webView);
        }];
    }
    if (!self.watchAllBtn.isHidden) {
        [self.watchAllBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(15));
            make.size.mas_equalTo(CGSizeMake(kRealWidth(180), kRealWidth(35)));
            make.top.equalTo(self.webView.mas_bottom).offset(-kRealWidth(13));
        }];
    }

    [super updateConstraints];
}
#pragma mark
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
#pragma mark
/** @lazy nameLabel */
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [HDAppTheme.TinhNowFont fontMedium:15];
        _nameLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _nameLabel.text = TNLocalizedString(@"1PvveLDi", @"商品详情");
    }
    return _nameLabel;
}
/** @lazy productImageView */
- (UIImageView *)productImageView {
    if (!_productImageView) {
        _productImageView = [[UIImageView alloc] init];
        _productImageView.contentMode = UIViewContentModeScaleAspectFill;
        _productImageView.clipsToBounds = YES;
    }
    return _productImageView;
}
/** @lazy blurImageView */
- (UIImageView *)blurImageView {
    if (!_blurImageView) {
        _blurImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tn_product_detail_blur"]];
    }
    return _blurImageView;
}
/** @lazy watchAllBtn */
- (SAOperationButton *)watchAllBtn {
    if (!_watchAllBtn) {
        _watchAllBtn = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        [_watchAllBtn setTitle:TNLocalizedString(@"Y6ARiDuW", @"查看全部") forState:UIControlStateNormal];
        _watchAllBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:15];
        [_watchAllBtn applyHollowPropertiesWithTintColor:HDAppTheme.TinhNowColor.C1];
        _watchAllBtn.borderWidth = 0.5;
        _watchAllBtn.titleEdgeInsets = UIEdgeInsetsZero;
        [_watchAllBtn addTarget:self action:@selector(showDetail) forControlEvents:UIControlEventTouchUpInside];
    }
    return _watchAllBtn;
}
/** @lazy webView */
- (WKWebView *)webView {
    if (!_webView) {
        NSMutableString *jScript = [NSMutableString string];
        [jScript appendString:@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width, initial-scale=1, maximum-scale=1, "
                              @"user-scalable=no, viewport-fit=cover'); document.getElementsByTagName('head')[0].appendChild(meta); var imgs = document.getElementsByTagName('img');for (var i in "
                              @"imgs){imgs[i].style.maxWidth='100%';imgs[i].style.height='auto';}; "];

        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];

        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addUserScript:wkUScript];
        WKWebViewConfiguration *config = WKWebViewConfiguration.new;
        config.userContentController = wkUController;
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MIN) configuration:config];
        _webView.scrollView.scrollEnabled = NO;
        _webView.scrollView.userInteractionEnabled = NO;
        _webView.navigationDelegate = self;
        _webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    }
    return _webView;
}
@end


@implementation TNProductDetailCardCellModel

@end
