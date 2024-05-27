//
//  SALoginByPasswordViewController.m
//  SuperApp
//
//  Created by Tia on 2022/9/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SALoginByPasswordViewController.h"
#import "SALoginBaseViewModel.h"
#import "SALoginByPasswordView.h"

@interface SALoginByPasswordViewController ()
/// 内容
@property (nonatomic, strong) SALoginByPasswordView *contentView;
/// VM
@property (nonatomic, strong) SALoginBaseViewModel *viewModel;

@end


@implementation SALoginByPasswordViewController

- (void)hd_setupViews {
    [self.view addSubview:self.contentView];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.view];
}

- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"login_new_PasswordSignIn", @"密码登录");
}

- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.bottom.centerX.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];
    [super updateViewConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    BeginIgnoreClangWarning(-Wundeclared - selector);

    [NSNotificationCenter.defaultCenter addObserver:self.viewModel selector:@selector(receiveWechatAuthLoginResp:) name:kNotificationWechatAuthLoginResponse object:nil];
    EndIgnoreClangWarning
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [NSNotificationCenter.defaultCenter removeObserver:self.viewModel name:kNotificationWechatAuthLoginResponse object:nil];
}

#pragma mark - config
- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return true;
}

#pragma mark - lazy load
- (SALoginByPasswordView *)contentView {
    if (!_contentView) {
        _contentView = [[SALoginByPasswordView alloc] initWithViewModel:self.viewModel];
    }
    return _contentView;
}

- (SALoginBaseViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = SALoginBaseViewModel.new;
        // 获取上次登录成功的账号
        _viewModel.lastLoginFullAccount = SAUser.lastLoginFullAccount;
    }
    return _viewModel;
}

@end
