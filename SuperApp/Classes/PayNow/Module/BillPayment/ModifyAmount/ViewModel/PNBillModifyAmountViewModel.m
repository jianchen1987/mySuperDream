//
//  PNBillModifyAccountViewModel.m
//  SuperApp
//
//  Created by xixi_wen on 2022/3/24.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNBillModifyAmountViewModel.h"
#import "PNBillModifyAmountDTO.h"
#import "PNBillModifyAmountModel.h"
#import "PNRspModel.h"


@interface PNBillModifyAmountViewModel ()

@property (nonatomic, strong) PNBillModifyAmountDTO *modifyDTO;

@end


@implementation PNBillModifyAmountViewModel

/// 试算
- (void)billModifyAmount:(NSString *)amount {
    [self.view showloading];
    @HDWeakify(self);
    [self.modifyDTO billModifyAccountWithPaymentToken:self.balancesInfoModel.paymentToken amount:amount billNo:self.billNo currency:self.balancesInfoModel.currency
        success:^(PNRspModel *_Nonnull rspModel) {
            @HDStrongify(self);
            [self.view dismissLoading];
            PNBillModifyAmountModel *modifyAccountModel = [PNBillModifyAmountModel yy_modelWithJSON:rspModel.data];
            if (!WJIsObjectNil(modifyAccountModel.billAmount) && WJIsStringNotEmpty(modifyAccountModel.paymentToken)) {
                self.balancesInfoModel.feeAmount = modifyAccountModel.feeAmount;
                self.balancesInfoModel.billAmount = modifyAccountModel.billAmount;
                self.balancesInfoModel.totalAmount = modifyAccountModel.totalAmount;
                self.balancesInfoModel.paymentToken = modifyAccountModel.paymentToken;
                self.balancesInfoModel.otherCurrencyAmounts = modifyAccountModel.otherCurrencyAmounts;

                self.refreshFlag = !self.refreshFlag;

                !self.handleModifyAmountBlock ?: self.handleModifyAmountBlock(self.balancesInfoModel);
                [self.view.viewController.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self.view dismissLoading];
            self.refreshFlag = !self.refreshFlag;

            /// 额外处理特殊的code
            if (WJIsObjectNil(rspModel)) {
                [NAT showToastWithTitle:nil content:SALocalizedString(@"network_no_network", @"网络开小差啦") type:HDTopToastTypeError];
            } else {
                if ([rspModel.code isEqualToString:@"BL10008"]) {
                    // 该交易已过期，请重新查询   - 跳转到 查询页面
                    @HDWeakify(self);
                    [NAT showAlertWithMessage:[NSString stringWithFormat:@"%@", rspModel.msg] buttonTitle:PNLocalizedString(@"BUTTON_TITLE_DONE", @"确定")
                                      handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                                          [alertView dismiss];
                                          @HDStrongify(self);
                                          [self.view.viewController.navigationController popToViewControllerClass:NSClassFromString(@"PNUtilitiesViewController") animated:YES];
                                      }];

                } else {
                    [NAT showAlertWithMessage:[NSString stringWithFormat:@"%@", rspModel.msg] buttonTitle:PNLocalizedString(@"BUTTON_TITLE_DONE", @"确定")
                                      handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                                          [alertView dismiss];
                                      }];
                }
            }
        }];
}

#pragma mark
- (PNBillModifyAmountDTO *)modifyDTO {
    if (!_modifyDTO) {
        _modifyDTO = [[PNBillModifyAmountDTO alloc] init];
    }
    return _modifyDTO;
}
@end
