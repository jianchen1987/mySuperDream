//
//  HDBaseViewController.h
//  customer
//
//  Created by 陈剑 on 2018/7/4.
//  Copyright © 2018年 chaos network technology. All rights reserved.
//

#import "HDAppTheme.h"
#import "SANavigationController.h"
#import "HDBaseViewModel.h"
#import "HDCustomNavBarController.h"
#import "HDDispatchMainQueueSafe.h"
#import "HDEnum.h"
#import "HDJsonRspModel.h"
#import "HDNotificationMacro.h"
#import "HDRouteMacro.h"
#import "SATalkingData.h"
#import "HDTips.h"
#import "HDUIButton.h"
//#import "HDWindowManager.h"
#import "InternationalManager.h"
#import "NAT.h"
#import "UIImageView+hdAnimate.h"
#import "UIMacro.h"
#import "UIView+HD_Extension.h"
#import "UIView+HD_Extension.h"
#import "UIViewController+HDKitCore.h"
#import "UtilMacro.h"
#import "VipayUser.h"
#import "WJFrameLayout.h"
//#import <JLRoutes/JLRoutes.h>
#import <Masonry/Masonry.h>

typedef NS_ENUM(NSInteger, HDNavigationStyle) { HDNavigationStyleGradual, HDNavigationStyleClear, HDNavigationStyleHidden, HDNavigationStyleWhite, HDNavigationStyleOther };

#define HDWeakSelf __weak typeof(self) weakSelf = self;
#define HDStrongSelf __strong typeof(self) strongSelf = self;

@import Firebase;

typedef NS_ENUM(NSInteger, HDBackBarButtonImageToType) { HDBackBarButtonImageToTypeWhite = 0, HDBackBarButtonImageToTypeRed };

@protocol InternationalProtocol <NSObject>

@required
- (void)reflushUI;
@end


@interface HDBaseViewController : HDCustomNavBarController <InternationalProtocol, ViewModelProtocol>
@property (nonatomic, strong) UIBarButtonItem *hdBackBarButtonItem;
@property (nonatomic, assign) BOOL isInitialLayoutEnded;                   ///< 初次布局是否完成
@property (nonatomic, assign) UIStatusBarStyle hd_preferredStatusBarStyle; ///< 状态栏样式
@property (nonatomic, copy) NSDictionary<NSString *, id> *parameters;      ///< 路由参数
@property (nonatomic, assign) BOOL needLogin;                              ///< 是否需要登录，默认 YES
@property (nonatomic, assign) BOOL disableHandleKeyBoardEvent;             ///< 禁用键盘处理，在 viewDidLoad 之前设置
@property (nonatomic, strong) UIScrollView *scrollContainerView;           ///< 滚动容器
@property (nonatomic, copy) NSString *boldTitle;                           ///< 设置加粗标题（17 bold, #343B4D）
@property (nonatomic, assign) BOOL allowContinuousBePushed;                ///< 允许被连续 push，默认为否
@property (nonatomic, strong, readonly) HDUIButton *backBarButton;         ///< 引用用于动态修改

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters;

/** 显示 loading */
- (void)showloading;

/** 显示 loading 到 self.view */
- (void)showloadingToSelf;

/** 0.3秒后关闭 loading */
- (void)dismissLoading;

/** 立刻关闭 loading */
- (void)dismissLoadingImmediately;

- (void)viewModel:(HDBaseViewModel *)viewModel transactionFailure:(NSString *)reason code:(NSString *)code;

- (void)networkRequestFail:(NSError *)error;

- (void)checkAuthentificate:(void (^)(void))finish;

/**
 点击了返回按钮
 */
- (void)clickOnBackBarButtonItem:(UIBarButtonItem *)item;

/**
 可否跳结果页
 */
- (BOOL)shouldGoToResultPageByCode:(NSString *)code;

/**
 导航栏风格
 */
- (HDNavigationStyle)navigationBarStyleForViewController:(HDBaseViewController *)viewController;

/** 是否隐藏导航栏底部线条 */
- (BOOL)shouldHideNavigationBarBottomLine;

/** 是否添加导航栏底部阴影 */
- (BOOL)shouldHideNavigationBarBottomShadow;

/**
 动态改变返回按钮样式，这里只是提供遍历方式设置两种图片而已，如需设置更多图片可使用 setNavLeftBtnImage:title:方法

 @param type 目标样式
 */
- (void)changeBackBarButtonImageToType:(HDBackBarButtonImageToType)type;

/** 获取 SANavigationController 导航控制器 */
- (SANavigationController *)navController;

/**
 设置加粗标题，带颜色

 @param color 颜色
 */
- (void)setBoldWithTitle:(NSString *)title color:(UIColor *)color;

/** 更新导航栏样式 */
- (void)udpateStatusBarStyle;
@end

/** 导航栏白色，导航栏底部加阴影 */
@interface HDNavBarWhiteBottomShadowViewController : HDBaseViewController

@end
