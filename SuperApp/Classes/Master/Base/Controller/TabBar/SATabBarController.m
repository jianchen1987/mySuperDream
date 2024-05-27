//
//  SATabBarController.m
//  SuperApp
//
//  Created by VanJay on 2020/3/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATabBarController.h"
#import "HDPopTip.h"
#import "LKDataRecord.h"
#import "SAAppLaunchToDoService.h"
#import "SAAppSwitchManager.h"
#import "SAAppTheme.h"
#import "SAAppVersionViewModel.h"
#import "SACacheManager.h"
#import "SAMarketingAlertViewPresenter.h"
#import "SAMessageDTO.h"
#import "SAMessageManager.h"
#import "SANotificationConst.h"
#import "SARemoteNotifyViewModel.h"
#import "SATabBar.h"
#import "SATalkingData.h"
#import "SAUser.h"
#import "SAVersionAlertManager.h"
#import "SAWindowManager.h"
#import "TNGlobalData.h"
#import <HDKitCore/CAAnimation+HDKitCore.h>
#import <HDKitCore/HDFunctionThrottle.h>
#import <HDKitCore/NSArray+HDKitCore.h>
#import <HDKitCore/UITabBarController+HDKitCore.h>
#import <HDServiceKit/HDWebViewHost.h>
#import <HDServiceKit/WNHelloWebSocketClient.h>
#import <KSInstantMessagingKit/KSCore.h>
#import <KSInstantMessagingKit/KSInstMsgManager.h>


@interface SATabBarController () <SATabBarDelegate, SAMessageManagerDelegate>
/// 自定义tabBar
@property (nonatomic, strong) SATabBar *customTabBar;
/// 新功能提示是否正在显示
@property (nonatomic, assign) BOOL isNewFunctionGuideShowing;

@property (nonatomic, strong) SARemoteNotifyViewModel *remoteNotifyVM; ///<
@property (nonatomic, strong) SAMessageDTO *messageDTO;                ///<
@property (nonatomic, strong) SAAppVersionViewModel *versionCtrl;      ///< 版本控制器
/// 消息中心VC下标
@property (nonatomic, assign) NSUInteger messageCenterVCIndex;

@end


@implementation SATabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.messageCenterVCIndex = 99;

    self.customTabBar.translucent = NO;

    // iOS 13 beta 的 bug
    if (@available(iOS 10.0, *)) {
        self.customTabBar.unselectedItemTintColor = UIColor.lightGrayColor;
    }

    // 替换系统 tabBar
    [self setValue:self.customTabBar forKey:@"tabBar"];

    [self registerNotifications];

    [SAMessageManager.share addListener:self];
}

- (void)dealloc {
    [self resignNotifications];
    [SAMessageManager.share removeListener:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 视图加载完毕，可以开始展示TabBar引导提示
    [NSNotificationCenter.defaultCenter postNotificationName:kNotificationNameSuccessGetAppTabBarConfigList object:nil];
    [self checkNewVersion];
    [self getUnreadMessageCount];
}

#pragma mark - private methods
- (void)registerNotifications {
    // 监听语言变化
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(hd_languageDidChanged) name:kNotificationNameLanguageChanged object:nil];
    // 监听获取导航栏配置成功
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(appSuccessGetAppTabBarConfigList) name:kNotificationNameSuccessGetAppTabBarConfigList object:nil];
    // 监听DeviceToken变化
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didRegisterRemoteNotificationToken:) name:kNotificationNameReceiveRegistrationToken object:nil];
    // 登录成功也更新推送token
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(loginSuccessHandler) name:kNotificationNameLoginSuccess object:nil];
    // 监听远程配置更新
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(bindImRemoteNotificationToken:) name:kNotificationNameIMLoginSuccess object:nil];
    // 用户登出
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(userLogoutHandler) name:kNotificationNameUserLogout object:nil];
    // voip token 变化
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didRegisterVoipToken:) name:kNotificationNameVoipTokenChanged object:nil];

    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector((locationDidChanged:)) name:kNotificationNameLocationChanged object:nil];

    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didRegisterHelloPlatDeviceToken:) name:kNotificationNameDidReceiveHelloPlatformDeviceToken object:nil];
}

- (void)resignNotifications {
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameLanguageChanged object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameSuccessGetAppTabBarConfigList object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameReceiveRegistrationToken object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameLoginSuccess object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameIMLoginSuccess object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameUserLogout object:nil];

    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameVoipTokenChanged object:nil];

    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameLocationChanged object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationNameDidReceiveHelloPlatformDeviceToken object:nil];
}

- (NSArray<SATabBarItemConfig *> *)reloadTabBarData {
    // 取出配置
    NSArray<SATabBarItemConfig *> *oldList = [SATabBarController mainTabBarConfigArray];

    // 更新SACacheManager
    [self.customTabBar addCustomButtonsWithConfigArray:oldList];

    return oldList;
}
// 检查是否有可更新的版本
- (void)checkNewVersion {
    [self.versionCtrl getAppVersionInfoSuccess:^(SAAppVersionInfoRspModel *_Nonnull rspModel) {
        if (HDIsStringNotEmpty(rspModel.publicVersion)) {
            SAVersionAlertViewConfig *config = SAVersionAlertViewConfig.new;
            config.versionId = rspModel.versionId;
            config.updateInfo = rspModel.versionInfo;
            config.updateVersion = rspModel.publicVersion;
            config.updateModel = rspModel.updateModel;
            config.packageLink = rspModel.packageLink;
            if ([SAVersionAlertManager versionShouldAlert:config]) {
                SAVersionBaseAlertView *alertView = [SAVersionAlertManager alertViewWithConfig:config];
                alertView.didDismissHandler = ^(HDActionAlertView *_Nonnull alertView) {

                };
                [alertView show];
            }
        }
    } failure:nil];
}

- (void)getUnreadMessageCount {
    if ([SAUser hasSignedIn]) {
        [SAMessageManager.share getUnreadMessageCount:nil];
    }
}

#pragma mark - public methods
+ (NSArray<SATabBarItemConfig *> *)mainTabBarConfigArray {
    // 从本地获取配置
    NSArray<SATabBarItemConfig *> *cacheList = [SACacheManager.shared objectForKey:kCacheKeyAppTabBarConfigList type:SACacheTypeDocumentPublic relyLanguage:YES];
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

    if (cacheList.count != list.count) {
        // 缓存有问题，为防止意外，直接用默认数据
        return [SATabBarController defaultTabBarConfigArray];
    }


    // 排序
    list = [list sortedArrayWithOptions:NSSortStable usingComparator:^NSComparisonResult(SATabBarItemConfig *_Nonnull obj1, SATabBarItemConfig *_Nonnull obj2) {
        return obj1.index > obj2.index ? NSOrderedDescending : NSOrderedAscending;
    }];
    // 取前五个
    list = [list subarrayWithRange:NSMakeRange(0, 5)];

    if (!list || list.count <= 0) {
        return [SATabBarController defaultTabBarConfigArray];
    } else {
        return list;
    }
}

+ (NSArray<SATabBarItemConfig *> *)defaultTabBarConfigArray {
    NSMutableArray<SATabBarItemConfig *> *res = [NSMutableArray arrayWithCapacity:4];
    SATabBarItemConfig *config = SATabBarItemConfig.new;
    config.index = 1;
    // 设置本地配置
    SAInternationalizationModel *languageModel = [SAInternationalizationModel modelWithInternationalKey:@"tabbar_home" value:@"首页" table:nil];
    config.loadPageName = @"WNHomeViewController";
    config.startupParams = @{@"pageLabel": @"WOWNOW_HOME3.0_O2O"};
    [config setLocalName:languageModel localImage:@"ic-home-normal" selectedLocalImage:@"ic-home-selected"];
    [config setTitleColor:HDAppTheme.color.G1 selectedTitleColor:HDAppTheme.color.sa_C1];
    [res addObject:config];

    config = SATabBarItemConfig.new;
    config.index = 2;
    // 设置本地配置
    languageModel = [SAInternationalizationModel modelWithInternationalKey:@"order" value:@"订单" table:nil];
    config.loadPageName = @"SAOrderViewController";
    config.startupParams = @{@"hideBackButton": @"1"};
    [config setLocalName:languageModel localImage:@"ic-order-normal" selectedLocalImage:@"ic-order-selected"];
    [config setTitleColor:HDAppTheme.color.G1 selectedTitleColor:HDAppTheme.color.sa_C1];
    [res addObject:config];

    config = SATabBarItemConfig.new;
    config.index = 3;
    // 设置本地配置
    languageModel = [SAInternationalizationModel modelWithInternationalKey:@"discover" value:@"发现" table:nil];
    config.loadPageName = @"SACMSWaterfallViewController";
    config.startupParams = @{@"pageLabel": @"DISCOVERY_PAGE"};
    [config setLocalName:languageModel localImage:@"ic-discover-normal" selectedLocalImage:@"ic-discover-selected"];
    [config setTitleColor:HDAppTheme.color.G1 selectedTitleColor:HDAppTheme.color.sa_C1];
    [res addObject:config];

    config = SATabBarItemConfig.new;
    config.index = 4;
    // 设置本地配置
    languageModel = [SAInternationalizationModel modelWithInternationalKey:@"messages" value:@"消息" table:nil];
    config.loadPageName = @"SANewMessageCenterViewController";
    config.startupParams = @{};
    [config setLocalName:languageModel localImage:@"ic-message-normal" selectedLocalImage:@"ic-message-selected"];
    [config setTitleColor:HDAppTheme.color.G1 selectedTitleColor:HDAppTheme.color.sa_C1];
    [res addObject:config];

    config = SATabBarItemConfig.new;
    config.index = 5;
    // 设置本地配置
    languageModel = [SAInternationalizationModel modelWithInternationalKey:@"mine" value:@"我的" table:nil];
    config.loadPageName = @"SAMineViewController";
    config.startupParams = @{@"hideBackButton": @"1"};
    [config setLocalName:languageModel localImage:@"ic-mine-normal" selectedLocalImage:@"ic-mine-selected"];
    [config setTitleColor:HDAppTheme.color.G1 selectedTitleColor:HDAppTheme.color.sa_C1];
    [res addObject:config];

    return res;
}

#pragma mark - Notification
- (void)hd_languageDidChanged {
    for (SATabBarButton *button in self.customTabBar.buttons) {
        NSString *title = HDIsStringNotEmpty(button.config.name.desc) ? button.config.name.desc : button.config.localName.desc;
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateHighlighted];
        [button setTitle:button.config.hideTextWhenSelected ? @"" : title forState:UIControlStateSelected];
    }

    [self didRegisterRemoteNotificationToken:nil];
    [self didRegisterVoipToken:nil];
    [self didRegisterHelloPlatDeviceToken:nil];

    [KSInstMsgManager.share setCurrentLanguage:[SAMultiLanguageManager currentLanguage]];
    // 用户语言切换的时候记录用户当前语言
    [SATalkingData SATrackUserLanguage];
}

- (void)appSuccessGetAppTabBarConfigList {
    NSArray<SATabBarItemConfig *> *oldList = [SATabBarController mainTabBarConfigArray];

    // 展示新功能提示
    // 节流的同时做到延时
    dispatch_throttle(1, @"superapp.showTabBarGuideEventKey", ^{
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
            [SACacheManager.shared setObject:oldList forKey:kCacheKeyAppTabBarConfigList type:SACacheTypeDocumentPublic relyLanguage:YES];

            // 刷新
            [strongSelf reloadTabBarData];
        } withKey:@"superapp.showTabBarGuideEventKey"];
    });
}

- (void)didRegisterRemoteNotificationToken:(NSNotification *)notification {
    if (![SAUser hasSignedIn]) {
        HDLog(@"⚠️⚠️⚠️：用户未登录，不更新Apns token");
        return;
    }

    NSString *deviceToken;
    if (notification) {
        deviceToken = [notification.userInfo valueForKey:@"fcmToken"];
        NSString *cacheDeviceToken = [SACacheManager.shared objectForKey:[NSString stringWithFormat:@"Apns_DeviceToken_%@", SAUser.shared.operatorNo] type:SACacheTypeCacheNotPublic];
        if (HDIsStringNotEmpty(cacheDeviceToken) && [cacheDeviceToken isEqualToString:deviceToken]) {
            HDLog(@"⚠️⚠️⚠️：本地 apns device token 一致，不再上送");
            return;
        }

    } else {
        // 切换环境触发
        NSString *cacheDeviceToken = [SACacheManager.shared objectForKey:kCacheKeyFCMRemoteNotifitionToken type:SACacheTypeCachePublic];
        if (HDIsStringEmpty(cacheDeviceToken)) {
            HDLog(@"⚠️⚠️⚠️：本地切换语言触发的通知，缓存没有Apns token，不上送");
            return;
        }
        deviceToken = [cacheDeviceToken copy];
    }

    [self.remoteNotifyVM registerUserRemoteNofityDeviceToken:deviceToken channel:SAPushChannelAPNS success:^{
        HDLog(@"远程通知设备绑定或更新成功!");
        SAUser.shared.deviceToken = deviceToken;
        [SAUser.shared save];
        // 缓存在本地，只缓存24小时，确保每天都能上传一次
        [SACacheManager.shared setObject:deviceToken forKey:[NSString stringWithFormat:@"Apns_DeviceToken_%@", SAUser.shared.operatorNo] duration:60 * 60 * 24 type:SACacheTypeCacheNotPublic];
    } failure:nil];
    // 更新IM 绑定的推送token
    //    [self bindImRemoteNotificationToken:notification];
}

- (void)didRegisterHelloPlatDeviceToken:(NSNotification *_Nullable)notification {
    if (![SAUser hasSignedIn]) {
        HDLog(@"⚠️⚠️⚠️：用户未登录，不更新Hello token");
        return;
    }
    NSString *deviceToken;
    if (notification) {
        deviceToken = [notification.userInfo valueForKey:@"deviceToken"];
        NSString *cacheDeviceToken = [SACacheManager.shared objectForKey:[NSString stringWithFormat:@"Hello_DeviceToken_%@", SAUser.shared.operatorNo] type:SACacheTypeCacheNotPublic];
        if (HDIsStringNotEmpty(cacheDeviceToken) && [cacheDeviceToken isEqualToString:deviceToken]) {
            //            HDLog(@"缓存:%@", cacheDeviceToken);
            //            HDLog(@"最新:%@", deviceToken);
            HDLog(@"⚠️⚠️⚠️：本地 hello device token 一致，不再上送");
            return;
        }

    } else {
        // 切换环境触发
        NSString *cacheDeviceToken = [SACacheManager.shared objectForKey:kCacheKeyHelloPlatformDeviceToken type:SACacheTypeCachePublic];
        if (HDIsStringEmpty(cacheDeviceToken)) {
            HDLog(@"⚠️⚠️⚠️：本地切换语言触发的通知，缓存没有Hello token，不上送");
            return;
        }
        deviceToken = [cacheDeviceToken copy];
    }

    [self.remoteNotifyVM registerUserRemoteNofityDeviceToken:deviceToken channel:SAPushChannelHello success:^{
        HDLog(@"⚠️⚠️⚠️：上送 hello device token 成功，存入缓存!");
        // 存入私有空间
        [SACacheManager.shared setObject:deviceToken forKey:[NSString stringWithFormat:@"Hello_DeviceToken_%@", SAUser.shared.operatorNo] duration:60 * 60 * 24 type:SACacheTypeCacheNotPublic];
    } failure:nil];
}

- (void)bindImRemoteNotificationToken:(NSNotification *)notification {
    //    NSString *flag = [SACacheManager.shared objectForKey:@"fix_IM_Bug" type:SACacheTypeCachePublic];
    //    if (HDIsObjectNil(flag)) {
    //        // 因为imbug，强制删一次会话
    //        HDLog(@"修复imbug，强制删掉本地缓存");
    //        [KSInstMsgManager.share deleteConversactionWithConversactionId:nil];
    //
    //        [SACacheManager.shared setObject:@"fixed" forKey:@"fix_IM_Bug" type:SACacheTypeCachePublic];
    //    }

    // OpenIM已经不需要推送
    return;
}

- (void)didRegisterVoipToken:(NSNotification *)notification {
    if (!SAUser.hasSignedIn) {
        HDLog(@"⚠️⚠️⚠️：用户未登录，不更新Voip token");
        return;
    }

    NSString *deviceToken;
    if (notification) {
        deviceToken = [notification.userInfo valueForKey:@"voipToken"];
        NSString *cacheToken = [SACacheManager.shared objectForKey:[NSString stringWithFormat:@"VoipDeviceToken_%@", SAUser.shared.operatorNo] type:SACacheTypeCacheNotPublic];
        if (HDIsStringNotEmpty(cacheToken) && [cacheToken isEqualToString:deviceToken]) {
            HDLog(@"⚠️⚠️⚠️：本地 Voip device token 一致，不再上送");
            return;
        }
    } else {
        // 登录 or 切换语言触发
        NSString *token = [SACacheManager.shared objectForKey:kCacheKeyAppleVoipToken type:SACacheTypeCachePublic];
        // 如果为空，就是本地没存储 token
        if (HDIsStringEmpty(token)) {
            HDLog(@"⚠️⚠️⚠️：本地未存储 token ，APNS未返回Voip DT，直接返回等待APNS通知!");
            return;
        }
        deviceToken = [token copy];
    }


    [self.remoteNotifyVM registerUserRemoteNofityDeviceToken:deviceToken channel:SAPushChannelVOIP success:^{
        HDLog(@"⚠️⚠️⚠️：上送 Voip device token 成功，存入缓存!");
        // 存入私有空间
        [SACacheManager.shared setObject:deviceToken forKey:[NSString stringWithFormat:@"VoipDeviceToken_%@", SAUser.shared.operatorNo] duration:60 * 60 * 24 type:SACacheTypeCacheNotPublic];
    } failure:nil];
}

- (void)loginSuccessHandler {
    HDLog(@"登陆成功");

    [self didRegisterRemoteNotificationToken:nil];
    [self didRegisterVoipToken:nil];

    [self getUnreadMessageCount];
    // 通知H5容器刷新
    [NSNotificationCenter.defaultCenter postNotificationName:kWebViewHostNotificationReload object:nil];


    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SAMarketingAlertViewPresenter showMarketingAlertAboutUserLoginActivity];
    });
    

    NSString *helloSwitch = [SAAppSwitchManager.shared switchForKey:SAAppSwitchHelloPlatform];
#ifndef DEBUG
    if (HDIsStringEmpty(helloSwitch) || [[helloSwitch lowercaseString] isEqualToString:@"off"]) {
        return;
    }
#endif
    // 登陆成功，登陆传声筒
    [[WNHelloClient sharedClient] signInWithUserId:[SAUser.shared operatorNo]];
}

- (void)userLogoutHandler {
    UIApplication.sharedApplication.applicationIconBadgeNumber = 0;
    NSUInteger index = [self getIndexOfMessage];
    if (index < self.viewControllers.count) {
        [self.customTabBar updateBadgeValue:@"" atIndex:index];
    }
    //清理电商单例数据
    [TNGlobalData clean];
    [WNHelloClient.sharedClient signOutWithUserId:@""];
    [KSInstMsgManager.share signoutWithCompletion:nil];
}

- (void)locationDidChanged:(NSNotification *)notification {
}

#pragma mark - SAMessageManagerDelegate
- (void)unreadMessageCountChanged:(NSUInteger)count details:(NSDictionary<SAAppInnerMessageType, NSNumber *> *)details {
    NSUInteger index = [self getIndexOfMessage];
    if (index < self.viewControllers.count) {
        if (count == 0) {
            [self.customTabBar updateBadgeValue:@"" atIndex:index];
            UIApplication.sharedApplication.applicationIconBadgeNumber = 0;
        } else {
            [self.customTabBar updateBadgeValue:count > 99 ? @"99+" : [NSString stringWithFormat:@"%ld", count] atIndex:index];
            UIApplication.sharedApplication.applicationIconBadgeNumber = count;
        }
    }
}

- (NSUInteger)getIndexOfMessage {
    if (self.messageCenterVCIndex == 99) {
        __block NSUInteger index = 99;
        [self.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            UIViewController *trueVC = obj;
            if ([obj isKindOfClass:UINavigationController.class]) {
                UINavigationController *nav = obj;
                trueVC = nav.hd_rootViewController;
            }
            if ([@"SANewMessageCenterViewController" isEqualToString:NSStringFromClass(trueVC.class)] || [@"SAMessageCenterViewController" isEqualToString:NSStringFromClass(trueVC.class)] ||
                [@"SAMessagesViewController" isEqualToString:NSStringFromClass(trueVC.class)]) {
                index = idx;
                *stop = YES;
            }
        }];
        self.messageCenterVCIndex = index;
    }
    return self.messageCenterVCIndex;
}

#pragma mark - SATabBarDelegate
- (void)tabBar:(SATabBar *)tabBar didSelectButton:(SATabBarButton *)button {
    if (self.selectedIndex != NSNotFound && button.animatedImageView) {
        [button addCustomAnimation:[CAAnimation scaleAnimationWithDuration:0.2 repeatCount:1 fromValue:@1 toValue:@0.7] forKey:nil];
    }

    if (self.selectedIndex == tabBar.selectedIndex) {
        if (self.repeatSelectedBlock) {
            self.repeatSelectedBlock(tabBar.selectedIndex);
        }
        return;
    }

    if (self.selectedIndex != NSNotFound) {
        // 增加转场动画
        [self addTransitionAnimationForWillSelectIndex:tabBar.selectedIndex duration:0.3];
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
- (SATabBar *)customTabBar {
    if (!_customTabBar) {
        _customTabBar = [SATabBar new];
        _customTabBar.customTarBarDelegate = self;
    }
    return _customTabBar;
}

- (SARemoteNotifyViewModel *)remoteNotifyVM {
    if (!_remoteNotifyVM) {
        _remoteNotifyVM = [SARemoteNotifyViewModel new];
    }
    return _remoteNotifyVM;
}

- (SAMessageDTO *)messageDTO {
    if (!_messageDTO) {
        _messageDTO = SAMessageDTO.new;
    }
    return _messageDTO;
}

- (SAAppVersionViewModel *)versionCtrl {
    return _versionCtrl ?: ({ _versionCtrl = SAAppVersionViewModel.new; });
}

@end
