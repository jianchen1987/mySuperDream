//
//  TNSellerTableViewController.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/8.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNSellerTabBarViewController.h"
#import "HDAppTheme+TinhNow.h"
#import "SANavigationController.h"
#import "SATabBar.h"
#import "SATabBarItemConfig.h"
#import "SAViewController.h"
#import "TNCustomTabBarView.h"
#import "TNIncomeViewController.h"
#import "TNMicroShopViewController.h"
#import "TNSellerOrderViewController.h"
#import "TNTutorialViewController.h"
#import "UITabBarItem+SATabBar.h"


@interface TNSellerTabBarViewController () <SATabBarDelegate>
/// 自定义tabBar
@property (nonatomic, strong) SATabBar *customTabBar;
///
@property (strong, nonatomic) NSArray<SATabBarItemConfig *> *configArray;
///
@property (strong, nonatomic) TNTutorialViewController *tutorialVC;
@end


@implementation TNSellerTabBarViewController

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
}

- (void)setupChildViewControllers {
    self.configArray = [TNSellerTabBarViewController defaultTabBarConfigArray];
    NSMutableArray<UIViewController *> *vcs = [[NSMutableArray alloc] init];

    for (SATabBarItemConfig *config in self.configArray) {
        config.selectedTitleColor = HDAppTheme.TinhNowColor.C1;
        NSString *controllerClassName = config.loadPageName;
        Class controllerClass = NSClassFromString(controllerClassName);
        TNViewController *vc = [[controllerClass alloc] init];
        vc.title = config.name.desc;
        if ([vc isKindOfClass:TNTutorialViewController.class]) {
            TNTutorialViewController *webVC = (TNTutorialViewController *)vc;
            self.tutorialVC = webVC;
        }
        SANavigationController *nav = [SANavigationController rootVC:vc];
        nav.tabBarItem.hd_config = config;
        [vcs addObject:nav];
    }

    self.viewControllers = vcs;
}

+ (NSArray<SATabBarItemConfig *> *)defaultTabBarConfigArray {
    NSMutableArray<SATabBarItemConfig *> *res = [NSMutableArray arrayWithCapacity:4];
    SATabBarItemConfig *config = SATabBarItemConfig.new;
    config.index = 1;
    // 设置本地配置
    SAInternationalizationModel *languageModel = [SAInternationalizationModel modelWithInternationalKey:@"seller_tabbar_home" value:TNLocalizedString(@"tn_product_backhome", @"首页") table:nil];
    config.loadPageName = @"TNMicroShopViewController";
    config.startupParams = @{};
    [config setLocalName:languageModel localImage:@"tn_seller_home_nomal" selectedLocalImage:@"tn_seller_home_selected"];
    [config setTitleColor:HDAppTheme.TinhNowColor.G3 selectedTitleColor:HDAppTheme.TinhNowColor.C1];
    [res addObject:config];

    config = SATabBarItemConfig.new;
    config.index = 2;
    // 设置本地配置
    languageModel = [SAInternationalizationModel modelWithInternationalKey:@"seller_order" value:TNLocalizedString(@"tn_tabbar_order_title", @"订单") table:nil];
    config.loadPageName = @"TNSellerOrderViewController";
    config.startupParams = @{};
    [config setLocalName:languageModel localImage:@"tn_seller_order_nomal" selectedLocalImage:@"tn_seller_order_selected"];
    [config setTitleColor:HDAppTheme.TinhNowColor.G3 selectedTitleColor:HDAppTheme.TinhNowColor.C1];
    [res addObject:config];

    config = SATabBarItemConfig.new;
    config.index = 3;
    // 设置本地配置
    languageModel = [SAInternationalizationModel modelWithInternationalKey:@"seller_income" value:TNLocalizedString(@"1dh32q2n", @"收益") table:nil];
    config.loadPageName = @"TNIncomeViewController";
    config.startupParams = @{};
    [config setLocalName:languageModel localImage:@"tn_income_nomal" selectedLocalImage:@"tn_income_selected"];
    [config setTitleColor:HDAppTheme.TinhNowColor.G3 selectedTitleColor:HDAppTheme.TinhNowColor.C1];
    [res addObject:config];
    //
    config = SATabBarItemConfig.new;
    config.index = 4;
    // 设置本地配置
    languageModel = [SAInternationalizationModel modelWithInternationalKey:@"sell_mine" value:TNLocalizedString(@"yPagC9Hf", @"教程") table:nil];
    config.loadPageName = @"TNTutorialViewController";
    config.startupParams = @{};
    [config setLocalName:languageModel localImage:@"tn_seller_help_nomal" selectedLocalImage:@"tn_seller_help_selected"];
    [config setTitleColor:HDAppTheme.TinhNowColor.G3 selectedTitleColor:HDAppTheme.TinhNowColor.C1];
    [res addObject:config];

    return res;
}
#pragma mark - SATabBarDelegate
- (void)tabBar:(SATabBar *)tabBar didSelectButton:(SATabBarButton *)button {
    if (self.selectedIndex != NSNotFound && button.animatedImageView) {
        //        [button.animatedImageView.layer addAnimation:[CAAnimation scaleAnimationWithDuration:0.2 repeatCount:1 fromValue:@1 toValue:@0.7] forKey:nil];
    }

    if (self.selectedIndex == tabBar.selectedIndex) {
        return;
    }

    if (self.selectedIndex != NSNotFound) {
        // 增加转场动画
        //        [self addTransitionAnimationForWillSelectIndex:tabBar.selectedIndex duration:0.3];
    }

    // 设置选中
    self.selectedIndex = tabBar.selectedIndex;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if (self.selectedIndex == selectedIndex)
        return;
    [super setSelectedIndex:selectedIndex];
    self.customTabBar.selectedIndex = selectedIndex;

    SATabBarItemConfig *config = self.configArray[selectedIndex];
    if ([config.loadPageName isEqualToString:@"TNTutorialViewController"]) {
        if (HDIsStringEmpty(self.tutorialVC.url)) {
            self.tutorialVC.url = [[SAAppEnvManager sharedInstance].appEnvConfig.tinhNowHost stringByAppendingString:kTinhNowMicroShopTutorial];
        }
        [TNEventTrackingInstance trackEvent:@"buyer_book" properties:@{@"buyerId": [TNGlobalData shared].seller.supplierId}];
    } else if ([config.loadPageName isEqualToString:@"TNIncomeViewController"]) {
        [TNEventTrackingInstance trackEvent:@"buyer_income" properties:@{@"buyerId": [TNGlobalData shared].seller.supplierId}];
    }
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
