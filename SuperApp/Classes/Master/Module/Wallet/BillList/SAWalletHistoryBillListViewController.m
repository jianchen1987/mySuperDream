
//
//  SAWalletBillListViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/8/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAWalletHistoryBillListViewController.h"
#import "SAWalletBillListView.h"
#import "SAWalletBillListViewModel.h"


@interface SAWalletHistoryBillListViewController ()
@property (nonatomic, strong) SAWalletBillListView *contentView;    ///<
@property (nonatomic, strong) SAWalletBillListViewModel *viewModel; ///<
@end


@implementation SAWalletHistoryBillListViewController

#pragma mark - SAViewControllerRoutableProtocol
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;

    return self;
}

#pragma mark - SAViewControllerProtocol
- (void)hd_setupViews {
    [self.view addSubview:self.contentView];
}

- (void)hd_bindViewModel {
    [self.contentView hd_bindViewModel];
    [self.viewModel hd_bindView:self.contentView];
}

- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"bill_history_title", @"历史账单");
}

- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.bottom.centerX.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];

    [super updateViewConstraints];
}

#pragma mark - action
- (void)clickedOnHistoryButton:(HDUIButton *)button {
}

#pragma mark - lazy load
- (SAWalletBillListView *)contentView {
    if (!_contentView) {
        _contentView = [[SAWalletBillListView alloc] initWithViewModel:self.viewModel];
    }

    return _contentView;
}

- (SAWalletBillListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = SAWalletBillListViewModel.new;
        _viewModel.billType = SABillTypeHistory;
    }
    return _viewModel;
}

@end
