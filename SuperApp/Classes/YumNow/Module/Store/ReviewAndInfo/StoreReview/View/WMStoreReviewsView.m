//
//  WMStoreReviewsView.m
//  SuperApp
//
//  Created by Chaos on 2020/6/12.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreReviewsView.h"
#import "SANoDataCell.h"
#import "SATableView.h"
#import "WMReviewFilterView.h"
#import "WMStoreProductDetailRspModel.h"
#import "WMStoreProductReviewCell+Skeleton.h"
#import "WMStoreProductReviewCell.h"
#import "WMStoreProductReviewModel.h"
#import "WMStoreReviewCountRspModel.h"
#import "WMStoreReviewsHeaderView.h"
#import "WMStoreReviewsRepModel.h"
#import "WMStoreReviewsViewModel.h"


@interface WMStoreReviewsView () <UITableViewDelegate, UITableViewDataSource>
/// 头部
@property (nonatomic, strong) WMStoreReviewsHeaderView *headerView;
/// VM
@property (nonatomic, strong) WMStoreReviewsViewModel *viewModel;
/// 数据源
@property (nonatomic, strong) NSMutableArray *dataSource;
/// 骨架 loading 生成器
@property (nonatomic, strong) HDSkeletonLayerDataSourceProvider *provider;
@end


@implementation WMStoreReviewsView

- (void)hd_setupViews {
    [self addSubview:self.tableView];
    self.tableView.delegate = self.provider;
    self.tableView.dataSource = self.provider;

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
    self.headerView.viewModel = self.viewModel;
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

    [self.KVOController hd_observe:self.viewModel keyPath:@"scoreModel" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        self.headerView.viewModel = self.viewModel;
    }];

    [self.KVOController hd_observe:self.viewModel keyPath:@"countRspModel" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        WMStoreReviewCountRspModel *countRspModel = change[NSKeyValueChangeNewKey];
        self.headerView.filterView.hidden = HDIsObjectNil(countRspModel) || countRspModel.total <= 0;

        if (countRspModel && [countRspModel isKindOfClass:WMStoreReviewCountRspModel.class]) {
            NSArray<WMReviewFilterButtonConfig *> *dataSource = self.headerView.filterView.dataSource;
            for (WMReviewFilterButtonConfig *config in dataSource) {
                if ([config.type isEqualToString:WMReviewFilterTypeAll]) {
                    config.title = [NSString stringWithFormat:@"%@(%zd)", WMLocalizedString(@"store_reviews_all", @"全部"), countRspModel.total];
                } else if ([config.type isEqualToString:WMReviewFilterTypeGood]) {
                    config.title = [NSString stringWithFormat:@"%@(%zd)", WMLocalizedString(@"store_reviews_praise", @"好评"), countRspModel.praises];
                } else if ([config.type isEqualToString:WMReviewFilterTypeBad]) {
                    config.title = [NSString stringWithFormat:@"%@(%zd)", WMLocalizedString(@"store_reviews_critical", @"差评"), countRspModel.criticals];
                } else if ([config.type isEqualToString:WMReviewFilterTypeWithImage]) {
                    config.title = [NSString stringWithFormat:@"%@(%zd)", WMLocalizedString(@"store_reviews_image", @"有图"), countRspModel.images];
                } else if ([config.type isEqualToString:WMReviewFilterTypeMiddle]) {
                    config.title = [NSString stringWithFormat:@"%@(%zd)", WMLocalizedString(@"wm_evaluation_medium_reviews", @"中评"), countRspModel.middles];
                }
            }
            if (!self.headerView.filterView.isHidden) {
                [self.headerView.filterView reloadData];
            }
        }
        [self.headerView setNeedsUpdateConstraints];
    }];

    self.viewModel.successGetNewDataBlock = ^(NSMutableArray<WMStoreProductReviewModel *> *_Nonnull dataSource, BOOL hasNextPage) {
        @HDStrongify(self);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.dataSource = dataSource;
        [self.tableView successGetNewDataWithNoMoreData:!hasNextPage];
    };

    self.viewModel.successLoadMoreDataBlock = ^(NSMutableArray<WMStoreProductReviewModel *> *_Nonnull dataSource, BOOL hasNextPage) {
        @HDStrongify(self);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.dataSource = dataSource;
        [self.tableView successLoadMoreDataWithNoMoreData:!hasNextPage];
    };

    self.viewModel.failedGetNewDataBlock = ^(NSMutableArray<WMStoreProductReviewModel *> *_Nonnull dataSource) {
        @HDStrongify(self);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView failGetNewData];
    };

    self.viewModel.failedLoadMoreDataBlock = ^(NSMutableArray<WMStoreProductReviewModel *> *_Nonnull dataSource) {
        @HDStrongify(self);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView failLoadMoreData];
    };
}

- (void)updateConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [super updateConstraints];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.dataSource.count)
        return UITableViewCell.new;
    id model = self.dataSource[indexPath.row];

    if ([model isKindOfClass:WMStoreProductReviewModel.class]) {
        WMStoreProductReviewCell *cell = [WMStoreProductReviewCell cellWithTableView:tableView];
        ((WMStoreProductReviewModel *)model).cellType = WMStoreProductReviewCellTypeStoreReview;
        cell.model = model;
        @HDWeakify(cell);
        @HDWeakify(self);
        cell.clickedUserReviewContentReadMoreOrReadLessBlock = ^{
            @HDStrongify(cell);
            @HDStrongify(self);
            cell.model.isUserReviewContentExpanded = !cell.model.isUserReviewContentExpanded;
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        };

        cell.clickedMerchantReplyReadMoreOrReadLessBlock = ^{
            @HDStrongify(cell);
            @HDStrongify(self);
            cell.model.isMerchantReplyExpanded = !cell.model.isMerchantReplyExpanded;
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        };

        cell.clickedProductItemBlock = ^(NSString *_Nonnull goodsId, NSString *_Nonnull storeNo) {
            @HDStrongify(self);
            [self showloading];
            [self.viewModel getStoreProductDetailInfoWithGoodsId:goodsId success:^(WMStoreProductDetailRspModel *_Nonnull rspModel) {
                [self dismissLoading];
                if (rspModel.status == WMGoodsStatusOff) {
                    [NAT showToastWithTitle:nil content:WMLocalizedString(@"product_no_longer_available", @"product is no longer available") type:HDTopToastTypeError];
                } else {
                    [HDMediator.sharedInstance navigaveToStoreProductDetailController:@{@"goodsId": goodsId, @"storeNo": storeNo}];
                }
            } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
                [self dismissLoading];
            }];
        };

        return cell;
    } else if ([model isKindOfClass:SANoDataCellModel.class]) {
        SANoDataCell *cell = [SANoDataCell cellWithTableView:tableView];
        cell.model = model;

        return cell;
    }

    return UITableViewCell.new;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell hd_endSkeletonAnimation];
}

#pragma mark - private method

#pragma mark - lazy load
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.needRefreshHeader = true;
        _tableView.needRefreshFooter = true;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;
        _tableView.bounces = true;
        _tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
}

- (WMStoreReviewsHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[WMStoreReviewsHeaderView alloc] init];
    }
    return _headerView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    if (HDIsArrayEmpty(_dataSource)) {
        SANoDataCellModel *model = SANoDataCellModel.new;
        _dataSource = [NSMutableArray arrayWithObject:model];
    }
    return _dataSource;
}

- (HDSkeletonLayerDataSourceProvider *)provider {
    if (!_provider) {
        _provider = [[HDSkeletonLayerDataSourceProvider alloc] initWithTableViewCellBlock:^UITableViewCell<HDSkeletonLayerLayoutProtocol> *(UITableView *tableview, NSIndexPath *indexPath) {
            return [WMStoreProductReviewCell cellWithTableView:tableview];
        } heightBlock:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return [WMStoreProductReviewCell skeletonViewHeight];
        }];
        _provider.numberOfRowsInSection = 8;
    }
    return _provider;
}

@end
