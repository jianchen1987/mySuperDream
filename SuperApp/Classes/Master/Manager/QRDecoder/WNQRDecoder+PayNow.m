//
//  WNQRDecoder+PayNow.m
//  SuperApp
//
//  Created by seeu on 2022/5/9.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "HDBaseHtmlVC.h"
#import "HDPayeeInfoModel.h"
#import "PNCommonUtils.h"
#import "PNTransAmountViewController.h"
#import "PNTransListDTO.h"
#import "PNUserDTO.h"
#import "SAApolloManager.h"
#import "SAUser.h"
#import "SAWalletManager.h"
#import "SAWindowManager.h"
#import "WNQRDecoder+PayNow.h"
#import <BakongKHQR/BakongKHQR.h>
#import <HDKitCore/HDKitCore.h>
#import <HDUIKit/HDTips.h>


@implementation WNQRDecoder (PayNow)

/// 是否可以解码
/// @param code 二维码字符串
- (BOOL)canDecodePayNowQRCode:(NSString *)code {
    /// 配置白名单
    NSArray<NSString *> *whiteList = [SAApolloManager getApolloConfigForKey:kApolloSwitchKeyPayNowWhiteList];
    if ([code.lowercaseString hasPrefix:@"coolcash"]) {
        // 出金二维码
        return YES;
    } else if ([code.lowercaseString hasPrefix:@"http"] && !HDIsArrayEmpty(whiteList)) {
        // decode 一下，防止有特殊字符导致无法转换
        NSString *decodeStr = [code hd_URLDecodedString];
        NSURL *url = [NSURL URLWithString:decodeStr];
        if ([whiteList containsObject:[url host]]) {
            // coolcash 内部网站，用coolcash容器打开
            return YES;
        } else {
            // 不可识别的网站，抛给下一位
            return NO;
        }
    }
    // Bakong
    KHQRResponse *response = [BakongKHQR verify:code];
    if (response.data != nil) {
        CRCValidation *crcValidation = (CRCValidation *)response.data;
        if (crcValidation.valid == 1) {
            return YES;
        }
    }
    // coolcash 需要调后端解密，默认所有都能解
    return YES;
}

/// 解码
/// @param code 二维码字符串
- (BOOL)decodePayNowQRCode:(NSString *)code {
    // 上面做了白名单判断这里就不做了，能进来肯定是coolcash的
    // result: https://openapi-uat.coolcashcam.com/open_web/qr?wd=01102377
    if ([code.lowercaseString hasPrefix:@"http"]) {
        [self checkPayNowWasStandbyCompletion:^{
            NSString *urlStr = [code hd_URLEncodedString];
            HDBaseHtmlVC *vc = HDBaseHtmlVC.new;
            vc.url = urlStr;
            vc.hidesBottomBarWhenPushed = YES;
            [SAWindowManager navigateToViewController:vc parameters:@{}];
        }];
        return YES;
    }

    if ([code.lowercaseString hasPrefix:@"coolcash"]) { //出金二维码
        @HDWeakify(self);
        [self checkPayNowWasStandbyCompletion:^{
            @HDStrongify(self);
            [self getCoolCashInfo:code];
        }];
        return YES;
    }

    KHQRResponse *response = [BakongKHQR verify:code];
    if (response.data != nil) {
        CRCValidation *crcValidation = (CRCValidation *)response.data;
        if (crcValidation.valid == 1) { // bakong
            KHQRResponse *decodeResponse = [BakongKHQR decode:code];
            KHQRDecodeData *decodeData = (KHQRDecodeData *)decodeResponse.data;
            [decodeData printAll];
            @HDWeakify(self);
            [self checkPayNowWasStandbyCompletion:^{
                @HDStrongify(self);
                [self getBakongInfo:decodeData qrCode:code];
            }];

            return YES;
        }
    }

    @HDWeakify(self);
    [self checkPayNowWasStandbyCompletion:^{
        @HDStrongify(self);
        [self finalProcess:code];
    }];

    return YES;
}

#pragma mark - private methods
// bakong 支付
- (void)getBakongInfo:(KHQRDecodeData *)decodeData qrCode:(NSString *)qrCode {
    HDLog(@"进入Bakong处理");
    NSString *payeeNo = decodeData.bakongAccountID;

    NSString *merchantId = @"";
    if ([decodeData.merchantType isEqualToString:@"30"]) { //商户
        merchantId = decodeData.merchantAccountId;
    } else { // 29 个人
        merchantId = decodeData.accountInformation;
    }

    NSString *merchantType = decodeData.merchantType;

    [HDTips showLoading];

    PNTransListDTO *transDTO = PNTransListDTO.new;
    [transDTO getPayeeInfoFromBaKongQRCodeWithAccuontNo:payeeNo merchantId:merchantId merchantType:merchantType terminalLabel:decodeData.terminalLabel success:^(HDPayeeInfoModel *_Nonnull payeeInfo) {
        [HDTips hideAllTips];
        payeeInfo.payeeLoginName = payeeNo;

        NSString *cy = @"";
        if ([decodeData.transactionCurrency isEqualToString:@"840"]) {
            cy = PNCurrencyTypeUSD;
        } else if ([decodeData.transactionCurrency isEqualToString:@"116"]) {
            cy = PNCurrencyTypeKHR;
        }

        PNTransAmountViewController *vc = [[PNTransAmountViewController alloc] init];
        vc.cy = cy;
        vc.merchantId = merchantId;
        vc.payeeStoreName = decodeData.storeLabel;
        vc.payeeStoreLocation = decodeData.merchantCity;
        vc.billNumber = decodeData.billNumber;
        /// coolkhppxxx@cool 固定死
        if ([decodeData.bakongAccountID isEqualToString:@"coolkhppxxx@cool"] && [decodeData.merchantType isEqualToString:@"30"]) {
            vc.pageType = PNTradeSubTradeTypeToBakongMerchant;
        } else {
            if (payeeInfo.isCoolCashAccount == true) {
                vc.pageType = PNTradeSubTradeTypeToCoolCash;
                vc.subBizType = @"49";
            } else {
                vc.pageType = PNTradeSubTradeTypeToBakongCode;
            }
        }
        vc.payeeBankName = payeeInfo.bankName.length > 0 ? payeeInfo.bankName : @"Bakong";
        vc.qrData = qrCode;

        if ([decodeData.transactionAmount doubleValue] > 0) {
            SAMoneyModel *orderAmt = [SAMoneyModel new];
            orderAmt.cent = [PNCommonUtils yuanTofen:decodeData.transactionAmount];
            orderAmt.cy = cy;
            payeeInfo.orderAmt = orderAmt;
        }
        payeeInfo.payeeLoginName = merchantId;
        payeeInfo.name = decodeData.merchantName;
        payeeInfo.terminalLabel = decodeData.terminalLabel;
        //            payeeInfo.accountId = payeeInfo.phone.length > 0 ? payeeInfo.phone : payeeNo;
        payeeInfo.bakongAccountID = decodeData.merchantAccountId;
        vc.payeeInfo = payeeInfo;

        [SAWindowManager navigateToViewController:vc];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        [HDTips hideAllTips];
    }];
}

- (void)getCoolCashInfo:(NSString *)result {
    HDLog(@"进入CoolCash处理");
    [HDTips showLoading];
    //    @HDWeakify(self);

    PNTransListDTO *transDTO = PNTransListDTO.new;
    [transDTO getPayeeInfoFromCoolcashQRCodeWithQRData:result success:^(HDPayeeInfoModel *_Nonnull payeeInfo) {
        //            @HDStrongify(self);
        [HDTips hideAllTips];
        PNTransAmountViewController *vc = [[PNTransAmountViewController alloc] init];
        vc.cy = payeeInfo.currency ?: @"";
        vc.pageType = PNTradeSubTradeTypeCoolCashCashOut;
        vc.payeeInfo = payeeInfo;
        [SAWindowManager navigateToViewController:vc];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        [HDTips hideAllTips];
    }];
}

/// 兜底处理
/// @param result 二维码明文
- (void)finalProcess:(NSString *)result {
    HDLog(@"进入兜底处理");
    [HDTips showLoading];

    PNTransListDTO *transDTO = PNTransListDTO.new;
    //    @HDWeakify(self);
    [transDTO doAnalysisQRCode:result success:^(HDAnalysisQRCodeRspModel *_Nonnull rspModel) {
        //            @HDStrongify(self);
        [HDTips hideAllTips];
        if (PNTransTypeConsume == rspModel.tradeType) {
        } else if (PNTransTypeTransfer == rspModel.tradeType) {
            PNTransAmountViewController *vc = [[PNTransAmountViewController alloc] init];
            vc.cy = rspModel.orderAmt.cy;
            vc.pageType = PNTradeSubTradeTypeToCoolCash;
            vc.qrData = result;

            HDPayeeInfoModel *payeeInfo = [[HDPayeeInfoModel alloc] initWithAnalysisQRCodeModel:rspModel];
            payeeInfo.payeeLoginName = rspModel.payeeNo;
            vc.payeeInfo = payeeInfo;

            [SAWindowManager navigateToViewController:vc];
        }
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        [HDTips hideAllTips];
    }];
}

// 检查钱包开通状态
- (void)checkPayNowWasStandbyCompletion:(void (^)(void))completion {
    if (![SAUser hasSignedIn]) {
        @HDWeakify(self);
        [SAWindowManager switchWindowToLoginViewControllerWithLoginToDoEvent:^{
            @HDStrongify(self);
            [self checkPayNowWasStandbyCompletion:completion];
        }];
    } else {
        [SAWindowManager navigateToSetPhoneViewControllerWithText:[NSString stringWithFormat:SALocalizedString(@"login_new2_tip10",
                                                                                                               @"您将使用的 %@ 功能，需要您设置手机号码。请放心，手机号码经加密保护，不会对外泄露。"),
                                                                                             SALocalizedString(@"login_new2_Payment", @"支付")] bindSuccessBlock:^{
            [SAWalletManager adjustShouldSettingPayPwdCompletion:^(BOOL needSetting, BOOL isSuccess) {
                if (isSuccess) {
                    // 需要登录，已登录，需支付密码
                    PNUserDTO *userDTO = PNUserDTO.new;
                    [userDTO getPayNowUserInfoSuccess:^(HDUserInfoRspModel *_Nonnull rspModel) {
                        completion();
                    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
                        HDLog(@"💣💣💣查询支付用户接口失败");
                    }];

                } else {
                    HDLog(@"💣💣💣需要支付密码，但支付密码失败了或无支付密码，不处理");
                }
            }];
        }
                                                  cancelBindBlock:nil];
    }
}

@end
