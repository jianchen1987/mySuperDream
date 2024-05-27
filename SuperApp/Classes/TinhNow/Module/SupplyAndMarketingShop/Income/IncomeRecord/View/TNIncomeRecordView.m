//
//  TNIncomeRecordView.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNIncomeRecordView.h"
#import "HDAppTheme+TinhNow.h"
#import "SATableView.h"
#import "SATalkingData.h"
#import "TNIncomRecordItemCell+Skeleton.h"
#import "TNIncomRecordItemCell.h"
#import "TNIncomeFilterCell.h"
#import "TNIncomeRecordListHeaderView.h"
#import "TNIncomeRecordListView.h"
#import "TNIncomeToggleHeaderView.h"
#import "TNIncomeViewModel.h"
#import "TNInconmeAssetsCell.h"


@interface TNIncomeRecordView () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) TNIncomeViewModel *viewModel;
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


@implementation TNIncomeRecordView
- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}
- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self];
    [self.tableView successGetNewDataWithNoMoreData:true];
    @HDWeakify(self);
    self.viewModel.incomeGetDataFaild = ^{
        @HDStrongify(self);
        [self showErrorPlaceHolderNeedRefrenshBtn:YES refrenshCallBack:^{
            [self.viewModel getIncomeData];
            //列表的数据 也重新来一次
            [self.viewModel recordGetNewData];
        }];
    };

    self.viewModel.recordListGetNewDataFaild = ^{
        @HDStrongify(self);
        [self.tableView failGetNewData];
    };
    self.tableView.requestNewDataHandler = ^{
        @HDStrongify(self);
        [self.viewModel getIncomeData];
        [self.viewModel recordGetNewData];
    };
    self.tableView.requestMoreDataHandler = ^{
        @HDStrongify(self);
        [self.viewModel recordLoadMoreData];
    };
    self.tableView.tappedRefreshBtnHandler = ^{
        @HDStrongify(self);
        if (!self.tableView.hd_hasData) {
            [self.tableView successGetNewDataWithNoMoreData:true];
        }
    };
    [self.KVOController hd_observe:self.viewModel keyPath:@"incomeRefreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self.tableView successLoadMoreDataWithNoMoreData:!self.viewModel.recordHasNextPage];
    }];
    [self.KVOController hd_observe:self.viewModel keyPath:@"commitionSumRefreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self.tableView successLoadMoreDataWithNoMoreData:!self.viewModel.recordHasNextPage];
    }];

    [self.KVOController hd_observe:self.viewModel keyPath:@"recordRefreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);

        if (!HDIsArrayEmpty(self.viewModel.recordList)) {
            self.listSectionModel.list = self.viewModel.recordList;
        } else {
            SANoDataCellModel *noDataModel = [[SANoDataCellModel alloc] init];
            if (!self.viewModel.filterModel.isCleanFilter) {
                noDataModel.descText = TNLocalizedString(@"7LIDsWGg", @"没有相关搜索数据，请换个搜索条件");
            } else {
                noDataModel.descText = SALocalizedString(@"no_data", @"暂无数据");
            }
            self.listSectionModel.list = @[noDataModel];
        }

        if (self.viewModel.recordCurrentPage == 1) {
            [self.tableView successGetNewDataWithNoMoreData:!self.viewModel.recordHasNextPage];
        } else {
            [self.tableView successLoadMoreDataWithNoMoreData:!self.viewModel.recordHasNextPage];
        }
    }];

    //请求收益列表数据
    [self.viewModel recordGetNewData];
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
        [self.tableView successLoadMoreDataWithNoMoreData:!self.viewModel.recordHasNextPage];
    } else {
        [self.viewModel getCommissionSum];
    }

    [self.viewModel recordGetNewDataWithLoading:YES];
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
        TNInconmeAssetsCell *cell = [TNInconmeAssetsCell cellWithTableView:tableView];
        cell.incomeModel = self.viewModel.incomeModel;
        @HDWeakify(self);
        cell.withDrawClickCallBack = ^{
            @HDStrongify(self);
            void (^callBack)(void) = ^{
                //列表的数据 也重新来一次
                [self.viewModel recordGetNewData];
            };
            [HDMediator.sharedInstance navigaveToTinhNowWithdrawBindViewController:@{@"amount": self.viewModel.incomeModel.commissionBalanceMoney, @"callBack": callBack}];
        };
        cell.preIncomeClickCallBack = ^{
            @HDStrongify(self);
            [HDMediator.sharedInstance
                navigaveToTinhNowPreIncomeRecordViewController:@{@"frozenCommissionBalanceMoney": self.viewModel.incomeModel.frozenCommissionBalanceMoney.thousandSeparatorAmount}];
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
            [self.tableView successLoadMoreDataWithNoMoreData:!self.viewModel.recordHasNextPage];
        };
        return cell;
    } else if (sectionModel == self.commonSectionModel) {
        TNIncomRecordItemCommonHeaderCell *cell = [TNIncomRecordItemCommonHeaderCell cellWithTableView:tableView];
        return cell;
    } else if (sectionModel == self.listSectionModel) {
        id model = sectionModel.list[indexPath.row];
        if ([model isKindOfClass:[SANoDataCellModel class]]) {
            TNIncomeNoDataCell *cell = [TNIncomeNoDataCell cellWithTableView:tableView];
            cell.model = model;
            return cell;
        } else if ([model isKindOfClass:[TNIncomeRecordItemModel class]]) {
            TNIncomRecordItemCell *cell = [TNIncomRecordItemCell cellWithTableView:tableView];
            cell.isPreIncomeList = NO;
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
        if ([tempModel isKindOfClass:[TNIncomeRecordItemModel class]]) {
            TNIncomeRecordItemModel *model = (TNIncomeRecordItemModel *)tempModel;
            if (model.type == TNIncomeRecordItemTypeIncome || model.type == TNIncomeRecordItemTypePartTimeDeduct) {
                [SAWindowManager openUrl:@"SuperApp://TinhNow/IncomeDetail" withParameters:@{@"id": model.objId, @"type": @(model.type)}];
            } else {
                [SAWindowManager openUrl:@"SuperApp://TinhNow/WithDrawDetail" withParameters:@{@"id": model.objId}];
            }
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
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    CGFloat targetCellOffSet = [self.tableView rectForSection:1].origin.y;
//    HDLog(@"headerView 的 frame - %@",NSStringFromCGRect(self.headerView.frame));
//    if (scrollView.contentOffset.y > targetCellOffSet) {
//        HDLog(@"移动到第一个section了");
//    }
//}
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
