//
//  HDCheckStandBaseViewController.m
//  SuperApp
//
//  Created by VanJay on 2019/5/15.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDCheckStandBaseViewController.h"
#import "HDCheckStandInputPwdViewController.h"
#import "HDCheckStandViewController.h"
#import "HDWeakTimer.h"


@interface HDCheckStandBaseViewController () <UIGestureRecognizerDelegate>
@property (nonatomic, weak) id<UIGestureRecognizerDelegate> gestureDelegate; ///< 手势代理
@property (nonatomic, strong) UIView *containerView;                         ///< 容器
@property (nonatomic, strong) HDCheckstandDTO *checkStandDTO;                ///< 收银台 DTO
@property (nonatomic, strong) HDCheckStandCustomNavBarView *navBarView;      ///< 导航栏
@property (nonatomic, weak) HDCheckStandViewController *checkStand;          ///< 收银台
@end


@implementation HDCheckStandBaseViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    // 绑定收银台
    UINavigationController *navc = self.navigationController;
    if ([navc isKindOfClass:HDCheckStandViewController.class]) {
        HDCheckStandViewController *checkStandVc = (HDCheckStandViewController *)navc;
        self.checkStand = checkStandVc;

        // 让收银台引用输入框
        if ([self isKindOfClass:HDCheckStandInputPwdViewController.class] && [self respondsToSelector:@selector(textField)]) {
            checkStandVc.textField = [self performSelector:@selector(textField)];
        }
        //通过代理拿到收银台导航控制器
        if (self.checkStand.resultDelegate && [self.checkStand.resultDelegate respondsToSelector:@selector(getCheckStandViewController:)]) {
            [self.checkStand.resultDelegate getCheckStandViewController:self.checkStand];
        }
    }

    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.navBarView];
    [self.view addSubview:self.containerView];

    @HDWeakify(self);
    self.navBarView.clickedLeftBtnHandler = ^{
        @HDStrongify(self);
        [self clickOnBackBarButtonItem];
    };

    /*
    if (self.style == HDCheckStandViewControllerStyleDefault) {
        [self startOverTimePaymentTimer];
    }
    */
}

- (HDCheckStandPaymentOverTimeEndActionType)preferedPaymentOverTimeEndActionType {
    return HDCheckStandPaymentOverTimeEndActionTypeConfirm;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (self.navigationController.viewControllers.count > 1) {
        [self.navBarView setLeftBtnImage:@"back-left-gray" title:nil];

        // 添加手势
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.gestureDelegate = self.navigationController.interactivePopGestureRecognizer.delegate;
            self.navigationController.interactivePopGestureRecognizer.delegate = self;
        }
    } else {
        [self.navBarView setLeftBtnImage:@"ic-checkstand-close" title:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    //    [self stopOverTimePaymentTimer];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    if (self.checkStand && [self.checkStand isKindOfClass:HDCheckStandViewController.class]) {
        self.navBarView.frame = CGRectMake(0, kStatusBarH, CGRectGetWidth(self.checkStand.view.frame), 44);
        self.containerView.frame
            = CGRectMake(0, CGRectGetMaxY(self.navBarView.frame), CGRectGetWidth(self.checkStand.view.frame), CGRectGetHeight(self.checkStand.view.frame) - CGRectGetMaxY(self.navBarView.frame));
    } else {
        self.navBarView.frame = CGRectMake(0, UIApplication.sharedApplication.statusBarFrame.size.height, kScreenWidth, 44);
        self.containerView.frame = CGRectMake(0,
                                              CGRectGetMaxY(self.navBarView.frame),
                                              CGRectGetWidth(self.navigationController.view.frame),
                                              CGRectGetHeight(self.navigationController.view.frame) - CGRectGetMaxY(self.navBarView.frame));
    }
}

- (void)dealloc {
    //    [self stopOverTimePaymentTimer];

    HDLog(@"收银台拥有控制器 %@ 销毁", NSStringFromClass(self.class));
}

#pragma mark - HDViewControllerNavigationBarStyle
- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleHidden;
}

#pragma mark - public methods
/** 关闭订单 */
- (void)closePaymentFinshed:(void (^)(void))finished {
    !finished ?: finished();
}

- (void)hideContainerViewAndDismissCheckStand {
    [self hideContainerViewAndDismissCheckStandFinshed:nil];
}

- (void)hideContainerViewAndDismissCheckStandFinshed:(void (^__nullable)(void))finishedHandler {
    @HDWeakify(self);
    [self closePaymentFinshed:^{
        @HDStrongify(self);
        [self.view endEditing:true];
        [UIView animateWithDuration:kHDCSPresentDefaultTransitionDuration animations:^{
            self.checkStand.view.transform = CGAffineTransformMakeTranslation(0, self.checkStand.view.bounds.size.height);
        } completion:^(BOOL finished) {
            !finishedHandler ?: finishedHandler();
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }];
    }];
}

- (void)hideContainerViewAndDismissCheckStandWithoutCallingClosePaymentFinshed:(void (^__nullable)(void))finishedHandler {
    [self.view endEditing:true];
    [UIView animateWithDuration:kHDCSPresentDefaultTransitionDuration animations:^{
        self.checkStand.view.transform = CGAffineTransformMakeTranslation(0, self.checkStand.view.bounds.size.height);
    } completion:^(BOOL finished) {
        [self.navigationController dismissViewControllerAnimated:false completion:^{
            !finishedHandler ?: finishedHandler();
        }];
    }];
}

#pragma mark - private methods
/** 启动超时支付定时器 */
//- (void)startOverTimePaymentTimer {
//    if (self.timer) {
//        [self stopOverTimePaymentTimer];
//    }
//    @HDWeakify(self);
//    self.timer = [HDWeakTimer scheduledTimerWithTimeInterval:5 * 60
//                                                       block:^(id userInfo) {
//                                                           @HDStrongify(self);
//                                                           [self paymentOverTime];
//                                                       }
//                                                    userInfo:nil
//                                                     repeats:NO];
//
//    HDLog(@"订单支付超时检查定时器已启动，界面：%zd", [self preferedPaymentOverTimeEndActionType]);
//}
//
//- (void)stopOverTimePaymentTimer {
//    if (self.timer) {
//        [self.timer invalidate];
//        self.timer = nil;
//
//        HDLog(@"订单支付超时检查定时器已销毁，界面：%zd", [self preferedPaymentOverTimeEndActionType]);
//    }
//}
//
//- (void)paymentOverTime {
//    HDLog(@"5分钟内未操作, 关闭定时器，通知代理，关闭收银台");
//    [self stopOverTimePaymentTimer];
//
//    if (self.checkStand.resultDelegate && [self.checkStand.resultDelegate respondsToSelector:@selector(checkStandViewControllerPaymentOverTime:endActionType:)]) {
//
//        HDCheckStandPaymentOverTimeEndActionType type = [self preferedPaymentOverTimeEndActionType];
//
//        HDLog(@"收银台最终操作界面：%zd", type);
//        [self.checkStand.resultDelegate checkStandViewControllerPaymentOverTime:self.checkStand endActionType:type];
//    }
//
//    [NAT showAlertWithMessage:SALocalizedString(@"checkStand_payment_overtime", @"订单支付超时")
//                  buttonTitle:SALocalizedString(@"confirm", @"确定")
//                      handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
//                          [alertView dismiss];
//
//                          [self hideContainerViewAndDismissCheckStand];
//                      }];
//}

#pragma mark - event response
- (void)clickOnBackBarButtonItem {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - set navBarView
- (void)setTitleBtnImage:(NSString *)imageName title:(NSString *)title font:(UIFont *)font {
    [self.navBarView setTitleBtnImage:imageName title:title font:font];
}

- (void)setTitle:(NSString *)title {
    [super setTitle:title];

    [self.navBarView setTitleBtnImage:nil title:title font:nil];
}

#pragma mark - lazy load
- (HDCheckstandDTO *)checkStandDTO {
    if (!_checkStandDTO) {
        _checkStandDTO = [[HDCheckstandDTO alloc] init];
    }
    return _checkStandDTO;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}

- (HDCheckStandCustomNavBarView *)navBarView {
    if (!_navBarView) {
        _navBarView = [[HDCheckStandCustomNavBarView alloc] init];
    }
    return _navBarView;
}
@end
