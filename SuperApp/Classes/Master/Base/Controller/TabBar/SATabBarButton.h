//
//  SATabBarButton.h
//  SuperApp
//
//  Created by VanJay on 2020/3/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATabBarItemConfig.h"
#import <SDWebImage/SDAnimatedImageView.h>
#import <UIKit/UIButton.h>

NS_ASSUME_NONNULL_BEGIN


@interface SATabBarButton : UIButton
@property (nonatomic, strong, readonly) SDAnimatedImageView *animatedImageView; ///< imageView，用于外部获取
@property (nonatomic, strong) SATabBarItemConfig *config;                       ///< 动态配置模型

- (void)updateBadgeValue:(NSString *)badgeValue;
- (void)updateBadgeColor:(UIColor *)badgeColor;
- (void)updateBackgroundColor:(UIColor *)backgroundColor;

- (void)addCustomAnimation:(CAAnimation *)anim forKey:(nullable NSString *)key;

@end

NS_ASSUME_NONNULL_END
