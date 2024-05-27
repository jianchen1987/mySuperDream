//
//  SACancellationApplicationVerifyIdentityViewController.m
//  SuperApp
//
//  Created by Tia on 2022/6/16.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACancellationApplicationVerifyIdentityViewController.h"
#import "SACancellationApplicationSuccessViewController.h"
#import "SACancellationApplicationVerifyIdentityView.h"
#import "SACancellationApplicationVerifyIdentityViewModel.h"
#import "SACancellationReasonModel.h"


@interface SACancellationApplicationVerifyIdentityViewController ()
/// 内容
@property (nonatomic, strong) SACancellationApplicationVerifyIdentityView *contentView;
/// VM
@property (nonatomic, strong) SACancellationApplicationVerifyIdentityViewModel *viewModel;

@end


@implementation SACancellationApplicationVerifyIdentityViewController

- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"ac_deactive_account", @"注销账号");
}

- (void)hd_setupViews {
    [self.view addSubview:self.contentView];
}

- (void)hd_bindViewModel {
    [self.contentView hd_bindViewModel];
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
- (SACancellationApplicationVerifyIdentityView *)contentView {
    if (!_contentView) {
        _contentView = [[SACancellationApplicationVerifyIdentityView alloc] initWithViewModel:self.viewModel];
        @HDWeakify(self);
        _contentView.nextBlock = ^{
            @HDStrongify(self);
            SACancellationApplicationSuccessViewController *vc = SACancellationApplicationSuccessViewController.new;
            [self.navigationController pushViewController:vc animated:YES];
        };
        _contentView.cancelBlock = ^{
            @HDStrongify(self);
            [self.navigationController popViewControllerAnimated:YES];
        };
    }
    return _contentView;
}

- (SACancellationApplicationVerifyIdentityViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SACancellationApplicationVerifyIdentityViewModel alloc] initWithModel:self.reasonModel];
        // 获取上次登录成功的账号
        _viewModel.lastLoginFullAccount = SAUser.lastLoginFullAccount;
    }
    return _viewModel;
}

@end
