//
//  PNGuaranteeListViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2023/1/5.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNGuaranteeListViewController.h"
#import "PNBottomView.h"
#import "PNGTFilterView.h"
#import "PNGuaranteeListCell.h"
#import "PNGuaranteeListDTO.h"
#import "PNNotifyView.h"
#import "PNTableView.h"


@interface PNGuaranteeListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) PNNotifyView *notifyView;
@property (nonatomic, strong) PNTableView *tableView;
@property (nonatomic, strong) HDUIButton *filterBtn;
@property (nonatomic, strong) PNBottomView *bottomBgView;
@property (nonatomic, strong) PNGuaranteeListDTO *listDTO;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) PNGTFilterView *filterView;
@property (nonatomic, copy) NSString *startDate;
@property (nonatomic, copy) NSString *endDate;
@property (nonatomic, strong) NSMutableArray *statusArray;
@end


@implementation PNGuaranteeListViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.currentPage = 1;
        self.startDate = @"";
        self.endDate = @"";
        self.statusArray = [NSMutableArray arrayWithObject:@(PNGuarateenStatus_ALL)];
    }
    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"gFCHMFQU", @"担保交易");
    self.hd_navRightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.filterBtn]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.tableView.mj_header beginRefreshing];
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return YES;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (void)hd_setupViews {
    self.view.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self.view addSubview:self.notifyView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomBgView];

    NSString *noticeContent = [PNCommonUtils getNotifiView:PNWalletListItemTypeGuaratee];
    if (WJIsStringNotEmpty(noticeContent)) {
        self.notifyView.content = noticeContent;
        self.notifyView.hidden = NO;
    } else {
        self.notifyView.hidden = YES;
    }
}

- (void)updateViewConstraints {
    if (!self.notifyView.hidden) {
        [self.notifyView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.hd_navigationBar.mas_bottom);
            make.height.equalTo(@([self.notifyView getViewHeight]));
        }];
    }

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        if (!self.notifyView.hidden) {
            make.top.mas_equalTo(self.notifyView.mas_bottom);
        } else {
            make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
        }
    }];

    [self.bottomBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.mas_equalTo(self.tableView.mas_bottom);
    }];

    [super updateViewConstraints];
}

#pragma mark
- (void)getData {
    @HDWeakify(self);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    /// 开始日期 结束日期
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    [fmt setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];

    NSString *tempStartDate = @"";
    if (WJIsStringEmpty(self.startDate)) {
        tempStartDate = [PNCommonUtils getDateStrByFormat:@"dd/MM/yyyy" withDate:[PNCommonUtils getNewDateByDay:-31 Month:0 Year:0 fromDate:[NSDate new]]];
    } else {
        tempStartDate = self.startDate;
    }
    [dic setObject:[NSString stringWithFormat:@"%0.0f", [[fmt dateFromString:[tempStartDate stringByAppendingString:@" 00:00:00"]] timeIntervalSince1970] * 1000] forKey:@"beginTime"];

    NSString *tempEndDate = @"";
    if (WJIsStringEmpty(self.endDate)) {
        tempEndDate = [PNCommonUtils getCurrentDateStrByFormat:@"dd/MM/yyyy"];
    } else {
        tempEndDate = self.endDate;
    }
    [dic setObject:[NSString stringWithFormat:@"%0.0f", [[fmt dateFromString:[tempEndDate stringByAppendingString:@" 23:59:59"]] timeIntervalSince1970] * 1000] forKey:@"endTime"];

    NSMutableArray *tempStatus = [NSMutableArray array];
    if (![self.statusArray containsObject:@(PNGuarateenStatus_ALL)]) {
        tempStatus = [NSMutableArray arrayWithArray:self.statusArray];
    }

    [dic setValue:tempStatus forKey:@"statusList"];
    [dic setValue:@(self.currentPage) forKey:@"pageNum"];
    [dic setValue:@"20" forKey:@"pageSize"];

    [self.listDTO getGuarateenRecordList:dic success:^(PNGuaranteeRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self dismissLoading];

        NSArray<PNGuaranteeListItemModel *> *list = rspModel.list;
        if (self.currentPage == 1) {
            [self.dataSource removeAllObjects];
            if (list.count) {
                self.dataSource = [NSMutableArray arrayWithArray:list];
            }

            [self.tableView successGetNewDataWithNoMoreData:!rspModel.pn_hasNetPage];
        } else {
            if (list.count) {
                [self.dataSource addObjectsFromArray:list];
            }
            [self.tableView successLoadMoreDataWithNoMoreData:!rspModel.pn_hasNetPage];
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
    PNGuaranteeListCell *cell = [PNGuaranteeListCell cellWithTableView:tableView];
    cell.model = [self.dataSource objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PNGuaranteeListItemModel *model = [self.dataSource objectAtIndex:indexPath.row];
    [HDMediator.sharedInstance navigaveToPayNowGuaranteenRecordDetailVC:@{@"orderNo": model.orderNo}];
}

#pragma mark
- (PNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[PNTableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = YES;
        _tableView.needRefreshFooter = YES;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
        _tableView.estimatedRowHeight = 130;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }

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

- (HDUIButton *)filterBtn {
    if (!_filterBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"pn_more_filter"] forState:0];

        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);

            self.filterView.startDate = self.startDate;
            self.filterView.endDate = self.endDate;
            self.filterView.statusArray = self.statusArray;
            [self.filterView showInSuperView:self.view];
        }];

        _filterBtn = button;
    }
    return _filterBtn;
}

- (PNBottomView *)bottomBgView {
    if (!_bottomBgView) {
        _bottomBgView = [[PNBottomView alloc] initWithTitle:PNLocalizedString(@"aEvpZcFf", @"发起交易")];
        _bottomBgView.btnClickBlock = ^{
            [HDMediator.sharedInstance navigaveToPayNowGuaranteeInitSelectVC:@{}];
        };
    }
    return _bottomBgView;
}

- (PNGuaranteeListDTO *)listDTO {
    if (!_listDTO) {
        _listDTO = [[PNGuaranteeListDTO alloc] init];
    }
    return _listDTO;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (PNGTFilterView *)filterView {
    if (!_filterView) {
        _filterView = [[PNGTFilterView alloc] initWithFrame:CGRectMake(0, kNavigationBarH, kScreenWidth, kScreenHeight)];

        @HDWeakify(self);
        _filterView.confirmBlock = ^(NSString *_Nonnull startDate, NSString *_Nonnull endDate, NSArray *_Nonnull status) {
            @HDStrongify(self);
            self.currentPage = 1;

            self.startDate = startDate;
            self.endDate = endDate;
            self.statusArray = [NSMutableArray arrayWithArray:status];

            [self getData];
        };
    }
    return _filterView;
}

- (PNNotifyView *)notifyView {
    if (!_notifyView) {
        _notifyView = [[PNNotifyView alloc] init];
        _notifyView.hidden = YES;
    }
    return _notifyView;
}
@end
