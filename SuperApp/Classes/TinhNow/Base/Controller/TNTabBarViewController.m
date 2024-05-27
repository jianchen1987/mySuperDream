//
//  TNTabBarViewController.m
//  SuperApp
//
//  Created by seeu on 2020/6/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNTabBarViewController.h"
#import "HDPopTip.h"
#import "SAAppLaunchToDoService.h"
#import "SACacheManager.h"
#import "SANavigationController.h"
#import "SATabBar.h"
#import "SATabBarItemConfig.h"
#import "SATalkingData.h"
#import "SAUser.h"
#import "SAWindowManager.h"
#import "TNClassificationViewController.h"
#import "TNGlobalData.h"
#import "TNHomeViewController.h"
#import "TNMicroShopDTO.h"
#import "TNMoreViewController.h"
#import "TNOrderDTO.h"
#import "TNOrderViewController.h"
#import "TNPaymentCapacityResponse.h"
#import "TNQueryProcessingOrderRspModel.h"
#import "TNShoppingCar.h"
#import "TNShoppingCarViewController.h"
#import "TNShoppingCartEntryWindow.h"
#import "UITabBarItem+SATabBar.h"
#import <HDKitCore/CAAnimation+HDKitCore.h>
#import <HDKitCore/HDFunctionThrottle.h>
#import <HDKitCore/NSArray+HDKitCore.h>
#import <HDKitCore/UITabBarController+HDKitCore.h>


@interface TNTabBarViewController () <SATabBarDelegate>
/// 自定义tabBar
@property (nonatomic, strong) SATabBar *customTabBar;
/// 新功能提示是否正在显示
@property (nonatomic, assign) BOOL isNewFunctionGuideShowing;
/// DTO
@property (nonatomic, strong) TNOrderDTO *orderDTO;
/// 购物车数据中心
@property (strong, nonatomic) TNShoppingCar *shopCarDataCenter;

@end


@implementation TNTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.customTabBar.translucent = NO;

    // iOS 13 beta 的 bug
    if (@available(iOS 10.0, *)) {
        self.customTabBar.unselectedItemTintColor = UIColor.lightGrayColor;
    }

    // 替换系统 tabBar
    [self setValue:self.customTabBar forKey:@"tabBar"];

    [self setupChildViewControllers];
    // 检查版本更新
    [self checkVersion];
    //查询购物车数据
    [self queryUserShoppingTotalCount];

    @HDWeakify(self);
    [self.KVOController hd_observe:self.shopCarDataCenter keyPath:@"totalGoodsCount" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        //总数量
        NSInteger totalCount = self.shopCarDataCenter.totalGoodsCount;
        NSInteger shopCartIndex = [self getIndexOfControllerByClassName:@"TNShoppingCarViewController"];
        if (totalCount == 0) {
            [self updateBadgeValue:@"" atIndex:shopCartIndex];
        } else if (totalCount <= 99) {
            [self updateBadgeValue:[NSString stringWithFormat:@"%ld", totalCount] atIndex:shopCartIndex];
        } else {
            [self updateBadgeValue:@"99+" atIndex:shopCartIndex];
        }
    }];
}
- (void)dealloc {
    [self unRegisterNotifications];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self queryProcessingOrders];
    [NSNotificationCenter.defaultCenter postNotificationName:kNotificationNameSuccessGetTinhNowAppTabBarConfigList object:nil];
}

- (void)setupChildViewControllers {
    NSArray<SATabBarItemConfig *> *configArray = [TNTabBarViewController mainTabBarConfigArray];
    NSMutableArray<UIViewController *> *vcs = [[NSMutableArray alloc] init];

    for (SATabBarItemConfig *config in configArray) {
        config.selectedTitleColor = HDAppTheme.TinhNowColor.C1;
        NSString *controllerClassName = config.loadPageName;
        Class controllerClass = NSClassFromString(controllerClassName);
        SAViewController *vc = [[controllerClass alloc] initWithRouteParameters:config.startupParams];
        vc.title = config.name.desc;
        SANavigationController *nav = [SANavigationController rootVC:vc];
        nav.tabBarItem.hd_config = config;
        [vcs addObject:nav];
    }

    self.viewControllers = vcs;
}
- (void)queryUserShoppingTotalCount {
    if ([SAUser hasSignedIn]) {
        [self.shopCarDataCenter queryUserShoppingTotalCountSuccess:nil failure:nil];
    }
}
#pragma mark - private methods
- (void)queryProcessingOrders {
    if (![SAUser hasSignedIn]) {
        return;
    }
    @HDWeakify(self);
    [self.orderDTO queryTinhNowProcessOrdersNumberWithOperateNo:SAUser.shared.operatorNo success:^(TNQueryProcessingOrderRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        if (HDIsObjectNil(rspModel)) {
            return;
        }
        //总数量
        NSInteger totalCount = [rspModel getTotalOrderNum];
        NSInteger orderIndex = [self getIndexOfControllerByClassName:@"TNOrderViewController"];
        if (totalCount == 0) {
            [self updateBadgeValue:@"" atIndex:orderIndex];
        } else if (totalCount <= 99) {
            [self updateBadgeValue:[NSString stringWithFormat:@"%ld", totalCount] atIndex:orderIndex];
        } else {
            [self updateBadgeValue:@"99+" atIndex:orderIndex];
        }
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error){

    }];
}

- (void)registerNotifications {
    // 监听语言变化
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(hd_languageDidChanged) name:kNotificationNameLanguageChanged object:nil];
    // 监听获取导航栏配置成功
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(appSuccessGetAppTabBarConfigList) name:kNotificationNameSuccessGetTinhNowAppTabBarConfigList object:nil];
    //监听用户登录成功  在电商埋点  只统计从电商侧登录的
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(loginSuccess) name:kNotificationNameLoginSuccess object:nil];
}

- (void)unRegisterNotifications {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameLanguageChanged object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameSuccessGetTinhNowAppTabBarConfigList object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameLoginSuccess object:nil];
}

- (NSArray<SATabBarItemConfig *> *)reloadTabBarData {
    // 取出配置
    NSArray<SATabBarItemConfig *> *oldList = [TNTabBarViewController mainTabBarConfigArray];

    // 更新SACacheManager
    [self.customTabBar addCustomButtonsWithConfigArray:oldList];

    return oldList;
}

#pragma mark - public methods
+ (NSArray<SATabBarItemConfig *> *)mainTabBarConfigArray {
    // 从本地获取配置
    NSArray<SATabBarItemConfig *> *cacheList = [SACacheManager.shared objectForKey:kCacheKeyTinhNowAppTabBarConfigList type:SACacheTypeDocumentPublic relyLanguage:YES];

    // 过滤掉无效配置
    NSArray<SATabBarItemConfig *> *list = [cacheList mapObjectsUsingBlock:^id _Nonnull(SATabBarItemConfig *_Nonnull obj, NSUInteger idx) {
        NSString *className = obj.loadPageName;
        Class vcClass = NSClassFromString(className);
        if (!vcClass) {
            return nil;
        } else {
            return obj;
        }
    }];

    if (!list || list.count <= 0) {
        HDLog(@"使用默认配置");
        return [TNTabBarViewController defaultTabBarConfigArray];
    } else {
        HDLog(@"使用线上配置");
        return list;
    }
}

+ (NSArray<SATabBarItemConfig *> *)defaultTabBarConfigArray {
    NSMutableArray<SATabBarItemConfig *> *res = [NSMutableArray arrayWithCapacity:4];
    SATabBarItemConfig *config = SATabBarItemConfig.new;
    config.index = 1;
    // 设置本地配置
    SAInternationalizationModel *languageModel = [SAInternationalizationModel modelWithInternationalKey:@"tinhNow" value:TNLocalizedString(@"tn_tabbar_home_title", @"电商") table:nil];
    [config setLocalName:languageModel localImage:@"tinhnow-ic-tabbar-home-normal" selectedLocalImage:@"tinhnow-ic-tabbar-home-selected"];
    [config setTitleColor:HDAppTheme.TinhNowColor.G2 selectedTitleColor:HDAppTheme.TinhNowColor.C1];
    config.hideTextWhenSelected = YES;
    config.loadPageName = @"TNHomeViewController";
    config.startupParams = @{@"hideBackButton": @0};
    [res addObject:config];

    config = SATabBarItemConfig.new;
    config.index = 2;
    // 设置本地配置
    languageModel = [SAInternationalizationModel modelWithInternationalKey:@"tinhnow-tabbar-class" value:TNLocalizedString(@"tn_tabbar_category_title", @"分类") table:nil];
    [config setLocalName:languageModel localImage:@"tinhnow-ic-tabbar-class-normal" selectedLocalImage:@"tinhnow-ic-tabbar-class-selected"];
    [config setTitleColor:HDAppTheme.TinhNowColor.G2 selectedTitleColor:HDAppTheme.TinhNowColor.C1];
    config.loadPageName = @"TNClassificationViewController";
    config.startupParams = @{};
    [res addObject:config];

    config = SATabBarItemConfig.new;
    config.index = 3;
    // 设置本地配置
    languageModel = [SAInternationalizationModel modelWithInternationalKey:@"tinhnow-tabbar-shopcar" value:TNLocalizedString(@"tn_product_cart", @"购物车") table:nil];
    [config setLocalName:languageModel localImage:@"tinhnow-ic-tabbar-shopcar-normal" selectedLocalImage:@"tinhnow-ic-tabbar-shopcar-selected"];
    [config setTitleColor:HDAppTheme.TinhNowColor.G2 selectedTitleColor:HDAppTheme.TinhNowColor.C1];
    config.loadPageName = @"TNShoppingCarViewController";
    config.startupParams = @{};
    [res addObject:config];

    config = SATabBarItemConfig.new;
    config.index = 4;
    // 设置本地配置
    languageModel = [SAInternationalizationModel modelWithInternationalKey:@"tinhnow-tabbar-order" value:TNLocalizedString(@"tn_tabbar_order_title", @"订单") table:nil];
    [config setLocalName:languageModel localImage:@"tinhnow-ic-tabbar-order-normal" selectedLocalImage:@"tinhnow-ic-tabbar-order-selected"];
    [config setTitleColor:HDAppTheme.TinhNowColor.G2 selectedTitleColor:HDAppTheme.TinhNowColor.C1];
    config.loadPageName = @"TNOrderViewController";
    config.startupParams = @{};
    [res addObject:config];

    config = SATabBarItemConfig.new;
    config.index = 5;
    // 设置本地配置
    languageModel = [SAInternationalizationModel modelWithInternationalKey:@"tinhnow-tabbar-more" value:TNLocalizedString(@"tn_tabbar_more_title", @"更多") table:nil];
    [config setLocalName:languageModel localImage:@"tinhnow-ic-tabbar-more-normal" selectedLocalImage:@"tinhnow-ic-tabbar-more-selected"];
    [config setTitleColor:HDAppTheme.TinhNowColor.G2 selectedTitleColor:HDAppTheme.TinhNowColor.C1];
    config.loadPageName = @"TNMoreViewController";
    config.startupParams = @{};
    [res addObject:config];

    return res;
}

#pragma mark - Notification
- (void)hd_languageDidChanged {
    for (SATabBarButton *button in self.customTabBar.buttons) {
        NSString *title = HDIsStringNotEmpty(button.config.name.desc) ? button.config.name.desc : button.config.localName.desc;
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitle:button.config.hideTextWhenSelected ? @"" : title forState:UIControlStateSelected];
    }
}

- (void)appSuccessGetAppTabBarConfigList {
    NSArray<SATabBarItemConfig *> *oldList = [self reloadTabBarData];

    // 展示新功能提示
    // 节流的同时做到延时
    dispatch_throttle(1, @"showTinhNowTabBarGuideEventKey", ^{
        NSArray<SATabBarButton *> *array = self.customTabBar.shouldShowGuideViewArray;
        if (self.isNewFunctionGuideShowing || !array || array.count <= 0)
            return;
        NSArray<HDPopTipConfig *> *configs = [array mapObjectsUsingBlock:^HDPopTipConfig *_Nonnull(SATabBarButton *_Nonnull obj, NSUInteger idx) {
            HDPopTipConfig *config = [[HDPopTipConfig alloc] init];
            config.text = obj.config.guideDesc.desc;
            config.sourceView = obj.animatedImageView;
            config.needDrawMaskImageBackground = true;
            config.autoDismiss = false;
            config.maskImageHeightScale = (49.0 / obj.animatedImageView.bounds.size.height) / 1.414;
            config.imageURL = obj.config.selectedImageUrl;
            config.identifier = [NSString stringWithFormat:@"tabbar_%@", obj.config.identifier];
            return config;
        }];
        [HDPopTip showPopTipInView:nil configs:configs onlyInControllerClass:[self class]];
        self.isNewFunctionGuideShowing = true;
        __weak __typeof(self) weakSelf = self;
        [HDPopTip setDissmissHandler:^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.isNewFunctionGuideShowing = false;
            // 新功能指引消失
            NSArray<SATabBarItemConfig *> *showndList = [array mapObjectsUsingBlock:^SATabBarItemConfig *_Nonnull(SATabBarButton *_Nonnull obj, NSUInteger idx) {
                return obj.config;
            }];

            [showndList enumerateObjectsUsingBlock:^(SATabBarItemConfig *_Nonnull obj, NSUInteger oldIdx, BOOL *_Nonnull oldStop) {
                [oldList enumerateObjectsUsingBlock:^(SATabBarItemConfig *_Nonnull oldObj, NSUInteger idx, BOOL *_Nonnull stop) {
                    if ([oldObj.identifier isEqualToString:obj.identifier]) {
                        oldObj.hasDisplayedNewFunctionGuide = true;
                    }
                }];
            }];
            // 更新缓存
            [SACacheManager.shared setObject:oldList forKey:kCacheKeyTinhNowAppTabBarConfigList type:SACacheTypeDocumentPublic relyLanguage:YES];

            // 刷新
            [strongSelf reloadTabBarData];
        } withKey:@"showTinhNowTabBarGuideEventKey"];
    });
}
- (void)loginSuccess {
    [SATalkingData trackEvent:@"[电商]点击登录"];
    //查询购物车数据
    [self queryUserShoppingTotalCount];
}

- (NSUInteger)getIndexOfControllerByClassName:(NSString *)className {
    __block NSUInteger index = 99;
    [self.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        UIViewController *trueVC = obj;
        if ([obj isKindOfClass:UINavigationController.class]) {
            UINavigationController *nav = obj;
            trueVC = nav.hd_rootViewController;
        }
        if ([className isEqualToString:NSStringFromClass(trueVC.class)]) {
            index = idx;
            *stop = YES;
        }
    }];
    return index;
}
#pragma mark - SATabBarDelegate
- (BOOL)tabBar:(SATabBar *)tabBar shouldInterceptClickAtIndex:(NSInteger)index {
    //如果是购物车页面  要先判断是否登录
    if (![SAUser hasSignedIn]) {
        NSInteger shopCartIndex = [self getIndexOfControllerByClassName:@"TNShoppingCarViewController"];
        if (index == shopCartIndex) {
            //购物车 先跳转登录
            @HDWeakify(self);
            [SAWindowManager switchWindowToLoginViewControllerWithLoginToDoEvent:^{
                @HDStrongify(self);
                self.customTabBar.selectedIndex = shopCartIndex;
            }];
            return YES;
        }
    }
    return NO;
}
- (void)tabBar:(SATabBar *)tabBar didSelectButton:(SATabBarButton *)button {
    if (self.selectedIndex != NSNotFound && button.animatedImageView) {
        //        [button.animatedImageView.layer addAnimation:[CAAnimation scaleAnimationWithDuration:0.2 repeatCount:1 fromValue:@1 toValue:@0.7] forKey:nil];
        [button addCustomAnimation:[CAAnimation scaleAnimationWithDuration:0.2 repeatCount:1 fromValue:@1 toValue:@0.7] forKey:nil];
    }
    //分类页面埋点
    if ([button.config.loadPageName isEqualToString:@"TNClassificationViewController"]) {
        [SATalkingData trackEvent:@"[电商]分类tab"];
    }
    if (self.selectedIndex == tabBar.selectedIndex)
        return;

    if (self.selectedIndex != NSNotFound) {
        // 增加转场动画
        //         [self addTransitionAnimationForWillSelectIndex:tabBar.selectedIndex duration:0.3];
    }

    // 设置选中
    self.selectedIndex = tabBar.selectedIndex;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if (self.selectedIndex == selectedIndex)
        return;
    [super setSelectedIndex:selectedIndex];
    self.customTabBar.selectedIndex = selectedIndex;
    !self.selectedIndexBlock ?: self.selectedIndexBlock(selectedIndex);
}

- (void)checkVersion {
    //目前只是调用  更新走错误G1097   G1098处理
    TNNetworkRequest *request = TNNetworkRequest.new;
    request.retryCount = 2;
    request.requestURI = @"/api/merchant/common/hn";
    request.isNeedLogin = NO;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    if ([SAUser hasSignedIn] && HDIsStringNotEmpty(SAUser.shared.loginName)) {
        request.requestParameter = @{@"loginName": SAUser.shared.loginName};
    }
    [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {

    } failure:^(HDNetworkResponse *_Nonnull response){
    }];
}

#pragma mark - lazy load
- (SATabBar *)customTabBar {
    if (!_customTabBar) {
        _customTabBar = [SATabBar new];
        _customTabBar.customTarBarDelegate = self;
    }
    return _customTabBar;
}
/** @lazy orderDTO */
- (TNOrderDTO *)orderDTO {
    if (!_orderDTO) {
        _orderDTO = [[TNOrderDTO alloc] init];
    }
    return _orderDTO;
}
/** @lazy shopCarDataCenter */
- (TNShoppingCar *)shopCarDataCenter {
    if (!_shopCarDataCenter) {
        _shopCarDataCenter = [TNShoppingCar share];
    }
    return _shopCarDataCenter;
}
@end
