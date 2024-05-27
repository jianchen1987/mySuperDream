//
//  PNQueryWaterPaymentViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/3/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNQueryWaterPaymentViewController.h"
#import "PNBillQueryView.h"
#import "PNCommonUtils.h"
#import "PNWaterViewModel.h"


@interface PNQueryWaterPaymentViewController ()
@property (nonatomic, strong) PNBillQueryView *contentView;
@property (nonatomic, strong) PNWaterViewModel *viewModel;
@end


@implementation PNQueryWaterPaymentViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.viewModel.billerCode = [parameters objectForKey:@"billerCode"];
        self.viewModel.paymentCategoryType = [[parameters objectForKey:@"paymentCategory"] integerValue];
        self.viewModel.customerCode = [parameters objectForKey:@"customerCode"];
        self.viewModel.apiCredential = [parameters objectForKey:@"apiCredential"];
        self.viewModel.payTo = [parameters objectForKey:@"payTo"];
        self.viewModel.customerPhone = [parameters objectForKey:@"customerPhone"];
        self.viewModel.notes = [parameters objectForKey:@"notes"];
    }
    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"bill_payment", @"账单支付");
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

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.contentView];
}

#pragma mark
- (PNBillQueryView *)contentView {
    if (!_contentView) {
        _contentView = [[PNBillQueryView alloc] initWithViewModel:self.viewModel];
    }
    return _contentView;
}

- (PNWaterViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[PNWaterViewModel alloc] init];
    }
    return _viewModel;
}
@end
