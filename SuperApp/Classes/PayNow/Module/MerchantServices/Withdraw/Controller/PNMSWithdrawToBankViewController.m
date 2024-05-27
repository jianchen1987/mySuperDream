//
//  PNMSWithdrawToBankViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSWithdrawToBankViewController.h"
#import "PNMSWithdrawToBankView.h"
#import "PNMSWithdrawViewModel.h"


@interface PNMSWithdrawToBankViewController ()
@property (nonatomic, strong) PNMSWithdrawToBankView *contentView;
@property (nonatomic, strong) PNMSWithdrawViewModel *viewModel;
@end


@implementation PNMSWithdrawToBankViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.viewModel.selectCurrency = [parameters objectForKey:@"currency"];
        self.viewModel.amount = [parameters objectForKey:@"amount"];
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

- (void)hd_getNewData {
    [self.viewModel getWitdrawBankList:YES];
}

- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

#pragma mark
- (PNMSWithdrawToBankView *)contentView {
    if (!_contentView) {
        _contentView = [[PNMSWithdrawToBankView alloc] initWithViewModel:self.viewModel];
    }
    return _contentView;
}

- (PNMSWithdrawViewModel *)viewModel {
    return _viewModel ?: (_viewModel = PNMSWithdrawViewModel.new);
}

@end
