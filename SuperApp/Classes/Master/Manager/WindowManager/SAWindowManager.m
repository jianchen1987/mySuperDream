//
//  SAWindowManager.m
//  SuperApp
//
//  Created by VanJay on 2020/3/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAWindowManager.h"
#import "GNTabBarController.h"
#import "HDCheckStandViewController.h"
#import "SAAppDelegate.h"
#import "SAAppLaunchToDoService.h"
#import "SAAppSwitchManager.h"
#import "SACacheManager.h"
#import "SALoginByPasswordViewController.h"
#import "SALoginFrontPageViewController.h"
#import "SAMineViewController.h"
#import "SANavigationController.h"
#import "SAOrderViewController.h"
#import "SATabBarController.h"
#import "SATabBarItemConfig.h"
#import "SAUser.h"
#import "SAWalletManager.h"
#import "TNHomeViewController.h"
#import "TNSellerTabBarViewController.h"
#import "TNTabBarViewController.h"
#import "UITabBarItem+SATabBar.h"
#import "WMTabBarController.h"
#import <HDKitCore/HDLog.h>
#import <HDKitCore/HDMediator.h>
#import <HDKitCore/UIViewController+HDKitCore.h>
#import "SALoginViewController.h"
#import "SASetPhoneViewController.h"

NSString *const kSAAfterSignedInToDoEventBlockParamKey = @"kSAAfterSignedInToDoEventBlockParamKey";
NSString *const kSAShouldForbidAutoPerformBeforeSignedInActionParamKey = @"kSAShouldForbidAutoPerformBeforeSignedInActionParamKey";


@interface SAWindowManager ()
/// 是否已登录
@property (nonatomic, assign) BOOL isLogined;
@end


@implementation SAWindowManager

static BOOL kJumpDirectlyToPasswordLogin = false;

+ (BOOL)isLogined {
    return SAUser.hasSignedIn;
}

#pragma mark - public methods
+ (UIViewController *)rootViewController {
    UIViewController *vc = self.mainTabBarController;
    return vc;
}

+ (void)switchWindowToMainTabBarController {
    [self switchWindowToMainTabBarControllerCompletion:nil];
}

+ (void)switchWindowToMainTabBarControllerCompletion:(void (^)(void))completion {
    // 拿到登录界面的导航控制器 dismiss
    SANavigationController *navigationController = (SANavigationController *)self.visibleViewController.navigationController;
    if ([navigationController isKindOfClass:SANavigationController.class] && navigationController.isLoginLogicAssociated) {
        void (^afterSignedInToDoEventBlock)(void) = navigationController.toDoEventBlock;
        [navigationController dismissAnimated:true completion:^{
            !afterSignedInToDoEventBlock ?: afterSignedInToDoEventBlock();
            !completion ?: completion();
        }];
    } else {
        HDLog(@"当前界面并无登录相关界面");
        // 重新创建一个mainTabBar，方便处理一些奇葩的跳转首页需求
        SAAppDelegate *appDelegate = (SAAppDelegate *)UIApplication.sharedApplication.delegate;
        UIWindow *rootWindow = appDelegate.window;
        UIViewController *newRootTabbarVC = [self rootViewController];
        [UIView transitionWithView:rootWindow duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            [rootWindow makeKeyAndVisible];
            BOOL oldState = [UIView areAnimationsEnabled];
            [UIView setAnimationsEnabled:YES];
            [rootWindow setRootViewController:newRootTabbarVC];
            [UIView setAnimationsEnabled:oldState];
        } completion:nil];
    }
}

+ (void)switchWindowToLoginViewController {
    [self switchWindowToLoginViewControllerCompletion:nil];
}

+ (void)switchWindowToLoginByPasswordViewController {
    kJumpDirectlyToPasswordLogin = true;
    [self switchWindowToLoginViewControllerCompletion:^{
        kJumpDirectlyToPasswordLogin = false;
    }];
}

+ (void)switchWindowToLoginViewControllerCompletion:(void (^)(void))completion {
    [self switchWindowToLoginViewControllerToViewController:nil completion:completion];
}

+ (void)switchWindowToLoginViewControllerToViewController:(UIViewController *)viewController completion:(void (^)(void))completion {
    __block UIViewController *visibleViewController = self.visibleViewController;
    void (^adjustSwitchWindowToLoginViewController)(void) = ^(void) {
        SANavigationController *navigationController = (SANavigationController *)visibleViewController.navigationController;
        if ([navigationController isKindOfClass:SANavigationController.class] && !navigationController.isLoginLogicAssociated) {
            // 当前nav不是登陆控制器
            SANavigationController *navigationController = [SANavigationController rootVC:[self _getLoginPageVC]];
            navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
            navigationController.isLoginLogicAssociated = true;

            if (viewController) {
                [navigationController pushViewController:viewController animated:NO];
            }
            [visibleViewController presentViewController:navigationController
                                                animated:true completion:^{
                                                    // 执行完成回调
                                                    !completion ?: completion();
                                                }];

        } else {
            // 当前的nav是登陆控制器，直接push or pop到根（登陆控制器的根视图一般就是登录页)
            if (viewController) {
                [self navigateToViewController:viewController];
            } else {
                [navigationController popToRootViewControllerAnimated:YES];
            }
            // 执行完成回调
            !completion ?: completion();
        }
    };

    // 当前可见界面是被 present 的并且无导航控制器
    if (visibleViewController.presentingViewController && !visibleViewController.navigationController) {
        [visibleViewController dismissAnimated:false completion:^{
            // 重新获取可见界面
            visibleViewController = self.visibleViewController;
            adjustSwitchWindowToLoginViewController();
        }];

    } else {
        adjustSwitchWindowToLoginViewController();
    }
}

+ (void)switchWindowToLoginViewControllerWithLoginToDoEvent:(void (^_Nullable)(void))event {
    __block UIViewController *visibleViewController = self.visibleViewController;

    void (^adjustSwitchWindowToLoginViewController)(void) = ^(void) {
        SANavigationController *navigationController = (SANavigationController *)visibleViewController.navigationController;
        if ([navigationController isKindOfClass:SANavigationController.class] && !navigationController.isLoginLogicAssociated) {
            // 当前nav不是登陆控制器
            SANavigationController *navigationController = [SANavigationController rootVC:[self _getLoginPageVC]];
            navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
            navigationController.isLoginLogicAssociated = true;
            navigationController.toDoEventBlock = event;
            [visibleViewController presentViewController:navigationController animated:true completion:nil];

        } else {
            // 当前的nav是登陆控制器，直接 pop到根（登陆控制器的根视图一般就是登录页)
            navigationController.toDoEventBlock = event;
            [navigationController popToRootViewControllerAnimated:YES];
        }
    };

    // 当前可见界面是被 present 的并且无导航控制器
    if (visibleViewController.presentingViewController && !visibleViewController.navigationController) {
        [visibleViewController dismissAnimated:false completion:^{
            // 重新获取可见界面
            visibleViewController = self.visibleViewController;
            adjustSwitchWindowToLoginViewController();
        }];

    } else {
        adjustSwitchWindowToLoginViewController();
    }
}

+ (UIViewController *)getControllerInstanceFromTabBarSelectedIndex:(UITabBarController *)tabBarVC forVC:(Class)vcClass {
    UIViewController *targetViewController;

    if ([tabBarVC isKindOfClass:SATabBarController.class]) {
        SATabBarController *tabVC = (SATabBarController *)tabBarVC;
        SANavigationController *selectedVc = tabVC.selectedViewController;
        for (UIViewController *vc in selectedVc.viewControllers) {
            if ([vc isKindOfClass:vcClass]) {
                targetViewController = vc;
            }
        }
    }
    return targetViewController;
}

+ (void)presentViewControllerClass:(Class)class needNavCWrapper:(BOOL)needNavCWrapper {
    [self presentViewControllerClass:class parameters:nil needNavCWrapper:needNavCWrapper];
}

+ (void)presentViewControllerClass:(Class)class parameters:(NSDictionary *)parameters needNavCWrapper:(BOOL)needNavCWrapper {
    UIViewController *destVC = [self destVCInstanceFromDestClass:class parameters:parameters];
    [self presentViewController:destVC parameters:parameters needNavCWrapper:needNavCWrapper];
}

+ (void)presentViewController:(UIViewController *)viewController parameters:(NSDictionary *)parameters {
    [self presentViewController:viewController parameters:parameters needNavCWrapper:true];
}

+ (void)presentViewController:(UIViewController *)viewController parameters:(NSDictionary *)parameters needNavCWrapper:(BOOL)needNavCWrapper {
    // 根据是否需要包装导航控制器加工目标控制器
    viewController = [self wrapperViewControllerForVC:viewController needNavCWrapper:needNavCWrapper];
    // 全屏
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;

    __block UIViewController *visibleViewController = self.visibleViewController;

    // 默认，假定不是 SAViewController 子类
    BOOL needLogin = false;
    SAViewController *saVC;
    BOOL allowContinuousBePushed = true;
    if ([viewController isKindOfClass:SAViewController.class]) {
        saVC = (SAViewController *)viewController;
        needLogin = saVC.needLogin;
        allowContinuousBePushed = saVC.allowContinuousBePushed;
    }

    // 这里需要注意，如果控制器是被 present 且被 NavigationContoller 包裹的，此时拿到的就是包裹的 NavigationContoller，逻辑也能正常进行
    SANavigationController *visibleViewControllerNavigationController = (SANavigationController *)visibleViewController.navigationController;
    if ([visibleViewControllerNavigationController isKindOfClass:SANavigationController.class] && visibleViewControllerNavigationController.isLoginLogicAssociated) {
        // 已经弹起登录相关页面
        if (needLogin) {
            // 需要登录但当前已经弹起登录相关页面，更新 TODOEvent block
            visibleViewControllerNavigationController.toDoEventBlock = ^{
                HDAfterSignedInToDoEventBlock hd_afterSignedInToDoEventBlock = parameters[kSAAfterSignedInToDoEventBlockParamKey];
                if (hd_afterSignedInToDoEventBlock) {
                    hd_afterSignedInToDoEventBlock();
                } else {
                    if (![parameters[kSAShouldForbidAutoPerformBeforeSignedInActionParamKey] boolValue]) {
                        [self presentViewController:viewController parameters:parameters needNavCWrapper:needNavCWrapper];
                    }
                }
            };
        } else {
            // 不需要登录，又是 present 操作，收起登录界面
            [visibleViewControllerNavigationController dismissAnimated:false completion:nil];
            // 再执行之前的操作
            [self presentViewController:viewController parameters:parameters needNavCWrapper:needNavCWrapper];
        }
        return;
    } else if ([visibleViewControllerNavigationController isKindOfClass:HDCheckStandViewController.class]) {
        HDCheckStandViewController *checkStand = (HDCheckStandViewController *)visibleViewControllerNavigationController;
        HDTradeBuildOrderModel *buildModel = checkStand.buildModel.copy;
        id resultDelegate = checkStand.resultDelegate;

        [checkStand dismissViewControllerCompletion:^{
            HDLog(@"收银台关闭");
            // 再执行之前的操作
            void (^callback)(BOOL, BOOL) = ^(BOOL need, BOOL isSuccess) {
                // 弹起收银台
                HDCheckStandViewController *checkStandVC = [[HDCheckStandViewController alloc] initWithTradeBuildModel:buildModel preferedHeight:0];
                checkStandVC.resultDelegate = resultDelegate;
                [self presentViewController:viewController parameters:nil];
            };

            if ([viewController isKindOfClass:UINavigationController.class]) {
                SAViewController *settingPwdVC = ((UINavigationController *)viewController).viewControllers.lastObject;
                NSMutableDictionary *parameters = settingPwdVC.parameters.mutableCopy;
                // 回调重新赋值
                parameters[@"completion"] = callback;
                settingPwdVC.parameters = parameters;
            }

            [self presentViewController:viewController parameters:parameters needNavCWrapper:needNavCWrapper];
        }];
        return;
    }

    void (^presentViewController)(void) = ^(void) {
        UINavigationController *navController = visibleViewController.navigationController;
        // present
        [self presentVC:navController forDestVC:viewController];
    };

    void (^adjustPresentViewControllerBlock)(void) = ^(void) {
        if (needLogin) { // 需要登录
            if (self.isLogined) {
                // 需要登录，已登录
                presentViewController();
            } else {
                // 需要登录，未登录
                SANavigationController *navigationController = [SANavigationController rootVC:[self _getLoginPageVC]];
                navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
                [visibleViewController presentViewController:navigationController animated:true completion:nil];
                navigationController.isLoginLogicAssociated = true;

                // 登录完成之后继续之前的操作
                navigationController.toDoEventBlock = ^{
                    HDAfterSignedInToDoEventBlock hd_afterSignedInToDoEventBlock = parameters[kSAAfterSignedInToDoEventBlockParamKey];
                    if (hd_afterSignedInToDoEventBlock) {
                        hd_afterSignedInToDoEventBlock();
                    } else {
                        if (![parameters[kSAShouldForbidAutoPerformBeforeSignedInActionParamKey] boolValue]) {
                            [self presentViewController:viewController parameters:parameters needNavCWrapper:needNavCWrapper];
                        }
                    }
                };
            }
        } else {
            // 不需要登录，present
            presentViewController();
        }
    };

    // 当前可见界面是被 present 的并且无导航控制器
    if (visibleViewController.presentingViewController && !visibleViewController.navigationController) {
        [visibleViewController dismissAnimated:false completion:^{
            // 重新获取可见界面
            visibleViewController = self.visibleViewController;
            adjustPresentViewControllerBlock();
        }];

    } else {
        adjustPresentViewControllerBlock();
    }
}

+ (void)navigateToViewController:(UIViewController *)viewController {
    [self navigateToViewController:viewController parameters:nil needUpdateParams:NO addBusinessLineHomePage:SAClientTypeMaster removeSpecClass:nil];
}

+ (void)navigateToViewController:(UIViewController *)viewController removeSpecClass:(NSString *_Nullable)className {
    [self navigateToViewController:viewController parameters:nil needUpdateParams:NO addBusinessLineHomePage:SAClientTypeMaster removeSpecClass:className];
}

+ (void)navigateToViewControllerClass:(Class)class {
    [self navigateToViewControllerClass:class parameters:nil];
}

+ (void)navigateToViewControllerClass:(Class)class parameters:(NSDictionary *)parameters {
    UIViewController *destVC = [self destVCInstanceFromDestClass:class parameters:parameters];
    [self navigateToViewController:destVC parameters:parameters needUpdateParams:NO addBusinessLineHomePage:SAClientTypeMaster removeSpecClass:nil];
}

+ (void)navigateToViewController:(UIViewController *)viewController parameters:(NSDictionary *)parameters {
    [self navigateToViewController:viewController parameters:parameters needUpdateParams:YES addBusinessLineHomePage:SAClientTypeMaster removeSpecClass:nil];
}
+ (void)navigateToViewController:(UIViewController *)viewController parameters:(NSDictionary *)parameters addBusinessHomePage:(SAClientType)businessLine {
    [self navigateToViewController:viewController parameters:parameters needUpdateParams:YES addBusinessLineHomePage:businessLine removeSpecClass:nil];
}

+ (void)navigateToViewController:(UIViewController *)viewController
                      parameters:(NSDictionary *)parameters
                needUpdateParams:(BOOL)needUpdateParams
         addBusinessLineHomePage:(SAClientType)businessLine
                 removeSpecClass:(NSString *_Nullable)specClassName {
    __block UIViewController *visibleViewController = self.visibleViewController;

    // 默认，假定不是 SAViewController 子类
    BOOL needLogin = false;
    BOOL needCheckPayPwd = false;
    SAViewController *saVC;
    BOOL allowContinuousBePushed = true;
    if ([viewController isKindOfClass:SAViewController.class]) {
        saVC = (SAViewController *)viewController;
        needLogin = saVC.needLogin;
        needCheckPayPwd = saVC.needCheckPayPwd;
        allowContinuousBePushed = saVC.allowContinuousBePushed;
    }
    // 针对业务的特殊诉求，所有业务线的二级页面，在pop的时候需要先回业务线首页
    void (^pushViewControllerWithBusinessLine)(UINavigationController *, UIViewController *, SAClientType)
        = ^(UINavigationController *visiableVCNav, UIViewController *targetVC, SAClientType businessLine) {
              NSMutableArray<UIViewController *> *curVCs = [visiableVCNav.viewControllers mutableCopy];

              //            if ([businessLine isEqualToString:SAClientTypeYumNow]) {
              //                NSArray *filterArr = [curVCs hd_filterWithBlock:^BOOL(UIViewController *_Nonnull item) {
              //                    return [item isKindOfClass:WMTabBarController.class];
              //                }];
              //
              //                BOOL inHomePageNow = visiableVCNav.tabBarController && [visiableVCNav.tabBarController isKindOfClass:WMTabBarController.class];
              //
              //                if (HDIsArrayEmpty(filterArr) && !inHomePageNow) {
              //                    WMTabBarController *wmTabBarVC = WMTabBarController.new;
              //                    wmTabBarVC.hidesBottomBarWhenPushed = YES;
              //                    [curVCs addObject:wmTabBarVC];
              //                }
              //            } else if ([businessLine isEqualToString:SAClientTypeTinhNow]) {
              //                NSArray *filterArr = [curVCs hd_filterWithBlock:^BOOL(UIViewController *_Nonnull item) {
              //                    return [item isKindOfClass:TNTabBarViewController.class] || [item isKindOfClass:TNSellerTabBarViewController.class];
              //                }];
              //
              //                BOOL inHomePageNow = visiableVCNav.tabBarController &&
              //                                     ([visiableVCNav.tabBarController isKindOfClass:TNTabBarViewController.class] || [visiableVCNav.tabBarController
              //                                     isKindOfClass:TNSellerTabBarViewController.class]);
              //
              //                if (HDIsArrayEmpty(filterArr) && !inHomePageNow) {
              //                    TNTabBarViewController *tnTabBarVC = TNTabBarViewController.new;
              //                    tnTabBarVC.hidesBottomBarWhenPushed = YES;
              //                    [curVCs addObject:tnTabBarVC];
              //                }
              //            } else if ([businessLine isEqualToString:SAClientTypeGroupBuy]) {
              //                NSArray *filterArr = [curVCs hd_filterWithBlock:^BOOL(UIViewController *_Nonnull item) {
              //                    return [item isKindOfClass:GNTabBarController.class];
              //                }];
              //
              //                BOOL inHomePageNow = visiableVCNav.tabBarController && [visiableVCNav.tabBarController isKindOfClass:GNTabBarController.class];
              //
              //                if (HDIsArrayEmpty(filterArr) && !inHomePageNow) {
              //                    GNTabBarController *tnTabBarVC = GNTabBarController.new;
              //                    tnTabBarVC.hidesBottomBarWhenPushed = YES;
              //                    [curVCs addObject:tnTabBarVC];
              //                }
              //            }

              targetVC.hidesBottomBarWhenPushed = YES;
              [curVCs addObject:targetVC];

              NSArray<UIViewController *> *finalVCs = nil;
              if (HDIsStringNotEmpty(specClassName)) {
                  finalVCs = [curVCs hd_filterWithBlock:^BOOL(UIViewController *_Nonnull item) {
                      return ![item isKindOfClass:NSClassFromString(specClassName)];
                  }];
              } else {
                  finalVCs = curVCs;
              }

              NSArray<NSString *> *specClassNames = [parameters objectForKey:@"specClassNames"];
              if (!HDIsArrayEmpty(specClassNames)) {
                  finalVCs = [finalVCs hd_filterWithBlock:^BOOL(UIViewController *_Nonnull item) {
                      return ![specClassNames containsObject:NSStringFromClass(item.class)];
                  }];
              }

              [visiableVCNav setViewControllers:finalVCs animated:YES];
          };

    // 这里需要注意，如果控制器是被 present 且被 NavigationContoller 包裹的，此时拿到的就是包裹的 NavigationContoller，逻辑也能正常进行
    SANavigationController *visibleViewControllerNavigationController = (SANavigationController *)visibleViewController.navigationController;
    // 当前是登陆导航控制器
    if ([visibleViewControllerNavigationController isKindOfClass:SANavigationController.class] && visibleViewControllerNavigationController.isLoginLogicAssociated) {
        // 已经弹起登录相关页面
        if (needLogin) {
            // 需要登录但当前已经弹起登录相关页面，更新 TODOEvent block
            visibleViewControllerNavigationController.toDoEventBlock = ^{
                HDAfterSignedInToDoEventBlock hd_afterSignedInToDoEventBlock = parameters[kSAAfterSignedInToDoEventBlockParamKey];
                if (hd_afterSignedInToDoEventBlock) {
                    hd_afterSignedInToDoEventBlock();
                } else {
                    if (![parameters[kSAShouldForbidAutoPerformBeforeSignedInActionParamKey] boolValue]) {
                        [self navigateToViewController:viewController parameters:parameters needUpdateParams:needUpdateParams addBusinessLineHomePage:businessLine removeSpecClass:specClassName];
                    }
                }
            };
        } else {
            if (visibleViewControllerNavigationController.viewControllers.count >= 2) {
                // 判断要跳转的界面是否已在导航栈中，如果在的话，则 pop 到那个页面
                SAViewController *existedDestVC = nil;
                for (UIViewController *vc in visibleViewControllerNavigationController.viewControllers) {
                    if ([vc isKindOfClass:viewController.class]) {
                        existedDestVC = (SAViewController *)vc;
                    }
                }
                if (existedDestVC) {
                    // 存在
                    [visibleViewControllerNavigationController popToViewController:existedDestVC animated:true];
                    // 判断是否要更新参数
                    if (needUpdateParams && [existedDestVC respondsToSelector:@selector(setParameters:)]) {
                        [existedDestVC performSelector:@selector(setParameters:) withObject:parameters];
                    }
                } else {
                    // 不存在，push 进栈
                    //                    [visibleViewControllerNavigationController pushViewController:viewController animated:true];
                    pushViewControllerWithBusinessLine(visibleViewControllerNavigationController, viewController, businessLine);
                }
            } else {
                // 正在顶级页面，直接 push
                //                [visibleViewControllerNavigationController pushViewController:viewController animated:true];
                pushViewControllerWithBusinessLine(visibleViewControllerNavigationController, viewController, businessLine);
            }
        }
        return;
    }

    void (^pushViewController)(void) = ^(void) {
        UINavigationController *navController = visibleViewController.navigationController;
        // 判断是否在目标控制器界面
        UIViewController *navControllerLastVC = navController.viewControllers.lastObject;
        if ([navControllerLastVC isKindOfClass:viewController.class]) {
            if (allowContinuousBePushed) {
                //                [navController pushViewController:viewController animated:true];
                pushViewControllerWithBusinessLine(navController, viewController, businessLine);
            } else {
                // 不允许连续 push，就判断是否要更新参数
                if (needUpdateParams && [navControllerLastVC respondsToSelector:@selector(setParameters:)]) {
                    [navControllerLastVC performSelector:@selector(setParameters:) withObject:parameters];
                }
            }
        } else {
            //            [navController pushViewController:viewController animated:true];
            pushViewControllerWithBusinessLine(navController, viewController, businessLine);
        }
    };

    void (^adjustPushViewControllerBlock)(void) = ^(void) {
        if (needLogin) { // 需要登录
            if (self.isLogined) {
                // 需要登录，判断是否需要支付密码
                if (needCheckPayPwd) {
                    [SAWalletManager adjustShouldSettingPayPwdCompletion:^(BOOL needSetting, BOOL isSuccess) {
                        if (isSuccess) {
                            // 需要登录，已登录，需支付密码
                            pushViewController();
                        } else {
                            HDLog(@"需要支付密码，但支付密码失败了或无支付密码，不处理");
                        }
                    }];
                } else {
                    // 需要登录，已登录，无需支付密码
                    pushViewController();
                }
            } else {
                // 需要登录，未登录
                SANavigationController *navigationController = [SANavigationController rootVC:[self _getLoginPageVC]];
                navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
                [visibleViewController presentViewController:navigationController animated:true completion:nil];
                navigationController.isLoginLogicAssociated = true;

                // 登录完成之后继续之前的操作
                navigationController.toDoEventBlock = ^{
                    HDAfterSignedInToDoEventBlock hd_afterSignedInToDoEventBlock = parameters[kSAAfterSignedInToDoEventBlockParamKey];
                    if (hd_afterSignedInToDoEventBlock) {
                        hd_afterSignedInToDoEventBlock();
                    } else {
                        if (![parameters[kSAShouldForbidAutoPerformBeforeSignedInActionParamKey] boolValue]) {
                            [self navigateToViewController:viewController parameters:parameters needUpdateParams:needUpdateParams addBusinessLineHomePage:SAClientTypeMaster
                                           removeSpecClass:specClassName];
                        }
                    }
                };
            }
        } else {
            // 不需要登录
            pushViewController();
        }
    };

    // 当前可见界面是被 present 的并且无导航控制器，先dismiss 再把目标控制器推入栈
    if (visibleViewController.presentingViewController && !visibleViewController.navigationController) {
        [visibleViewController dismissAnimated:false completion:^{
            // 重新获取可见界面
            visibleViewController = self.visibleViewController;
            adjustPushViewControllerBlock();
        }];

    } else {
        adjustPushViewControllerBlock();
    }
}

+ (void)navigateToBusinessLineHomePageWithClass:(Class)class {
    id rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([rootVC isKindOfClass:SATabBarController.class]) {
        SATabBarController *trueRootVC = (SATabBarController *)rootVC;
        SANavigationController *selectedVC = [trueRootVC selectedViewController];
        NSInteger index = [self findClassInNav:selectedVC WithClass:class];
        if (index != -1 && (index - 1) >= 0) {
            UIViewController *taget = selectedVC.viewControllers[index - 1];
            [selectedVC popToViewController:taget animated:NO];
            [selectedVC pushViewController:[class new] animated:YES];
        } else {
            [selectedVC popToRootViewControllerAnimated:YES];
        }
    } else if ([rootVC isKindOfClass:SANavigationController.class]) {
        SANavigationController *trueRootVC = (SANavigationController *)rootVC;
        NSInteger index = [self findClassInNav:trueRootVC WithClass:class];
        if (index != -1 && (index - 1) >= 0) {
            UIViewController *taget = trueRootVC.viewControllers[index - 1];
            [trueRootVC popToViewController:taget animated:NO];
            [trueRootVC pushViewController:[class new] animated:YES];
        } else {
            [trueRootVC popToRootViewControllerAnimated:YES];
        }
    }
}

+ (NSInteger)findClassInNav:(UINavigationController *)nav WithClass:(Class)class {
    __block NSInteger index = -1;
    [nav.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([obj isKindOfClass:class]) {
            index = idx;
            *stop = YES;
        }
    }];
    return index;
}

+ (BOOL)canOpenURL:(NSString *)url {
    return [HDMediator.sharedInstance canPerformActionWithURL:[url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
}

+ (BOOL)openUrl:(NSString *)url withParameters:(NSDictionary<NSString *, id> *__nullable)parameters {
    [HDMediator.sharedInstance performActionWithURL:[url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] params:parameters];
    return [HDMediator.sharedInstance canPerformActionWithURL:url];
}

+ (UIViewController *)visibleViewController {
    UIWindow *keyWindow = self.keyWindow;
    UIViewController *rootViewController = keyWindow.rootViewController;
    return [self getVisibleViewControllerFrom:rootViewController];
}

#pragma mark - private methods
+ (UIWindow *)keyWindow {
    static __weak UIWindow *cachedKeyWindow = nil;
    UIWindow *originalKeyWindow = nil;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
    if (@available(iOS 13.0, *)) {
        NSSet<UIScene *> *connectedScenes = [UIApplication sharedApplication].connectedScenes;
        for (UIScene *scene in connectedScenes) {
            if ((scene.activationState == UISceneActivationStateForegroundActive || scene.activationState == UISceneActivationStateForegroundInactive) && [scene isKindOfClass:[UIWindowScene class]]) {
                UIWindowScene *windowScene = (UIWindowScene *)scene;
                for (UIWindow *window in windowScene.windows) {
                    if (window.isKeyWindow) {
                        originalKeyWindow = window;
                        break;
                    }
                }
            }
        }
    } else
#endif
    {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 130000
        originalKeyWindow = [UIApplication sharedApplication].keyWindow;
#endif
    }

    BOOL systemComponent = [NSStringFromClass(originalKeyWindow.class) hasPrefix:@"UITextEffects"] || [NSStringFromClass(originalKeyWindow.class) hasPrefix:@"UIRemoteKeyboard"];
    BOOL appComponent = [NSStringFromClass(originalKeyWindow.class) hasPrefix:@"HDActionAlert"];

    if (systemComponent || appComponent) {
        originalKeyWindow = [[UIApplication sharedApplication].delegate window];
    }

    if (originalKeyWindow) {
        cachedKeyWindow = originalKeyWindow;
    }
    return cachedKeyWindow;
}

+ (UIViewController *)getVisibleViewControllerFrom:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self getVisibleViewControllerFrom:[((UINavigationController *)vc) visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self getVisibleViewControllerFrom:[((UITabBarController *)vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [self getVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            return vc;
        }
    }
}

+ (SATabBarController *)mainTabBarController {
    NSArray<SATabBarItemConfig *> *configArray = [SATabBarController mainTabBarConfigArray];
    NSMutableArray<UIViewController *> *vcs = [[NSMutableArray alloc] init];
    SATabBarController *tab = [[SATabBarController alloc] init];

    NSString *mappingJson = [SAAppSwitchManager.shared switchForKey:SAAppSwitchTabBarMapping];
    NSDictionary<NSString *, NSString *> *controllerMapping = @{};
    if (HDIsStringNotEmpty(mappingJson)) {
        controllerMapping = [NSJSONSerialization JSONObjectWithData:[mappingJson dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    }

    for (SATabBarItemConfig *config in configArray) {
        NSString *controllerClassName = config.loadPageName;
        NSString *mapping = [controllerMapping objectForKey:controllerClassName];
        Class controllerClass = NSClassFromString(HDIsStringNotEmpty(mapping) ? mapping : controllerClassName);
        SAViewController *vc = [[controllerClass alloc] initWithRouteParameters:config.startupParams];
        vc.title = config.name.desc;
        SANavigationController *nav = [SANavigationController rootVC:vc];
        nav.tabBarItem.hd_config = config;
        [vcs addObject:nav];
    }

    tab.viewControllers = vcs;

    tab.selectedIndexBlock = ^(NSUInteger index) {
        //处理切换订单的tab,重置筛选条件
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameSATabBarControllerChangeSelectedIndex object:nil userInfo:@{@"index": @(index)}];
    };

    return tab;
}

+ (UIViewController *)destVCInstanceFromDestClass:(Class)class parameters:(NSDictionary *)parameters {
    // 从类初始化要单独做判断
    UIViewController *destVC;

    if ([class instancesRespondToSelector:@selector(initWithRouteParameters:)]) {
        destVC = [[class alloc] initWithRouteParameters:parameters];
    } else {
        destVC = [[class alloc] init];
    }
    return destVC;
}

+ (UIViewController *)wrapperViewControllerForVC:(UIViewController *)destVC needNavCWrapper:(BOOL)needNavCWrapper {
    if (needNavCWrapper && ![destVC isKindOfClass:UINavigationController.class]) {
        destVC = [SANavigationController rootVC:destVC];
    }
    return destVC;
}

+ (void)presentVC:(UIViewController *)presentVC forDestVC:(UIViewController *)destVC {
    if (presentVC.presentedViewController) {
        @HDWeakify(presentVC);
        [presentVC.presentedViewController dismissAnimated:YES completion:^{
            @HDStrongify(presentVC);
            [presentVC presentViewController:destVC animated:YES completion:nil];
        }];
    } else {
        [presentVC presentViewController:destVC animated:YES completion:nil];
    }
}

/// 获取登录页面
+ (SAViewController *)_getLoginPageVC {
    SAViewController *loginVC;

    NSString *switchLine = [SAAppSwitchManager.shared switchForKey:SAAppSwitchNewLoginPage];
    if (switchLine && [switchLine isEqualToString:@"on"]) {
        return loginVC = SALoginViewController.new;

    } else {
        if (kJumpDirectlyToPasswordLogin) {
            loginVC = SALoginByPasswordViewController.new;
        } else {
            loginVC = SALoginFrontPageViewController.new;
        }
        return loginVC;
    }
}

/// 跳转到绑定手机页面
+ (void)navigateToSetPhoneViewControllerWithText:(NSString *)text bindSuccessBlock:(nullable dispatch_block_t)bindSuccessBlock cancelBindBlock:(nullable dispatch_block_t)cancelBindBlock {
    
    if([SAUser hasSignedIn]){
        ///新增手机绑定判断
        if (HDIsStringNotEmpty([SAUser getUserMobile])) {
            !bindSuccessBlock ?: bindSuccessBlock();
        } else {
            SASetPhoneViewController *vc = SASetPhoneViewController.new;
            vc.text = text;
            vc.bindSuccessBlock = ^{
                !bindSuccessBlock ?: bindSuccessBlock();
            };
            vc.cancelBindBlock = ^{
                !cancelBindBlock ?: cancelBindBlock();
            };
            [SAWindowManager navigateToViewController:vc parameters:@{}];
        }
    }else{
        @HDWeakify(self);
        [SAWindowManager switchWindowToLoginViewControllerWithLoginToDoEvent:^{
            @HDStrongify(self);
            [self navigateToSetPhoneViewControllerWithText:text bindSuccessBlock:bindSuccessBlock cancelBindBlock:cancelBindBlock];
        }];
    }
        
}


@end
