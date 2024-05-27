//
//  PNPaymentOrderDetailsViewModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/4/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPaymentOrderDetailsViewModel.h"
#import "HDTableHeaderFootViewModel.h"
#import "HDTableViewSectionModel.h"
#import "PNCommonUtils.h"
#import "PNRspModel.h"
#import "PNWaterBillModel.h"
#import "PNWaterDTO.h"
#import "SAInfoViewModel.h"
#import "SAOrderDTO.h"
#import "SAQueryOrderDetailsRspModel.h"


@interface PNPaymentOrderDetailsViewModel ()
@property (nonatomic, strong) PNWaterDTO *waterDTO;
@property (nonatomic, strong) SAOrderDTO *saOrderDTO;
@property (nonatomic, strong) SAQueryOrderDetailsRspModel *saOrderDetailsRspModel;
@end


@implementation PNPaymentOrderDetailsViewModel

/// 查询账单详情
- (void)queryBillDetail {
    [self.view showloading];
    @HDWeakify(self);

    dispatch_group_t taskGroup = dispatch_group_create();

    dispatch_group_enter(taskGroup);

    [self.waterDTO queryBillDetailWithOrderNo:self.orderNo tradeNo:self.tradeNo success:^(PNRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.billModel = [PNWaterBillModel yy_modelWithJSON:rspModel.data];
        dispatch_group_leave(taskGroup);
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        dispatch_group_leave(taskGroup);
    }];

    if (HDIsStringNotEmpty(self.orderNo)) {
        dispatch_group_enter(taskGroup);

        [self.saOrderDTO queryOrderDetailsWithOrderNo:self.orderNo success:^(SAQueryOrderDetailsRspModel *_Nonnull rspModel) {
            @HDStrongify(self);
            dispatch_group_leave(taskGroup);
            self.saOrderDetailsRspModel = rspModel;
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            dispatch_group_leave(taskGroup);
        }];
    }

    dispatch_group_notify(taskGroup, dispatch_get_main_queue(), ^{
        @HDStrongify(self);
        [self.view dismissLoading];

        [self generData];
        self.refreshFlag = !self.refreshFlag;
    });
}

/// 关闭业务账单订单
- (void)closePaymentOrder {
    [self.view showloading];
    @HDWeakify(self);
    [self.waterDTO closePaymentOrderWithOrderNo:self.orderNo success:^(PNRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self queryBillDetail];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

- (void)generData {
    [self.dataSourceArray removeAllObjects];

    PNBalancesInfoModel *balancesInfoModel = self.billModel.balances.firstObject;

    /// biller_info
    HDTableViewSectionModel *section = HDTableViewSectionModel.new;
    NSMutableArray *listArray = [NSMutableArray array];
    HDTableHeaderFootViewModel *header = HDTableHeaderFootViewModel.new;

    header.title = PNLocalizedString(@"biller_info", @"biller_info");

    SAInfoViewModel *model = SAInfoViewModel.new;
    model.keyText = [NSString stringWithFormat:@"%@:", PNLocalizedString(@"bill_type", @"bill type")];
    model.valueText = balancesInfoModel.paymentCategoryName;
    [listArray addObject:model];

    model = SAInfoViewModel.new;
    model.keyText = PNLocalizedString(@"pay_to", @"pay to");
    model.valueText = self.billModel.supplier.name;
    [listArray addObject:model];

    if (HDIsStringNotEmpty(balancesInfoModel.billItmeName)) {
        model = SAInfoViewModel.new;
        model.keyText = [NSString stringWithFormat:@"%@:", PNLocalizedString(@"pn_items", @"产品类目")];
        model.valueText = balancesInfoModel.billItmeName;
        [listArray addObject:model];

        section.list = listArray;
        section.headerModel = header;
        [self.dataSourceArray addObject:section];
    } else {
        model = SAInfoViewModel.new;
        model.keyText = [NSString stringWithFormat:@"%@:", PNLocalizedString(@"bill_code", @"bill code")];
        model.valueText = self.billModel.supplier.code;
        [listArray addObject:model];

        section.list = listArray;
        section.headerModel = header;
        [self.dataSourceArray addObject:section];
    }

    /// customer_info

    section = HDTableViewSectionModel.new;
    listArray = [NSMutableArray array];
    header = HDTableHeaderFootViewModel.new;

    if (!HDIsObjectNil(self.billModel.cardPasswordEntertainmentRespDTO)) {
        if (self.billModel.cardPasswordEntertainmentRespDTO.group == 10) {
            // PINBase账单 卡密信息
            header.title = PNLocalizedString(@"pn_pincode_info", @"卡密信息");

            model = SAInfoViewModel.new;
            model.keyText = PNLocalizedString(@"pn_pincode", @"卡密");
            model.valueText = self.billModel.cardPasswordEntertainmentRespDTO.customerName;
            [listArray addObject:model];

            model = SAInfoViewModel.new;
            model.keyText = PNLocalizedString(@"pn_ref_number", @"支付流水号");
            model.valueText = self.billModel.cardPasswordEntertainmentRespDTO.refNo;
            [listArray addObject:model];
        } else if (self.billModel.cardPasswordEntertainmentRespDTO.group == 11) {
            // PINLESS账单 账号信息
            header.title = PNLocalizedString(@"pn_account_info", @"账号信息");

            model = SAInfoViewModel.new;
            model.keyText = PNLocalizedString(@"pn_customer_name", @"客户名称");
            model.valueText = self.billModel.cardPasswordEntertainmentRespDTO.customerName;
            [listArray addObject:model];

            model = SAInfoViewModel.new;
            model.keyText = PNLocalizedString(@"pn_zone", @"区域");
            model.valueText = self.billModel.cardPasswordEntertainmentRespDTO.zoneId;
            [listArray addObject:model];

            model = SAInfoViewModel.new;
            model.keyText = PNLocalizedString(@"pn_ref_number", @"支付流水号");
            model.valueText = self.billModel.cardPasswordEntertainmentRespDTO.refNo;
            [listArray addObject:model];
        }

    } else {
        //用户信息
        header.title = PNLocalizedString(@"customer_info", @"Customer Info");

        model = SAInfoViewModel.new;
        NSString *norStr = @"";
        if (balancesInfoModel.paymentCategory == PNPaymentCategorySchool) {
            norStr = PNLocalizedString(@"student_id", @"学生ID");
        } else if (balancesInfoModel.paymentCategory == PNPaymentCategoryInsurance) {
            norStr = PNLocalizedString(@"policy_number", @"保单号");
        } else {
            norStr = PNLocalizedString(@"customer_code", @"用户号");
        }
        model.keyText = [NSString stringWithFormat:@"%@:", norStr];
        model.valueText = self.billModel.customer.code;
        [listArray addObject:model];

        model = SAInfoViewModel.new;
        model.keyText = [NSString stringWithFormat:@"%@:", PNLocalizedString(@"customer_name", @"Customer Name")];
        model.valueText = self.billModel.customer.name;
        [listArray addObject:model];
    }

    section.list = listArray;
    section.headerModel = header;
    [self.dataSourceArray addObject:section];

    /// balances_info
    section = HDTableViewSectionModel.new;
    listArray = [NSMutableArray array];
    header = HDTableHeaderFootViewModel.new;

    header.title = PNLocalizedString(@"balances_info", @"Balances Info");

    model = SAInfoViewModel.new;
    model.keyText = [NSString stringWithFormat:@"%@:", PNLocalizedString(@"bill_amount", @"Bill Amount")];
    model.valueText = balancesInfoModel.billAmount.thousandSeparatorAmount;
    [listArray addObject:model];

    model = SAInfoViewModel.new;
    model.keyText = [NSString stringWithFormat:@"%@:", PNLocalizedString(@"fee", @"fee")];
    model.valueText = balancesInfoModel.feeAmount.thousandSeparatorAmount;
    [listArray addObject:model];

    if (balancesInfoModel.marketingBreaks.amount.doubleValue > 0) {
        model = SAInfoViewModel.new;
        model.keyText = [NSString stringWithFormat:@"%@:", PNLocalizedString(@"promotion", @"promotion")];
        model.valueText = balancesInfoModel.marketingBreaks.thousandSeparatorAmount;
        [listArray addObject:model];
    }

    model = SAInfoViewModel.new;
    model.keyText = [NSString stringWithFormat:@"%@:", PNLocalizedString(@"charge_type", @"Charge type")];
    model.valueText = balancesInfoModel.chargeType;
    [listArray addObject:model];

    model = SAInfoViewModel.new;
    model.keyText = [NSString stringWithFormat:@"%@:", PNLocalizedString(@"total_amount", @"Total Amount")];
    model.valueText = balancesInfoModel.totalAmount.thousandSeparatorAmount;
    [listArray addObject:model];

    if ([balancesInfoModel.currency isEqualToString:PNCurrencyTypeKHR]) {
        model = SAInfoViewModel.new;
        model.keyText = [NSString stringWithFormat:@"%@:", PNLocalizedString(@"total_Amount_exchange_USD", @"支付合计（换算为USD）")];
        model.valueText = balancesInfoModel.otherCurrencyAmounts.thousandSeparatorAmount;
        [listArray addObject:model];
    }

    /// payDiscountAmount不为空 且大于0， 就显示 支付优惠, 然后支付金额用payActualPayAmount
    if (!HDIsObjectNil(self.saOrderDetailsRspModel.payDiscountAmount) && self.saOrderDetailsRspModel.payDiscountAmount.cent.integerValue > 0) {
        model = SAInfoViewModel.new;
        model.keyText = SALocalizedString(@"payment_coupon", @"支付优惠");
        model.valueText = [NSString stringWithFormat:@"-%@", self.saOrderDetailsRspModel.payDiscountAmount.thousandSeparatorAmount];
        model.valueColor = [UIColor hd_colorWithHexString:@"#F83E00"];
        [listArray addObject:model];

        model = SAInfoViewModel.new;
        model.keyText = SALocalizedString(@"PAGE_TEXT_REAL_AMOUNT", @"实付金额");
        model.valueText = self.saOrderDetailsRspModel.payActualPayAmount.thousandSeparatorAmount;
        [listArray addObject:model];
    }
    //    else {
    //        model = SAInfoViewModel.new;
    //        model.keyText = SALocalizedString(@"orderDetails_payAmount", @"支付金额");
    //        model.valueText = self.saOrderDetailsRspModel.actualPayAmount.thousandSeparatorAmount;
    //        [listArray addObject:model];
    //    }

    section.list = listArray;
    section.headerModel = header;
    [self.dataSourceArray addObject:section];

    /// payer info
    section = HDTableViewSectionModel.new;
    listArray = [NSMutableArray array];
    header = HDTableHeaderFootViewModel.new;

    header.title = PNLocalizedString(@"payer_info", @"Payer Info");

    model = SAInfoViewModel.new;
    model.keyText = [NSString stringWithFormat:@"%@:", PNLocalizedString(@"customer_phone", @"Customer_phone")];
    model.valueText = balancesInfoModel.customerPhone;
    [listArray addObject:model];

    model = SAInfoViewModel.new;
    model.keyText = [NSString stringWithFormat:@"%@:", PNLocalizedString(@"pay_currency", @"pay_currency")];
    model.valueText = balancesInfoModel.actualPaymentCurrency;
    [listArray addObject:model];

    model = SAInfoViewModel.new;
    model.keyText = [NSString stringWithFormat:@"%@:", PNLocalizedString(@"PAGE_TEXT_CREATE_TIME", @"创建时间")];
    model.valueText = [PNCommonUtils getDateStrByFormat:@"dd/MM/yyyy HH:mm" withDate:[NSDate dateWithTimeIntervalSince1970:balancesInfoModel.orderTime.floatValue / 1000]];
    [listArray addObject:model];

    model = SAInfoViewModel.new;
    model.keyText = [NSString stringWithFormat:@"%@:", PNLocalizedString(@"notes", @"Notes")];
    model.valueText = balancesInfoModel.notes;
    [listArray addObject:model];

    section.list = listArray;
    section.headerModel = header;
    [self.dataSourceArray addObject:section];
}

#pragma mark
- (PNWaterDTO *)waterDTO {
    return _waterDTO ?: ({ _waterDTO = [[PNWaterDTO alloc] init]; });
}

- (SAOrderDTO *)saOrderDTO {
    return _saOrderDTO ?: ({ _saOrderDTO = [[SAOrderDTO alloc] init]; });
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}
@end
