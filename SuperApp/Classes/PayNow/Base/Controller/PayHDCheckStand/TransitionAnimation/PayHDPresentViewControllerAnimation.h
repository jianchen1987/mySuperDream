//
//  PayHDPresentViewControllerAnimation.h
//  customer
//
//  Created by VanJay on 2019/5/15.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/** 过渡动画类型 */
typedef NS_ENUM(NSUInteger, PayHDPresentVCAnimationStyle) {
    PayHDPresentVCAnimationPresentingStyleFromBottom = 1 << 0,             ///< 默认，由底部向上弹出
    PayHDPresentVCAnimationPresentingStyleFromBottomBackVCZoomIn = 1 << 1, ///< 被弹出界面由底部向上弹出，弹出界面缩小
    PayHDPresentVCAnimationPresentingStyleNone = 1 << 2,                   ///< 无任何动画

    PayHDPresentVCAnimationDismissStyleToBottom = 2 << 0,              ///< 默认，向下弹出消失
    PayHDPresentVCAnimationDismissStyleToBottomBackVCZoomOut = 2 << 1, ///< 被弹出界面向下弹出消失，弹出界面还原
    PayHDPresentVCAnimationDismissStyleNone = 2 << 2                   ///< 无任何动画
};

UIKIT_EXTERN CGFloat kPayHDPresentDefaultTransitionDuration;

NS_ASSUME_NONNULL_BEGIN


@interface PayHDPresentViewControllerAnimation : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) PayHDPresentVCAnimationStyle presentingStyle;
@property (nonatomic, assign) PayHDPresentVCAnimationStyle dismissStyle;

@property (nonatomic, copy) void (^tappedShadowHandler)(void); ///< 点击了阴影
@end

NS_ASSUME_NONNULL_END
