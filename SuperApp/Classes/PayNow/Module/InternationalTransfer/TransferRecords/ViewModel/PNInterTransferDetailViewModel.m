//
//  PNInterTransferDetailViewModel.m
//  SuperApp
//
//  Created by 张杰 on 2022/6/20.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInterTransferDetailViewModel.h"
#import "HDAppTheme+PayNow.h"
#import "PNCommonUtils.h"
#import "SAInfoViewModel.h"
#import "VipayUser.h"


@implementation PNInterTransferDetailViewModel

- (void)initDataArr {
    if (self.recordModel.channel == PNInterTransferThunesChannel_Wechat) {
        // 1.我的账号相关section
        HDTableViewSectionModel *sectionModel = HDTableViewSectionModel.new;

        NSMutableArray *temp = [NSMutableArray array];

        SAInfoViewModel *infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"PAGE_TITLE_MY_INFO", @"我的账号");
        infoModel.valueText = [VipayUser shareInstance].loginName;
        [temp addObject:infoModel];

        if (WJIsStringNotEmpty(self.recordModel.inviteCode)) {
            SAInfoViewModel *infoModel = [self getDefaultInfoViewModel];
            infoModel.keyText = PNLocalizedString(@"pn_invite_code", @"邀请码");
            infoModel.valueText = self.recordModel.inviteCode;
            [temp addObject:infoModel];
        }

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"C3InKk2b", @"转账目的");
        infoModel.valueText = HDIsStringNotEmpty(self.recordModel.otherPurposeRemittance) ? self.recordModel.otherPurposeRemittance : self.recordModel.purposeRemittanceType;
        [temp addObject:infoModel];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"qVCl1o8O", @"交易日期");
        infoModel.valueText = [PNCommonUtils getDateStrByFormat:@"dd/MM/yyyy" withDate:[NSDate dateWithTimeIntervalSince1970:self.recordModel.createTime.floatValue / 1000]];
        ;
        [temp addObject:infoModel];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"28Y45s6W", @"交易单号");
        infoModel.valueText = self.recordModel.tradeNo;
        [temp addObject:infoModel];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"5xdNPvU0", @"交易状态");
        infoModel.valueText = [PNCommonUtils getInterTransferOrderStatus:self.recordModel.status];
        [temp addObject:infoModel];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"pn_txn_channel", @"交易渠道");
        infoModel.valueText = self.recordModel.receiveChannel;
        [temp addObject:infoModel];

        if (HDIsStringNotEmpty(self.recordModel.reason)) {
            infoModel = [self getDefaultInfoViewModel];
            infoModel.keyText = PNLocalizedString(@"y97jp8l0", @"错误信息");
            infoModel.valueText = self.recordModel.reason;
            [temp addObject:infoModel];
        }

        sectionModel.list = temp;
        [self.dataArr addObject:sectionModel];

        //转账详情
        sectionModel = HDTableViewSectionModel.new;
        sectionModel.headerModel = HDTableHeaderFootViewModel.new;
        sectionModel.headerModel.title = PNLocalizedString(@"dtXJWLUv", @"转账详情");

        temp = [NSMutableArray array];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"transfer_amount", @"转账金额");
        infoModel.valueText = self.recordModel.payoutAmount.thousandSeparatorAmount;
        [temp addObject:infoModel];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"cB3e7LW6", @"转账服务费");
        infoModel.valueText = self.recordModel.serviceCharge.thousandSeparatorAmount;
        [temp addObject:infoModel];

        if (!HDIsObjectNil(self.recordModel.promotion) && HDIsStringNotEmpty(self.recordModel.promotion.cent) && [self.recordModel.promotion.cent integerValue] > 0) {
            infoModel = [self getDefaultInfoViewModel];
            infoModel.keyText = PNLocalizedString(@"d1q6xTQ3", @"营销减免");
            infoModel.valueText = self.recordModel.promotion.thousandSeparatorAmount;
            [temp addObject:infoModel];
        }

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"detail_total_amount", @"支付金额");
        infoModel.valueText = self.recordModel.totalPayoutAmount.thousandSeparatorAmount;
        [temp addObject:infoModel];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"O7btTqFy", @"转账汇率");
        infoModel.valueText = self.recordModel.fxRate;
        [temp addObject:infoModel];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"JWRpnuek", @"预计到账金额");
        infoModel.valueText = self.recordModel.receiverAmount.thousandSeparatorAmount;
        [temp addObject:infoModel];

        sectionModel.list = temp;
        [self.dataArr addObject:sectionModel];

        sectionModel = HDTableViewSectionModel.new;
        sectionModel.headerModel = HDTableHeaderFootViewModel.new;
        sectionModel.headerModel.title = PNLocalizedString(@"RHUBAPgC", @"收款人详情");

        temp = [NSMutableArray array];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"pn_full_name", @"姓名");
        infoModel.valueText = self.recordModel.fullName;
        [temp addObject:infoModel];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"EflnCwt2", @"手机号");
        infoModel.valueText = self.recordModel.msisdn;
        [temp addObject:infoModel];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"Legal_type", @"证件类型");
        NSString *text;
        if (self.recordModel.idType == PNPapersTypePassport) {
            text = PNLocalizedString(@"PAPER_TYPE_PASSPORT", @"护照");
        } else if (self.recordModel.idType == PNPapersTypeIDCard) {
            text = PNLocalizedString(@"PAPER_TYPE_IDCARD", @"身份证");
        }
        infoModel.valueText = text;
        [temp addObject:infoModel];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"Legal_number", @"证件号");
        infoModel.valueText = self.recordModel.idCode;
        [temp addObject:infoModel];

        sectionModel.list = temp;
        [self.dataArr addObject:sectionModel];
    } else {
        // 1.我的账号相关section
        HDTableViewSectionModel *sectionModel = HDTableViewSectionModel.new;

        NSMutableArray *temp = [NSMutableArray array];

        SAInfoViewModel *infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"PAGE_TITLE_MY_INFO", @"我的账号");
        infoModel.valueText = [VipayUser shareInstance].loginName;
        [temp addObject:infoModel];

        if (WJIsStringNotEmpty(self.recordModel.inviteCode)) {
            SAInfoViewModel *infoModel = [self getDefaultInfoViewModel];
            infoModel.keyText = PNLocalizedString(@"pn_invite_code", @"邀请码");
            infoModel.valueText = self.recordModel.inviteCode;
            [temp addObject:infoModel];
        }

        //    infoModel = [self getDefaultInfoViewModel];
        //    infoModel.keyText = PNLocalizedString(@"jipl0KUj", @"出生国家");
        //    infoModel.valueText = self.recordModel.senderPayoutCountryOfBirth;
        //    [temp addObject:infoModel];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"C3InKk2b", @"转账目的");
        infoModel.valueText = HDIsStringNotEmpty(self.recordModel.otherPurposeRemittance) ? self.recordModel.otherPurposeRemittance : self.recordModel.purposeRemittanceType;
        [temp addObject:infoModel];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"73IrNw1L", @"资金来源");
        infoModel.valueText = HDIsStringNotEmpty(self.recordModel.otherSourceFund) ? self.recordModel.otherSourceFund : self.recordModel.sourceFundType;
        [temp addObject:infoModel];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"qVCl1o8O", @"交易日期");
        infoModel.valueText = [PNCommonUtils getDateStrByFormat:@"dd/MM/yyyy" withDate:[NSDate dateWithTimeIntervalSince1970:self.recordModel.createTime.floatValue / 1000]];
        ;
        [temp addObject:infoModel];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"28Y45s6W", @"交易单号");
        infoModel.valueText = self.recordModel.tradeNo;
        [temp addObject:infoModel];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"5xdNPvU0", @"交易状态");
        infoModel.valueText = [PNCommonUtils getInterTransferOrderStatus:self.recordModel.status];
        [temp addObject:infoModel];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"pn_txn_channel", @"交易渠道");
        infoModel.valueText = self.recordModel.receiveChannel;
        [temp addObject:infoModel];

        if (HDIsStringNotEmpty(self.recordModel.reason)) {
            infoModel = [self getDefaultInfoViewModel];
            infoModel.keyText = PNLocalizedString(@"y97jp8l0", @"错误信息");
            infoModel.valueText = self.recordModel.reason;
            [temp addObject:infoModel];
        }

        sectionModel.list = temp;
        [self.dataArr addObject:sectionModel];

        //转账详情
        sectionModel = HDTableViewSectionModel.new;
        sectionModel.headerModel = HDTableHeaderFootViewModel.new;
        sectionModel.headerModel.title = PNLocalizedString(@"dtXJWLUv", @"转账详情");

        temp = [NSMutableArray array];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"transfer_amount", @"转账金额");
        infoModel.valueText = self.recordModel.payoutAmount.thousandSeparatorAmount;
        [temp addObject:infoModel];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"cB3e7LW6", @"转账服务费");
        infoModel.valueText = self.recordModel.serviceCharge.thousandSeparatorAmount;
        [temp addObject:infoModel];

        if (!HDIsObjectNil(self.recordModel.promotion) && HDIsStringNotEmpty(self.recordModel.promotion.cent) && [self.recordModel.promotion.cent integerValue] > 0) {
            infoModel = [self getDefaultInfoViewModel];
            infoModel.keyText = PNLocalizedString(@"d1q6xTQ3", @"营销减免");
            infoModel.valueText = self.recordModel.promotion.thousandSeparatorAmount;
            [temp addObject:infoModel];
        }

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"detail_total_amount", @"支付金额");
        infoModel.valueText = self.recordModel.totalPayoutAmount.thousandSeparatorAmount;
        [temp addObject:infoModel];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"O7btTqFy", @"转账汇率");
        infoModel.valueText = self.recordModel.fxRate;
        [temp addObject:infoModel];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"JWRpnuek", @"预计到账金额");
        infoModel.valueText = self.recordModel.receiverAmount.thousandSeparatorAmount;
        [temp addObject:infoModel];

        sectionModel.list = temp;
        [self.dataArr addObject:sectionModel];

        sectionModel = HDTableViewSectionModel.new;
        sectionModel.headerModel = HDTableHeaderFootViewModel.new;
        sectionModel.headerModel.title = PNLocalizedString(@"RHUBAPgC", @"收款人详情");

        temp = [NSMutableArray array];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"TF_TITLE_LAST_NAME", @"姓");
        infoModel.valueText = self.recordModel.lastName;
        [temp addObject:infoModel];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"UNzSjgTY", @"名");
        infoModel.valueText = self.recordModel.firstName;
        [temp addObject:infoModel];

        //    if (HDIsStringNotEmpty(self.recordModel.middleName)) {
        //        infoModel = [self getDefaultInfoViewModel];
        //        infoModel.keyText = PNLocalizedString(@"OwjdGw1x", @"中间名");
        //        infoModel.valueText = self.recordModel.middleName;
        //        [temp addObject:infoModel];
        //    }

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"Suw8Q4KU", @"国家");
        infoModel.valueText = self.recordModel.nationality;
        [temp addObject:infoModel];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"MAOLJbCr", @"省");
        infoModel.valueText = self.recordModel.province;
        [temp addObject:infoModel];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"WFLBHUE4", @"城市");
        infoModel.valueText = self.recordModel.city;
        [temp addObject:infoModel];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"LQPsLBJh", @"地址");
        infoModel.valueText = self.recordModel.address;
        [temp addObject:infoModel];

        //    infoModel = [self getDefaultInfoViewModel];
        //    infoModel.keyText = PNLocalizedString(@"info_email", @"邮箱");
        //    infoModel.valueText = self.recordModel.email;
        //    [temp addObject:infoModel];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"EflnCwt2", @"手机号");
        infoModel.valueText = self.recordModel.msisdn;
        [temp addObject:infoModel];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"lYXV87bl", @"与转账人关系");
        infoModel.valueText = HDIsStringNotEmpty(self.recordModel.otherRelation) ? self.recordModel.otherRelation : self.recordModel.relationType;
        [temp addObject:infoModel];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"Legal_type", @"证件类型");
        NSString *text;
        if (self.recordModel.idType == PNPapersTypePassport) {
            text = PNLocalizedString(@"PAPER_TYPE_PASSPORT", @"护照");
        } else if (self.recordModel.idType == PNPapersTypeIDCard) {
            text = PNLocalizedString(@"PAPER_TYPE_IDCARD", @"身份证");
        }
        infoModel.valueText = text;
        [temp addObject:infoModel];

        infoModel = [self getDefaultInfoViewModel];
        infoModel.keyText = PNLocalizedString(@"Legal_number", @"证件号");
        infoModel.valueText = self.recordModel.idCode;
        [temp addObject:infoModel];

        sectionModel.list = temp;
        [self.dataArr addObject:sectionModel];
    }
}
- (SAInfoViewModel *)getDefaultInfoViewModel {
    SAInfoViewModel *infoModel = [[SAInfoViewModel alloc] init];
    infoModel.keyFont = [HDAppTheme.PayNowFont fontBold:12];
    infoModel.keyColor = HDAppTheme.PayNowColor.c333333;
    infoModel.valueFont = HDAppTheme.PayNowFont.standard12;
    infoModel.valueColor = HDAppTheme.PayNowColor.c333333;
    return infoModel;
}

/** @lazy dataArr */
- (NSMutableArray<HDTableViewSectionModel *> *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
@end
