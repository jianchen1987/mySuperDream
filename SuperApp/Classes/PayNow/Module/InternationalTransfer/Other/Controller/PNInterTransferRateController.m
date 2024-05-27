//
//  PNInterTransferRateController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/7/14.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInterTransferRateController.h"
#import "PNGridCell.h"
#import "PNGrideItemModel.h"
#import "PNInterTransferDTO.h"
#import "PNInterTransferRateFeeModel.h"
#import "PNTableView.h"


@interface PNInterTransferRateController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) PNInterTransferDTO *transDTO;
@property (nonatomic, strong) PNTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL isMore;
@property (nonatomic, assign) PNInterTransferThunesChannel channel;

@end


@implementation PNInterTransferRateController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.isMore = [[parameters objectForKey:@"more"] boolValue];
        self.channel = [[parameters objectForKey:@"channel"] integerValue];
    }
    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"Service_Charge", @"手续费");
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
    [self.transDTO queryRateFeeWithChannel:self.channel success:^(PNInterTransferRateFeeModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        self.scrollViewContainer.hidden = NO;
        [self processingData:rspModel];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

- (void)processingData:(PNInterTransferRateFeeModel *)rateFeeModel {
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObjectsFromArray:[self getSecionHeaderRowData]];

    for (PNInterTransferFeeInfoModel *infoModel in rateFeeModel.feeInfos) {
        NSString *leftAmount = [NSString stringWithFormat:@"%@<%@<=%@",
                                                          infoModel.feeStartAmt.thousandSeparatorAmountNoCurrencySymbol,
                                                          PNLocalizedString(@"kwCIcL1x", @"金额"),
                                                          infoModel.feeEndAmt.thousandSeparatorAmountNoCurrencySymbol];
        [arr addObject:[self defaultContentItemModel:leftAmount]];

        NSString *rightFee = @"";
        if (infoModel.personalRule.feeCalcType == PNInterTransFeeCalcTypeFixedAmount) {
            // 固定金额
            rightFee = infoModel.personalRule.feeFixed.thousandSeparatorAmountNoCurrencySymbol;
        } else if (infoModel.personalRule.feeCalcType == PNInterTransFeeCalcTypePercent) {
            rightFee = [NSString stringWithFormat:@"%@%%", infoModel.personalRule.feeRate.thousandSeparatorAmountNoCurrencySymbol];
        }
        [arr addObject:[self defaultContentItemModel:rightFee]];
    }

    PNGrideModel *model = PNGrideModel.new;
    model.gridColumn = 2;
    model.listArray = arr;
    [self.dataArray addObject:model];

    [self.tableView successGetNewDataWithNoMoreData:NO];
}

- (NSArray *)getSecionHeaderRowData {
    PNGrideItemModel *model = [self defaultSectionItemModel];
    model.value = [NSString stringWithFormat:@"%@($)", PNLocalizedString(@"pn_limit_amount", @"限额")];

    PNGrideItemModel *model2 = [self defaultSectionItemModel];
    model2.value = [NSString stringWithFormat:@"%@($)", PNLocalizedString(@"pn_fee_charge", @"收费标准")];

    return @[model, model2];
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
