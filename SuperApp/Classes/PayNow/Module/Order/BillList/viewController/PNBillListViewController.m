//
//  HDBillListViewController.m
//  customer
//
//  Created by 陈剑 on 2018/7/26.
//  Copyright © 2018年 chaos network technology. All rights reserved.
//

#import "PNBillListViewController.h"
#import "PNBillFilterModel.h"
#import "PNBillListDataModel.h"
#import "PNBillListModel.h"
#import "PNBillListRspModel.h"
#import "PNBillListTableViewHeadView.h"
#import "PNCommonUtils.h"
#import "PNFilterView.h"
#import "PNOrderListCell.h"
#import "PNOrderResultViewController.h"
#import "PNTableView.h"
#import "PNTransListDTO.h"

#define HD_BILL_LIST_PAGE_NO 20


@interface PNBillListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) PNFilterView *filterView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) PNTableView *tableview;
@property (nonatomic, assign) NSInteger currentPageNo;
@property (nonatomic, strong) NSMutableArray<PNBillListDataModel *> *dataSource; ///< 数据

@property (nonatomic, strong) UIView *categoryView;

@property (nonatomic, assign) PNTransType transType;
@property (nonatomic, copy) NSString *startDate;
@property (nonatomic, copy) NSString *endDate;
@property (nonatomic, strong) NSString *currency;

@property (nonatomic, strong) HDUIButton *navBtn;
@property (nonatomic, strong) PNTransListDTO *transDTO;

@end


@implementation PNBillListViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        NSInteger type = [[parameters valueForKey:@"type"] integerValue];
        if (type > 0) {
            self.transType = type;
        }
    }
    return self;
}

- (void)hd_setupViews {
    self.dataSource = [[NSMutableArray alloc] initWithCapacity:30];

    // 默认时间,默认取最近六个月
    self.startDate = @"";
    self.endDate = @"";
    self.currency = @"";

    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.tableview];
}

- (void)hd_bindViewModel {
    [self loadData];
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return true;
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return true;
}

- (void)updateViewConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    [self.tableview mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_top);
        make.left.right.bottom.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"Transaction_record", @"交易记录");
    self.hd_navRightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.navBtn]];
}

#pragma mark---

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    PNBillListDataModel *model = self.dataSource[section];
    return model.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PNBillListDataModel *dataModel = self.dataSource[indexPath.section];
    PNOrderListModel *model = dataModel.datas[indexPath.row];
    PNOrderListCell *cell = [PNOrderListCell cellWithTableView:tableView];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PNBillListDataModel *dataModel = self.dataSource[indexPath.section];
    PNOrderListModel *model = dataModel.datas[indexPath.row];
    HDPayOrderRspModel *OrderRspModel = [HDPayOrderRspModel yy_modelWithJSON:[model yy_modelToJSONObject]];
    PNOrderResultViewController *vc = [[PNOrderResultViewController alloc] init];
    vc.rspModel = OrderRspModel;
    //    vc.type = resultPage;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PNBillListDataModel *dataModel = self.dataSource[section];

    PNBillListTableViewHeadView *view = [PNBillListTableViewHeadView viewWithTableView:tableView];
    //    __weak __typeof(self) weakSelf = self;

    view.clickHandle = ^(UIButton *_Nonnull button) {
        //        __strong __typeof(weakSelf) strongSelf = weakSelf;
        //        [strongSelf clickOnDatePicker:nil];
    };

    if ([dataModel.sectionName isEqualToString:[PNCommonUtils getCurrentDateStrByFormat:@"MM/yyyy"]]) {
        view.title = PNLocalizedString(@"PAGE_TEXT_CURRENT_MONTH", @"本月");
    } else {
        view.title = dataModel.sectionName;
    }

    return view;
}

#pragma mark - data
- (void)loadData {
    if (self.dataSource.count == 0) {
        [self.tableview getNewData];
    }
}

- (void)getNewData {
    self.currentPageNo = 1;
    [self getDataForPageNo:self.currentPageNo];
}

- (void)loadMoreData {
    self.currentPageNo += 1;
    [self getDataForPageNo:self.currentPageNo];
}

- (void)getDataForPageNo:(NSInteger)pageNo {
    /**
     * 有就传值，没有就不传
     */

    __weak __typeof(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setObject:@(pageNo) forKey:@"pageNum"];
    [dic setObject:@(HD_BILL_LIST_PAGE_NO) forKey:@"pageSize"];

    /// 交易类型
    if (self.transType != PNTransTypeDefault) {
        [dic setObject:[NSNumber numberWithInteger:self.transType] forKey:@"tradeType"];
    }

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
    [dic setObject:[NSString stringWithFormat:@"%0.0f", [[fmt dateFromString:[tempStartDate stringByAppendingString:@" 00:00:00"]] timeIntervalSince1970] * 1000] forKey:@"startDate"];

    NSString *tempEndDate = @"";
    if (WJIsStringEmpty(self.endDate)) {
        tempEndDate = [PNCommonUtils getCurrentDateStrByFormat:@"dd/MM/yyyy"];
    } else {
        tempEndDate = self.endDate;
    }
    [dic setObject:[NSString stringWithFormat:@"%0.0f", [[fmt dateFromString:[tempEndDate stringByAppendingString:@" 23:59:59"]] timeIntervalSince1970] * 1000] forKey:@"endDate"];
    HDLog(@"%@ - %@", tempStartDate, tempEndDate);
    /// 币种
    if ([self.currency isEqualToString:PNCurrencyTypeUSD] || [self.currency isEqualToString:PNCurrencyTypeKHR]) {
        [dic setObject:self.currency forKey:@"currency"];
    }

    [self.transDTO getTransOrderListWithParams:dic success:^(PNBillListRspModel *_Nonnull rspModel) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;

        self.currentPageNo = rspModel.pageNum;
        NSArray<PNBillListModel *> *list = rspModel.list;
        if (pageNo == 1) {
            [strongSelf.dataSource removeAllObjects];
            if (list.count) {
                [strongSelf proccessRspData:list];
                [strongSelf.tableview successGetNewDataWithNoMoreData:!rspModel.hasNextPage];
            } else {
                [strongSelf proccessRspData:list];
                [strongSelf.tableview successGetNewDataWithNoMoreData:YES];
            }
        } else {
            if (list.count) {
                [strongSelf proccessRspData:list];
                [strongSelf.tableview successLoadMoreDataWithNoMoreData:!rspModel.hasNextPage];
            }
        }
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;

        pageNo == 1 ? [strongSelf.tableview failGetNewData] : [strongSelf.tableview failLoadMoreData];
    }];
}

#pragma mark - data cleaning
- (void)insertBillListModel:(PNBillListModel *)model {
    NSString *sectionName = nil;
    sectionName = [PNCommonUtils getDateStrByFormat:@"MM/yyyy" withDate:[NSDate dateWithTimeIntervalSince1970:model.createTime.integerValue / 1000]];
    for (PNBillListDataModel *dataModel in self.dataSource) {
        if ([dataModel.sectionName isEqualToString:sectionName]) {
            [dataModel.datas addObject:model];
            return;
        }
    }

    /// 如果不存在这个月的分组，则需要新增一个
    PNBillListDataModel *dataModel = [[PNBillListDataModel alloc] init];
    dataModel.sectionName = sectionName;
    dataModel.sortFactor = model.createTime;
    [dataModel.datas addObject:model];
    [self.dataSource addObject:dataModel];
}

- (void)proccessRspData:(NSArray<PNBillListModel *> *)rspList {
    // 没有数据的情况下需要显示第一个section
    if (rspList.count == 0) {
        PNBillListDataModel *model = [[PNBillListDataModel alloc] init];
        model.sectionName = [self.endDate substringFromIndex:3];

        model.sortFactor = @"0";
        [self.dataSource addObject:model];

    } else {
        for (PNBillListModel *model in rspList) {
            [self insertBillListModel:model];
        }

        [self.dataSource sortedArrayWithOptions:NSSortStable usingComparator:^NSComparisonResult(PNBillListDataModel *_Nonnull model1, PNBillListDataModel *_Nonnull model2) {
            if (model2.sortFactor.doubleValue > model1.sortFactor.doubleValue) {
                return NSOrderedDescending;
            } else {
                return NSOrderedAscending;
            }
        }];
    }
}

#pragma mark - lazy load
- (PNTableView *)tableview {
    if (!_tableview) {
        _tableview = [[PNTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        if (@available(iOS 15.0, *)) {
            _tableview.sectionHeaderTopPadding = 0;
        }
        _tableview.backgroundColor = [HDAppTheme.color G5];
        _tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealWidth(26))];
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.separatorInset = UIEdgeInsetsMake(0, 45, 0, 0);
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.sectionHeaderHeight = 50;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 80;
        [_tableview registerClass:PNBillListTableViewHeadView.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(PNBillListTableViewHeadView.class)];

        _tableview.needRefreshHeader = YES;
        _tableview.needRefreshFooter = YES;

        __weak __typeof(self) weakSelf = self;
        _tableview.requestNewDataHandler = ^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf getNewData];
        };

        _tableview.requestMoreDataHandler = ^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf loadMoreData];
        };
    }
    return _tableview;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = UIView.new;
    }
    return _bgView;
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

            HDLog(@"传入值 \n startDate:%@ \n endDate:%@ \n transType:%zd \n currency:%@", self.startDate, self.endDate, self.transType, self.currency);
            [self.filterView showInSuperView:self.bgView];
        }];

        _navBtn = button;
    }
    return _navBtn;
}

- (PNTransListDTO *)transDTO {
    if (!_transDTO) {
        _transDTO = [[PNTransListDTO alloc] init];
    }
    return _transDTO;
}

- (PNFilterView *)filterView {
    if (!_filterView) {
        _filterView = [[PNFilterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        @HDWeakify(self);
        _filterView.confirmBlock = ^(NSString *startDate, NSString *endDate, PNTransType transType, NSString *currency) {
            @HDStrongify(self);
            HDLog(@"\n startDate:%@ \n endDate:%@ \n transType:%zd \n currency:%@", startDate, endDate, transType, currency);
            self.transType = transType;
            self.startDate = startDate;
            self.endDate = endDate;
            self.currency = currency;

            self.currentPageNo = 1;
            [self.tableview getNewData];
        };
    }
    return _filterView;
}
@end
