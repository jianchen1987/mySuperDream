//
//  UITabBarItem+SATabBar.h
//  SuperApp
//
//  Created by VanJay on 2020/3/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SATabBarItemConfig;

NS_ASSUME_NONNULL_BEGIN


@interface UITabBarItem (SATabBar)
/// 动态配置
@property (nonatomic, strong) SATabBarItemConfig *hd_config;
@end

NS_ASSUME_NONNULL_END
