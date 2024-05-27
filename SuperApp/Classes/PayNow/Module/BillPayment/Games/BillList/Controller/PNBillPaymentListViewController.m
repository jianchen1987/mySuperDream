//
//  PNBillPaymentListViewController.m
//  SuperApp
//
//  Created by 张杰 on 2022/12/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNBillPaymentListViewController.h"
#import "PNBillPaymentListCell.h"
#import "PNBillPaymentListDTO.h"
#import "PNTableView.h"


@interface PNBillPaymentListViewController () <UITableViewDelegate, UITableViewDataSource>
///
@property (strong, nonatomic) PNTableView *tableView;
///
@property (strong, nonatomic) NSMutableArray *dataArr;
///
@property (strong, nonatomic) PNBillPaymentListDTO *paymentDTO;
///
@property (nonatomic, assign) NSInteger currentPage;
@end


@implementation PNBillPaymentListViewController

- (void)hd_setupViews {
    [self.view addSubview:self.tableView];
    [self.tableView getNewData];
}
- (void)updateViewConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
    }];
    [super updateViewConstraints];
}
- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"Transaction_record", @"交易记录");
}

- (void)loadDataWithLoadMore:(BOOL)isLoadMore {
    if (isLoadMore) {
        self.currentPage += 1;
    } else {
        self.currentPage = 1;
    }
    @HDWeakify(self);
    [self.paymentDTO queryBillPaymentListWithPageNum:self.currentPage pageSize:20 success:^(PNBillPaymentRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        if (self.currentPage == 1) {
            [self.dataArr removeAllObjects];
            if (!HDIsArrayEmpty(rspModel.list)) {
                [self.dataArr addObjectsFromArray:rspModel.list];
            }
            [self.tableView successGetNewDataWithNoMoreData:!rspModel.hasNextPage];
        } else {
            if (!HDIsArrayEmpty(rspModel.list)) {
                [self.dataArr addObjectsFromArray:rspModel.list];
            }
            [self.tableView successLoadMoreDataWithNoMoreData:!rspModel.hasNextPage];
        }
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        if (self.currentPage == 1) {
            [self.tableView failGetNewData];
        } else {
            [self.tableView failLoadMoreData];
        }
    }];
}
#pragma mark
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PNBillPaymentListCell *cell = [PNBillPaymentListCell cellWithTableView:tableView];
    PNBillPaymentItemModel *model = self.dataArr[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PNBillPaymentItemModel *model = self.dataArr[indexPath.row];
    NSString *orderNo = HDIsStringNotEmpty(model.orderNo) ? model.orderNo : @"";
    NSString *tradeNo = HDIsStringNotEmpty(model.outPayOrderNo) ? model.outPayOrderNo : @"";
    [HDMediator.sharedInstance navigaveToPayNowPaymentBillOrderDetailsVC:@{@"orderNo": orderNo, @"tradeNo": tradeNo}];
}
- (PNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[PNTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        _tableView.needRefreshHeader = YES;
        _tableView.needRefreshFooter = YES;
        _tableView.estimatedRowHeight = kRealHeight(80);
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.needShowErrorView = YES;
        _tableView.backgroundColor = HexColor(0xF3F4FA);

        UIViewPlaceholderViewModel *model = [[UIViewPlaceholderViewModel alloc] init];
        model.title = SALocalizedString(@"no_data", @"暂无数据");
        model.image = @"pn_no_data_placeholder";
        _tableView.placeholderViewModel = model;

        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        footerView.backgroundColor = HexColor(0xF3F4FA);
        _tableView.tableFooterView = footerView;

        @HDWeakify(self);
        _tableView.requestNewDataHandler = ^{
            @HDStrongify(self);
            [self loadDataWithLoadMore:NO];
        };
        _tableView.requestMoreDataHandler = ^{
            @HDStrongify(self);
            [self loadDataWithLoadMore:YES];
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
/** @lazy paymentDTO */
- (PNBillPaymentListDTO *)paymentDTO {
    if (!_paymentDTO) {
        _paymentDTO = [[PNBillPaymentListDTO alloc] init];
    }
    return _paymentDTO;
}
@end
