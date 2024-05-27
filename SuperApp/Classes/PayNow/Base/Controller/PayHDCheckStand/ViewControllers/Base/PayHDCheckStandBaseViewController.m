//
//  PayHDCheckstandBaseViewController.m
//  customer
//
//  Created by VanJay on 2019/5/15.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "PayHDCheckStandBaseViewController.h"
#import "PNRspModel.h"
#import "PayHDCheckStandViewController.h"
#import "PayHDCheckstandInputPwdViewController.h"
#import "WJWeakTimer.h"


@interface PayHDCheckstandBaseViewController () <UIGestureRecognizerDelegate>
@property (nonatomic, weak) id<UIGestureRecognizerDelegate> gestureDelegate; ///< 手势代理
@property (nonatomic, strong) NSTimer *timer;                                ///< 记录5分钟未操作关闭订单
@end


@implementation PayHDCheckstandBaseViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    [self hideNavigationBarAndWrapperView];

    self.view.backgroundColor = UIColor.clearColor;

    [self.view addSubview:self.containerView];
    self.containerView.backgroundColor = UIColor.whiteColor;

    _navBarView = [[PayHDCheckstandCustomNavBarView alloc] init];
    [self.containerView addSubview:_navBarView];

    __weak __typeof(self) weakSelf = self;
    self.navBarView.clickedLeftBtnHandler = ^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf clickOnBackBarButtonItem];
    };

    // 设置代理
    UINavigationController *navc = self.navigationController;
    if ([navc isKindOfClass:PayHDCheckstandViewController.class]) {
        PayHDCheckstandViewController *checkStandVc = (PayHDCheckstandViewController *)navc;
        self.delegate = checkStandVc;

        // 让收银台引用输入框
        if ([self isKindOfClass:PayHDCheckstandInputPwdViewController.class] && [self respondsToSelector:@selector(textField)]) {
            checkStandVc.textField = [self performSelector:@selector(textField)];
        }
    }

    if (self.style == PayHDCheckstandViewControllerStyleDefault) {
        [self startOverTimePaymentTimer];
    }
}
- (void)hideNavigationBarAndWrapperView {
    self.hd_navigationBar.hidden = true;
    //    self.view.hidden = true;

    [self.view setNeedsUpdateConstraints];
}
- (PayHDCheckstandPaymentOverTimeEndActionType)preferedaymentOverTimeEndActionType {
    return PayHDCheckstandPaymentOverTimeEndActionTypeConfirm;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (self.navigationController.viewControllers.count > 1) {
        [self.navBarView setLeftBtnImage:@"back-left-gray" title:nil];

        //        // 添加手势
        //        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        //            _gestureDelegate = self.navigationController.interactivePopGestureRecognizer.delegate;
        //            self.navigationController.interactivePopGestureRecognizer.delegate = self;
        //        }
    } else {
        [self.navBarView setLeftBtnImage:@"ic-checkstand-close" title:nil];
    }
}

- (void)updateViewConstraints {
    [super updateViewConstraints];

    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.size.mas_equalTo(self.navigationController.view.bounds.size);
    }];

    [self.navBarView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.equalTo(self.containerView);
        make.height.mas_equalTo(57);
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self stopOverTimePaymentTimer];
}

- (void)dealloc {
    [self stopOverTimePaymentTimer];

    HDLog(@"收银台拥有控制器 %@ 销毁", NSStringFromClass(self.class));
}

#pragma mark - public methods
/** 关闭订单 */
- (void)closePaymentFinshed:(void (^)(void))finished {
    [self showloading];
    __weak __typeof(self) weakSelf = self;

    // coolcash 扫码  关闭不做订单关闭操作
    if (self.subTradeType == PNTradeSubTradeTypeCoolCashCashOut || self.subTradeType == PNTradeSubTradeTypeMerchantToSelfWallet || self.subTradeType == PNTradeSubTradeTypeMerchantToSelfBank) {
        !finished ?: finished();
    } else {
        // 发起关闭订单请求
        [self.checkStandViewModel pn_tradeClosePaymentWithTradeNo:self.tradeNo success:^(NSString *_Nonnull tradeNo) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf dismissLoading];
            HDLog(@"订单：%@ 关闭成功", tradeNo);
            !finished ?: finished();
        } failure:^(PNRspModel *_Nullable rspModel, NSInteger errorType, NSError *_Nullable error) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf dismissLoading];
            HDLog(@"订单 :%@ 关闭失败，%@", strongSelf.tradeNo, rspModel.msg);
            !finished ?: finished();
        }];
    }
}

- (void)hideContainerViewAndDismissCheckStand {
    [self hideContainerViewAndDismissCheckStandFinshed:nil];
}

- (void)hideContainerViewAndDismissCheckStandFinshed:(void (^__nullable)(void))finishedHandler {
    __weak __typeof(self) weakSelf = self;
    [self closePaymentFinshed:^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.view endEditing:true];
        [UIView animateWithDuration:kPayHDPresentDefaultTransitionDuration animations:^{
            strongSelf.containerView.transform = CGAffineTransformMakeTranslation(0, strongSelf.containerView.bounds.size.height);
        } completion:^(BOOL finished) {
            !finishedHandler ?: finishedHandler();
            [strongSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
        }];
    }];
}

- (void)hideContainerViewAndDismissCheckStandWithoutCallingClosePaymentFinshed:(void (^__nullable)(void))finishedHandler {
    [self.view endEditing:true];
    [UIView animateWithDuration:kPayHDPresentDefaultTransitionDuration animations:^{
        self.containerView.transform = CGAffineTransformMakeTranslation(0, self.containerView.bounds.size.height);
    } completion:^(BOOL finished) {
        [self.navigationController dismissViewControllerAnimated:false completion:nil];
        !finishedHandler ?: finishedHandler();
    }];
}

#pragma mark - private methods
/** 启动超时支付定时器 */
- (void)startOverTimePaymentTimer {
    if (self.timer) {
        [self stopOverTimePaymentTimer];
    }
    __weak __typeof(self) weakSelf = self;
    self.timer = [WJWeakTimer scheduledTimerWithTimeInterval:5 * 60 block:^(id userInfo) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf paymentOverTime];
    } userInfo:nil repeats:NO];

    HDLog(@"订单支付超时检查定时器已启动，界面：%zd", [self preferedaymentOverTimeEndActionType]);
}

- (void)stopOverTimePaymentTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;

        HDLog(@"订单支付超时检查定时器已销毁，界面：%zd", [self preferedaymentOverTimeEndActionType]);
    }
}

- (void)paymentOverTime {
    HDLog(@"5分钟内未操作, 关闭定时器，通知代理，关闭收银台");
    [self stopOverTimePaymentTimer];

    if (self.delegate && [self.delegate respondsToSelector:@selector(checkStandViewBaseControllerPaymentOverTime:endActionType:)]) {
        PayHDCheckstandPaymentOverTimeEndActionType type = [self preferedaymentOverTimeEndActionType];

        HDLog(@"收银台最终操作界面：%zd", type);

        [self.delegate checkStandViewBaseControllerPaymentOverTime:self endActionType:type];
    }

    [NAT showAlertWithMessage:PNLocalizedString(@"checkStand_payment_overtime", @"订单支付超时") buttonTitle:PNLocalizedString(@"BUTTON_TITLE_SURE", @"确定")
                      handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                          [alertView dismiss];

                          [self hideContainerViewAndDismissCheckStand];
                      }];
}

#pragma mark - lazy load
- (PayHDCheckstandViewModel *)checkStandViewModel {
    if (!_checkStandViewModel) {
        _checkStandViewModel = [[PayHDCheckstandViewModel alloc] init];
    }
    return _checkStandViewModel;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}

#pragma mark - event response
- (void)clickOnBackBarButtonItem {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - getters and setters

- (void)setTitleBtnImage:(NSString *__nullable)imageName title:(NSString *)title font:(UIFont *__nullable)font {
    [self.navBarView setTitleBtnImage:imageName title:title font:font];
}

- (void)setTitle:(NSString *)title {
    [super setTitle:title];

    [self.navBarView setTitleBtnImage:nil title:title font:nil];
}

- (NSString *)tradeNo {
    return WJIsStringNotEmpty(_tradeNo) ? _tradeNo : @"";
}
@end
