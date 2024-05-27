//
//  PNMSSettingViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2022/7/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSSettingViewController.h"
#import "PNInfoView.h"
#import "PNMSAgreementDataModel.h"
#import "PNMSBaseInfoModel.h"
#import "PNMSHomeDTO.h"
#import "PNMSSettingDTO.h"
#import "PayHDCheckstandViewController.h"
#import "PayPassWordTip.h"
#import "VipayUser.h"


@interface PNMSSettingViewController () <PayHDCheckstandViewControllerDelegate>
/// 商户信息
@property (nonatomic, strong) PNInfoView *merchantInfoInfoView;
/// 解除绑定
@property (nonatomic, strong) PNInfoView *unBindInfoInfoView;
///  商户支付服务协议
@property (nonatomic, strong) PNInfoView *merchantServiceAgreementInfoView;
/// 修改交易密码
@property (nonatomic, strong) PNInfoView *changePayPwdInfoView;

/// 操作员编号
@property (nonatomic, strong) NSString *operatorNo;
/// 商户编号
@property (nonatomic, strong) NSString *merchantNo;
///
@property (nonatomic, strong) PNMSSettingDTO *settingDTO;
@property (nonatomic, strong) NSArray *agreementDataArray;
@property (nonatomic, strong) PNMSHomeDTO *homeDTO;
@end


@implementation PNMSSettingViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (self) {
        self.merchantNo = VipayUser.shareInstance.merchantNo;
        self.operatorNo = VipayUser.shareInstance.operatorNo;
    }
    return self;
}

- (void)hd_setupViews {
    self.view.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
    self.scrollViewContainer.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;

    [self.scrollViewContainer addSubview:self.merchantInfoInfoView];
    if (VipayUser.shareInstance.role == PNMSRoleType_MANAGEMENT || [VipayUser hasWalletWithdrawMenu]) {
        [self.scrollViewContainer addSubview:self.changePayPwdInfoView];
    }

    if (VipayUser.shareInstance.role == PNMSRoleType_MANAGEMENT) {
        [self.scrollViewContainer addSubview:self.merchantServiceAgreementInfoView];
        [self.scrollViewContainer addSubview:self.unBindInfoInfoView];
    }
}

- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"settings", @"设置");
}

- (void)hd_bindViewModel {
    if (VipayUser.shareInstance.role == PNMSRoleType_MANAGEMENT) {
        [self getMSAgreement];
    }
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return YES;
}

#pragma mark - layout
- (void)updateViewConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.width.bottom.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom).offset(kRealWidth(8));
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];

    NSArray<PNInfoView *> *visableInfoViews = [self.scrollViewContainer.subviews hd_filterWithBlock:^BOOL(PNInfoView *_Nonnull item) {
        return !item.isHidden;
    }];

    PNInfoView *lastInfoView;
    for (PNInfoView *infoView in visableInfoViews) {
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

    [super updateViewConstraints];
}

#pragma mark
#pragma mark 获取商户的服务协议【可能是多个】
- (void)getMSAgreement {
    [self.view showloading];

    @HDWeakify(self);
    [self.settingDTO getMSAgreementDataWithMerchantNo:self.merchantNo success:^(NSArray<PNMSAgreementDataModel *> *_Nonnull rspList) {
        @HDStrongify(self);
        [self.view dismissLoading];
        self.agreementDataArray = rspList;

        if (rspList.count > 0) {
            self.merchantServiceAgreementInfoView.hidden = NO;
        } else {
            self.merchantServiceAgreementInfoView.hidden = YES;
        }

        [self.view setNeedsUpdateConstraints];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

- (void)pushVC {
    if (self.agreementDataArray.count == 1) {
        PNMSAgreementDataModel *model = self.agreementDataArray.firstObject;
        [HDMediator.sharedInstance navigaveToPayNowPayWebViewVC:@{
            @"url": model.resUrl,
            @"navTitle": model.resName,
        }];
    }

    if (self.agreementDataArray.count > 1) {
        [HDMediator.sharedInstance navigaveToPayNowMerchantServicesArgeementWarpVC:@{
            @"data": self.agreementDataArray,
        }];
    }
}

- (void)unBind {
    [self showloading];

    @HDWeakify(self);
    [self.homeDTO getMerchantServicesBaseInfo:^(PNMSBaseInfoModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self dismissLoading];
        NSString *msg = [NSString stringWithFormat:PNLocalizedString(@"RNHELxfb", @"商户号：%@\n商户名称：%@"), rspModel.merchantNo, rspModel.merchantName];
        [NAT showAlertWithTitle:PNLocalizedString(@"oXLMrSO8", @"您确定要解除与商户的绑定吗？") message:msg confirmButtonTitle:PNLocalizedString(@"pn_confirm", @"确认")
            confirmButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                [alertView dismiss];
                [self checkPwd];
            }
            cancelButtonTitle:PNLocalizedString(@"BUTTON_TITLE_CANCEL", @"取消") cancelButtonHandler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                [alertView dismiss];
            }];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}

- (void)changePwd {
    // 修改交易密码
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
    void (^clickedRememberBlock)(void) = ^{
        NSMutableDictionary *updatePWdParams = [NSMutableDictionary dictionaryWithCapacity:3];
        void (^completion)(BOOL) = ^(BOOL isSuccess) {
            [self.navigationController popToViewControllerClass:self.class];
        };
        updatePWdParams[@"completion"] = completion;
        // 校验旧密码修改密码
        updatePWdParams[@"actionType"] = @(3);
        updatePWdParams[@"operatorNo"] = self.operatorNo;
        [HDMediator.sharedInstance navigaveToPayNowMerchantServicesSetTradePwdVC:updatePWdParams];
    };
    params[@"rememberCallback"] = clickedRememberBlock;
    void (^clickedForgetBlock)(void) = ^{
        void (^completion)(BOOL) = ^(BOOL isSuccess) {
            [self.navigationController popToViewControllerClass:self.class];
        };
        /// 忘记密码  发送短信
        NSMutableDictionary *sendSMSParams = [NSMutableDictionary dictionaryWithCapacity:2];
        sendSMSParams[@"operatorNo"] = self.operatorNo;
        sendSMSParams[@"completion"] = completion;

        if (VipayUser.shareInstance.role == PNMSRoleType_MANAGEMENT) {
            [HDMediator.sharedInstance navigaveToPayNowMerchantServicesPasswordContactUSVC:params];
        } else {
            [HDMediator.sharedInstance navigaveToPayNowMerchantServicesContactAdminVC:@{}];
        }
    };
    params[@"forgetCallback"] = clickedForgetBlock;
    [HDMediator.sharedInstance navigaveToPayNowMerchantServicesAskTradePasswordVC:params];
}

- (void)checkPwd {
    PNPaymentReqModel *model = [[PNPaymentReqModel alloc] init];
    model.businessType = PNUserBussinessTypePaymentCode;
    model.certifiedType = PNUserCertifiedTypesNon;

    PayHDCheckstandViewController *vc = [PayHDCheckstandViewController checkStandWithBusinessPaymenModel:model preferedHeight:0 style:PayHDCheckstandViewControllerStyleMerchantServicePwd
                                                                                                   title:PNLocalizedString(@"PAYPASSWORD_INPUT_WARM", @"请输入商户交易密码")
                                                                                                  tipStr:@""];
    vc.resultDelegate = self;
    [self presentViewController:vc animated:true completion:nil];
}

- (void)unbindToServer:(NSString *)index pwd:(NSString *)pwd {
    [self showloading];

    @HDWeakify(self);
    [self.homeDTO unBindMerchantServiceWithMerchantNo:self.merchantNo operatorNo:self.operatorNo index:index pwd:pwd success:^(PNRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self dismissLoading];
        [self.navigationController popToViewControllerClass:NSClassFromString(@"PNWalletController") animated:YES];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}

#pragma mark delegate
- (void)checkStandViewController:(PayHDCheckstandViewController *)controller merchantPwd:(NSString *)index password:(nonnull NSString *)password {
    [self dismissLoading];
    [controller dismissViewControllerAnimated:YES completion:^{
        [self unbindToServer:index pwd:password];
    }];
    HDLog(@"index:%@ - pwd:%@", index, password);
}

/** 支付失败 */
- (void)checkStandViewController:(PayHDCheckstandViewController *)controller transactionFailure:(NSString *)reason code:(NSString *)code {
    [self dismissLoading];

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
            [self changePwd];
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

                [self changePwd];
            }];
    } else {
        [controller dismissViewControllerCompletion:^{
            [NAT showAlertWithMessage:reason buttonTitle:PNLocalizedString(@"BUTTON_TITLE_SURE", @"确定") handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                [alertView dismiss];
            }];
        }];
    }
}
/**
 获取凭证成功
 */
- (void)checkStandViewController:(PayHDCheckstandViewController *)controller confirmOrderSuccessWithVoucherNo:(NSString *)voucherNo {
    HDLog(@"获取凭证成功");
}

/**
 密码输入完成
 */
- (void)checkStandViewController:(PayHDCheckstandViewController *)controller completedInputPassword:(PayHDCheckstandTextField *)textField {
    HDLog(@"密码输入完成");
}

/**
 用户取消支付

 @param controller 收银台
 */
- (void)checkStandViewControllerUserClosedCheckStand:(PayHDCheckstandViewController *)controller {
    HDLog(@"用户取消支付");
}

/**
 订单超过5分钟内未支付
 @param type 超时支付时用户所在的页面
 */
- (void)checkStandViewControllerPaymentOverTime:(PayHDCheckstandViewController *)controller endActionType:(PayHDCheckstandPaymentOverTimeEndActionType)type {
    HDLog(@"订单超过5分钟内未支付");
}

/**
 验证支付密码成功

 @param controller 收银台
 @param token 凭证
 @param index 加密因子
 @param password 加密后的密码
 */
- (void)checkStandViewController:(PayHDCheckstandViewController *)controller verifyPwdPaymentPasswordSuccess:(NSString *)token index:(NSString *)index password:(NSString *)password {
    HDLog(@"验证支付密码成功");
}

/**
 验证支付密码失败

 @param controller 收银台
 @param reason 失败原因
 @param code 失败 code
 */
- (void)checkStandViewController:(PayHDCheckstandViewController *)controller verifyPwdPaymentPasswordFailed:(NSString *)reason code:(NSString *)code {
    HDLog(@"验证支付密码失败");
}

#pragma mark - private methods
- (PNInfoViewModel *)infoViewModelWithKey:(NSString *)key {
    PNInfoViewModel *model = PNInfoViewModel.new;
    model.keyColor = HDAppTheme.color.G1;
    model.valueColor = HDAppTheme.color.G3;
    model.keyText = key;
    model.enableTapRecognizer = true;
    model.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
    return model;
}

- (PNInfoViewModel *)infoViewModelWithArrowImageAndKey:(NSString *)key {
    PNInfoViewModel *model = [self infoViewModelWithKey:key];
    model.rightButtonImage = [UIImage imageNamed:@"pn_arrow_gray_small"];
    return model;
}

#pragma mark
- (PNInfoView *)merchantInfoInfoView {
    if (!_merchantInfoInfoView) {
        PNInfoView *view = PNInfoView.new;
        view.model = [self infoViewModelWithArrowImageAndKey:PNLocalizedString(@"ms_merchant_info", @"商户信息")];

        @HDWeakify(self);
        view.model.eventHandler = ^{
            @HDStrongify(self);
            [HDMediator.sharedInstance navigaveToMerchantServicesMerchantInfoVC:@{
                @"merchantNo": self.merchantNo,
            }];
        };
        _merchantInfoInfoView = view;
    }
    return _merchantInfoInfoView;
}

- (PNInfoView *)unBindInfoInfoView {
    if (!_unBindInfoInfoView) {
        PNInfoView *view = PNInfoView.new;
        view.model = [self infoViewModelWithArrowImageAndKey:PNLocalizedString(@"FV17a1Mf", @"解除与商户绑定")];

        @HDWeakify(self);
        view.model.eventHandler = ^{
            @HDStrongify(self);
            [self unBind];
        };
        _unBindInfoInfoView = view;
    }
    return _unBindInfoInfoView;
}

- (PNInfoView *)merchantServiceAgreementInfoView {
    if (!_merchantServiceAgreementInfoView) {
        PNInfoView *view = PNInfoView.new;
        view.hidden = YES;
        view.model = [self infoViewModelWithArrowImageAndKey:PNLocalizedString(@"pn_merchant_payment_service_agreement", @"商户支付服务协议")];

        @HDWeakify(self);
        view.model.eventHandler = ^{
            @HDStrongify(self);
            [self pushVC];
        };
        _merchantServiceAgreementInfoView = view;
    }
    return _merchantServiceAgreementInfoView;
}

- (PNInfoView *)changePayPwdInfoView {
    if (!_changePayPwdInfoView) {
        PNInfoView *view = PNInfoView.new;
        view.model = [self infoViewModelWithArrowImageAndKey:(SALocalizedString(@"change_pay_password", @"修改支付密码"))];
        @HDWeakify(self);
        view.model.eventHandler = ^{
            @HDStrongify(self);
            [self changePwd];
        };
        _changePayPwdInfoView = view;
    }
    return _changePayPwdInfoView;
}

- (PNMSSettingDTO *)settingDTO {
    if (!_settingDTO) {
        _settingDTO = [[PNMSSettingDTO alloc] init];
    }
    return _settingDTO;
}

- (PNMSHomeDTO *)homeDTO {
    if (!_homeDTO) {
        _homeDTO = [[PNMSHomeDTO alloc] init];
    }
    return _homeDTO;
}
@end
