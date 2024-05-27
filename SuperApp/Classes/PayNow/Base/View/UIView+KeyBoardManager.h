//
//  UIView+KeyBoardManager.h
//  customer
//
//  Created by VanJay on 2019/4/15.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface UIView (KeyBoardManager)

/**
 设置是否跟随键盘上升

 @param enable 是否开启跟随键盘向上弹起
 @param margin 底部和键盘顶部间距
 @param refView 最大到其底部的参考 view
 */
- (void)setFollowKeyBoardConfigEnable:(BOOL)enable margin:(CGFloat)margin refView:(UIView *__nullable)refView;

/**
 设置是否跟随键盘上升

 @param enable 是否开启跟随键盘向上弹起
 @param margin 底部和键盘顶部间距
 @param refView 最大到其底部的参考 view
 @param distanceToRefViewBottom 距离参考 view最小高度，默认值10
 */
- (void)setFollowKeyBoardConfigEnable:(BOOL)enable margin:(CGFloat)margin refView:(UIView *__nullable)refView distanceToRefViewBottom:(CGFloat)distanceToRefViewBottom;

/**
 设置跟随键盘上升，不管挡没挡住

 @param distance 移动距离
 */
- (void)setFollowKeyBoardConfigEnable:(BOOL)enable distance:(CGFloat)distance;
@end

NS_ASSUME_NONNULL_END
