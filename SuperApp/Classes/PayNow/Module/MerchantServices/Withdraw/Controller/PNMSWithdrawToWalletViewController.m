//
//  PNMSCaseInController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/6/7.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSWithdrawToWalletViewController.h"
#import "PNMSWithdrawToWalletView.h"
#import "PNMSWithdrawViewModel.h"
#import "VipayUser.h"


@interface PNMSWithdrawToWalletViewController ()
@property (nonatomic, strong) PNMSWithdrawToWalletView *contentView;
@property (nonatomic, strong) PNMSWithdrawViewModel *viewModel;
@end


@implementation PNMSWithdrawToWalletViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.viewModel.selectCurrency = PNCurrencyTypeUSD;
        self.viewModel.merchantNo = VipayUser.shareInstance.merchantNo;
        self.viewModel.operatorNo = VipayUser.shareInstance.operatorNo;
    }
    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"pn_Withdraw", @"提现");
}

- (void)hd_setupViews {
    [self.view addSubview:self.contentView];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.contentView];
}

- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

#pragma mark
- (PNMSWithdrawToWalletView *)contentView {
    if (!_contentView) {
        _contentView = [[PNMSWithdrawToWalletView alloc] initWithViewModel:self.viewModel];
    }
    return _contentView;
}

- (PNMSWithdrawViewModel *)viewModel {
    return _viewModel ?: (_viewModel = PNMSWithdrawViewModel.new);
}

@end
