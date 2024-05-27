//
//  PNSubmitWaterPaymentViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/3/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNSubmitWaterPaymentViewController.h"
#import "PNSubmitWaterPaymentView.h"
#import "PNWaterBillModel.h"
#import "PNWaterViewModel.h"


@interface PNSubmitWaterPaymentViewController ()
@property (nonatomic, strong) PNSubmitWaterPaymentView *contentView;
@property (nonatomic, strong) PNWaterViewModel *viewModel;
@end


@implementation PNSubmitWaterPaymentViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.viewModel.billModel = [PNWaterBillModel yy_modelWithJSON:[parameters objectForKey:@"billInfo"]];
        self.viewModel.paymentCategoryType = [[parameters objectForKey:@"paymentCategory"] integerValue];
        self.viewModel.notes = [parameters objectForKey:@"notes"];
        self.viewModel.customerPhone = [parameters objectForKey:@"customerPhone"];
    }
    return self;
}

- (void)hd_bindViewModel {
    self.viewModel.refreshFlag = !self.viewModel.refreshFlag;

    [self.viewModel hd_bindView:self.contentView];
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"bill_payment", @"账单支付");
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
- (PNSubmitWaterPaymentView *)contentView {
    if (!_contentView) {
        _contentView = [[PNSubmitWaterPaymentView alloc] initWithViewModel:self.viewModel];
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
