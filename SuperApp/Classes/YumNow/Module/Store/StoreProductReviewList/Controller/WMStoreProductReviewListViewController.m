//
//  WMStoreProductReviewListViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/6/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreProductReviewListViewController.h"
#import "WMStoreProductReviewListView.h"
#import "WMStoreProductReviewListViewModel.h"


@interface WMStoreProductReviewListViewController ()
/// 内容
@property (nonatomic, strong) WMStoreProductReviewListView *contentView;
/// VM
@property (nonatomic, strong) WMStoreProductReviewListViewModel *viewModel;
@end


@implementation WMStoreProductReviewListViewController

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
    self.boldTitle = WMLocalizedString(@"product_reviews", @"商品评价");
}

- (void)hd_bindViewModel {
    [self.contentView hd_bindViewModel];
    [self.viewModel hd_bindView:self.view];
}

- (void)hd_getNewData {
    [self.viewModel queryCountInfo];
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
- (WMStoreProductReviewListView *)contentView {
    return _contentView ?: ({ _contentView = [[WMStoreProductReviewListView alloc] initWithViewModel:self.viewModel]; });
}

- (WMStoreProductReviewListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[WMStoreProductReviewListViewModel alloc] init];
        _viewModel.storeNo = [self.parameters objectForKey:@"storeNo"];
        _viewModel.goodsId = [self.parameters objectForKey:@"goodsId"];
    }
    return _viewModel;
}
@end
