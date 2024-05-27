//
//  PNInterTransferLimitController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/7/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInterTransferLimitController.h"
#import "PNGridCell.h"
#import "PNGrideItemModel.h"
#import "PNInterTransferDTO.h"
#import "PNInterTransferRiskListModel.h"
#import "PNTableView.h"


@interface PNInterTransferLimitController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) PNInterTransferDTO *transDTO;
@property (nonatomic, strong) PNTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL isMore;
@property (nonatomic, assign) PNInterTransferThunesChannel channel;
@end


@implementation PNInterTransferLimitController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.isMore = [[parameters objectForKey:@"more"] boolValue];
        self.channel = [[parameters objectForKey:@"channel"] integerValue];
    }
    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"pn_inter_transfer_limit", @"转账限额");
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (void)hd_bindViewModel {
    [self getData];
}

- (void)hd_setupViews {
    [self.view addSubview:self.tableView];
}

- (void)updateViewConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.isMore) {
            make.top.mas_equalTo(self.view).offset(kRealWidth(16));
        } else {
            make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
        }
        make.left.right.bottom.equalTo(self.view);
    }];

    [super updateViewConstraints];
}

#pragma mark
- (void)getData {
    [self.view showloading];
    @HDWeakify(self);
    [self.transDTO queryriskListWithChannel:self.channel success:^(NSArray<PNInterTransferRiskListModel *> *_Nonnull rspArray) {
        @HDStrongify(self);
        [self.view dismissLoading];
        self.scrollViewContainer.hidden = NO;

        [self processingData:rspArray];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

- (void)processingData:(NSArray<PNInterTransferRiskListModel *> *)array {
    for (PNInterTransferRiskListModel *itemModel in array) {
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObjectsFromArray:[self getSecionHeaderRowData]];

        // 单笔
        [arr addObject:[self defaultContentItemModel:PNLocalizedString(@"pn_single", @"单笔")]];

        NSString *singleLimitStr = itemModel.singleLimit.thousandSeparatorAmountNoCurrencySymbol;
        if (itemModel.singleLimit.cent.doubleValue <= 0) {
            singleLimitStr = PNLocalizedString(@"pn_no_limit", @"不限");
        }
        [arr addObject:[self defaultContentItemModel:singleLimitStr]];

        [arr addObject:[self defaultContentItemModel:@"-"]];

        // 按日累计
        [arr addObject:[self defaultContentItemModel:PNLocalizedString(@"pn_txn_day", @"按日累计")]];

        NSString *singleDayLimitStr = itemModel.singleDayLimit.thousandSeparatorAmountNoCurrencySymbol;
        if (itemModel.singleDayLimit.cent.doubleValue <= 0) {
            singleDayLimitStr = PNLocalizedString(@"pn_no_limit", @"不限");
        }
        [arr addObject:[self defaultContentItemModel:singleDayLimitStr]];

        NSString *dailyCumulativeTimesStr = [NSString stringWithFormat:@"%zd", itemModel.dailyCumulativeTimes];
        if (itemModel.dailyCumulativeTimes <= 0) {
            dailyCumulativeTimesStr = @"-";
        }
        [arr addObject:[self defaultContentItemModel:dailyCumulativeTimesStr]];

        // 按日累计
        [arr addObject:[self defaultContentItemModel:PNLocalizedString(@"pn_txn_month", @"按月累计")]];

        NSString *monthlyCumulativeLimitStr = itemModel.monthlyCumulativeLimit.thousandSeparatorAmountNoCurrencySymbol;
        if (itemModel.monthlyCumulativeLimit.cent.doubleValue <= 0) {
            monthlyCumulativeLimitStr = PNLocalizedString(@"pn_no_limit", @"不限");
        }
        [arr addObject:[self defaultContentItemModel:monthlyCumulativeLimitStr]];

        NSString *monthlyCumulativeTimesStr = [NSString stringWithFormat:@"%zd", itemModel.monthlyCumulativeTimes];
        if (itemModel.monthlyCumulativeTimes <= 0) {
            monthlyCumulativeTimesStr = @"-";
        }
        [arr addObject:[self defaultContentItemModel:monthlyCumulativeTimesStr]];

        // 按年累计
        [arr addObject:[self defaultContentItemModel:PNLocalizedString(@"pn_txn_year", @"按年累计")]];

        NSString *annualCumulativeLimitStr = itemModel.annualCumulativeLimit.thousandSeparatorAmountNoCurrencySymbol;
        if (itemModel.annualCumulativeLimit.cent.doubleValue <= 0) {
            annualCumulativeLimitStr = PNLocalizedString(@"pn_no_limit", @"不限");
        }
        [arr addObject:[self defaultContentItemModel:annualCumulativeLimitStr]];

        [arr addObject:[self defaultContentItemModel:@"-"]];

        PNGrideModel *model = PNGrideModel.new;
        model.gridColumn = 3;
        if (itemModel.direction == PNInterTransferDirectionPayer) {
            model.title = PNLocalizedString(@"pn_limit_for_payer", @"转账限额(Transfer Limit for payer)");
        } else {
            model.title = PNLocalizedString(@"pn_limit_for_receiver", @"转账限额(Transfer Limit for Receiver)");
        }
        model.listArray = arr;
        [self.dataArray addObject:model];
    }

    [self.tableView successGetNewDataWithNoMoreData:NO];
}

- (NSArray *)getSecionHeaderRowData {
    PNGrideItemModel *model0 = [self defaultSectionItemModel];
    model0.value = PNLocalizedString(@"pn_limit_type", @"类型");

    PNGrideItemModel *model1 = [self defaultSectionItemModel];
    model1.value = [NSString stringWithFormat:@"%@($)", PNLocalizedString(@"pn_limit_amount", @"限额")];

    PNGrideItemModel *model2 = [self defaultSectionItemModel];
    model2.value = PNLocalizedString(@"pn_limit_time", @"次数");

    return @[model0, model1, model2];
}

- (PNGrideItemModel *)defaultSectionItemModel {
    PNGrideItemModel *model = [[PNGrideItemModel alloc] init];
    model.cellBackgroudColor = HDAppTheme.PayNowColor.backgroundColor;
    model.valueFont = HDAppTheme.PayNowFont.standard16B;
    model.valueColor = HDAppTheme.PayNowColor.c333333;

    return model;
}

- (PNGrideItemModel *)defaultContentItemModel:(NSString *)value {
    PNGrideItemModel *model = [[PNGrideItemModel alloc] init];
    model.cellBackgroudColor = HDAppTheme.PayNowColor.cFFFFFF;
    model.valueFont = HDAppTheme.PayNowFont.standard14;
    model.valueColor = HDAppTheme.PayNowColor.c333333;
    model.value = value;

    return model;
}

#pragma mark
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PNGridCell *cell = [PNGridCell cellWithTableView:tableView];
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark
- (PNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[PNTableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = NO;
        _tableView.needRefreshFooter = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (PNInterTransferDTO *)transDTO {
    if (!_transDTO) {
        _transDTO = [[PNInterTransferDTO alloc] init];
    }
    return _transDTO;
}

- (UIView *)listView {
    return self.view;
}
@end
