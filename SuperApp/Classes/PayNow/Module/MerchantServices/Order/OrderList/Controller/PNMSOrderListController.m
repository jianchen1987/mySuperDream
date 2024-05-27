//
//  PNMSOrderListController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/6/7.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSOrderListController.h"
#import "PNBillListDataModel.h"
#import "PNBillListTableViewHeadView.h"
#import "PNCommonUtils.h"
#import "PNMSBillFilterModel.h"
#import "PNMSBillListModel.h"
#import "PNMSBillListRspModel.h"
#import "PNMSBillListSectionHeaderView.h"
#import "PNMSFilterModel.h"
#import "PNMSFilterStoreOperatorDataModel.h"
#import "PNMSFilterView.h"
#import "PNMSOrderDTO.h"
#import "PNMSOrderListCell.h"
#import "PNOrderListModel.h"
#import "PNOrderResultViewController.h"
#import "PNTableView.h"
#import "VipayUser.h"

#define HD_BILL_LIST_PAGE_NO 20


@interface PNMSOrderListController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) PNMSFilterView *filterView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) PNTableView *tableview;
@property (nonatomic, assign) NSInteger currentPageNo;
@property (nonatomic, strong) NSMutableArray<PNMSBillListGroupModel *> *dataSource; ///< 数据

@property (nonatomic, strong) UIView *categoryView;

@property (nonatomic, strong) PNMSFilterModel *filterModel;

@property (nonatomic, strong) CAShapeLayer *navBarShadowLayer; ///< 阴影
@property (nonatomic, strong) HDUIButton *navBtn;
@property (nonatomic, strong) PNMSOrderDTO *transDTO;

@property (nonatomic, strong) NSString *merchantNo;
@property (nonatomic, strong) PNMSFilterStoreOperatorDataModel *spModel;
@property (nonatomic, assign) BOOL isFirst;
@end


@implementation PNMSOrderListController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.merchantNo = VipayUser.shareInstance.merchantNo;
        NSInteger type = [[parameters valueForKey:@"type"] integerValue];
        if (type > 0) {
            self.filterModel.transType = type;
        }
        self.isFirst = YES;
    }
    return self;
}

- (void)hd_setupViews {
    self.dataSource = [[NSMutableArray alloc] initWithCapacity:30];

    // 默认时间,默认取最近六个月
    self.filterModel = [PNMSFilterModel new];
    self.filterModel.startDate = @"";
    self.filterModel.endDate = @"";
    self.filterModel.currency = @"";
    self.filterModel.transferStatus = PNOrderStatusAll;
    self.filterModel.storeNo = @"";
    self.filterModel.operatorValue = @"";

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
    PNMSBillListGroupModel *groupModel = self.dataSource[section];
    return groupModel.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PNMSBillListGroupModel *groupModel = self.dataSource[indexPath.section];
    PNMSBillListModel *model = groupModel.list[indexPath.row];
    PNMSOrderListCell *cell = [PNMSOrderListCell cellWithTableView:tableView];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PNMSBillListGroupModel *groupModel = self.dataSource[indexPath.section];
    PNMSBillListModel *model = groupModel.list[indexPath.row];
    HDPayOrderRspModel *OrderRspModel = [HDPayOrderRspModel yy_modelWithJSON:[model yy_modelToJSONObject]];

    [HDMediator.sharedInstance navigaveToPayNowMerchantServicesOrderDetailsVC:@{
        @"model": [OrderRspModel yy_modelToJSONObject],
        @"viewType": @(0),
        @"merchantNo": self.merchantNo,
        @"tradeType": @(model.tradeType),
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PNMSBillListSectionHeaderView *view = [PNMSBillListSectionHeaderView headerWithTableView:tableView];
    view.model = self.dataSource[section];
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
    [dic setObject:self.merchantNo forKey:@"merId"];

    /// 交易类型
    if (self.filterModel.transType != PNTransTypeDefault) {
        [dic setObject:[NSNumber numberWithInteger:self.filterModel.transType] forKey:@"tradeType"];
    }

    /// 开始日期 结束日期
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    [fmt setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];

    NSString *tempStartDate = @"";
    if (WJIsStringEmpty(self.filterModel.startDate)) {
        tempStartDate = [PNCommonUtils getDateStrByFormat:@"dd/MM/yyyy" withDate:[PNCommonUtils getNewDateByDay:-31 Month:0 Year:0 fromDate:[NSDate new]]];
    } else {
        tempStartDate = self.filterModel.startDate;
    }
    [dic setObject:[NSString stringWithFormat:@"%0.0f", [[fmt dateFromString:[tempStartDate stringByAppendingString:@" 00:00:00"]] timeIntervalSince1970] * 1000] forKey:@"startDate"];

    NSString *tempEndDate = @"";
    if (WJIsStringEmpty(self.filterModel.endDate)) {
        tempEndDate = [PNCommonUtils getCurrentDateStrByFormat:@"dd/MM/yyyy"];
    } else {
        tempEndDate = self.filterModel.endDate;
    }
    [dic setObject:[NSString stringWithFormat:@"%0.0f", [[fmt dateFromString:[tempEndDate stringByAppendingString:@" 23:59:59"]] timeIntervalSince1970] * 1000] forKey:@"endDate"];
    HDLog(@"%@ - %@", tempStartDate, tempEndDate);
    /// 币种
    if ([self.filterModel.currency isEqualToString:PNCurrencyTypeUSD] || [self.filterModel.currency isEqualToString:PNCurrencyTypeKHR]) {
        [dic setObject:self.filterModel.currency forKey:@"currency"];
    }

    [dic setObject:self.filterModel.storeNo forKey:@"storeNo"];
    [dic setObject:self.filterModel.operatorValue forKey:@"operaLoginName"];
    [dic setObject:VipayUser.shareInstance.merchantNo forKey:@"merchantNo"];
    if (self.filterModel.transferStatus != PNOrderStatusAll) {
        [dic setObject:@(self.filterModel.transferStatus) forKey:@"status"];
    }

    [self.transDTO getMSTransOrderListWithParams:dic success:^(PNMSBillListRspModel *_Nonnull rspModel) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;

        self.currentPageNo = rspModel.pageNum;
        NSArray<PNMSBillListGroupModel *> *list = rspModel.list;
        if (pageNo == 1) {
            [strongSelf.dataSource removeAllObjects];
            if (list.count) {
                [strongSelf proccessRspData:list];
                [strongSelf.tableview successGetNewDataWithNoMoreData:NO];
            } else {
                [strongSelf proccessRspData:list];
                [strongSelf.tableview successGetNewDataWithNoMoreData:YES];
            }
        } else {
            if (list.count) {
                [strongSelf proccessRspData:list];
                [strongSelf.tableview successLoadMoreDataWithNoMoreData:NO];
            } else {
                [strongSelf.tableview successLoadMoreDataWithNoMoreData:YES];
            }
        }
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;

        pageNo == 1 ? [strongSelf.tableview failGetNewData] : [strongSelf.tableview failLoadMoreData];
    }];
}

#pragma mark - data cleaning
- (void)insertBillListModel:(PNMSBillListModel *)model {
    //    NSString *sectionName = nil;
    //    sectionName = [PNCommonUtils getDateStrByFormat:@"MM/yyyy" withDate:[NSDate dateWithTimeIntervalSince1970:model.createTime.floatValue / 1000]];
    //
    //    for (PNBillListDataModel *dataModel in self.dataSource) {
    //        if ([dataModel.sectionName isEqualToString:sectionName]) {
    //            [dataModel.datas addObject:model];
    //            return;
    //        }
    //    }
    //
    //    /// 如果不存在这个月的分组，则需要新增一个
    //    PNBillListDataModel *dataModel = [[PNBillListDataModel alloc] init];
    //    dataModel.sectionName = sectionName;
    //    dataModel.sortFactor = model.createTime;
    //    [dataModel.datas addObject:model];
    //    [self.dataSource addObject:dataModel];
}

- (void)proccessRspData:(NSArray<PNMSBillListGroupModel *> *)rspList {
    for (PNMSBillListGroupModel *model in rspList) {
        BOOL isExist = NO;
        for (PNMSBillListGroupModel *dataModel in self.dataSource) {
            if ([dataModel.dayTime isEqualToString:model.dayTime]) {
                NSMutableArray *listArr = [NSMutableArray arrayWithArray:dataModel.list];
                dataModel.usdNum = model.usdNum;
                dataModel.khrNum = model.khrNum;
                dataModel.inUsdAmt = model.inUsdAmt;
                dataModel.inKhrAmt = model.inKhrAmt;
                dataModel.outUsdAmt = model.outUsdAmt;
                dataModel.outKhrAmt = model.outKhrAmt;

                [listArr addObjectsFromArray:model.list];

                isExist = YES;
                break;
            }
        }

        if (!isExist) {
            [self.dataSource addObject:model];
        }
    }

    //    // 没有数据的情况下需要显示第一个section
    //    if (rspList.count == 0) {
    //        PNBillListDataModel *model = [[PNBillListDataModel alloc] init];
    //        model.sectionName = [self.filterModel.endDate substringFromIndex:3];
    //
    //        model.sortFactor = @"0";
    //        [self.dataSource addObject:model];
    //
    //    } else {
    //        for (PNMSBillListGroupModel *model in rspList) {
    //            for (PNMSBillListModel *itemMoel in model.list) {
    //                [self insertBillListModel:itemMoel];
    //            }
    //        }
    //
    //        [self.dataSource sortedArrayWithOptions:NSSortStable
    //                                usingComparator:^NSComparisonResult(PNBillListDataModel *_Nonnull model1, PNBillListDataModel *_Nonnull model2) {
    //                                    if (model2.sortFactor.doubleValue > model1.sortFactor.doubleValue) {
    //                                        return NSOrderedDescending;
    //                                    } else {
    //                                        return NSOrderedAscending;
    //                                    }
    //                                }];
    //    }
}

#pragma mark - lazy load
- (PNTableView *)tableview {
    if (!_tableview) {
        _tableview = [[PNTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        //        if (@available(iOS 15.0, *)) {
        //            _tableview.sectionHeaderTopPadding = 0;
        //        }
        _tableview.backgroundColor = [HDAppTheme.color G5];
        //        _tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kRealWidth(26))];
        //        _tableview.separatorInset = UIEdgeInsetsMake(0, 45, 0, 0);
        _tableview.delegate = self;
        _tableview.dataSource = self;

        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;

        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 80;

        _tableview.sectionHeaderHeight = UITableViewAutomaticDimension;
        _tableview.estimatedSectionHeaderHeight = 130;

        _tableview.sectionFooterHeight = kRealWidth(8);

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
        [button setTitleColor:HDAppTheme.PayNowColor.mainThemeColor forState:UIControlStateNormal];
        button.titleLabel.font = [HDAppTheme.font forSize:13];
        [button sizeToFit];

        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            self.filterView.filterModel = self.filterModel;

            HDLog(@"传入值 \n startDate:%@ \n endDate:%@ \n transType:%zd \n currency:%@ \ntransferStatus:%zd",
                  self.filterModel.startDate,
                  self.filterModel.endDate,
                  self.filterModel.transType,
                  self.filterModel.currency,
                  self.filterModel.transferStatus);
            [self.filterView showInSuperView:self.bgView];
            self.isFirst = NO;
        }];

        _navBtn = button;
    }
    return _navBtn;
}

- (PNMSOrderDTO *)transDTO {
    if (!_transDTO) {
        _transDTO = [[PNMSOrderDTO alloc] init];
    }
    return _transDTO;
}

- (PNMSFilterView *)filterView {
    if (!_filterView) {
        _filterView = [[PNMSFilterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - self.hd_navigationBar.hd_height)];
        @HDWeakify(self);
        _filterView.confirmBlock = ^(PNMSFilterModel *model) {
            @HDStrongify(self);
            HDLog(@"\n startDate:%@ \n endDate:%@ \n transType:%zd \n currency:%@ \ntransferStatus:%zd storeNo:%@ storeName:%@",
                  model.startDate,
                  model.endDate,
                  model.transType,
                  model.currency,
                  model.transferStatus,
                  model.storeNo,
                  model.storeName);
            self.filterModel = model;

            self.currentPageNo = 1;
            [self.tableview getNewData];
        };
    }
    return _filterView;
}

@end
