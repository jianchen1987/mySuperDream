//
//  SAAppDelegate+PushService.h
//  SuperApp
//
//  Created by VanJay on 2020/3/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAAppDelegate.h"
#import <UserNotifications/UserNotifications.h>

NS_ASSUME_NONNULL_BEGIN


@interface SAAppDelegate (PushService)

- (void)initRemotePush:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
/// 处理消息推送
/// - Parameter userInfo: 数据模型
- (void)proccessNotification:(NSDictionary *)userInfo;

@end

NS_ASSUME_NONNULL_END
