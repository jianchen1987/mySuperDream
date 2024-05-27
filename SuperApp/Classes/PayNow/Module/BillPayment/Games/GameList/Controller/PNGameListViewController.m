//
//  PNGamePaymentViewController.m
//  SuperApp
//
//  Created by 张杰 on 2022/12/16.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNGameListViewController.h"
#import "PNGameListView.h"
#import "PNGameListViewModel.h"
#import "PNGameSearchViewController.h"


@interface PNGameListViewController ()
///
@property (strong, nonatomic) PNGameListView *contentView;
///
@property (strong, nonatomic) PNGameListViewModel *viewModel;
/// 搜索按钮
@property (strong, nonatomic) HDUIButton *searchBtn;
@end


@implementation PNGameListViewController
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    if (self = [super initWithRouteParameters:parameters]) {
        NSNumber *code = parameters[@"paymentCategory"];
        if (code) {
            self.viewModel.paymentCategoryCode = [code integerValue];
        }
    }
    return self;
}
- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"bill_payment", @"账单支付");

    self.hd_navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchBtn];
}
- (void)hd_setupViews {
    [self.view addSubview:self.contentView];
}
- (void)hd_bindViewModel {
    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        if (!HDIsObjectNil(self.viewModel.rspModel)) {
            self.searchBtn.hidden = NO;
        }
    }];
}
- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];
    [super updateViewConstraints];
}
- (void)searchClick {
}
/** @lazy contentView */
- (PNGameListView *)contentView {
    if (!_contentView) {
        _contentView = [[PNGameListView alloc] initWithViewModel:self.viewModel];
    }
    return _contentView;
}
/** @lazy viewModel */
- (PNGameListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[PNGameListViewModel alloc] init];
    }
    return _viewModel;
}
/** @lazy searchBtn */
- (HDUIButton *)searchBtn {
    if (!_searchBtn) {
        _searchBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_searchBtn setImage:[UIImage imageNamed:@"pn_nav_search"] forState:UIControlStateNormal];
        @HDWeakify(self);
        [_searchBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            PNGameSearchViewController *searchVC = [[PNGameSearchViewController alloc] initWithViewModel:self.viewModel];
            [SAWindowManager navigateToViewController:searchVC];
        }];
        _searchBtn.hidden = NO;
    }
    return _searchBtn;
}
@end
