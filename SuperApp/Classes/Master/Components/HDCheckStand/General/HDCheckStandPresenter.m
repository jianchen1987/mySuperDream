//
//  HDCheckStandPresenter.m
//  SuperApp
//
//  Created by Tia on 2022/6/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "HDCheckStandPresenter.h"
#import "HDMediator+SuperApp.h"
#import "HDTradeBuildOrderModel.h"
#import "SARspModel.h"
#import "UIView+NAT.h"
#import "SAWindowManager.h"

/// 流水模型
@interface HDCheckStandPresenterModel : NSObject
/// 流水状态
@property (nonatomic, assign) SAPaymentState payState;

@end


@implementation HDCheckStandPresenterModel

@end


@implementation HDCheckStandPresenter
//最大支付流水次数
static int kMaxTimes = 9;

+ (void)payWithTradeBuildModel:(HDTradeBuildOrderModel *)model
                preferedHeight:(CGFloat)preferedHeight
            fromViewController:(nonnull UIViewController *)viewController
                      delegate:(nullable id)delegate {
    
    [SAWindowManager navigateToSetPhoneViewControllerWithText:[NSString stringWithFormat:SALocalizedString(@"login_new2_tip10",
                                                                                                           @"您将使用的 %@ 功能，需要您设置手机号码。请放心，手机号码经加密保护，不会对外泄露。"),
                                                                                         SALocalizedString(@"login_new2_Payment", @"支付")] bindSuccessBlock:^{
        //特殊处理二维码跳转
        if (model.payType == SAOrderPaymentTypeQRCode) {
            model.supportedPaymentMethods = @[HDSupportedPaymentMethodQRCode];
            model.selectedPaymentMethod = [HDPaymentMethodType qrCodePay];
            HDCheckStandViewController *checkStandVC = [[HDCheckStandViewController alloc] initWithTradeBuildModel:model preferedHeight:preferedHeight];
            checkStandVC.resultDelegate = delegate;
            [viewController presentViewController:checkStandVC animated:YES completion:nil];
            return;
        }

        if (model.needCheckPaying) {
            //外卖业务线而且有店铺id
            if (HDIsStringNotEmpty(model.storeNo) && [model.businessLine isEqualToString:SAClientTypeYumNow]) {
                CMNetworkRequest *request = CMNetworkRequest.new;
                request.retryCount = 2;
                request.requestURI = @"/takeaway-merchant/app/super-app/get-store-order-info";

                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                params[@"storeNo"] = model.storeNo;
                params[@"location"] = @{
                    @"lat": [NSString stringWithFormat:@"%f", HDLocationManager.shared.coordinate2D.latitude],
                    @"lon": [NSString stringWithFormat:@"%f", HDLocationManager.shared.coordinate2D.longitude]
                };
                params[@"serviceType"] = @(model.serviceType);
                request.requestParameter = params;

                [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
                    SARspModel *rspModel = response.extraData;
                    NSDictionary *dic = (NSDictionary *)rspModel.data;
                    NSMutableArray *paymentMethods = [dic[@"paymentMethods"] mutableCopy];
                    if ([paymentMethods isKindOfClass:NSArray.class] && paymentMethods.count > 0) {
                        //如果不含货到付款，插入不能货到付款枚举，需要区分外卖还是到店自取
                        if (![paymentMethods containsObject:HDSupportedPaymentMethodCashOnDelivery]) {
                            if (model.serviceType == 20) {
                                [paymentMethods addObject:HDSupportedPaymentMethodCashOnDeliveryForbiddenByToStore];
                            } else {
                                [paymentMethods addObject:HDSupportedPaymentMethodCashOnDeliveryForbidden];
                            }
                        }
                        model.supportedPaymentMethods = paymentMethods;
                        [self _checkPayTime:model preferedHeight:preferedHeight fromViewController:viewController delegate:delegate];
                    } else {
                        [self _checkPayTime:model preferedHeight:preferedHeight fromViewController:viewController delegate:delegate];
                    }
                } failure:^(HDNetworkResponse *_Nonnull response) {
                    [self _checkPayTime:model preferedHeight:preferedHeight fromViewController:viewController delegate:delegate];
                }];

            } else {
                [self _checkPayTime:model preferedHeight:preferedHeight fromViewController:viewController delegate:delegate];
            }

        } else {
            [self _payWithTradeBuildModel:model preferedHeight:preferedHeight viewController:viewController delegate:delegate];
        }
    }
                                              cancelBindBlock:nil];
}

#pragma mark - privite methed
+ (void)_payWithTradeBuildModel:(HDTradeBuildOrderModel *)model preferedHeight:(CGFloat)preferedHeight viewController:(UIViewController *)viewController delegate:(nullable id)delegate {
    HDCheckStandViewController *checkStandVC = [[HDCheckStandViewController alloc] initWithTradeBuildModel:model preferedHeight:preferedHeight];
    checkStandVC.resultDelegate = delegate;
    [viewController presentViewController:checkStandVC animated:YES completion:nil];
}

+ (void)_checkPayTime:(HDTradeBuildOrderModel *)model preferedHeight:(CGFloat)preferedHeight fromViewController:(nonnull UIViewController *)viewController delegate:(nullable id)delegate {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/shop/order/listPayTransaction";
    request.shouldAlertErrorMsgExceptSpecCode = NO; //不提示报错信息

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"aggregateOrderNo"] = model.orderNo;
    //        params[@"payState"] = @"PAYING";

    request.requestParameter = params;

    [viewController.view showloading];

    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
        [viewController.view dismissLoading];

        SARspModel *rspModel = response.extraData;
        NSArray *arr = [NSArray yy_modelArrayWithClass:HDCheckStandPresenterModel.class json:rspModel.data];
        NSInteger times = arr.count >= kMaxTimes ? kMaxTimes : arr.count;

        //判断是否少于9条流水且存在支付中的流水
        if (times > 0 && times < kMaxTimes) {
            BOOL needShowWaitPayResultViewController = NO;
            for (HDCheckStandPresenterModel *m in arr) {
                if (m.payState == SAPaymentStatePaying) {
                    needShowWaitPayResultViewController = YES;
                    break;
                }
            }
            if (!needShowWaitPayResultViewController) { //没有支付中的流水，清空流水次数，直接拉起收银台
                times = 0;
            }
        }

        HDLog(@"已有%ld条流水", times);

        if (times) {
            NSMutableDictionary *params = NSMutableDictionary.new;
            params[@"buildModel"] = model;                 //收银台模型
            params[@"preferedHeight"] = @(preferedHeight); //高度
            params[@"resultDelegate"] = delegate;          //收银台代理
            params[@"times"] = @(times);                   //流水条数
            [HDMediator.sharedInstance navigaveToWaitPayResultViewController:params];
        } else {
            [self _payWithTradeBuildModel:model preferedHeight:preferedHeight viewController:viewController delegate:delegate];
        }
    } failure:^(HDNetworkResponse *_Nonnull response) {
        [viewController.view dismissLoading];
        [self _payWithTradeBuildModel:model preferedHeight:preferedHeight viewController:viewController delegate:delegate];
    }];
}

@end
