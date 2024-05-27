//
//  WMProductPackingFeeViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/6/27.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMProductPackingFeeViewController.h"
#import "WMProductPackingFeeView.h"
#import "WMProductPackingFeeViewModel.h"


@interface WMProductPackingFeeViewController ()
/// 内容
@property (nonatomic, strong) WMProductPackingFeeView *contentView;
/// VM
@property (nonatomic, strong) WMProductPackingFeeViewModel *viewModel;
@end


@implementation WMProductPackingFeeViewController

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
    self.boldTitle = WMLocalizedString(@"packing_fee_detail_title", @"包装费明细");
}

- (void)hd_bindViewModel {
    [self.contentView hd_bindViewModel];
    [self.viewModel hd_bindView:self.view];
}

- (void)hd_getNewData {
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
- (WMProductPackingFeeView *)contentView {
    return _contentView ?: ({ _contentView = [[WMProductPackingFeeView alloc] initWithViewModel:self.viewModel]; });
}

- (WMProductPackingFeeViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[WMProductPackingFeeViewModel alloc] init];
        _viewModel.productList = [self.parameters objectForKey:@"productList"];
        _viewModel.packingFee = [self.parameters objectForKey:@"packingFee"];
    }
    return _viewModel;
}
@end
