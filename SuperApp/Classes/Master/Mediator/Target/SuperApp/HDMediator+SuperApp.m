//
//  HDMediator+SuperApp.m
//  SuperApp
//
//  Created by VanJay on 2020/6/12.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDMediator+SuperApp.h"
#import "SAAppEnvManager.h"


@implementation HDMediator (SuperApp)

- (void)navigaveToSettingsViewController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"navigaveToSettingsViewController" params:params];
}

- (void)navigaveToWebViewViewController:(NSDictionary *)params {
    NSString *url = [params valueForKey:@"url"];
    if (HDIsStringEmpty(url)) {
        NSString *path = [params valueForKey:@"path"];
        SAAppEnvConfig *model = SAAppEnvManager.sharedInstance.appEnvConfig;
        url = [NSString stringWithFormat:@"%@%@%@", model.h5URL, [path hasPrefix:@"/"] ? @"" : @"/", path];
    }
    [self performActionWithURL:url];
}

- (void)navigaveToMyInfomationController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"myInformation" params:params];
}

- (void)navigaveToSetNickNameController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"navigaveToSetNickNameController" params:params];
}

- (void)navigaveToEmailController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"navigaveToEmailController" params:params];
}
- (void)navigaveToBindEmailController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"bindEmail" params:params];
}

- (void)navigaveToSetPhoneController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"setPhone" params:params];
}

- (void)navigaveToSuggestionViewController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"appSuggestion" params:params];
}

- (void)navigaveToYumNowController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"YumNow" params:params];
}

- (void)navigaveToTinhNowController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"TinhNow" params:params];
}

- (void)navigaveToTopUpDetailViewController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"navigaveToTopUpDetailViewController" params:params];
}

- (void)navigaveToTopUpRefundDetailViewController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"navigaveToTopUpRefundDetailViewController" params:params];
}

- (void)navigaveToCommonRefundDetailViewController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"commonRefundDetail" params:params];
}

- (void)navigaveToRefundDestinationViewController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"navigaveToRefundDestinationViewController" params:params];
}

- (void)navigaveToMyCouponsViewController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"myCouponList" params:params];
}

- (void)navigaveToLoginViewController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"login" params:params];
}

- (void)navigaveToWalletViewController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"wallet" params:params];
}

- (void)navigaveToSettingPayPwdViewController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"navigaveToSettingPayPwdViewController" params:params];
}

- (void)navigaveToWalletChargeViewController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"navigaveToWalletChargeViewController" params:params];
}

- (void)navigaveToWalletBillListViewController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"navigaveToWalletBillListViewController" params:params];
}

- (void)navigaveToWalletBillDetailViewController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"navigaveToWalletBillDetailViewController" params:params];
}

- (void)navigaveToChooseMyAddressViewController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"navigaveToChooseMyAddressViewController" params:params];
}

- (void)navigaveToSettingPwdOptionViewController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"navigaveToSettingPwdOptionViewController" params:params];
}

- (void)navigaveToWalletChargeResultViewController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"navigaveToWalletChargeResultViewController" params:params];
}

- (void)navigaveToWalletChangePayPwdAskingViewController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"navigaveToWalletChangePayPwdAskingViewController" params:params];
}

- (void)navigaveToWalletChangePayPwdInputSMSCodeViewController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"navigaveToWalletChangePayPwdInputSMSCodeViewController" params:params];
}


- (void)navigaveToCheckstandWebViewController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"navigaveToCheckstandWebViewController" params:params];
}

- (void)navigaveToCheckStandPayResultViewController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"CashierResult" params:params];
}

- (void)navigaveToStoreFavoriteViewController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"storeFavorite" params:params];
}

- (void)navigaveToSystemMessageViewController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"systemMessageList" params:params];
}

- (void)navigaveToIMViewController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"im" params:params];
}

- (void)navigaveToCouponRedemptionViewController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"couponRedemptionList" params:params];
}

- (void)navigaveToChooseZoneViewController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"navigaveToChooseZoneViewController" params:params];
}

- (void)navigaveToScanViewController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"scanQRCode" params:params];
}

- (void)navigaveToChooseAddressInMapViewController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"chooseAddressInMap" params:params];
}

- (void)navigaveToChatViewController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"openChatViewController" params:params];
}

- (void)navigaveToCallAccountViewController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"callTest" params:params];
}

- (void)navigaveToAudioCallViewController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"audioCall" params:params];
}

- (void)navigaveToVideoCallViewController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"videoCall" params:params];
}

- (void)navigaveToShoppingAddressViewController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"address" params:params];
}

- (void)navigaveToMessagesViewController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"navigaveToMessagesViewController" params:params];
}

- (void)navigaveToCommonOrderDetails:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"commonOrderDetails" params:params];
}

- (void)navigaveToBillPaymentDetails:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"userBillPaymentDetails" params:params];
}
- (void)navigaveToBillRefundDetails:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"userBillRefundDetails" params:params];
}

- (void)navigaveToWaitPayResultViewController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"waitPayResult" params:params];
}

- (void)navigaveToCancellationApplication:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"cancellationApplication" params:params];
}

- (void)navigaveToOrderList:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"orderList" params:params];
}

#pragma mark -
- (void)showChangeLanguage {
    [self performTarget:@"SuperApp" action:@"changeLanguage" params:nil];
}

- (void)checkAppVersion {
    [self performTarget:@"SuperApp" action:@"checkAppVersion" params:nil];
}

- (void)navigaveToLoginBySMSViewController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"loginBySMS" params:params];
}

- (void)navigaveToLoginWithSMSViewController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"loginWithSMS" params:params];
}

- (void)navigaveToLoginByVerificationCodeViewController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"loginByVerificationCode" params:params];
}

- (void)navigaveToVerificationCodeViewController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"VerificationCode" params:params];
}

- (void)navigaveToForgotPasswordViewController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"forgotPassword" params:params];
}

- (void)navigaveToForgetPasswordOrBindPhoneViewController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"forgetPasswordOrBindPhone" params:params];
}

- (void)navigaveToSetPasswordViewController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"setPassword" params:params];
}

- (void)navigaveToChangeLoginPasswordViewController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"navigaveToChangeLoginPasswordViewController" params:params];
}

- (void)navigaveToSuggestionDetailViewController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"suggestionDetail" params:params];
}

- (void)navigaveToOrderSearch:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"orderSearch" params:params];
}

- (void)navigaveToGroupChat:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"openGroupChatViewController" params:params];
}

- (void)navigaveToImFeedBackViewController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"imFeedBack" params:params];
}

- (void)navigaveToOcrScanViewController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"ocrScan" params:params];
}

- (void)navigaveToChatListViewController:(NSDictionary *)params {
    [self performTarget:@"SuperApp" action:@"chatList" params:params];
}

@end
