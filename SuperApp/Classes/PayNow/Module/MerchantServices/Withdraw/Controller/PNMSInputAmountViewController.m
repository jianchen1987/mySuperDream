//
//  PNMSInputAmountViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/23.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSInputAmountViewController.h"
#import "PNMSInputAmountView.h"
#import "PNMSWithdrawViewModel.h"


@interface PNMSInputAmountViewController ()
@property (nonatomic, strong) PNMSInputAmountView *contentView;
@property (nonatomic, strong) PNMSWithdrawViewModel *viewModel;
@end


@implementation PNMSInputAmountViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.viewModel.selectCurrency = PNCurrencyTypeUSD;
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

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return YES;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

#pragma mark
- (PNMSInputAmountView *)contentView {
    if (!_contentView) {
        _contentView = [[PNMSInputAmountView alloc] initWithViewModel:self.viewModel];
    }
    return _contentView;
}

- (PNMSWithdrawViewModel *)viewModel {
    return _viewModel ?: (_viewModel = PNMSWithdrawViewModel.new);
}

@end
