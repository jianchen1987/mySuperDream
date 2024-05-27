//
//  PNMSOperatorManagerViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/10.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSOperatorManagerViewController.h"
#import "PNMSOperatorManagerView.h"
#import "PNMSOperatorViewModel.h"


@interface PNMSOperatorManagerViewController ()
@property (nonatomic, strong) PNMSOperatorManagerView *contentView;
@property (nonatomic, strong) PNMSOperatorViewModel *viewModel;
@property (nonatomic, strong) HDUIButton *addBtn;
@end


@implementation PNMSOperatorManagerViewController

- (void)hd_setupViews {
    [self.view addSubview:self.contentView];
}

- (void)hd_getNewData {
    [self.viewModel getNewData:YES];
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"pn_operator_management", @"操作员管理");
    self.hd_navRightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.addBtn]];
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return YES;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
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
- (PNMSOperatorManagerView *)contentView {
    if (!_contentView) {
        _contentView = [[PNMSOperatorManagerView alloc] initWithViewModel:self.viewModel];
    }
    return _contentView;
}

- (PNMSOperatorViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[PNMSOperatorViewModel alloc] init];
    }
    return _viewModel;
}

- (HDUIButton *)addBtn {
    if (!_addBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:PNLocalizedString(@"pn_add", @"添加") forState:0];
        [button setTitleColor:HDAppTheme.PayNowColor.mainThemeColor forState:0];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard14;
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [HDMediator.sharedInstance navigaveToPayNowMerchantServicesAddOrEditOperatorVC:@{}];
        }];

        _addBtn = button;
    }
    return _addBtn;
}

@end
