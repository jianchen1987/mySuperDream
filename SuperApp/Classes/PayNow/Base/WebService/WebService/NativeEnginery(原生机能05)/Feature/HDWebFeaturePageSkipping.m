//
//  HDWebFeaturePageSkipping.m
//  customer
//
//  Created by 谢泽锋 on 2019/3/5.
//  Copyright © 2019 chaos network technology. All rights reserved.
//
#import "HDWebFeaturePageSkipping.h"
#import "HDPayOrderRspModel.h"
#import "PNCommonUtils.h"
#import "PNNotificationMacro.h"
#import "PNOrderResultViewController.h"
#import "PNPaymentComfirmViewController.h"
#import "PayPassWordTip.h"
#import "SAChangePayPwdAskingViewController.h"
#import "SAMoneyModel.h"
#import "SAWindowManager.h"
#import "TalkingData.h"
#import "VipayUser.h"
#import "WQCodeScanner.h"

@interface HDWebFeaturePageSkipping () <PNPaymentComfirmViewControllerDelegate>

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
//        NSString *orderAmt = arr3.lastObject;
//        NSString *orderCy = arr4.lastObject;

        PNPaymentBuildModel *buildModel = [[PNPaymentBuildModel alloc] init];
        buildModel.tradeNo = orderNo;
        buildModel.fromType = PNPaymentBuildFromType_Default;

        PNPaymentComfirmViewController *vc = [[PNPaymentComfirmViewController alloc] initWithRouteParameters:@{@"data" : [buildModel yy_modelToJSONData]}];
        vc.delegate = self;
        [SAWindowManager.visibleViewController.navigationController pushViewControllerDiscontinuous:vc animated:YES];
    }
}

#pragma mark
- (void)paymentSuccess:(PayHDTradeSubmitPaymentRspModel *)rspModel controller:(PNPaymentComfirmViewController *)controller {
    HDPayOrderRspModel *payOrderRspModel = [HDPayOrderRspModel modelFromTradeSubmitPaymentRspModel:rspModel];
    [self orderPaySuccess:payOrderRspModel showPaymentResult:YES];
    [controller removeFromParentViewController];
}

- (void)userGoBack:(PNPaymentComfirmViewController *)controller {
    self.featureRes(self, [self responseFailureWithReason:@""]);
}

- (void)orderPaySuccess:(HDPayOrderRspModel *)rspModel showPaymentResult:(BOOL)show {

    [TalkingData
        trackEvent:@"聚合支付"
             label:rspModel.tradeNo
        parameters:@{@"时间" : [NSString stringWithFormat:@"订单支付成功:%@", [PNCommonUtils getCurrentDateStrByFormat:@"yyyy/MM/dd HH:mm:ss:SSS"]], @"网络" : [PNCommonUtils getCurrentNetworkType]}];

    if (!show) {
        self.featureRes(self, [self responseSuccessWithData:@{@"orderStatus" : rspModel.status}]);
    } else {
        PNOrderResultViewController *vc = [[PNOrderResultViewController alloc] init];
        vc.type = resultPage;
        vc.rspModel = rspModel;
        __weak __typeof(self) weakSelf = self;
        vc.clickedDoneBtnHandler = ^{
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
@end
