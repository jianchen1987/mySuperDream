//
//  SAForgetLoginPwdSetPwdViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/4/6.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAForgetLoginPwdSetPwdViewController.h"
#import "SAForgetLoginPwdSetPwdView.h"
#import "SAForgetLoginPwdSetPwdViewModel.h"


@interface SAForgetLoginPwdSetPwdViewController ()
/// 内容
@property (nonatomic, strong) SAForgetLoginPwdSetPwdView *contentView;
/// VM
@property (nonatomic, strong) SAForgetLoginPwdSetPwdViewModel *viewModel;
@end


@implementation SAForgetLoginPwdSetPwdViewController
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

#pragma mark - lazy load

- (SAForgetLoginPwdSetPwdView *)contentView {
    return _contentView ?: ({ _contentView = [[SAForgetLoginPwdSetPwdView alloc] initWithViewModel:self.viewModel]; });
}

- (SAForgetLoginPwdSetPwdViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SAForgetLoginPwdSetPwdViewModel alloc] init];
        _viewModel.accountNo = [self.parameters objectForKey:@"accountNo"];
        _viewModel.countryCode = [self.parameters objectForKey:@"countryCode"];
        _viewModel.apiTicket = [self.parameters objectForKey:@"apiTicket"];
    }
    return _viewModel;
}
@end
