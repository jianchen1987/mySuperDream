//
//  SAShortcutManager.m
//  SuperApp
//
//  Created by VanJay on 2020/3/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAShortcutManager.h"
#import "SAAppDelegate.h"
#import "SAMultiLanguageManager.h"
#import "SAShortcutItemConfig.h"
#import "SAWindowManager.h"
#import <HDKitCore/HDCommonDefines.h>
#import <HDKitCore/NSArray+HDKitCore.h>


@implementation SAShortcutManager

/** 配置桌面快捷入口 */
+ (void)configureShortCutItems {
    if (@available(iOS 9.0, *)) {
        SAAppDelegate *appDelegate = (SAAppDelegate *)UIApplication.sharedApplication.delegate;
        if (appDelegate.window.rootViewController.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable || [HDHelper isCurrentSystemAtLeastVersion:@"13"]) {
            HDLog(@"3D Touch 可用 或 系统版本高于 13");
            [self _configureShortCutItems];
            // 监听语言改变
            [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(languageDidChanged) name:kNotificationNameLanguageChanged object:nil];
        } else {
            HDLog(@"3D Touch 不可用且系统版本低于 13");
        }
    }
}

+ (void)_configureShortCutItems {
    if (@available(iOS 9.0, *)) {
        NSMutableArray<SAShortcutItemConfig *> *shortCutItemsConfigs = [NSMutableArray arrayWithCapacity:4];

        SAShortcutItemConfig *config;
        SAInternationalizationModel *ilModel;

        ilModel = [SAInternationalizationModel modelWithInternationalKey:@"BUTTON_TITLE_SCAN" value:@"扫一扫" table:@"Buttons"];
        config = [SAShortcutItemConfig configWithType:SAShortcutItemConfigTypeScan icon:@"short_cut_scan" internationalizationModel:ilModel routePath:@"SuperApp://YumNow/scanCodeViewController"];
        [shortCutItemsConfigs addObject:config];

        ilModel = [SAInternationalizationModel modelWithInternationalKey:@"BUTTON_TITLE_Delivery" value:@"外卖" table:@"Buttons"];
        config = [SAShortcutItemConfig configWithType:SAShortcutItemConfigTypeCollection icon:@"short_cut_scan" internationalizationModel:ilModel
                                            routePath:@"SuperApp://YumNow/transferViewController"];
        [shortCutItemsConfigs addObject:config];

        ilModel = [SAInternationalizationModel modelWithInternationalKey:@"BUTTON_TITLE_SCAN" value:@"收款" table:@"Buttons"];
        config = [SAShortcutItemConfig configWithType:SAShortcutItemConfigTypeTransfer icon:@"short_cut_scan" internationalizationModel:ilModel
                                            routePath:@"SuperApp://YumNow/collectionViewController"];
        [shortCutItemsConfigs addObject:config];

        ilModel = [SAInternationalizationModel modelWithInternationalKey:@"BUTTON_TITLE_SCAN" value:@"地图" table:@"Buttons"];
        config = [SAShortcutItemConfig configWithType:SAShortcutItemConfigTypeMap icon:@"short_cut_scan" internationalizationModel:ilModel routePath:@"SuperApp://YumNow/mapViewController"];
        [shortCutItemsConfigs addObject:config];

        NSArray<UIApplicationShortcutItem *> *items = [shortCutItemsConfigs mapObjectsUsingBlock:^UIApplicationShortcutItem *_Nonnull(SAShortcutItemConfig *_Nonnull obj, NSUInteger idx) {
            UIApplicationShortcutIcon *icon = [UIApplicationShortcutIcon iconWithTemplateImageName:obj.icon];
            UIApplicationShortcutItem *item = [[UIApplicationShortcutItem alloc] initWithType:obj.type localizedTitle:obj.internationalizationModel.desc localizedSubtitle:nil icon:icon
                                                                                     userInfo:@{@"routeURL": obj.routePath, @"ilModel": obj.internationalizationModel.yy_modelToJSONObject}];
            return item;
        }];

        [UIApplication sharedApplication].shortcutItems = items;
    }
}

+ (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler API_AVAILABLE(ios(9.0)) {
    NSString *path = (NSString *)shortcutItem.userInfo[@"routeURL"];
    if (HDIsStringNotEmpty(path)) {
        HDLog(@"桌面快捷入口进入 APP");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SAWindowManager openUrl:path withParameters:nil];
        });
    }
}

#pragma mark - 通知
+ (void)languageDidChanged {
    NSArray<UIApplicationShortcutItem *> *shortcutItems =
        [[UIApplication sharedApplication].shortcutItems mapObjectsUsingBlock:^UIApplicationShortcutItem *_Nonnull(UIApplicationShortcutItem *_Nonnull obj, NSUInteger idx) {
            SAInternationalizationModel *ilModel = [SAInternationalizationModel yy_modelWithJSON:obj.userInfo[@"ilModel"]];

            UIApplicationShortcutItem *item = [[UIApplicationShortcutItem alloc] initWithType:obj.type localizedTitle:ilModel.desc localizedSubtitle:nil icon:obj.icon userInfo:obj.userInfo];
            return item;
        }];
    [UIApplication sharedApplication].shortcutItems = shortcutItems;
}
@end
