//
//  GNTabBarController.m
//  SuperApp
//
//  Created by wmz on 2021/5/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNTabBarController.h"
#import "GNHomeViewController.h"
#import "GNNewsDTO.h"
#import "GNNewsViewController.h"
#import "GNTabbar.h"
#import "GNViewController.h"
#import "LOTAnimationView.h"
#import "SAAppLaunchToDoService.h"
#import "SACacheManager.h"
#import "SANavigationController.h"
#import "SANotificationConst.h"
#import "SAWindowManager.h"
#import "UITabBarItem+SATabBar.h"
#import <HDKitCore/CAAnimation+HDKitCore.h>
#import <HDKitCore/HDFunctionThrottle.h>
#import <HDKitCore/NSArray+HDKitCore.h>
#import <HDKitCore/UITabBarController+HDKitCore.h>


@interface GNTabBarController () <SATabBarDelegate>
/// 自定义tabBar
@property (nonatomic, strong) GNTabbar *customTabBar;
/// 新功能提示是否正在显示
@property (nonatomic, assign) BOOL isNewFunctionGuideShowing;
/// 消息
@property (nonatomic, strong) GNNewsDTO *newDTO;

@property (nonatomic, strong) LOTAnimationView *animation;
@end


@implementation GNTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.customTabBar.translucent = NO;
    if (@available(iOS 10.0, *)) {
        self.customTabBar.unselectedItemTintColor = UIColor.lightGrayColor;
    }
    [self setValue:self.customTabBar forKey:@"tabBar"];
    [self setupChildViewControllers];
    [self registerNotifications];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [NSNotificationCenter.defaultCenter postNotificationName:kNotificationNameSuccessGetGroupBuyAppTabBarConfigList object:nil];
    [self getMessageCount];
}

- (void)getMessageCount {
    @HDWeakify(self)[self.newDTO getUnreadSystemMessageCountBlock:^(NSUInteger station) {
        @HDStrongify(self) SATabBarButton *tabbarBtn = [self getCurrentTabBarButton];
        tabbarBtn.config.badgeValue = station ? @" " : @"";
        [tabbarBtn setConfig:tabbarBtn.config];
        [tabbarBtn updateBadgeColor:HDAppTheme.color.gn_mainColor];
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupChildViewControllers {
    NSArray<SATabBarItemConfig *> *configArray = [GNTabBarController mainTabBarConfigArray];
    NSMutableArray<UIViewController *> *vcs = [[NSMutableArray alloc] init];
    for (SATabBarItemConfig *config in configArray) {
        NSString *controllerClassName = config.loadPageName;
        Class controllerClass = NSClassFromString(controllerClassName);
        GNViewController *vc = [[controllerClass alloc] initWithRouteParameters:config.startupParams];
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
    return [GNTabBarController defaultTabBarConfigArray];
}

+ (NSArray<SATabBarItemConfig *> *)defaultTabBarConfigArray {
    NSMutableArray<SATabBarItemConfig *> *res = [NSMutableArray arrayWithCapacity:4];
    SATabBarItemConfig *config = SATabBarItemConfig.new;
    config.index = 0;
    config.titleColor = HDAppTheme.color.gn_999Color;
    config.selectedTitleColor = HDAppTheme.color.gn_333Color;
    config.loadPageName = @"GNHomeViewController";
    config.jsonName = @"gn_tab_home";
    //    config.startupParams = @{@"upImage" : @"gn_tab_home_up", @"downImage" : @"gn_tab_home_select"};
    SAInternationalizationModel *languageModel = [SAInternationalizationModel modelWithGNInternationalKey:@"gn_home_title" value:@"首页" table:nil];
    [config setLocalName:languageModel localImage:@"gn_tab_home" selectedLocalImage:@" "];
    [res addObject:config];

    config = SATabBarItemConfig.new;
    config.index = 1;
    config.titleColor = HDAppTheme.color.gn_999Color;
    config.selectedTitleColor = HDAppTheme.color.gn_333Color;
    config.loadPageName = @"GNOrderHomeViewController";
    config.startupParams = @{};
    config.jsonName = @"gn_tab_order";
    languageModel = [SAInternationalizationModel modelWithGNInternationalKey:@"gn_order_title" value:@"订单" table:nil];
    [config setLocalName:languageModel localImage:@"gn_tab_order" selectedLocalImage:@" "];
    [res addObject:config];

    config = SATabBarItemConfig.new;
    config.index = 2;
    config.titleColor = HDAppTheme.color.gn_999Color;
    config.selectedTitleColor = HDAppTheme.color.gn_333Color;
    config.loadPageName = @"GNNewsViewController";
    config.jsonName = @"gn_tab_news";
    config.badgeFont = [UIFont systemFontOfSize:5];
    config.startupParams = @{};
    languageModel = [SAInternationalizationModel modelWithGNInternationalKey:@"gn_news_title" value:@"消息" table:nil];
    [config setLocalName:languageModel localImage:@"gn_tab_news" selectedLocalImage:@" "];
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

#pragma mark - SATabBarDelegate
- (void)tabBar:(SATabBar *)tabBar didSelectButton:(SATabBarButton *)button {
    if (self.selectedIndex != NSNotFound && button.animatedImageView) {
        if (self.animation) {
            [self.animation stop];
            [self.animation removeFromSuperview];
        }
        self.animation = [LOTAnimationView animationNamed:button.config.jsonName];
        [button.animatedImageView addSubview:self.animation];
        [self.animation playWithCompletion:^(BOOL animationFinished){
        }];
    }
    if (self.selectedIndex == tabBar.selectedIndex) {
        !self.repeatSelectedBlock ?: self.repeatSelectedBlock(tabBar.selectedIndex);
        if (tabBar.selectedIndex == 0 && [button isSelected] && [button.config.loadPageName isEqualToString:@"GNHomeViewController"]) {
            GNHomeViewController *homeVC = nil;
            UINavigationController *naV = self.viewControllers.firstObject;
            if ([naV isKindOfClass:UINavigationController.class] && naV.viewControllers.count) {
                homeVC = naV.viewControllers.firstObject;
                if ([homeVC isKindOfClass:GNHomeViewController.class] && homeVC.isDown) {
                    [homeVC scrollToTop];
                }
            }
            return;
        }
    }
    if (self.selectedIndex != tabBar.selectedIndex && tabBar.selectedIndex == 2 && [button.config.loadPageName isEqualToString:@"GNNewsViewController"]) {
        GNNewsViewController *newsVC = nil;
        UINavigationController *naV = self.viewControllers[2];
        if ([naV isKindOfClass:UINavigationController.class] && naV.viewControllers.count) {
            newsVC = naV.viewControllers.firstObject;
            if ([newsVC isKindOfClass:GNNewsViewController.class]) {
                [newsVC gn_getNewData];
            }
        }
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

#pragma mark - lazy load
- (GNTabbar *)customTabBar {
    if (!_customTabBar) {
        _customTabBar = [GNTabbar new];
        _customTabBar.customTarBarDelegate = self;
    }
    return _customTabBar;
}

- (GNNewsDTO *)newDTO {
    if (!_newDTO) {
        _newDTO = GNNewsDTO.new;
    }
    return _newDTO;
}

- (SATabBarButton *)getCurrentTabBarButton {
    if (self.customTabBar.buttons.count > 2) {
        return self.customTabBar.buttons[2];
    }
    return nil;
}

@end
