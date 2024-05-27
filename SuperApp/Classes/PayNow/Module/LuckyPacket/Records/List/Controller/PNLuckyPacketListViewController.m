//
//  PNPacketListViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/5.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNLuckyPacketListViewController.h"
#import "NSDate+Extension.h"
#import "PNPacketRecordDTO.h"
#import "PNPacketRecordRspModel.h"
#import "PNPacketRecordsCountView.h"
#import "PNPacketRecordsListItemCell.h"
#import "PNTableView.h"


@interface PNLuckyPacketListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) PNPacketRecordsCountView *countView;
@property (nonatomic, strong) PNTableView *tableView;

@property (nonatomic, copy) NSString *viewType;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSString *currentYear;
@property (nonatomic, strong) PNPacketRecordDTO *recordDTO;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end


@implementation PNLuckyPacketListViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.viewType = [parameters objectForKey:@"viewType"];
    }
    return self;
}

- (void)getData {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(self.currentPage) forKey:@"pageNum"];
    [dict setValue:@(20) forKey:@"pageSize"];
    [dict setValue:self.viewType forKey:@"sendOrReciver"];
    [dict setValue:self.currentYear forKey:@"transTime"];

    [self.recordDTO getPacketRecordList:dict success:^(PNPacketRecordRspModel *_Nonnull rspModel) {
        self.countView.model = rspModel;
        if (self.currentPage == 1) {
            [self.dataSource removeAllObjects];
            if (rspModel.records.count) {
                self.dataSource = [NSMutableArray arrayWithArray:rspModel.records];
                [self.tableView successGetNewDataWithNoMoreData:NO];
            } else {
                [self.tableView successGetNewDataWithNoMoreData:YES];
            }
        } else {
            if (rspModel.records.count) {
                [self.dataSource addObjectsFromArray:rspModel.records];
                [self.tableView successLoadMoreDataWithNoMoreData:NO];
            } else {
                [self.tableView successLoadMoreDataWithNoMoreData:YES];
            }
        }
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error){

    }];
}

- (void)hd_setupViews {
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.countView];
    [self.view addSubview:self.tableView];

    self.currentYear = [NSString stringWithFormat:@"%zd", [NSDate.date year]];
    [self.tableView.mj_header beginRefreshing];
}

- (void)updateViewConstraints {
    [self.countView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
    }];

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.countView.mas_bottom);
    }];

    [super updateViewConstraints];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PNPacketRecordsListItemCell *cell = [PNPacketRecordsListItemCell cellWithTableView:tableView];
    cell.viewType = self.viewType;
    cell.model = [self.dataSource objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PNPacketRecordListItemModel *model = [self.dataSource objectAtIndex:indexPath.row];
    [HDMediator.sharedInstance navigaveToPacketDetailVC:@{
        @"packetId": model.packetId,
        @"viewType": self.viewType,
    }];
}

#pragma mark
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
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;

        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableHeaderView = self.headerView;

        @HDWeakify(self);
        _tableView.requestNewDataHandler = ^{
            @HDStrongify(self);
            self.currentPage = 1;
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

- (PNPacketRecordsCountView *)countView {
    if (!_countView) {
        _countView = [[PNPacketRecordsCountView alloc] init];
        _countView.viewType = self.viewType;

        @HDWeakify(self);
        _countView.selectBlock = ^(NSString *year) {
            @HDStrongify(self);
            self.currentYear = year;
            self.currentPage = 1;
            [self getData];
        };
    }
    return _countView;
}

- (UIView *)headerView {
    if (!_headerView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealWidth(16))];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        view.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:kRealWidth(16)];
        };
        view.hidden = YES;
        _headerView = view;
    }
    return _headerView;
}

- (PNPacketRecordDTO *)recordDTO {
    if (!_recordDTO) {
        _recordDTO = [[PNPacketRecordDTO alloc] init];
    }
    return _recordDTO;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark
- (UIView *)listView {
    return self.view;
}

@end
