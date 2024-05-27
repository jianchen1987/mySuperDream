//
//  SATabBarController.h
//  SuperApp
//
//  Created by VanJay on 2020/3/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SATabBarItemConfig;


@interface SATabBarController : UITabBarController
/** 选中了 index 回调 */
@property (nonatomic, copy) void (^selectedIndexBlock)(NSUInteger index);

/// 选中状态下再次选择
@property (nonatomic, copy) void (^repeatSelectedBlock)(NSUInteger index);

/// 导航栏配置
+ (NSArray<SATabBarItemConfig *> *)mainTabBarConfigArray;
@end

NS_ASSUME_NONNULL_END
