//
//  PNPaymentComfirmViewModel.m
//  SuperApp
//
//  Created by xixi_wen on 2023/2/9.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNPaymentComfirmViewModel.h"
#import "HDCheckStandOrderSubmitParamsRspModel.h"
#import "HDCheckstandDTO.h"
#import "PNCheckstandDTO.h"
#import "PNMSTransferCreateOrderRspModel.h"
#import "PNMSWitdrawDTO.h"
#import "PNPaymentComfirmDTO.h"
#import "PNRspModel.h"
#import "PayHDTradeConfirmPaymentRspModel.h"


@interface PNPaymentComfirmViewModel ()
@property (nonatomic, strong) PNPaymentComfirmDTO *paymentComfirmDTO;
@property (nonatomic, strong) PNCheckstandDTO *standDTO;
@property (nonatomic, strong) PNMSWitdrawDTO *withdrawDTO;
@end


@implementation PNPaymentComfirmViewModel

- (void)getData:(PNWalletBalanceType)type {
    [self.view showloading];

    @HDWeakify(self);
    [self.paymentComfirmDTO getTradePaymentInfo:self.buildModel.tradeNo type:type payWay:self.buildModel.payWay success:^(PNPaymentComfirmRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        self.model = rspModel;
        self.refreshFlag = !self.refreshFlag;
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
        self.model = [PNPaymentComfirmRspModel new];
        self.refreshFlag = !self.refreshFlag;
    }];
}

/// 确认支付
- (void)paymentComfirm:(void (^)(PayHDTradeConfirmPaymentRspModel *rspModel))successBlock {
    if (self.buildModel.fromType == PNPaymentBuildFromType_Default || self.buildModel.fromType == PNPaymentBuildFromType_Middle) {
        if (self.buildModel.subTradeType == PNTradeSubTradeTypeCoolCashCashOut) {
            [self coolCash_PaymentComfirm:successBlock];
        } else {
            [self nor_paymentComfirm:successBlock];
        }
    } else {
        /// 商户提现模块
        if (self.buildModel.subTradeType == PNTradeSubTradeTypeMerchantToSelfBank) {
            [self ms_withdrawToBank:successBlock];
        } else if (self.buildModel.subTradeType == PNTradeSubTradeTypeMerchantToSelfWallet) {
            [self ms_withdrawToMyWallet:^(PNMSTransferCreateOrderRspModel *rspModel) {
                self.buildModel.tradeNo = rspModel.tradeNo;
                [self nor_paymentComfirm:successBlock];
            }];
        }
    }
}

/// 确认支付
- (void)nor_paymentComfirm:(void (^)(PayHDTradeConfirmPaymentRspModel *rspModel))successBlock {
    [self.view showloading];

    @HDWeakify(self);

    if (self.buildModel.fromType == PNPaymentBuildFromType_Middle) {
        [self.paymentComfirmDTO submitOrderParamsWithPaymentMethod:HDCheckStandPaymentToolsBalance tradeNo:self.buildModel.tradeNo paymentCurrency:self.model.paymentCurrency
            success:^(HDCheckStandOrderSubmitParamsRspModel *_Nonnull rspModel) {
                @HDStrongify(self);
                [self.view dismissLoading];

                PayHDTradeConfirmPaymentRspModel *model = [PayHDTradeConfirmPaymentRspModel yy_modelWithJSON:[rspModel yy_modelToJSONObject]];
                !successBlock ?: successBlock(model);
            } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
                @HDStrongify(self);
                [self.view dismissLoading];
                [NAT showAlertWithMessage:rspModel.msg buttonTitle:PNLocalizedString(@"BUTTON_TITLE_SURE", @"确定") handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                    [alertView dismiss];
                }];
            }];
    } else {
        [self.standDTO pn_tradeConfirmPaymentWithTradeNo:self.buildModel.tradeNo paymentCurrency:self.model.paymentCurrency payWay:self.buildModel.payWay
            success:^(PayHDTradeConfirmPaymentRspModel *_Nonnull rspModel) {
                @HDStrongify(self);
                [self.view dismissLoading];
                !successBlock ?: successBlock(rspModel);
            } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
                @HDStrongify(self);
                [self.view dismissLoading];
                [NAT showAlertWithMessage:rspModel.msg buttonTitle:PNLocalizedString(@"BUTTON_TITLE_SURE", @"确定") handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                    [alertView dismiss];
                }];
            }];
    }
}

/// coolcash 出金受理确认
- (void)coolCash_PaymentComfirm:(void (^)(PayHDTradeConfirmPaymentRspModel *rspModel))successBlock {
    [self.view showloading];

    @HDWeakify(self);
    [self.standDTO coolCashOutCashAcceptWithTradeNo:self.buildModel.tradeNo paymentCurrency:self.model.paymentCurrency methodPayment:nil
        success:^(PayHDTradeConfirmPaymentRspModel *_Nonnull rspModel) {
            @HDStrongify(self);
            [self.view dismissLoading];
            !successBlock ?: successBlock(rspModel);
        } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self.view dismissLoading];
        }];
}

/// 提现到银行卡下单确认
- (void)ms_withdrawToBank:(void (^)(PayHDTradeConfirmPaymentRspModel *rspModel))successBlock {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.buildModel.extendWithdrawModel.caseInAmount.cent forKey:@"orderAmt"];
    [dict setValue:self.buildModel.extendWithdrawModel.caseInAmount.cy forKey:@"currency"];
    [dict setValue:self.buildModel.extendWithdrawModel.accountNumber forKey:@"accountNumber"];
    [dict setValue:self.buildModel.extendWithdrawModel.participantCode forKey:@"participantCode"];
    [dict setValue:self.buildModel.extendWithdrawModel.operatorNo forKey:@"operatorNo"];
    [dict setValue:self.buildModel.extendWithdrawModel.merchantNo forKey:@"merchantNo"];

    [self.view showloading];

    @HDWeakify(self);
    [self.withdrawDTO bankCardWithdrawMSCreateOrderWithParam:dict success:^(PNRspModel *_Nonnull rspModel) {
        NSLog(@"%@", rspModel);
        @HDStrongify(self);
        [self.view dismissLoading];
        PayHDTradeConfirmPaymentRspModel *model = [PayHDTradeConfirmPaymentRspModel yy_modelWithJSON:rspModel.data];
        !successBlock ?: successBlock(model);
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

/// 提现到个人钱包下单确认
- (void)ms_withdrawToMyWallet:(void (^)(PNMSTransferCreateOrderRspModel *rspModel))successBlock {
    NSDictionary *dict = @{
        @"amt": self.buildModel.extendWithdrawModel.caseInAmount.amount,
        @"userFeeAmt": @(0),
        @"realAmt": self.buildModel.extendWithdrawModel.caseInAmount.amount,
        @"currency": self.buildModel.extendWithdrawModel.caseInAmount.cy,
        @"userMp": self.buildModel.extendWithdrawModel.accountNumber,
        @"merchantNo": self.buildModel.extendWithdrawModel.merchantNo,
        @"operatorNo": self.buildModel.extendWithdrawModel.operatorNo,
        @"operatorType": @(10),
    };

    [self.view showloading];

    @HDWeakify(self);
    [self.withdrawDTO transferMSCreateOrderWithParam:dict success:^(PNMSTransferCreateOrderRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        !successBlock ?: successBlock(rspModel);
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

#pragma mark
- (PNPaymentComfirmDTO *)paymentComfirmDTO {
    if (!_paymentComfirmDTO) {
        _paymentComfirmDTO = [[PNPaymentComfirmDTO alloc] init];
    }
    return _paymentComfirmDTO;
}

- (PNCheckstandDTO *)standDTO {
    if (!_standDTO) {
        _standDTO = [[PNCheckstandDTO alloc] init];
    }
    return _standDTO;
}

- (PNMSWitdrawDTO *)withdrawDTO {
    if (!_withdrawDTO) {
        _withdrawDTO = [[PNMSWitdrawDTO alloc] init];
    }
    return _withdrawDTO;
}

@end
