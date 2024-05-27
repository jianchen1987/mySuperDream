//
//  TNProductCenterViewController.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/9.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNProductCenterViewController.h"
#import "TNCategoryContainerView.h"


@interface TNProductCenterViewController ()
/// searchBar
@property (nonatomic, strong) HDSearchBar *searchBar;
@property (strong, nonatomic) TNCategoryContainerView *categoryView; ///<
@end


@implementation TNProductCenterViewController
- (void)hd_setupViews {
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.categoryView];
}
- (void)hd_setupNavigation {
    self.boldTitle = TNLocalizedString(@"u7pH8DDd", @"选品中心");
}
- (void)updateViewConstraints {
    [self.searchBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(kRealWidth(55));
    }];
    [self.categoryView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.searchBar.mas_bottom);
    }];
    [super updateViewConstraints];
}
#pragma mark - 点击搜索
- (void)clickedSearchHandler {
    [[HDMediator sharedInstance] navigaveToTinhNowSellerSearchViewController:@{@"sp": [TNGlobalData shared].seller.supplierId}];
}
- (HDSearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = HDSearchBar.new;
        _searchBar.showBottomShadow = NO;
        [_searchBar disableTextField];
        [_searchBar setShowLeftButton:NO animated:NO];
        _searchBar.textFieldHeight = kRealWidth(35);
        _searchBar.placeHolder = TNLocalizedString(@"MUkyJash", @"请输入关键词");
        _searchBar.placeholderColor = HDAppTheme.TinhNowColor.G3;
        [_searchBar setShowRightButton:NO animated:NO];
        _searchBar.textFont = HDAppTheme.TinhNowFont.standard14;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedSearchHandler)];
        [_searchBar addGestureRecognizer:recognizer];
    }
    return _searchBar;
}
/** @lazy categoryView */
- (TNCategoryContainerView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[TNCategoryContainerView alloc] initWithViewModel:nil];
    }
    return _categoryView;
}
@end
