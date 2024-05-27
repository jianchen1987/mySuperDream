//
//  PNMSCollectionController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/6/7.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSCollectionController.h"
#import "PNMSCollectionView.h"
#import "PNMSCollectionViewModel.h"
#import "VipayUser.h"


@interface PNMSCollectionController ()
@property (nonatomic, strong) PNMSCollectionViewModel *viewModel;
@property (nonatomic, strong) PNMSCollectionView *contentView;
@end


@implementation PNMSCollectionController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.viewModel.merchantNo = VipayUser.shareInstance.merchantNo;
    }
    return self;
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return YES;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleTransparent;
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"ms_today_collection", @"今日收款");
    self.hd_navTitleColor = HDAppTheme.PayNowColor.c333333;
    self.hd_backButtonImage = [UIImage imageNamed:@"pn_icon_back_black"];
    self.hd_statusBarStyle = UIStatusBarStyleDefault;
}

- (void)hd_setupViews {
    self.view.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self.view addSubview:self.contentView];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.contentView];
}

- (void)updateViewConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

#pragma mark
- (PNMSCollectionView *)contentView {
    if (!_contentView) {
        _contentView = [[PNMSCollectionView alloc] initWithViewModel:self.viewModel];
    }
    return _contentView;
}

- (PNMSCollectionViewModel *)viewModel {
    return _viewModel ?: (_viewModel = PNMSCollectionViewModel.new);
}

@end
