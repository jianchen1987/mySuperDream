//
//  PNAccountInfoViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/1/7.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNAccountInfoViewController.h"
#import "PNAccountInfoView.h"
#import "PNAccountViewModel.h"


@interface PNAccountInfoViewController ()
@property (nonatomic, strong) PNAccountViewModel *viewModel;
@property (nonatomic, strong) PNAccountInfoView *accountInfoView;
@end


@implementation PNAccountInfoViewController

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"ACCOUNT_INFO", @"账户信息");
}

- (void)hd_setupViews {
    [self.view addSubview:self.accountInfoView];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.accountInfoView];
    [self.viewModel getUserInfo];
}

- (void)updateViewConstraints {
    [self.accountInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
    }];

    [super updateViewConstraints];
}

#pragma mark
- (PNAccountViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[PNAccountViewModel alloc] init];
    }
    return _viewModel;
}

- (PNAccountInfoView *)accountInfoView {
    if (!_accountInfoView) {
        _accountInfoView = [[PNAccountInfoView alloc] initWithViewModel:self.viewModel];
    }
    return _accountInfoView;
}

@end
