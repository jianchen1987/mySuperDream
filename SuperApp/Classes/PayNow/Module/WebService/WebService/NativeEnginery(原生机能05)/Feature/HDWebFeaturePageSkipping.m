//
//  HDWebFeaturePageSkipping.m
//  customer
//
//  Created by 谢泽锋 on 2019/3/5.
//  Copyright © 2019 chaos network technology. All rights reserved.
//
#import "HDWebFeaturePageSkipping.h"
#import "PayHDCheckstandViewController.h"
//#import "HDConsumeResultViewController.h"
#import "HDPayOrderRspModel.h"
#import "OrderResultVC.h"
#import "PayPassWordTip.h"
#import "SAChangePayPwdAskingViewController.h"
#import "SAMoneyModel.h"
#import "SAWindowManager.h"
#import "TalkingData.h"
#import "VipayUser.h"
#import "WQCodeScanner.h"
#import "WalletVC.h"
@interface HDWebFeaturePageSkipping () <PayHDCheckstandViewControllerDelegate>

@property (nonatomic, copy) WebFeatureResponse featureRes;  ///< 回调

@end

@implementation HDWebFeaturePageSkipping

- (void)webFeatureResponseAction:(WebFeatureResponse)webFeatureResponse {
    if (![VipayUser isLogin]) {  //在用户未登录情况下点击广告回到登录页

        [self.viewController.navigationController popViewControllerAnimated:YES];
        return;
    }
    self.featureRes = webFeatureResponse;
    NSDictionary *params = [self.parameter.param objectForKey:@"params"];
    if (params) {
        NSString *oriRouteStr = [params objectForKey:@"url"];
        NSString *routeUrl = [oriRouteStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //        [SAWindowManager openUrl:routeUrl withParameters:@{@"delegateObject": self}];
        //        "vipay://cashier?orderNo=21120282517309&orderAmt=100&orderCy=USD"
        NSArray *arr0 = [routeUrl componentsSeparatedByString:@"?"];
        NSArray *arr1 = [arr0.lastObject componentsSeparatedByString:@"&"];
        NSArray *arr2 = [arr1[0] componentsSeparatedByString:@"="];
        NSArray *arr3 = [arr1[1] componentsSeparatedByString:@"="];
        NSArray *arr4 = [arr1[2] componentsSeparatedByString:@"="];
        NSString *orderNo = arr2.lastObject;
        NSString *orderAmt = arr3.lastObject;
        NSString *orderCy = arr4.lastObject;
        // 唤起收银台
        SAMoneyModel *amountModel = [SAMoneyModel modelWithAmount:orderAmt currency:orderCy];
        PayHDTradeBuildOrderRspModel *buildModel = [PayHDTradeBuildOrderRspModel modelWithOrderAmount:amountModel tradeNo:orderNo];
        PayHDCheckstandViewController *checkStandVC = [PayHDCheckstandViewController checkStandWithTradeBuildModel:buildModel preferedHeight:0];
        checkStandVC.resultDelegate = self;
        [SAWindowManager.visibleViewController presentViewController:checkStandVC animated:YES completion:nil];
    }
}
- (BOOL)shouldGoToResultPageByCode:(NSString *)code {
    if ([GOTO_RESULT_CODE containsString:code]) {
        return YES;
    }

    return NO;
}
#pragma mark - PayHDCheckstandViewControllerDelegate

/**
 支付成功

 @param controller 收银台
 @param rspModel 支付成功返回模型
 */
- (void)checkStandViewController:(PayHDCheckstandViewController *)controller paymentSuccess:(PayHDTradeSubmitPaymentRspModel *)rspModel {

    __weak __typeof(self) weakSelf = self;
    [controller dismissViewControllerCompletion:^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        HDPayOrderRspModel *payOrderRspModel = [HDPayOrderRspModel modelFromTradeSubmitPaymentRspModel:rspModel];
        if (payOrderRspModel.status.integerValue == HDOrderStatusSuccess || payOrderRspModel.status.integerValue == HDOrderStatusProcessing) {
            [strongSelf orderPaySuccess:payOrderRspModel showPaymentResult:controller.showPaymentResult];
        } else {
            [strongSelf orderPayFailure:payOrderRspModel showPaymentResult:controller.showPaymentResult];
        }
    }];
}

/**
 支付失败
 */
- (void)checkStandViewController:(PayHDCheckstandViewController *)controller transactionFailure:(HDBaseViewModel *)viewModel reason:(NSString *)reason code:(NSString *)code {

    __weak __typeof(self) weakSelf = self;

    if ([code containsString:@"V1087"]) {
        [NAT showAlertWithMessage:reason
                      buttonTitle:HDLocalizedString(@"BUTTON_TITLE_REINPUT", @"重新输入", @"")
                          handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                              [controller.textField clear];
                              [controller.textField becomeFirstResponder];
                              [alertView dismiss];
                          }];
    } else if ([code containsString:@"V1007"]) {

        [PayPassWordTip showPayPassWordTipViewToView:[UIApplication sharedApplication].windows.firstObject
            IconImgName:@""
            Detail:reason
            CancelBtnText:@""
            SureBtnText:@""
            SureCallBack:^{
                [controller.textField clear];
                [controller.textField becomeFirstResponder];
            }
            CancelCallBack:^{
                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
                void (^completion)(BOOL, BOOL) = ^(BOOL needSetting, BOOL isSuccess) {
                    [SAWindowManager.visibleViewController.navigationController dismissViewControllerAnimated:YES completion:nil];
                };
                params[@"completion"] = completion;
                void (^clickedRememberBlock)(void) = ^{
                    // 校验旧密码修改密码
                    params[@"actionType"] = @(5);
                    [HDMediator.sharedInstance navigaveToSettingPayPwdViewController:params];
                };
                params[@"clickedRememberBlock"] = clickedRememberBlock;
                void (^clickedForgetBlock)(void) = ^{
                    [HDMediator.sharedInstance navigaveToWalletChangePayPwdInputSMSCodeViewController:params];
                };
                params[@"clickedForgetBlock"] = clickedForgetBlock;
                SAChangePayPwdAskingViewController *vc = [[SAChangePayPwdAskingViewController alloc] initWithRouteParameters:params];
                [SAWindowManager.visibleViewController presentViewController:[[SANavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
            }];
    } else if ([code containsString:@"V1015"]) {  //密码错误
        [PayPassWordTip showPayPassWordTipViewToView:[UIApplication sharedApplication].windows.firstObject
            IconImgName:@""
            Detail:[NSString stringWithFormat:@"%@ %d %@", PNLocalizedString(@"enter_the_rest", @""), [HDCommonUtils getnum:reason], PNLocalizedString(@"Times", @"")]
            CancelBtnText:@""
            SureBtnText:@""
            SureCallBack:^{
                [controller.textField clear];
                [controller.textField becomeFirstResponder];
            }
            CancelCallBack:^{
                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
                void (^completion)(BOOL, BOOL) = ^(BOOL needSetting, BOOL isSuccess) {
                    [SAWindowManager.visibleViewController.navigationController dismissViewControllerAnimated:YES completion:nil];
                };
                params[@"completion"] = completion;
                void (^clickedRememberBlock)(void) = ^{
                    // 校验旧密码修改密码
                    params[@"actionType"] = @(5);
                    [HDMediator.sharedInstance navigaveToSettingPayPwdViewController:params];
                };
                params[@"clickedRememberBlock"] = clickedRememberBlock;
                void (^clickedForgetBlock)(void) = ^{
                    [HDMediator.sharedInstance navigaveToWalletChangePayPwdInputSMSCodeViewController:params];
                };
                params[@"clickedForgetBlock"] = clickedForgetBlock;
                SAChangePayPwdAskingViewController *vc = [[SAChangePayPwdAskingViewController alloc] initWithRouteParameters:params];
                [SAWindowManager.visibleViewController presentViewController:[[SANavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
            }];
    } else if ([code isEqualToString:@"C0011"]) {  //余额不足
        [NAT showAlertWithMessage:reason
                      buttonTitle:HDLocalizedString(@"BUTTON_TITLE_SURE", @"确定", @"")
                          handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                              [alertView dismiss];
                          }];
        //        [NAT showAlertWithMessage:reason
        //            confirmButtonTitle:HDLocalizedString(@"BUTTON_TITLE_GO_TO_RECHARGE", @"去充值", @"")
        //            confirmButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
        //                [alertView dismissCompletion:^{
        //                    __strong __typeof(weakSelf) strongSelf = weakSelf;
        //                    [controller dismissViewControllerCompletion:^{
        //                        [SAWindowManager openUrl:[HDSchemePathUtil urlForScheme:kRouteSchemaViPay routePath:kRoutePathBranchMap] withParameters:nil];
        //                        [HDTalkingData trackEvent:@"入金地图_进入" label:@"余额不足"];
        //                    }];
        //                    strongSelf.featureRes(strongSelf, [strongSelf responseFailureWithReason:@"user cancel"]);
        //                }];
        //            }
        //            cancelButtonTitle:HDLocalizedString(@"BUTTON_TITLE_CANCEL", @"取消", @"")
        //            cancelButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
        //                [alertView dismiss];
        //            }];

    } else if ([self shouldGoToResultPageByCode:code]) {
        [controller dismissViewControllerCompletion:^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;

            HDPayOrderRspModel *rspModel = [HDPayOrderRspModel new];
            rspModel.rspCd = code;
            rspModel.rspInf = reason;
            rspModel.status = [NSNumber numberWithInteger:HDOrderStatusFailure];
            rspModel.tradeType = HDTransTypeConsume;
            [strongSelf orderPayFailure:rspModel showPaymentResult:controller.showPaymentResult];
        }];

    } else {
        [controller dismissViewControllerCompletion:^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.featureRes(strongSelf, [strongSelf responseFailureWithReason:reason]);
            //            [strongSelf.viewController viewModel:viewModel transactionFailure:reason code:code];
            [PayNetWorkViewModel viewController:(SAViewController *)SAWindowManager.visibleViewController transactionFailure:reason code:code];
        }];
    }
}

/**
 网络错误
 */
- (void)checkStandViewController:(PayHDCheckstandViewController *)controller networkRequestFail:(NSError *)error {

    __weak __typeof(self) weakSelf = self;
    [controller dismissViewControllerCompletion:^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.featureRes(strongSelf, [strongSelf responseFailureWithReason:error.localizedDescription]);
        //        [strongSelf.viewController networkRequestFail:error];
        [PayNetWorkViewModel networkRequestFail:error viewController:(SAViewController *)SAWindowManager.visibleViewController ShowToast:NO];
    }];
}

/**
 用户取消支付

 @param controller 收银台
 */
- (void)checkStandViewControllerUserClosedCheckStand:(PayHDCheckstandViewController *)controller {

    self.featureRes(self, [self responseFailureWithReason:@""]);
}

/**
 订单超过5分钟内未支付
 @param type 超时支付时用户所在的页面
 */
- (void)checkStandViewControllerPaymentOverTime:(PayHDCheckstandViewController *)controller endActionType:(PayHDCheckstandPaymentOverTimeEndActionType)type {
    self.featureRes(self, [self responseFailureWithReason:@"payment timeout"]);
}

- (void)orderPaySuccess:(HDPayOrderRspModel *)rspModel showPaymentResult:(BOOL)show {

    [TalkingData
        trackEvent:@"聚合支付"
             label:rspModel.tradeNo
        parameters:@{@"时间" : [NSString stringWithFormat:@"订单支付成功:%@", [HDCommonUtils getCurrentDateStrByFormat:@"yyyy/MM/dd HH:mm:ss:SSS"]], @"网络" : [HDCommonUtils getCurrentNetworkType]}];

    if (!show) {
        self.featureRes(self, [self responseSuccessWithData:@{@"orderStatus" : rspModel.status}]);
    } else {
        OrderResultVC *vc = [[OrderResultVC alloc] init];
        vc.type = resultPage;
        vc.rspModel = rspModel;
        __weak __typeof(self) weakSelf = self;
        vc.clickedDoneBtnHandler = ^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            //            [strongSelf.viewController.navigationController popToViewControllerClass:WalletVC.class animated:YES];
            [NSNotificationCenter.defaultCenter postNotificationName:kNOTIFICATIONSuccessWebPay object:nil];
        };
        [self.viewController presentViewController:[[SANavigationController alloc] initWithRootViewController:vc]
                                          animated:YES
                                        completion:^{
                                            __strong __typeof(weakSelf) strongSelf = weakSelf;
                                            strongSelf.featureRes(strongSelf, [strongSelf responseSuccessWithData:@{@"orderStatus" : rspModel.status}]);
                                        }];
    }
}

- (void)orderPayFailure:(HDPayOrderRspModel *)rspModel showPaymentResult:(BOOL)show {

    [TalkingData trackEvent:@"聚合支付"
                      label:rspModel.tradeNo
                 parameters:@{
                     @"原因" : [NSString stringWithFormat:@"(%@)%@", rspModel.rspCd, rspModel.rspInf],
                     @"时间" : [NSString stringWithFormat:@"订单支付失败:%@", [HDCommonUtils getCurrentDateStrByFormat:@"yyyy/MM/dd HH:mm:ss:SSS"]],
                     @"网络" : [HDCommonUtils getCurrentNetworkType]
                 }];

    if (!show) {
        self.featureRes(self, [self responseFailureWithReason:rspModel.rspInf]);
    } else {
        OrderResultVC *vc = [[OrderResultVC alloc] init];
        vc.type = resultPage;
        vc.rspModel = rspModel;
        __weak __typeof(self) weakSelf = self;
        vc.clickedDoneBtnHandler = ^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            //            [strongSelf.viewController.navigationController popToRootViewControllerAnimated:YES];
            [strongSelf.viewController.navigationController popToViewControllerClass:WalletVC.class animated:YES];
        };
        [self.viewController presentViewController:[[SANavigationController alloc] initWithRootViewController:vc]
                                          animated:YES
                                        completion:^{
                                            __strong __typeof(weakSelf) strongSelf = weakSelf;
                                            strongSelf.featureRes(strongSelf, [strongSelf responseFailureWithReason:rspModel.rspInf]);
                                        }];
    }
}

@end
