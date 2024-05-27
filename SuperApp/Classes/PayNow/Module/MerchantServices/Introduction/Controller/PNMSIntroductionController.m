//
//  PNMSIntroductionController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/5/30.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSIntroductionController.h"
#import "PNMSIntroductionView.h"
#import "PNMSIntroductionViewModel.h"


@interface PNMSIntroductionController ()
@property (nonatomic, strong) PNMSIntroductionView *contentView;
@property (nonatomic, strong) PNMSIntroductionViewModel *viewModel;
@end


@implementation PNMSIntroductionController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
    }
    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"pn_merchant_service_introduction", @"商户服务介绍");
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (void)hd_setupViews {
    [self.view addSubview:self.contentView];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.contentView];
    [self.viewModel getUserInfo];
}

- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

#pragma mark
- (PNMSIntroductionView *)contentView {
    if (!_contentView) {
        _contentView = [[PNMSIntroductionView alloc] initWithViewModel:self.viewModel];
    }
    return _contentView;
}

- (PNMSIntroductionViewModel *)viewModel {
    return _viewModel ?: (_viewModel = PNMSIntroductionViewModel.new);
}

@end
