//
//  TNTabBarViewController.h
//  SuperApp
//
//  Created by seeu on 2020/6/18.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNMultiLanguageManager.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SATabBarItemConfig;


@interface TNTabBarViewController : UITabBarController
/** 选中了 index 回调 */
@property (nonatomic, copy) void (^selectedIndexBlock)(NSUInteger index);

/// 导航栏配置
+ (NSArray<SATabBarItemConfig *> *)mainTabBarConfigArray;
/// 默认配置
+ (NSArray<SATabBarItemConfig *> *)defaultTabBarConfigArray;
@end

NS_ASSUME_NONNULL_END
