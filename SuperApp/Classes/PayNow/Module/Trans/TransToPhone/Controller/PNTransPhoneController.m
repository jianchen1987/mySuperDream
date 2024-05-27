//
//  PNTransPhoneController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/5/12.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNTransPhoneController.h"
#import "PNTransPhoneView.h"
#import "PNTransPhoneViewModel.h"


@interface PNTransPhoneController ()
@property (nonatomic, strong) PNTransPhoneViewModel *viewModel;
@property (nonatomic, strong) PNTransPhoneView *contentView;
@end


@implementation PNTransPhoneController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.viewModel.phoneNumber = [parameters objectForKey:@"phoneNumber"];
        self.viewModel.selectCurrency = PNCurrencyTypeUSD;
    }
    return self;
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.contentView];

    [self.viewModel getMyWalletBalance];
}

- (void)hd_setupViews {
    [self.view addSubview:self.contentView];
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"pn_transfer_phone_number2", @"转账到手机号");
}

- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
        make.width.left.bottom.equalTo(self.view);
    }];

    [super updateViewConstraints];
}

#pragma mark
- (PNTransPhoneView *)contentView {
    if (!_contentView) {
        _contentView = [[PNTransPhoneView alloc] initWithViewModel:self.viewModel];
    }
    return _contentView;
}

- (PNTransPhoneViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[PNTransPhoneViewModel alloc] init];
    }
    return _viewModel;
}
@end
