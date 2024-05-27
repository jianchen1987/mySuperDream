//
//  TNSellerOrderView.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNSellerOrderView.h"
#import "SATableView.h"
#import "TNSellerOrderCell+Skeleton.h"
#import "TNSellerOrderCell.h"
#import "TNSellerOrderFooterView.h"
#import "TNSellerOrderHeaderView.h"


@interface TNSellerOrderView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) SATableView *tableView;
@property (strong, nonatomic) TNSellerOrderDTO *dto;
///当前页码
@property (nonatomic, assign) NSInteger currentPage;
///是否有下一页
@property (nonatomic, assign) BOOL hasNextPage;
/// 数据源
@property (strong, nonatomic) NSMutableArray<TNSellerOrderModel *> *dataArr;
/// 查询的订单类型
@property (nonatomic, assign) TNSellerOrderStatus status;
/// 骨架 loading 生成器
@property (nonatomic, strong) HDSkeletonLayerDataSourceProvider *provider;
@end


@implementation TNSellerOrderView
- (instancetype)initWithStatus:(TNSellerOrderStatus)status {
    if (self = [super init]) {
        self.status = status;
        [self getProductListData:NO];
    }
    return self;
}
- (void)hd_setupViews {
    [self addSubview:self.tableView];
    if (!self.tableView.hd_hasData) {
        if (SAUser.hasSignedIn) {
            self.tableView.dataSource = self.provider;
            self.tableView.delegate = self.provider;
        }
        [self.tableView successGetNewDataWithNoMoreData:true];
    }
}
#pragma mark -获取列表数据
- (void)getProductListData:(BOOL)isLoadMore {
    if (!isLoadMore) {
        self.currentPage = 1;
    } else {
        self.currentPage += 1;
    }
    @HDWeakify(self);
    [self.dto querySellerOrderListWithPageNo:self.currentPage pageSize:20 status:self.status success:^(TNSellerOrderRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        if (self.currentPage == 1) {
            [self.dataArr removeAllObjects];
            [self.dataArr addObjectsFromArray:rspModel.content];
            [self.tableView successGetNewDataWithNoMoreData:!rspModel.hasNextPage];
        } else {
            [self.dataArr addObjectsFromArray:rspModel.content];
            [self.tableView successLoadMoreDataWithNoMoreData:!rspModel.hasNextPage];
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.dataArr removeAllObjects];
        [self.tableView failGetNewData];
    }];
}

- (void)updateConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [super updateConstraints];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    TNSellerOrderModel *model = self.dataArr[section];
    return model.supplierProductDTOList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TNSellerOrderCell *cell = [TNSellerOrderCell cellWithTableView:tableView];
    TNSellerOrderModel *model = self.dataArr[indexPath.section];
    TNSellerOrderProductsModel *productModel = model.supplierProductDTOList[indexPath.row];
    cell.overseaChannel = model.overseaChannel;
    cell.model = productModel;
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TNSellerOrderHeaderView *headerView = [TNSellerOrderHeaderView headerWithTableView:tableView];
    TNSellerOrderModel *model = self.dataArr[section];
    headerView.model = model;
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    TNSellerOrderFooterView *footerView = [TNSellerOrderFooterView headerWithTableView:tableView];
    TNSellerOrderModel *model = self.dataArr[section];
    footerView.model = model;
    return footerView;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:false];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell hd_endSkeletonAnimation];
}
#pragma mark - lazy load
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = YES;
        _tableView.needRefreshFooter = YES;
        _tableView.needShowErrorView = YES;
        _tableView.needShowNoDataView = YES;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
        _tableView.sectionFooterHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 110;
        _tableView.estimatedSectionHeaderHeight = 100;
        _tableView.estimatedSectionFooterHeight = 100;
        _tableView.backgroundColor = HDAppTheme.TinhNowColor.G5;
        @HDWeakify(self);
        _tableView.requestNewDataHandler = ^{
            @HDStrongify(self);
            [self getProductListData:NO];
        };
        _tableView.requestMoreDataHandler = ^{
            @HDStrongify(self);
            [self getProductListData:YES];
        };
    }
    return _tableView;
}
/** @lazy dto */
- (TNSellerOrderDTO *)dto {
    if (!_dto) {
        _dto = [[TNSellerOrderDTO alloc] init];
    }
    return _dto;
}
/** @lazy dataArr */
- (NSMutableArray<TNSellerOrderModel *> *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
- (HDSkeletonLayerDataSourceProvider *)provider {
    if (!_provider) {
        _provider = [[HDSkeletonLayerDataSourceProvider alloc] initWithTableViewCellBlock:^UITableViewCell<HDSkeletonLayerLayoutProtocol> *(UITableView *tableview, NSIndexPath *indexPath) {
            return [TNSellerOrderCell cellWithTableView:tableview];
        } heightBlock:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return [TNSellerOrderCell skeletonViewHeight];
        }];
        _provider.numberOfRowsInSection = 10;
    }
    return _provider;
}
#pragma mark - HDCategoryListContentViewDelegate
- (UIView *)listView {
    return self;
}

@end
