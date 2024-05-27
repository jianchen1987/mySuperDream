//
//  PNMSOpenController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/5/30.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSOpenController.h"
#import "PNMSOpenView.h"
#import "PNMSOpenViewModel.h"
#import "VipayUser.h"


@interface PNMSOpenController ()
@property (nonatomic, strong) PNMSOpenView *contentView;
@property (nonatomic, strong) PNMSOpenViewModel *viewModel;
@end


@implementation PNMSOpenController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.viewModel.merchantNo = VipayUser.shareInstance.merchantNo;
    }
    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"ms_open_merchant", @"开通商户");
}

- (void)hd_setupViews {
    self.view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
    [self.view addSubview:self.contentView];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.contentView];
}

- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
    }];

    [super updateViewConstraints];
}

#pragma mark
- (PNMSOpenView *)contentView {
    if (!_contentView) {
        _contentView = [[PNMSOpenView alloc] initWithViewModel:self.viewModel];
    }
    return _contentView;
}

- (PNMSOpenViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[PNMSOpenViewModel alloc] init];
        _viewModel.model = [[PNMSOpenModel alloc] init];
    }
    return _viewModel;
}

@end
