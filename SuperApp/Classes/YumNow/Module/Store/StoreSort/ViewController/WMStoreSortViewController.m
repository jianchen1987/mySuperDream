//
//  WMStoreSortViewController.m
//  SuperApp
//
//  Created by wmz on 2021/6/28.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "WMStoreSortViewController.h"
#import "SATableView.h"
#import "SAWriteDateReadableModel.h"
#import "WMStoreListViewModel.h"
#import "WMStoreSortSecondCell.h"
#import "WMStoreSoutFirstCell.h"


@interface WMStoreSortViewController () <UITableViewDelegate, UITableViewDataSource>
/// 占位图
@property (nonatomic, strong) UIView *emptyView;
/// 一级分类
@property (nonatomic, strong) SATableView *firstSortTable;
/// 二级分类
@property (nonatomic, strong) SATableView *secondSortTable;
/// 数据源
@property (nonatomic, strong) NSArray<WMCategoryItem *> *dataSource;
/// VM
@property (nonatomic, strong) WMStoreListViewModel *viewModel;
/// 左侧滑动
@property (nonatomic, assign) BOOL leftScroll;
/// 滚动上次选择
@property (nonatomic, strong) NSIndexPath *selectIndexPath;
/// 无数据VM
@property (nonatomic, strong) UIViewPlaceholderViewModel *placeholderViewModel;

@end


@implementation WMStoreSortViewController

- (void)hd_setupNavigation {
    self.boldTitle = WMLocalizedString(@"wm_all_categories", @"全部分类");
}

- (void)hd_setupViews {
    [self.view addSubview:self.firstSortTable];
    [self.view addSubview:self.secondSortTable];
    [self.view addSubview:self.emptyView];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self.view];
    [self getCateData];
}

- (void)getCateData {
    @HDWeakify(self)[self.emptyView hd_removePlaceholderView];
    self.firstSortTable.hidden = self.secondSortTable.hidden = YES;
    [self showloading];
    [self.viewModel getMerchantCategorySuccess:^(NSArray<WMCategoryItem *> *_Nonnull list) {
        @HDStrongify(self)[self dismissLoading];
        self.firstSortTable.hidden = self.secondSortTable.hidden = NO;
        self.dataSource = [NSArray arrayWithArray:list];
        if (self.dataSource && self.dataSource.count) {
            self.dataSource.firstObject.selected = YES;
            [self.firstSortTable successGetNewDataWithNoMoreData:NO];
            [self.secondSortTable successGetNewDataWithNoMoreData:NO];
        } else {
            [self showPlaceholderViewModel:@"no_data_placeholder" title:SALocalizedString(@"no_data", @"暂无数据")];
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self)[self dismissLoading];
        [self showPlaceholderViewModel:@"placeholder_network_error" title:SALocalizedString(@"network_error", @"网络开小差啦")];
    }];
}

- (void)showPlaceholderViewModel:(NSString *)image title:(NSString *)title {
    SAWriteDateReadableModel *cacheModel = [SACacheManager.shared objectForKey:kCacheKeyMerchantKind];
    NSArray<WMCategoryItem *> *cachedList = [NSArray yy_modelArrayWithClass:WMCategoryItem.class json:cacheModel.storeObj];
    if (cachedList && cachedList.count) {
        self.firstSortTable.hidden = self.secondSortTable.hidden = NO;
        self.dataSource = [NSArray arrayWithArray:cachedList];
        self.dataSource.firstObject.selected = YES;
        [self.firstSortTable successGetNewDataWithNoMoreData:NO];
        [self.secondSortTable successGetNewDataWithNoMoreData:NO];
    } else {
        self.firstSortTable.hidden = self.secondSortTable.hidden = YES;
        self.placeholderViewModel.image = image;
        self.placeholderViewModel.title = title;
        [self.emptyView hd_showPlaceholderViewWithModel:self.placeholderViewModel];
    }
}

- (void)updateViewConstraints {
    [self.emptyView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];

    [self.firstSortTable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(kNavigationBarH + kRealHeight(5));
        make.width.mas_equalTo(kRealWidth(100));
        make.bottom.mas_equalTo(0);
    }];
    [self.secondSortTable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kRealWidth(15));
        make.top.bottom.equalTo(self.firstSortTable);
        make.left.equalTo(self.firstSortTable.mas_right).offset(kRealWidth(15));
    }];

    [super updateViewConstraints];
}

#pragma mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.firstSortTable)
        return 1;
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.firstSortTable)
        return self.dataSource.count;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.firstSortTable) {
        WMStoreSoutFirstCell *cell = [WMStoreSoutFirstCell cellWithTableView:tableView];
        cell.model = self.dataSource[indexPath.row];
        return cell;
    }
    WMStoreSortSecondCell *cell = [WMStoreSortSecondCell cellWithTableView:tableView];
    WMCategoryItem *model = self.dataSource[indexPath.section];
    cell.blockOnClickItem = ^(WMCategoryItem *_Nonnull item) {
        [HDMediator.sharedInstance navigaveToStoreListViewController:@{
            @"category": item.scopeCode ?: @"",
            @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|全部分类页"] : @"全部分类页",
            @"associatedId" : self.viewModel.associatedId
        }];
    };
    cell.blockOnClickAll = ^{
        [HDMediator.sharedInstance navigaveToStoreListViewController:@{
            @"category": model.scopeCode ?: @"",
            @"source" : HDIsStringNotEmpty(self.viewModel.source) ? [self.viewModel.source stringByAppendingString:@"|全部分类页"] : @"全部分类页",
            @"associatedId" : self.viewModel.associatedId
        }];
    };
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.firstSortTable) {
        self.leftScroll = YES;
        self.selectIndexPath = indexPath;
        if ([self.secondSortTable numberOfSections] > indexPath.row) {
            [self.secondSortTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        if (self.firstSortTable.contentSize.height > self.firstSortTable.hd_height) {
            /// 滚动到中间
            CGFloat centerY = self.firstSortTable.hd_height / 2;
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            CGRect indexFrame = cell.frame;
            CGFloat contenSize = self.firstSortTable.contentSize.height;
            CGPoint point = CGPointZero;
            if (indexFrame.origin.y <= centerY) {
                point = CGPointMake(0, 0);
            } else if (CGRectGetMaxY(indexFrame) > (contenSize - centerY)) {
                point = CGPointMake(0, self.firstSortTable.contentSize.height - self.firstSortTable.hd_height);
            } else {
                point = CGPointMake(0, CGRectGetMaxY(indexFrame) - centerY - indexFrame.size.height / 2);
            }
            point = CGPointMake(point.x, MIN(self.firstSortTable.contentSize.height, MAX(0, point.y)));
            [self.firstSortTable setContentOffset:point animated:YES];
        }
        [self.dataSource enumerateObjectsUsingBlock:^(WMCategoryItem *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            obj.selected = (idx == indexPath.row);
        }];
        [UIView performWithoutAnimation:^{
            [tableView reloadData];
        }];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    /// 右边联动左边
    if (scrollView == self.secondSortTable && !self.leftScroll) {
        NSIndexPath *firstIndexPath = nil;
        if ([self.secondSortTable indexPathsForVisibleRows].count) {
            firstIndexPath = [self.secondSortTable indexPathsForVisibleRows].firstObject;
        }
        if (self.selectIndexPath) {
            if (self.dataSource.count > self.selectIndexPath.row) {
                self.dataSource[self.selectIndexPath.row].selected = NO;
            }
            if ([self.firstSortTable numberOfRowsInSection:0] > self.selectIndexPath.row) {
                [self.firstSortTable selectRowAtIndexPath:self.selectIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
        }
        if (firstIndexPath) {
            self.selectIndexPath = [NSIndexPath indexPathForRow:firstIndexPath.section inSection:0];
            if (self.dataSource.count > self.selectIndexPath.row) {
                self.dataSource[self.selectIndexPath.row].selected = YES;
            }
            if ([self.firstSortTable numberOfRowsInSection:0] > self.selectIndexPath.row) {
                [self.firstSortTable scrollToRowAtIndexPath:self.selectIndexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
                [self.firstSortTable selectRowAtIndexPath:self.selectIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    /// 左边联动右边的时候
    if (scrollView == self.secondSortTable) {
        self.leftScroll = NO;
    }
}

#pragma mark - lazy load
- (SATableView *)firstSortTable {
    if (!_firstSortTable) {
        _firstSortTable = [[SATableView alloc] initWithFrame:CGRectMake(0, 0, kRealHeight(90), self.view.hd_height) style:UITableViewStyleGrouped];
        _firstSortTable.needRefreshHeader = false;
        _firstSortTable.backgroundColor = [UIColor hd_colorWithHexString:@"#F3F4F8"];
        _firstSortTable.needRefreshFooter = false;
        _firstSortTable.needShowNoDataView = false;
        _firstSortTable.needShowErrorView = false;
        _firstSortTable.hidden = true;
        _firstSortTable.delegate = self;
        _firstSortTable.dataSource = self;
        _firstSortTable.estimatedRowHeight = kRealHeight(100);
        _firstSortTable.contentInset = UIEdgeInsetsMake(0, 0, kiPhoneXSeriesSafeBottomHeight, 0);
    }
    return _firstSortTable;
}

- (SATableView *)secondSortTable {
    if (!_secondSortTable) {
        _secondSortTable = [[SATableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame) * 0.3, self.view.hd_height) style:UITableViewStyleGrouped];
        _secondSortTable.bounces = false;
        _secondSortTable.needRefreshHeader = false;
        _secondSortTable.needRefreshFooter = false;
        _secondSortTable.needShowNoDataView = false;
        _secondSortTable.needShowErrorView = false;
        _firstSortTable.hidden = true;
        _secondSortTable.delegate = self;
        _secondSortTable.dataSource = self;
        _secondSortTable.rowHeight = UITableViewAutomaticDimension;
        _secondSortTable.estimatedRowHeight = 50;
        _secondSortTable.contentInset = UIEdgeInsetsMake(0, 0, kiPhoneXSeriesSafeBottomHeight, 0);
    }
    return _secondSortTable;
}

- (WMStoreListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = WMStoreListViewModel.new;
        _viewModel.plateId = self.parameters[@"plateId"];
        _viewModel.source = self.parameters[@"source"];
        _viewModel.associatedId = self.parameters[@"associatedId"];
    }
    return _viewModel;
}

- (UIViewPlaceholderViewModel *)placeholderViewModel {
    if (!_placeholderViewModel) {
        @HDWeakify(self) _placeholderViewModel = UIViewPlaceholderViewModel.new;
        _placeholderViewModel.needRefreshBtn = YES;
        _placeholderViewModel.refreshBtnTitle = SALocalizedString(@"refresh", @"刷新");
        _placeholderViewModel.clickOnRefreshButtonHandler = ^{
            @HDStrongify(self)[self getCateData];
        };
    }
    return _placeholderViewModel;
}

- (UIView *)emptyView {
    if (!_emptyView) {
        _emptyView = UIView.new;
        _emptyView.hidden = YES;
    }
    return _emptyView;
}

- (WMSourceType)currentSourceType {
    return WMSourceTypeAllCategory;
}

@end
