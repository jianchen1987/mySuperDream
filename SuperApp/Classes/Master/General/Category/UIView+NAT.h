//
//  UIView+NAT.h
//  SuperApp
//
//  Created by VanJay on 2020/3/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface UIView (NAT)
/** 显示 loading */
- (void)showloading;

/** 显示 loading 和 文字，支持属性文字 */
- (void)showloadingText:(id)text;

/** 关闭 loading */
- (void)dismissLoading;

- (void)dismissLoadingAfterDelay:(NSTimeInterval)delay;

@end

NS_ASSUME_NONNULL_END
