//
//  TNCustomerViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNCustomerViewController.h"
#import "SATableView.h"
#import "TNMyCustomerDTO.h"
#import "TNMyCustomerItemCell+Skeleton.h"
#import "TNMyCustomerItemCell.h"
#import "TNMyCustomerItemHederView.h"


@interface TNCustomerViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) TNMyCustomerItemHederView *headerView;
/// 列表
@property (strong, nonatomic) SATableView *tableView;
/// 骨架 loading 生成器
@property (nonatomic, strong) HDSkeletonLayerDataSourceProvider *provider;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) TNMyCustomerDTO *myCustomerDTO;
@end


@implementation TNCustomerViewController

- (void)hd_setupViews {
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self.provider;
    self.tableView.dataSource = self.provider;
    [self.tableView getNewData];
    @HDWeakify(self);
    self.tableView.requestNewDataHandler = ^{
        @HDStrongify(self);
        self.currentPage = 1;
        [self getMyCustomerListData];
    };
    self.tableView.requestMoreDataHandler = ^{
        @HDStrongify(self);
        self.currentPage += 1;
        [self getMyCustomerListData];
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

#pragma mark - 获取店铺收藏列表数据
- (void)getMyCustomerListData {
    @HDWeakify(self);
    [self.myCustomerDTO queryMyCustomerListWithPageNum:self.currentPage pageSize:20 success:^(TNMyCustomerRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.currentPage = rspModel.pageNum;
        if (rspModel.pageNum == 1) {
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:rspModel.list];
            [self.tableView successGetNewDataWithNoMoreData:!rspModel.hasNextPage];
        } else {
            [self.dataArray addObjectsFromArray:rspModel.list];
            [self.tableView successLoadMoreDataWithNoMoreData:!rspModel.hasNextPage];
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView failGetNewData];
    }];
}

- (void)updateViewConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.mas_equalTo(self.view);
    }];
    [super updateViewConstraints];
}

#pragma mark tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count > 0 ? 1 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TNMyCustomerModel *model = [self.dataArray objectAtIndex:indexPath.row];
    TNMyCustomerItemCell *cell = [TNMyCustomerItemCell cellWithTableView:tableView];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell hd_endSkeletonAnimation];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        TNMyCustomerItemHederView *headerView = [TNMyCustomerItemHederView viewWithTableView:tableView];
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
        _tableView.estimatedSectionHeaderHeight = UITableViewAutomaticDimension;
        _tableView.sectionHeaderHeight = 45;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (HDSkeletonLayerDataSourceProvider *)provider {
    if (!_provider) {
        _provider = [[HDSkeletonLayerDataSourceProvider alloc] initWithTableViewCellBlock:^UITableViewCell<HDSkeletonLayerLayoutProtocol> *(UITableView *tableview, NSIndexPath *indexPath) {
            return [TNMyCustomerItemCell cellWithTableView:tableview];
        } heightBlock:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return [TNMyCustomerItemCell skeletonViewHeight];
        }];
    }
    return _provider;
}

- (TNMyCustomerDTO *)myCustomerDTO {
    if (!_myCustomerDTO) {
        _myCustomerDTO = [[TNMyCustomerDTO alloc] init];
    }
    return _myCustomerDTO;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - HDCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

@end
