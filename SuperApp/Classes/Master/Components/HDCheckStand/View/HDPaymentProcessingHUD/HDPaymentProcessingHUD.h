//
//  HDPaymentProcessingHUD.h
//  SuperApp
//
//  Created by VanJay on 2019/9/16.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface HDPaymentProcessingHUD : UIView

/// 显示 loading
/// @param view  目标 View
/// @param offset Y 方向偏移
+ (HDPaymentProcessingHUD *)showLoadingIn:(UIView *)view offset:(CGFloat)offset;

/// 加载完成动画
/// @param completion 动画完成
- (void)showSuccessCompletion:(void (^__nullable)(void))completion;

/// 隐藏进度 View
/// @param view 隐藏的进度 View
+ (HDPaymentProcessingHUD *)hideFor:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
