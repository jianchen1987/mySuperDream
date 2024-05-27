//
//  WMMyReviewsViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/6/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMMyReviewsViewController.h"
#import "WMMyReviewsView.h"
#import "WMMyReviewsViewModel.h"


@interface WMMyReviewsViewController ()
/// 内容
@property (nonatomic, strong) WMMyReviewsView *contentView;
/// VM
@property (nonatomic, strong) WMMyReviewsViewModel *viewModel;
@end


@implementation WMMyReviewsViewController

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
    self.boldTitle = WMLocalizedString(@"my_reviews", @"我的评价");
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
- (WMMyReviewsView *)contentView {
    return _contentView ?: ({ _contentView = [[WMMyReviewsView alloc] initWithViewModel:self.viewModel]; });
}

- (WMMyReviewsViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[WMMyReviewsViewModel alloc] init];
        _viewModel.source = self.parameters[@"source"];
        _viewModel.associatedId = self.parameters[@"associatedId"];
    }
    return _viewModel;
}
@end
