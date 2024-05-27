//
//  SAUserBillListViewController.m
//  SuperApp
//
//  Created by seeu on 2022/4/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAUserBillListViewController.h"
#import "HDBillDatePickViewController.h"
#import "NSDate+SAExtension.h"
#import "NSString+SA_Extension.h"
#import "PNCommonUtils.h"
#import "SAInfoAlertView.h"
#import "SANavigationController.h"
#import "SATableView.h"
#import "SAUserBillDTO.h"
#import "SAUserBillListHeaderView.h"
#import "SAUserBillListTableViewCell.h"


@interface SAUserBillListViewController () <UITableViewDelegate, UITableViewDataSource, billDatePickDelegate>
@property (nonatomic, strong) SATableView *tableView;
///< 数据源
@property (nonatomic, strong) NSArray<HDTableViewSectionModel *> *dataSource;
///< DTO
@property (nonatomic, strong) SAUserBillDTO *billDTO;
///< 当前页
@property (nonatomic, assign) NSUInteger currentPage;

///< 开始时间
@property (nonatomic, assign) NSTimeInterval startTime;
///< 结束时间
@property (nonatomic, assign) NSTimeInterval endTime;
///< 帮助按钮
@property (nonatomic, strong) HDUIButton *tipsButton;

@end


@implementation SAUserBillListViewController

- (void)hd_setupViews {
    [self.view addSubview:self.tableView];

    self.currentPage = 1;
    self.dataSource = @[];
    self.startTime = 0;
    self.endTime = 0;
    self.view.backgroundColor = HDAppTheme.color.G5;

    @HDWeakify(self);
    self.tableView.requestNewDataHandler = ^{
        @HDStrongify(self);
        [self getNewData];
    };
    self.tableView.requestMoreDataHandler = ^{
        @HDStrongify(self);
        [self loadMoreData];
    };

    [self.tableView getNewData];
}

- (void)hd_languageDidChanged {
    self.boldTitle = SALocalizedString(@"userBillList_title", @"账单");
}

- (void)hd_setupNavigation {
    self.hd_navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.tipsButton];
}

- (void)updateViewConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];

    [super updateViewConstraints];
}

#pragma mark - private methods
- (void)getNewData {
    [self queryUserBillListWithPageNum:1];
}

- (void)loadMoreData {
    [self queryUserBillListWithPageNum:++self.currentPage];
}

- (void)processRspDatas:(NSArray<SAUserBillListModel *> *)list {
    NSMutableArray<HDTableViewSectionModel *> *sections = [NSMutableArray arrayWithArray:self.dataSource];
    [list enumerateObjectsUsingBlock:^(SAUserBillListModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        NSString *dateStr = [[NSDate dateWithTimeIntervalSince1970:obj.createTime.floatValue / 1000.0] stringWithFormatStr:@"MM/yyyy"];
        NSArray<HDTableViewSectionModel *> *bingo = [sections hd_filterWithBlock:^BOOL(HDTableViewSectionModel *_Nonnull item) {
            return item.headerModel && [item.headerModel.title isEqualToString:dateStr];
        }];
        if (bingo.count) {
            HDTableViewSectionModel *sectionModel = bingo.firstObject;
            NSMutableArray<SAUserBillListModel *> *tmp = [NSMutableArray arrayWithArray:sectionModel.list];
            [tmp addObject:obj];
            [tmp sortWithOptions:NSSortStable usingComparator:^NSComparisonResult(SAUserBillListModel *_Nonnull obj1, SAUserBillListModel *_Nonnull obj2) {
                return obj1.createTime.floatValue > obj2.createTime.floatValue ? NSOrderedAscending : NSOrderedDescending;
            }];
            sectionModel.list = tmp;
        } else {
            HDTableViewSectionModel *sectionModel = HDTableViewSectionModel.new;
            HDTableHeaderFootViewModel *headerModel = HDTableHeaderFootViewModel.new;
            headerModel.title = dateStr;
            sectionModel.headerModel = headerModel;
            sectionModel.list = @[obj];
            // 计算真实区间
            NSString *startDate = [NSString stringWithFormat:@"01/%@ 00:00:00", dateStr];
            NSArray<NSString *> *dayMonthStrArr = [dateStr componentsSeparatedByString:@"/"];
            NSString *endDate = [NSString stringWithFormat:@"%02ld/%@ 23:59:59", (long)[PNCommonUtils getDayByMonth:dayMonthStrArr[0].integerValue Year:dayMonthStrArr[1].integerValue], dateStr];
            sectionModel.commonHeaderModel = @{@"startDateStr": startDate, @"endDateStr": endDate};

            [sections addObject:sectionModel];
        }
    }];

    self.dataSource = sections;
}

#pragma mark - Action
- (void)clickOnDatePicker {
    HDBillDatePickViewController *vc = [HDBillDatePickViewController new];
    vc.delegate = self;
    SANavigationController *nav = [[SANavigationController alloc] initWithRootViewController:vc];
    //    nav.modalPresentationStyle = UIModalPresentationPageSheet;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)clickOnTips:(HDUIButton *)button {
    HDCustomViewActionViewConfig *config = HDCustomViewActionViewConfig.new;
    //    config.containerViewEdgeInsets = UIEdgeInsetsMake(kRealWidth(20), kRealWidth(15), 0, kRealWidth(15));
    config.buttonTitle = SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons");

    const CGFloat width = kScreenWidth - config.containerViewEdgeInsets.left - config.containerViewEdgeInsets.right;

    SAInfoAlertViewModel *model = SAInfoAlertViewModel.new;
    model.text = SALocalizedString(@"userBillList_tips", @"• 账单记录为\"在线支付、线下转账\"交易 \n\n• 账单不包括\"货到付款\"交易");
    model.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(50), kRealWidth(15), kRealWidth(80), kRealWidth(15));

    SAInfoAlertView *view = [[SAInfoAlertView alloc] initWithFrame:CGRectMake(0, 0, width, 10)];
    view.model = model;
    [view layoutyImmediately];
    HDCustomViewActionView *actionView = [HDCustomViewActionView actionViewWithContentView:view config:config];
    [actionView show];
}

#pragma mark - Data

- (void)queryUserBillListWithPageNum:(NSUInteger)pageNum {
    @HDWeakify(self);
    [self.billDTO queryUserBillListWithPageNum:pageNum pageSize:20 startTime:self.startTime endTime:self.endTime success:^(SAUserBillListRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.currentPage = rspModel.pageNum;

        if (pageNum == 1) {
            self.dataSource = @[];
            [self processRspDatas:rspModel.list];
            [self.tableView successGetNewDataWithNoMoreData:!rspModel.hasNextPage];
        } else {
            [self processRspDatas:rspModel.list];
            [self.tableView successLoadMoreDataWithNoMoreData:!rspModel.hasNextPage];
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        if (pageNum == 1) {
            [self.tableView failGetNewData];
        } else {
            [self.tableView failLoadMoreData];
        }
    }];
}

- (void)getBillStatistticsWithSectionModel:(HDTableViewSectionModel *)sectioModel {
    NSString *startDateStr = [sectioModel.commonHeaderModel objectForKey:@"startDateStr"];
    NSString *endDateStr = [sectioModel.commonHeaderModel objectForKey:@"endDateStr"];

    NSTimeInterval startTime = [[startDateStr dateWithFormat:@"dd/MM/yyyy HH:mm:ss"] timeIntervalSince1970];
    NSTimeInterval endTime = [[endDateStr dateWithFormat:@"dd/MM/yyyy HH:mm:ss"] timeIntervalSince1970];
    @HDWeakify(self);
    [self.billDTO getUserBillStatisticsWithStatTime:startTime endTime:endTime success:^(SAUserBillStatisticsRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        sectioModel.headerModel.rightButtonTitle = [NSString stringWithFormat:@"%@ %@ | %@ %@",
                                                                              SALocalizedString(@"userBillList_cash_out", @"支出"),
                                                                              rspModel.cashOutAmt.thousandSeparatorAmount,
                                                                              SALocalizedString(@"userBillList_cash_in", @"收入"),
                                                                              rspModel.cashInAmt.thousandSeparatorAmount];

        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:[self.dataSource indexOfObject:sectioModel]] withRowAnimation:UITableViewRowAnimationNone];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error){

    }];
}

#pragma mark billDatePickDelegate -----
- (void)DatePickDateType:(HD_SEARCH_DATE_TYPE)dateType Start:(NSString *)start End:(NSString *)end {
    if (dateType == HD_SEARCH_DATE_TYPE_MONTH) {
        NSString *startDate = [NSString stringWithFormat:@"01/%@ 00:00:00", start];
        NSArray<NSString *> *dayMonthStrArr = [start componentsSeparatedByString:@"/"];
        NSString *endDate = [NSString stringWithFormat:@"%02ld/%@ 23:59:59", (long)[PNCommonUtils getDayByMonth:dayMonthStrArr[0].integerValue Year:dayMonthStrArr[1].integerValue], start];
        self.startTime = [[startDate dateWithFormat:@"dd/MM/yyyy HH:mm:ss"] timeIntervalSince1970];
        self.endTime = [[endDate dateWithFormat:@"dd/MM/yyyy HH:mm:ss"] timeIntervalSince1970];

    } else {
        NSString *startDate = [NSString stringWithFormat:@"%@ 00:00:00", start];
        NSString *endDate = [NSString stringWithFormat:@"%@ 23:59:59", end];
        self.startTime = [[startDate dateWithFormat:@"dd/MM/yyyy HH:mm:ss"] timeIntervalSince1970];
        self.endTime = [[endDate dateWithFormat:@"dd/MM/yyyy HH:mm:ss"] timeIntervalSince1970];
    }

    [self.tableView getNewData];
}

- (void)DatePickCancel {
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource[section].list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataSource[indexPath.section].list[indexPath.row];
    if ([model isKindOfClass:SAUserBillListModel.class]) {
        SAUserBillListTableViewCell *cell = [SAUserBillListTableViewCell cellWithTableView:tableView];
        cell.model = model;
        return cell;
    }
    return UITableViewCell.new;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataSource[indexPath.section].list[indexPath.row];
    if ([model isKindOfClass:SAUserBillListModel.class]) {
        SAUserBillListModel *trueModel = model;
        if (trueModel.billingType.code == 1) {
            [HDMediator.sharedInstance navigaveToBillPaymentDetails:@{@"payTransactionNo": trueModel.payTransactionNo}];
        } else if (trueModel.billingType.code == 2) {
            [HDMediator.sharedInstance navigaveToBillRefundDetails:@{@"refundTransactionNo": trueModel.refundTransactionNo}];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HDTableViewSectionModel *sectionModel = self.dataSource[section];
    SAUserBillListHeaderView *header = [SAUserBillListHeaderView headerWithTableView:tableView];
    header.model = sectionModel.headerModel;
    @HDWeakify(self);
    header.titleClickedHander = ^(HDTableHeaderFootViewModel *_Nonnull headerModel) {
        @HDStrongify(self);
        [self clickOnDatePicker];
    };

    if (sectionModel.headerModel && sectionModel.commonHeaderModel && HDIsStringEmpty(sectionModel.headerModel.rightButtonTitle)) {
        [self getBillStatistticsWithSectionModel:sectionModel];
    }

    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kRealHeight(45);
}

#pragma mark - lazy load
- (SATableView *)tableView {
    if (!_tableView) {
        _tableView = [[SATableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0) style:UITableViewStylePlain];
        _tableView.needRefreshHeader = YES;
        _tableView.needRefreshFooter = YES;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (SAUserBillDTO *)billDTO {
    if (!_billDTO) {
        _billDTO = SAUserBillDTO.new;
    }
    return _billDTO;
}

- (HDUIButton *)tipsButton {
    if (!_tipsButton) {
        _tipsButton = [[HDUIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [_tipsButton setImage:[[UIImage imageNamed:@"icon-help"] hd_imageResizedInLimitedSize:CGSizeMake(22, 22)] forState:UIControlStateNormal];
        //        _tipsButton.imageEdgeInsets = UIEdgeInsetsMake(1, 1, 1, 1);
        //        _tipsButton.imageView.frame = CGRectMake(0, 0, 44, 44);
        [_tipsButton addTarget:self action:@selector(clickOnTips:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tipsButton;
}

@end
