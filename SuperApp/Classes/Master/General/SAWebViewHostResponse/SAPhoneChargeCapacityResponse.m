//
//  SABaseCapacity.m
//  SuperApp
//
//  Created by seeu on 2020/7/1.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAPhoneChargeCapacityResponse.h"
#import "HDCheckStandViewController.h"
#import "HDMediator+SuperApp.h"
#import "SAEnum.h"
#import "SAMoneyModel.h"
#import "SAPhoneTopUpDTO.h"
#import "SAWindowManager.h"
#import "UIView+NAT.h"
#import "WMOrderSubmitRspModel.h"
#import <HDUIKit/NAT.h>


@interface SAPhoneChargeCapacityResponse () <HDCheckStandViewControllerDelegate>
/// 充值 DTO
@property (nonatomic, strong) SAPhoneTopUpDTO *phoneTopUpDTO;
/// 话费充值回调 key
@property (nonatomic, copy) NSString *phoneTopUpCallbackKey;
/// 下单成功返回
@property (nonatomic, strong) WMOrderSubmitRspModel *submitOrderRspModel;
@end


@implementation SAPhoneChargeCapacityResponse

- (instancetype)init {
    self = [super init];
    if (self) {
        //        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(clearCommand:) name:@"kNotificationNameCashierWebViewClose" object:nil];
    }
    return self;
}

- (void)dealloc {
    //    [NSNotificationCenter.defaultCenter removeObserver:self name:@"kNotificationNameCashierWebViewClose" object:nil];
}

+ (NSDictionary<NSString *, NSString *> *)supportActionList {
    return @{
        @"phoneChargePay_$": kHDWHResponseMethodOn ///< 话费充值下单支付
    };
}

wh_doc_begin(phoneChargePay_$, "话费充值下单并支付");
wh_doc_param(phone, "手机号");
wh_doc_param(amount, "金额(分)");
wh_doc_param(storeNo, "门店号");
wh_doc_code(window.webViewHost.invoke(
    "phoneChargePay", {"phone": "xxxxx", "amount": "100"}, function(params) { alert('话费充值回调:' + JSON.stringify(params)); }));
wh_doc_code_expect("支付完成，跳转订单详情");
wh_doc_end;
- (void)phoneChargePay:(NSDictionary *)paramDict callback:(NSString *)callBackKey {
    if (!SAUser.hasSignedIn) {
        [self.webViewHost fireCallback:callBackKey actionName:@"phoneChargePay" code:HDWHRespCodeCommonFailed type:HDWHCallbackTypeFail
                                params:@{@"reason": SALocalizedString(@"user_not_login", @"用户未登录")}];
        [SAWindowManager switchWindowToLoginViewController];
        return;
    }

    // 取参
    NSString *topUpNumber = paramDict[@"phone"];
    NSString *amount = paramDict[@"amount"];
    NSString *storeNo = paramDict[@"storeNo"];
    if (HDIsStringEmpty(topUpNumber) || HDIsStringEmpty(amount) || HDIsStringEmpty(storeNo)) {
        [self.webViewHost fireCallback:callBackKey actionName:@"phoneChargePay" code:HDWHRespCodeIllegalArg type:HDWHCallbackTypeFail params:nil];
        return;
    }
    self.phoneTopUpCallbackKey = callBackKey;

    SACurrencyType currency = paramDict[@"currency"];
    // H5 未传币种使用美元
    currency = HDIsStringEmpty(currency) ? SACurrencyTypeUSD : currency;

    SAMoneyModel *amountModel = [SAMoneyModel modelWithAmount:amount currency:currency];

    // 下单
    [self.webViewHost.view showloading];
    @HDWeakify(self);
    [self.phoneTopUpDTO submitPhoneTopUpOrderWithPaymentType:SAOrderPaymentTypeOnline amountModel:amountModel topUpNumber:topUpNumber merchantNo:storeNo
        success:^(WMOrderSubmitRspModel *_Nonnull rspModel) {
            @HDStrongify(self);
            [self.webViewHost.view dismissLoading];
            self.submitOrderRspModel = rspModel;
            [self handlingSuccessSubmitPhoneTopUpOrderWithRspModel:rspModel amountModel:amountModel];
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self);
            [self.webViewHost.view dismissLoading];
            [self.webViewHost fireCallback:callBackKey actionName:@"phoneChargePay" code:HDWHRespCodeCommonFailed type:HDWHCallbackTypeFail params:@{@"reason": rspModel.msg}];
        }];
}
- (void)clearCommand:(NSNotification *)nofitication {
    [self.webViewHost fireCallback:self.phoneTopUpCallbackKey actionName:@"phoneChargePay" code:HDWHRespCodeUserCancel type:HDWHCallbackTypeCancel params:@{@"reason": @"用户取消"}];
}

#pragma mark - private methods
- (void)handlingSuccessSubmitPhoneTopUpOrderWithRspModel:(WMOrderSubmitRspModel *)rspModel amountModel:(SAMoneyModel *)amountModel {
    HDTradeBuildOrderModel *buildModel = [HDTradeBuildOrderModel new];
    buildModel.orderNo = rspModel.orderNo;
    buildModel.outPayOrderNo = rspModel.outPayOrderNo;
    buildModel.tradeAmountModel = amountModel;
    buildModel.businessLine = SAClientTypePhoneTopUp;
    HDCheckStandViewController *checkStandVC = [[HDCheckStandViewController alloc] initWithTradeBuildModel:buildModel preferedHeight:0];
    checkStandVC.resultDelegate = self;

    [self.webViewHost presentViewController:checkStandVC animated:YES completion:nil];
}

#pragma mark - HDCheckStandViewControllerDelegate

- (void)checkStandViewControllerInitializeFailed:(HDCheckStandViewController *)controller {
    [self.webViewHost fireCallback:controller.currentOrderNo actionName:@"phoneChargePay" code:HDWHRespCodeCommonFailed type:HDWHCallbackTypeFail params:@{@"reason": @"init fail!"}];
}

- (void)checkStandViewControllerCompletedAndPaymentUnknow:(HDCheckStandViewController *)controller {
    [self.webViewHost fireCallback:controller.currentOrderNo actionName:@"phoneChargePay" code:HDWHRespCodeSuccess type:HDWHCallbackTypeSuccess params:@{@"tradeNo": controller.outPayOrderNo}];
}

- (void)checkStandViewController:(HDCheckStandViewController *)controller paymentSuccess:(HDCheckStandPayResultResp *)resultResp {
    @HDWeakify(controller);
    [controller dismissViewControllerAnimated:true completion:^{
        @HDStrongify(controller);
        [HDMediator.sharedInstance navigaveToCheckStandPayResultViewController:@{@"orderNo": controller.currentOrderNo, @"businessLine": SAClientTypePhoneTopUp}];
        [self.webViewHost fireCallback:self.phoneTopUpCallbackKey actionName:@"phoneChargePay" code:HDWHRespCodeSuccess type:HDWHCallbackTypeSuccess params:@{
            @"tradeNo": self.submitOrderRspModel.orderNo,
            @"outPayOrderNo": self.submitOrderRspModel.outPayOrderNo,
            @"actualAmt": self.submitOrderRspModel.paymentAmount.cent,
            @"cy": @"USD",
            @"orderState": @"1"
        }];
    }];
}

- (void)checkStandViewController:(HDCheckStandViewController *)controller failureWithRspModel:(SARspModel *_Nullable)rspModel errorType:(CMResponseErrorType)errorType error:(NSError *_Nullable)error {
    NSString *tipStr = HDIsStringNotEmpty(rspModel.msg) ? rspModel.msg : SALocalizedString(@"pay_failure_try_again", @"支付失败，请重试");
    [NAT showToastWithTitle:tipStr content:nil type:HDTopToastTypeError];
    //    [HDMediator.sharedInstance navigaveToCheckStandPayResultViewController:@{@"orderNo": controller.currentOrderNo,
    //                                                                             @"businessLine": controller.businessLine,
    //                                                                             @"paymentState": @(SAPaymentStatePayFail)}];

    [self.webViewHost fireCallback:self.phoneTopUpCallbackKey actionName:@"phoneChargePay" code:HDWHRespCodeCommonFailed type:HDWHCallbackTypeFail params:@{@"reason": tipStr}];
}

- (void)checkStandViewController:(HDCheckStandViewController *)controller paymentFail:(nonnull HDCheckStandPayResultResp *)resultResp {
    NSString *tipStr = HDIsStringNotEmpty(resultResp.errStr) ? resultResp.errStr : SALocalizedString(@"pay_failure_try_again", @"支付失败，请重试");
    @HDWeakify(controller);
    [controller dismissViewControllerCompletion:^{
        @HDStrongify(controller);
        [HDMediator.sharedInstance navigaveToCheckStandPayResultViewController:
                                       @{@"orderNo": controller.currentOrderNo,
                                         @"businessLine": controller.businessLine,
                                         @"paymentState": @(SAPaymentStatePayFail)}];
    }];

    [self.webViewHost fireCallback:self.phoneTopUpCallbackKey actionName:@"phoneChargePay" code:HDWHRespCodeCommonFailed type:HDWHCallbackTypeFail params:@{@"reason": tipStr}];
}

- (void)checkStandViewControllerUserClosedCheckStand:(HDCheckStandViewController *)controller {
    @HDWeakify(self);
    [controller dismissViewControllerAnimated:true completion:^{
        @HDStrongify(self);
        [self.webViewHost fireCallback:self.phoneTopUpCallbackKey actionName:@"phoneChargePay" code:HDWHRespCodeUserCancel type:HDWHCallbackTypeCancel params:@{@"reason": @"用户取消"}];
    }];
}

#pragma mark - lazy load
- (SAPhoneTopUpDTO *)phoneTopUpDTO {
    if (!_phoneTopUpDTO) {
        _phoneTopUpDTO = SAPhoneTopUpDTO.new;
    }
    return _phoneTopUpDTO;
}
@end
