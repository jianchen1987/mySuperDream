//
//  GNOrderViewController.m
//  SuperApp
//
//  Created by wmz on 2021/5/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNOrderViewController.h"
#import "GNOrderDetailViewController.h"


@interface GNOrderViewController () <GNTableViewProtocol>
/// tableView
@property (nonatomic, strong) GNTableView *tableView;
/// 骨架 loading 生成器
@property (nonatomic, strong) HDSkeletonLayerDataSourceProvider *provider;

@end


@implementation GNOrderViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.viewModel.dataSource && SAUser.hasSignedIn) {
        self.tableView.pageNum = 1;
        [self requestData:1];
    }
}

- (void)hd_bindViewModel {
    self.type = GNOrderFromGNList;
    [self.viewModel hd_bindView:self.view];
}

/// 获取列表数据
- (void)requestData:(NSInteger)pageNum {
    @HDWeakify(self);
    [self.viewModel getOrderListMore:self.tableView.pageNum bizState:self.orderStatus ?: @"" completion:^(GNOrderPagingRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.tableView.GNdelegate = self;
        self.viewModel.countDownList.count ? [self startTimer] : [self cancelTimer];
        if (rspModel) {
            [self.tableView reloadData:!rspModel.hasNextPage];
        } else {
            [self.tableView reloadFail];
        }
    }];
}

///刷新
- (void)updateUI {
    self.tableView.pageNum = 1;
    [self requestData:1];
}

- (void)updateViewConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [super updateViewConstraints];
}

- (void)hd_setupViews {
    [self.view addSubview:self.tableView];

    @HDWeakify(self);
    self.tableView.tappedRefreshBtnHandler = self.tableView.requestNewDataHandler = ^{
        @HDStrongify(self);
        if (!self.tableView.hd_hasData) {
            self.tableView.delegate = self.provider;
            self.tableView.dataSource = self.provider;
            [self.tableView reloadData];
        }
        [self requestData:self.tableView.pageNum];
    };
    self.tableView.requestMoreDataHandler = ^{
        @HDStrongify(self);
        [self requestData:self.tableView.pageNum];
    };
}

#pragma mark RespondEvent
- (void)respondEvent:(NSObject<GNEvent> *)event {
    [super respondEvent:event];
    /// 再次购买
    if ([event.key isEqualToString:@"bugAgain"]) {
        GNOrderCellModel *orderModel = self.viewModel.dataSource[event.indexPath.row];
        [HDMediator.sharedInstance
            navigaveToGNStoreProductViewController:@{@"storeNo": orderModel.merchantInfo.storeNo, @"productCode": orderModel.productInfo.productCode, @"fromOrder": @"bugAgain"}];
    }
    /// 前往门店
    else if ([event.key isEqualToString:@"storeAction"]) {
        [HDMediator.sharedInstance navigaveToGNStoreDetailViewController:@{@"storeNo": GNFillEmpty(event.info[@"storeNo"])}];
    }
}

#pragma mark GNTableViewProtocol
- (NSArray<id<GNRowModelProtocol>> *)numberOfRowsInGNTableView:(GNTableView *)tableView {
    return self.viewModel.dataSource;
}

- (void)GNTableView:(GNTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath data:(GNOrderCellModel<GNRowModelProtocol> *)rowData {
    [HDMediator.sharedInstance navigaveToGNOrderDetailViewController:@{@"orderNo": GNFillEmpty(rowData.orderNo)}];
}

///统一倒计时处理
- (void)refreshAction {
    @HDWeakify(self)[self.viewModel.countDownList enumerateObjectsUsingBlock:^(GNOrderCellModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        @HDStrongify(self) obj.payFailureTime = ((obj.payFailureTime / 1000) - 1) * 1000;
        if ([self.tableView numberOfRowsInSection:0] > obj.indexPath.row) {
            GNOrderTableViewCell *cell = [self.tableView cellForRowAtIndexPath:obj.indexPath];
            cell.countTime = obj.payFailureTime;
            if (obj.payFailureTime / 1000 <= 0) {
                @HDWeakify(self)[self getPaymentStateSuccess:^(SAQueryPaymentStateRspModel *_Nonnull rspModel) {
                    @HDStrongify(self)[self updateUI];
                } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
                    @HDStrongify(self)[self updateUI];
                }];
            }
        }
    }];
}

- (GNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[GNTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = HDAppTheme.color.gn_mainBgColor;
        _tableView.provider = self.provider;
        _tableView.delegate = self.provider;
        _tableView.dataSource = self.provider;
        _tableView.needRefreshBTN = YES;
        _tableView.needRefreshFooter = YES;
        _tableView.needRefreshHeader = YES;
        _tableView.needShowErrorView = YES;
        _tableView.needShowNoDataView = YES;
    }
    return _tableView;
}

- (GNOrderViewModel *)viewModel {
    return _viewModel ?: ({ _viewModel = GNOrderViewModel.new; });
}

- (HDSkeletonLayerDataSourceProvider *)provider {
    if (!_provider) {
        _provider = [[HDSkeletonLayerDataSourceProvider alloc] initWithTableViewCellBlock:^UITableViewCell<HDSkeletonLayerLayoutProtocol> *(UITableView *tableview, NSIndexPath *indexPath) {
            return [GNOrderTableViewCell cellWithTableView:tableview];
        } heightBlock:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return [GNOrderTableViewCell skeletonViewHeight];
        }];
    }
    return _provider;
}

@end
