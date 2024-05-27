//
//  PNIDVerifyViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/9/28.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNIDVerifyViewController.h"
#import "PNIDVerifyView.h"
#import "PNIDVerifyViewModel.h"


@interface PNIDVerifyViewController ()
@property (nonatomic, strong) PNIDVerifyView *contentView;
@property (nonatomic, strong) PNIDVerifyViewModel *viewModel;
@end


@implementation PNIDVerifyViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.viewModel.userLevel = [[parameters objectForKey:@"level"] integerValue];
        self.viewModel.successHandler = [parameters objectForKey:@"completion"];
    }
    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"pn_verify_information", @"客户信息校验");
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
- (PNIDVerifyView *)contentView {
    if (!_contentView) {
        _contentView = [[PNIDVerifyView alloc] initWithViewModel:self.viewModel];
    }
    return _contentView;
}

- (PNIDVerifyViewModel *)viewModel {
    return _viewModel ?: (_viewModel = PNIDVerifyViewModel.new);
}

@end
