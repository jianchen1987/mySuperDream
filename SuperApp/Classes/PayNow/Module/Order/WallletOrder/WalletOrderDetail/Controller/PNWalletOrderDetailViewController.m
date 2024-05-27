//
//  PNWalletOrderDetailViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2023/2/6.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNWalletOrderDetailViewController.h"
#import "PNTableView.h"
#import "PNWalletOrderDTO.h"
#import "PNWalletOrderDetailHeaderView.h"
#import "PNWalletOrderDetailModel.h"
#import "SAInfoTableViewCell.h"
#import "SAInfoView.h"


@interface PNWalletOrderDetailViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, strong) PNTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) PNWalletOrderDetailModel *billDetailModel;
@property (nonatomic, strong) PNWalletOrderDetailHeaderView *headView;
@property (nonatomic, strong) PNWalletOrderDTO *orderDTO;
@end


@implementation PNWalletOrderDetailViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.orderNo = [parameters objectForKey:@"orderNo"];
    }
    return self;
}

- (void)hd_setupNavigation {
    self.boldTitle = PNLocalizedString(@"trans_details", @"交易详情");
}

- (void)hd_setupViews {
    [self.view addSubview:self.tableView];

    [self getData];
}

- (void)updateViewConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];

    [super updateViewConstraints];
}

#pragma mark
- (void)getData {
    [self showloading];

    @HDWeakify(self);
    [self.orderDTO getWalletOrderDetailWithOrderNo:self.orderNo success:^(PNWalletOrderDetailModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self dismissLoading];

        self.billDetailModel = rspModel;
        [self drawDetailsByRspModel:self.billDetailModel];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}

#pragma mark
- (SAInfoViewModel *)infoViewModelWithKey:(NSString *)key value:(NSString *)value {
    SAInfoViewModel *model = [[SAInfoViewModel alloc] init];
    model.keyText = key;
    model.keyFont = HDAppTheme.PayNowFont.standard14;
    model.keyColor = HDAppTheme.PayNowColor.c999999;
    model.keyNumbersOfLines = 0;
    model.valueText = value;
    model.valueFont = HDAppTheme.PayNowFont.standard14M;
    model.valueColor = HDAppTheme.PayNowColor.c333333;
    model.valueNumbersOfLines = 0;
    model.lineWidth = 0;
    model.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(6), kRealWidth(12), kRealWidth(6), kRealWidth(12));
    return model;
}

- (NSString *)formatDate:(NSString *)dateTime {
    return [PNCommonUtils getDateStrByFormat:@"dd/MM/yyyy HH:mm" withDate:[NSDate dateWithTimeIntervalSince1970:dateTime.floatValue / 1000]];
}

- (void)drawDetailsByRspModel:(PNWalletOrderDetailModel *)rspModel {
    [self.dataSource removeAllObjects];

    self.headView.model = rspModel;

    [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"5xdNPvU0", @"交易状态") value:rspModel.tradeStatus]];
    [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"vHTu9ZGs", @"业务类型") value:rspModel.orderType]];
    [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"3WYdfNiq", @"账务流水号") value:rspModel.orderSerialNo]];
    [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"PAGE_TEXT_ORDERNO", @"订单号") value:rspModel.tradeNo]];
    [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"PAGE_TEXT_CREATE_TIME", @"创建时间") value:[self formatDate:rspModel.createTime]]];

    if (WJIsStringNotEmpty(rspModel.rate)) {
        NSString *keyStr = @"";
        if ([rspModel.debitCreditFlag isEqualToString:@"+"]) {
            keyStr = PNLocalizedString(@"Ffyc9JwU", @"汇入金额");
        } else {
            keyStr = PNLocalizedString(@"kbgEMmB0", @"汇出金额");
        }
        [self.dataSource addObject:[self infoViewModelWithKey:keyStr value:rspModel.exchangeAmount.thousandSeparatorAmount]];
        [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"TEXT_EXCHANGE_RATE", @"汇率") value:[NSString stringWithFormat:@"$1=៛%@", rspModel.rate]]];
    }

    [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"wiU2b9Uf", @"账户余额") value:rspModel.balance.thousandSeparatorAmount]];
    [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"remark", @"备注") value:rspModel.remark]];

    [self.tableView successGetNewDataWithNoMoreData:YES];
}

#pragma mark
- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return YES;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(SATableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(SATableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.dataSource.count)
        return UITableViewCell.new;
    SAInfoViewModel *model = self.dataSource[indexPath.row];
    SAInfoTableViewCell *cell = [SAInfoTableViewCell cellWithTableView:tableView];
    cell.model = model;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (!WJIsObjectNil(self.billDetailModel)) {
        return self.headView;
    } else {
        return UIView.new;
    }
}

#pragma mark - lazy load
- (PNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[PNTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.needRefreshHeader = NO;
        _tableView.needRefreshFooter = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;
        _tableView.estimatedSectionHeaderHeight = 200;
        _tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    }
    return _tableView;
}

- (PNWalletOrderDetailHeaderView *)headView {
    if (!_headView) {
        _headView = [[PNWalletOrderDetailHeaderView alloc] init];
    }
    return _headView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (PNWalletOrderDTO *)orderDTO {
    if (!_orderDTO) {
        _orderDTO = [[PNWalletOrderDTO alloc] init];
    }
    return _orderDTO;
}

@end
