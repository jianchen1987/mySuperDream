//
//  SAWalletViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/8/17.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAWalletViewController.h"
#import "SAWalletView.h"
#import "SAWalletViewModel.h"


@interface SAWalletViewController ()
/// 内容
@property (nonatomic, strong) SAWalletView *contentView;
/// VM
@property (nonatomic, strong) SAWalletViewModel *viewModel;
/// 账单按钮
@property (nonatomic, strong) HDUIButton *billBTN;
@end


@implementation SAWalletViewController

#pragma mark - SAViewControllerRoutableProtocol
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;

    return self;
}

#pragma mark - SAViewControllerProtocol
- (BOOL)needCheckPayPwd {
    return true;
}

- (void)hd_setupViews {
    [self.view addSubview:self.contentView];
}

- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"wallet", @"Wallet");
    self.hd_navRightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.billBTN]];
}

- (void)hd_bindViewModel {
    [self.contentView hd_bindViewModel];
    [self.viewModel hd_bindView:self.view];
}

- (void)hd_getNewData {
    [self.contentView getNewData];
}

#pragma mark - SAMultiLanguageRespond
- (void)hd_languageDidChanged {
}

#pragma mark - HDViewControllerNavigationBarStyle
- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleWhite;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return false;
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return true;
}

#pragma mark - layout
- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.bottom.centerX.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];
    [super updateViewConstraints];
}

#pragma mark - lazy load
- (SAWalletView *)contentView {
    return _contentView ?: ({ _contentView = [[SAWalletView alloc] initWithViewModel:self.viewModel]; });
}

- (SAWalletViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SAWalletViewModel alloc] init];
    }
    return _viewModel;
}

- (HDUIButton *)billBTN {
    if (!_billBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsButtonWhenHighlighted = false;
        [button setTitle:SALocalizedString(@"bill", @"账单") forState:UIControlStateNormal];
        [button setTitleColor:HDAppTheme.color.G1 forState:UIControlStateNormal];
        button.titleLabel.font = HDAppTheme.font.standard3;
        [button sizeToFit];
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [HDMediator.sharedInstance navigaveToWalletBillListViewController:nil];
        }];
        _billBTN = button;
    }
    return _billBTN;
}
@end
