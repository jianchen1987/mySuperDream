//
//  SAOrderSearchViewController.m
//  SuperApp
//
//  Created by Tia on 2023/2/6.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAOrderSearchViewController.h"
#import "SAOrderCenterListViewController.h"
#import "SAOrderSearchHistoryView.h"
#import "SAOrderSearchViewModel.h"
#import "UIView+FrameChangedHandler.h"


@interface SAOrderSearchViewController () <HDSearchBarDelegate>
/// 搜索框
@property (nonatomic, strong) HDSearchBar *searchBar;
///搜索历史
@property (nonatomic, strong) SAOrderSearchHistoryView *historyView;

@property (nonatomic, strong) SAOrderSearchViewModel *viewModel;

@property (nonatomic, strong) SAOrderCenterListViewController *resultVC;

@end


@implementation SAOrderSearchViewController

- (void)hd_setupViews {
    self.view.backgroundColor = HDAppTheme.color.sa_backgroundColor;

    [self.view addSubview:self.searchBar];
//    @HDWeakify(self);
    [self.searchBar hd_setFrameNonZeroOnceHandler:^(CGRect frame) {
//        @HDStrongify(self);
        //        [self.searchBar becomeFirstResponder];
    }];

    [self.view addSubview:self.historyView];

    [self.view addSubview:self.resultVC.view];
}

- (void)hd_bindViewModel {
    [self.historyView hd_bindViewModel];
    [self.viewModel hd_bindView:self.view];
    //    //    // 加载历史搜索
    [self.viewModel loadDefaultData];
}

- (void)hd_setupNavigation {
    self.hd_statusBarStyle = UIStatusBarStyleDefault;
}

- (void)updateViewConstraints {
    // 这里可以根据是否正在搜索对搜索栏做位置变化
    [self.searchBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(HDAppTheme.value.statusBarHeight);
        make.width.centerX.equalTo(self.view);
        make.height.mas_equalTo(kRealWidth(44));
    }];
    [self.historyView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.mas_bottom);
        make.bottom.left.width.equalTo(self.view);
    }];
    [self.resultVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.historyView);
    }];
    [super updateViewConstraints];
}

#pragma mark - OVERWRITE
- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleHidden;
}

#pragma mark - private method
- (void)searchListForKeyWord:(NSString *)keyword {
    self.resultVC.view.hidden = NO;
    self.resultVC.keyName = keyword;
    [self.resultVC getNewData];
    // 保存搜索关键词到本地
    [self.viewModel saveMerchantHistorySearchWithKeyword:keyword];
}

#pragma mark - getters and setters
- (void)setKeyword:(NSString *)keyword {
    // 去首尾空格
    keyword = [keyword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.viewModel.keyword = keyword;
    HDLog(@"关键词变化：%@", keyword);
    if (!HDIsStringEmpty(keyword)) {
        [HDFunctionThrottle throttleWithInterval:0.3 key:NSStringFromSelector(@selector(searchListForKeyWord:)) handler:^{
            [self searchListForKeyWord:keyword];
        }];
    } else {
        [HDFunctionThrottle throttleCancelWithKey:NSStringFromSelector(@selector(searchListForKeyWord:))];
    }
}

#pragma mark - private methods
NS_INLINE NSString *fixedKeywordWithOriginalKeyword(NSString *originalKeyword) {
    // 去除两端空格
    NSString *keyWord = [originalKeyword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    // 去除连续空格
    while ([keyWord rangeOfString:@"  "].location != NSNotFound) {
        keyWord = [keyWord stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    }
    return [keyWord copy];
}

#pragma mark - HDSearchBarDelegate
- (BOOL)searchBarShouldClear:(HDSearchBar *)searchBar {
    HDLog(@"清空搜索");
    self.resultVC.view.hidden = true;
    return true;
}

- (void)searchBarTextDidBeginEditing:(HDSearchBar *)searchBar {
    HDLog(@"开始编辑");
}

- (void)searchBarLeftButtonClicked:(HDSearchBar *)searchBar {
    [self dismissAnimated:true completion:nil];
}

- (void)searchBarRightButtonClicked:(HDSearchBar *)searchBar {
    [searchBar resignFirstResponder];
    self.keyword = fixedKeywordWithOriginalKeyword(searchBar.getText);
}

- (BOOL)searchBarShouldReturn:(HDSearchBar *)searchBar textField:(UITextField *)textField {
    [searchBar resignFirstResponder];
    [searchBar setShowRightButton:false animated:true];
    self.keyword = fixedKeywordWithOriginalKeyword(textField.text);
    return true;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view.window endEditing:true];
}

#pragma mark - lazy load
- (HDSearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = HDSearchBar.new;
        _searchBar.delegate = self;
        [_searchBar setShowLeftButton:true animated:true];
        _searchBar.textFieldHeight = 36;
        _searchBar.placeHolder = SALocalizedString(@"oc_search_placeholder", @"订单号/商家名/商品名");
        _searchBar.placeholderColor = HDAppTheme.color.sa_searchBarTextColor;
        _searchBar.borderColor = HDAppTheme.color.G4;
        _searchBar.buttonTitleColor = HDAppTheme.color.G1;
        _searchBar.tintColor = [UIColor hd_colorWithHexString:@"FC2040"];
        [_searchBar setLeftButtonImage:[UIImage imageNamed:@"icon_navi_back_black"]];
        //        [_searchBar setRightButtonTitle:WMLocalizedString(@"search", @"搜索")];
        [_searchBar setShowRightButton:false animated:false];
        _searchBar.searchImage = [UIImage imageNamed:@"icon_oc_search"];
        _searchBar.backgroundColor = UIColor.clearColor;
        _searchBar.inputFieldBackgrounColor = UIColor.whiteColor;
    }
    return _searchBar;
}

- (SAOrderSearchHistoryView *)historyView {
    if (!_historyView) {
        _historyView = [[SAOrderSearchHistoryView alloc] initWithViewModel:self.viewModel];
        @HDWeakify(self);
        _historyView.keywordSelectedBlock = ^(NSString *_Nonnull keyword) {
            @HDStrongify(self);
            [self.view endEditing:true];
            self.searchBar.text = keyword;
            // 触发搜索
            [self searchBarRightButtonClicked:self.searchBar];
        };
    }
    return _historyView;
}

- (SAOrderSearchViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SAOrderSearchViewModel alloc] init];
        _viewModel.source = self.parameters[@"source"];
        _viewModel.associatedId = self.parameters[@"associatedId"];
    }
    return _viewModel;
}

- (SAOrderCenterListViewController *)resultVC {
    if (!_resultVC) {
        SAOrderCenterListViewController *vc = [[SAOrderCenterListViewController alloc] initWithRouteParameters:@{
            @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|订单搜索结果"] : @"订单搜索结果"
        }];
        vc.orderState = SAOrderStateAll;
        vc.businessLine = SAClientTypeMaster;
        vc.view.hidden = YES;
        _resultVC = vc;
        [self addChildViewController:_resultVC];
    }
    return _resultVC;
}

@end
