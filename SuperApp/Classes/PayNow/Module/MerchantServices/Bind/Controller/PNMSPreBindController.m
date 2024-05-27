//
//  PNMSPreBindController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/6/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSPreBindController.h"
#import "PNMSBindViewModel.h"
#import "PNMSPreBindView.h"


@interface PNMSPreBindController ()
@property (nonatomic, strong) PNMSPreBindView *contentView;
@property (nonatomic, strong) PNMSBindViewModel *viewModel;
@end


@implementation PNMSPreBindController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
    }
    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"ms_bind_merchant_services", @"关联商户");
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
- (PNMSPreBindView *)contentView {
    if (!_contentView) {
        _contentView = [[PNMSPreBindView alloc] initWithViewModel:self.viewModel];
    }
    return _contentView;
}

- (PNMSBindViewModel *)viewModel {
    return _viewModel ?: (_viewModel = PNMSBindViewModel.new);
}

@end
