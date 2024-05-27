//
//  SATabBar.h
//  SuperApp
//
//  Created by VanJay on 2020/3/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATabBarButton.h"
#import <UIKit/UITabBar.h>

@class SATabBar;

NS_ASSUME_NONNULL_BEGIN

@protocol SATabBarDelegate <NSObject>

@optional
- (void)tabBar:(SATabBar *)tabBar didSelectButton:(SATabBarButton *)button;
/// 是否需要拦截点击
- (BOOL)tabBar:(SATabBar *)tabBar shouldInterceptClickAtIndex:(NSInteger)index;
@end


@interface SATabBar : UITabBar
@property (nonatomic, weak) id<SATabBarDelegate> customTarBarDelegate;    ///< 代理
@property (nonatomic, assign) NSInteger selectedIndex;                    ///< 选中索引
@property (nonatomic, copy, readonly) NSArray<SATabBarButton *> *buttons; ///< 所有按钮
@property (nonatomic, copy, readonly) NSArray<SATabBarButton *> *shouldShowGuideViewArray;
/// 是否是新的tabBar  默认都是新的  用于记录是否被重置了tabBar
@property (nonatomic, assign) BOOL isNewTabBar;
/// 为 tabBar 增加自定义按钮
/// @param configArray 配置数组
- (void)addCustomButtonsWithConfigArray:(NSArray<SATabBarItemConfig *> *)configArray;

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
