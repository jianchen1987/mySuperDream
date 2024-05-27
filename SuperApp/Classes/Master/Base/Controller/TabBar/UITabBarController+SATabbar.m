

//
//  UITabBarController+SATabbar.m
//  SuperApp
//
//  Created by VanJay on 2020/7/12.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATabBar.h"
#import "UITabBarController+SATabbar.h"


@implementation UITabBarController (SATabbar)

- (void)updateBadgeValue:(NSString *)badgeValue atIndex:(NSUInteger)index {
    SATabBar *tabBar = [self valueForKey:@"tabBar"];
    if (![tabBar isKindOfClass:SATabBar.class])
        return;

    [tabBar updateBadgeValue:badgeValue atIndex:index];
}

- (void)updateBadgeColor:(UIColor *)badgeColor atIndex:(NSUInteger)index {
    SATabBar *tabBar = [self valueForKey:@"tabBar"];
    if (![tabBar isKindOfClass:SATabBar.class])
        return;

    [tabBar updateBadgeColor:badgeColor atIndex:index];
}

- (void)updateBackgroundColor:(UIColor *)backgroundColor atIndex:(NSUInteger)index {
    SATabBar *tabBar = [self valueForKey:@"tabBar"];
    if (![tabBar isKindOfClass:SATabBar.class])
        return;

    [tabBar updateBackgroundColor:backgroundColor atIndex:index];
}
@end
