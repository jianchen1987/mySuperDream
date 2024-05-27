//
//  GNSearchViewController.m
//  SuperApp
//
//  Created by wmz on 2021/6/2.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNSearchViewController.h"
#import "GNSearchViewModel.h"
#import "GNStoreViewCell.h"
#import "SearchNaviView.h"


@interface GNSearchViewController () <GNTableViewProtocol, HDSearchBarDelegate>
/// 显示历史记录模块
@property (nonatomic, assign) BOOL showHistory;
/// 点击搜索
@property (nonatomic, assign) BOOL clickSearch;
/// resultTableview
@property (nonatomic, strong) GNTableView *tableView;
/// historyTableView
@property (nonatomic, strong) GNTableView *historyTableView;
/// 搜索
@property (nonatomic, strong) SearchNaviView *searchView;
/// viewModel
@property (nonatomic, strong) GNSearchViewModel *viewModel;
/// 骨架
@property (nonatomic, strong) HDSkeletonLayerDataSourceProvider *provider;

@end


@implementation GNSearchViewController

- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleHidden;
}

- (void)hd_setupNavigation {
    [super hd_setupNavigation];
    self.hd_statusBarStyle = UIStatusBarStyleDefault;
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.view];
    self.showHistory = YES;
}

- (void)updateViewConstraints {
    [self.searchView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(kNavigationBarH);
    }];

    [self.historyTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.searchView.mas_bottom).offset(HDAppTheme.value.gn_marginT);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
    }];

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.historyTableView.mas_top);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
    }];
    [super updateViewConstraints];
}

- (void)hd_setupViews {
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.historyTableView];

    @HDWeakify(self);
    [self.searchView.backBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
        @HDStrongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];

    [self.searchView.locationBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
        @HDStrongify(self);
        [self searchAction];
    }];

    self.tableView.tappedRefreshBtnHandler = ^{
        @HDStrongify(self);
        if (!self.tableView.hd_hasData) {
            self.tableView.delegate = self.provider;
            self.tableView.dataSource = self.provider;
            [self.tableView updateUI];
        }
        [self requestData];
    };

    self.tableView.requestNewDataHandler = ^{
        @HDStrongify(self);
        [self requestData];
    };
    self.tableView.requestMoreDataHandler = ^{
        @HDStrongify(self);
        [self requestData];
    };
}

#pragma mark methor
- (void)respondEvent:(NSObject<GNEvent> *)event {
    //清除
    if ([event.key isEqualToString:@"GNHistoryClear"]) {
        [self.viewModel localClearHistory];
        [self.historyTableView updateUI];
    } else if ([event.key isEqualToString:@"GNTagClick"]) {
        if (event.info[@"data"] && [event.info[@"data"] isKindOfClass:GNCellModel.class]) {
            GNCellModel *model = event.info[@"data"];
            if (GNStringNotEmpty(model.title)) {
                self.clickSearch = YES;
                [self searchWithText:model.title];
            }
        }
    }
}

/// 搜索点击
- (void)searchAction {
    if (!self.searchView.searchBar.textField.text.length && !self.clickSearch)
        return;
    self.clickSearch = YES;
    [self searchWithText:self.searchView.searchBar.textField.text];
}

/// 根据文本搜索
- (void)searchWithText:(NSString *)text {
    if (!GNStringNotEmpty(text))
        return;
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.searchView.searchBar.text = text;
    self.tableView.pageNum = 1;
    [self requestData];
}

- (void)requestData {
    @HDWeakify(self);
    if (self.tableView.pageNum == 1) {
        self.tableView.delegate = self.provider;
        self.tableView.dataSource = self.provider;
        [self.tableView updateUI];
    }
    if (self.tableView.pageNum > 1 && !self.viewModel.resultSection.rows.count) {
        [self.viewModel getRecommendDataMore:self.tableView.pageNum completion:^(GNStorePagingRspModel *_Nonnull rspModel, BOOL error) {
            @HDStrongify(self);
            self.tableView.GNdelegate = self;
            if (error) {
                [self.tableView reloadFail];
            } else {
                [self.tableView reloadData:!rspModel.hasNextPage];
            }
        }];
    } else {
        [self.viewModel getSearchData:self.searchView.searchBar.text pageNum:self.tableView.pageNum completion:^(GNStorePagingRspModel *_Nonnull rspModel, BOOL error) {
            @HDStrongify(self);
            self.tableView.GNdelegate = self;
            if (error) {
                [self.tableView reloadFail];
            } else {
                [self.viewModel localSaveHistory:self.searchView.searchBar.text];
                [self.historyTableView updateUI];
                [self.tableView reloadData:!rspModel.hasNextPage];
            }
            if (self.tableView.pageNum == 1) {
                [self.tableView layoutIfNeeded];
                if ([self.tableView numberOfSections] && [self.tableView numberOfRowsInSection:0]) {
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }
            }
        }];
    }
}

- (BOOL)searchBarShouldReturn:(HDSearchBar *)searchBar textField:(UITextField *)textField {
    [searchBar resignFirstResponder];
    if (GNStringNotEmpty(textField.text)) {
        self.clickSearch = YES;
        [self searchWithText:textField.text];
    }
    return true;
}

- (BOOL)searchBarShouldClear:(HDSearchBar *)searchBar {
    [searchBar resignFirstResponder];
    self.clickSearch = NO;
    return true;
}

#pragma mark GNTableViewProtocol
- (NSArray<GNSectionModel *> *)numberOfSectionsInGNTableView:(GNTableView *)tableView {
    if (tableView == self.historyTableView) {
        return self.viewModel.historyDataSource;
    }
    return self.viewModel.dataSource;
}

- (void)setClickSearch:(BOOL)clickSearch {
    _clickSearch = clickSearch;
    self.showHistory = !clickSearch;
}

- (GNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[GNTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = HDAppTheme.color.gn_mainBgColor;
        _tableView.provider = self.provider;
        _tableView.needRefreshFooter = YES;
        _tableView.needRefreshHeader = YES;
        _tableView.needShowErrorView = YES;
        _tableView.needShowNoDataView = YES;
        _tableView.needRefreshBTN = YES;
    }
    return _tableView;
}

- (GNTableView *)historyTableView {
    if (!_historyTableView) {
        _historyTableView = [[GNTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _historyTableView.GNdelegate = self;
        _historyTableView.bounces = NO;
        _historyTableView.backgroundColor = HDAppTheme.color.gn_mainBgColor;
    }
    return _historyTableView;
}

- (GNSearchViewModel *)viewModel {
    return _viewModel ?: ({ _viewModel = GNSearchViewModel.new; });
}

- (HDSkeletonLayerDataSourceProvider *)provider {
    if (!_provider) {
        _provider = [[HDSkeletonLayerDataSourceProvider alloc] initWithTableViewCellBlock:^UITableViewCell<HDSkeletonLayerLayoutProtocol> *(UITableView *tableview, NSIndexPath *indexPath) {
            return [GNStoreViewCell cellWithTableView:tableview];
        } heightBlock:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return [GNStoreViewCell skeletonViewHeight];
        }];
    }
    return _provider;
}

- (void)setShowHistory:(BOOL)showHistory {
    _showHistory = showHistory;
    self.historyTableView.hidden = !showHistory;
    self.tableView.hidden = showHistory;
}

- (SearchNaviView *)searchView {
    if (!_searchView) {
        _searchView = SearchNaviView.new;
        _searchView.searchBar.delegate = self;
    }
    return _searchView;
}

- (BOOL)needLogin {
    return NO;
}

- (BOOL)needClose {
    return YES;
}

@end
