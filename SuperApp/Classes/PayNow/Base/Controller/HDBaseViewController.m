//
//  HDBaseViewController.m
//  customer
//
//  Created by 陈剑 on 2018/7/4.
//  Copyright © 2018年 chaos network technology. All rights reserved.
//

#import "HDBaseViewController.h"
#import "HDAccountListViewController.h"
#import "HDBaseTabBarController.h"
#import "HDDispatchMainQueueSafe.h"
#import "HDForgetLoginPwdInputAccountViewController.h"
#import "HDLoginNavigationControllerViewController.h"
#import "HDLoginPwdViewController.h"
#import "HDNewVersionAlertView.h"
#import "HDShadowBlankView.h"
#import "HDWelcomePageViewController.h"
#import "NSObject+Extension.h"
#import "UIButton+EnlargeEdge.h"
#import "UITabBarController+Extension.h"
#import "UIViewController+WJKeyBoard.h"


@interface HDBaseViewController ()
@property (nonatomic, strong) HDTips *hud;                        ///< 提示 HUD
@property (nonatomic, strong) HDUIButton *backBarButton;          ///< 引用用于动态修改
@property (nonatomic, strong) CAShapeLayer *navBarShaodowLayer;   ///< 标题栏阴影图层
@property (nonatomic, assign) BOOL hasManuallySetStatusBarStyle;  ///< 标志位，是否手动设置过状态栏样式
@property (nonatomic, assign) BOOL hasSetNavigationBarBackButton; ///< 标志位，是否已经设置过返回按钮
@end


@implementation HDBaseViewController
- (instancetype)init {
    self = [super init];
    if (self) {
        self.needLogin = YES;
    }
    return self;
}

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super init];
    if (self) {
        self.needLogin = YES;
        self.parameters = parameters;
    }
    return self;
}

- (void)viewDidLoad {
    [self setupNavigationBarStyle];
    [super viewDidLoad];

    if (!self.disableHandleKeyBoardEvent && ![self isKindOfClass:NSClassFromString(@"HDBaseHtmlVC")]) {
        [self wj_addKeyBoardHandle];
        if (self.viewWrapper.isHidden) {
            self.wj_needScrollView = self.view;
        } else {
            self.wj_needScrollView = self.viewWrapper;
        }
    }

    self.modalPresentationStyle = UIModalPresentationFullScreen;
    self.viewWrapper.backgroundColor = [HDAppTheme HDColorG5];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reflushUI) name:kInternationReflushUINotication object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillChangeStatusBarFrame:) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
}

- (void)setupNavigationBarStyle {
    HDNavigationStyle curVCNavStyle = [self navigationBarStyleForViewController:self];

    if (HDNavigationStyleGradual == curVCNavStyle) {
        [self setNavBarBackgroundColor:[HDAppTheme HDColorC1]];
        [self setNavTintColor:UIColor.whiteColor];
    } else if (HDNavigationStyleWhite == curVCNavStyle) {
        [self setNavBarBackgroundColor:UIColor.whiteColor];
        [self setNavTintColor:[HDAppTheme HDColorG1]];
    } else if (HDNavigationStyleClear == curVCNavStyle) {
        [self setNavBarBackgroundColor:UIColor.clearColor];
        [self setNavTintColor:UIColor.whiteColor];
    } else if (HDNavigationStyleHidden == curVCNavStyle) {
        self.hideNavigationBar = true;
    }
    [self setNavBottomLineHidden:[self shouldHideNavigationBarBottomLine]];

    [self setNavigationBarBottomShadowHidden:[self shouldHideNavigationBarBottomShadow]];
}

- (void)udpateStatusBarStyle {
    HDNavigationStyle curVCNavStyle = [self navigationBarStyleForViewController:self];

    if (self.hasManuallySetStatusBarStyle) {
        [UIApplication sharedApplication].statusBarStyle = [self fixedStatusBarStyle:self.hd_preferredStatusBarStyle];
    } else {
        UIStatusBarStyle darkStyle = UIStatusBarStyleDefault;
        if (@available(iOS 13.0, *)) {
            darkStyle = UIStatusBarStyleDarkContent;
        }
        UIStatusBarStyle style = darkStyle;
        if (HDNavigationStyleGradual == curVCNavStyle) {
            style = UIStatusBarStyleLightContent;
        } else if (HDNavigationStyleWhite == curVCNavStyle) {
            style = darkStyle;
        } else if (HDNavigationStyleClear == curVCNavStyle) {
            style = UIStatusBarStyleLightContent;
        } else if (HDNavigationStyleHidden == curVCNavStyle) {
            style = darkStyle;
        }
        [UIApplication sharedApplication].statusBarStyle = style;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kInternationReflushUINotication object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillChangeStatusBarFrameNotification object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self];

    HDLog(@"控制器 -- %@ -- dealloc", NSStringFromClass([self preferredViewControllerClass]));
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (!self.hasSetNavigationBarBackButton && !self.hideNavBackButton && self.navigationController.viewControllers.count > 1) {
        // 不允许返回的页面不需要添加
        [self setNavCustomLeftView:self.backBarButton];
        self.hasSetNavigationBarBackButton = true;
    }

    // 滑动返回正在进行就不着急改状态栏样式，放在 viewDidAppear 中改
    UIGestureRecognizerState state = self.navigationController.interactivePopGestureRecognizer.state;
    if (state != UIGestureRecognizerStateBegan && state != UIGestureRecognizerStateChanged) {
        [self udpateStatusBarStyle];
    }

    self.hidesBottomBarWhenPushed = self.navigationController.viewControllers.count > 1;

    [TalkingData trackPageBegin:NSStringFromClass(self.class)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self udpateStatusBarStyle];

    // 特殊处理，告诉 UITabbarViewController viewDidAppear
    if (self.navigationController && self.navigationController.viewControllers.count > 0 && self.navigationController.viewControllers.firstObject == self) {
        [self.tabBarController performDidAppearSelectIndexHandler];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [TalkingData trackPageEnd:NSStringFromClass(self.class)];
}

- (void)setNavigationBarBottomShadowHidden:(BOOL)hidden {
    if (self.navBarShaodowLayer) {
        [self.navBarShaodowLayer removeFromSuperlayer];
        self.navBarShaodowLayer = nil;
    }

    if (!hidden) {
        self.navBarShaodowLayer = [self.navigationBar setRoundedCorners:UIRectCornerAllCorners radius:0 shadowRadius:3 shadowOpacity:1
                                                            shadowColor:[UIColor colorWithRed:228 / 255.0 green:229 / 255.0 blue:234 / 255.0 alpha:0.5].CGColor
                                                              fillColor:UIColor.whiteColor.CGColor
                                                           shadowOffset:CGSizeMake(0, 3)];
    }
}

- (void)reflushUI {
}

#pragma mark - HUD
- (void)showloading {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.hud) {
            [self.hud hideAnimated:true];
            [self.hud removeFromSuperview];
            self.hud = nil;
        }
        self.hud = [HDTips showLoadingInView:self.hudSuperView];
    });
}

- (void)showloadingToSelf {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.hud) {
            [self.hud hideAnimated:true];
            [self.hud removeFromSuperview];
            self.hud = nil;
        }
        self.hud = [HDTips showLoadingInView:self.hudSuperView];
    });
}

- (UIView *)hudSuperView {
    UIView *view = self.viewWrapper;
    // 如果子控件不存在，则假设该界面还是使用 self.view 做容器
    if (view.subviews.count <= 0) {
        view = self.view;
    }
    return view;
}

- (void)dismissLoading {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.hud) {
            [self.hud hideAnimated:YES afterDelay:0.3];
        }
    });
}

- (void)dismissLoadingImmediately {
    dispatch_main_async_safe(^{
        if (self.hud) {
            [self.hud hideAnimated:YES];
        }
    });
}

#pragma mark - Data
- (void)networkRequestFail:(NSError *)error {
    [self dismissLoadingImmediately];

    [NAT showToastWithTitle:[NSString stringWithFormat:@"%zd", error.code] content:HDLocalizedString(@"ERROR_MSG_NETWORK_FAIL", @"网络连接失败", nil) type:FFToastTypeError];
}

- (void)viewModel:(HDBaseViewModel *)viewModel transactionFailure:(NSString *)reason code:(NSString *)code {
    [self dismissLoading];

    if ([code isEqualToString:@"G1016"]) { // 异设备

        [NAT showAlertWithMessage:reason confirmButtonTitle:HDLocalizedString(@"BUTTON_TITLE_LOGIN_RIGHT_NOW", @"立即登录", @"Buttons")
            confirmButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                [[VipayUser shareInstance] logout];
                [alertView dismissCompletion:^{
                    //[HDWindowManager switchRootViewControllerToLoginNavControllerFinish:nil];
                }];
            }
            cancelButtonTitle:HDLocalizedString(@"BUTTON_TITLE_RESET_LOGIN_PWD", @"重置密码", @"Buttons") cancelButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                [[VipayUser shareInstance] logout];

                [alertView dismissCompletion:^{
                    //[HDWindowManager switchRootViewControllerToLoginNavControllerWithViewController:[HDForgetLoginPwdInputAccountViewController new] finish:nil];
                }];
            }];

    } else if ([code isEqualToString:@"G1017"] || [code isEqualToString:@"G1086"] || [code isEqualToString:@"G1083"]) { // session 失效

        [NAT showAlertWithMessage:reason buttonTitle:HDLocalizedString(@"BUTTON_TITLE_LOGIN_RIGHT_NOW", @"立即登录", @"Buttons") handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
            [[VipayUser shareInstance] logout];
            [alertView dismissCompletion:^{
                //[HDWindowManager switchRootViewControllerToLoginNavControllerFinish:nil];
            }];
        }];

    } else if ([code isEqualToString:@"C0011"]) { //余额不足
        [NAT showAlertWithMessage:reason buttonTitle:HDLocalizedString(@"BUTTON_TITLE_SURE", @"确定", @"Buttons") handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
            [alertView dismiss];
        }];
        //        [NAT showAlertWithMessage:reason
        //            confirmButtonTitle:HDLocalizedString(@"BUTTON_TITLE_GO_TO_RECHARGE", @"去充值", @"Buttons")
        //            confirmButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
        //                [alertView dismissCompletion:^{
        //                    //[HDWindowManager openUrl:[HDSchemePathUtil urlForScheme:kRouteSchemaViPay routePath:kRoutePathBranchMap] withParameters:nil];
        //                    [HDTalkingData trackEvent:@"入金地图_进入" label:@"余额不足"];
        //                }];
        //            }
        //            cancelButtonTitle:HDLocalizedString(@"BUTTON_TITLE_CANCEL", @"取消", @"Buttons")
        //            cancelButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
        //                [alertView dismiss];
        //            }];

    } else if ([code isEqualToString:@"G1010"] || [code isEqualToString:@"G1011"] || [code isEqualToString:@"G1012"] || [code isEqualToString:@"V1056"] || [code isEqualToString:@"G1105"] ||
               [code isEqualToString:@"G1106"]) { //黑名单 冻结退出

        __weak __typeof(self) weakSelf = self;
        [NAT showAlertWithMessage:reason buttonTitle:HDLocalizedString(@"BUTTON_TITLE_SURE", @"确定", @"Buttons") handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
            [weakSelf.view endEditing:true];

            [[VipayUser shareInstance] logout];
            [alertView dismissCompletion:^{
                //[HDWindowManager switchRootViewControllerToLoginNavControllerFinish:nil];
            }];
        }];

    } else if ([code isEqualToString:@"70001"]) {
        [NAT showAlertWithMessage:HDLocalizedString(@"ERROR_MSG_RPC", @"服务器开小差了", nil) buttonTitle:HDLocalizedString(@"BUTTON_TITLE_SURE", @"确定", @"Buttons")
                          handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                              [alertView dismiss];
                          }];
    } else if ([code isEqualToString:@"G1098"]) {
        HDNewVersionAlertView *contentView = [[HDNewVersionAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 100, 100)];
        contentView.title.text = HDLocalizedString(@"new_version_detected", @"发现新版本", nil);
        contentView.content.text = reason;
        [contentView setNeedsLayout];
        [contentView layoutIfNeeded];
        CGFloat viewHeight = contentView.contentSize.height + 50;

        contentView.frame = CGRectMake(0, 0, kScreenWidth - 100, viewHeight);
        [NAT showAlertWithTitle:nil contentView:contentView buttonTitle:HDLocalizedString(@"BUTTON_TITLE_UPDATE", @"去更新", @"Buttons") handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
            [alertView dismiss];
            NSURL *url = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1562285047"];
            [[UIApplication sharedApplication] openURL:url];
            if ([VipayUser isLogin]) {
                [[VipayUser shareInstance] logout];
                //[HDWindowManager switchRootViewControllerToLoginNavControllerFinish:nil];
            }
        }];

    } else {
        [NAT showAlertWithMessage:[NSString stringWithFormat:@"%@", reason] buttonTitle:HDLocalizedString(@"BUTTON_TITLE_SURE", @"确定", @"Buttons")
                          handler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                              [alertView dismiss];
                          }];
    }
    // G1017
}

#pragma mark - UIApplicationWillChangeStatusBarFrameNotification
// 如有必要，需监听系统状态栏变更通知：UIApplicationWillChangeStatusBarFrameNotification
- (void)applicationWillChangeStatusBarFrame:(NSNotification *)notification {
    // CGRect newStatusBarFrame = [(NSValue *)[notification.userInfo objectForKey:UIApplicationStatusBarFrameUserInfoKey] CGRectValue];
    // 根据系统状态栏高判断热门栏的变动
    // BOOL isHotspotConnected = CGRectGetHeight(newStatusBarFrame) == (kStatusBarH + khotSpotStatusBarH) ? YES : NO;

    [self.view setNeedsUpdateConstraints];
}

#pragma mark - event response
- (void)clickOnBackBarButtonItem:(UIBarButtonItem *)item {
    if (self.clickedNavLeftBtnHandler) {
        self.clickedNavLeftBtnHandler();
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - private methods
- (void)checkTradePwd:(void (^)(void))finish {
    if (![VipayUser shareInstance].tradePwdExist) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNOTIFICATION_SET_TRADEPWD object:nil];
    } else {
        if (finish) {
            finish();
        }
    }
}

- (void)checkAuthentificate:(void (^)(void))finish {
    if ([VipayUser isLogin] && ![VipayUser hasAuthen]) {
        [NAT showAlertWithMessage:HDLocalizedString(@"", @"实名认证后才可使用该功能", nil) confirmButtonTitle:HDLocalizedString(@"aclede_amount_user_grade_go", @"账户升级", nil)
            confirmButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                [alertView dismiss];
                //[HDWindowManager openUrl:[HDSchemePathUtil urlForScheme:kRouteSchemaViPay routePath:kRoutePathAccountInfomation] withParameters:nil];
            }
            cancelButtonTitle:HDLocalizedString(@"BUTTON_TITLE_CANCEL", @"取消", @"Buttons") cancelButtonHandler:^(HDAlertView *alertView, HDAlertViewButton *button) {
                [alertView dismiss];
            }];
    } else {
        !finish ?: finish();
    }
}

- (BOOL)shouldGoToResultPageByCode:(NSString *)code {
    if ([GOTO_RESULT_CODE containsString:code]) {
        return YES;
    }

    return NO;
}

- (void)setBackBarButtonImageWithImageName:(NSString *)backImageName {
    [_backBarButton setImage:[[UIImage imageNamed:backImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [_backBarButton setImage:[[UIImage imageNamed:backImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateHighlighted];
}

- (void)changeBackBarButtonImageToType:(HDBackBarButtonImageToType)type {
    switch (type) {
        case HDBackBarButtonImageToTypeWhite:
            [self setBackBarButtonImageWithImageName:@"ic-return-white"];
            break;

        case HDBackBarButtonImageToTypeRed:
            [self setBackBarButtonImageWithImageName:@"ic-return-red"];
            break;

        default:
            break;
    }
}

- (UIStatusBarStyle)fixedStatusBarStyle:(UIStatusBarStyle)style {
    if (@available(iOS 13.0, *)) {
        if (style == UIStatusBarStyleDefault) {
            style = UIStatusBarStyleDarkContent;
        }
    }
    return style;
}

#pragma mark - NavigationBar Style
- (HDNavigationStyle)navigationBarStyleForViewController:(HDBaseViewController *)viewController {
    return HDNavigationStyleWhite;
}

- (BOOL)shouldHideNavigationBarBottomLine {
    return true;
}

- (BOOL)shouldHideNavigationBarBottomShadow {
    return true;
}

- (Class)preferredViewControllerClass {
    return self.class;
}

- (SANavigationController *)navController {
    return (SANavigationController *)self.navigationController;
}

- (void)setBoldWithTitle:(NSString *)title color:(UIColor *)color {
    _boldTitle = title;

    [self setTitle:title titleFont:[HDAppTheme HDFontStandard2Bold] titleColor:color image:nil];
}

#pragma mark - getters and setters
- (void)setBoldTitle:(NSString *)boldTitle {
    [self setBoldWithTitle:boldTitle color:[HDAppTheme HDColorG1]];
}

- (void)setHd_preferredStatusBarStyle:(UIStatusBarStyle)hd_preferredStatusBarStyle {
    _hd_preferredStatusBarStyle = hd_preferredStatusBarStyle;

    self.hasManuallySetStatusBarStyle = true;
    [UIApplication sharedApplication].statusBarStyle = [self fixedStatusBarStyle:hd_preferredStatusBarStyle];
}

#pragma mark - lazy load
- (UIScrollView *)scrollContainerView {
    if (!_scrollContainerView) {
        _scrollContainerView = [[UIScrollView alloc] init];
        _scrollContainerView.showsVerticalScrollIndicator = NO;
        _scrollContainerView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollContainerView;
}

- (HDUIButton *)backBarButton {
    if (!_backBarButton) {
        _backBarButton = [[HDUIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 44)];
        NSString *backImageName = nil;
        switch ([self navigationBarStyleForViewController:self]) {
            case HDNavigationStyleWhite:
                backImageName = @"ic-return-red";
                break;
            case HDNavigationStyleClear:
                backImageName = @"ic-return-white";
                break;
            case HDNavigationStyleGradual:
                backImageName = @"ic-return-white";
                break;
            default:
                backImageName = @"ic-return-red";
                break;
        }

        [self setBackBarButtonImageWithImageName:backImageName];
        [_backBarButton setEnlargeEdgeWithTop:20 left:30 bottom:20 right:30];
        [_backBarButton addTarget:self action:@selector(clickOnBackBarButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBarButton;
}
@end


@implementation HDNavBarWhiteBottomShadowViewController

- (HDNavigationStyle)navigationBarStyleForViewController:(HDBaseViewController *)viewController {
    return HDNavigationStyleWhite;
}

- (BOOL)shouldHideNavigationBarBottomLine {
    return true;
}

- (BOOL)shouldHideNavigationBarBottomShadow {
    return false;
}
@end
