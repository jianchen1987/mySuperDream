//
//  UITabBarController+SATabbar.h
//  SuperApp
//
//  Created by VanJay on 2020/7/12.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface UITabBarController (SATabbar)
/// 更新角标
/// @param badgeValue 角标内容
/// @param index 位置
- (void)updateBadgeValue:(NSString *)badgeValue atIndex:(NSUInteger)index;

/// 更新角标颜色
/// @param badgeColor 颜色
/// @param index 位置
- (void)updateBadgeColor:(UIColor *)badgeColor atIndex:(NSUInteger)index;

/// 更新角标背景颜色
/// @param backgroundColor 背景颜色
/// @param index 位置
- (void)updateBackgroundColor:(UIColor *)backgroundColor atIndex:(NSUInteger)index;
@end

NS_ASSUME_NONNULL_END
