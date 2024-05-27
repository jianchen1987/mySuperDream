//
//  WMModifyAddressPayBaseViewController.m
//  SuperApp
//
//  Created by wmz on 2022/10/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMModifyAddressPayBaseViewController.h"


@interface WMModifyAddressPayBaseViewController ()
/// orderNo
@property (nonatomic, copy, readwrite) NSString *orderNo;
/// payableAmount
@property (nonatomic, strong, readwrite) SAMoneyModel *payableAmount;
/// storeNo
@property (nonatomic, copy, readwrite) NSString *storeNo;
/// merchantNo
@property (nonatomic, copy, readwrite) NSString *merchantNo;

@end


@implementation WMModifyAddressPayBaseViewController

- (void)payActionWithOrderNo:(NSString *)orderNo merchantNo:(NSString *)merchantNo storeNo:(NSString *)storeNo payableAmount:(SAMoneyModel *)payableAmount {
    self.orderNo = orderNo;
    self.merchantNo = merchantNo;
    self.storeNo = storeNo;
    self.payableAmount = payableAmount;
    if (!self.orderNo || !self.merchantNo || !self.payableAmount || !self.storeNo)
        return;
    HDTradeBuildOrderModel *buildModel = [HDTradeBuildOrderModel new];
    buildModel.orderNo = self.orderNo;
    buildModel.supportedPaymentMethods = @[HDSupportedPaymentMethodOnline];
    buildModel.merchantNo = self.merchantNo;
    buildModel.storeNo = self.storeNo;
    buildModel.payableAmount = self.payableAmount;
    buildModel.businessLine = SAClientTypeYumNow;
    buildModel.needCheckPaying = YES;
    [HDCheckStandPresenter payWithTradeBuildModel:buildModel preferedHeight:0 fromViewController:self delegate:self];
}

#pragma mark - HDCheckStandViewControllerDelegate

- (void)checkStandViewControllerInitializeFailed:(HDCheckStandViewController *)controller {
    [NAT showToastWithTitle:SALocalizedString(@"pay_failure_try_again", @"支付失败，请重试") content:nil type:HDTopToastTypeError];
}

- (void)checkStandViewControllerCompletedAndPaymentUnknow:(HDCheckStandViewController *)controller {
}

- (void)checkStandViewController:(HDCheckStandViewController *)controller paymentSuccess:(HDCheckStandPayResultResp *)resultResp {
    [controller dismissViewControllerAnimated:true completion:^{
        [self navigationToResultPageWithStatus:HDOrderStatusKnown];
    }];
}

- (void)checkStandViewController:(HDCheckStandViewController *)controller paymentFail:(nonnull HDCheckStandPayResultResp *)resultResp {
    [controller dismissAnimated:true completion:^{
        [self navigationToResultPageWithStatus:HDOrderStatusFailure];
    }];
}

- (void)checkStandViewControllerUserClosedCheckStand:(HDCheckStandViewController *)controller {
}

- (void)checkStandViewController:(HDCheckStandViewController *)controller failureWithRspModel:(SARspModel *)rspModel errorType:(CMResponseErrorType)errorType error:(NSError *)error {
    [controller dismissAnimated:true completion:^{
        [NAT showToastWithTitle:@"" content:rspModel.msg type:HDTopToastTypeError];
        [self dismissAnimated:YES completion:nil];
    }];
}

- (void)navigationToResultPageWithStatus:(HDOrderStatus)status {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    void (^orderDetailBlock)(UIViewController *) = ^(UIViewController *vc) {
        [vc.navigationController popToRootViewControllerAnimated:YES];
        [HDMediator.sharedInstance navigaveToOrderDetailViewController:@{@"orderNo": self.parentOrderNo}];
        [HDTips showSuccess:WMLocalizedString(@"wm_modify_address_successfully", @"成功修改地址") hideAfterDelay:1];
    };
    params[@"orderClickBlock"] = orderDetailBlock;
    params[@"businessLine"] = SAClientTypeYumNow;
    params[@"orderNo"] = self.orderNo;
    params[@"merchantNo"] = self.merchantNo;
    [HDMediator.sharedInstance navigaveToCheckStandPayResultViewController:params];
}

@end
