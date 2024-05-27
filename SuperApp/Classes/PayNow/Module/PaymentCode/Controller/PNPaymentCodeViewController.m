//
//  PNPaymentCodeViewController.m
//  SuperApp
//
//  Created by xixi_wen on 2021/12/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNPaymentCodeViewController.h"
#import "HDPasswordManagerViewModel.h"
#import "HDPayOrderRspModel.h"
#import "HDQrCodePaymentResultQueryRsp.h"
#import "HDUserBussinessQueryRsp.h"
#import "PNCommonUtils.h"
#import "PNOpenPaymentCodeView.h"
#import "PNOrderResultViewController.h"
#import "PNPaymentCodeView.h"
#import "PNPaymentCodeViewModel.h"
#import "PayHDCheckStandViewController.h"
#import "PayPassWordTip.h"
#import "SAChangePayPwdAskingViewController.h"
#import "UIViewController+NavigationController.h"
#import "HDSystemCapabilityUtil.h"


@interface PNPaymentCodeViewController () <PayHDCheckstandViewControllerDelegate>
@property (nonatomic, strong) PNPaymentCodeViewModel *viewModel;
@property (nonatomic, strong) HDPasswordManagerViewModel *pwdViewModel;
@property (nonatomic, strong) PNOpenPaymentCodeView *openCodeView;
@property (nonatomic, strong) PNPaymentCodeView *codeView;
@property (nonatomic, strong) HDUIButton *navBtn;
@property (nonatomic, strong) HDUserBussinessQueryRsp *businessQueryRspModel;

@property (nonatomic, assign) BOOL isOpenOneSetup; //记录当前选择的 是否开启了 免密支付 【开启付款码的时候】

@property (nonatomic, strong) dispatch_source_t timer; ///< 定时查询在线付款码支付结果
@property (nonatomic, assign) BOOL isTimerRunning;     ///< 查询付款结果定时器是否在运行

/// 高亮？
@property (nonatomic, assign) BOOL isNeedBrightness;

@end


@implementation PNPaymentCodeViewController


- (void)setScreenBrightnessToMax {
    [HDSystemCapabilityUtil graduallySetBrightness:0.9];
}

- (void)revertScreenBrightnessToOrigin {
    [HDSystemCapabilityUtil graduallyResumeBrightness];
}

- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
}

/// 活跃
- (void)appDidBecomeActive:(NSNotification *)notification {
    if (self.isNeedBrightness) {
        [self setScreenBrightnessToMax];
    }
}

/// 不活跃
- (void)appWillResignActive:(NSNotification *)notification {
    if (self.isNeedBrightness) {
        [self revertScreenBrightnessToOrigin];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.isNeedBrightness) {
        [self revertScreenBrightnessToOrigin];
    }
}

- (void)dealloc {
    HDLog(@"%@ --- dealloc", NSStringFromClass(self.class));
    [_codeView stopTimer];
    [self stopQueryOnlinePaymentCodeResult];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)hd_setupViews {
    self.boldTitle = PNLocalizedString(@"make_payment_to_merchant", @"向商家付款");
    [self registerNotification];
    self.view.backgroundColor = HDAppTheme.PayNowColor.cFD7127;

    [self.view addSubview:self.openCodeView];
    [self.view addSubview:self.codeView];

    [self queryBusinessStatus];
}

- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleTransparent;
}

- (BOOL)hd_shouldHideNavigationBarBottomShadow {
    return true;
}

- (void)updateViewConstraints {
    if (!self.openCodeView.hidden) {
        [self.openCodeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left).offset(kRealWidth(15));
            make.right.mas_equalTo(self.view.mas_right).offset(kRealWidth(-15));
            make.top.mas_equalTo(self.hd_navigationBar.mas_bottom).offset(kRealWidth(5));
        }];
    }

    if (!self.codeView.hidden) {
        [self.codeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left).offset(kRealWidth(15));
            make.right.mas_equalTo(self.view.mas_right).offset(kRealWidth(-15));
            make.top.mas_equalTo(self.hd_navigationBar.mas_bottom).offset(kRealWidth(25));
        }];
    }

    [super updateViewConstraints];
}

#pragma mark
- (void)handlerChoose {
    NSString *sheetItemStr = @"";
    NSString *alertMessage = @"";
    if (self.businessQueryRspModel.payCertifiedType == PNUserCertifiedTypesOpen) {
        sheetItemStr = PNLocalizedString(@"Close_one_step_payment", @"关闭免密支付");
        alertMessage = PNLocalizedString(@"Close_Paymen_Code_Sure", @"关闭免密支付后，每次进入付款码页面前都需要输入支付密码，是否确认关闭？");
    } else {
        sheetItemStr = PNLocalizedString(@"Open_one_step_payment", @"开启免密支付");
        alertMessage = PNLocalizedString(@"Open_Payment_Code_Sure", @"开启免密支付后，每次进入付款码页面无需输入支付密码，是否确认开启？");
    }

    HDActionSheetView *sheetView = [HDActionSheetView alertViewWithCancelButtonTitle:PNLocalizedString(@"BUTTON_TITLE_CANCEL", @"取消") config:nil];
    @HDWeakify(self);
    // clang-format off
    HDActionSheetViewButton *openBTN = [HDActionSheetViewButton buttonWithTitle:sheetItemStr type:HDActionSheetViewButtonTypeCustom handler:^(HDActionSheetView * _Nonnull alertView, HDActionSheetViewButton * _Nonnull button) {
        [sheetView dismiss];
        

        [NAT showAlertWithMessage:alertMessage
            confirmButtonTitle:PNLocalizedString(@"BUTTON_TITLE_SURE", @"确定")
            confirmButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                [alertView dismiss];
            @HDStrongify(self);
            if (self.businessQueryRspModel.payCertifiedType == PNUserCertifiedTypesOpen) {
                [self updatePayOnSetup:PNUserCertifiedTypesNon];
            } else {
                [self updatePayOnSetup:PNUserCertifiedTypesOpen];
            }
            
            }
            cancelButtonTitle:PNLocalizedString(@"BUTTON_TITLE_CANCEL", @"取消")
            cancelButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                [alertView dismiss];
            }];
        
    }];
    HDActionSheetViewButton *stopBTN = [HDActionSheetViewButton buttonWithTitle:PNLocalizedString(@"Suspend_PaymentCode", @"暂停使用") type:HDActionSheetViewButtonTypeCustom handler:^(HDActionSheetView * _Nonnull alertView, HDActionSheetViewButton * _Nonnull button) {
        [sheetView dismiss];
        
        
        [NAT showAlertWithMessage:PNLocalizedString(@"need_open_again", @"付款码让支付更便捷。暂停使用付款码，下次启用需重新开启。")
            confirmButtonTitle:PNLocalizedString(@"Suspend_PaymentCode", @"暂停使用")
            confirmButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                [alertView dismiss];
            @HDStrongify(self);
            [self closePaymentCode];
            }
            cancelButtonTitle:PNLocalizedString(@"BUTTON_TITLE_CANCEL", @"取消")
            cancelButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                [alertView dismiss];
            }];
    }];
    // clang-format on
    [sheetView addButtons:@[openBTN, stopBTN]];
    [sheetView show];
}

- (void)reSetView:(PNUserBussinessStatus)status {
    if (status == PNUserBussinessStatusOpened) {
        self.codeView.hidden = YES;
        self.openCodeView.hidden = YES;
        self.hd_navRightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.navBtn]];
    } else {
        self.codeView.hidden = YES;
        self.openCodeView.hidden = NO;
        self.hd_navRightBarButtonItems = nil;
    }
    [self.view setNeedsUpdateConstraints];
}

- (void)setBrightness {
    self.isNeedBrightness = YES;
    [HDSystemCapabilityUtil saveDefaultBrightness];
    [self setScreenBrightnessToMax];
}

#pragma mark 查询用户业务状态
- (void)queryBusinessStatus {
    [self showloading];
    @HDWeakify(self);
    [self.viewModel queryUserBussinessStatusWithType:PNUserBussinessTypePaymentCode success:^(HDUserBussinessQueryRsp *_Nonnull rspModel) {
        @HDStrongify(self);
        [self dismissLoading];
        HDLog(@"%@", rspModel);
        self.businessQueryRspModel = rspModel;
        ///控制界面
        [self reSetView:rspModel.status];

        if (rspModel.status == PNUserBussinessStatusOpened) {
            [self judgeStatus];
        }
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
        HDLog(@"%@", error);
    }];
}

#pragma mark 逻辑判断
- (void)judgeStatus {
    if (self.businessQueryRspModel.payCertifiedType == PNUserCertifiedTypesOpen) {
        //已经开通免密直接获取 付款二维码 [已经开启不用上送 index password]
        [self getPaymentQRCodeWithIndex:@"" password:@""];
    } else {
        //没有开通免密支付需要 调起支付验证之后再获取到付款二维码
        PNPaymentReqModel *model = [[PNPaymentReqModel alloc] init];
        model.businessType = PNUserBussinessTypePaymentCode;
        model.certifiedType = PNUserCertifiedTypesNon;

        PayHDCheckstandViewController *vc = [PayHDCheckstandViewController checkStandWithBusinessPaymenModel:model preferedHeight:0 style:PayHDCheckstandViewControllerStyleGetPaymentCode
                                                                                                       title:PNLocalizedString(@"PAYPASSWORD_INPUT_WARM", @"请输入支付密码")
                                                                                                      tipStr:@""];
        vc.resultDelegate = self;
        [self presentViewController:vc animated:true completion:nil];
    }
}

/// 获取付款二维码
- (void)getPaymentQRCodeWithIndex:(NSString *)index password:(NSString *)password {
    @HDWeakify(self);
    [self showloading];
    [self.pwdViewModel requestPaymentQRCodeWithBusinessType:PNUserBussinessTypePaymentCode index:index password:password success:^(NSDictionary *rspData) {
        @HDStrongify(self);
        [self dismissLoading];

        [self reSetView:PNUserBussinessStatusOpened];
        PNOpenPaymentRspModel *model = [PNOpenPaymentRspModel yy_modelWithJSON:rspData];
        self.codeView.model = model;
        self.codeView.hidden = NO;
        [self.view setNeedsUpdateConstraints];

        [self startQueryOnlinePaymentCodeResultWithContentCodeStr:model.payCode];

        [self setBrightness];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}

#pragma mark 关闭付款码业务
- (void)closePaymentCode {
    [self showloading];

    @HDWeakify(self);
    [self.viewModel closeBussinessWithType:PNUserBussinessTypePaymentCode success:^{
        @HDStrongify(self);
        [self dismissLoading];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}

#pragma mark 关闭/开启 免密支付
- (void)updatePayOnSetup:(PNUserCertifiedTypes)type {
    [self showloading];
    @HDWeakify(self);
    [self.viewModel updateCertifiledWithType:PNUserBussinessTypePaymentCode operationType:type success:^{
        @HDStrongify(self);
        [self dismissLoading];

        NSString *str = @"";
        if (type == PNUserCertifiedTypesOpen) {
            str = PNLocalizedString(@"Open_successfully", @"开启成功");
        } else {
            str = PNLocalizedString(@"Close_successfully", @"关闭成功");
        }
        self.businessQueryRspModel.payCertifiedType = type;
        [NAT showToastWithTitle:PNLocalizedString(@"VIEW_TEXT_TIPS", @"提示") content:str type:HDTopToastTypeSuccess];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}

#pragma mark 查询交易详情
- (void)getBillDetailWithContentCodeStr:(NSString *)contentCodeStr {
    HDLog(@"来调用交易详情接口了");
    @HDWeakify(self);
    [self.viewModel queryPaymentCodeResultWithContentQrCode:contentCodeStr success:^(HDQrCodePaymentResultQueryRsp *_Nonnull rspModel) {
        @HDStrongify(self);
        // 只要不是成功或者失败就一直轮询
        if (rspModel.status == PNOrderStatusSuccess || rspModel.status == PNOrderStatusFailure) {
            // 停止定时器
            [self stopQueryOnlinePaymentCodeResult];

            HDPayOrderRspModel *resRspModel = [HDPayOrderRspModel modelFromPaymentCodeQueryRspModel:rspModel];
            PNOrderResultViewController *vc = [[PNOrderResultViewController alloc] init];
            vc.type = resultPage;
            vc.rspModel = resRspModel;
            vc.clickedDoneBtnHandler = ^{
                [self.navigationController popViewControllerAnimated:YES];
            };
            [self.navigationController presentViewController:[[SANavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
        }
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error){
    }];
}

#pragma mark
/** 开始轮询在线付款码结果 */
- (void)startQueryOnlinePaymentCodeResultWithContentCodeStr:(NSString *)contentCodeStr {
    // 全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    // 创建一个 timer 类型定时器
    if (!_timer) {
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    }
    // 设置定时器的各种属性（何时开始，间隔多久执行）
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC, 0);
    // 任务回调
    @HDWeakify(self);
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            @HDStrongify(self);
            [self getBillDetailWithContentCodeStr:contentCodeStr];
        });
    });
    // 开始定时器任务（定时器默认开始是暂停的，需要复位开启）
    if (_timer && !_isTimerRunning) {
        HDLog(@"开启了轮询定时器");
        dispatch_resume(_timer);
        _isTimerRunning = YES;
    }
}

/** 结束轮询在线付款码结果 */
- (void)stopQueryOnlinePaymentCodeResult {
    if (_timer && _isTimerRunning) {
        HDLog(@"关闭了轮询定时器");
        dispatch_source_cancel(_timer);
        _timer = nil;
        _isTimerRunning = NO;
    }
}

#pragma mark 开启付款码 支付密码校验
- (void)checkPassword:(BOOL)isOpenOneSetup {
    self.isOpenOneSetup = isOpenOneSetup;
    PNPaymentReqModel *model = [[PNPaymentReqModel alloc] init];
    model.businessType = PNUserBussinessTypePaymentCode;
    model.certifiedType = isOpenOneSetup ? PNUserCertifiedTypesOpen : PNUserCertifiedTypesNon;

    PayHDCheckstandViewController *vc = [PayHDCheckstandViewController checkStandWithBusinessPaymenModel:model preferedHeight:0 style:PayHDCheckstandViewControllerStyleOpenPayment
                                                                                                   title:PNLocalizedString(@"PAYPASSWORD_INPUT_WARM", @"请输入支付密码")
                                                                                                  tipStr:@""];
    vc.resultDelegate = self;
    [self presentViewController:vc animated:true completion:nil];
}

#pragma mark - 获取加密因子
- (void)getEncryptFactor:(NSString *)pwd {
    NSString *random = [PNCommonUtils getRandomKey];
    // 获取加密因子
    [self showloading];
    @HDWeakify(self);
    [self.pwdViewModel getEncryptFactorWithRandom:random finish:^(NSString *_Nonnull index, NSString *_Nonnull factor) {
        @HDStrongify(self);
        [self dismissLoading];
        NSString *securityTxt = [RSACipher encrypt:pwd publicKey:factor];
        [self getPaymentQRCodeWithIndex:index password:securityTxt];
    } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}

#pragma mark delegate
/// 开通付款码  校验 回调
- (void)checkStandViewController:(PayHDCheckstandViewController *)controller
    verifyOpenPaymentPasswordSuccess:(NSString *)payerUsrToken
                               index:(NSString *)index
                            password:(NSString *)password
                                 key:(NSString *)authKey
                                 pwd:(NSString *)pwd {
    HDLog(@"来了open： %@ - %@", payerUsrToken, authKey);
    @HDWeakify(self);
    [controller dismissViewControllerCompletion:^{
        @HDStrongify(self);
        self.businessQueryRspModel.status = PNUserBussinessStatusOpened;
        // 如果开启付款码业务 选择 开启了免密 ，则可以直接 获取付款二维码 ， 否则 需要帮忙 获取加密因子，加密之后才能获取二维码【避免二次输入支付密码】
        if (self.isOpenOneSetup) {
            self.businessQueryRspModel.payCertifiedType = PNUserCertifiedTypesOpen;
            [self getPaymentQRCodeWithIndex:@"" password:@""];
        } else {
            self.businessQueryRspModel.payCertifiedType = PNUserCertifiedTypesNon;
            [self getEncryptFactor:pwd];
        }
    }];
}

/// 获取付款码  校验 回调
- (void)checkStandViewController:(PayHDCheckstandViewController *)controller verifyGetPaymentQRCodeSuccess:(NSDictionary *)rspData index:(NSString *)index password:(NSString *)password {
    HDLog(@"来了get qrcode： %@", rspData);
    [controller dismissViewControllerCompletion:^{
        PNOpenPaymentRspModel *model = [PNOpenPaymentRspModel yy_modelWithJSON:rspData];
        self.codeView.model = model;
        self.codeView.hidden = NO;
        [self.view setNeedsUpdateConstraints];

        [self startQueryOnlinePaymentCodeResultWithContentCodeStr:model.payCode];

        [self setBrightness];
    }];
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
                    [HDMediator.sharedInstance navigaveToPayNowPasswordContactUSVC:params];
                };
                params[@"clickedForgetBlock"] = clickedForgetBlock;
                SAChangePayPwdAskingViewController *vc = [[SAChangePayPwdAskingViewController alloc] initWithRouteParameters:params];
                [SAWindowManager.visibleViewController presentViewController:[[SANavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
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

#pragma mark
- (PNPaymentCodeViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[PNPaymentCodeViewModel alloc] init];
    }
    return _viewModel;
}

- (HDPasswordManagerViewModel *)pwdViewModel {
    if (!_pwdViewModel) {
        _pwdViewModel = [[HDPasswordManagerViewModel alloc] init];
    }
    return _pwdViewModel;
}

- (PNPaymentCodeView *)codeView {
    if (!_codeView) {
        _codeView = [[PNPaymentCodeView alloc] init];
        _codeView.hidden = YES;

        @HDWeakify(self);
        _codeView.scanBlock = ^{
            [HDMediator.sharedInstance navigaveToPayNowScannerVC:@{}];
            @HDStrongify(self);
            [self.navigationController removeSpecificViewControllerClass:self.class onlyOnce:NO];
        };

        _codeView.receiveCodeBlock = ^{
            [HDMediator.sharedInstance navigaveToPayNowReceiveCodeVC:@{}];
            @HDStrongify(self);
            [self.navigationController removeSpecificViewControllerClass:self.class onlyOnce:NO];
        };
    }
    return _codeView;
}

- (PNOpenPaymentCodeView *)openCodeView {
    if (!_openCodeView) {
        _openCodeView = [[PNOpenPaymentCodeView alloc] init];
        _openCodeView.hidden = YES;
        _openCodeView.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        _openCodeView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(10)];
        };
        @HDWeakify(self);
        _openCodeView.secretFlagBlock = ^(BOOL selectFlag) {
            @HDStrongify(self);
            [self checkPassword:selectFlag];
        };
    }
    return _openCodeView;
}

- (HDUIButton *)navBtn {
    if (!_navBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsButtonWhenHighlighted = false;
        [button setTitle:PNLocalizedString(@"Security", @"安全") forState:UIControlStateNormal];
        [button setTitleColor:HDAppTheme.PayNowColor.cFFFFFF forState:UIControlStateNormal];
        button.titleLabel.font = [HDAppTheme.font forSize:13];
        [button sizeToFit];
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self handlerChoose];
        }];

        _navBtn = button;
    }
    return _navBtn;
}

- (HDUserBussinessQueryRsp *)businessQueryRspModel {
    if (!_businessQueryRspModel) {
        _businessQueryRspModel = [[HDUserBussinessQueryRsp alloc] init];
    }
    return _businessQueryRspModel;
}

@end
