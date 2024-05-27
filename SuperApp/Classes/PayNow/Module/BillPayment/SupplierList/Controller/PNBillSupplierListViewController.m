//
//  PNBillSupplierListViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/4/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNBillSupplierListViewController.h"
#import "PNBillSupplierListView.h"
#import "PNBillSupplierListViewModel.h"


@interface PNBillSupplierListViewController ()
@property (nonatomic, strong) PNBillSupplierListViewModel *viewModel;
@property (nonatomic, strong) PNBillSupplierListView *contentView;
@end


@implementation PNBillSupplierListViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.viewModel.paymentCategory = [[parameters objectForKey:@"paymentCategory"] integerValue];
    }
    return self;
}

#pragma mark
- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"bill_payment", @"账单支付");
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.contentView];
}

- (void)hd_setupViews {
    [self.view addSubview:self.contentView];
}

- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.width.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
    }];
    [super updateViewConstraints];
}

#pragma mark
- (PNBillSupplierListView *)contentView {
    if (!_contentView) {
        _contentView = [[PNBillSupplierListView alloc] initWithViewModel:self.viewModel];
    }
    return _contentView;
}

- (PNBillSupplierListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[PNBillSupplierListViewModel alloc] init];
    }
    return _viewModel;
}
@end
