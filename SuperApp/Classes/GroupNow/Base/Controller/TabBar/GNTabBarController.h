//
//  GNTabBarController.h
//  SuperApp
//
//  Created by wmz on 2021/5/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@class SATabBarItemConfig;


@interface GNTabBarController : UITabBarController
/** 选中了 index 回调 */
@property (nonatomic, copy) void (^selectedIndexBlock)(NSUInteger index);
/**选中状态下  再次 选中了 index 回调 */
@property (nonatomic, copy) void (^repeatSelectedBlock)(NSUInteger index);
/// 导航栏配置
+ (NSArray<SATabBarItemConfig *> *)mainTabBarConfigArray;
@end

NS_ASSUME_NONNULL_END
