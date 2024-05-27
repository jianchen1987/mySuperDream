//
//  SACommonRefundDetailViewController.m
//  SuperApp
//
//  Created by Tia on 2022/5/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACommonRefundDetailViewController.h"
#import "SACommonRefundDetailView.h"
#import "SACommonRefundDetailViewModel.h"


@interface SACommonRefundDetailViewController ()
/// 内容
@property (nonatomic, strong) SACommonRefundDetailView *contentView;
/// VM
@property (nonatomic, strong) SACommonRefundDetailViewModel *viewModel;

@end


@implementation SACommonRefundDetailViewController

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
    self.boldTitle = SALocalizedString(@"refund_detail", @"退款详情");
}

- (void)hd_bindViewModel {
    [self.contentView hd_bindViewModel];
    [self.viewModel hd_bindView:self.view];
}

- (void)hd_getNewData {
    [self.viewModel queryOrdeDetailInfo];
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
- (SACommonRefundDetailView *)contentView {
    if (!_contentView) {
        _contentView = [[SACommonRefundDetailView alloc] initWithViewModel:self.viewModel];
    }
    return _contentView;
}

- (SACommonRefundDetailViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SACommonRefundDetailViewModel alloc] init];
        _viewModel.aggregateOrderNo = [self.parameters objectForKey:@"aggregateOrderNo"];
    }
    return _viewModel;
}

@end
