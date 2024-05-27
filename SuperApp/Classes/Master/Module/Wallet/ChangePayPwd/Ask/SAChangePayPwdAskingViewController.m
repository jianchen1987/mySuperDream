//
//  SAChangePayPwdAskingViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/8/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAChangePayPwdAskingViewController.h"


@interface SAChangePayPwdAskingViewController ()
/// 导航栏标题
@property (nonatomic, copy) NSString *navTitle;
/// 提示文字
@property (nonatomic, copy) NSString *tipStr;
/// 记得回调
@property (nonatomic, copy) void (^clickedRememberBlock)(void);
/// 不记得回调
@property (nonatomic, copy) void (^clickedForgetBlock)(void);
/// 提示
@property (nonatomic, strong) SALabel *tipLB;
/// 不记得按钮
@property (nonatomic, strong) SAOperationButton *forgetBTN;
/// 记得按钮
@property (nonatomic, strong) SAOperationButton *rememberBTN;
@end


@implementation SAChangePayPwdAskingViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;

    NSString *navTitle = [parameters objectForKey:@"navTitle"];
    if (HDIsStringNotEmpty(navTitle)) {
        self.navTitle = navTitle;
    } else {
        self.navTitle = SALocalizedString(@"change_pay_password", @"修改支付密码");
    }

    NSString *tipStr = [parameters objectForKey:@"tipStr"];
    if (HDIsStringNotEmpty(tipStr)) {
        self.tipStr = tipStr;
    } else {
        self.tipStr = SALocalizedString(@"remember_pay_password", @"您是否记得当前的支付密码？");
    }
    self.clickedForgetBlock = [parameters objectForKey:@"clickedForgetBlock"];
    self.clickedRememberBlock = [parameters objectForKey:@"clickedRememberBlock"];
    return self;
}

- (void)hd_setupViews {
    [self.view addSubview:self.tipLB];
    [self.view addSubview:self.forgetBTN];
    [self.view addSubview:self.rememberBTN];
}

- (void)hd_setupNavigation {
    self.boldTitle = self.navTitle;
}

#pragma mark - event response
- (void)clickedForgetBTNHandler {
    !self.clickedForgetBlock ?: self.clickedForgetBlock();
}

- (void)clickedRememberBTNHandler {
    !self.clickedRememberBlock ?: self.clickedRememberBlock();
}

#pragma mark - layout
- (void)updateViewConstraints {
    [self.tipLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hd_navigationBar.mas_bottom).offset(kRealWidth(45));
        make.width.equalTo(self.view).offset(-2 * kRealWidth(30));
        make.centerX.equalTo(self.view);
    }];

    [self.forgetBTN sizeToFit];
    [self.rememberBTN sizeToFit];

    // 使用更大的那个 size
    CGFloat buttonWidth = MAX(self.forgetBTN.bounds.size.width, self.rememberBTN.bounds.size.width);
    buttonWidth = MIN(buttonWidth, (kScreenWidth - kRealWidth(60)) / 2.0);

    [self.forgetBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(buttonWidth);
        make.height.mas_equalTo(self.forgetBTN.bounds.size.height);
        make.right.equalTo(self.view.mas_centerX).offset(-kRealWidth(10));
        make.top.equalTo(self.tipLB.mas_bottom).offset(kRealWidth(45));
    }];

    [self.rememberBTN sizeToFit];
    [self.rememberBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(buttonWidth);
        make.height.mas_equalTo(self.rememberBTN.bounds.size.height);
        make.left.equalTo(self.view.mas_centerX).offset(kRealWidth(10));
        make.top.equalTo(self.forgetBTN);
    }];

    [super updateViewConstraints];
}

#pragma mark - lazy load
- (SALabel *)tipLB {
    if (!_tipLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.font boldForSize:23];
        label.textColor = HDAppTheme.color.G1;
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = self.tipStr;
        _tipLB = label;
    }
    return _tipLB;
}

- (SAOperationButton *)forgetBTN {
    if (!_forgetBTN) {
        SAOperationButton *button = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        [button setTitle:SALocalizedString(@"forget", @"不记得") forState:UIControlStateNormal];
        if (isScreen47Inch) {
            button.titleLabel.font = HDAppTheme.font.standard3Bold;
        } else {
            button.titleLabel.font = HDAppTheme.font.standard2Bold;
        }
        if (SAMultiLanguageManager.isCurrentLanguageEN) {
            button.titleEdgeInsets = UIEdgeInsetsMake(11, 18, 11, 18);
        } else {
            button.titleEdgeInsets = UIEdgeInsetsMake(11, 50, 11, 50);
        }
        [button addTarget:self action:@selector(clickedForgetBTNHandler) forControlEvents:UIControlEventTouchUpInside];
        _forgetBTN = button;
    }
    return _forgetBTN;
}

- (SAOperationButton *)rememberBTN {
    if (!_rememberBTN) {
        SAOperationButton *button = [SAOperationButton buttonWithStyle:SAOperationButtonStyleHollow];
        [button setTitle:SALocalizedString(@"remember", @"记得") forState:UIControlStateNormal];
        if (isScreen47Inch) {
            button.titleLabel.font = HDAppTheme.font.standard3Bold;
        } else {
            button.titleLabel.font = HDAppTheme.font.standard2Bold;
        }
        if (SAMultiLanguageManager.isCurrentLanguageEN) {
            button.titleEdgeInsets = UIEdgeInsetsMake(11, 18, 11, 18);
        } else {
            button.titleEdgeInsets = UIEdgeInsetsMake(11, 50, 11, 50);
        }
        [button addTarget:self action:@selector(clickedRememberBTNHandler) forControlEvents:UIControlEventTouchUpInside];
        _rememberBTN = button;
    }
    return _rememberBTN;
}
@end
