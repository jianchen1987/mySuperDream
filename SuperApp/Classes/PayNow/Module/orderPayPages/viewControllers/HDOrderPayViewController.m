//
//  HDOrderPayViewController.m
//  customer
//
//  Created by 帅呆 on 2018/11/22.
//  Copyright © 2018 chaos network technology. All rights reserved.
//

#import "HDOrderPayViewController.h"
#import "HDBaseButton.h"
#import "HDBaseCallBackModel.h"
#import "HDCheckStandViewController.h"
#import "HDOrderPayResultViewController.h"
#import "HDPasswordManagerViewModel.h"
//#import "HDResetPayPwdViewController.h"
#import "HDShadowBlankView.h"
#import "HDTransCenterViewModel.h"
#import "HDTransationRspModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HDSchemePathUtil.h"
#import "TalkingData.h"
#import "VipayUser.h"


@interface HDOrderPayViewController () <HDCheckStandViewControllerDelegate>

@property (nonatomic, strong) HDShadowBlankView *contentView;
@property (nonatomic, strong) UIImageView *headIV;
@property (nonatomic, strong) UILabel *merchantNameLB;
@property (nonatomic, strong) UILabel *orderTitleLB;
@property (nonatomic, strong) UILabel *orderAmountLB;
@property (nonatomic, strong) HDBaseButton *confirmBTN;
@property (nonatomic, strong) UIButton *cancenBTN;
@property (nonatomic, strong) HDTransCenterViewModel *transVM;
@property (nonatomic, strong) HDCheckStandViewController *checkStandVC;
@property (nonatomic, strong) HDGetOrderInfoRspModel *orderInfoModel;

@end


@implementation HDOrderPayViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        NSString *vipayOrderNo = parameters[@"orderNo"];
        NSString *merchantScheme = parameters[@"scheme"];
        if (WJIsStringNotEmpty(vipayOrderNo)) {
            self.vipayOrderNo = vipayOrderNo;
        }
        if (WJIsStringNotEmpty(merchantScheme)) {
            self.merchantScheme = merchantScheme;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //    [self checkAuthentificate:nil];
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.headIV];
    [self.contentView addSubview:self.merchantNameLB];
    [self.contentView addSubview:self.orderTitleLB];
    [self.contentView addSubview:self.orderAmountLB];
    [self.contentView addSubview:self.confirmBTN];
    self.contentView.frame = CGRectMake(15, 15, kScreenWidth - 30, self.confirmBTN.bottom + 15);

    //    [self setNavCustomLeftView:self.cancenBTN];
    self.hd_navRightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.cancenBTN]];
    [self reflushUI];

    [TalkingData
        trackEvent:@"sdk支付"
             label:self.vipayOrderNo
        parameters:@{@"时间": [NSString stringWithFormat:@"ViPay唤起成功:%@", [HDCommonUtils getCurrentDateStrByFormat:@"yyyy/MM/dd HH:mm:ss:SSS"]], @"网络": [HDCommonUtils getCurrentNetworkType]}];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self queryOrderInfo];
}

- (void)reflushUI {
    self.boldTitle = HDLocalizedString(@"PAGE_TITLE_CONFIRM_PAY", @"确认支付", nil);
}

- (void)orderPay {
    SAMoneyModel *amountModel = [SAMoneyModel modelWithAmount:self.orderInfoModel.amt.stringValue currency:self.orderInfoModel.currency];
    //    HDTradeBuildOrderRspModel *buildModel = [HDTradeBuildOrderRspModel modelWithOrderAmount:amountModel tradeNo:self.orderInfoModel.tradeNo];
    HDTradeBuildOrderModel *buildModel = HDTradeBuildOrderModel.new;
    buildModel.tradeAmountModel = amountModel;
    buildModel.orderNo = self.orderInfoModel.tradeNo;
    // 唤起收银台
    HDCheckStandViewController *checkStandVC = [HDCheckStandViewController checkStandWithTradeBuildModel:buildModel preferedHeight:0];
    checkStandVC.resultDelegate = self;
    [self presentViewController:checkStandVC animated:YES completion:nil];
    self.checkStandVC = checkStandVC;
}

- (void)queryOrderInfo {
    [self showloading];
    __weak __typeof(self) weakSelf = self;
    [self.transVM getOrderInfoWithLoginName:[VipayUser shareInstance].loginName orderNo:self.vipayOrderNo success:^(HDGetOrderInfoRspModel *rspModel) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        //                                        [strongSelf dismissLoadingImmediately];
        //显示订单信息
        [strongSelf.headIV sd_setImageWithURL:[NSURL URLWithString:rspModel.headUrl] placeholderImage:[UIImage imageNamed:@"neutral"]];
        strongSelf.merchantNameLB.text = rspModel.payeeName;
        strongSelf.orderTitleLB.text = rspModel.subject;
        strongSelf.orderAmountLB.text = [HDCommonUtils thousandSeparatorAmount:[HDCommonUtils fenToyuan:rspModel.amt.stringValue] currencyCode:rspModel.currency];
        strongSelf.orderInfoModel = rspModel;
        //打开确认按钮
        [strongSelf.confirmBTN setEnabled:YES];

        [TalkingData
            trackEvent:@"sdk支付"
                 label:strongSelf.vipayOrderNo
            parameters:
                @{@"时间": [NSString stringWithFormat:@"订单查询成功:%@", [HDCommonUtils getCurrentDateStrByFormat:@"yyyy/MM/dd HH:mm:ss:SSS"]], @"网络": [HDCommonUtils getCurrentNetworkType]}];
    }];
}

#pragma mark - event response
- (void)clickOnConfirmButton:(HDBaseButton *)button {
    [self orderPay];
}

- (void)clickOnCancelButton:(UIBarButtonItem *)button {
    __block HDOrderPayViewController *vc = self;

    [NAT showAlertWithMessage:HDLocalizedString(@"ALERT_MSG_CANCEL_TRANSATION", @"是否放弃本次交易？", nil) confirmButtonTitle:HDLocalizedString(@"BUTTON_TITLE_CONFIRM", @"确认", @"Buttons")
        confirmButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
            [vc dismissViewControllerAnimated:YES completion:^{
                [self backToMerchant];
            }];
            [alertView dismiss];
        }
        cancelButtonTitle:HDLocalizedString(@"BUTTON_TITLE_CANCEL", @"取消", @"Buttons") cancelButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
            [alertView dismiss];
        }];
}

#pragma mark - HDCheckStandViewControllerDelegate
/** 支付成功 */
- (void)checkStandViewController:(HDCheckStandViewController *)controller paymentSuccess:(HDTradeSubmitPaymentRspModel *)rspModel {
    [controller dismissViewControllerCompletion:^{
        HDPayOrderRspModel *payOrderRspModel = [HDPayOrderRspModel modelFromTradeSubmitPaymentRspModel:rspModel];

        if (payOrderRspModel.status.integerValue == HDOrderStatusSuccess) {
            [self orderPaySuccess:payOrderRspModel];
        } else {
            [self orderPayFailure:payOrderRspModel];
        }
    }];
}

/** 支付失败 */
- (void)checkStandViewController:(HDCheckStandViewController *)controller transactionFailure:(HDBaseViewModel *)viewModel reason:(NSString *)reason code:(NSString *)code {
    [self dismissLoading];

    [TalkingData trackEvent:@"sdk支付" label:self.vipayOrderNo parameters:@{
        @"原因": [NSString stringWithFormat:@"(%@)%@", code, reason],
        @"时间": [NSString stringWithFormat:@"订单支付失败:%@", [HDCommonUtils getCurrentDateStrByFormat:@"yyyy/MM/dd HH:mm:ss:SSS"]],
        @"网络": [HDCommonUtils getCurrentNetworkType]
    }];

    __weak __typeof(self) weakSelf = self;
    if ([code containsString:@"V1087"]) {
        [NAT showAlertWithMessage:reason buttonTitle:HDLocalizedString(@"BUTTON_TITLE_REINPUT", @"重新输入", @"Buttons") handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
            [controller.textField clear];
            [controller.textField becomeFirstResponder];
            [alertView dismiss];
        }];
    } else if ([code containsString:@"V1007"]) {
        [NAT showAlertWithMessage:reason confirmButtonTitle:HDLocalizedString(@"BUTTON_TITLE_REINPUT", @"重新输入", @"Buttons")
            confirmButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                [controller.textField clear];
                [controller.textField becomeFirstResponder];

                [alertView dismiss];
            }
            cancelButtonTitle:HDLocalizedString(@"BUTTON_TITLE_FORGET_LOGIN_PWD", @"忘记密码", @"Buttons") cancelButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                [controller dismissViewControllerCompletion:^{
                    [SAWindowManager openUrl:[HDSchemePathUtil urlForSchemeStr:kRouteSchemaViPay routePath:kRoutePathResetPaymentPwd] withParameters:nil];
                }];
                [alertView dismiss];
            }];
    } else if ([code isEqualToString:@"C0011"]) { //余额不足
        [NAT showAlertWithMessage:reason buttonTitle:HDLocalizedString(@"BUTTON_TITLE_SURE", @"确定", @"Buttons") handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
            [alertView dismiss];
        }];
        //        [NAT showAlertWithMessage:reason
        //            confirmButtonTitle:HDLocalizedString(@"BUTTON_TITLE_GO_TO_RECHARGE", @"去充值", @"Buttons")
        //            confirmButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
        //                [alertView dismissCompletion:^{
        //                    [controller dismissViewControllerCompletion:^{
        //                        [SAWindowManager openUrl:[HDSchemePathUtil urlForScheme:kRouteSchemaViPay routePath:kRoutePathBranchMap] withParameters:nil];
        //                        [SATalkingData trackEvent:@"入金地图_进入" label:@"余额不足"];
        //                    }];
        //                }];
        //            }
        //            cancelButtonTitle:HDLocalizedString(@"BUTTON_TITLE_CANCEL", @"取消", @"Buttons")
        //            cancelButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
        //                [alertView dismiss];
        //            }];

    } else if ([self shouldGoToResultPageByCode:code]) {
        [controller dismissViewControllerCompletion:^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;

            HDPayOrderRspModel *rspModel = [HDPayOrderRspModel new];
            rspModel.rspCode = code;
            rspModel.rspMsg = reason;
            rspModel.status = [NSNumber numberWithInteger:HDOrderStatusFailure];
            rspModel.tradeType = HDTransTypeConsume;

            [strongSelf orderPayFailure:rspModel];
        }];
    } else {
        [controller dismissViewControllerCompletion:^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            //            [strongSelf viewModel:viewModel transactionFailure:reason code:code];
        }];
    }
}
- (BOOL)shouldGoToResultPageByCode:(NSString *)code {
    if ([GOTO_RESULT_CODE containsString:code]) {
        return YES;
    }

    return NO;
}
- (void)checkStandViewController:(HDCheckStandViewController *)controller confirmOrderSuccessWithVoucherNo:(NSString *)voucherNo {
    [TalkingData
        trackEvent:@"sdk支付"
             label:self.vipayOrderNo
        parameters:@{@"时间": [NSString stringWithFormat:@"订单确认成功:%@", [HDCommonUtils getCurrentDateStrByFormat:@"yyyy/MM/dd HH:mm:ss:SSS"]], @"网络": [HDCommonUtils getCurrentNetworkType]}];
}

- (void)orderPaySuccess:(HDPayOrderRspModel *)rspModel {
    [TalkingData
        trackEvent:@"APP支付"
             label:rspModel.tradeNo
        parameters:@{@"时间": [NSString stringWithFormat:@"订单支付成功:%@", [HDCommonUtils getCurrentDateStrByFormat:@"yyyy/MM/dd HH:mm:ss:SSS"]], @"网络": [HDCommonUtils getCurrentNetworkType]}];

    //    HDOrderPayResultViewController *vc = [[HDOrderPayResultViewController alloc] init];
    //
    //    vc.rspModel = rspModel;
    //    __weak __typeof(self) weakSelf = self;
    //    vc.clickedDoneBtnHandler = ^{
    //        __strong __typeof(weakSelf) strongSelf = weakSelf;
    //        [strongSelf backToMerchant];
    //    };
    //    vc.callBackTitle = @"返回商户";
    //    vc.callBack = ^(SAViewController *vc, UIButton *callButton) {
    //        __strong __typeof(weakSelf) strongSelf = weakSelf;
    //        [strongSelf backToMerchant];
    //    };
    //    [self.navigationController pushViewController:vc animated:YES];

    [TalkingData
        trackEvent:@"sdk支付"
             label:self.vipayOrderNo
        parameters:@{@"时间": [NSString stringWithFormat:@"订单支付成功:%@", [HDCommonUtils getCurrentDateStrByFormat:@"yyyy/MM/dd HH:mm:ss:SSS"]], @"网络": [HDCommonUtils getCurrentNetworkType]}];
}

- (void)orderPayFailure:(HDPayOrderRspModel *)rspModel {
    [TalkingData trackEvent:@"APP支付" label:rspModel.tradeNo parameters:@{
        @"原因": [NSString stringWithFormat:@"(%@)%@", rspModel.rspCode, rspModel.rspMsg],
        @"时间": [NSString stringWithFormat:@"订单支付失败:%@", [HDCommonUtils getCurrentDateStrByFormat:@"yyyy/MM/dd HH:mm:ss:SSS"]],
        @"网络": [HDCommonUtils getCurrentNetworkType]
    }];

    //    HDOrderPayResultViewController *vc = [[HDOrderPayResultViewController alloc] init];
    //
    //    vc.rspModel = rspModel;
    //    __weak __typeof(self) weakSelf = self;
    //    vc.clickedDoneBtnHandler = ^{
    //        __strong __typeof(weakSelf) strongSelf = weakSelf;
    //        [strongSelf backToMerchant];
    //    };
    //    vc.callBackTitle = @"返回商户";
    //    vc.callBack = ^(SAViewController *vc, UIButton *callButton) {
    //        __strong __typeof(weakSelf) strongSelf = weakSelf;
    //        [strongSelf backToMerchant];
    //    };
    //    [self.navigationController pushViewController:vc animated:YES];

    [TalkingData trackEvent:@"sdk支付" label:self.vipayOrderNo parameters:@{
        @"原因": rspModel.rspMsg,
        @"时间": [NSString stringWithFormat:@"订单支付失败:%@", [HDCommonUtils getCurrentDateStrByFormat:@"yyyy/MM/dd HH:mm:ss:SSS"]],
        @"网络": [HDCommonUtils getCurrentNetworkType]
    }];
}

- (void)backToMerchant {
    HDBaseCallBackModel *callBack = [HDBaseCallBackModel new];
    callBack.resultStatus = CALLBACK_RSP_USERCANCEL;

    NSString *urlStr = [NSString
        stringWithFormat:@"%@://vipay.x-vipay.com/result.do?result=%@", self.merchantScheme, [[callBack yy_modelToJSONString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:urlStr];

    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            if (success) {
                HDLog(@"open success");
            } else {
                HDLog(@"open fail");
            }
        }];
    } else {
        [[UIApplication sharedApplication] openURL:url];
    }

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - lazy load
- (HDTransCenterViewModel *)transVM {
    if (!_transVM) {
        _transVM = [HDTransCenterViewModel new];
        _transVM.delegate = self;
    }
    return _transVM;
}

- (HDShadowBlankView *)contentView {
    if (!_contentView) {
        _contentView = [[HDShadowBlankView alloc] initWithFrame:CGRectMake(15, 15, kScreenWidth - 30, 300)];
    }

    return _contentView;
}

- (UIImageView *)headIV {
    if (!_headIV) {
        _headIV = [[UIImageView alloc] initWithFrame:CGRectMake((self.contentView.width - 65) / 2, 15, 65, 65)];
        _headIV.layer.cornerRadius = 65 / 2.0f;
        _headIV.layer.masksToBounds = YES;
        _headIV.image = [UIImage imageNamed:@"neutral"];
    }

    return _headIV;
}

- (UILabel *)merchantNameLB {
    if (!_merchantNameLB) {
        _merchantNameLB = [[UILabel alloc] initWithFrame:CGRectMake(15, self.headIV.bottom + 15, self.contentView.width - 30, 20)];
        _merchantNameLB.textAlignment = NSTextAlignmentCenter;
        _merchantNameLB.textColor = kTextColor38;
        _merchantNameLB.font = kFontAuto(KFontSize14);
        _merchantNameLB.lineBreakMode = NSLineBreakByTruncatingTail;
        _merchantNameLB.numberOfLines = 2;
    }
    return _merchantNameLB;
}

- (UILabel *)orderTitleLB {
    if (!_orderTitleLB) {
        _orderTitleLB = [[UILabel alloc] initWithFrame:CGRectMake(15, self.merchantNameLB.bottom + 25, self.contentView.width - 30, 20)];
        _orderTitleLB.textAlignment = NSTextAlignmentCenter;
        _orderTitleLB.textColor = kTextColor123;
        _orderTitleLB.font = kFontAuto(KFontSize14);
        _orderTitleLB.lineBreakMode = NSLineBreakByTruncatingTail;
        _orderTitleLB.numberOfLines = 2;
    }
    return _orderTitleLB;
}

- (UILabel *)orderAmountLB {
    if (!_orderAmountLB) {
        _orderAmountLB = [[UILabel alloc] initWithFrame:CGRectMake(15, self.orderTitleLB.bottom + 10, self.contentView.width - 30, 20)];
        _orderAmountLB.textAlignment = NSTextAlignmentCenter;
        _orderAmountLB.textColor = kTextColor38;
        _orderAmountLB.font = kFontAuto(KFontSize23);
        _orderAmountLB.text = @"-";
    }
    return _orderAmountLB;
}

- (HDBaseButton *)confirmBTN {
    if (!_confirmBTN) {
        _confirmBTN = [[HDBaseButton alloc] initWithFrame:CGRectMake(15, self.orderAmountLB.bottom + 50, self.contentView.width - 30, 45)];
        [_confirmBTN addTarget:self action:@selector(clickOnConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
        [_confirmBTN setTitle:HDLocalizedString(@"BTN_TITLE_CONFIRM_PAY", @"确认支付", @"Buttons") forState:UIControlStateNormal];
        [_confirmBTN setEnabled:NO];
    }
    return _confirmBTN;
}

- (UIButton *)cancenBTN {
    if (!_cancenBTN) {
        _cancenBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancenBTN setTitle:HDLocalizedString(@"BUTTON_TITLE_CANCEL", @"取消", @"Buttons") forState:UIControlStateNormal];
        [_cancenBTN addTarget:self action:@selector(clickOnCancelButton:) forControlEvents:UIControlEventTouchUpInside];
        _cancenBTN.titleLabel.font = kFontAuto(KFontSize12);
    }
    return _cancenBTN;
}
@end
