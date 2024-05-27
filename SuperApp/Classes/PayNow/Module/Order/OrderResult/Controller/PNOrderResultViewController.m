//
//  OrderResultVC.m
//  SuperApp
//
//  Created by Quin on 2021/11/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNOrderResultViewController.h"
#import "HDUserBillDetailRspModel.h"
#import "PNCommonUtils.h"
#import "PNOrderResultFailView.h"
#import "PNOrderTableHeaderView.h"
#import "PNOrderTableHeaderViewModel.h"
#import "PNQueryWithdrawCodeModel.h"
#import "PNTableView.h"
#import "PNTransListDTO.h"
#import "PayOrderTableCell.h"


@interface PNOrderResultViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) HDUIButton *navBtn;
@property (nonatomic, strong) PNOrderTableHeaderView *headView;
@property (nonatomic, strong) PNOrderResultFailView *footFailView;
@property (nonatomic, strong) PNTableView *tableView;

@property (nonatomic, strong) dispatch_source_t timer;     ///< 定时获取数据
@property (nonatomic, assign) BOOL isTimerRunning;         ///< 定时器是否正在运行
@property (nonatomic, assign) BOOL shouldQueryOrderStatus; ///< 是否要查询订单状态
@property (nonatomic, strong) HDUserBillDetailRspModel *billDetailModel;
@property (nonatomic, strong) PNQueryWithdrawCodeModel *withdrawCodeModel;
@property (nonatomic, strong) PNTransListDTO *transDTO;

@property (nonatomic, strong) dispatch_source_t querWithDrawCodeTimer; ///< 定时获取数据 - 查询提现码
@property (nonatomic, assign) BOOL isTimerRunningQuerWithDrawCode;     ///< 定时器是否正在运行 - 查询提现am

@end


@implementation PNOrderResultViewController
#pragma mark - SAViewControllerRoutableProtocol
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (![parameters isEqualToDictionary:@{}]) {
        self.rspModel = HDPayOrderRspModel.new;
        self.rspModel.tradeNo = parameters[@"tradeNo"];
    }
    if (!self)
        return nil;

    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self stopQueryOrderStatusTimer];
    [self stopQueryOrderStatusTimerQueryWithDrawCode];
}

#pragma mark - SAViewControllerProtocol
- (void)hd_setupViews {
    /// 支付结果页 和  交易详情 共用【区别是header 的logo】
    if (self.type == resultPage) {
        [self.view addSubview:self.navBtn];
    }

    self.view.backgroundColor = HDAppTheme.PayNowColor.cF8F8F8;
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
    [self.transDTO getTransOrderDetailWithtTadeNo:self.rspModel.tradeNo tradeType:tradeTypeStr success:^(HDUserBillDetailRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.billDetailModel = rspModel;

        /// 按理来说只需要查询一次
        if (self.billDetailModel.tradeType == PNTransTypeToPhone) {
            self.billDetailModel.withdrawCode = self.withdrawCodeModel.code;
            self.billDetailModel.withdrawStatus = self.withdrawCodeModel.status;
            self.billDetailModel.withdrawOverdueTime = self.withdrawCodeModel.expiredTime;

            if (WJIsStringEmpty(self.withdrawCodeModel.code)) {
                [self startQueryOrderStatusTimerWithDrawCode];
            }
        } else {
            [self handleData];
        }

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

/// 查询提现码
- (void)querWithDrawCode {
    [self.transDTO queryWithdrawCodeWithTradeNo:self.rspModel.tradeNo success:^(PNQueryWithdrawCodeModel *_Nonnull rspModel) {
        self.withdrawCodeModel = rspModel;

        self.billDetailModel.withdrawCode = self.withdrawCodeModel.code;
        self.billDetailModel.withdrawStatus = self.withdrawCodeModel.status;
        self.billDetailModel.withdrawOverdueTime = self.withdrawCodeModel.expiredTime;

        [self handleData];

        if (WJIsStringNotEmpty(self.withdrawCodeModel.code)) {
            [self stopQueryOrderStatusTimerQueryWithDrawCode];
        }
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        /// 如果查询失败也要让界面出数据先
        [self handleData];
        [self stopQueryOrderStatusTimerQueryWithDrawCode];
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

    if (self.billDetailModel.tradeType == PNTransTypeAdjust) { ///调账不显示状态
        headerModel.stateStr = @"";
    } else {
        headerModel.stateStr = [NSString stringWithFormat:@"(%@)", [PNCommonUtils getStatusByCode:self.billDetailModel.status]];
    }

    headerModel.typeStr = [PNCommonUtils getTradeTypeNameByCode:self.billDetailModel.tradeType];

    NSString *amountStr = [NSString stringWithFormat:@"%@%@",
                                                     self.billDetailModel.incomeFlag,
                                                     [PNCommonUtils thousandSeparatorAmount:[PNCommonUtils fenToyuan:self.billDetailModel.realAmt.stringValue]
                                                                               currencyCode:self.billDetailModel.currency]];
    headerModel.incomeFlag = self.billDetailModel.incomeFlag;
    headerModel.amountStr = amountStr;
    headerModel.transType = self.billDetailModel.tradeType;
    headerModel.withdrawStatus = self.billDetailModel.withdrawStatus;
    headerModel.withdrawCode = self.billDetailModel.withdrawCode;
    headerModel.withdrawOverdueTime = self.billDetailModel.withdrawOverdueTime;
    self.headView.model = headerModel;

#pragma mark - 获取cell
    [self.dataSource removeAllObjects];

    if (self.billDetailModel.tradeType == PNTransTypeToPhone && self.billDetailModel.status == PNOrderStatusFailure) {
        [self emptyCell];
    } else {
        switch (self.billDetailModel.tradeType) {
            case PNTransTypeTransfer: //转账
                [self drawTransferDetailsByRspModel:self.billDetailModel];
                break;
            case PNTransTypeToPhone: // 转账手机号
                [self drawTransferToPhoneDetailsByRspModel:self.billDetailModel];
                break;
            case PNTransTypeExchange: //兑换
                [self drawExchangeDetailsByRspModel:self.billDetailModel];
                break;
            case PNTransTypeRecharge: //充值
                [self drawRechargeDetailsByRspModel:self.billDetailModel];
                break;
            case PNTransTypeWithdraw: //提现
                [self drawWithdrawDetailsByRspModel:self.billDetailModel];
                break;
            case PNTransTypeConsume: //消费
                [self drawConsumptionDetailsByRspModel:self.billDetailModel];
                break;
            case PNTransTypeCollect: //收款
                [self drawCollectDetailsByRspModel:self.billDetailModel];
                break;
            case PNTransTypeRefund: //退款
                [self drawRefundDetailsByRspModel:self.billDetailModel];
                break;
            case PNTransTypePinkPacket: //红包
                [self drawPinkPacketDetailsByRspModel:self.billDetailModel];
                break;
            case PNTransTypeRemuneration: //酬劳
                [self drawRemunerationDetailsByRspModel:self.billDetailModel];
                break;
            case PNTransTypeBlocked: //冻结扣款
                [self drawWithBlockedDetailsByRspModel:self.billDetailModel];
                break;
            case PNTransTypeAdjust: //调账
                [self drawWithAdjustDetailsByRspModel:self.billDetailModel];
                break;
            case PNTransTypeApartment: //缴费
                [self drawWithApartmentDetailsByRspModel:self.billDetailModel];
                break;
            case PNTransTypeDefault: //所有
                break;
        }
    }
    [self.tableView successGetNewDataWithNoMoreData:NO];
}

#pragma mark
/// MARK: 酬劳
- (void)drawRemunerationDetailsByRspModel:(HDUserBillDetailRspModel *)rspModel {
    PayOrderTableCellModel *cell = PayOrderTableCellModel.new;
    if (rspModel.payerUsrMp.length > 0) {
        cell.name = PNLocalizedString(@"TEXTFIELD_TITLE_PAYMENT_ACC_NO", @"付款账号");
        cell.value = [PNCommonUtils deSensitiveString:rspModel.payerUsrMp];
        [self.dataSource addObject:cell];
    }

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"PAGE_TEXT_PAYER", @"付款方");
    cell.value = [NSString stringWithFormat:@"%@", rspModel.payerUsrName];
    [self.dataSource addObject:cell];

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"PAGE_TEXT_PAYEE_ACCOUNT", @"收款账户");
    cell.value = [PNCommonUtils getAccountNameByCode:rspModel.currency];
    [self.dataSource addObject:cell];

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"PAGE_TEXT_BUSSINESS_TYPE", @"账单分类");
    cell.value = [PNCommonUtils getTradeTypeNameByCode:rspModel.tradeType];
    [self.dataSource addObject:cell];

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"PAGE_TEXT_CREATE_TIME", @"创建时间");
    cell.value = [PNCommonUtils getDateStrByFormat:@"dd/MM/yyyy HH:mm" withDate:[NSDate dateWithTimeIntervalSince1970:rspModel.createTime.floatValue / 1000]];
    [self.dataSource addObject:cell];

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"PAGE_TEXT_ORDERNO", @"订单号");
    cell.value = rspModel.tradeNo;
    [self.dataSource addObject:cell];

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"Remark", @"备注");
    cell.value = rspModel.body;
    [self.dataSource addObject:cell];
}

/// MARK: 红包
- (void)drawPinkPacketDetailsByRspModel:(HDUserBillDetailRspModel *)rspModel {
    PayOrderTableCellModel *cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"kwCIcL1x", @"金额");
    cell.value = [NSString stringWithFormat:@"%@", [PNCommonUtils thousandSeparatorAmount:[PNCommonUtils fenToyuan:rspModel.orderAmt.stringValue] currencyCode:rspModel.currency]];
    [self.dataSource addObject:cell];

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"PAGE_TEXT_BUSSINESS_TYPE", @"账单分类");
    cell.value = [PNCommonUtils getTradeTypeNameByCode:rspModel.tradeType];
    [self.dataSource addObject:cell];

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"PAGE_TEXT_CREATE_TIME", @"创建时间");
    cell.value = [PNCommonUtils getDateStrByFormat:@"dd/MM/yyyy HH:mm" withDate:[NSDate dateWithTimeIntervalSince1970:rspModel.createTime.floatValue / 1000]];
    [self.dataSource addObject:cell];

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"PAGE_TEXT_ORDERNO", @"订单号");
    cell.value = rspModel.tradeNo;
    [self.dataSource addObject:cell];
}

/// MARK: 退款
- (void)drawRefundDetailsByRspModel:(HDUserBillDetailRspModel *)rspModel {
    if (![rspModel.bizEntity.code isEqualToString:@"1050"]) {
        /// bakong 退款
        PayOrderTableCellModel *cell = PayOrderTableCellModel.new;
        cell.name = PNLocalizedString(@"pn_refund_amount", @"退款金额");
        cell.value = [NSString stringWithFormat:@"%@", [PNCommonUtils thousandSeparatorAmount:[PNCommonUtils fenToyuan:rspModel.orderAmt.stringValue] currencyCode:rspModel.currency]];
        [self.dataSource addObject:cell];

        cell = PayOrderTableCellModel.new;
        cell.name = PNLocalizedString(@"pn_receiver_account", @"收款账号");
        cell.value = [NSString stringWithFormat:@"%@", [PNCommonUtils deSensitiveString:rspModel.payeeUsrMp]];
        [self.dataSource addObject:cell];

        cell = PayOrderTableCellModel.new;
        cell.name = PNLocalizedString(@"PAGE_TEXT_PAYEE", @"收款方");
        cell.value = rspModel.payeeUsrName;
        [self.dataSource addObject:cell];

        if (WJIsStringNotEmpty(rspModel.receiveBankName)) {
            cell = PayOrderTableCellModel.new;
            cell.name = PNLocalizedString(@"pn_Receiving_bank", @"收款银行");
            cell.value = [NSString stringWithFormat:@"%@", WJIsStringNotEmpty(rspModel.receiveBankName) ? rspModel.receiveBankName : @""];
            [self.dataSource addObject:cell];
        }

        cell = PayOrderTableCellModel.new;
        cell.name = PNLocalizedString(@"PAGE_TEXT_CREATE_TIME", @"创建时间");
        cell.value = [PNCommonUtils getDateStrByFormat:@"dd/MM/yyyy HH:mm" withDate:[NSDate dateWithTimeIntervalSince1970:rspModel.createTime.floatValue / 1000]];
        [self.dataSource addObject:cell];

        cell = PayOrderTableCellModel.new;
        cell.name = PNLocalizedString(@"PAGE_TEXT_ORDERNO", @"订单号");
        cell.value = rspModel.tradeNo;
        [self.dataSource addObject:cell];

        if (rspModel.transactionHash.length > 0) {
            NSString *str = @"";
            if (rspModel.transactionHash.length > 8) {
                str = [rspModel.transactionHash substringToIndex:8];
            } else {
                str = rspModel.transactionHash;
            }
            cell = PayOrderTableCellModel.new;
            cell.name = PNLocalizedString(@"transaction_Hash", @"交易hash");
            cell.value = str;
            [self.dataSource addObject:cell];
        }

    } else {
        PayOrderTableCellModel *cell = PayOrderTableCellModel.new;
        cell.name = PNLocalizedString(@"TEXTFIELD_TITLE_PAYMENT_ACC_NO", @"付款账号");
        cell.value = [PNCommonUtils deSensitiveString:rspModel.payerUsrMp];
        [self.dataSource addObject:cell];

        cell = PayOrderTableCellModel.new;
        cell.name = PNLocalizedString(@"PAGE_TEXT_PAYER", @"付款方");
        cell.value = [NSString stringWithFormat:@"%@", rspModel.merName];
        [self.dataSource addObject:cell];

        cell = PayOrderTableCellModel.new;
        cell.name = PNLocalizedString(@"PAGE_TEXT_PAYEE_ACCOUNT", @"收款账户");
        cell.value = [PNCommonUtils getAccountNameByCode:rspModel.currency];
        [self.dataSource addObject:cell];

        cell = PayOrderTableCellModel.new;
        cell.name = PNLocalizedString(@"PAGE_TEXT_BUSSINESS_TYPE", @"账单分类");
        cell.value = [PNCommonUtils getTradeTypeNameByCode:rspModel.tradeType];
        [self.dataSource addObject:cell];

        cell = PayOrderTableCellModel.new;
        cell.name = PNLocalizedString(@"PAGE_TEXT_CREATE_TIME", @"创建时间");
        cell.value = [PNCommonUtils getDateStrByFormat:@"dd/MM/yyyy HH:mm" withDate:[NSDate dateWithTimeIntervalSince1970:rspModel.createTime.floatValue / 1000]];
        [self.dataSource addObject:cell];

        cell = PayOrderTableCellModel.new;
        cell.name = PNLocalizedString(@"PAGE_TEXT_ORDERNO", @"订单号");
        cell.value = rspModel.tradeNo;
        [self.dataSource addObject:cell];
    }
}

/// MARK: 收款
- (void)drawCollectDetailsByRspModel:(HDUserBillDetailRspModel *)rspModel {
    PayOrderTableCellModel *cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"TEXTFIELD_TITLE_PAYMENT_ACC_NO", @"付款账号");
    cell.value = [PNCommonUtils deSensitiveString:rspModel.payerUsrMp];
    [self.dataSource addObject:cell];

    if (rspModel.receiveBankName.length > 0) {
        cell = PayOrderTableCellModel.new;
        cell.name = PNLocalizedString(@"pn_Receiving_bank", @"收款银行");
        cell.value = [NSString stringWithFormat:@"%@", WJIsStringNotEmpty(rspModel.receiveBankName) ? rspModel.receiveBankName : @""];
        [self.dataSource addObject:cell];
    }

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"PAGE_TEXT_PAYER", @"付款方");
    cell.value = [NSString stringWithFormat:@"%@ %@", rspModel.payerRealNameFirst, rspModel.payerRealNameEnd];
    [self.dataSource addObject:cell];

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"PAGE_TEXT_PAYEE_ACCOUNT", @"收款账户");
    cell.value = [PNCommonUtils getAccountNameByCode:rspModel.currency];
    [self.dataSource addObject:cell];

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"PAGE_TEXT_BUSSINESS_TYPE", @"账单分类");
    cell.value = [PNCommonUtils getTradeTypeNameByCode:rspModel.tradeType];
    [self.dataSource addObject:cell];

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"PAGE_TEXT_CREATE_TIME", @"创建时间");
    cell.value = [PNCommonUtils getDateStrByFormat:@"dd/MM/yyyy HH:mm" withDate:[NSDate dateWithTimeIntervalSince1970:rspModel.createTime.floatValue / 1000]];
    [self.dataSource addObject:cell];

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"PAGE_TEXT_ORDERNO", @"订单号");
    cell.value = rspModel.tradeNo;
    [self.dataSource addObject:cell];
}

/// MARK: 提现
- (void)drawWithdrawDetailsByRspModel:(HDUserBillDetailRspModel *)rspModel {
    PayOrderTableCellModel *cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"PAGE_TEXT_WITHDRAW_AMOUNT", @"出金金额");
    cell.value = [NSString
        stringWithFormat:@"%@", [NSString stringWithFormat:@"%@", [PNCommonUtils thousandSeparatorAmount:[PNCommonUtils fenToyuan:rspModel.orderAmt.stringValue] currencyCode:rspModel.currency]]];
    [self.dataSource addObject:cell];

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"PAGE_TEXT_FEE", @"手续费");
    cell.value = [PNCommonUtils thousandSeparatorAmount:[PNCommonUtils fenToyuan:rspModel.serviceAmt.stringValue] currencyCode:rspModel.currency];
    [self.dataSource addObject:cell];

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"pn_Withdrawal_account", @"提现账户");
    cell.value = [PNCommonUtils getAccountNameByCode:rspModel.currency];
    [self.dataSource addObject:cell];

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"PAGE_TEXT_BUSSINESS_TYPE", @"账单分类");
    cell.value = [PNCommonUtils getTradeTypeNameByCode:rspModel.tradeType];
    [self.dataSource addObject:cell];

    //    cell = PayOrderTableCellModel.new;
    //    cell.name = PNLocalizedString(@"PAGE_TEXT_WITHDRAW_CHANNEL", @"提现渠道");
    //    cell.value = rspModel.channelCode;
    //    [self.dataSource addObject:cell];

    //    cell = PayOrderTableCellModel.new;
    //    cell.name = PNLocalizedString(@"PAGE_TEXT_WITHDRAW_STATION", @"提现网点");
    //    cell.value = rspModel.address;
    //    [self.dataSource addObject:cell];

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"PAGE_TEXT_CREATE_TIME", @"创建时间");

    cell.value = [PNCommonUtils getDateStrByFormat:@"dd/MM/yyyy HH:mm" withDate:[NSDate dateWithTimeIntervalSince1970:rspModel.createTime.floatValue / 1000]];
    [self.dataSource addObject:cell];

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"PAGE_TEXT_ORDERNO", @"订单号");
    cell.value = rspModel.tradeNo;
    [self.dataSource addObject:cell];

    if (rspModel.purpose.length > 0) {
        cell = PayOrderTableCellModel.new;
        cell.name = PNLocalizedString(@"Remark", @"备注");
        cell.value = rspModel.purpose;
        [self.dataSource addObject:cell];
    }
}

/// MARK: 充值
- (void)drawRechargeDetailsByRspModel:(HDUserBillDetailRspModel *)rspModel {
    PayOrderTableCellModel *cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"PAGE_TEXT_ORDER_AMOUNT", @"订单金额");
    cell.value = [NSString
        stringWithFormat:@"%@", [NSString stringWithFormat:@"%@", [PNCommonUtils thousandSeparatorAmount:[PNCommonUtils fenToyuan:rspModel.orderAmt.stringValue] currencyCode:rspModel.currency]]];
    [self.dataSource addObject:cell];

    if (![rspModel.discount isEqualToNumber:[NSNumber numberWithInt:0]]) {
        cell = PayOrderTableCellModel.new;
        cell.name = PNLocalizedString(@"PAGE_TEXT_DISCOUNT_AMOUNT", @"折扣金额");
        cell.value = [NSString
            stringWithFormat:@"%@", [NSString stringWithFormat:@"%@", [PNCommonUtils thousandSeparatorAmount:[PNCommonUtils fenToyuan:rspModel.discount.stringValue] currencyCode:rspModel.currency]]];
        [self.dataSource addObject:cell];
    }

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"order_detail_cashin_account", @"入金账户");
    cell.value = [PNCommonUtils getAccountNameByCode:rspModel.currency];
    [self.dataSource addObject:cell];

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"PAGE_TEXT_BUSSINESS_TYPE", @"账单分类");
    cell.value = [PNCommonUtils getTradeTypeNameByCode:rspModel.tradeType];
    [self.dataSource addObject:cell];

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"order_detail_cashin_channel", @"入金渠道");
    cell.value = rspModel.channelCode;
    [self.dataSource addObject:cell];

    if (WJIsStringNotEmpty(rspModel.address)) {
        cell = PayOrderTableCellModel.new;
        cell.name = PNLocalizedString(@"PAGE_TEXT_OFFLINE_STATION", @"充值网点");
        cell.value = rspModel.address;
        [self.dataSource addObject:cell];
    }

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"order_detail_cashin_time", @"入金时间");
    cell.value = [PNCommonUtils getDateStrByFormat:@"dd/MM/yyyy HH:mm" withDate:[NSDate dateWithTimeIntervalSince1970:rspModel.createTime.floatValue / 1000]];
    [self.dataSource addObject:cell];

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"PAGE_TEXT_ORDERNO", @"订单号");
    cell.value = rspModel.tradeNo;
    [self.dataSource addObject:cell];

    if (rspModel.purpose.length > 0) {
        cell = PayOrderTableCellModel.new;
        cell.name = PNLocalizedString(@"Remark", @"备注");
        cell.value = rspModel.purpose;
        [self.dataSource addObject:cell];
    }

    if (rspModel.transactionHash.length > 0) {
        NSString *str = @"";
        if (rspModel.transactionHash.length > 8) {
            str = [rspModel.transactionHash substringToIndex:8];
        } else {
            str = rspModel.transactionHash;
        }
        cell = PayOrderTableCellModel.new;
        cell.name = PNLocalizedString(@"transaction_Hash", @"交易hash");
        cell.value = str;
        [self.dataSource addObject:cell];
    }
}

/// MARK: 转账
- (void)drawTransferDetailsByRspModel:(HDUserBillDetailRspModel *)rspModel {
    PayOrderTableCellModel *cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"PAGE_TEXT_ORDER_AMOUNT", @"订单金额");
    cell.value = [NSString stringWithFormat:@"%@", [PNCommonUtils thousandSeparatorAmount:[PNCommonUtils fenToyuan:rspModel.orderAmt.stringValue] currencyCode:rspModel.currency]];
    [self.dataSource addObject:cell];

    if (rspModel.serviceAmt.doubleValue > 0) {
        cell = PayOrderTableCellModel.new;
        cell.name = PNLocalizedString(@"PAGE_TEXT_FEE", @"手续费");
        cell.value = [NSString stringWithFormat:@"%@", [PNCommonUtils thousandSeparatorAmount:[PNCommonUtils fenToyuan:rspModel.serviceAmt.stringValue] currencyCode:rspModel.currency]];
        [self.dataSource addObject:cell];
    }

    if (WJIsStringEmpty(rspModel.bizEntity.code) || [rspModel.bizEntity.code isEqualToString:PNTransferTypeToCoolcash] || [rspModel.bizEntity.code isEqualToString:PNTransferTypePersonalToBaKong] ||
        [rspModel.bizEntity.code isEqualToString:PNTransferTypePersonalToBank] || [rspModel.bizEntity.code isEqualToString:PNTransferTypePersonalScanQRToBakong]) {
        /// 订单金额手续费
        cell = PayOrderTableCellModel.new;
        cell.name = PNLocalizedString(@"PAGE_TEXT_FEE", @"手续费");
        NSString *str = @"";
        if ([rspModel.orderFeeAmt.cy isEqualToString:PNCurrencyTypeKHR]) {
            str = [NSString stringWithFormat:@"%@0", rspModel.orderFeeAmt.currencySymbol];
        } else {
            str = [NSString stringWithFormat:@"%@0.00", rspModel.orderFeeAmt.currencySymbol];
        }
        cell.value = rspModel.orderFeeAmt.thousandSeparatorAmount.length > 0 ? rspModel.orderFeeAmt.thousandSeparatorAmount : str;
        [self.dataSource addObject:cell];

        /// 活动减免 discountFeeAmt
        if (rspModel.discountFeeAmt.cent.integerValue > 0) {
            cell = PayOrderTableCellModel.new;
            cell.name = PNLocalizedString(@"Fee_free", @"活动减免");
            cell.value = [NSString stringWithFormat:@"-%@", rspModel.discountFeeAmt.thousandSeparatorAmount];
            [self.dataSource addObject:cell];
        }
    }

    if (self.type != resultPage) {
        cell = PayOrderTableCellModel.new;
        cell.name = PNLocalizedString(@"PAGE_TEXT_PAYER_ACCOUNT", @"付款账户");
        cell.value = [PNCommonUtils getAccountNameByCode:rspModel.currency];
        [self.dataSource addObject:cell];
    }

    if (rspModel.receiveBankName.length > 0) {
        cell = PayOrderTableCellModel.new;
        cell.name = PNLocalizedString(@"pn_Receiving_bank", @"收款银行");
        cell.value = [NSString stringWithFormat:@"%@", WJIsStringNotEmpty(rspModel.receiveBankName) ? rspModel.receiveBankName : @""];
        [self.dataSource addObject:cell];
    } else {
        if (self.type == resultPage && [rspModel.bizEntity.code isEqualToString:PNTransferTypePersonalToBaKong]) {
            rspModel.receiveBankName = @"Cool Cash";
            cell = PayOrderTableCellModel.new;
            cell.name = PNLocalizedString(@"pn_Receiving_bank", @"收款银行");
            cell.value = [NSString stringWithFormat:@"%@", WJIsStringNotEmpty(rspModel.receiveBankName) ? rspModel.receiveBankName : @""];
            [self.dataSource addObject:cell];
        }
    }

    if (rspModel.payeeUsrMp.length > 0) {
        cell = PayOrderTableCellModel.new;
        cell.name = PNLocalizedString(@"pn_receiver_account", @"收款账号");
        cell.value = [NSString stringWithFormat:@"%@", [PNCommonUtils deSensitiveString:rspModel.payeeUsrMp]];
        [self.dataSource addObject:cell];
    }

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"PAGE_TEXT_PAYEE", @"收款方");
    cell.value = [NSString stringWithFormat:@"%@ %@", rspModel.realNameFirst.length > 0 ? rspModel.realNameFirst : @"", rspModel.realNameEnd.length > 0 ? rspModel.realNameEnd : @""];
    [self.dataSource addObject:cell];

    if (self.type != resultPage) {
        cell = PayOrderTableCellModel.new;
        cell.name = PNLocalizedString(@"PAGE_TEXT_BUSSINESS_TYPE", @"账单分类");
        cell.value = [PNCommonUtils getTradeTypeNameByCode:rspModel.tradeType];
        [self.dataSource addObject:cell];
    }

    if (rspModel.purpose.length > 0) {
        cell = PayOrderTableCellModel.new;
        cell.name = PNLocalizedString(@"Remark", @"备注");
        cell.value = rspModel.purpose;
        [self.dataSource addObject:cell];
    }

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"PAGE_TEXT_CREATE_TIME", @"创建时间");
    cell.value = [PNCommonUtils getDateStrByFormat:@"dd/MM/yyyy HH:mm" withDate:[NSDate dateWithTimeIntervalSince1970:rspModel.createTime.floatValue / 1000]];
    [self.dataSource addObject:cell];

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"PAGE_TEXT_ORDERNO", @"订单号");
    cell.value = rspModel.tradeNo;
    [self.dataSource addObject:cell];

    if (rspModel.transactionHash.length > 0) {
        NSString *str = @"";
        if (rspModel.transactionHash.length > 8) {
            str = [rspModel.transactionHash substringToIndex:8];
        } else {
            str = rspModel.transactionHash;
        }
        cell = PayOrderTableCellModel.new;
        cell.name = PNLocalizedString(@"transaction_Hash", @"交易hash");
        cell.value = str;
        [self.dataSource addObject:cell];
    }
    if (rspModel.payeeStoreName.length > 0) {
        cell = PayOrderTableCellModel.new;
        cell.name = PNLocalizedString(@"Collection_shop", @"收款店铺");
        cell.value = rspModel.payeeStoreName;
        [self.dataSource addObject:cell];
    }

    if (rspModel.payeeStoreName.length > 0) {
        cell = PayOrderTableCellModel.new;
        cell.name = PNLocalizedString(@"location", @"定位");
        cell.value = rspModel.payeeStoreLocation;
        [self.dataSource addObject:cell];
    }
}

/// MARK: 转账 - 手机号
- (void)drawTransferToPhoneDetailsByRspModel:(HDUserBillDetailRspModel *)rspModel {
    PayOrderTableCellModel *cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"transfer_amount", @"转账金额");
    cell.value = [NSString stringWithFormat:@"%@", [PNCommonUtils thousandSeparatorAmount:[PNCommonUtils fenToyuan:rspModel.orderAmt.stringValue] currencyCode:rspModel.currency]];
    [self.dataSource addObject:cell];

    if (rspModel.serviceAmt.doubleValue > 0) {
        cell = PayOrderTableCellModel.new;
        cell.name = PNLocalizedString(@"PAGE_TEXT_FEE", @"手续费");
        cell.value = [NSString stringWithFormat:@"%@", [PNCommonUtils thousandSeparatorAmount:[PNCommonUtils fenToyuan:rspModel.serviceAmt.stringValue] currencyCode:rspModel.currency]];
        [self.dataSource addObject:cell];
    }

    /// 订单金额手续费
    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"PAGE_TEXT_FEE", @"手续费");
    NSString *str = @"";
    if ([rspModel.orderFeeAmt.cy isEqualToString:PNCurrencyTypeKHR]) {
        str = [NSString stringWithFormat:@"%@0", rspModel.orderFeeAmt.currencySymbol];
    } else {
        str = [NSString stringWithFormat:@"%@0.00", rspModel.orderFeeAmt.currencySymbol];
    }
    cell.value = rspModel.orderFeeAmt.thousandSeparatorAmount.length > 0 ? rspModel.orderFeeAmt.thousandSeparatorAmount : str;
    [self.dataSource addObject:cell];

    /// 活动减免 discountFeeAmt
    if (rspModel.discountFeeAmt.cent.integerValue > 0) {
        cell = PayOrderTableCellModel.new;
        cell.name = PNLocalizedString(@"Fee_free", @"活动减免");
        cell.value = [NSString stringWithFormat:@"-%@", rspModel.discountFeeAmt.thousandSeparatorAmount];
        [self.dataSource addObject:cell];
    }

    if (self.type != resultPage) {
        cell = PayOrderTableCellModel.new;
        cell.name = PNLocalizedString(@"PAGE_TEXT_PAYER_ACCOUNT", @"付款账户");
        cell.value = [PNCommonUtils getAccountNameByCode:rspModel.currency];
        [self.dataSource addObject:cell];
    }

    if (rspModel.payeeUsrMp.length > 0) {
        cell = PayOrderTableCellModel.new;
        cell.name = PNLocalizedString(@"receive_phone", @"收款手机号");
        cell.value = rspModel.payeeUsrMp;
        [self.dataSource addObject:cell];
    }

    if (self.type != resultPage) {
        cell = PayOrderTableCellModel.new;
        cell.name = PNLocalizedString(@"PAGE_TEXT_BUSSINESS_TYPE", @"账单分类");
        cell.value = [PNCommonUtils getTradeTypeNameByCode:rspModel.tradeType];
        [self.dataSource addObject:cell];
    }

    if (rspModel.purpose.length > 0) {
        cell = PayOrderTableCellModel.new;
        cell.name = PNLocalizedString(@"Remark", @"备注");
        cell.value = rspModel.purpose;
        [self.dataSource addObject:cell];
    }

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"PAGE_TEXT_CREATE_TIME", @"创建时间");
    cell.value = [PNCommonUtils getDateStrByFormat:@"dd/MM/yyyy HH:mm" withDate:[NSDate dateWithTimeIntervalSince1970:rspModel.createTime.floatValue / 1000]];
    [self.dataSource addObject:cell];

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"PAGE_TEXT_ORDERNO", @"订单号");
    cell.value = rspModel.tradeNo;
    [self.dataSource addObject:cell];

    if (rspModel.transactionHash.length > 0) {
        NSString *str = @"";
        if (rspModel.transactionHash.length > 8) {
            str = [rspModel.transactionHash substringToIndex:8];
        } else {
            str = rspModel.transactionHash;
        }
        cell = PayOrderTableCellModel.new;
        cell.name = PNLocalizedString(@"transaction_Hash", @"交易hash");
        cell.value = str;
        [self.dataSource addObject:cell];
    }
}

/// MARK: 消费
- (void)drawConsumptionDetailsByRspModel:(HDUserBillDetailRspModel *)rspModel {
    PayOrderTableCellModel *cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"PAGE_TEXT_ORDER_AMOUNT", @"订单金额");
    cell.value = [NSString stringWithFormat:@"%@", [PNCommonUtils thousandSeparatorAmount:[PNCommonUtils fenToyuan:rspModel.orderAmt.stringValue] currencyCode:rspModel.currency]];
    [self.dataSource addObject:cell];

    if (WJIsStringEmpty(rspModel.sceneId)) {
        cell = PayOrderTableCellModel.new;
        cell.name = PNLocalizedString(@"PAGE_TEXT_PAYEE", @"收款方");
        cell.value = rspModel.payeeUsrName;
        [self.dataSource addObject:cell];
    }

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"PAGE_TEXT_BUSSINESS_TYPE", @"账单分类");
    cell.value = [PNCommonUtils getTradeTypeNameByCode:rspModel.tradeType];
    [self.dataSource addObject:cell];

    if (rspModel.purpose.length > 0) {
        cell = PayOrderTableCellModel.new;
        cell.name = PNLocalizedString(@"Remark", @"备注");
        cell.value = rspModel.purpose;
        [self.dataSource addObject:cell];
    }

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"PAGE_TEXT_CREATE_TIME", @"创建时间");
    cell.value = [PNCommonUtils getDateStrByFormat:@"dd/MM/yyyy HH:mm" withDate:[NSDate dateWithTimeIntervalSince1970:rspModel.createTime.floatValue / 1000]];
    [self.dataSource addObject:cell];

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"PAGE_TEXT_ORDERNO", @"订单号");
    cell.value = rspModel.tradeNo;
    [self.dataSource addObject:cell];

    if (rspModel.transactionHash.length > 0) {
        NSString *str = @"";
        if (rspModel.transactionHash.length > 8) {
            str = [rspModel.transactionHash substringToIndex:8];
        } else {
            str = rspModel.transactionHash;
        }
        cell = PayOrderTableCellModel.new;
        cell.name = PNLocalizedString(@"transaction_Hash", @"交易hash");
        cell.value = str;
        [self.dataSource addObject:cell];
    }
    if (rspModel.payeeStoreName.length > 0) {
        cell = PayOrderTableCellModel.new;
        cell.name = PNLocalizedString(@"Collection_shop", @"收款店铺");
        cell.value = rspModel.payeeStoreName;
        [self.dataSource addObject:cell];
    }

    if (rspModel.payeeStoreName.length > 0) {
        cell = PayOrderTableCellModel.new;
        cell.name = PNLocalizedString(@"location", @"定位");
        cell.value = rspModel.payeeStoreLocation;
        [self.dataSource addObject:cell];
    }

    if (WJIsStringNotEmpty(rspModel.sceneId)) {
        if (WJIsStringNotEmpty(rspModel.sceneMerNo)) {
            cell = PayOrderTableCellModel.new;
            cell.name = PNLocalizedString(@"pn_merchant_id_2", @"商户号");
            cell.value = rspModel.sceneMerNo;
            [self.dataSource addObject:cell];
        }

        if (WJIsStringNotEmpty(rspModel.merName)) {
            cell = PayOrderTableCellModel.new;
            cell.name = PNLocalizedString(@"agent_name", @"商户名称");
            cell.value = rspModel.merName;
            [self.dataSource addObject:cell];
        }

        if (WJIsStringNotEmpty(rspModel.sceneStoreName)) {
            cell = PayOrderTableCellModel.new;
            cell.name = PNLocalizedString(@"pn_store_name", @"门店名称");
            cell.value = rspModel.sceneStoreName;
            [self.dataSource addObject:cell];
        }

        if (WJIsStringNotEmpty(rspModel.sceneOperaName)) {
            cell = PayOrderTableCellModel.new;
            cell.name = PNLocalizedString(@"pn_ms_store_staff", @"门店店员");
            cell.value = rspModel.sceneOperaName;
            [self.dataSource addObject:cell];
        }
    }
}

/// MARK: 兑换
- (void)drawExchangeDetailsByRspModel:(HDUserBillDetailRspModel *)rspModel {
    PayOrderTableCellModel *cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"PAGE_TEXT_ORDER_AMOUNT", @"订单金额");
    cell.value = [NSString stringWithFormat:@"%@(%@)",
                                            [PNCommonUtils thousandSeparatorAmount:[PNCommonUtils fenToyuan:rspModel.orderAmt.stringValue] currencyCode:rspModel.currency],
                                            [PNCommonUtils thousandSeparatorAmount:[PNCommonUtils fenToyuan:rspModel.payeeAmt] currencyCode:rspModel.payeeCy]];
    [self.dataSource addObject:cell];

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"TEXT_EXCHANGE_RATE", @"汇率");
    cell.value = [NSString stringWithFormat:@"%@ = %@",
                                            [PNCommonUtils thousandSeparatorAmount:@"1" currencyCode:PNCurrencyTypeUSD],
                                            [PNCommonUtils thousandSeparatorAmount:[rspModel.exchangeRate stringValue] currencyCode:PNCurrencyTypeKHR]];
    [self.dataSource addObject:cell];

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"PAGE_TEXT_BUSSINESS_TYPE", @"账单分类");
    cell.value = [PNCommonUtils getTradeTypeNameByCode:rspModel.tradeType];
    [self.dataSource addObject:cell];

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"PAGE_TEXT_CREATE_TIME", @"创建时间");
    cell.value = [PNCommonUtils getDateStrByFormat:@"dd/MM/yyyy HH:mm" withDate:[NSDate dateWithTimeIntervalSince1970:rspModel.createTime.floatValue / 1000]];
    [self.dataSource addObject:cell];

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"PAGE_TEXT_ORDERNO", @"订单号");
    cell.value = rspModel.tradeNo;
    [self.dataSource addObject:cell];
}

/// MARK: 冻结扣款
- (void)drawWithBlockedDetailsByRspModel:(HDUserBillDetailRspModel *)rspModel {
    PayOrderTableCellModel *cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"Deduct_amount", @"扣款金额");
    cell.value = [NSString
        stringWithFormat:@"%@", [NSString stringWithFormat:@"%@", [PNCommonUtils thousandSeparatorAmount:[PNCommonUtils fenToyuan:rspModel.orderAmt.stringValue] currencyCode:rspModel.currency]]];
    [self.dataSource addObject:cell];

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"Deduct_account", @"扣款账户");
    cell.value = [PNCommonUtils getAccountNameByCode:rspModel.currency];
    [self.dataSource addObject:cell];

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"Serial_number", @"流水号");
    cell.value = rspModel.tradeNo;
    [self.dataSource addObject:cell];

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"Deduct_time", @"扣款时间");
    cell.value = [PNCommonUtils getDateStrByFormat:@"dd/MM/yyyy HH:mm" withDate:[NSDate dateWithTimeIntervalSince1970:rspModel.createTime.floatValue / 1000]];
    [self.dataSource addObject:cell];

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"Deduct_reason", @"扣款原因");
    cell.value = rspModel.purpose;
    [self.dataSource addObject:cell];
}

/// MARK: 调账
- (void)drawWithAdjustDetailsByRspModel:(HDUserBillDetailRspModel *)rspModel {
    PayOrderTableCellModel *cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"Adjust_amount", @"调账金额");
    cell.value = [NSString
        stringWithFormat:@"%@", [NSString stringWithFormat:@"%@", [PNCommonUtils thousandSeparatorAmount:[PNCommonUtils fenToyuan:rspModel.orderAmt.stringValue] currencyCode:rspModel.currency]]];
    [self.dataSource addObject:cell];

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"Adjust_account", @"调账账户");
    cell.value = [PNCommonUtils getAccountNameByCode:rspModel.currency];
    [self.dataSource addObject:cell];

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"Serial_number", @"流水号");
    cell.value = rspModel.tradeNo;
    [self.dataSource addObject:cell];

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"Adjust_time", @"调账时间");
    cell.value = [PNCommonUtils getDateStrByFormat:@"dd/MM/yyyy HH:mm" withDate:[NSDate dateWithTimeIntervalSince1970:rspModel.createTime.floatValue / 1000]];
    [self.dataSource addObject:cell];

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"Adjust_reason", @"调账原因");
    cell.value = rspModel.purpose;
    [self.dataSource addObject:cell];
}

/// MARK: 缴费
- (void)drawWithApartmentDetailsByRspModel:(HDUserBillDetailRspModel *)rspModel {
    PayOrderTableCellModel *cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"PAGE_TEXT_ORDER_AMOUNT", @"订单金额");
    cell.value = [NSString stringWithFormat:@"%@", [PNCommonUtils thousandSeparatorAmount:[PNCommonUtils fenToyuan:rspModel.orderAmt.stringValue] currencyCode:rspModel.currency]];
    [self.dataSource addObject:cell];

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"TEXTFIELD_TITLE_PAYMENT_ACC_NO", @"付款账号");
    cell.value = [PNCommonUtils deSensitiveString:rspModel.payerUsrMp];
    [self.dataSource addObject:cell];

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"pn_receiver_account", @"收款账号");
    cell.value = [PNCommonUtils deSensitiveString:rspModel.payeeUsrNo];
    [self.dataSource addObject:cell];


    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"PAGE_TEXT_BUSSINESS_TYPE", @"账单分类");
    cell.value = [PNCommonUtils getTradeTypeNameByCode:rspModel.tradeType];
    [self.dataSource addObject:cell];

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"PAGE_TEXT_CREATE_TIME", @"创建时间");
    cell.value = [PNCommonUtils getDateStrByFormat:@"dd/MM/yyyy HH:mm" withDate:[NSDate dateWithTimeIntervalSince1970:rspModel.createTime.floatValue / 1000]];
    [self.dataSource addObject:cell];

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"PAGE_TEXT_ORDERNO", @"订单号");
    cell.value = rspModel.tradeNo;
    [self.dataSource addObject:cell];

    cell = PayOrderTableCellModel.new;
    cell.name = PNLocalizedString(@"pn_complete_time", @"完成时间");
    cell.value = [PNCommonUtils getDateStrByFormat:@"dd/MM/yyyy HH:mm" withDate:[NSDate dateWithTimeIntervalSince1970:rspModel.tmFinished.floatValue / 1000]];
    [self.dataSource addObject:cell];


    if (rspModel.purpose.length > 0) {
        cell = PayOrderTableCellModel.new;
        cell.name = PNLocalizedString(@"Remark", @"备注");
        cell.value = rspModel.purpose;
        [self.dataSource addObject:cell];
    }
}

/// MARK: 空白
- (void)emptyCell {
    PayOrderTableCellModel *cell = PayOrderTableCellModel.new;
    [self.dataSource addObject:cell];

    self.tableView.tableFooterView = self.footFailView;
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

// 开启定时器
- (void)startQueryOrderStatusTimerWithDrawCode {
    // 全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    // 创建一个 timer 类型定时器
    if (!_querWithDrawCodeTimer) {
        _querWithDrawCodeTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    }
    // 设置定时器的各种属性（何时开始，间隔多久执行）
    dispatch_source_set_timer(_querWithDrawCodeTimer, DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC, 0);
    // 任务回调
    dispatch_source_set_event_handler(_querWithDrawCodeTimer, ^{
        // 查询结果
        HDLog(@"开始 提现码查询");
        [self querWithDrawCode];
    });
    // 开始定时器任务（定时器默认开始是暂停的，需要复位开启）
    if (_querWithDrawCodeTimer && !_isTimerRunningQuerWithDrawCode) {
        dispatch_resume(_querWithDrawCodeTimer);
        _isTimerRunningQuerWithDrawCode = YES;
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
#pragma mark - HDViewControllerNavigationBarStyle
- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    if (self.type == resultPage) {
        return HDViewControllerNavigationBarStyleHidden;
    }
    return HDViewControllerNavigationBarStyleWhite;
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
    PayOrderTableCellModel *model = self.dataSource[indexPath.row];
    PayOrderTableCell *cell = [PayOrderTableCell cellWithTableView:tableView];
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

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.billDetailModel.status == PNOrderStatusFailure && self.billDetailModel.tradeType == PNTransTypeToPhone) {
        return self.footFailView;
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

- (PNOrderResultFailView *)footFailView {
    if (!_footFailView) {
        _footFailView = [[PNOrderResultFailView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    }
    return _footFailView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

- (PNTransListDTO *)transDTO {
    if (!_transDTO) {
        _transDTO = [[PNTransListDTO alloc] init];
    }
    return _transDTO;
}
@end
