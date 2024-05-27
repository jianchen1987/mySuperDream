//
//  PNGameSearchViewController.m
//  SuperApp
//
//  Created by 张杰 on 2022/12/16.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNGameSearchViewController.h"
#import "PNGameDetailViewController.h"
#import "PNGameListViewModel.h"
#import "PNGameSearchCell.h"
#import "PNTableView.h"


@interface PNGameSearchViewController () <HDSearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) HDSearchBar *searchBar;
@property (nonatomic, strong) PNTableView *tableView;

@property (nonatomic, strong) NSString *keyWord;
///
@property (strong, nonatomic) PNGameListViewModel *viewModel;
/// 搜索筛选数组
@property (strong, nonatomic) NSArray *searchFilterArray;
@end


@implementation PNGameSearchViewController
- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    self.searchFilterArray = self.viewModel.rspModel.categories;
    return [super initWithViewModel:viewModel];
}
- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"bill_payment", @"账单支付");
}
- (void)hd_setupViews {
    self.view.backgroundColor = HexColor(0xF3F4FA);
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tableView];
}

- (void)updateViewConstraints {
    [self.searchBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
        make.height.mas_equalTo(50);
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchBar.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    [super updateViewConstraints];
}

#pragma mark
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchFilterArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PNGameSearchCell *cell = [PNGameSearchCell cellWithTableView:tableView];
    PNGameCategoryModel *model = self.searchFilterArray[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PNGameCategoryModel *model = self.searchFilterArray[indexPath.section];
    PNGameDetailViewController *vc = [[PNGameDetailViewController alloc] initWithRouteParameters:@{@"categoryId": model.gameId}];
    [SAWindowManager navigateToViewController:vc];
}

#pragma mark
#pragma mark - HDSearchBarDelegate
NS_INLINE NSString *fixedKeywordWithOriginalKeyword(NSString *originalKeyword) {
    // 去除两端空格
    NSString *keyWord = [originalKeyword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    // 去除连续空格
    while ([keyWord rangeOfString:@"  "].location != NSNotFound) {
        keyWord = [keyWord stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    }
    return [keyWord copy];
}

- (void)searchBarTextDidBeginEditing:(HDSearchBar *)searchBar {
    [searchBar setShowRightButton:true animated:true];
}

- (void)searchBarTextDidEndEditing:(HDSearchBar *)searchBar {
    [searchBar setShowRightButton:false animated:true];
}

- (void)searchBarTextDidEndEditing:(HDSearchBar *)searchBar reason:(UITextFieldDidEndEditingReason)reason API_AVAILABLE(ios(10.0)) {
    [searchBar setShowRightButton:false animated:true];
}

- (void)searchBar:(HDSearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self searchListForKeyWord:searchText];
}

- (void)searchBarRightButtonClicked:(HDSearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [searchBar setShowRightButton:false animated:true];
}

- (BOOL)searchBarShouldReturn:(HDSearchBar *)searchBar textField:(UITextField *)textField {
    [searchBar resignFirstResponder];
    [searchBar setShowRightButton:false animated:true];
    [self searchListForKeyWord:textField.text];
    return YES;
}

#pragma mark
- (void)searchListForKeyWord:(NSString *)key {
    HDLog(@"search: %@", key);
    NSString *keyStr = fixedKeywordWithOriginalKeyword(key).uppercaseString;
    if (WJIsStringEmpty(keyStr)) {
        self.searchFilterArray = self.viewModel.rspModel.categories;
        [self.tableView successGetNewDataWithNoMoreData:YES];
    } else {
        /// 过滤
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@", keyStr];
        self.searchFilterArray = [self.viewModel.rspModel.categories filteredArrayUsingPredicate:predicate];

        if (self.searchFilterArray.count > 0) {
            [self.tableView successGetNewDataWithNoMoreData:YES];
        } else {
            self.tableView.placeholderViewModel.title = [NSString stringWithFormat:PNLocalizedString(@"supplier_no_search_result", @"没有关于\"ac\"的搜索结果"), keyStr];
            [self.tableView failGetNewData];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

#pragma mark
- (HDSearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = HDSearchBar.new;
        _searchBar.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        _searchBar.delegate = self;
        _searchBar.textFieldHeight = 35;
        _searchBar.showBottomShadow = false;
        [_searchBar setRightButtonTitle:PNLocalizedString(@"BUTTON_TITLE_CANCEL", @"取消")];
        _searchBar.placeHolder = PNLocalizedString(@"SEARCH", @"搜索");
        _searchBar.placeholderColor = HDAppTheme.PayNowColor.placeholderColor;
        _searchBar.inputFieldBackgrounColor = HDAppTheme.PayNowColor.cF6F6F6;
        [_searchBar setLeftButtonImage:UIImage.new];
    }
    return _searchBar;
}

- (PNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[PNTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        _tableView.needRefreshHeader = false;
        _tableView.needRefreshFooter = false;
        _tableView.rowHeight = kRealHeight(54);
        _tableView.backgroundColor = HexColor(0xF3F4FA);

        UIViewPlaceholderViewModel *model = [[UIViewPlaceholderViewModel alloc] init];
        model.title = SALocalizedString(@"no_data", @"暂无数据");
        model.image = @"pn_no_data_placeholder";
        _tableView.placeholderViewModel = model;
    }
    return _tableView;
}

@end
