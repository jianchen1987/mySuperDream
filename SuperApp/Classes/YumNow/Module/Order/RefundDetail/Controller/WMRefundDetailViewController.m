//
//  WMRefundDetailViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/6/28.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMRefundDetailViewController.h"
#import "WMRefundDetailView.h"
#import "WMRefundDetailViewModel.h"


@interface WMRefundDetailViewController ()
/// 内容
@property (nonatomic, strong) WMRefundDetailView *contentView;
/// VM
@property (nonatomic, strong) WMRefundDetailViewModel *viewModel;
@end


@implementation WMRefundDetailViewController

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
    self.boldTitle = WMLocalizedString(@"refund_detail", @"退款详情");
}

- (void)hd_bindViewModel {
    [self.contentView hd_bindViewModel];
    [self.viewModel hd_bindView:self.view];
}

- (void)hd_getNewData {
    [self.viewModel queryOrdeDetailInfo];
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
- (WMRefundDetailView *)contentView {
    return _contentView ?: ({ _contentView = [[WMRefundDetailView alloc] initWithViewModel:self.viewModel]; });
}

- (WMRefundDetailViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[WMRefundDetailViewModel alloc] init];
        _viewModel.orderNo = [self.parameters objectForKey:@"orderNo"];
    }
    return _viewModel;
}
@end
