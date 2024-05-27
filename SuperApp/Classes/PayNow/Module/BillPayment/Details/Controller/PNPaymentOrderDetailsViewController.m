//
//  PNPaymentOrderDetailsViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/3/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPaymentOrderDetailsViewController.h"
#import "PNBillOrderDetailsView.h"
#import "PNPaymentOrderDetailsView.h"
#import "PNPaymentOrderDetailsViewModel.h"
#import "PNWaterBillModel.h"


@interface PNPaymentOrderDetailsViewController ()
@property (nonatomic, strong) PNBillOrderDetailsView *contentView;
@property (nonatomic, strong) PNPaymentOrderDetailsViewModel *viewModel;
@end


@implementation PNPaymentOrderDetailsViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.viewModel.orderNo = [parameters objectForKey:@"orderNo"];
        self.viewModel.tradeNo = [parameters objectForKey:@"tradeNo"];
    }
    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"bill_payment", @"账单支付");
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.contentView];
}

- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.width.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
    }];

    [super updateViewConstraints];
}

- (void)hd_setupViews {
    [self.view addSubview:self.contentView];
}

#pragma mark
- (PNBillOrderDetailsView *)contentView {
    if (!_contentView) {
        _contentView = [[PNBillOrderDetailsView alloc] initWithViewModel:self.viewModel];
    }
    return _contentView;
}

- (PNPaymentOrderDetailsViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[PNPaymentOrderDetailsViewModel alloc] init];
    }
    return _viewModel;
}
@end
