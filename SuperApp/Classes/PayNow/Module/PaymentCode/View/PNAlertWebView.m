//
//  PNAlertWebView.m
//  SuperApp
//
//  Created by xixi on 2022/5/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNAlertWebView.h"
#import "HDAppTheme+PayNow.h"
#import "HDUIButton.h"
#import "PNMultiLanguageManager.h"
#import "SACacheManager.h"
#import "SALabel.h"
#import "SAWriteDateReadableModel.h"
#import <HDKitCore.h>
#import <Masonry.h>
#import <WebKit/WebKit.h>


@interface PNAlertWebView () <WKNavigationDelegate>
@property (nonatomic, strong) SALabel *titleLabel;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) HDUIButton *leftBtn;
@property (nonatomic, strong) HDUIButton *rightBtn;
@property (nonatomic, strong) HDUIButton *showMoreBtn;
@property (nonatomic, assign) CGFloat scrollHeight;

@end


@implementation PNAlertWebView

///
- (instancetype)initAlertWithURL:(NSString *)url title:(NSString *)title {
    self = [super init];
    if (self) {
        self.scrollHeight = kScreenHeight * 0.5;
        self.titleLabel.text = title;
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        self.transitionStyle = HDActionAlertViewTransitionStyleBounce;
    }
    return self;
}

- (void)setupContainerSubViews {
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.webView];
    [self.containerView addSubview:self.showMoreBtn];
    //    [self.containerView addSubview:self.leftBtn];
    [self.containerView addSubview:self.rightBtn];
}

- (void)layoutContainerView {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kRealWidth(35));
        make.right.equalTo(self.mas_right).offset(-kRealWidth(35));
        make.centerY.equalTo(self.mas_centerY).offset(-kRealWidth(30));
    }];
}

- (void)setupContainerViewAttributes {
    self.containerView.layer.masksToBounds = YES;
    self.containerView.layer.cornerRadius = 8;
}

- (void)layoutContainerViewSubViews {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_top).offset(kRealWidth(20));
        make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(15));
        make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(15));
    }];

    [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.containerView.mas_left);
        make.right.mas_equalTo(self.containerView.mas_right);
        make.height.equalTo(@(self.scrollHeight));
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(10));
    }];

    //    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.bottom.equalTo(self.containerView);
    //        make.top.equalTo(self.webView.mas_bottom).offset(kRealWidth(10));
    //        make.width.equalTo(self.rightBtn.mas_width);
    //        make.height.mas_equalTo(kRealWidth(45));
    //    }];

    [self.showMoreBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).offset(kRealWidth(15));
        make.right.lessThanOrEqualTo(self.containerView).offset(kRealWidth(-15));
        make.top.mas_equalTo(self.webView.mas_bottom);
        make.height.equalTo(@(30));
    }];

    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).offset(kRealWidth(15));
        make.right.equalTo(self.containerView).offset(kRealWidth(-15));
        make.top.equalTo(self.showMoreBtn.mas_bottom).offset(kRealWidth(10));
        make.bottom.equalTo(self.containerView).offset(kRealWidth(-15));
        make.height.mas_equalTo(kRealWidth(45));
    }];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable result, NSError *_Nullable error){
        ///获取页面高度
        //                  self.scrollHeight = [result doubleValue];
        //                  [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
        //                      make.height.mas_equalTo(self.scrollHeight);
        //                  }];
    }];
}

#pragma mark
- (SALabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[SALabel alloc] init];
        _titleLabel.font = HDAppTheme.PayNowFont.standard17B;
        _titleLabel.textColor = HDAppTheme.PayNowColor.c343B4D;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

/** @lazy cancelBtn */
- (HDUIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [[HDUIButton alloc] init];
        _leftBtn.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;
        [_leftBtn setTitle:PNLocalizedString(@"BUTTON_TITLE_CANCEL", @"取消") forState:UIControlStateNormal];
        [_leftBtn setTitleColor:HDAppTheme.PayNowColor.c343B4D forState:UIControlStateNormal];
        _leftBtn.titleLabel.font = HDAppTheme.PayNowFont.standard15;
        @HDWeakify(self);
        [_leftBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self dismiss];
        }];
    }
    return _leftBtn;
}
/** @lazy cancelBtn */
- (HDUIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [[HDUIButton alloc] init];
        _rightBtn.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;
        [_rightBtn setTitle:PNLocalizedString(@"BUTTON_TITLE_SURE", @"确定") forState:UIControlStateNormal];
        [_rightBtn setTitleColor:HDAppTheme.PayNowColor.cFFFFFF forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = HDAppTheme.PayNowFont.standard15;
        _rightBtn.backgroundColor = HDAppTheme.PayNowColor.mainThemeColor;

        _rightBtn.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(6)];
        };

        @HDWeakify(self);
        [_rightBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);

            /// 如果勾选了 不再提醒 ，则缓存一下
            if (self.showMoreBtn.selected) {
                [SACacheManager.shared setObject:@(NO) forKey:kSaveDisclaimerAlertTips type:SACacheTypeDocumentNotPublic];
            }

            !self.rightBtnClickBlock ?: self.rightBtnClickBlock();
            [self dismiss];
        }];
    }
    return _rightBtn;
}

- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        WKUserContentController *userController = [[WKUserContentController alloc] init];
        configuration.userContentController = userController;
        configuration.preferences.javaScriptEnabled = YES;
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
        _webView.navigationDelegate = self;
        _webView.opaque = NO;
        _webView.multipleTouchEnabled = YES;
        _webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    }
    return _webView;
}

- (HDUIButton *)showMoreBtn {
    if (!_showMoreBtn) {
        _showMoreBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_showMoreBtn setTitle:PNLocalizedString(@"not_show_more", @"不再提醒") forState:0];
        [_showMoreBtn setTitleColor:HDAppTheme.PayNowColor.c343B4D forState:0];
        _showMoreBtn.titleLabel.font = HDAppTheme.PayNowFont.standard15;
        [_showMoreBtn setImage:[UIImage imageNamed:@"pay_Unchecked"] forState:UIControlStateNormal];
        [_showMoreBtn setImage:[UIImage imageNamed:@"pay_checked"] forState:UIControlStateSelected];
        _showMoreBtn.spacingBetweenImageAndTitle = kRealWidth(5);
        @HDWeakify(self);
        [_showMoreBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            HDLog(@"click");
            self.showMoreBtn.selected = !self.showMoreBtn.selected;
        }];
    }
    return _showMoreBtn;
}
@end
