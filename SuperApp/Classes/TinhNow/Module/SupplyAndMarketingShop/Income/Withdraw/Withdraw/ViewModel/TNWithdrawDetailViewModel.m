//
//  TNWithdrawViewModel.m
//  SuperApp
//
//  Created by xixi_wen on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNWithdrawDetailViewModel.h"
#import "HDAppTheme+TinhNow.h"
#import "SAInfoView.h"
#import "TNMultiLanguageManager.h"
#import "TNWithDrawAuditAmountCell.h"
#import "TNWithDrawDetailCertificateCell.h"
#import "TNWithDrawDetailTipsCell.h"

#import "TNWithdrawDTO.h"


@interface TNWithdrawDetailViewModel ()
@property (strong, nonatomic) TNWithdrawDTO *dto;

@end


@implementation TNWithdrawDetailViewModel
- (void)getDetailData {
    [self.view showloading];
    @HDWeakify(self);
    [self.dto queryWithDrawDetailWithObjId:self.objId success:^(TNWithdrawModel *model) {
        @HDStrongify(self);
        [self.view dismissLoading];
        self.model = model;
        [self configDataArrWithModel:model];
        self.refreshFlag = !self.refreshFlag;
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
        !self.withDrawDetailGetDataFaild ?: self.withDrawDetailGetDataFaild();
    }];
}

- (void)configDataArrWithModel:(TNWithdrawModel *)model {
    TNWithDrawAuditAmountCellModel *amoutModel = TNWithDrawAuditAmountCellModel.new;
    amoutModel.amountMoney = model.amountMoney;
    amoutModel.status = model.status;
    amoutModel.commissionType = model.commissionType;
    amoutModel.remark = model.remark;
    [self.dataArr addObject:amoutModel];

    if (![model.status isEqualToString:TNWithDrawApplyStatusPending]) {
        TNWithDrawDetailTipsCellModel *tipsModel = TNWithDrawDetailTipsCellModel.new;
        tipsModel.status = model.status;
        tipsModel.memo = model.memo;
        [self.dataArr addObject:tipsModel];
    }

    SAInfoViewModel *infoModel = [self getonfigInfoViewModel];
    infoModel.keyText = TNLocalizedString(@"cri3B0so", @"提现方式");
    infoModel.valueText = [self.model.settlementType isEqualToString:TNPaymentWayCodeThird] ? TNLocalizedString(@"mCPxonSi", @"第三方支付") : TNLocalizedString(@"WqN6EPGK", @"银行转账");
    [self.dataArr addObject:infoModel];

    infoModel = [self getonfigInfoViewModel];
    infoModel.keyText = [self.model.settlementType isEqualToString:TNPaymentWayCodeThird] ? TNLocalizedString(@"bX44DKDk", @"支付公司名称") : TNLocalizedString(@"LKipPAAx", @"银行名称");
    ;
    infoModel.valueText = model.bank;
    [self.dataArr addObject:infoModel];

    infoModel = [self getonfigInfoViewModel];
    infoModel.keyText = [self.model.settlementType isEqualToString:TNPaymentWayCodeThird] ? TNLocalizedString(@"lcFUhF8n", @"支付账号") : TNLocalizedString(@"3VeQVX4G", @"银行账号");
    infoModel.valueText = model.account;
    [self.dataArr addObject:infoModel];

    infoModel = [self getonfigInfoViewModel];
    infoModel.keyText = [self.model.settlementType isEqualToString:TNPaymentWayCodeThird] ? TNLocalizedString(@"pBB3MUZp", @"账号名称") : TNLocalizedString(@"mJzP2nCp", @"开户名");
    infoModel.valueText = model.accountHolder;
    [self.dataArr addObject:infoModel];

    if ([model.status isEqualToString:TNWithDrawApplyStatusApproved] && HDIsStringNotEmpty(model.voucher)) {
        TNWithDrawDetailCertificateCellModel *cerModel = TNWithDrawDetailCertificateCellModel.new;
        cerModel.voucher = model.voucher;
        [self.dataArr addObject:cerModel];
    }
}
// configInfoViewModel
- (SAInfoViewModel *)getonfigInfoViewModel {
    SAInfoViewModel *infoModel = [[SAInfoViewModel alloc] init];
    infoModel.keyFont = HDAppTheme.TinhNowFont.standard12;
    infoModel.keyColor = HDAppTheme.TinhNowColor.G3;
    infoModel.valueFont = HDAppTheme.TinhNowFont.standard12M;
    infoModel.valueColor = HDAppTheme.TinhNowColor.G1;
    infoModel.lineWidth = 0;
    return infoModel;
}

/** @lazy dataArr */
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
/** @lazy dto */
- (TNWithdrawDTO *)dto {
    if (!_dto) {
        _dto = [[TNWithdrawDTO alloc] init];
    }
    return _dto;
}
@end
