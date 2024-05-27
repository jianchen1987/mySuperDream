//
//  WMStoreProductReviewListView.m
//  SuperApp
//
//  Created by VanJay on 2020/6/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreProductReviewListView.h"
#import "SANoDataCell.h"
#import "SATableView.h"
#import "WMReviewFilterView.h"
#import "WMStoreProductReviewCell.h"
#import "WMStoreProductReviewListViewModel.h"
#import "WMStoreProductReviewModel.h"


@interface WMStoreProductReviewListView () <UITableViewDelegate, UITableViewDataSource>
/// VM
@property (nonatomic, strong) WMStoreProductReviewListViewModel *viewModel;
/// 头部
@property (nonatomic, strong) WMReviewFilterView *headerView;
/// 列表
@property (nonatomic, strong) SATableView *tableView;
/// 数据源
@property (nonatomic, copy) NSArray<WMStoreProductReviewModel *> *dataSource;
@end


@implementation WMStoreProductReviewListView
#pragma mark - SAViewProtocol
- (void)hd_setupViews {
    [self addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;

    @HDWeakify(self);
    self.tableView.requestNewDataHandler = ^{
        @HDStrongify(self);
        [self.viewModel getNewData];
    };
    self.tableView.requestMoreDataHandler = ^{
        @HDStrongify(self);
        [self.viewModel loadMoreData];
    };
}

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_bindViewModel {
    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"isLoading" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        BOOL isLoading = [change[NSKeyValueChangeNewKey] boolValue];
        if (isLoading) {
            @HDStrongify(self);
            [self showloading];
        } else {
            [self dismissLoading];
        }
    }];
    [self.KVOController hd_observe:self.viewModel keyPath:@"countRspModel" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        WMProductReviewCountRspModel *countRspModel = change[NSKeyValueChangeNewKey];
        if (countRspModel && [countRspModel isKindOfClass:WMProductReviewCountRspModel.class]) {
            NSArray<WMReviewFilterButtonConfig *> *dataSource = self.headerView.dataSource;
            for (WMReviewFilterButtonConfig *config in dataSource) {
                if ([config.type isEqualToString:WMReviewFilterTypeAll]) {
                    config.title = [NSString stringWithFormat:@"%@(%zd)", WMLocalizedString(@"store_reviews_all", @"全部"), countRspModel.total];
                } else if ([config.type isEqualToString:WMReviewFilterTypeLike]) {
                    config.title = [NSString stringWithFormat:@"%@(%zd)", WMLocalizedString(@"produce_reviews_like", @"喜欢"), countRspModel.likes];
                } else if ([config.type isEqualToString:WMReviewFilterTypeUnlike]) {
                    config.title = [NSString stringWithFormat:@"%@(%zd)", WMLocalizedString(@"produce_reviews_unlike", @"不喜欢"), countRspModel.unlikes];
                } else if ([config.type isEqualToString:WMReviewFilterTypeWithImage]) {
                    config.title = [NSString stringWithFormat:@"%@(%zd)", WMLocalizedString(@"store_reviews_image", @"有图"), countRspModel.pictures];
                }
            }
            [self.headerView reloadData];
        }
    }];

    self.viewModel.successGetNewDataBlock = ^(NSMutableArray<WMStoreProductReviewModel *> *_Nonnull dataSource, BOOL hasNextPage) {
        @HDStrongify(self);
        self.dataSource = dataSource;
        [self.tableView successGetNewDataWithNoMoreData:!hasNextPage];
    };
    self.viewModel.successLoadMoreDataBlock = ^(NSMutableArray<WMStoreProductReviewModel *> *_Nonnull dataSource, BOOL hasNextPage) {
        @HDStrongify(self);
        self.dataSource = dataSource;
        [self.tableView successLoadMoreDataWithNoMoreData:!hasNextPage];
    };
    self.viewModel.failedGetNewDataBlock = ^(NSMutableArray<WMStoreProductReviewModel *> *_Nonnull dataSource) {
        @HDStrongify(self);
        [self.tableView failGetNewData];
    };
    self.viewModel.failedLoadMoreDataBlock = ^(NSMutableArray<WMStoreProductReviewModel *> *_Nonnull dataSource) {
        @HDStrongify(self);
        [self.tableView failLoadMoreData];
    };
}

#pragma mark - SAMultiLanguageRespond
- (void)hd_languageDidChanged {
}

#pragma mark - event response

#pragma mark - public methods

#pragma mark - private methods

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.dataSource.count)
        return UITableViewCell.new;
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:WMStoreProductReviewModel.class]) {
        WMStoreProductReviewCell *cell = [WMStoreProductReviewCell cellWithTableView:tableView];
        WMStoreProductReviewModel *trueModel = (WMStoreProductReviewModel *)model;
        trueModel.cellType = WMStoreProductReviewCellTypeAllReviews;
        cell.model = trueModel;

        @HDWeakify(cell);
        cell.clickedUserReviewContentReadMoreOrReadLessBlock = ^{
            @HDStrongify(cell);
            cell.model.isUserReviewContentExpanded = !cell.model.isUserReviewContentExpanded;
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        };
        cell.clickedMerchantReplyReadMoreOrReadLessBlock = ^{
            @HDStrongify(cell);
            cell.model.isMerchantReplyExpanded = !cell.model.isMerchantReplyExpanded;
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        };

        return cell;
    } else if ([model isKindOfClass:SANoDataCellModel.class]) {
        SANoDataCell *cell = [SANoDataCell cellWithTableView:tableView];
        cell.model = (SANoDataCellModel *)model;
        return cell;
    }
    return UITableViewCell.new;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:WMStoreProductReviewModel.class]) {
    }
}

#pragma mark - layout
- (void)updateConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [super updateConstraints];
}

#pragma mark - lazy load
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = false;
        _tableView.needRefreshFooter = true;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;
    }
    return _tableView;
}

- (WMReviewFilterView *)headerView {
    if (!_headerView) {
        _headerView = WMReviewFilterView.new;
        _headerView.showBottomSepLine = true;
        _headerView.defaultHasContentButtonStatus = self.viewModel.hasDetailCondition == WMReviewFilterConditionHasDetailRequired ? true : false;

        NSString *countStr = @"(0)";
        NSMutableArray<WMReviewFilterButtonConfig *> *dataSource = [NSMutableArray arrayWithCapacity:4];
        WMReviewFilterButtonConfig *config = [WMReviewFilterButtonConfig configWithTitle:[NSString stringWithFormat:@"%@%@", WMLocalizedString(@"store_reviews_all", @"全部"), countStr]
                                                                                    type:WMReviewFilterTypeAll];
        config.isSelected = true;
        [dataSource addObject:config];

        config = [WMReviewFilterButtonConfig configWithTitle:[NSString stringWithFormat:@"%@%@", WMLocalizedString(@"produce_reviews_like", @"喜欢"), countStr] type:WMReviewFilterTypeLike];
        [dataSource addObject:config];

        config = [WMReviewFilterButtonConfig configWithTitle:[NSString stringWithFormat:@"%@%@", WMLocalizedString(@"produce_reviews_unlike", @"不喜欢"), countStr] type:WMReviewFilterTypeUnlike];
        [dataSource addObject:config];

        config = [WMReviewFilterButtonConfig configWithTitle:[NSString stringWithFormat:@"%@%@", WMLocalizedString(@"store_reviews_image", @"有图"), countStr] type:WMReviewFilterTypeWithImage];
        [dataSource addObject:config];

        _headerView.dataSource = dataSource;

        @HDWeakify(self);
        _headerView.clickedFilterButtonBlock = ^(HDUIGhostButton *_Nonnull button, WMReviewFilterButtonConfig *_Nonnull config) {
            @HDStrongify(self);
            self.viewModel.filterType = config.type;
            [self.viewModel getNewData];
        };
        _headerView.clickedHasContentButtonBlock = ^(BOOL isSelected) {
            @HDStrongify(self);
            self.viewModel.hasDetailCondition = isSelected ? WMReviewFilterConditionHasDetailRequired : WMReviewFilterConditionHasDetailOrNone;
            [self.viewModel getNewData];
        };
    }
    return _headerView;
}
@end
