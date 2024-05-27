//
//  PNApartmentRecordListView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNApartmentRecordListView.h"
#import "PNTableView.h"
#import "PNOperationButton.h"
#import "PNTableView.h"
#import "PNApartmentListCell.h"
#import "PNApartmentDTO.h"


@interface PNApartmentRecordListView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) PNTableView *tableView;
@property (nonatomic, assign) PNApartmentListCellType cellType;

@property (nonatomic, strong) PNApartmentDTO *apartmentDTO;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray<PNApartmentListItemModel *> *dataSource;
@property (nonatomic, copy) PNCurrencyType currency;
@end


@implementation PNApartmentRecordListView

- (void)getNewData {
    self.currentPage = 1;
    [self.tableView getNewData];
}

- (void)hd_setupViews {
    self.cellType = PNApartmentListCellType_OrderList;
    self.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;

    [self addSubview:self.tableView];
}

- (void)updateConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.top.mas_equalTo(self.mas_top).offset(kRealWidth(12));
    }];

    [super updateConstraints];
}

#pragma mark
- (void)getData {
    @HDWeakify(self);

    NSMutableArray *tempStatus = [NSMutableArray array];
    if (![self.statusArray containsObject:@(PNApartmentPaymentStatus_ALL)]) {
        tempStatus = [NSMutableArray arrayWithArray:self.statusArray];
    }

    [self.apartmentDTO getApartmentListData:self.startDate endTime:self.endDate currentPage:self.currentPage status:tempStatus success:^(PNApartmentListRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        NSArray<PNApartmentListItemModel *> *list = rspModel.list;
        if (self.currentPage == 1) {
            [self.dataSource removeAllObjects];
            if (list.count) {
                self.dataSource = [NSMutableArray arrayWithArray:list];
            }
            [self.tableView successGetNewDataWithNoMoreData:!rspModel.hasNextPage];
        } else {
            if (list.count) {
                [self.dataSource addObjectsFromArray:list];
            }
            [self.tableView successLoadMoreDataWithNoMoreData:!rspModel.hasNextPage];
        }
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        self.currentPage == 1 ? [self.tableView failGetNewData] : [self.tableView failLoadMoreData];
    }];
}

#pragma mark
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PNApartmentListCell *cell = [PNApartmentListCell cellWithTableView:tableView];
    cell.cellType = self.cellType;
    cell.model = [self.dataSource objectAtIndex:indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PNApartmentListItemModel *model = [self.dataSource objectAtIndex:indexPath.row];

    [HDMediator.sharedInstance navigaveToPayNowApartmentRecordDetailVC:@{
        @"paymentId": model.paymentSlipNo,
    }];
}

#pragma mark
- (PNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[PNTableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
        _tableView.needRefreshHeader = YES;
        _tableView.needRefreshFooter = YES;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 80;

        UIViewPlaceholderViewModel *model = [[UIViewPlaceholderViewModel alloc] init];
        model.title = SALocalizedString(@"no_data", @"暂无数据");
        model.image = @"pn_no_data_placeholder_2";
        _tableView.placeholderViewModel = model;

        @HDWeakify(self);
        _tableView.requestNewDataHandler = ^{
            @HDStrongify(self);
            self.currentPage = 1;
            self.currency = @"";
            [self getData];
        };

        _tableView.requestMoreDataHandler = ^{
            @HDStrongify(self);
            self.currentPage++;
            [self getData];
        };
    }
    return _tableView;
}

- (PNApartmentDTO *)apartmentDTO {
    if (!_apartmentDTO) {
        _apartmentDTO = [[PNApartmentDTO alloc] init];
    }
    return _apartmentDTO;
}

- (NSMutableArray<PNApartmentListItemModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
@end
