//
//  PNBillModifyAccountViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/3/24.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNBillModifyAmountViewController.h"
#import "PNBillModifyAmountView.h"
#import "PNBillModifyAmountViewModel.h"
#import "PNWaterBillModel.h"


@interface PNBillModifyAmountViewController ()
@property (nonatomic, strong) PNBillModifyAmountView *contentView;
@property (nonatomic, strong) PNBillModifyAmountViewModel *viewModel;
@end


@implementation PNBillModifyAmountViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.viewModel.billNo = [parameters objectForKey:@"billNo"];
        self.viewModel.balancesInfoModel = [PNBalancesInfoModel yy_modelWithJSON:[parameters objectForKey:@"data"]];
        self.viewModel.handleModifyAmountBlock = [parameters objectForKey:@"handle"];
    }
    return self;
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.contentView];
    self.viewModel.refreshFlag = !self.viewModel.refreshFlag;
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"Modify_amount", @"Modify amount");
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
- (PNBillModifyAmountView *)contentView {
    if (!_contentView) {
        _contentView = [[PNBillModifyAmountView alloc] initWithViewModel:self.viewModel];
    }
    return _contentView;
}

- (PNBillModifyAmountViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[PNBillModifyAmountViewModel alloc] init];
    }
    return _viewModel;
}
@end
