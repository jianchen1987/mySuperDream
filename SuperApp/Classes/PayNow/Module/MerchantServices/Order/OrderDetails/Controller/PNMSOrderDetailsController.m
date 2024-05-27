//
//  PNMSOrderDetailsController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/6/7.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSOrderDetailsController.h"
#import "HDUserBillDetailRspModel.h"
#import "PNCommonUtils.h"
#import "PNMSOrderDTO.h"
#import "PNOrderResultFailView.h"
#import "PNOrderTableHeaderView.h"
#import "PNOrderTableHeaderViewModel.h"
#import "PNQueryWithdrawCodeModel.h"
#import "PNTableView.h"
#import "SAInfoTableViewCell.h"
#import "VipayUser.h"


@interface PNMSOrderDetailsController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) HDUIButton *navBtn;
@property (nonatomic, strong) PNOrderTableHeaderView *headView;
@property (nonatomic, strong) PNTableView *tableView;

@property (nonatomic, strong) dispatch_source_t timer;     ///< 定时获取数据
@property (nonatomic, assign) BOOL isTimerRunning;         ///< 定时器是否正在运行
@property (nonatomic, assign) BOOL shouldQueryOrderStatus; ///< 是否要查询订单状态
@property (nonatomic, strong) HDUserBillDetailRspModel *billDetailModel;
@property (nonatomic, strong) PNQueryWithdrawCodeModel *withdrawCodeModel;
@property (nonatomic, strong) PNMSOrderDTO *transDTO;

@property (nonatomic, strong) dispatch_source_t querWithDrawCodeTimer; ///< 定时获取数据 - 查询提现码
@property (nonatomic, assign) BOOL isTimerRunningQuerWithDrawCode;     ///< 定时器是否正在运行 - 查询提现
///
@property (nonatomic, strong) HDPayOrderRspModel *rspModel;
@property (nonatomic, strong) NSString *merchantNo;
@property (nonatomic, assign) BOOL needBalance;

@property (nonatomic, copy) void (^clickedDoneBtnHandler)(void); ///< 点击完成
@property (nonatomic, strong) NSMutableArray<SAInfoViewModel *> *dataSource;
@property (nonatomic, assign) PNOrderResultPageType type; // 1结果页 否则详情页
@property (nonatomic, assign) PNTransType tradeType;
@end


@implementation PNMSOrderDetailsController
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.merchantNo = VipayUser.shareInstance.merchantNo;
        self.rspModel = [HDPayOrderRspModel yy_modelWithJSON:[parameters objectForKey:@"model"]];
        self.type = [[parameters objectForKey:@"viewType"] integerValue];
        self.clickedDoneBtnHandler = [parameters objectForKey:@"callback"];
        self.tradeType = [[parameters objectForKey:@"tradeType"] integerValue];
        self.needBalance = [[parameters objectForKey:@"needBalance"] boolValue];
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self stopQueryOrderStatusTimer];
    [self stopQueryOrderStatusTimerQueryWithDrawCode];
}

#pragma mark - SAViewControllerProtocol
- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    if (self.type == resultPage) {
        return HDViewControllerNavigationBarStyleHidden;
    }
    return HDViewControllerNavigationBarStyleWhite;
}

- (void)hd_setupViews {
    /// 支付结果页 和  交易详情 共用【区别是header 的logo】
    if (self.type == resultPage) {
        [self.view addSubview:self.navBtn];
    }

    self.view.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    self.headView.type = self.type;

    self.shouldQueryOrderStatus = (self.rspModel.payOrderStatus == PNOrderStatusProcessing) ? true : false;
    // 轮询状态
    if (self.shouldQueryOrderStatus) {
        [self startQueryOrderStatusTimer];
    } else {
        // 查询结果
        [self getBillDetails];
    }
}

/// 查询交易详情
- (void)getBillDetails {
    if (WJIsStringEmpty(self.rspModel.tradeNo))
        return;

    NSString *tradeTypeStr = @"";
    if (self.rspModel.tradeType != PNTransTypeDefault) {
        tradeTypeStr = [NSString stringWithFormat:@"%zd", self.rspModel.tradeType];
    }

    @HDWeakify(self);

    [self.transDTO getMSTransOrderDetailWithtTadeNo:self.rspModel.tradeNo merchantNo:self.merchantNo tradeType:self.tradeType needBalance:self.needBalance
        success:^(HDUserBillDetailRspModel *_Nonnull rspModel) {
            @HDStrongify(self);
            self.billDetailModel = rspModel;

            [self handleData];

            if (self.billDetailModel.status != PNOrderStatusProcessing) {
                self.shouldQueryOrderStatus = false;
                // 停止定时器
                [self stopQueryOrderStatusTimer];
            }
        } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            // 停止定时器
            [self stopQueryOrderStatusTimer];
        }];
}

- (void)handleData {
    switch (self.billDetailModel.status) {
        case PNOrderStatusUnknown: {
            self.rspModel.payOrderStatus = PNOrderStatusUnknown;
            self.rspModel.status = @0;
        } break;
        case PNOrderStatusProcessing: {
            self.rspModel.payOrderStatus = PNOrderStatusProcessing;
            self.rspModel.status = @11;
        } break;
        case PNOrderStatusSuccess: {
            self.rspModel.payOrderStatus = PNOrderStatusSuccess;
            self.rspModel.status = @12;
        } break;
        case PNOrderStatusFailure: {
            self.rspModel.payOrderStatus = PNOrderStatusFailure;
            self.rspModel.status = @13;
        } break;
        case PNOrderStatusRefund: {
            self.rspModel.payOrderStatus = PNOrderStatusRefund;
            self.rspModel.status = @15;
        } break;
        default:
            break;
    }

    self.rspModel.transactionHash = self.billDetailModel.transactionHash;
    self.rspModel.payeeNo = self.billDetailModel.payeeUsrMp;
    //处理数据
    [self toSetData];
}

- (void)toSetData {
    PNOrderTableHeaderViewModel *headerModel = PNOrderTableHeaderViewModel.new;
    switch (self.billDetailModel.status) {
        case PNOrderStatusSuccess:
            headerModel.iconImgName = @"pay_success";
            break;
        case PNOrderStatusFailure:
            headerModel.iconImgName = @"pay_fail";
            break;
        case PNOrderStatusProcessing:
            headerModel.iconImgName = @"pay_processing";
            break;
        default:
            headerModel.iconImgName = @"pay_fail";
            break;
    }

    headerModel.stateStr = [NSString stringWithFormat:@"(%@)", [PNCommonUtils getStatusByCode:self.billDetailModel.status]];

    headerModel.typeStr = [PNCommonUtils getTradeTypeNameByCode:self.billDetailModel.tradeType];
    /// 23 备付金提现 【额外处理】
    if (self.billDetailModel.tradeType == PNTransTypeRecharge) {
        headerModel.typeStr = PNLocalizedString(@"pn_Withdraw", @"提现");
    }

    NSString *amountStr = [NSString stringWithFormat:@"%@%@",
                                                     self.billDetailModel.incomeFlag,
                                                     [PNCommonUtils thousandSeparatorAmount:[PNCommonUtils fenToyuan:self.billDetailModel.realAmt.stringValue]
                                                                               currencyCode:self.billDetailModel.currency]];
    headerModel.incomeFlag = self.billDetailModel.incomeFlag;
    headerModel.amountStr = amountStr;
    headerModel.transType = self.billDetailModel.tradeType;
    self.headView.model = headerModel;

#pragma mark - 获取cell
    [self.dataSource removeAllObjects];

    switch (self.billDetailModel.tradeType) {
        case PNTransTypeRecharge: //入金
            [self drawRechargeDetailsByRspModel:self.billDetailModel];
            break;
        case PNTransTypeCollect: //收款
            [self drawCollectDetailsByRspModel:self.billDetailModel];
            break;
        case PNTransTypeRefund: //退款
            [self drawRefundDetailsByRspModel:self.billDetailModel];
            break;
        default:
            break;
    }

    [self.tableView successGetNewDataWithNoMoreData:NO];
}

#pragma mark Tools
- (NSString *)formatDate:(NSString *)dateTime {
    return [PNCommonUtils getDateStrByFormat:@"dd/MM/yyyy HH:mm" withDate:[NSDate dateWithTimeIntervalSince1970:dateTime.floatValue / 1000]];
}

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

#pragma mark
/// MARK: 收款
- (void)drawCollectDetailsByRspModel:(HDUserBillDetailRspModel *)rspModel {
    [self.dataSource
        addObject:[self infoViewModelWithKey:PNLocalizedString(@"PAGE_TEXT_ORDER_AMOUNT", @"订单金额")
                                       value:[NSString stringWithFormat:@"%@",
                                                                        [NSString stringWithFormat:@"%@",
                                                                                                   [PNCommonUtils thousandSeparatorAmount:[PNCommonUtils fenToyuan:rspModel.orderAmt.stringValue]
                                                                                                                             currencyCode:rspModel.currency]]]]];

    if (rspModel.serviceAmt.doubleValue > 0) {
        [self.dataSource
            addObject:[self infoViewModelWithKey:PNLocalizedString(@"PAGE_TEXT_FEE", @"手续费")
                                           value:[NSString stringWithFormat:@"%@",
                                                                            [NSString stringWithFormat:@"%@",
                                                                                                       [PNCommonUtils thousandSeparatorAmount:[PNCommonUtils fenToyuan:rspModel.serviceAmt.stringValue]
                                                                                                                                 currencyCode:rspModel.currency]]]]];
    }

    [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"TEXTFIELD_TITLE_PAYMENT_ACC_NO", @"付款账号") value:[PNCommonUtils deSensitiveString:rspModel.payerUsrMp]]];

    [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"PAGE_TEXT_PAYER", @"付款方") value:[NSString stringWithFormat:@"%@", rspModel.payerUsrName ?: @""]]];

    [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"pay_bank", @"付款银行") value:[NSString stringWithFormat:@"%@", rspModel.receiveBankName ?: @""]]];

    [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"PAGE_TEXT_CREATE_TIME", @"创建时间") value:[self formatDate:rspModel.createTime]]];

    [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"PAGE_TEXT_ORDERNO", @"订单号") value:rspModel.tradeNo]];

    if (rspModel.transactionHash.length > 0) {
        NSString *str = @"";
        if (rspModel.transactionHash.length > 8) {
            str = [rspModel.transactionHash substringToIndex:8];
        } else {
            str = rspModel.transactionHash;
        }

        [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"transaction_Hash", @"交易hash") value:str]];
    }

    if (WJIsStringNotEmpty(rspModel.storeNo)) {
        [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"pn_Store_NO", @"门店编号") value:rspModel.storeNo]];
    }

    if (WJIsStringNotEmpty(rspModel.storeName)) {
        [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"pn_store_name", @"门店名称") value:rspModel.storeName]];
    }

    if (WJIsStringNotEmpty(rspModel.storeOperatorName)) {
        [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"pn_Operator", @"操作员") value:rspModel.storeOperatorName]];
    }
}

/// MARK: 入金
- (void)drawRechargeDetailsByRspModel:(HDUserBillDetailRspModel *)rspModel {
    if ([rspModel.subBizEntity.code isEqualToString:PNTransferTypeWitdraw]) {
        /// 提现到银行
        [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"LoVFJY6s", @"用户钱包") value:rspModel.customerNo]];
        [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"EflnCwt2", @"手机号") value:rspModel.loginName]];

        [self.dataSource
            addObject:[self infoViewModelWithKey:PNLocalizedString(@"pn_withdarw_amount", @"提现金额")
                                           value:[NSString stringWithFormat:@"%@",
                                                                            [NSString stringWithFormat:@"%@",
                                                                                                       [PNCommonUtils thousandSeparatorAmount:[PNCommonUtils fenToyuan:rspModel.orderAmt.stringValue]
                                                                                                                                 currencyCode:rspModel.currency]]]]];

        [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"pn_Receiving_bank", @"收款银行") value:rspModel.bankName]];

        [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"pn_Receiver_name", @"收款人姓名") value:rspModel.accountName]];

        [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"pn_Receiver_bank_account", @"收款人银行账号") value:rspModel.accountNumber]];

        [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"pn_withdraw_datetime", @"提现时间") value:[self formatDate:rspModel.createTime]]];

        [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"PAGE_TEXT_ORDERNO", @"订单号") value:rspModel.tradeNo]];

        NSString *khr = [NSString stringWithFormat:@"%@: %@", PNCurrencyTypeKHR, rspModel.khrBalance.thousandSeparatorAmount];
        NSString *usd = [NSString stringWithFormat:@"%@: %@", PNCurrencyTypeUSD, rspModel.usdBalance.thousandSeparatorAmount];

        [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"TuYqOnTv", @"用户钱包余额") value:[NSString stringWithFormat:@"%@\n%@", khr, usd]]];

    } else {
        /// 提现到个人钱包
        [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"LoVFJY6s", @"用户钱包") value:rspModel.customerNo]];
        [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"EflnCwt2", @"手机号") value:rspModel.loginName]];
        [self.dataSource
            addObject:[self infoViewModelWithKey:PNLocalizedString(@"pn_withdarw_amount", @"提现金额")
                                           value:[NSString stringWithFormat:@"%@",
                                                                            [NSString stringWithFormat:@"%@",
                                                                                                       [PNCommonUtils thousandSeparatorAmount:[PNCommonUtils fenToyuan:rspModel.orderAmt.stringValue]
                                                                                                                                 currencyCode:rspModel.currency]]]]];

        [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"pn_Withdrawal_account", @"提现账户") value:rspModel.payeeUsrMp]];

        [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"customer_name", @"用户姓名") value:rspModel.payeeUsrName]];

        [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"pn_withdraw_datetime", @"提现时间") value:[self formatDate:rspModel.createTime]]];

        [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"PAGE_TEXT_ORDERNO", @"订单号") value:rspModel.tradeNo]];

        NSString *khr = [NSString stringWithFormat:@"%@: %@", PNCurrencyTypeKHR, rspModel.khrBalance.thousandSeparatorAmount];
        NSString *usd = [NSString stringWithFormat:@"%@: %@", PNCurrencyTypeUSD, rspModel.usdBalance.thousandSeparatorAmount];

        [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"TuYqOnTv", @"用户钱包余额") value:[NSString stringWithFormat:@"%@\n%@", khr, usd]]];
    }
}

/// MARK: 退款
- (void)drawRefundDetailsByRspModel:(HDUserBillDetailRspModel *)rspModel {
    /// bakong 退款

    [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"pn_refund_amount", @"退款金额")
                                                    value:[NSString stringWithFormat:@"%@",
                                                                                     [PNCommonUtils thousandSeparatorAmount:[PNCommonUtils fenToyuan:rspModel.orderAmt.stringValue]
                                                                                                               currencyCode:rspModel.currency]]]];

    [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"pn_receiver_account", @"收款账号")
                                                    value:[NSString stringWithFormat:@"%@", [PNCommonUtils deSensitiveString:rspModel.payeeUsrMp]]]];

    [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"PAGE_TEXT_PAYEE", @"收款方") value:rspModel.payeeUsrName]];

    if (WJIsStringNotEmpty(rspModel.receiveBankName)) {
        [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"pn_Receiving_bank", @"收款银行")
                                                        value:[NSString stringWithFormat:@"%@", WJIsStringNotEmpty(rspModel.receiveBankName) ? rspModel.receiveBankName : @""]]];
    }

    [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"PAGE_TEXT_CREATE_TIME", @"创建时间")
                                                    value:[PNCommonUtils getDateStrByFormat:@"dd/MM/yyyy HH:mm"
                                                                                   withDate:[NSDate dateWithTimeIntervalSince1970:rspModel.createTime.floatValue / 1000]]]];

    [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"PAGE_TEXT_ORDERNO", @"订单号") value:rspModel.tradeNo]];

    if (rspModel.transactionHash.length > 0) {
        NSString *str = @"";
        if (rspModel.transactionHash.length > 8) {
            str = [rspModel.transactionHash substringToIndex:8];
        } else {
            str = rspModel.transactionHash;
        }

        [self.dataSource addObject:[self infoViewModelWithKey:PNLocalizedString(@"transaction_Hash", @"交易hash") value:str]];
    }
}

#pragma mark
#pragma mark 定时器
// 停止定时器
- (void)stopQueryOrderStatusTimer {
    if (_timer && _isTimerRunning) {
        dispatch_source_cancel(_timer);
        _timer = nil;
        _isTimerRunning = NO;
    }
}

- (void)stopQueryOrderStatusTimerQueryWithDrawCode {
    if (_querWithDrawCodeTimer && _isTimerRunningQuerWithDrawCode) {
        dispatch_source_cancel(_querWithDrawCodeTimer);
        _querWithDrawCodeTimer = nil;
        _isTimerRunningQuerWithDrawCode = NO;
    }
}

// 开启定时器
- (void)startQueryOrderStatusTimer {
    // 全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    // 创建一个 timer 类型定时器
    if (!_timer) {
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    }
    // 设置定时器的各种属性（何时开始，间隔多久执行）
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC, 0);
    // 任务回调
    dispatch_source_set_event_handler(_timer, ^{
        // 查询结果
        [self getBillDetails];
    });
    // 开始定时器任务（定时器默认开始是暂停的，需要复位开启）
    if (_timer && !_isTimerRunning) {
        dispatch_resume(_timer);
        _isTimerRunning = YES;
    }
}

#pragma mark - layout
- (void)updateViewConstraints {
    if (self.type == resultPage) {
        [self.navBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view.mas_right).offset(kRealWidth(-15));
            make.top.equalTo(self.view).offset(kRealHeight(20) + kStatusBarH);
        }];
    }

    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        if (self.type == resultPage) {
            make.top.equalTo(self.navBtn.mas_bottom);
        } else {
            make.top.equalTo(self.hd_navigationBar.mas_bottom);
        }
    }];
    [super updateViewConstraints];
}

- (void)hd_setupNavigation {
    if (self.type != 1) {
        self.boldTitle = PNLocalizedString(@"trans_details", @"交易详情");
    }
}

#pragma mark - SAMultiLanguageRespond
- (UIStatusBarStyle)hd_fixedStatusBarStyle:(UIStatusBarStyle)style {
    return UIStatusBarStyleDefault;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return false;
}

- (BOOL)hd_shouldHideNavigationBarBottomLine {
    return false;
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
        _tableView.needRefreshHeader = true;
        _tableView.needRefreshFooter = false;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;
        _tableView.estimatedSectionHeaderHeight = 200;
        _tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
        _tableView.bounces = false;
    }
    return _tableView;
}

- (HDUIButton *)navBtn {
    if (!_navBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsButtonWhenHighlighted = false;
        [button setTitle:PNLocalizedString(@"BUTTON_TITLE_DONE", @"完成") forState:UIControlStateNormal];
        [button setTitleColor:HDAppTheme.PayNowColor.cFD7127 forState:UIControlStateNormal];
        button.titleLabel.font = [HDAppTheme.font boldForSize:17];
        [button sizeToFit];
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            !self.clickedDoneBtnHandler ?: self.clickedDoneBtnHandler();
            [self dismissAnimated:YES completion:nil];
        }];

        _navBtn = button;
    }
    return _navBtn;
}

- (PNOrderTableHeaderView *)headView {
    if (!_headView) {
        _headView = PNOrderTableHeaderView.new;
        _headView.backgroundColor = [UIColor clearColor];
    }
    return _headView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

- (PNMSOrderDTO *)transDTO {
    if (!_transDTO) {
        _transDTO = [[PNMSOrderDTO alloc] init];
    }
    return _transDTO;
}

@end
