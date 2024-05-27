//
//  SABaseCapacity.m
//  SuperApp
//
//  Created by seeu on 2020/7/1.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAPaymentCapacityResponse.h"
#import "HDCheckStandViewController.h"
#import "HDMediator+SuperApp.h"
#import "SAEnum.h"
#import "SAMoneyModel.h"
#import "SAOrderDTO.h"
#import "SAQueryOrderInfoRspModel.h"
#import "SAWindowManager.h"
#import "UIView+NAT.h"
#import "WMOrderSubmitRspModel.h"
#import <HDUIKit/NAT.h>
#import "HDCheckStandChoosePaymentMethodViewModel.h"
#import "SAPayHelper.h"
#import "WXApiManager.h"
#import "SAWechatPayRequestModel.h"
#import "HDCheckstandWebViewController.h"
#import "PNPaymentComfirmViewController.h"
#import "LKDataRecord.h"

//针对汇旺不支持模拟器
#if !TARGET_IPHONE_SIMULATOR

#import <HuionePaySDK_iOS/HuionePaySDK_iOS.h>
#import "RRMerchantManager.h"

#endif


@interface SAPaymentCapacityResponse () <HDCheckStandViewControllerDelegate, PNPaymentComfirmViewControllerDelegate>
/// 支付回调 key
@property (nonatomic, copy) NSString *orderPayCallbackKey;
///< orderDTO
@property (nonatomic, strong) SAOrderDTO *orderDTO;
///< vm
@property (nonatomic, strong) HDCheckStandChoosePaymentMethodViewModel *viewModel;

@end


@implementation SAPaymentCapacityResponse

- (instancetype)init {
    self = [super init];
    if (self) {
        //        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(clearCommand:) name:@"kNotificationNameCashierWebViewClose" object:nil];

        // 监听微信支付返回
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(appDidReceivedWechatPayResult:) name:kNotificationWechatPayOnResponse object:nil];
        // 监听太子银行返回
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(appDidReceivePrinceBankPayResult:) name:kNotificationNamePrinceBankResp object:nil];

#if !TARGET_IPHONE_SIMULATOR
        // 监听汇旺支付返回
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(appDidReceiveHuiOnePayResult:) name:kNotificationNameHuiOneResp object:nil];
#endif
    }
    return self;
}

- (void)dealloc {
    //    [NSNotificationCenter.defaultCenter removeObserver:self name:@"kNotificationNameCashierWebViewClose" object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationWechatPayOnResponse object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNamePrinceBankResp object:nil];
#if !TARGET_IPHONE_SIMULATOR
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameHuiOneResp object:nil];
#endif
}

+ (NSDictionary<NSString *, NSString *> *)supportActionList {
    return @{
        @"payOrder_$": kHDWHResponseMethodOn,        ///< 订单支付
        @"queryOrderState_$": kHDWHResponseMethodOn, ///< 查询订单支付状态
        @"applePay_$": kHDWHResponseMethodOff
    };
}

wh_doc_begin(payOrder_$, "订单支付");
wh_doc_param(orderNo, "中台订单号");
wh_doc_code(window.webViewHost.invoke(
    "payOrder", {"orderNo": "xxxxx"}, function(params) { alert('订单支付回调:' + JSON.stringify(params)); }));
wh_doc_code_expect("支付完成，跳转订单详情");
wh_doc_end;
- (void)payOrder:(NSDictionary *)paramDict callback:(NSString *)callBackKey {
    if (!SAUser.hasSignedIn) {
        [self.webViewHost fireCallback:callBackKey actionName:@"payOrder" code:HDWHRespCodeUserNotSignedIn type:HDWHCallbackTypeFail
                                params:@{@"reason": SALocalizedString(@"user_not_login", @"用户未登录")}];
        [SAWindowManager switchWindowToLoginViewController];
        return;
    }

    NSString *outPayOrderNo = paramDict[@"orderNo"]; //非中台订单

    NSString *aggregateOrderNo = paramDict[@"aggregateOrderNo"]; //中台订单

    if (HDIsStringEmpty(outPayOrderNo) && HDIsStringEmpty(aggregateOrderNo)) {
        if (HDIsStringEmpty(outPayOrderNo)) {
            [self.webViewHost fireCallback:callBackKey actionName:@"payOrder" code:HDWHRespCodeIllegalArg type:HDWHCallbackTypeFail params:@{@"illegalArg": @"orderNo"}];
        } else {
            [self.webViewHost fireCallback:callBackKey actionName:@"payOrder" code:HDWHRespCodeIllegalArg type:HDWHCallbackTypeFail params:@{@"illegalArg": @"aggregateOrderNo"}];
        }
        return;
    }
    //    NSString *payAmount = paramDict[@"amount"];
    //    if (HDIsStringEmpty(payAmount)) {
    //        [self.webViewHost fireCallback:callBackKey actionName:@"payOrder" code:HDWHRespCodeIllegalArg type:HDWHCallbackTypeFail params:@{@"illegalArg": @"amount"}];
    //        return;
    //    }
    //    NSString *currency = paramDict[@"currency"];
    //    if (HDIsStringEmpty(currency)) {
    //        [self.webViewHost fireCallback:callBackKey actionName:@"payOrder" code:HDWHRespCodeIllegalArg type:HDWHCallbackTypeFail params:@{@"illegalArg": @"currency"}];
    //        return;
    //    }

    self.orderPayCallbackKey = callBackKey;
    NSString *toolCode = paramDict[@"toolCode"]; //支付方式
    if (!HDIsObjectNil(toolCode) && ![toolCode isKindOfClass:NSString.class]) {
        toolCode = [NSString stringWithFormat:@"%@", toolCode];
    }


    @HDWeakify(self);
    [SAWindowManager navigateToSetPhoneViewControllerWithText:[NSString stringWithFormat:SALocalizedString(@"login_new2_tip10",
                                                                                                           @"您将使用的 %@ 功能，需要您设置手机号码。请放心，手机号码经加密保护，不会对外泄露。"),
                                                                                         SALocalizedString(@"login_new2_Payment", @"支付")] bindSuccessBlock:^{
        @HDStrongify(self);
        @HDWeakify(self);
        [self.orderDTO queryOrderInfoWithOrderNo:aggregateOrderNo outPayOrderNo:outPayOrderNo success:^(SAQueryOrderInfoRspModel *_Nonnull rspModel) {
            @HDStrongify(self);

            if (HDIsStringNotEmpty(toolCode)) {
                self.viewModel = HDCheckStandChoosePaymentMethodViewModel.new;
                self.viewModel.orderNo = rspModel.aggregateOrderNo;
                self.viewModel.payableAmount = rspModel.totalPayableAmount;
                self.viewModel.businessLine = rspModel.businessLine;
                self.viewModel.merchantNo = rspModel.merchantNo;
                self.viewModel.storeNo = rspModel.storeId;

                HDPaymentMethodType *paymentMethod = HDPaymentMethodType.new;
                paymentMethod.method = SAOrderPaymentTypeOnline;
                paymentMethod.toolCode = toolCode;

                self.viewModel.lastChoosedMethod = paymentMethod;


                //创建支付订单
                [self.webViewHost showloading];
                [self _createPaymentOrderAndSubmitWithCallback:callBackKey];
            } else {
                HDTradeBuildOrderModel *buildModel = [HDTradeBuildOrderModel new];
                buildModel.orderNo = rspModel.aggregateOrderNo;
                buildModel.payableAmount = rspModel.totalPayableAmount;
                buildModel.businessLine = rspModel.businessLine;
                buildModel.merchantNo = rspModel.merchantNo;
                buildModel.storeNo = rspModel.storeId;
                buildModel.outPayOrderNo = outPayOrderNo;
                buildModel.associatedObject = @{@"callBackKey": callBackKey};

                HDCheckStandViewController *checkStandVC = [[HDCheckStandViewController alloc] initWithTradeBuildModel:buildModel preferedHeight:0];
                checkStandVC.resultDelegate = self;

                [self.webViewHost presentViewController:checkStandVC animated:YES completion:nil];
            }
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self.webViewHost fireCallback:callBackKey actionName:@"payOrder" code:HDWHRespCodeCommonFailed type:HDWHCallbackTypeFail params:@{@"reason": rspModel.msg}];
        }];
    } cancelBindBlock:^{
        @HDStrongify(self);
        [self.webViewHost fireCallback:self.orderPayCallbackKey actionName:@"payOrder" code:HDWHRespCodeUserCancel type:HDWHCallbackTypeCancel params:@{@"reason": @"user cancel"}];
    }];
}

wh_doc_begin(queryOrderState_$, "查询订单支付状态");
wh_doc_param(orderNo, "中台订单号");
wh_doc_code(window.webViewHost.invoke(
    "queryOrderState", {"orderNo": "000000"}, function(params) { alert('订单支付状态查询回调:' + JSON.stringify(params)); }));
wh_doc_end;
- (void)queryOrderState:(NSDictionary *)paramDict callback:(NSString *)callBackKey {
    if (!SAUser.hasSignedIn) {
        [self.webViewHost fireCallback:callBackKey actionName:@"phoneChargePay" code:HDWHRespCodeCommonFailed type:HDWHCallbackTypeFail
                                params:@{@"reason": SALocalizedString(@"user_not_login", @"用户未登录")}];
        [SAWindowManager switchWindowToLoginViewController];
        return;
    }
    [self.webViewHost fireCallback:callBackKey actionName:@"queryOrderState" code:HDWHRespCodeCommonFailed type:HDWHCallbackTypeSuccess params:@{@"orderState": @"1"}];
}

wh_doc_begin(applePay_$, "applepay");
wh_doc_param(orderNo, "支付单号");
wh_doc_param(productId, "商品编号");
wh_doc_end;
//- (void)applePay:(NSDictionary *)paramDict callback:(NSString *)callBackKey {
//    if (!SAUser.hasSignedIn) {
//        [self.webViewHost fireCallback:callBackKey
//                            actionName:@"phoneChargePay"
//                                  code:HDWHRespCodeCommonFailed
//                                  type:HDWHCallbackTypeFail
//                                params:@{@"reason" : SALocalizedString(@"user_not_login", @"用户未登录")}];
//        [SAWindowManager switchWindowToLoginViewController];
//        return;
//    }
//
//    NSString *outPayOrderNo = paramDict[@"orderNo"];
//    if (HDIsStringEmpty(outPayOrderNo)) {
//        [self.webViewHost fireCallback:callBackKey actionName:@"applePay" code:HDWHRespCodeIllegalArg type:HDWHCallbackTypeFail params:@{@"illegalArg" : @"orderNo"}];
//        return;
//    }
//    NSString *productId = paramDict[@"productId"];
//    if (HDIsStringEmpty(productId)) {
//        [self.webViewHost fireCallback:callBackKey actionName:@"applePay" code:HDWHRespCodeIllegalArg type:HDWHCallbackTypeFail params:@{@"illegalArg" : @"productId"}];
//        return;
//    }
//
//    NSInteger quantity = [paramDict[@"quantity"] integerValue];
//    if (quantity <= 0) {
//        [self.webViewHost fireCallback:callBackKey actionName:@"applePay" code:HDWHRespCodeIllegalArg type:HDWHCallbackTypeFail params:@{@"illegalArg" : @"quantity"}];
//        return;
//    }
//
//    //    NSDictionary *userInfo = paramDict[@"userInfo"];
//    @HDWeakify(self);
//    [ApplePayManager.shared requestPaymentWithOrderNo:outPayOrderNo
//                                            productId:productId
//                                             quantity:quantity
//                                             userInfo:@{@"callBackKey" : callBackKey}
//                                           completion:^(NSInteger rspCode, NSDictionary *_Nonnull userInfo) {
//                                               @HDStrongify(self);
//                                               NSString *key = userInfo[@"callBackKey"];
//                                               if (0 == rspCode) {
//                                                   [self.webViewHost fireCallback:key actionName:@"applePay" code:HDWHRespCodeSuccess type:HDWHCallbackTypeSuccess params:@{}];
//                                               } else {
//                                                   [self.webViewHost fireCallback:key actionName:@"applePay" code:HDWHRespCodeCommonFailed type:HDWHCallbackTypeFail params:@{@"reason" : @"error"}];
//                                               }
//                                           }];
//}

#pragma mark - Notification
- (void)appDidReceivedWechatPayResult:(NSNotification *)notification {
    // 取出返回数据
    PayResp *resp = notification.object;
    HDCheckStandWechatPayResultResp *resultResp = HDCheckStandWechatPayResultResp.new;
    resultResp.errCode = resp.errCode;
    resultResp.errStr = resp.errStr;
    resultResp.returnKey = resp.returnKey;
    resultResp.type = resp.type;

    if (resultResp.errCode == 0) {
        //支付成功
        [self.webViewHost fireCallback:self.orderPayCallbackKey actionName:@"payOrder" code:HDWHRespCodeSuccess type:HDWHCallbackTypeSuccess params:@{}];

    } else if (resultResp.errCode == -2) {
        // 支付取消
        [self.webViewHost fireCallback:self.orderPayCallbackKey actionName:@"payOrder" code:HDWHRespCodeUserCancel type:HDWHCallbackTypeCancel params:@{@"reason": @"user cancel"}];
    } else {
        // 支付失败
        NSString *tipStr = HDIsStringNotEmpty(resultResp.errStr) ? resultResp.errStr : SALocalizedString(@"pay_failure_try_again", @"支付失败，请重试");
        [self.webViewHost fireCallback:self.orderPayCallbackKey actionName:@"payOrder" code:HDWHRespCodeCommonFailed type:HDWHCallbackTypeFail params:@{@"reason": tipStr}];
    }
}

- (void)appDidReceivePrinceBankPayResult:(NSNotification *)notification {
    NSString *status = notification.object;
    if (HDIsStringNotEmpty(status) && [status isEqualToString:@"1"]) {
        // 支付成功
        [self.webViewHost fireCallback:self.orderPayCallbackKey actionName:@"payOrder" code:HDWHRespCodeSuccess type:HDWHCallbackTypeSuccess params:@{}];

    } else {
        // 支付取消
        [self.webViewHost fireCallback:self.orderPayCallbackKey actionName:@"payOrder" code:HDWHRespCodeUserCancel type:HDWHCallbackTypeCancel params:@{@"reason": @"user cancel"}];
    }
}

- (void)appDidReceiveHuiOnePayResult:(NSNotification *)notification {
    HDLog(@"汇旺支付回调了");
    /// code=5000&msg=[object Object]
    /// code=5001&msg=用户中途取消
    /// code=5005&msg=正在处理中，支付结果未知，请查询商户订单列表中订单的支付状态
    NSInteger code = [notification.object integerValue];

    if (code == 5005 || code == 5000) { //正在处理中
        [self.webViewHost fireCallback:self.orderPayCallbackKey actionName:@"payOrder" code:HDWHRespCodeSuccess type:HDWHCallbackTypeSuccess params:@{}];
    } else {
        // 支付取消
        [self.webViewHost fireCallback:self.orderPayCallbackKey actionName:@"payOrder" code:HDWHRespCodeUserCancel type:HDWHCallbackTypeCancel params:@{@"reason": @"user cancel"}];
    }
}

#pragma mark - private methods
- (void)_createPaymentOrderAndSubmitWithCallback:(NSString *)callBackKey {
    @HDWeakify(self);
    [self.viewModel createPayOrderWithOrderNo:self.viewModel.orderNo trialId:nil payableAmount:self.viewModel.payableAmount discountAmount:nil success:^(HDCreatePayOrderRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.viewModel.outPayOrderNo = rspModel.outPayOrderNo;

        if ([self.viewModel.lastChoosedMethod.toolCode isEqualToString:HDCheckStandPaymentToolsBalance]) {
            [self.webViewHost dismissLoading];
            [self _goToWalletPaymentComfirm:rspModel.outPayOrderNo];
        } else {
            //支付
            [self _submitPaymentWithCallback:callBackKey];
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.webViewHost dismissLoading];
        [self.webViewHost fireCallback:callBackKey actionName:@"payOrder" code:HDWHRespCodeCommonFailed type:HDWHCallbackTypeFail params:@{@"reason": @"init fail!"}];
    }];
}

- (void)_submitPaymentWithCallback:(NSString *)callBackKey {
    @HDWeakify(self);
    [self.viewModel submitPaymentParamsWithPaymentTools:self.viewModel.lastChoosedMethod.toolCode
                                                orderNo:self.viewModel.orderNo
                                          outPayOrderNo:self.viewModel.outPayOrderNo
        success:^(HDCheckStandOrderSubmitParamsRspModel *_Nonnull rspModel) {
            @HDStrongify(self);
            [self _handlingSuccessSubmitPaymentParamsWithRspModel:rspModel callback:callBackKey];
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self.webViewHost dismissLoading];
            [self.webViewHost fireCallback:callBackKey actionName:@"payOrder" code:HDWHRespCodeCommonFailed type:HDWHCallbackTypeFail params:@{@"reason": @"init fail!"}];
        }];
}

- (void)_handlingSuccessSubmitPaymentParamsWithRspModel:(HDCheckStandOrderSubmitParamsRspModel *)rspModel callback:(NSString *)callBackKey {
    // 根据 payWay 生成 payResult 模型

    [self.webViewHost dismissLoading];

    NSString *toolCode = self.viewModel.lastChoosedMethod.toolCode;

    if ([toolCode isEqualToString:HDCheckStandPaymentToolsWechat]) {
        void (^paymentFailWithMsgBlock)(NSString *_Nullable, HDCheckStandPayResultErrorType) = ^(NSString *errorMsg, HDCheckStandPayResultErrorType errorCode) {
            [self.webViewHost fireCallback:callBackKey actionName:@"payOrder" code:HDWHRespCodeSuccess type:HDWHCallbackTypeSuccess params:@{}];
        };

        // 先判断是否安装微信
        BOOL isSupported = [SAPayHelper isSupportWechatPayAppNotInstalledHandler:^{
            [NAT showToastWithTitle:SALocalizedString(@"not_install_wechat", @"未安装微信") content:nil type:HDTopToastTypeError];
            paymentFailWithMsgBlock(SALocalizedString(@"not_install_wechat", @"未安装微信"), HDCheckStandPayResultErrorTypeAppNotInstalled);
        } appNotSupportApiHandler:^{
            [NAT showToastWithTitle:SALocalizedString(@"wechat_not_support", @"当前微信版本不支持此功能") content:nil type:HDTopToastTypeError];
            paymentFailWithMsgBlock(SALocalizedString(@"wechat_not_support", @"当前微信版本不支持此功能"), HDCheckStandPayResultErrorTypeAppApiNotSupport);
        }];
        if (isSupported) {
            NSDictionary *payResultDict = rspModel.payUrl.hd_dictionary;
            SAWechatPayRequestModel *requestModel = [SAWechatPayRequestModel yy_modelWithJSON:payResultDict];
            if (!payResultDict || !requestModel) {
                [NAT showToastWithTitle:SALocalizedString(@"invalid_payment_parameters", @"支付参数无效") content:nil type:HDTopToastTypeError];
                paymentFailWithMsgBlock(SALocalizedString(@"invalid_payment_parameters", @"支付参数无效"), HDCheckStandPayResultErrorTypeAppParamsInValid);
            } else {
                [WXApiManager.sharedManager sendPayReq:requestModel];
            }
        }
    } else if ([toolCode isEqualToString:HDCheckStandPaymentToolsABAPay]) {
        HDLog(@"ABA支付:%@", [NSURL URLWithString:[rspModel.deeplink hd_URLEncodedString]]);
        if (HDIsStringNotEmpty(rspModel.deeplink)) {
            if ([UIApplication.sharedApplication canOpenURL:[NSURL URLWithString:[rspModel.deeplink hd_URLEncodedString]]]) {
                //延时0.25，处理偶发不弹等待支付结果loading
                [UIApplication.sharedApplication openURL:[NSURL URLWithString:[rspModel.deeplink hd_URLEncodedString]] options:@{} completionHandler:^(BOOL success) {
                    if (!success) {
                        [HDSystemCapabilityUtil gotoAppStoreForAppID:@"968860649"];
                    }
                }];
            } else {
                [HDSystemCapabilityUtil gotoAppStoreForAppID:@"968860649"];
            }
            [self.webViewHost fireCallback:callBackKey actionName:@"payOrder" code:HDWHRespCodeSuccess type:HDWHCallbackTypeSuccess params:@{}];
        } else {
            [self _openInWebviewWithUrl:rspModel.payUrl callback:callBackKey];
        }
    } else if ([toolCode isEqualToString:HDCheckStandPaymentToolsWing]) {
        [self _openInWebviewWithUrl:rspModel.payUrl callback:callBackKey];

    } else if ([toolCode isEqualToString:HDCheckStandPaymentToolsCredit]) {
        [self _openInWebviewWithUrl:[rspModel.payUrl stringByAppendingFormat:@"/%@", SAUser.shared.loginName] callback:callBackKey];

    } else if ([toolCode isEqualToString:HDCheckStandPaymentToolsSmartPay]) {
        [self _openInWebviewWithUrl:rspModel.payUrl callback:callBackKey];
        
    }
//    else if([toolCode isEqualToString:HDCheckStandPaymentToolsAlipayPlus]) {
//        [self _openInWebviewWithUrl:rspModel.deeplink callback:callBackKey];
//
//    }
#if !TARGET_IPHONE_SIMULATOR
    else if ([toolCode isEqualToString:HDCheckStandPaymentToolsPrince]) {
        // 太子银行
        if (HDIsStringNotEmpty(rspModel.tokenStr)) {
            if ([UIApplication.sharedApplication canOpenURL:[NSURL URLWithString:@"xdbank://rrpay"]]) {
                [[RRMerchantManager shared] openPrinceBankWithOrder:rspModel.tokenStr];
            } else {
                [self.webViewHost fireCallback:callBackKey actionName:@"payOrder" code:HDWHRespCodeSuccess type:HDWHCallbackTypeSuccess params:@{}];
                [HDSystemCapabilityUtil gotoAppStoreForAppID:@"1480524848"];
            }
        } else {
            [self.webViewHost fireCallback:callBackKey actionName:@"payOrder" code:HDWHRespCodeSuccess type:HDWHCallbackTypeSuccess params:@{}];
        }
    } else if ([toolCode isEqualToString:HDCheckStandPaymentToolsHuiOneV2]) {
        if(HDIsStringNotEmpty(rspModel.deeplink)) {
            NSDictionary *params = [rspModel.deeplink hd_dictionary];
            NSString *iOSParamStr = [params objectForKey:@"iOS"];
            NSString *data = [[iOSParamStr hd_dictionary] objectForKey:@"data"];
            NSString *payOrder = [[data hd_dictionary] objectForKey:@"outTradeNo"];
            
            @HDWeakify(self);
            [HuionePaySDK pay:payOrder name:@"huione2" callback:^(NSString * _Nonnull error) {
                @HDStrongify(self);
                if(HDIsStringNotEmpty(error)) {
                    HDLog(@"汇旺拉起异常:%@", error);
                    [LKDataRecord.shared traceEvent:@"@DEBUG" name:@"H5拉起汇旺SDKV2失败"
                                         parameters:@{@"resultDic": error, @"carriers": [HDDeviceInfo getCarrierName], @"network": [HDDeviceInfo getNetworkType]}
                                                SPM:nil];
                    //没安装汇旺app跳转到应用市场
                    [HDSystemCapabilityUtil gotoAppStoreForAppID:@"1177980631"];
                    [self.webViewHost fireCallback:callBackKey actionName:@"payOrder" code:HDWHRespCodeSuccess type:HDWHCallbackTypeSuccess params:@{}];
                }
            }];
            
        } else {
            [self.webViewHost fireCallback:callBackKey actionName:@"payOrder" code:HDWHRespCodeSuccess type:HDWHCallbackTypeSuccess params:@{}];
        }
    }
#endif
    else if ([toolCode isEqualToString:HDCheckStandPaymentToolsACLEDABank]) {
        HDLog(@"ACLEDA BANK支付:%@", [NSURL URLWithString:[rspModel.deeplink hd_URLEncodedString]]);
        if (HDIsStringNotEmpty(rspModel.deeplink)) {
            if ([UIApplication.sharedApplication canOpenURL:[NSURL URLWithString:[rspModel.deeplink hd_URLEncodedString]]]) {
                //延时0.25，处理偶发不弹等待支付结果loading
                [UIApplication.sharedApplication openURL:[NSURL URLWithString:[rspModel.deeplink hd_URLEncodedString]] options:@{} completionHandler:^(BOOL success) {
                    if (!success) {
                        [HDSystemCapabilityUtil gotoAppStoreForAppID:@"1196285236"];
                    }
                }];

            } else {
                [HDSystemCapabilityUtil gotoAppStoreForAppID:@"1196285236"];
            }
            [self.webViewHost fireCallback:callBackKey actionName:@"payOrder" code:HDWHRespCodeSuccess type:HDWHCallbackTypeSuccess params:@{}];
        } else {
            [self.webViewHost fireCallback:callBackKey actionName:@"payOrder" code:HDWHRespCodeCommonFailed type:HDWHCallbackTypeFail params:@{@"reason": @"init fail!"}];
        }
    } else if ([toolCode isEqualToString:HDCheckStandPaymentToolsABAKHQR]) {
        HDLog(@"ABAKHQR支付:%@", [NSURL URLWithString:[rspModel.deeplink hd_URLEncodedString]]);
        //优先app拉起H5的aba khqr网页
        if(HDIsStringNotEmpty(rspModel.checkoutQrUrl)){
            [self _openInWebviewWithUrl:rspModel.checkoutQrUrl callback:callBackKey];
        }
        //如果能拉起ABA app接着拉起aba app
        if (HDIsStringNotEmpty(rspModel.deeplink)) {
            if ([UIApplication.sharedApplication canOpenURL:[NSURL URLWithString:[rspModel.deeplink hd_URLEncodedString]]]) {
                [UIApplication.sharedApplication openURL:[NSURL URLWithString:[rspModel.deeplink hd_URLEncodedString]] options:@{} completionHandler:nil];
            }
        }
    }
}

- (void)_openInWebviewWithUrl:(NSString *)url callback:(NSString *)callBackKey {
    HDCheckstandWebViewController *webVC = [[HDCheckstandWebViewController alloc] init];
    webVC.url = url;
    @HDWeakify(self);
    webVC.closeByUser = ^{
        HDLog(@"用户关闭啦");
        @HDStrongify(self);
        [self.webViewHost fireCallback:callBackKey actionName:@"payOrder" code:HDWHRespCodeSuccess type:HDWHCallbackTypeSuccess params:@{}];
    };
    [SAWindowManager navigateToViewController:webVC];
}

#pragma mark 钱包支付确认页
- (void)_goToWalletPaymentComfirm:(NSString *)tradeNo {
    PNPaymentBuildModel *buildModel = [[PNPaymentBuildModel alloc] init];
    buildModel.tradeNo = tradeNo;
    buildModel.fromType = PNPaymentBuildFromType_Middle;
    buildModel.payWay = HDCheckStandPaymentToolsBalance;

    PNPaymentComfirmViewController *vc = [[PNPaymentComfirmViewController alloc] initWithRouteParameters:@{@"data": [buildModel yy_modelToJSONData]}];
    vc.delegate = self;
    [self.webViewHost.navigationController pushViewController:vc animated:YES];
}

//- (void)clearCommand:(NSNotification *)nofitication {
//    [self.webViewHost fireCallback:self.orderPayCallbackKey actionName:@"payOrder" code:HDWHRespCodeUserCancel type:HDWHCallbackTypeCancel params:@{@"reason": @"user cancel"}];
//}

#pragma mark - PNPaymentComfirmViewControllerDelegate
/// 支付成功的回调
- (void)paymentSuccess:(PayHDTradeSubmitPaymentRspModel *)rspModel controller:(PNPaymentComfirmViewController *)controller {
    [self.webViewHost fireCallback:self.orderPayCallbackKey actionName:@"payOrder" code:HDWHRespCodeSuccess type:HDWHCallbackTypeSuccess params:@{}];
    [controller removeFromParentViewController];
}

/// 支付失败的回调
- (void)paymentFaild:(NSString *)errorCode message:(NSString *)message tradeNo:(NSString *)tradeNo controller:(PNPaymentComfirmViewController *)controller {
    NSString *tipStr = HDIsStringNotEmpty(message) ? message : SALocalizedString(@"pay_failure_try_again", @"支付失败，请重试");
    [self.webViewHost fireCallback:self.orderPayCallbackKey actionName:@"payOrder" code:HDWHRespCodeCommonFailed type:HDWHCallbackTypeFail params:@{@"reason": tipStr}];
}

/// 主动点击了返回
- (void)userGoBack:(PNPaymentComfirmViewController *)controller {
    [self.webViewHost fireCallback:self.orderPayCallbackKey actionName:@"payOrder" code:HDWHRespCodeUserCancel type:HDWHCallbackTypeCancel params:@{@"reason": @"user cancel"}];
}

#pragma mark - HDCheckStandViewControllerDelegate
- (void)checkStandViewControllerInitializeFailed:(HDCheckStandViewController *)controller {
    [self.webViewHost fireCallback:controller.associatedObject[@"callBackKey"] actionName:@"payOrder" code:HDWHRespCodeCommonFailed type:HDWHCallbackTypeFail params:@{@"reason": @"init fail!"}];
}

- (void)checkStandViewControllerCompletedAndPaymentUnknow:(HDCheckStandViewController *)controller {
    [self.webViewHost fireCallback:controller.associatedObject[@"callBackKey"] actionName:@"payOrder" code:HDWHRespCodeSuccess type:HDWHCallbackTypeSuccess params:@{}];
}

- (void)checkStandViewController:(HDCheckStandViewController *)controller paymentSuccess:(HDCheckStandPayResultResp *)resultResp {
    @HDWeakify(self);
    [controller dismissViewControllerAnimated:true completion:^{
        @HDStrongify(self);
        [self.webViewHost fireCallback:controller.associatedObject[@"callBackKey"] actionName:@"payOrder" code:HDWHRespCodeSuccess type:HDWHCallbackTypeSuccess params:@{}];
    }];
}

- (void)checkStandViewController:(HDCheckStandViewController *)controller failureWithRspModel:(SARspModel *_Nullable)rspModel errorType:(CMResponseErrorType)errorType error:(NSError *_Nullable)error {
    NSString *tipStr = HDIsStringNotEmpty(rspModel.msg) ? rspModel.msg : SALocalizedString(@"pay_failure_try_again", @"支付失败，请重试");
    [NAT showToastWithTitle:tipStr content:nil type:HDTopToastTypeError];

    if ([rspModel.code isEqualToString:@"O2052"]) {
        [self.webViewHost fireCallback:controller.associatedObject[@"callBackKey"] actionName:@"payOrder" code:HDWHRespCodeUserNotSignedIn type:HDWHCallbackTypeFail
                                params:@{@"reason": SALocalizedString(@"user_not_login", @"用户未登录")}];
        return;
    }
}

- (void)checkStandViewController:(HDCheckStandViewController *)controller paymentFail:(nonnull HDCheckStandPayResultResp *)resultResp {
    NSString *tipStr = HDIsStringNotEmpty(resultResp.errStr) ? resultResp.errStr : SALocalizedString(@"pay_failure_try_again", @"支付失败，请重试");
    @HDWeakify(self);
    [controller dismissViewControllerCompletion:^{
        @HDStrongify(self);
        [self.webViewHost fireCallback:controller.associatedObject[@"callBackKey"] actionName:@"payOrder" code:HDWHRespCodeCommonFailed type:HDWHCallbackTypeFail params:@{@"reason": tipStr}];
    }];
}

- (void)checkStandViewControllerUserClosedCheckStand:(HDCheckStandViewController *)controller {
    @HDWeakify(self);
    [controller dismissViewControllerAnimated:true completion:^{
        @HDStrongify(self);
        [self.webViewHost fireCallback:controller.associatedObject[@"callBackKey"] actionName:@"payOrder" code:HDWHRespCodeUserCancel type:HDWHCallbackTypeCancel params:@{@"reason": @"user cancel"}];
    }];
}

#pragma mark - lazy load
/** @lazy orderDTO */
- (SAOrderDTO *)orderDTO {
    if (!_orderDTO) {
        _orderDTO = [[SAOrderDTO alloc] init];
    }
    return _orderDTO;
}

@end
