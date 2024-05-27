//
//  UIView+FrameChangedHandler.h
//  SuperApp
//
//  Created by VanJay on 2020/4/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^FrameChangedHandler)(CGRect frame);


@interface UIView (FrameChangedHandler)

/// frame 变化触发 hook
/// @param handler 回调
- (void)hd_setFrameChangedHandler:(FrameChangedHandler)handler;

/// 移除 frame 变化触发 hook
- (void)hd_removeFrameChangedHandler;

/// 第一次 frame 不为0的回调（只会触发一次），如果本身 frame 就不为0，会直接触发回调
/// @param handler 回调
- (void)hd_setFrameNonZeroOnceHandler:(FrameChangedHandler)handler;

@end

NS_ASSUME_NONNULL_END
