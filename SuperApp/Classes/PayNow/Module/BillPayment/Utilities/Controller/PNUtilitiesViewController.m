//
//  PNUtilitiesViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/3/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNUtilitiesViewController.h"
#import "PNUtilitiesClassView.h"
#import "PNUtilitiesViewModel.h"


@interface PNUtilitiesViewController ()
@property (nonatomic, strong) PNUtilitiesClassView *contentView;
@property (nonatomic, strong) PNUtilitiesViewModel *viewModel;
@property (nonatomic, assign) BOOL isFirst;
/// 账单支付按钮
@property (nonatomic, strong) HDUIButton *recordButton;
@end


@implementation PNUtilitiesViewController

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"bill_payment", @"账单支付");
    self.hd_navRightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.recordButton];
}

- (void)hd_setupViews {
    self.isFirst = YES;
    [self.view addSubview:self.contentView];
}

- (void)hd_getNewData {
    /// 第一次由 view 里面触发获取【最近查询账单】
    if (!self.isFirst) {
        [self.viewModel queryRecentBillList];
    }
    self.isFirst = NO;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

#pragma mark
- (PNUtilitiesClassView *)contentView {
    if (!_contentView) {
        _contentView = [[PNUtilitiesClassView alloc] initWithViewModel:self.viewModel];
    }
    return _contentView;
}

- (PNUtilitiesViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[PNUtilitiesViewModel alloc] init];
    }
    return _viewModel;
}
- (HDUIButton *)recordButton {
    if (!_recordButton) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsButtonWhenHighlighted = false;
        [button setImage:[UIImage imageNamed:@"pn_billpayment_record"] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 5);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            [HDMediator.sharedInstance navigaveToBillPaymentListVC:@{}];
        }];
        _recordButton = button;
    }
    return _recordButton;
}
@end
