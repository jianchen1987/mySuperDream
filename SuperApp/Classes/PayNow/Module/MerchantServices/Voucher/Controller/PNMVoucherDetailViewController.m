//
//  PNMVoucherDetailViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/27.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMVoucherDetailViewController.h"
#import "PNMSVoucherDetailView.h"
#import "PNMSVoucherViewModel.h"


@interface PNMVoucherDetailViewController ()
@property (nonatomic, strong) PNMSVoucherDetailView *contentView;
@property (nonatomic, strong) PNMSVoucherViewModel *viewModel;
@end


@implementation PNMVoucherDetailViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.viewModel.voucherId = [parameters objectForKey:@"id"];
    }
    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"pn_voucher_detail", @"凭证详情");
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return YES;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
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
- (PNMSVoucherDetailView *)contentView {
    if (!_contentView) {
        _contentView = [[PNMSVoucherDetailView alloc] initWithViewModel:self.viewModel];
    }
    return _contentView;
}

- (PNMSVoucherViewModel *)viewModel {
    return _viewModel ?: (_viewModel = PNMSVoucherViewModel.new);
}
@end
