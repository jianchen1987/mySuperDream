//
//  HDCheckStandViewController.m
//  SuperApp
//
//  Created by VanJay on 2019/5/15.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDCheckStandViewController.h"
//#import "HDCheckStandConfirmViewController.h"
#import "HDCheckStandInputPwdViewController.h"
#import "SAAvailablePaymentMethodViewController.h"


@interface HDCheckStandViewController () <UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) HDPresentViewControllerAnimation *transitioning;
/// 下单模型
@property (nonatomic, strong) HDTradeBuildOrderModel *buildModel;
/// 高度，不设置将使用默认高度
@property (nonatomic, assign) CGFloat preferedHeight;
/// 风格
@property (nonatomic, assign) HDCheckStandViewControllerStyle style;
/// 记录导航栏风格
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
/// 初次布局是否完成
@property (nonatomic, assign) BOOL isInitialLayoutEnded;
@end


@implementation HDCheckStandViewController

+ (instancetype)checkStandWithTradeBuildModel:(HDTradeBuildOrderModel *)buildModel preferedHeight:(CGFloat)preferedHeight {
    return [[self alloc] initWithTradeBuildModel:buildModel preferedHeight:preferedHeight];
}

- (instancetype)initWithTradeBuildModel:(HDTradeBuildOrderModel *)buildModel preferedHeight:(CGFloat)preferedHeight {
    SAAvailablePaymentMethodViewController *vc = [SAAvailablePaymentMethodViewController checkStandWithTradeBuildModel:buildModel];

    self = [HDCheckStandViewController rootVC:vc];
    if (self) {
        self.buildModel = buildModel;
        self.preferedHeight = preferedHeight;

        self.transitioning = [[HDPresentViewControllerAnimation alloc] init];
        self.transitioning.presentingStyle = HDCSPresentVCAnimationPresentingStyleFromBottom;

        [self initProperties];
    }
    return self;
}

+ (instancetype)checkStandWithPreferedHeight:(CGFloat)preferedHeight style:(HDCheckStandViewControllerStyle)style title:(NSString *)title tipStr:(NSString *)tipStr {
    return [[self alloc] initWithPreferedHeight:preferedHeight style:style title:title tipStr:tipStr];
}

- (instancetype)initWithPreferedHeight:(CGFloat)preferedHeight style:(HDCheckStandViewControllerStyle)style title:(NSString *)title tipStr:(NSString *)tipStr {
    NSAssert(style == HDCheckStandViewControllerStyleVerifyPwd, @"该构造器只允许创建验证密码类型的收银台");

    HDCheckStandInputPwdViewController *vc = [[HDCheckStandInputPwdViewController alloc] initWithNumberOfCharacters:6 title:title tipStr:tipStr];
    vc.style = style;
    self = [HDCheckStandViewController rootVC:vc];
    if (self) {
        self.preferedHeight = preferedHeight;
        self.style = style;
        self.transitioning = [[HDPresentViewControllerAnimation alloc] init];
        self.transitioning.presentingStyle = HDCSPresentVCAnimationPresentingStyleFromBottom;

        [self initProperties];
    }
    return self;
}

- (void)dealloc {
    HDLog(@"收银台 -- %@ -- dealloc", NSStringFromClass(self.class));
}

- (void)initProperties {
    @HDWeakify(self);
    self.transitioning.tappedShadowHandler = ^{
        HDLog(@"点击了阴影");
        @HDStrongify(self);
        switch (self.tappedShadowAction) {
            case HDCheckStandTappedShadowActionDismiss:
                !self.tappedShadowHandler ?: self.tappedShadowHandler();
                break;

            case HDCheckStandTappedShadowActionDismissOnlyInConfirmPage: {
                if (self.viewControllers.count <= 1) {
                    !self.tappedShadowHandler ?: self.tappedShadowHandler();
                }
            } break;

            default:
                break;
        }
    };

    self.transitioningDelegate = self;
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;

    // 记录收银台显示之前的状态栏样式
    self.statusBarStyle = UIApplication.sharedApplication.statusBarStyle;
}

- (void)loadView {
    // 隐藏导航栏
    self.navigationBar.hidden = YES;

    //补齐高度
    CGFloat fillingHeight = kiPhoneXSeriesSafeBottomHeight;
    if ([self isKindOfClass:UINavigationController.class] && self.navigationBar.isHidden) {
        fillingHeight = kiPhoneXSeriesSafeBottomHeight - kNavigationBarH - kStatusBarH;
    }

    //默认高度
    CGFloat defaultHeight = kScreenHeight - kNavigationBarH + kStatusBarH;

    if ([self isKindOfClass:UINavigationController.class]) {
        self.preferredContentSize = CGSizeMake(kScreenWidth, self.preferedHeight != 0 ? (self.preferedHeight + fillingHeight) : (defaultHeight));
    } else {
        self.preferredContentSize = CGSizeMake(kScreenWidth, self.preferedHeight != 0 ? (self.preferedHeight + fillingHeight) : (defaultHeight));
    }

    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //    [self.view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:10];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    if (self.style == HDCheckStandViewControllerStyleDefault && !self.isInitialLayoutEnded) {
        // 默认隐藏
        self.view.transform = CGAffineTransformMakeTranslation(0, self.view.height);
        self.isInitialLayoutEnded = YES;
    }
}

#pragma mark - public methods
/// 返回当前订单号
- (NSString *)currentOrderNo {
    return self.buildModel.orderNo;
}
/// 返回应付金额
- (SAMoneyModel *)payableAmount {
    return self.buildModel.payableAmount;
}
- (NSString *)businessLine {
    return self.buildModel.businessLine;
}
- (NSString *)outPayOrderNo {
    return self.buildModel.outPayOrderNo;
}
- (id)associatedObject {
    return self.buildModel.associatedObject;
}
- (NSString *)merchantNo {
    return self.buildModel.merchantNo;
}

#pragma mark - override
- (void)dismissViewControllerCompletion:(void (^__nullable)(void))completion {
    UIViewController *vc = self.viewControllers.lastObject;
    if ([vc isKindOfClass:HDCheckStandBaseViewController.class]) {
        HDCheckStandBaseViewController *baseVC = (HDCheckStandBaseViewController *)vc;
        [baseVC hideContainerViewAndDismissCheckStandWithoutCallingClosePaymentFinshed:completion];
    } else {
        [self dismissViewControllerAnimated:true completion:completion];
    }
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    @HDWeakify(self);
    [super dismissViewControllerAnimated:flag completion:^{
        @HDStrongify(self);
        // 还原状态栏
        UIApplication.sharedApplication.statusBarStyle = self.statusBarStyle;
        if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
            [self setNeedsStatusBarAppearanceUpdate];
        }
        !completion ?: completion();
    }];
}

#pragma mark - getters and setters
- (void)setPresentingStyle:(HDCSPresentVCAnimationStyle)presentingStyle {
    _presentingStyle = presentingStyle;

    self.transitioning.presentingStyle = presentingStyle;
}

- (void)setDismissStyle:(HDCSPresentVCAnimationStyle)dismissStyle {
    _dismissStyle = dismissStyle;

    self.transitioning.dismissStyle = dismissStyle;
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    return self.transitioning;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self.transitioning;
}
@end
