//
//  PNInterTransferRecordsViewController.m
//  SuperApp
//
//  Created by 张杰 on 2022/6/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInterTransferRecordsViewController.h"
#import "NSString+SA_Extension.h"
#import "PNCommonUtils.h"
#import "PNInterTransferRecordCell.h"
#import "PNInterTransferRecordDTO.h"
#import "PNInterTransferRecordHeaderView.h"
#import "PNInterTransferRecordRspModel.h"
#import "PNTableView.h"


@interface PNInterTransferRecordsViewController () <UITableViewDelegate, UITableViewDataSource>
/// 列表视图
@property (strong, nonatomic) PNTableView *tableView;
///
@property (strong, nonatomic) NSMutableArray *dataArr;
///
@property (strong, nonatomic) PNInterTransferRecordDTO *recordDto;
///
@property (nonatomic, assign) NSInteger currentPage;
@end


@implementation PNInterTransferRecordsViewController
- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"tvy0oIAQ", @"转账记录");
}

- (void)hd_setupViews {
    [self.view addSubview:self.tableView];
    [self.tableView getNewData];
}

- (void)loadData:(BOOL)isLoadMore {
    if (isLoadMore) {
        self.currentPage += 1;
    } else {
        self.currentPage = 1;
    }
    @HDWeakify(self);
    [self.recordDto queryInterTransferRecordListWithPageNum:self.currentPage pageSize:10 success:^(PNInterTransferRecordRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        if (self.currentPage == 1) {
            [self.dataArr removeAllObjects];
            [self processData:rspModel.list];
            [self.tableView successGetNewDataWithNoMoreData:!rspModel.hasNextPage];
        } else {
            [self processData:rspModel.list];
            [self.tableView successLoadMoreDataWithNoMoreData:!rspModel.hasNextPage];
        }
        self.currentPage = rspModel.pageNum;
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        self.currentPage == 1 ? [self.tableView failGetNewData] : [self.tableView failLoadMoreData];
    }];
}

//处理数据
- (void)processData:(NSArray<PNInterTransRecordModel *> *)list {
    if (!HDIsArrayEmpty(list)) {
        for (PNInterTransRecordModel *model in list) {
            [self insertBillListModel:model];
        }
        // 做一次排序
        NSArray *sortArr = [self.dataArr sortedArrayWithOptions:NSSortStable usingComparator:^NSComparisonResult(HDTableViewSectionModel *_Nonnull model1, HDTableViewSectionModel *_Nonnull model2) {
            NSTimeInterval time1 = [model1.commonHeaderModel doubleValue];
            NSTimeInterval time2 = [model2.commonHeaderModel doubleValue];
            if (time1 > time2) {
                return NSOrderedAscending;
            } else {
                return NSOrderedDescending;
            }
        }];

        [self.dataArr removeAllObjects];
        [self.dataArr addObjectsFromArray:sortArr];
    }
}

#pragma mark - data cleaning
- (void)insertBillListModel:(PNInterTransRecordModel *)model {
    NSString *sectionName = nil;
    sectionName = [PNCommonUtils getDateStrByFormat:@"MM/yyyy" withDate:[NSDate dateWithTimeIntervalSince1970:model.createTime.floatValue / 1000]];

    for (HDTableViewSectionModel *sectionModel in self.dataArr) {
        if ([sectionModel.headerModel.title isEqualToString:sectionName]) {
            NSMutableArray *tempArr = [NSMutableArray arrayWithArray:sectionModel.list];
            [tempArr addObject:model];
            sectionModel.list = tempArr;
            //            [sectionModel.list sortedArrayWithOptions:NSSortStable
            //                                    usingComparator:^NSComparisonResult(PNInterTransRecordModel * obj1, PNInterTransRecordModel * obj2) {
            //                                        return [obj2.createTime compare:obj1.createTime];
            //                                    }];
            return;
        }
    }

    HDTableViewSectionModel *sectionModel = [[HDTableViewSectionModel alloc] init];
    sectionModel.headerModel = [[HDTableHeaderFootViewModel alloc] init];
    sectionModel.headerModel.title = sectionName;
    NSTimeInterval timeInterval = [[sectionName dateWithFormat:@"MM/yyyy"] timeIntervalSince1970];
    sectionModel.commonHeaderModel = [NSString stringWithFormat:@"%f", timeInterval];

    NSMutableArray *tempArr = [NSMutableArray array];
    [tempArr addObject:model];
    sectionModel.list = tempArr;
    [self.dataArr addObject:sectionModel];
}

- (void)updateViewConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];
    [super updateViewConstraints];
}

#pragma mark -tableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.dataArr[section];
    return sectionModel.list.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.dataArr[section];
    if (!HDIsObjectNil(sectionModel.headerModel)) {
        PNInterTransferRecordHeaderView *headerView = [PNInterTransferRecordHeaderView headerWithTableView:tableView];
        if ([sectionModel.headerModel.title isEqualToString:[PNCommonUtils getCurrentDateStrByFormat:@"MM/yyyy"]]) {
            headerView.title = PNLocalizedString(@"PAGE_TEXT_CURRENT_MONTH", @"本月");
        } else {
            headerView.title = sectionModel.headerModel.title;
        }
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HDTableViewSectionModel *sectionModel = self.dataArr[indexPath.section];
    PNInterTransRecordModel *model = sectionModel.list[indexPath.row];
    PNInterTransferRecordCell *cell = [PNInterTransferRecordCell cellWithTableView:tableView];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HDTableViewSectionModel *sectionModel = self.dataArr[indexPath.section];
    PNInterTransRecordModel *model = sectionModel.list[indexPath.row];
    [HDMediator.sharedInstance navigaveToInternationalTransferRecordsDetailVC:@{
        @"recordModel": model,
    }];
}

- (PNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[PNTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        _tableView.needRefreshHeader = YES;
        _tableView.needRefreshFooter = YES;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        @HDWeakify(self);
        _tableView.requestNewDataHandler = ^{
            @HDStrongify(self);
            [self loadData:NO];
        };
        _tableView.requestMoreDataHandler = ^{
            @HDStrongify(self);
            [self loadData:YES];
        };
    }
    return _tableView;
}

/** @lazy dataArr */
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

/** @lazy recordDto */
- (PNInterTransferRecordDTO *)recordDto {
    if (!_recordDto) {
        _recordDto = [[PNInterTransferRecordDTO alloc] init];
    }
    return _recordDto;
}
@end
