//
//  SAShortcutManager.h
//  SuperApp
//
//  Created by VanJay on 2020/3/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

@import Foundation;
@import UIKit;

NS_ASSUME_NONNULL_BEGIN


@interface SAShortcutManager : NSObject
/** 配置桌面快捷入口 */
+ (void)configureShortCutItems;

+ (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler API_AVAILABLE(ios(9.0));
@end

NS_ASSUME_NONNULL_END
