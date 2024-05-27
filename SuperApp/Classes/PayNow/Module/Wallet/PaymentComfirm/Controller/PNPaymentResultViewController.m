//
//  PNPaymentResultViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2023/2/8.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNPaymentResultViewController.h"
#import "PNBottomView.h"
#import "PNPaymentComfirmDTO.h"
#import "PNPaymentResultHeaderView.h"
#import "PNPaymentResultRspModel.h"
#import "PNTableView.h"
#import "PNWalletOrderDetailModel.h"
#import "SAInfoTableViewCell.h"
#import "SAInfoView.h"


@interface PNPaymentResultViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) PNTableView *tableView;
@property (nonatomic, strong) HDUIButton *doneBtn;

@property (nonatomic, copy) NSString *tradeNo;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) PNPaymentResultRspModel *billDetailModel;
@property (nonatomic, strong) PNPaymentResultHeaderView *headView;
@property (nonatomic, strong) PNPaymentComfirmDTO *paymentDTO;
@property (nonatomic, strong) PNBottomView *bottomView;

@property (nonatomic, copy) void (^completeBlock)(void);
@end


@implementation PNPaymentResultViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.tradeNo = [parameters objectForKey:@"tradeNo"];
        self.completeBlock = [parameters objectForKey:@"completeBlock"];
    }
    return self;
}

- (void)hd_setupNavigation {
    //    self.boldTitle = PNLocalizedString(@"Log1CQtZ", @"支付结果");
    [self setHd_navLeftBarButtonItem:nil];
    self.hd_navBackgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    //    self.hd_navRightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.doneBtn];
}

- (void)hd_setupViews {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];

    [self getData];
}

- (void)updateViewConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hd_navigationBar.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(self.bottomView.mas_top);
    }];

    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
    }];

    [super updateViewConstraints];
}

#pragma mark
- (void)getData {
    [self showloading];

    @HDWeakify(self);
    [self.paymentDTO getPaymentResultWithTradeNo:self.tradeNo success:^(PNPaymentResultRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self dismissLoading];
        self.billDetailModel = rspModel;
        [self drawDetailsByRspModel:self.billDetailModel];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
        [self.tableView failGetNewData];
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

- (void)drawDetailsByRspModel:(PNPaymentResultRspModel *)rspModel {
    [self.dataSource removeAllObjects];

    self.headView.model = rspModel;

    [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"TEXTFIELD_TITLE_PAYMENT_ACC_NO", @"付款账号") value:rspModel.customerNo]];
    [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"EflnCwt2", @"手机号") value:rspModel.usrMp]];
    [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"ms_pay_balance", @"付款账户") value:rspModel.payerAccounString]];

    [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"pn_charge", @"手续费") value:rspModel.serviceAmt.thousandSeparatorAmount]];
    [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"d1q6xTQ3", @"营销减免") value:rspModel.promotion.thousandSeparatorAmount]];
    if (rspModel.exchangeRate.doubleValue > 0) {
        [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"Epqp59t7", @"当前汇率") value:[NSString stringWithFormat:@"$1 = ៛%zd", rspModel.exchangeRate.integerValue]]];
    }
    [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"pn_receiver_account", @"收款账号") value:rspModel.payeeCustomerNo]];
    [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"8JOkLAyq", @"收款用户名") value:rspModel.payeeUserName]];
    [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"pn_Receiving_bank", @"收款银行") value:rspModel.payeeBank]];

    [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"PAGE_TEXT_ORDERNO", @"订单号") value:rspModel.tradeNo]];
    [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"PAGE_TEXT_CREATE_TIME", @"创建时间") value:[self formatDate:rspModel.createTime]]];

    NSString *khr = [NSString stringWithFormat:@"%@: %@", PNCurrencyTypeKHR, rspModel.khrBalance.thousandSeparatorAmount];
    NSString *usd = [NSString stringWithFormat:@"%@: %@", PNCurrencyTypeUSD, rspModel.usdBalance.thousandSeparatorAmount];

    [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"TuYqOnTv", @"用户钱包余额") value:[NSString stringWithFormat:@"%@\n%@", khr, usd]]];

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

- (PNPaymentResultHeaderView *)headView {
    if (!_headView) {
        _headView = [[PNPaymentResultHeaderView alloc] init];
    }
    return _headView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (PNPaymentComfirmDTO *)paymentDTO {
    if (!_paymentDTO) {
        _paymentDTO = [[PNPaymentComfirmDTO alloc] init];
    }
    return _paymentDTO;
}

- (HDUIButton *)doneBtn {
    if (!_doneBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsButtonWhenHighlighted = false;
        [button setTitle:SALocalizedString(@"complete", @"完成") forState:UIControlStateNormal];
        [button setTitleColor:HDAppTheme.PayNowColor.mainThemeColor forState:UIControlStateNormal];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard14;
        button.titleEdgeInsets = UIEdgeInsetsMake(12, 7, 12, 7);
        [button sizeToFit];

        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self.navigationController dismissAnimated:YES completion:nil];
            !self.completeBlock ?: self.completeBlock();
        }];

        _doneBtn = button;
    }
    return _doneBtn;
}

- (PNBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[PNBottomView alloc] initWithTitle:PNLocalizedString(@"BUTTON_TITLE_DONE", @"完成")];

        @HDWeakify(self);
        _bottomView.btnClickBlock = ^{
            @HDStrongify(self);
            [self.navigationController dismissAnimated:YES completion:nil];
            !self.completeBlock ?: self.completeBlock();
        };
    }
    return _bottomView;
}

@end
