//
//  PNMSTradePwdController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/6/9.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSTradePwdController.h"
#import "PNMSTradePwdView.h"
#import "PNMSTradePwdViewModel.h"


@interface PNMSTradePwdController ()
@property (nonatomic, strong) PNMSTradePwdViewModel *viewModel;
@property (nonatomic, strong) PNMSTradePwdView *contentView;
@end


@implementation PNMSTradePwdController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.viewModel.operatorNo = [parameters objectForKey:@"operatorNo"];
        ;
        self.viewModel.actionType = [[parameters objectForKey:@"actionType"] integerValue];
        self.viewModel.successHandler = [parameters objectForKey:@"completion"];
        self.viewModel.oldPayPassword = [parameters objectForKey:@"oldPayPassword"];

        self.viewModel.currentPassword = [parameters objectForKey:@"currentPassword"];

        self.viewModel.serialNumber = [parameters objectForKey:@"serialNumber"];
        self.viewModel.token = [parameters objectForKey:@"token"];
    }
    return self;
}

- (void)hd_backItemClick:(UIBarButtonItem *)sender {
    [self.view.window endEditing:true];
    [super hd_backItemClick:sender];
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"pn_merchant_service", @"商家服务");
}

- (void)hd_setupViews {
    [self.view addSubview:self.contentView];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.contentView];
}

- (BOOL)allowContinuousBePushed {
    return YES;
}

- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

#pragma mark
- (PNMSTradePwdView *)contentView {
    if (!_contentView) {
        _contentView = [[PNMSTradePwdView alloc] initWithViewModel:self.viewModel];
    }
    return _contentView;
}

- (PNMSTradePwdViewModel *)viewModel {
    return _viewModel ?: (_viewModel = PNMSTradePwdViewModel.new);
}

@end
