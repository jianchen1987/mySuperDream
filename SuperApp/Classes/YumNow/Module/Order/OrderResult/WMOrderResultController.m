//
//  WMOrderResultController.m
//  SuperApp
//
//  Created by Chaos on 2021/1/12.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "WMOrderResultController.h"
#import "SALotteryAlertViewPresenter.h"
#import "WMOrderResultView.h"
#import "WMOrderResultViewModel.h"


@interface WMOrderResultController ()

/// view
@property (nonatomic, strong) WMOrderResultView *resultView;
/// viewModel
@property (nonatomic, strong) WMOrderResultViewModel *viewModel;
/// 完成按钮
@property (nonatomic, strong) HDUIButton *doneBTN;

@end


@implementation WMOrderResultController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self.parameters = parameters;
    return [super initWithRouteParameters:parameters];
}

- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"Log1CQtZ", @"支付结果");
    [self setHd_navLeftBarButtonItem:nil];
    self.hd_navRightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.doneBTN]];
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (void)hd_setupViews {
    self.hd_interactivePopDisabled = true;
    [self.view addSubview:self.resultView];

    [self.viewModel autoCouponRedemptionSuccess:nil failure:nil];
    [SALotteryAlertViewPresenter showLotteryAlertViewWithOrderNo:self.viewModel.orderNo completion:nil];
}

- (void)updateViewConstraints {
    [self.resultView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.bottom.centerX.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];
    [super updateViewConstraints];
}

#pragma mark - event response
- (void)doneBtnAction {
    [self.navigationController popToRootViewControllerAnimated:true];
}

#pragma mark - lazy load
- (WMOrderResultView *)resultView {
    if (!_resultView) {
        _resultView = [[WMOrderResultView alloc] initWithViewModel:self.viewModel];
    }
    return _resultView;
}
/** @lazy viewmodel */
- (WMOrderResultViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[WMOrderResultViewModel alloc] init];
        _viewModel.orderNo = self.parameters[@"orderNo"];
    }
    return _viewModel;
}

- (HDUIButton *)doneBTN {
    if (!_doneBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsButtonWhenHighlighted = false;
        [button setTitle:SALocalizedString(@"complete", @"完成") forState:UIControlStateNormal];
        [button setTitleColor:HDAppTheme.WMColor.mainRed forState:UIControlStateNormal];
        button.titleLabel.font = HDAppTheme.font.standard3;
        button.titleEdgeInsets = UIEdgeInsetsMake(12, 7, 12, 7);
        [button addTarget:self action:@selector(doneBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        _doneBTN = button;
    }
    return _doneBTN;
}

@end
