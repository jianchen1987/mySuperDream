//
//  TNNewIncomeIndexView.m
//  SuperApp
//
//  Created by 张杰 on 2022/9/23.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNNewIncomeIndexView.h"
#import "HDAppTheme+TinhNow.h"
#import "SATableView.h"
#import "SATalkingData.h"
#import "TNIncomRecordItemCell+Skeleton.h"
#import "TNIncomRecordItemCell.h"
#import "TNIncomeFilterCell.h"
#import "TNIncomeListFilterModel.h"
#import "TNIncomeRecordListHeaderView.h"
#import "TNIncomeRecordListView.h"
#import "TNIncomeToggleHeaderView.h"
#import "TNNewIncomeAssetsCell.h"
#import "TNNewIncomeIndexItemCell.h"
#import "TNNewIncomeViewModel.h"


@interface TNNewIncomeIndexView () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) TNNewIncomeViewModel *viewModel;
@property (nonatomic, strong) SATableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
/// 收益section
@property (strong, nonatomic) HDTableViewSectionModel *incomeSectionModel;
/// 筛选section
@property (strong, nonatomic) HDTableViewSectionModel *filterSectionModel;
/// 列表secion
@property (strong, nonatomic) HDTableViewSectionModel *listSectionModel;
/// 列表头部secion
@property (strong, nonatomic) HDTableViewSectionModel *commonSectionModel;
///
@property (strong, nonatomic) TNIncomeToggleHeaderView *headerView;
@end


@implementation TNNewIncomeIndexView
- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}
- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self];
    [self.tableView successGetNewDataWithNoMoreData:true];
    @HDWeakify(self);
    self.viewModel.getNewDataFaild = ^{
        @HDStrongify(self);
        [self.tableView failGetNewData];
    };
    self.viewModel.loadMoreDataFaild = ^{
        @HDStrongify(self);
        [self.tableView failLoadMoreData];
    };
    self.tableView.requestNewDataHandler = ^{
        @HDStrongify(self);
        [self getProfitSettleData];
        [self.viewModel getNewListDataWithLoading:NO];
    };
    self.tableView.requestMoreDataHandler = ^{
        @HDStrongify(self);
        [self.viewModel loadMoreListData];
    };
    self.tableView.tappedRefreshBtnHandler = ^{
        @HDStrongify(self);
        if (!self.tableView.hd_hasData) {
            [self.tableView successGetNewDataWithNoMoreData:true];
        }
    };

    [self.KVOController hd_observe:self.viewModel keyPath:@"incomeRefreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);

        if (!HDIsArrayEmpty(self.viewModel.list)) {
            self.listSectionModel.list = self.viewModel.list;
        } else {
            SANoDataCellModel *noDataModel = [[SANoDataCellModel alloc] init];
            if (!self.viewModel.filterModel.isCleanFilter) {
                noDataModel.descText = TNLocalizedString(@"7LIDsWGg", @"没有相关搜索数据，请换个搜索条件");
            } else {
                noDataModel.descText = SALocalizedString(@"no_data", @"暂无数据");
            }
            self.listSectionModel.list = @[noDataModel];
        }

        if (self.viewModel.currentPage == 1) {
            [self.tableView successGetNewDataWithNoMoreData:!self.viewModel.hasNextPage];
        } else {
            [self.tableView successLoadMoreDataWithNoMoreData:!self.viewModel.hasNextPage];
        }
    }];
    [self getProfitSettleData];
    [self.viewModel getNewListDataWithLoading:NO];
}
- (void)getProfitSettleData {
    @HDWeakify(self);
    [self.viewModel getProfitIncomeDataCompletion:^(BOOL isSucess) {
        @HDStrongify(self);
        if (isSucess) {
            [self.tableView successGetNewDataWithNoMoreData:YES scrollToTop:NO];
        } else {
            [self showErrorPlaceHolderNeedRefrenshBtn:YES refrenshCallBack:^{
                [self getProfitSettleData];
                //列表的数据 也重新来一次
                [self.viewModel getNewListDataWithLoading:NO];
            }];
        }
    }];
}
#pragma mark -UI
- (void)hd_setupViews {
    self.dataArray = @[self.incomeSectionModel, self.filterSectionModel, self.commonSectionModel, self.listSectionModel];
    self.backgroundColor = HDAppTheme.TinhNowColor.cF5F7FA;
    [self addSubview:self.tableView];
}

- (void)updateConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [super updateConstraints];
}
#pragma mark -筛选数据
- (void)queryFilterData {
    if (self.viewModel.filterModel.isCleanFilter) {
        //没有扔个筛选条件 不请求合计数
        self.viewModel.commissionSumModel = nil;
        [self.tableView successGetNewDataWithNoMoreData:!self.viewModel.hasNextPage scrollToTop:NO];
    } else {
        [self.viewModel getIncomeSettlementSumCompletion:^{
            [self.tableView successGetNewDataWithNoMoreData:!self.viewModel.hasNextPage scrollToTop:NO];
        }];
    }
    [self.viewModel getNewListDataWithLoading:YES];
}
#pragma mark

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:TNIncomRecordItemSkeletonCell.class]) {
        [cell hd_beginSkeletonAnimation];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.dataArray[section];
    return sectionModel.list.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HDTableViewSectionModel *sectionModel = self.dataArray[indexPath.section];
    if (sectionModel == self.incomeSectionModel) {
        TNNewIncomeAssetsCell *cell = [TNNewIncomeAssetsCell cellWithTableView:tableView];
        cell.queryMode = self.viewModel.filterModel.queryMode;
        cell.incomeModel = self.viewModel.profitModel;
        @HDWeakify(self);
        cell.settledAndPreIncomeToggleCallBack = ^(NSInteger queryMode) {
            @HDStrongify(self);
            self.viewModel.filterModel.queryMode = queryMode;
            if (!self.viewModel.filterModel.isCleanFilter) {
                [self.viewModel getIncomeSettlementSumCompletion:^{
                    [self.tableView successGetNewDataWithNoMoreData:!self.viewModel.hasNextPage scrollToTop:NO];
                }];
            }
            [self.viewModel getNewListDataWithLoading:YES];
        };
        return cell;
    } else if (sectionModel == self.filterSectionModel) {
        TNIncomeFilterCell *cell = [TNIncomeFilterCell cellWithTableView:tableView];
        cell.filterModel = self.viewModel.filterModel;
        cell.sumModel = self.viewModel.commissionSumModel;
        @HDWeakify(self);
        cell.filterClickCallBack = ^(TNIncomeListFilterModel *_Nonnull filterModel) {
            @HDStrongify(self);
            [self queryFilterData];
        };
        cell.dropCellCallBack = ^{
            @HDStrongify(self);
            [self.tableView successLoadMoreDataWithNoMoreData:!self.viewModel.hasNextPage];
        };
        return cell;
    } else if (sectionModel == self.commonSectionModel) {
        TNIncomRecordItemCommonHeaderCell *cell = [TNIncomRecordItemCommonHeaderCell cellWithTableView:tableView];
        cell.queryMode = self.viewModel.filterModel.queryMode;
        return cell;
    } else if (sectionModel == self.listSectionModel) {
        id model = sectionModel.list[indexPath.row];
        if ([model isKindOfClass:[SANoDataCellModel class]]) {
            TNIncomeNoDataCell *cell = [TNIncomeNoDataCell cellWithTableView:tableView];
            cell.model = model;
            return cell;
        } else if ([model isKindOfClass:[TNNewIncomeItemModel class]]) {
            TNNewIncomeIndexItemCell *cell = [TNNewIncomeIndexItemCell cellWithTableView:tableView];
            cell.queryMode = self.viewModel.filterModel.queryMode;
            cell.model = model;
            if (indexPath.row == (sectionModel.list.count - 1)) {
                cell.isLast = YES;
            } else {
                cell.isLast = NO;
            }
            return cell;
        } else {
            TNIncomRecordItemSkeletonCell *cell = [TNIncomRecordItemSkeletonCell cellWithTableView:tableView];
            return cell;
        }
    }
    return UITableViewCell.new;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HDTableViewSectionModel *sectionModel = self.dataArray[indexPath.section];
    if (sectionModel == self.listSectionModel) {
        id tempModel = sectionModel.list[indexPath.row];
        if ([tempModel isKindOfClass:[TNNewIncomeItemModel class]]) {
            TNNewIncomeItemModel *model = (TNNewIncomeItemModel *)tempModel;
            [SAWindowManager openUrl:@"SuperApp://TinhNow/IncomeDetail" withParameters:@{@"id": model.objId}];
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.dataArray[section];
    if (sectionModel == self.filterSectionModel) {
        self.headerView = [TNIncomeToggleHeaderView headerWithTableView:tableView];
        @HDWeakify(self);
        self.headerView.itemClickCallBack = ^(TNSellerIdentityType type) {
            @HDStrongify(self);
            self.viewModel.filterModel.supplierType = type;
            [self queryFilterData];
        };
        return self.headerView;
    } else {
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.dataArray[section];
    if (sectionModel == self.filterSectionModel) {
        return kRealWidth(50);
    } else {
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HDTableViewSectionModel *sectionModel = self.dataArray[indexPath.section];
    if (sectionModel == self.listSectionModel) {
        id tempModel = sectionModel.list[indexPath.row];
        if ([tempModel isKindOfClass:[SANoDataCellModel class]]) {
            return kRealWidth(250);
        } else if ([tempModel isKindOfClass:[TNIncomeRecordItemModel class]]) {
            return UITableViewAutomaticDimension;
        } else {
            return kRealWidth(80);
        }
    } else {
        return UITableViewAutomaticDimension;
    }
}
#pragma mark
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor hd_colorWithHexString:@"#F5F7FA"];
        _tableView.needRefreshHeader = YES;
        _tableView.needRefreshFooter = YES;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
/** @lazy incomeSectionModel */
- (HDTableViewSectionModel *)incomeSectionModel {
    if (!_incomeSectionModel) {
        _incomeSectionModel = [[HDTableViewSectionModel alloc] init];
        _incomeSectionModel.list = @[@""];
    }
    return _incomeSectionModel;
}
/** @lazy filterSectionModel */
- (HDTableViewSectionModel *)filterSectionModel {
    if (!_filterSectionModel) {
        _filterSectionModel = [[HDTableViewSectionModel alloc] init];
        _filterSectionModel.list = @[@""];
    }
    return _filterSectionModel;
}
/** @lazy listSectionModel */
- (HDTableViewSectionModel *)listSectionModel {
    if (!_listSectionModel) {
        _listSectionModel = [[HDTableViewSectionModel alloc] init];
        _listSectionModel.list = @[@"skeleton", @"skeleton", @"skeleton", @"skeleton", @"skeleton", @"skeleton", @"skeleton"];
    }
    return _listSectionModel;
}
/** @lazy listSectionModel */
- (HDTableViewSectionModel *)commonSectionModel {
    if (!_commonSectionModel) {
        _commonSectionModel = [[HDTableViewSectionModel alloc] init];
        _commonSectionModel.list = @[@""];
    }
    return _commonSectionModel;
}

@end
