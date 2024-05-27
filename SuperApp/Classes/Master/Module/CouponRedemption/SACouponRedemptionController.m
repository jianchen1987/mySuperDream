//
//  SACouponRedemptionController.m
//  SuperApp
//
//  Created by Chaos on 2021/1/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACouponRedemptionController.h"
#import "SACouponRedemptionView.h"
#import "SACouponRedemptionViewModel.h"


@interface SACouponRedemptionController ()

/// view
@property (nonatomic, strong) SACouponRedemptionView *couponRedemptionView;
/// viewModel
@property (nonatomic, strong) SACouponRedemptionViewModel *viewModel;

@end


@implementation SACouponRedemptionController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;

    self.viewModel.dataSource = parameters[@"list"];

    return self;
}

- (void)hd_setupViews {
    [self.view addSubview:self.couponRedemptionView];
}

- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"order_detail_coupon_ticket", @"Coupon");
}

- (void)updateViewConstraints {
    [self.couponRedemptionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];
    [super updateViewConstraints];
}

#pragma mark - lazy load
- (SACouponRedemptionView *)couponRedemptionView {
    if (!_couponRedemptionView) {
        _couponRedemptionView = [[SACouponRedemptionView alloc] initWithViewModel:self.viewModel];
    }
    return _couponRedemptionView;
}

- (SACouponRedemptionViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = SACouponRedemptionViewModel.new;
    }
    return _viewModel;
}

@end
