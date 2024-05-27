//
//  PNMSHomeViewModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/5/27.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSHomeViewModel.h"
#import "PNAcountCellModel.h"
#import "PNCommonUtils.h"
#import "PNFunctionCellModel.h"
#import "PNMSHomeDTO.h"
#import "PNMSInfoModel.h"
#import "PNUserDTO.h"
#import "PNWalletAcountModel.h"
#import "PNWalletLevelInfoCellView.h"


@interface PNMSHomeViewModel ()
@property (nonatomic, strong) PNMSHomeDTO *homeDTO;
@property (nonatomic, strong) PNUserDTO *userDTO;
@end


@implementation PNMSHomeViewModel

/// 获取钱包首页信息
- (void)getNewData {
    [self.view showloading];

    @HDWeakify(self);
    [self.homeDTO getMSHomeBalance:^(NSArray<PNMSBalanceInfoModel *> *_Nonnull rspList) {
        @HDStrongify(self);

        void (^setData)(PNAcountCellModel *) = ^(PNAcountCellModel *itemCellModel) {
            for (PNMSBalanceInfoModel *item in rspList) {
                if (WJIsStringNotEmpty(item.currency)) {
                    if ([item.currency isEqualToString:itemCellModel.currency]) {
                        itemCellModel.balance = [PNCommonUtils thousandSeparatorNoCurrencySymbolWithAmount:[PNCommonUtils fenToyuan:item.balance] currencyCode:item.currency];
                        itemCellModel.usableBalance = [PNCommonUtils thousandSeparatorNoCurrencySymbolWithAmount:[PNCommonUtils fenToyuan:item.tradableBalance] currencyCode:item.currency];
                    }
                }
            }
        };

        if (rspList.count > 0) {
            for (int i = 0; i < self.dataSource.count; i++) {
                SACollectionViewSectionModel *sectionModel = self.dataSource[i];
                if ([sectionModel.hd_associatedObject isEqualToString:kAccountFlag]) {
                    for (PNAcountCellModel *itemCellModel in sectionModel.list) {
                        setData(itemCellModel);
                    }
                }
            }
        }

        [self.view dismissLoading];
        self.refreshFlag = !self.refreshFlag;
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
        self.refreshFlag = !self.refreshFlag;
    }];
}

#pragma mark
- (PNMSHomeDTO *)homeDTO {
    if (!_homeDTO) {
        _homeDTO = [[PNMSHomeDTO alloc] init];
    }
    return _homeDTO;
}

- (NSMutableArray<SACollectionViewSectionModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:2];
        SACollectionViewSectionModel *model = SACollectionViewSectionModel.new;

        model.hd_associatedObject = kAccountFlag;
        PNAcountCellModel *acountCellModel = [PNAcountCellModel getModel:@"" bgImage:@"pn_bg_KHR" CSymbolImage:@"currency_khr" Balance:@"---" Currency:@"KHR" currencyImage:@"currency_icon_khr"
                                                          NonCashBalance:@"---"];

        PNAcountCellModel *acountCellMode1 = [PNAcountCellModel getModel:@"" bgImage:@"pn_bg_USD" CSymbolImage:@"currency_usd" Balance:@"-.--" Currency:@"USD" currencyImage:@"currency_icon_usd"
                                                          NonCashBalance:@"-.--"];

        model.list = @[acountCellModel, acountCellMode1];
        if ([VipayUser hasWalletBalanceMenu]) {
            [_dataSource addObject:model];
        }

        model = SACollectionViewSectionModel.new;
        model.hd_associatedObject = kTopFunctionFlag;
        NSMutableArray *functionCellModelArr = [NSMutableArray array];
        if ([VipayUser hasCollectionTodayMenu]) {
            [functionCellModelArr addObject:[PNFunctionCellModel getModel:@"pn_ms_home_revice" title:PNLocalizedString(@"ms_today_collection", @"商户收款") actionName:@"merchantServicesCollection"]];
        }

        if ([VipayUser hasWalletWithdrawMenu]) {
            [functionCellModelArr addObject:[PNFunctionCellModel getModel:@"pn_ms_home_caseIn" title:PNLocalizedString(@"pn_Withdraw", @"提现") actionName:@"merchantServicesWithdrawList"]];
        }

        if ([VipayUser hasCollectionDataQueryMenu]) {
            [functionCellModelArr addObject:[PNFunctionCellModel getModel:@"pn_ms_home_record" title:PNLocalizedString(@"Transaction_record", @"交易记录") actionName:@"merchantServicesOrderList"]];
        }

        if ([VipayUser hasMerchantCodeQueryMenu]) {
            [functionCellModelArr addObject:[PNFunctionCellModel getModel:@"pn_ms_home_qrCode" title:PNLocalizedString(@"pn_ms_Merchant_KHQR", @"收款码") actionName:@"merchantServicesReceiveCode"]];
        }

        if ([VipayUser hasStoreManagerMenu]) {
            [functionCellModelArr addObject:[PNFunctionCellModel getModel:@"pn_ms_home_store" title:PNLocalizedString(@"pn_store_manager", @"门店管理") actionName:@"merchantServicesStoreManager"]];
        }

        if ([VipayUser hasOperatorManagerMenu]) {
            [functionCellModelArr addObject:[PNFunctionCellModel getModel:@"pn_ms_home_operator" title:PNLocalizedString(@"pn_operator_management", @"操作员管理")
                                                               actionName:@"merchantServicesOperatorManager"]];
        }

        if ([VipayUser hasUploadVoucherMenu]) {
            [functionCellModelArr addObject:[PNFunctionCellModel getModel:@"pn_ms_home_voucher" title:PNLocalizedString(@"pn_Upload_voucher", @"上传凭证") actionName:@"merchantServicesVoucherList"]];
        }

        model.list = functionCellModelArr;
        [_dataSource addObject:model];
    }
    return _dataSource;
}

@end
