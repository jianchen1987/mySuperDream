//
//  WMTabBarController.m
//  SuperApp
//
//  Created by VanJay on 2020/3/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMTabBarController.h"
#import "HDPopTip.h"
#import "LKDataRecord.h"
#import "SAAppLaunchToDoService.h"
#import "SACacheManager.h"
#import "SANavigationController.h"
#import "SANotificationConst.h"
#import "SATabBar.h"
#import "SAUser.h"
#import "SAWindowManager.h"
#import "UITabBarItem+SATabBar.h"
#import "WMHomeViewController.h"
#import "WMMineViewController.h"
#import "WMOrderViewController.h"
#import "WMShoppingCartViewController.h"
#import <HDKitCore/CAAnimation+HDKitCore.h>
#import <HDKitCore/HDFunctionThrottle.h>
#import <HDKitCore/NSArray+HDKitCore.h>
#import <HDKitCore/UITabBarController+HDKitCore.h>
#import "SAAppSwitchManager.h"


@interface WMTabBarController () <SATabBarDelegate>
/// 自定义tabBar
@property (nonatomic, strong) SATabBar *customTabBar;
/// 新功能提示是否正在显示
@property (nonatomic, assign) BOOL isNewFunctionGuideShowing;

///< 参数
@property (nonatomic, strong) NSDictionary<NSString *, id> *parameters;
@end


@implementation WMTabBarController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self.parameters = [[NSDictionary alloc] initWithDictionary:parameters];
    self = [super init];
    return self;
}

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

    [self registerNotifications];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [NSNotificationCenter.defaultCenter postNotificationName:kNotificationNameSuccessGetDeliveryAppTabBarConfigList object:nil];
}

- (void)dealloc {
    [self unRegisterNotifications];
}

- (void)setupChildViewControllers {
    NSArray<SATabBarItemConfig *> *configArray = [WMTabBarController mainTabBarConfigArray];
    NSMutableArray<UIViewController *> *vcs = [[NSMutableArray alloc] init];

    for (SATabBarItemConfig *config in configArray) {
        config.selectedTitleColor = HDAppTheme.WMColor.mainRed;
        NSString *controllerClassName = config.loadPageName;
        Class controllerClass = NSClassFromString(controllerClassName);
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:2];
        [dic addEntriesFromDictionary:config.startupParams];
        [dic addEntriesFromDictionary:self.parameters];
        SAViewController *vc = [[controllerClass alloc] initWithRouteParameters:dic];
        vc.title = config.name.desc;
        SANavigationController *nav = [SANavigationController rootVC:vc];
        nav.tabBarItem.hd_config = config;
        [vcs addObject:nav];
    }

    self.viewControllers = vcs;
}

#pragma mark - private methods
- (void)registerNotifications {
    // 监听语言变化
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(hd_languageDidChanged) name:kNotificationNameLanguageChanged object:nil];

    // 监听获取导航栏配置成功
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(appSuccessGetAppTabBarConfigList) name:kNotificationNameSuccessGetDeliveryAppTabBarConfigList object:nil];
}

- (void)unRegisterNotifications {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameLanguageChanged object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameSuccessGetDeliveryAppTabBarConfigList object:nil];
}

- (NSArray<SATabBarItemConfig *> *)reloadTabBarData {
    // 取出配置
    NSArray<SATabBarItemConfig *> *oldList = [self.class mainTabBarConfigArray];

    // 更新SACacheManager
    [self.customTabBar addCustomButtonsWithConfigArray:oldList];

    return oldList;
}

#pragma mark - public methods
+ (NSArray<SATabBarItemConfig *> *)mainTabBarConfigArray {
    // 从本地获取配置
    NSArray<SATabBarItemConfig *> *cacheList = [SACacheManager.shared objectForKey:kCacheKeyDeliveryAppTabBarConfigList type:SACacheTypeDocumentPublic relyLanguage:YES];

    // 过滤掉无效配置
    NSArray<SATabBarItemConfig *> *list = [cacheList mapObjectsUsingBlock:^id _Nonnull(SATabBarItemConfig *_Nonnull obj, NSUInteger idx) {
        NSString *className = obj.loadPageName;

        Class vcClass = NSClassFromString(className);
        obj.selectedTitleColor = HDAppTheme.WMColor.mainRed;
        if (!vcClass) {
            return nil;
        } else {
            //            if([className isEqualToString:@"WMHomeViewController"]){
            //                NSString *cryptModel = [SAAppSwitchManager.shared switchForKey:SAAppSwitchNewWMPage];
            //                if(HDIsStringNotEmpty(cryptModel) && [cryptModel.lowercaseString isEqualToString:@"on"]) {
            //                    className = @"WMNewHomeViewController";
            //                    obj.loadPageName = className;
            //                }
            //            }
            return obj;
        }
    }];

    if (!list || list.count <= 0) {
        return [WMTabBarController defaultTabBarConfigArray];
    } else {
        return list;
    }
}

+ (NSArray<SATabBarItemConfig *> *)defaultTabBarConfigArray {
    NSMutableArray<SATabBarItemConfig *> *res = [NSMutableArray arrayWithCapacity:4];
    SATabBarItemConfig *config = SATabBarItemConfig.new;
    config.index = 1;
    config.selectedTitleColor = HDAppTheme.WMColor.mainRed;

    //    NSString *cryptModel = [SAAppSwitchManager.shared switchForKey:SAAppSwitchNewWMPage];
    //    if(HDIsStringNotEmpty(cryptModel) && [cryptModel.lowercaseString isEqualToString:@"on"]) {
    //        config.loadPageName = @"WMNewHomeViewController";
    //    }else{
    config.loadPageName = @"WMHomeViewController";
    //    }
    config.startupParams = @{@"hideBackButton": @0};
    SAInternationalizationModel *languageModel = [SAInternationalizationModel modelWithWMInternationalKey:@"home" value:@"首页" table:nil];
    [config setLocalName:languageModel localImage:@"yn_tabbar_home" selectedLocalImage:@"yn_tabbar_home_sel"];
    [res addObject:config];

    config = SATabBarItemConfig.new;
    config.index = 2;
    config.selectedTitleColor = HDAppTheme.WMColor.mainRed;
    config.loadPageName = @"WMShoppingCartViewController";
    config.startupParams = @{};
    languageModel = [SAInternationalizationModel modelWithWMInternationalKey:@"cart_title" value:@"购物车" table:nil];
    [config setLocalName:languageModel localImage:@"yn_tabbar_car" selectedLocalImage:@"yn_tabbar_car_sel"];
    [res addObject:config];

    config = SATabBarItemConfig.new;
    config.index = 3;
    config.selectedTitleColor = HDAppTheme.WMColor.mainRed;
    config.loadPageName = @"WMMineViewController";
    config.startupParams = @{};
    languageModel = [SAInternationalizationModel modelWithWMInternationalKey:@"profile" value:@"会员" table:nil];
    [config setLocalName:languageModel localImage:@"yn_tabbar_new" selectedLocalImage:@"yn_tabbar_new_sel"];
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
    HDLog(@"获取 tabbar 配置成功");
    NSArray<SATabBarItemConfig *> *oldList = [self reloadTabBarData];

    // 展示新功能提示
    // 节流的同时做到延时
    dispatch_throttle(1, @"yunmow.showTabBarGuideEventKey", ^{
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
            [SACacheManager.shared setObject:oldList forKey:kCacheKeyDeliveryAppTabBarConfigList type:SACacheTypeDocumentPublic relyLanguage:NO];

            // 刷新
            [strongSelf reloadTabBarData];
        } withKey:@"yunmow.showTabBarGuideEventKey"];
    });
}

#pragma mark - SATabBarDelegate
- (void)tabBar:(SATabBar *)tabBar didSelectButton:(SATabBarButton *)button {
    if (self.selectedIndex != NSNotFound && button.animatedImageView) {
        //        [button.animatedImageView.layer addAnimation:[CAAnimation scaleAnimationWithDuration:0.2 repeatCount:1 fromValue:@1 toValue:@0.7] forKey:nil];
        [button addCustomAnimation:[CAAnimation scaleAnimationWithDuration:0.2 repeatCount:1 fromValue:@1 toValue:@0.7] forKey:nil];
    }

    if (self.selectedIndex == tabBar.selectedIndex) {
        !self.repeatSelectedBlock ?: self.repeatSelectedBlock(tabBar.selectedIndex);
        return;
    }

    if (self.selectedIndex != NSNotFound) {
        // 增加转场动画
        // [self addTransitionAnimationForWillSelectIndex:tabBar.selectedIndex duration:0.3];
    }

    // 设置选中
    self.selectedIndex = tabBar.selectedIndex;

    [LKDataRecord.shared traceEvent:@"clickBtn" name:@"clickBtn" parameters:@{@"clickType": @"BOTTOM", @"content": button.config.name.desc} SPM:[LKSPM SPMWithPage:@"WMTabBarController" area:nil node:nil]];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if (self.selectedIndex == selectedIndex)
        return;
    [super setSelectedIndex:selectedIndex];
    self.customTabBar.selectedIndex = selectedIndex;
    !self.selectedIndexBlock ?: self.selectedIndexBlock(selectedIndex);
}

#pragma mark - lazy load
- (SATabBar *)customTabBar {
    if (!_customTabBar) {
        _customTabBar = [SATabBar new];
        _customTabBar.customTarBarDelegate = self;
    }
    return _customTabBar;
}
@end
