//
//  PNWaterPaymentResultViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/3/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNWaterPaymentResultViewController.h"
#import "PNWaterBillModel.h"
#import "PNWaterPaymentResultView.h"
#import "PNWaterViewModel.h"


@interface PNWaterPaymentResultViewController ()
@property (nonatomic, strong) PNWaterPaymentResultView *contentView;
@property (nonatomic, strong) PNWaterViewModel *viewModel;
@property (nonatomic, strong) HDUIButton *closeBtn;
@end


@implementation PNWaterPaymentResultViewController

- (void)dealloc {
    HDLog(@"%@ --- dealloc <>", NSStringFromClass(self.class));
    [_contentView stopQueryOnline];
}

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
    self.hd_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.closeBtn];
}

- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.width.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
    }];

    [super updateViewConstraints];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.contentView];
}

- (void)hd_setupViews {
    [self.view addSubview:self.contentView];
}

#pragma mark
- (PNWaterPaymentResultView *)contentView {
    if (!_contentView) {
        _contentView = [[PNWaterPaymentResultView alloc] initWithViewModel:self.viewModel];
        _contentView.paymentOrderModel = PNWaterBillModel.new;
    }
    return _contentView;
}

- (PNWaterViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[PNWaterViewModel alloc] init];
    }
    return _viewModel;
}

- (HDUIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.frame = CGRectMake(0, 0, 44, 44);
        [_closeBtn setImage:[UIImage imageNamed:@"icon_back_black"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    }

    return _closeBtn;
}

- (void)popAction {
    [self.navigationController popToViewControllerClass:NSClassFromString(@"PNUtilitiesViewController") animated:YES];
}
@end
