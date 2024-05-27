//
//  WMFAQViewController.m
//  SuperApp
//
//  Created by wmz on 2021/11/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "WMFAQViewController.h"
#import "WMFAQViewModel.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>


@interface WMFAQViewController () <WKNavigationDelegate>
/// webView加载富文本
@property (nonatomic, strong) WKWebView *webView;
/// userController
@property (nonatomic, strong) WKUserContentController *userController;

@property (nonatomic, assign) CGFloat scrollHeight;
/// bottomView
@property (nonatomic, strong) UIView *bottomView;
/// leftBTN
@property (nonatomic, strong) HDUIButton *parseBTN;
/// rightBTN
@property (nonatomic, strong) HDUIButton *uparseBTN;
@end


@implementation WMFAQViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    if (self = [super initWithRouteParameters:parameters]) {
        self.viewModel = parameters[@"viewModel"];
    }
    return self;
}

- (void)hd_setupViews {
    self.view.backgroundColor = HDAppTheme.color.normalBackground;
    self.scrollHeight = self.view.bounds.size.height - kNavigationBarH;
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
    [self.scrollViewContainer addSubview:self.webView];
    [self.view addSubview:self.bottomView];
}

- (void)updateViewConstraints {
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
    }];

    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(kNavigationBarH);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];

    [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-kRealWidth(10));
        make.height.mas_equalTo(self.scrollHeight);
    }];

    [super updateViewConstraints];
}

- (void)hd_getNewData {
    @HDWeakify(self)[self showloading];
    [self.viewModel yumNowQueryGuideContentWithKey:self.viewModel.rspModel.key code:self.viewModel.rspModel.code block:^(WMFAQDetailRspModel *_Nonnull rspModel) {
        @HDStrongify(self)[self dismissLoading];
        if (rspModel) {
            self.boldTitle = rspModel.title ?: @"";
            self.bottomView.hidden = NO;
            [self.webView layoutIfNeeded];
            CGRect frame = self.webView.frame;
            frame.size.height = 0;
            self.webView.frame = frame;
            NSString *headerString = @"<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, "
                                     @"user-scalable=no'><style>img{max-width:100%}</style></header>";
            [self.webView loadHTMLString:[headerString stringByAppendingString:rspModel.content] baseURL:nil];
            self.parseBTN.userInteractionEnabled = self.uparseBTN.userInteractionEnabled = !rspModel.isSupport;
            if (rspModel.isSupport) {
                if (rspModel.isSupport) {
                    self.parseBTN.selected = YES;
                    self.uparseBTN.selected = NO;
                } else {
                    self.parseBTN.selected = NO;
                    self.uparseBTN.selected = YES;
                }
            }
        }
    }];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable result, NSError *_Nullable error) {
        ///获取页面高度
        self.scrollHeight = [result doubleValue];
        [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.scrollHeight);
        }];
    }];
}

#pragma mark private
- (void)parserAction:(BOOL)parse sender:(UIButton *)sender {
    if (self.viewModel.rspDetailModel.isSupport)
        return;
    @HDWeakify(self)[self.viewModel yumNowGuideFeedBackWithCode:self.viewModel.rspModel.code parrse:parse block:^(BOOL success) {
        @HDStrongify(self) if (success) {
            self.viewModel.rspDetailModel.isSupport = parse ? @"true" : @"false";
            self.parseBTN.userInteractionEnabled = self.uparseBTN.userInteractionEnabled = NO;
        }

        sender.selected = success;
    }];
}

- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        self.userController = [[WKUserContentController alloc] init];
        configuration.userContentController = self.userController;
        configuration.preferences.javaScriptEnabled = YES;
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
        _webView.navigationDelegate = self;
        _webView.opaque = NO;
        _webView.multipleTouchEnabled = YES;
        _webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    }
    return _webView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = UIView.new;
        _bottomView.backgroundColor = UIColor.whiteColor;

        UIView *contenView = UIView.new;
        contenView.backgroundColor = UIColor.whiteColor;
        [_bottomView addSubview:contenView];

        SALabel *lab = SALabel.new;
        lab.text = WMLocalizedString(@"wm_guide_help", @"有帮助到您吗？");
        lab.font = [HDAppTheme.font forSize:16];
        [contenView addSubview:lab];

        @HDWeakify(self) UIView *rightView = UIView.new;
        HDUIButton *parseBTN = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [parseBTN setTitle:WMLocalizedString(@"wm_guide_yes", @"有帮助") forState:UIControlStateNormal];
        parseBTN.adjustsButtonWhenHighlighted = NO;
        parseBTN.titleLabel.font = [HDAppTheme.font forSize:14];
        [parseBTN setTitleColor:[UIColor hd_colorWithHexString:@"#99000000"] forState:UIControlStateNormal];
        [parseBTN setTitleColor:[UIColor hd_colorWithHexString:@"#CC000000"] forState:UIControlStateSelected];
        [parseBTN setImage:[UIImage imageNamed:@"wm_guide_unparse_up"] forState:UIControlStateNormal];
        [parseBTN setImage:[UIImage imageNamed:@"wm_guide_parse_up"] forState:UIControlStateSelected];
        parseBTN.spacingBetweenImageAndTitle = kRealWidth(5);
        [parseBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self)[self parserAction:true sender:btn];
        }];
        self.parseBTN = parseBTN;

        HDUIButton *uparseBTN = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [uparseBTN setTitle:WMLocalizedString(@"wm_guide_no", @"没帮助") forState:UIControlStateNormal];
        uparseBTN.adjustsButtonWhenHighlighted = NO;
        uparseBTN.titleLabel.font = [HDAppTheme.font forSize:14];
        [uparseBTN setTitleColor:[UIColor hd_colorWithHexString:@"#99000000"] forState:UIControlStateNormal];
        [uparseBTN setTitleColor:[UIColor hd_colorWithHexString:@"#CC000000"] forState:UIControlStateSelected];
        [uparseBTN setImage:[UIImage imageNamed:@"wm_guide_unparse_down"] forState:UIControlStateNormal];
        [uparseBTN setImage:[UIImage imageNamed:@"wm_guide_parse_down"] forState:UIControlStateSelected];
        uparseBTN.spacingBetweenImageAndTitle = kRealWidth(5);
        [uparseBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self)[self parserAction:false sender:btn];
        }];
        self.uparseBTN = uparseBTN;

        [contenView addSubview:rightView];

        [rightView addSubview:uparseBTN];
        [rightView addSubview:parseBTN];

        [contenView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-kiPhoneXSeriesSafeBottomHeight);
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(kRealWidth(44));
        }];

        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kRealWidth(15));
            make.centerY.mas_equalTo(0);
        }];

        [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-kRealWidth(15));
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(kRealWidth(33));
        }];

        [parseBTN mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(kRealWidth(7));
        }];

        [uparseBTN mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-kRealWidth(7));
            make.left.equalTo(parseBTN.mas_right).offset(kRealWidth(6));
            make.top.bottom.mas_equalTo(0);
        }];

        rightView.layer.backgroundColor = UIColor.whiteColor.CGColor;
        rightView.layer.cornerRadius = kRealWidth(16.5);
        rightView.layer.borderWidth = 0.5;
        rightView.layer.borderColor = [UIColor hd_colorWithHexString:@"#CC000000"].CGColor;

        _bottomView.hidden = YES;
    }
    return _bottomView;
}

- (BOOL)needLogin {
    return NO;
}

- (WMFAQViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = WMFAQViewModel.new;
    }
    return _viewModel;
}

@end
