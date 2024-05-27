//
//  GNOrderBaseViewController.m
//  SuperApp
//
//  Created by wmz on 2021/11/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNOrderBaseViewController.h"
#import "GNOrderCellModel.h"
#import "GNOrderRushBuyModel.h"
#import "GNTimer.h"
#import "HDCheckStandRepaymentAlertView.h"
#import "HDCheckStandViewController.h"
#import "SAMoneyModel.h"
#import "SAMoneyTools.h"
#import "SAOrderDTO.h"
#import "SAQueryOrderDetailsRspModel.h"
#import "SAQueryPaymentStateRspModel.h"


@interface GNOrderBaseViewController () <HDCheckStandViewControllerDelegate>
/// customOrderModel
@property (nonatomic, strong) GNOrderCellModel *customOrderModel;
///订单号
@property (nonatomic, strong) NSString *orderNo;
/// 金额
@property (nonatomic, strong) NSDecimalNumber *money;
/// openCapabilityDTO
@property (nonatomic, strong) SAPaymentDTO *paymentDto;
///< 门店号
@property (nonatomic, copy) NSString *storeNo;
///< 商户号
@property (nonatomic, copy) NSString *merchantNo;

///< DTO
@property (nonatomic, strong) SAOrderDTO *orderDTO;

@end


@implementation GNOrderBaseViewController

- (void)respondEvent:(NSObject<GNEvent> *)event {
    [super respondEvent:event];
    /// 付款
    if ([event.key isEqualToString:@"onlinePayAction"]) {
        GNOrderCellModel *orderModel = event.info[@"model"];
        self.customOrderModel = orderModel;
        if (![orderModel isKindOfClass:GNOrderCellModel.class] && ![orderModel isKindOfClass:GNOrderRushBuyModel.class])
            return;
        if ([orderModel isKindOfClass:GNOrderCellModel.class]) {
            self.aggregateOrderNo = orderModel.aggregateOrderNo;
            self.money = orderModel.actualAmount;
            self.orderNo = orderModel.orderNo;

        } else if ([orderModel isKindOfClass:GNOrderRushBuyModel.class]) {
            GNOrderRushBuyModel *tempModel = (GNOrderRushBuyModel *)orderModel;
            self.aggregateOrderNo = tempModel.aggregateOrderNo;
            self.money = tempModel.allPrice;
            self.orderNo = tempModel.orderNo;
            self.merchantNo = tempModel.merchantNo;
            self.storeNo = tempModel.storeNo;
        }
        if (self.type == GNOrderFromSubmit) {
            [self payAction];
        } else {
            [self showRepaymetAlert];
        }
    }
}

- (void)payAction {
    @HDWeakify(self);
    [self.orderDTO queryOrderDetailsWithOrderNo:self.aggregateOrderNo success:^(SAQueryOrderDetailsRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        HDTradeBuildOrderModel *buildModel = [HDTradeBuildOrderModel new];
        buildModel.orderNo = self.aggregateOrderNo;
        buildModel.payableAmount = [SAMoneyModel modelWithAmount:[NSString stringWithFormat:@"%@", [SAMoneyTools yuanTofen:self.money.stringValue]] currency:@"USD"];
        buildModel.businessLine = SAClientTypeGroupBuy;
        buildModel.storeNo = rspModel.storeNo;
        buildModel.merchantNo = rspModel.merchantNo;
        buildModel.goods = @[];

        HDCheckStandViewController *checkStandVC = [[HDCheckStandViewController alloc] initWithTradeBuildModel:buildModel preferedHeight:0];
        checkStandVC.resultDelegate = self;
        [self presentViewController:checkStandVC animated:YES completion:nil];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self)[self refreshOrderDetail:nil];
    }];
}

///再次确认
- (void)showRepaymetAlert {
    HDCheckStandRepaymentAlertViewConfig *config = HDCheckStandRepaymentAlertViewConfig.new;
    @HDWeakify(self);
    config.clickOnContinuePaymentHandler = ^(HDCheckStandRepaymentAlertView *_Nonnull alertView) {
        @HDStrongify(self);

        @HDWeakify(self)[self getPaymentStateSuccess:^(SAQueryPaymentStateRspModel *_Nonnull rspModel) {
            @HDStrongify(self) if (rspModel.payState == SAPaymentStatePaying) {
                [self payAction];
            }
            else {
                [self refreshOrderDetail:rspModel];
            }
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self)[self payAction];
        }];
    };
    config.clickOnWailtPaymentResultHandler = ^(HDCheckStandRepaymentAlertView *_Nonnull alertView) {
        @HDStrongify(self);

        @HDWeakify(self)[self getPaymentStateSuccess:^(SAQueryPaymentStateRspModel *_Nonnull rspModel) {
            @HDStrongify(self)[self refreshOrderDetail:rspModel];
        } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
            @HDStrongify(self)[self refreshOrderDetail:nil];
        }];
    };
    config.clickOnServiceHandler = ^(HDCheckStandRepaymentAlertView *_Nonnull alertView) {
        [HDMediator.sharedInstance navigaveToWebViewViewController:@{@"path": @"/mobile-h5/super/app/user/v1/help-center"}];
    };
    HDCheckStandRepaymentAlertView *alertView = [HDCheckStandRepaymentAlertView alertViewWithConfig:config];
    [alertView show];
}

///订单状态发生改变 刷新
- (void)refreshOrderDetail:(nullable SAQueryPaymentStateRspModel *)rspModel {
    if (rspModel) {
        if (rspModel.payState != SAPaymentStatePaying) {
            [self updateUI];
        }
    } else {
        [self updateUI];
    }
}

#pragma mark - HDCheckStandViewControllerDelegate
- (void)checkStandViewControllerInitializeFailed:(HDCheckStandViewController *)controller {
    [controller dismissViewControllerAnimated:true completion:^{
        [self pushDetailVC];
    }];
}

- (void)checkStandViewControllerCompletedAndPaymentUnknow:(HDCheckStandViewController *)controller {
    [controller dismissViewControllerAnimated:true completion:^{
        [self pushDetailVC];
    }];
}

- (void)checkStandViewController:(HDCheckStandViewController *)controller paymentSuccess:(HDCheckStandPayResultResp *)resultResp {
    [controller dismissViewControllerAnimated:true completion:^{
        [self removeViewController:YES];
        [HDMediator.sharedInstance navigaveToGNOrderResultViewController:@{@"orderNo": GNFillEmpty(self.orderNo)}];
    }];
}

- (void)checkStandViewController:(HDCheckStandViewController *)controller paymentFail:(nonnull HDCheckStandPayResultResp *)resultResp {
}

- (void)checkStandViewControllerPaymentOverTime:(HDCheckStandViewController *)controller endActionType:(HDCheckStandPaymentOverTimeEndActionType)type {
    [controller dismissViewControllerAnimated:true completion:^{
        [self pushDetailVC];
    }];
}

- (void)checkStandViewControllerUserClosedCheckStand:(HDCheckStandViewController *)controller {
    [controller dismissViewControllerAnimated:true completion:^{
        [self pushDetailVC];
    }];
}

- (void)checkStandViewController:(HDCheckStandViewController *)controller failureWithRspModel:(SARspModel *)rspModel errorType:(CMResponseErrorType)errorType error:(NSError *)error {
    [controller dismissViewControllerAnimated:true completion:^{
        [self pushDetailVC];
    }];
}

///收银台已显示
- (void)checkStandViewControllerDidShown:(HDCheckStandViewController *)controller {
    [self startBankTimer:controller];
}

- (void)pushDetailVC {
    ///当前已经是详情 不跳转 刷新
    if ([NSStringFromClass(self.class) isEqualToString:@"GNOrderDetailViewController"] || self.type == GNOrderFromDetail) {
        [self updateUI];
        return;
    }
    [HDMediator.sharedInstance navigaveToGNOrderDetailViewController:@{@"orderNo": GNFillEmpty(self.orderNo)}];
    [self removeViewController:YES];
}

- (void)removeViewController:(BOOL)removeSelf withoutVCNameArr:(nullable NSArray<NSString *> *)limitArr {
    NSMutableArray *vcArr = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    for (GNViewController *vc in self.navigationController.viewControllers) {
        if (removeSelf) {
            if (vc == self) {
                [vcArr removeObject:vc];
                break;
            }
        } else {
            if ([vc conformsToProtocol:@protocol(GNViewControllerProtocol)] && [vc respondsToSelector:@selector(needClose)]) {
                if (HDIsArrayEmpty(limitArr)) {
                    if ([vc needClose])
                        [vcArr removeObject:vc];
                } else {
                    if ([limitArr indexOfObject:NSStringFromClass(vc.class)] == NSNotFound) {
                        if ([vc needClose])
                            [vcArr removeObject:vc];
                    }
                }
            }
        }
    }
    self.navigationController.viewControllers = [NSArray arrayWithArray:vcArr];
}

- (void)removeViewController:(BOOL)removeSelf {
    [self removeViewController:removeSelf withoutVCNameArr:nil];
}

#pragma mark 开启定时器
- (void)startTimer {
    if (self.timer)
        [self cancelTimer];

    @HDWeakify(self) self.timer = [NSTimer bl_scheduledTimerWithTimeInterval:1 block:^{
        @HDStrongify(self)[self refreshAction];
    } repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:UITrackingRunLoopMode];
    [self.timer fire];
}

- (void)cancelTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark 收银台定时器
- (void)startBankTimer:(HDCheckStandViewController *)controller {
    [self cancelBankTimer];
    [GNTimer timerWithStartTime:0 interval:1 timeId:@"bankCancelTimer" total:60 * 5 repeats:YES mainQueue:YES completion:^(NSInteger time) {
        if (time <= 0) {
            [controller dismissViewControllerAnimated:true completion:^{
                [self pushDetailVC];
            }];
        }
    }];
}

- (void)cancelBankTimer {
    [GNTimer cancel:@"bankCancelTimer"];
}

- (void)refreshAction {
}

- (void)updateUI {
}

- (void)getPaymentStateSuccess:(void (^_Nullable)(SAQueryPaymentStateRspModel *rspModel))successBlock failure:(CMNetworkFailureBlock _Nullable)failureBlock {
    if (!self.aggregateOrderNo)
        return;
    [self.paymentDto queryOrderPaymentStateWithOrderNo:self.aggregateOrderNo success:successBlock failure:failureBlock];
}

- (SAPaymentDTO *)paymentDto {
    if (!_paymentDto) {
        _paymentDto = [[SAPaymentDTO alloc] init];
    }
    return _paymentDto;
}

/** @lazy paymentDTO */
- (SAOrderDTO *)orderDTO {
    if (!_orderDTO) {
        _orderDTO = [[SAOrderDTO alloc] init];
    }
    return _orderDTO;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self cancelTimer];
    [self cancelBankTimer];
}

@end
