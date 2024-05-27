//
//  PNRememberViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/8/3.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSAskTradePwdViewController.h"


@interface PNMSAskTradePwdViewController ()
/// 提示
@property (nonatomic, strong) SALabel *tipsLabel;
/// 忘记
@property (nonatomic, strong) PNOperationButton *forgetBtn;
/// 记得
@property (nonatomic, strong) PNOperationButton *rememberBtn;
/// 记得回调
@property (nonatomic, copy) void (^clickedRememberBlock)(void);
/// 忘记得回调
@property (nonatomic, copy) void (^clickedForgetBlock)(void);

@end


@implementation PNMSAskTradePwdViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.clickedForgetBlock = [parameters objectForKey:@"forgetCallback"];
        self.clickedRememberBlock = [parameters objectForKey:@"rememberCallback"];
    }
    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"pn_ms_change_password", @"修改交易密码");
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (void)hd_setupViews {
    self.view.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self.view addSubview:self.tipsLabel];
    [self.view addSubview:self.forgetBtn];
    [self.view addSubview:self.rememberBtn];
}

- (void)updateViewConstraints {
    [self.tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(kRealWidth(16));
        make.right.mas_equalTo(self.view.mas_right).offset(kRealWidth(-16));
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom).offset(kRealWidth(24));
    }];

    [self.forgetBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(kRealWidth(16));
        make.width.mas_equalTo(self.rememberBtn.mas_width);
        make.top.mas_equalTo(self.tipsLabel.mas_bottom).offset(kRealWidth(48));
    }];

    [self.rememberBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.forgetBtn.mas_right).offset(kRealWidth(12));
        make.right.mas_equalTo(self.view.mas_right).offset(kRealWidth(-16));
        make.top.mas_equalTo(self.forgetBtn.mas_top);
    }];

    [super updateViewConstraints];
}

#pragma mark
- (SALabel *)tipsLabel {
    if (!_tipsLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard20M;
        label.numberOfLines = 0;
        label.text = PNLocalizedString(@"pn_ms_password_tips", @"您是否记得当前的交易密码？");
        _tipsLabel = label;
    }
    return _tipsLabel;
}

- (PNOperationButton *)forgetBtn {
    if (!_forgetBtn) {
        PNOperationButton *button = [PNOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        [button setTitle:PNLocalizedString(@"pn_not_remember", @"不记得") forState:0];
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            HDLog(@"click");
            !self.clickedForgetBlock ?: self.clickedForgetBlock();
        }];

        _forgetBtn = button;
    }
    return _forgetBtn;
}

- (PNOperationButton *)rememberBtn {
    if (!_rememberBtn) {
        PNOperationButton *button = [PNOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [button setTitle:PNLocalizedString(@"pn_remember", @"记得") forState:0];
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            !self.clickedRememberBlock ?: self.clickedRememberBlock();
        }];

        _rememberBtn = button;
    }
    return _rememberBtn;
}

@end
