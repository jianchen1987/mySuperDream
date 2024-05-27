//
//  PNMSHomeController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/5/27.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSHomeController.h"
#import "PNMSHomeView.h"
#import "PNMSHomeViewModel.h"


@interface PNMSHomeController ()
@property (nonatomic, strong) PNMSHomeView *contentView;
@property (nonatomic, strong) PNMSHomeViewModel *viewModel;
@property (nonatomic, strong) HDUIButton *navBtn;
@end


@implementation PNMSHomeController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.viewModel.merchantNo = [parameters objectForKey:@"merchantNo"];
        self.viewModel.operatorNo = [parameters objectForKey:@"operatorNo"];
        VipayUser.shareInstance.merchantNo = [parameters objectForKey:@"merchantNo"];
        VipayUser.shareInstance.merchantName = [parameters objectForKey:@"merchantName"];
        VipayUser.shareInstance.operatorNo = [parameters objectForKey:@"operatorNo"];
        VipayUser.shareInstance.role = [[parameters objectForKey:@"role"] integerValue];
        VipayUser.shareInstance.merchantMenus = [parameters objectForKey:@"merchantMenus"];
        VipayUser.shareInstance.permission = [parameters objectForKey:@"permission"];
        VipayUser.shareInstance.storeNo = [parameters objectForKey:@"storeNo"];
        VipayUser.shareInstance.storeName = [parameters objectForKey:@"storeName"];
    }
    return self;
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return YES;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleTransparent;
}

- (void)hd_getNewData {
    [self.viewModel getNewData];
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"pn_merchant_service", @"商户服务");
    self.hd_navTitleColor = HDAppTheme.PayNowColor.c333333;
    self.hd_backButtonImage = [UIImage imageNamed:@"pn_icon_back_black"];
    self.hd_statusBarStyle = UIStatusBarStyleDefault;

    //    if ([VipayUser hasSettingMenu]) {
    self.hd_navRightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.navBtn]];
    //    }
}

- (void)hd_setupViews {
    self.view.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self.view addSubview:self.contentView];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.contentView];
}

- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
    }];
    [super updateViewConstraints];
}

#pragma mark
- (PNMSHomeView *)contentView {
    if (!_contentView) {
        _contentView = [[PNMSHomeView alloc] initWithViewModel:self.viewModel];
    }
    return _contentView;
}

- (PNMSHomeViewModel *)viewModel {
    return _viewModel ?: (_viewModel = PNMSHomeViewModel.new);
}

- (HDUIButton *)navBtn {
    if (!_navBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsButtonWhenHighlighted = false;
        [button setImage:[UIImage imageNamed:@"pn_ms_setting_icon"] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 5);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [HDMediator.sharedInstance navigaveToPayNowMerchantServicesSettingVC:@{}];
        }];
        _navBtn = button;
    }
    return _navBtn;
}
@end
