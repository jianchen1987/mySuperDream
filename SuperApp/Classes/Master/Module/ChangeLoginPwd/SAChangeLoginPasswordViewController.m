//
//  SAChangeLoginPasswordViewController.m
//  SuperApp
//
//  Created by Tia on 2022/11/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAChangeLoginPasswordViewController.h"
#import "SAChangeLoginPasswordView.h"
#import "SAChangeLoginPwdViewModel.h"


@interface SAChangeLoginPasswordViewController ()
/// 内容
@property (nonatomic, strong) SAChangeLoginPasswordView *contentView;
/// VM
@property (nonatomic, strong) SAChangeLoginPwdViewModel *viewModel;
@end


@implementation SAChangeLoginPasswordViewController

- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"change_login_password", @"修改登录密码");
}

- (void)hd_setupViews {
    [self.view addSubview:self.contentView];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.view];
}

- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.bottom.centerX.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];

    [super updateViewConstraints];
}

#pragma mark - config
- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return true;
}

#pragma mark - lazy load

- (SAChangeLoginPasswordView *)contentView {
    return _contentView ?: ({ _contentView = [[SAChangeLoginPasswordView alloc] initWithViewModel:self.viewModel]; });
}

- (SAChangeLoginPwdViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SAChangeLoginPwdViewModel alloc] init];
    }
    return _viewModel;
}
@end
