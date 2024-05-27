//
//  PNWalletOrderListViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2023/2/3.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNWalletOrderListViewController.h"
#import "PNTableView.h"
#import "PNWalletListRspModel.h"
#import "PNWalletOrderDTO.h"
#import "PNWalletOrderFilterView.h"
#import "PNWalletOrderListCell.h"
#import "PNWalletOrderListSectionView.h"


@interface PNWalletOrderListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) PNTableView *tableView;

@property (nonatomic, assign) NSInteger currentPageNo;
@property (nonatomic, strong) PNWalletOrderDTO *orderDTO;

@property (nonatomic, strong) PNWalletListFilterType transType;
@property (nonatomic, copy) NSString *startDate;
@property (nonatomic, copy) NSString *endDate;
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, strong) HDUIButton *navBtn;
@property (nonatomic, strong) PNWalletOrderFilterView *filterView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end


@implementation PNWalletOrderListViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.currency = [parameters objectForKey:@"currency"] ?: @"";
        self.startDate = @"";
        self.endDate = @"";
        self.currentPageNo = 1;
        self.transType = PNWalletListFilterType_All;
    }
    return self;
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return YES;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"INCW7fTD", @"钱包明细");
    self.hd_navRightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.navBtn]];
}

- (void)hd_setupViews {
    self.view.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self.view addSubview:self.tableView];

    [self.tableView getNewData];
}

- (void)updateViewConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
    }];
    [super updateViewConstraints];
}

#pragma mark
- (void)getData {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setValue:@(self.currentPageNo) forKey:@"pageNum"];
    [dic setValue:@(20) forKey:@"pageSize"];

    /// 交易类型
    if (![self.transType isEqualToString:PNWalletListFilterType_All]) {
        [dic setValue:self.transType forKey:@"orderType"];
    }

    /// 开始日期 结束日期
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    [fmt setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];

    NSString *tempStartDate = @"";
    if (WJIsStringEmpty(self.startDate)) {
        tempStartDate = [PNCommonUtils getDateStrByFormat:@"dd/MM/yyyy" withDate:[PNCommonUtils getNewDateByDay:0 Month:0 Year:-1 fromDate:[NSDate new]]];
    } else {
        tempStartDate = self.startDate;
    }
    [dic setObject:[NSString stringWithFormat:@"%0.0f", [[fmt dateFromString:[tempStartDate stringByAppendingString:@" 00:00:00"]] timeIntervalSince1970] * 1000] forKey:@"startTime"];

    NSString *tempEndDate = @"";
    if (WJIsStringEmpty(self.endDate)) {
        tempEndDate = [PNCommonUtils getCurrentDateStrByFormat:@"dd/MM/yyyy"];
    } else {
        tempEndDate = self.endDate;
    }
    [dic setObject:[NSString stringWithFormat:@"%0.0f", [[fmt dateFromString:[tempEndDate stringByAppendingString:@" 23:59:59"]] timeIntervalSince1970] * 1000] forKey:@"endTime"];
    HDLog(@"%@ - %@", tempStartDate, tempEndDate);
    /// 币种
    if ([self.currency isEqualToString:PNCurrencyTypeUSD] || [self.currency isEqualToString:PNCurrencyTypeKHR]) {
        [dic setValue:self.currency forKey:@"currency"];
    }

    @HDWeakify(self);
    [self.orderDTO getWalletOrderListWithParams:dic success:^(PNWalletListRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        NSArray<PNWalletListModel *> *list = rspModel.list;
        if (self.currentPageNo == 1) {
            [self.dataSource removeAllObjects];
            if (list.count) {
                [self proccessRspData:list];
                [self.tableView successGetNewDataWithNoMoreData:NO];
            } else {
                [self proccessRspData:list];
                [self.tableView successGetNewDataWithNoMoreData:YES];
            }
        } else {
            if (list.count) {
                [self proccessRspData:list];
                [self.tableView successLoadMoreDataWithNoMoreData:NO];
            } else {
                [self.tableView successLoadMoreDataWithNoMoreData:YES];
            }
        }
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        self.currentPageNo == 1 ? [self.tableView failGetNewData] : [self.tableView failLoadMoreData];
    }];
}

- (void)proccessRspData:(NSArray<PNWalletListModel *> *)rspList {
    for (PNWalletListModel *model in rspList) {
        BOOL isExist = NO;

        for (PNWalletListModel *dataModel in self.dataSource) {
            NSString *date1 = [PNCommonUtils getDateStrByFormat:@"MM/yyyy" withDate:[NSDate dateWithTimeIntervalSince1970:dataModel.dayTime.doubleValue / 1000]];
            NSString *date2 = [PNCommonUtils getDateStrByFormat:@"MM/yyyy" withDate:[NSDate dateWithTimeIntervalSince1970:model.dayTime.doubleValue / 1000]];

            if ([date1 isEqualToString:date2]) {
                NSMutableArray *listArr = [NSMutableArray arrayWithArray:dataModel.list];

                [listArr addObjectsFromArray:model.list];
                dataModel.list = listArr;
                isExist = YES;
                break;
            }
        }

        if (!isExist) {
            [self.dataSource addObject:model];
        }
    }
}

#pragma mark
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    PNWalletListModel *model = [self.dataSource objectAtIndex:section];
    return model.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PNWalletOrderListCell *cell = [PNWalletOrderListCell cellWithTableView:tableView];
    PNWalletListModel *model = [self.dataSource objectAtIndex:indexPath.section];
    cell.model = [model.list objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PNWalletListModel *model = [self.dataSource objectAtIndex:indexPath.section];
    PNWalletListItemModel *itemModel = [model.list objectAtIndex:indexPath.row];

    [HDMediator.sharedInstance navigaveToWalletOrderDetailVC:@{
        @"orderNo": itemModel.accountSerialNo,
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PNWalletListModel *model = [self.dataSource objectAtIndex:section];

    PNWalletOrderListSectionView *headerView = [PNWalletOrderListSectionView headerWithTableView:tableView];
    headerView.dateStr = model.dayTime;
    return headerView;
}

#pragma mark
- (PNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[PNTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        _tableView.backgroundColor = [HDAppTheme.color G5];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealWidth(26))];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 45, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionHeaderHeight = 50;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 80;
        [_tableView registerClass:PNWalletOrderListSectionView.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(PNWalletOrderListSectionView.class)];

        _tableView.needRefreshHeader = YES;
        _tableView.needRefreshFooter = YES;

        @HDWeakify(self);
        _tableView.requestNewDataHandler = ^{
            @HDStrongify(self);
            self.currentPageNo = 1;
            [self getData];
        };

        _tableView.requestMoreDataHandler = ^{
            @HDStrongify(self);
            self.currentPageNo++;
            [self getData];
        };
    }
    return _tableView;
}

- (PNWalletOrderDTO *)orderDTO {
    if (!_orderDTO) {
        _orderDTO = [[PNWalletOrderDTO alloc] init];
    }
    return _orderDTO;
}

- (HDUIButton *)navBtn {
    if (!_navBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsButtonWhenHighlighted = false;
        [button setTitle:PNLocalizedString(@"more", @"更多") forState:UIControlStateNormal];
        [button setTitleColor:HDAppTheme.PayNowColor.c343B4D forState:UIControlStateNormal];
        button.titleLabel.font = [HDAppTheme.font forSize:13];
        [button sizeToFit];

        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            self.filterView.startDate = self.startDate;
            self.filterView.endDate = self.endDate;
            self.filterView.transType = self.transType;
            self.filterView.currency = self.currency;

            HDLog(@"传入值 \n startDate:%@ \n endDate:%@ \n transType:%@ \n currency:%@", self.startDate, self.endDate, self.transType, self.currency);
            [self.filterView showInSuperView:self.view];
        }];

        _navBtn = button;
    }
    return _navBtn;
}

- (PNWalletOrderFilterView *)filterView {
    if (!_filterView) {
        _filterView = [[PNWalletOrderFilterView alloc] initWithFrame:CGRectMake(0, kNavigationBarH, kScreenWidth, kScreenHeight)];
        @HDWeakify(self);
        _filterView.confirmBlock = ^(NSString *startDate, NSString *endDate, PNWalletListFilterType transType, NSString *currency) {
            @HDStrongify(self);
            HDLog(@"\n startDate:%@ \n endDate:%@ \n transType:%@ \n currency:%@", startDate, endDate, transType, currency);
            self.transType = transType;
            self.startDate = startDate;
            self.endDate = endDate;
            self.currency = currency;

            self.currentPageNo = 1;
            [self.tableView getNewData];
        };
    }
    return _filterView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
@end
