//
//  TNIncomeRecordListView.m
//  SuperApp
//
//  Created by xixi_wen on 2021/12/14.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNIncomeRecordListView.h"
#import "SATableView.h"
#import "TNIncomRecordItemCell+Skeleton.h"
#import "TNIncomRecordItemCell.h"
#import "TNIncomeRecordListHeaderView.h"
#import "TNIncomeViewModel.h"


@interface TNIncomeRecordListView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) SATableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) HDSkeletonLayerDataSourceProvider *provider;
@property (strong, nonatomic) TNIncomeViewModel *viewModel; ///<
@end


@implementation TNIncomeRecordListView
- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}
#pragma mark -处理收益列表数据
- (void)bindRecordListData {
    @HDWeakify(self);
    self.viewModel.recordListGetNewDataFaild = ^{
        @HDStrongify(self);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView failGetNewData];
    };
    [self.KVOController hd_observe:self.viewModel keyPath:@"recordRefreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.dataArray = self.viewModel.recordList;
        if (self.viewModel.recordCurrentPage == 1) {
            [self.tableView successGetNewDataWithNoMoreData:!self.viewModel.recordHasNextPage];
        } else {
            [self.tableView successLoadMoreDataWithNoMoreData:!self.viewModel.recordHasNextPage];
        }
    }];
}
#pragma mark -处理预估列表数据
- (void)bindPreRecordListData {
    @HDWeakify(self);
    self.viewModel.preRecordListGetNewDataFaild = ^{
        @HDStrongify(self);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView failGetNewData];
    };
    [self.KVOController hd_observe:self.viewModel keyPath:@"preRecordRefreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.dataArray = self.viewModel.preRecordList;
        if (self.viewModel.preRecordCurrentPage == 1) {
            [self.tableView successGetNewDataWithNoMoreData:!self.viewModel.preRecordHasNextPage];
        } else {
            [self.tableView successLoadMoreDataWithNoMoreData:!self.viewModel.preRecordHasNextPage];
        }
    }];
}

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.TinhNowColor.cFFFFFF;
    //    self.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
    //        [view setRoundedCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight radius:kRealWidth(8)];
    //    };
    [self addSubview:self.tableView];

    @HDWeakify(self);
    self.tableView.requestNewDataHandler = ^{
        @HDStrongify(self);
        if (self.isPreIncomeListView) {
            [self.viewModel preRecordGetNewData];
        } else {
            [self.viewModel recordGetNewData];
        }
    };
    self.tableView.requestMoreDataHandler = ^{
        @HDStrongify(self);
        if (self.isPreIncomeListView) {
            [self.viewModel preRecordLoadMoreData];
        } else {
            [self.viewModel recordLoadMoreData];
        }
    };
    self.tableView.tappedRefreshBtnHandler = ^{
        @HDStrongify(self);
        if (!self.tableView.hd_hasData) {
            self.tableView.dataSource = self.provider;
            self.tableView.delegate = self.provider;
            [self.tableView successGetNewDataWithNoMoreData:true];
        }
    };
}
- (void)setIsPreIncomeListView:(BOOL)isPreIncomeListView {
    _isPreIncomeListView = isPreIncomeListView;
    if (isPreIncomeListView) {
        [self bindPreRecordListData];
    } else {
        [self bindRecordListData];
    }
}

- (void)updateConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(self);
    }];
    [super updateConstraints];
}

#pragma mark

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell hd_endSkeletonAnimation];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count > 0 ? 1 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TNIncomRecordItemCell *cell = [TNIncomRecordItemCell cellWithTableView:tableView];
    cell.isPreIncomeList = self.isPreIncomeListView;
    TNIncomeRecordItemModel *model = [self.dataArray objectAtIndex:indexPath.row];
    cell.model = model;
    if (indexPath.row == (self.dataArray.count - 1)) {
        cell.isLast = YES;
    } else {
        cell.isLast = NO;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TNIncomeRecordItemModel *model = [self.dataArray objectAtIndex:indexPath.row];
    if (self.isPreIncomeListView) {
        [SAWindowManager openUrl:@"SuperApp://TinhNow/IncomeDetail" withParameters:@{@"id": model.objId, @"type": @(model.type)}];
    } else {
        if (model.type == TNIncomeRecordItemTypeIncome) {
            [SAWindowManager openUrl:@"SuperApp://TinhNow/IncomeDetail" withParameters:@{@"id": model.objId, @"type": @(model.type)}];
        } else {
            [SAWindowManager openUrl:@"SuperApp://TinhNow/WithDrawDetail" withParameters:@{@"id": model.objId}];
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        TNIncomeRecordListHeaderView *headerView = [TNIncomeRecordListHeaderView viewWithTableView:tableView];
        return headerView;
    } else {
        return nil;
    }
}

#pragma mark
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor hd_colorWithHexString:@"#F5F7FA"];
        _tableView.needRefreshHeader = YES;
        _tableView.needRefreshFooter = YES;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.mj_footer.hidden = YES;
        _tableView.delegate = self.provider;
        _tableView.dataSource = self.provider;
        _tableView.estimatedSectionHeaderHeight = UITableViewAutomaticDimension;
        _tableView.sectionHeaderHeight = 45;
    }
    return _tableView;
}

- (HDSkeletonLayerDataSourceProvider *)provider {
    if (!_provider) {
        _provider = [[HDSkeletonLayerDataSourceProvider alloc] initWithTableViewCellBlock:^UITableViewCell<HDSkeletonLayerLayoutProtocol> *(UITableView *tableview, NSIndexPath *indexPath) {
            return [TNIncomRecordItemCell cellWithTableView:tableview];
        } heightBlock:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return [TNIncomRecordItemCell skeletonViewHeight];
        }];
    }
    return _provider;
}

@end
