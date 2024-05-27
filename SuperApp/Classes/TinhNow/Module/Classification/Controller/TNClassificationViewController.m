//
//  TNClassificationViewController.m
//  SuperApp
//
//  Created by seeu on 2020/6/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNClassificationViewController.h"
#import "TNCategoryFirstLevelView.h"
#import "TNCategorySecondLevelView.h"
#import "TNCategoryViewModel.h"
#import "WMMenuNavView.h"


@interface TNClassificationViewController ()
/// left
@property (nonatomic, strong) TNCategoryFirstLevelView *leftView;
/// right
@property (nonatomic, strong) TNCategorySecondLevelView *rightView;
/// vm
@property (nonatomic, strong) TNCategoryViewModel *viewModel;
/// 分享按钮
@property (nonatomic, strong) HDUIButton *shareButton;

@end


@implementation TNClassificationViewController

- (void)hd_setupViews {
    [self.view addSubview:self.leftView];
    [self.view addSubview:self.rightView];
}
// 页面埋点
- (void)trackingPage {
    [TNEventTrackingInstance trackPage:@"category" properties:@{@"type": @"1"}];
}

- (void)hd_setupNavigation {
    self.boldTitle = TNLocalizedString(@"tn_page_category_title", @"Classification");
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.view];
}

- (void)hd_getNewData {
    if (HDIsArrayEmpty(self.viewModel.firstLevel)) {
        [self.viewModel queryCategory];
    }
}

- (void)updateViewConstraints {
    [self.leftView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
        make.width.mas_equalTo(kRealWidth(80.0f));
    }];

    [self.rightView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
        make.left.equalTo(self.leftView.mas_right);
    }];

    [super updateViewConstraints];
}
#pragma mark - nav config

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return true;
}
- (UIStatusBarStyle)hd_statusBarStyle {
    return UIStatusBarStyleDefault;
}
/** @lazy viewModel */
- (TNCategoryViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[TNCategoryViewModel alloc] init];
    }
    return _viewModel;
}
/** @lazy leftView */
- (TNCategoryFirstLevelView *)leftView {
    if (!_leftView) {
        _leftView = [[TNCategoryFirstLevelView alloc] initWithViewModel:self.viewModel];
    }
    return _leftView;
}
/** @lazy rightView */
- (TNCategorySecondLevelView *)rightView {
    if (!_rightView) {
        _rightView = [[TNCategorySecondLevelView alloc] initWithViewModel:self.viewModel];
    }
    return _rightView;
}
@end
