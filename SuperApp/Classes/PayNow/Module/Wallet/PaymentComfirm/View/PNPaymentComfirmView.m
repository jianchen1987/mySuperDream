//
//  PNPaymentComfirmView.m
//  SuperApp
//
//  Created by xixi_wen on 2023/2/9.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "PNPaymentComfirmView.h"
#import "PNBottomView.h"
#import "PNInfoView.h"
#import "PNPaymentComfirmViewController.h"
#import "PNPaymentComfirmViewModel.h"
#import "PNPaymentResultViewController.h"
#import "PNSelectPayAmountView.h"
#import "PayHDCheckstandViewController.h"
#import "PayPassWordTip.h"
#import "SAChangePayPwdAskingViewController.h"


@interface PNPaymentComfirmView () <PayHDCheckstandViewControllerDelegate>
@property (nonatomic, strong) PNBottomView *bottomView;
@property (nonatomic, strong) PNSelectPayAmountView *selectView;

@property (nonatomic, strong) PNPaymentComfirmViewModel *viewModel;
@end


@implementation PNPaymentComfirmView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_bindViewModel {
    [self.viewModel hd_bindView:self];

    @HDWeakify(self);
    [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        [self setData];
    }];

    if (self.viewModel.buildModel.fromType == PNPaymentBuildFromType_Default || self.viewModel.buildModel.fromType == PNPaymentBuildFromType_Middle) {
        [self.viewModel getData:PNWalletBalanceType_Non];
    } else {
        [self setData];
    }
}

- (void)hd_setupViews {
    [self addSubview:self.scrollView];
    self.scrollView.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self.scrollView addSubview:self.scrollViewContainer];
    [self addSubview:self.bottomView];

    self.scrollView.hidden = YES;
    self.bottomView.hidden = YES;
}

- (void)updateConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.equalTo(self);
        make.bottom.mas_equalTo(self.bottomView.mas_top);
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
    }];

    NSArray<UIView *> *visableInfoViews = [self.scrollViewContainer.subviews hd_filterWithBlock:^BOOL(UIView *_Nonnull item) {
        return !item.isHidden;
    }];

    UIView *lastInfoView;
    for (UIView *infoView in visableInfoViews) {
        [infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (lastInfoView) {
                make.top.equalTo(lastInfoView.mas_bottom);
            } else {
                make.top.equalTo(self.scrollViewContainer);
            }
            make.left.equalTo(self.scrollViewContainer);
            make.right.equalTo(self.scrollViewContainer);
            if (infoView == visableInfoViews.lastObject) {
                make.bottom.equalTo(self.scrollViewContainer);
            }
        }];
        lastInfoView = infoView;
    }

    [super updateConstraints];
}

#pragma mark
- (void)goToPaymentResult:(PayHDTradeSubmitPaymentRspModel *)rspModel {
    void (^completeBlock)(void) = ^{
        /// 点击了右上角的完成 进行返回
        PNPaymentComfirmViewController *controller = (PNPaymentComfirmViewController *)self.viewController;
        if (controller.delegate && [controller.delegate respondsToSelector:@selector(paymentSuccess:controller:)]) {
            [controller.delegate paymentSuccess:rspModel controller:controller];
        }
    };

    PNPaymentResultViewController *vc = [[PNPaymentResultViewController alloc] initWithRouteParameters:@{
        @"tradeNo": self.viewModel.buildModel.tradeNo,
        @"completeBlock": completeBlock,
    }];
    [SAWindowManager.visibleViewController presentViewController:[[SANavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
}

/** 支付成功 */
- (void)checkStandViewController:(PayHDCheckstandViewController *)controller paymentSuccess:(PayHDTradeSubmitPaymentRspModel *)rspModel {
    HDLog(@"支付成功");

    @HDWeakify(self);
    if (self.viewModel.buildModel.isShowUnifyPayResult) {
        [controller dismissAnimated:YES completion:^{
            @HDStrongify(self);
            [self goToPaymentResult:rspModel];
        }];
    } else {
        [controller dismissAnimated:YES completion:^{
            @HDStrongify(self);
            PNPaymentComfirmViewController *controller = (PNPaymentComfirmViewController *)self.viewController;
            if (controller.delegate && [controller.delegate respondsToSelector:@selector(paymentSuccess:controller:)]) {
                [controller.delegate paymentSuccess:rspModel controller:controller];
            }
        }];
    }
}

/** 支付失败 */
- (void)checkStandViewController:(PayHDCheckstandViewController *)controller transactionFailure:(NSString *)reason code:(NSString *)code {
    HDLog(@"支付失败");

    if (self.viewModel.buildModel.fromType == PNPaymentBuildFromType_MerchantWithdraw) {
        if ([code containsString:@"U1087"]) {
            [NAT showAlertWithMessage:reason buttonTitle:PNLocalizedString(@"BUTTON_TITLE_REINPUT", @"重新输入") handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                [controller.textField clear];
                [controller.textField becomeFirstResponder];
                [alertView dismiss];
            }];
        } else if ([code containsString:@"U1017"]) {
            [PayPassWordTip showPayPassWordTipViewToView:[UIApplication sharedApplication].windows.firstObject IconImgName:@"" Detail:reason CancelBtnText:@"" SureBtnText:@"" SureCallBack:^{
                [controller.textField clear];
                [controller.textField becomeFirstResponder];
                HDLog(@"确定");
            } CancelCallBack:^{
                [controller.textField clear];
                // 修改交易密码
                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
                void (^clickedRememberBlock)(void) = ^{
                    NSMutableDictionary *updatePWdParams = [NSMutableDictionary dictionaryWithCapacity:3];
                    void (^completion)(BOOL) = ^(BOOL isSuccess) {
                        [SAWindowManager.visibleViewController.navigationController dismissViewControllerAnimated:YES completion:nil];
                    };
                    updatePWdParams[@"completion"] = completion;
                    // 校验旧密码修改密码
                    updatePWdParams[@"actionType"] = @(3);
                    updatePWdParams[@"operatorNo"] = VipayUser.shareInstance.operatorNo;
                    [HDMediator.sharedInstance navigaveToPayNowMerchantServicesSetTradePwdVC:updatePWdParams];
                };
                params[@"rememberCallback"] = clickedRememberBlock;
                void (^clickedForgetBlock)(void) = ^{
                    void (^completion)(BOOL) = ^(BOOL isSuccess) {
                        [SAWindowManager.visibleViewController.navigationController dismissViewControllerAnimated:YES completion:nil];
                    };
                    /// 忘记密码  发送短信
                    NSMutableDictionary *sendSMSParams = [NSMutableDictionary dictionaryWithCapacity:2];
                    sendSMSParams[@"operatorNo"] = VipayUser.shareInstance.operatorNo;
                    sendSMSParams[@"completion"] = completion;
                    [HDMediator.sharedInstance navigaveToPayNowMerchantServicesPwdSendSMSVC:sendSMSParams];
                };
                params[@"forgetCallback"] = clickedForgetBlock;
                params[@"present"] = @(1);
                [HDMediator.sharedInstance navigaveToPayNowMerchantServicesAskTradePasswordVC:params];
            }];
        } else if ([self shouldGoToResultPageByCode:code]) {
            [NAT showAlertWithMessage:reason buttonTitle:PNLocalizedString(@"BUTTON_TITLE_SURE", @"确定") handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                [alertView dismiss];
            }];
        } else {
            [controller dismissViewControllerCompletion:^{
                [NAT showAlertWithMessage:reason buttonTitle:PNLocalizedString(@"BUTTON_TITLE_SURE", @"确定") handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                    [alertView dismiss];
                }];
            }];
        }
    } else {
        if ([code containsString:@"V1087"]) {
            [NAT showAlertWithMessage:reason buttonTitle:PNLocalizedString(@"BUTTON_TITLE_REINPUT", @"重新输入") handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                [controller.textField clear];
                [controller.textField becomeFirstResponder];
                [alertView dismiss];
            }];
        } else if ([code containsString:@"V1007"]) {
            [PayPassWordTip showPayPassWordTipViewToView:[UIApplication sharedApplication].windows.firstObject IconImgName:@"" Detail:reason CancelBtnText:@"" SureBtnText:@"" SureCallBack:^{
                [controller.textField clear];
                [controller.textField becomeFirstResponder];
                HDLog(@"确定");
            } CancelCallBack:^{
                [controller.textField clear];
                [controller.textField becomeFirstResponder];

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
                    [HDMediator.sharedInstance navigaveToPayNowPasswordContactUSVC:params];
                };
                params[@"clickedForgetBlock"] = clickedForgetBlock;
                SAChangePayPwdAskingViewController *vc = [[SAChangePayPwdAskingViewController alloc] initWithRouteParameters:params];
                [SAWindowManager.visibleViewController presentViewController:[[SANavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
            }];
        } else if ([code containsString:@"V1015"]) { //密码错误
            [PayPassWordTip showPayPassWordTipViewToView:[UIApplication sharedApplication].windows.firstObject IconImgName:@""
                Detail:[NSString stringWithFormat:@"%@ %d %@", PNLocalizedString(@"enter_the_rest", @""), [PNCommonUtils getnum:reason], PNLocalizedString(@"Times", @"")]
                CancelBtnText:@""
                SureBtnText:@"" SureCallBack:^{
                    [controller.textField clear];
                    [controller.textField becomeFirstResponder];
                } CancelCallBack:^{
                    [controller.textField clear];
                    [controller.textField becomeFirstResponder];

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
        } else if ([self shouldGoToResultPageByCode:code]) {
            [NAT showAlertWithMessage:reason buttonTitle:PNLocalizedString(@"BUTTON_TITLE_SURE", @"确定") handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                [alertView dismiss];
            }];
        } else {
            [controller dismissViewControllerCompletion:^{
                [NAT showAlertWithMessage:reason buttonTitle:PNLocalizedString(@"BUTTON_TITLE_SURE", @"确定") handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                    [alertView dismiss];
                }];
            }];
        }
    }
}

- (BOOL)shouldGoToResultPageByCode:(NSString *)code {
    if ([GOTO_RESULT_CODE containsString:code]) {
        return YES;
    }

    return NO;
}

#pragma mark
- (void)setData {
    self.scrollView.hidden = NO;
    self.bottomView.hidden = NO;

    if (self.viewModel.buildModel.fromType == PNPaymentBuildFromType_Default || self.viewModel.buildModel.fromType == PNPaymentBuildFromType_Middle) {
        [self.bottomView setBtnEnable:self.viewModel.model.balanceEnough];
        [self drawNorPaymentComfirm];
    } else {
        [self.bottomView setBtnEnable:YES];
        [self draWithdarwComfirm];
    }
}

#pragma mark
/// 确认支付UI
- (void)drawNorPaymentComfirm {
    [self.scrollViewContainer hd_removeAllSubviews];

    [self.scrollViewContainer addSubview:[self createSectionInfoView:PNLocalizedString(@"dRTBg4UD", @"业务信息") value:@""]];
    [self.scrollViewContainer addSubview:[self createInfoView:PNLocalizedString(@"vHTu9ZGs", @"业务类型") value:self.viewModel.model.transactionTypeEnum.message ?: @"" lineWidth:1]];
    [self.scrollViewContainer addSubview:[self createInfoViewAmount:PNLocalizedString(@"pQAaSPwA", @"交易金额") value:self.viewModel.model.tradeAmount.thousandSeparatorAmount lineWidth:0]];

    [self.scrollViewContainer addSubview:[self createSectionInfoView:PNLocalizedString(@"dNrknSgO", @"钱包账户信息") value:@""]];
    [self.scrollViewContainer addSubview:[self createInfoView:PNLocalizedString(@"AP6bl5V6", @"钱包账号") value:self.viewModel.model.walletAccount lineWidth:1]];
    [self.scrollViewContainer addSubview:[self createInfoView:PNLocalizedString(@"EflnCwt2", @"手机号") value:self.viewModel.model.loginName lineWidth:1]];
    [self.scrollViewContainer addSubview:self.selectView];

    self.selectView.model = self.viewModel.model;

    [self setNeedsUpdateConstraints];
}

/// 提现UI
- (void)draWithdarwComfirm {
    [self.scrollViewContainer hd_removeAllSubviews];

    [self.scrollViewContainer addSubview:[self createSectionInfoView:PNLocalizedString(@"dRTBg4UD", @"业务信息") value:@""]];
    [self.scrollViewContainer addSubview:[self createInfoView:PNLocalizedString(@"vHTu9ZGs", @"业务类型") value:PNLocalizedString(@"pn_Withdraw", @"提现") lineWidth:1]];
    [self.scrollViewContainer addSubview:[self createInfoViewAmount:PNLocalizedString(@"pn_withdarw_amount", @"提现金额")
                                                              value:self.viewModel.buildModel.extendWithdrawModel.caseInAmount.thousandSeparatorAmount
                                                          lineWidth:0]];

    [self.scrollViewContainer addSubview:[self createSectionInfoView:PNLocalizedString(@"dNrknSgO", @"钱包账户信息") value:@""]];
    [self.scrollViewContainer addSubview:[self createInfoView:PNLocalizedString(@"AP6bl5V6", @"钱包账号") value:VipayUser.shareInstance.customerNo lineWidth:1]];
    [self.scrollViewContainer addSubview:[self createInfoView:PNLocalizedString(@"EflnCwt2", @"手机号") value:VipayUser.shareInstance.loginName lineWidth:0]];

    [self.scrollViewContainer addSubview:[self createSectionInfoView:PNLocalizedString(@"gF1rn9Qc", @"收款账号信息") value:@""]];
    [self.scrollViewContainer addSubview:[self createInfoView:PNLocalizedString(@"pn_receiver_account", @"收款账号") value:self.viewModel.buildModel.extendWithdrawModel.accountNumber lineWidth:1]];
    [self.scrollViewContainer addSubview:[self createInfoView:PNLocalizedString(@"8JOkLAyq", @"收款户名") value:self.viewModel.buildModel.extendWithdrawModel.accountName lineWidth:1]];
    [self.scrollViewContainer addSubview:[self createInfoView:PNLocalizedString(@"pn_Receiving_bank", @"收款银行") value:self.viewModel.buildModel.extendWithdrawModel.bankName lineWidth:0]];

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (PNInfoViewModel *)infoViewModelWithKey:(NSString *)key value:(NSString *)value backgroundColor:(UIColor *)backgroundColor lineWidth:(NSInteger)lineWidth {
    PNInfoViewModel *model = PNInfoViewModel.new;
    model.backgroundColor = backgroundColor;

    model.keyText = key;
    model.keyColor = HDAppTheme.PayNowColor.c333333;
    model.keyFont = HDAppTheme.PayNowFont.standard16;

    model.valueText = value;
    model.valueFont = HDAppTheme.PayNowFont.standard16B;
    model.valueColor = HDAppTheme.PayNowColor.c333333;

    model.lineWidth = lineWidth;
    model.lineColor = HDAppTheme.PayNowColor.cECECEC;
    return model;
}

- (PNInfoView *)createSectionInfoView:(NSString *)key value:(NSString *)value {
    PNInfoView *view = PNInfoView.new;
    PNInfoViewModel *model = [self infoViewModelWithKey:key value:value backgroundColor:HDAppTheme.PayNowColor.backgroundColor lineWidth:0];
    model.keyFont = HDAppTheme.PayNowFont.standard16B;
    model.keyColor = HDAppTheme.PayNowColor.c333333;
    model.contentEdgeInsets = UIEdgeInsetsMake(12, 12, 8, 12);
    view.model = model;
    return view;
}

- (PNInfoView *)createInfoView:(NSString *)key value:(NSString *)value lineWidth:(NSInteger)lineWidth {
    PNInfoView *view = PNInfoView.new;
    PNInfoViewModel *model = [self infoViewModelWithKey:key value:value backgroundColor:HDAppTheme.PayNowColor.cFFFFFF lineWidth:lineWidth];
    view.model = model;
    return view;
}

- (PNInfoView *)createInfoViewAmount:(NSString *)key value:(NSString *)value lineWidth:(NSInteger)lineWidth {
    PNInfoView *view = PNInfoView.new;
    PNInfoViewModel *model = [self infoViewModelWithKey:key value:value backgroundColor:HDAppTheme.PayNowColor.cFFFFFF lineWidth:lineWidth];
    model.valueFont = [HDAppTheme.PayNowFont fontDINBold:16];
    view.model = model;
    return view;
}

- (PNBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[PNBottomView alloc] initWithTitle:PNLocalizedString(@"pn_confirm", @"确认")];
        [_bottomView setBtnEnable:NO];

        @HDWeakify(self);
        _bottomView.btnClickBlock = ^{
            @HDStrongify(self);
            [self.viewModel paymentComfirm:^(PayHDTradeConfirmPaymentRspModel *_Nonnull rspModel) {
                PayHDTradeBuildOrderRspModel *model = [[PayHDTradeBuildOrderRspModel alloc] init];
                model.tradeNo = self.viewModel.buildModel.tradeNo;

                NSString *tipsStr = self.viewModel.model.tradeAmount.thousandSeparatorAmount;

                if (WJIsStringEmpty(tipsStr)) {
                    tipsStr = self.viewModel.buildModel.extendWithdrawModel.caseInAmount.thousandSeparatorAmount;
                }
                model.tipsStr = tipsStr;
                model.payWay = self.viewModel.buildModel.payWay;
                model.subTradeType = self.viewModel.buildModel.subTradeType;
                model.confirmRspMode = rspModel;

                PayHDCheckstandViewController *checkStandVC = [PayHDCheckstandViewController pn_payCheckStandWithTradeBuildModel:model];
                checkStandVC.resultDelegate = self;
                [self.viewController.navigationController presentViewController:checkStandVC animated:YES completion:nil];
            }];
        };
    }
    return _bottomView;
}

- (PNSelectPayAmountView *)selectView {
    if (!_selectView) {
        _selectView = [[PNSelectPayAmountView alloc] initWithViewModel:self.viewModel];
    }
    return _selectView;
}

@end
