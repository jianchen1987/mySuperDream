//
//  SAWalletBillDetailViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/8/20.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAWalletBillDetailViewController.h"
#import "SAWalletBillDetailView.h"
#import "SAWalletBillDetailViewModel.h"


@interface SAWalletBillDetailViewController ()
/// 内容
@property (nonatomic, strong) SAWalletBillDetailView *contentView;
/// VM
@property (nonatomic, strong) SAWalletBillDetailViewModel *viewModel;
@end


@implementation SAWalletBillDetailViewController

#pragma mark - SAViewControllerRoutableProtocol
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;

    return self;
}

#pragma mark - SAViewControllerProtocol
- (void)hd_setupViews {
    [self.view addSubview:self.contentView];
}

- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"bill_detail", @"账单详情");
}

- (void)hd_bindViewModel {
    [self.contentView hd_bindViewModel];
    [self.viewModel hd_bindView:self.view];
}

- (void)hd_getNewData {
    [self.viewModel getNewData];
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
- (SAWalletBillDetailView *)contentView {
    return _contentView ?: ({ _contentView = [[SAWalletBillDetailView alloc] initWithViewModel:self.viewModel]; });
}

- (SAWalletBillDetailViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SAWalletBillDetailViewModel alloc] init];
        _viewModel.tradeNo = [self.parameters objectForKey:@"tradeNo"];
    }
    return _viewModel;
}
@end
