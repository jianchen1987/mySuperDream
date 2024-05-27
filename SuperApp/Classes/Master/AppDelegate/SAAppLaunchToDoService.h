//
//  SAAppLaunchToDoService.h
//  SuperApp
//
//  Created by VanJay on 2020/3/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface SAAppLaunchToDoService : NSObject

+ (instancetype)sharedInstance;

/** 执行所有待办事件 */
- (void)performAll;

/** 首次打开APP，选择完语言后执行的事件 */
- (void)performAllAfterChooseLanguage;

/** 查询导航栏配置 */
- (void)queryAppTabBarConfigList;

/** 查询外卖金刚区配置 */
//- (void)queryAppDeliveryHomeDynamicFunctionList;

/** 查询外卖导航栏配置 */
- (void)queryAppDeliveryTabBarConfigList;

/** 查询电商金刚区配置 */
- (void)queryAppTinhNowHomeDynamicFunctionList;

/** 查询电商导航栏配置 */
- (void)queryAppTinhNowTabBarConfigList;

/** 查询H5容器访问白名单 */
//- (void)queryH5ContainerWhiteList;

/** 解析WOW口令 */
- (void)parsingWOWToken;

/** APP后台进入前台 */
- (void)enterForeground;
@end

NS_ASSUME_NONNULL_END
