//
//  SATopUpOrderDetailViewModel.m
//  SuperApp
//
//  Created by Chaos on 2020/6/28.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATopUpOrderDetailViewModel.h"
#import "SAMoneyModel.h"
#import "SAOrderDTO.h"
#import "SATopUpOrderDetailDTO.h"
#import "SATopUpOrderDetailRspModel.h"


@interface SATopUpOrderDetailViewModel ()

/// 账单详情DTO
@property (nonatomic, strong) SATopUpOrderDetailDTO *topUpOrderDetailDTO;
///< 订单DTO
@property (nonatomic, strong) SAOrderDTO *orderDTO;
@end


@implementation SATopUpOrderDetailViewModel

- (void)getTopUpOrderDetail {
    @HDWeakify(self);
    dispatch_group_t taskGroup = dispatch_group_create();

    dispatch_group_enter(taskGroup);
    [self.topUpOrderDetailDTO getTopUpOrderDetailWithOrderNo:self.orderNo success:^(SATopUpOrderDetailRspModel *_Nonnull rspModel) {
        @HDStrongify(self);

        self.model = rspModel;
        self.outPayOrderNo = rspModel.outPayOrderNo;
        dispatch_group_leave(taskGroup);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        dispatch_group_leave(taskGroup);
    }];

    dispatch_group_enter(taskGroup);
    [self.orderDTO queryOrderDetailsWithOrderNo:self.orderNo success:^(SAQueryOrderDetailsRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        self.orderInfo = rspModel;
        dispatch_group_leave(taskGroup);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        dispatch_group_leave(taskGroup);
    }];

    dispatch_group_notify(taskGroup, dispatch_get_main_queue(), ^{
        @HDStrongify(self);
        self.refreshFlag = !self.refreshFlag;
    });
}

#pragma mark - HDCheckStandViewControllerDelegate
- (void)checkStandViewControllerInitializeFailed:(HDCheckStandViewController *)controller {
    [NAT showToastWithTitle:SALocalizedString(@"pay_failure_try_again", @"支付失败，请重试") content:nil type:HDTopToastTypeError];
}

- (void)checkStandViewControllerCompletedAndPaymentUnknow:(HDCheckStandViewController *)controller {
    @HDWeakify(self);
    [controller dismissViewControllerCompletion:^{
        @HDStrongify(self);

        @HDWeakify(self);
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        void (^orderDetailBlock)(UIViewController *) = ^(UIViewController *vc) {
            @HDStrongify(self);
            [vc.navigationController popViewControllerAnimated:YES];
            [self getTopUpOrderDetail];
        };

        params[@"orderClickBlock"] = orderDetailBlock;
        params[@"orderNo"] = self.orderNo;
        params[@"businessLine"] = SAClientTypePhoneTopUp;
        params[@"merchantNo"] = controller.merchantNo;
        [HDMediator.sharedInstance navigaveToCheckStandPayResultViewController:params];
    }];
}

/**
 支付成功

 @param controller 收银台
 @param rspModel 支付成功返回模型
 */
- (void)checkStandViewController:(HDCheckStandViewController *)controller paymentSuccess:(HDTradeSubmitPaymentRspModel *)rspModel {
    @HDWeakify(self);
    [controller dismissViewControllerCompletion:^{
        @HDStrongify(self);

        @HDWeakify(self);
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        void (^orderDetailBlock)(UIViewController *) = ^(UIViewController *vc) {
            @HDStrongify(self);
            [vc.navigationController popViewControllerAnimated:YES];
            [self getTopUpOrderDetail];
        };

        params[@"orderClickBlock"] = orderDetailBlock;
        params[@"orderNo"] = self.orderNo;
        params[@"businessLine"] = SAClientTypePhoneTopUp;
        params[@"merchantNo"] = controller.merchantNo;
        [HDMediator.sharedInstance navigaveToCheckStandPayResultViewController:params];
    }];
}

/**
 支付失败（可能是网络错误）
 */
- (void)checkStandViewController:(HDCheckStandViewController *)controller failureWithRspModel:(SARspModel *_Nullable)rspModel errorType:(CMResponseErrorType)errorType error:(NSError *_Nullable)error {
    @HDWeakify(self);
    [controller dismissViewControllerCompletion:^{
        @HDStrongify(self);
        [NAT showToastWithTitle:SALocalizedString(@"pay_failure_try_again", @"支付失败，请重试") content:nil type:HDTopToastTypeError];
        [self getTopUpOrderDetail];
    }];
}

- (void)checkStandViewController:(nonnull HDCheckStandViewController *)controller paymentFail:(nonnull HDCheckStandPayResultResp *)resultResp {
    @HDWeakify(self);
    [controller dismissViewControllerCompletion:^{
        @HDStrongify(self);
        [NAT showToastWithTitle:SALocalizedString(@"pay_failure_try_again", @"支付失败，请重试") content:nil type:HDTopToastTypeError];
        [self getTopUpOrderDetail];
    }];
}

- (void)checkStandViewControllerUserClosedCheckStand:(nonnull HDCheckStandViewController *)controller {
}

#pragma mark - setter
- (void)setModel:(SATopUpOrderDetailRspModel *)model {
    _model = model;

    self.isShowPayButton = NO;
    NSString *status = @"";
    switch (model.orderStatus) {
        case HDTopUpOrderStatusUnknown:
            status = @"";
            break;
        case HDTopUpOrderStatusCreated:
            self.isShowPayButton = YES;
            status = SALocalizedString(@"top_up_to_be_paid", @"待支付");
            break;
        case HDTopUpOrderStatusProcessing:
            status = SALocalizedString(@"top_up_in_the_processing", @"处理中");
            break;
        case HDTopUpOrderStatusSuccess:
            status = SALocalizedString(@"top_up_success", @"充值成功");
            break;
        case HDTopUpOrderStatusFailed:
            status = SALocalizedString(@"top_up_failure", @"充值失败");
            break;
        case HDTopUpOrderStatusClosed:
            status = SALocalizedString(@"top_up_closed", @"订单关闭");
            break;
    }

    self.status = status;
    self.storeIcon = self.model.logoUrl;
    NSMutableAttributedString *topUpMoney =
        [[NSMutableAttributedString alloc] initWithString:SALocalizedString(@"top_up_recharge_amount", @"充值金额:")
                                               attributes:@{NSForegroundColorAttributeName: HDAppTheme.color.G2, NSFontAttributeName: HDAppTheme.font.standard3Bold}];
    NSAttributedString *moneyStr = [[NSAttributedString alloc]
        initWithString:self.model.orderAmt.thousandSeparatorAmount ?: @""
            attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:255 / 255.0 green:68 / 255.0 blue:68 / 255.0 alpha:1.0], NSFontAttributeName: HDAppTheme.font.standard3Bold}];
    [topUpMoney appendAttributedString:moneyStr];
    self.topUpMoney = topUpMoney.copy;
    self.payMoney = self.model.payeeAmt.thousandSeparatorAmount;
    self.account = [NSString stringWithFormat:SALocalizedString(@"top_up_number", @"充值号码："), self.model.topUpNumber];
    if (HDIsStringNotEmpty(self.model.transactionTime)) {
        NSDate *orderDate = [NSDate dateWithTimeIntervalSince1970:[self.model.transactionTime doubleValue] / 1000.0];
        self.orderTime = [SAGeneralUtil getDateStrWithDate:orderDate format:@"MM/dd/yyyy HH:mm"];
    }

    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:[self.model.createTime doubleValue] / 1000.0];
    self.createTime = [SAGeneralUtil getDateStrWithDate:createDate format:@"MM/dd/yyyy HH:mm"];
}

#pragma mark - lazy load
- (SATopUpOrderDetailDTO *)topUpOrderDetailDTO {
    if (!_topUpOrderDetailDTO) {
        _topUpOrderDetailDTO = [[SATopUpOrderDetailDTO alloc] init];
    }
    return _topUpOrderDetailDTO;
}

/** @lazy orderDTO */
- (SAOrderDTO *)orderDTO {
    if (!_orderDTO) {
        _orderDTO = [[SAOrderDTO alloc] init];
    }
    return _orderDTO;
}

@end
