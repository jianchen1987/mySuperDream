//
//  PNMSUploadVoucherViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/26.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSUploadVoucherViewController.h"
#import "PNMSUploadVoucherView.h"
#import "PNMSVoucherViewModel.h"


@interface PNMSUploadVoucherViewController ()
@property (nonatomic, strong) PNMSUploadVoucherView *contentView;
@property (nonatomic, strong) PNMSVoucherViewModel *viewModel;
@end


@implementation PNMSUploadVoucherViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
    }
    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"pn_Upload_voucher", @"上传凭证");
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
- (PNMSUploadVoucherView *)contentView {
    if (!_contentView) {
        _contentView = [[PNMSUploadVoucherView alloc] initWithViewModel:self.viewModel];
    }
    return _contentView;
}

- (PNMSVoucherViewModel *)viewModel {
    return _viewModel ?: (_viewModel = PNMSVoucherViewModel.new);
}

@end
