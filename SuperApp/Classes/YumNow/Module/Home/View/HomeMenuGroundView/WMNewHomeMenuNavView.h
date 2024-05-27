//
//  WMNewHomeMenuNavView.h
//  SuperApp
//
//  Created by Tia on 2023/7/19.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMNewHomeMenuNavView : SAView
@property (nonatomic, assign) BOOL hideBackButton; ///< 隐藏返回按钮

/// 根据偏移变化 UI
/// @param criticalValue 临界值
/// @param offsetY 偏移 Y 方向大小
/// @param completion 变化回调
- (void)refreshUIWithCriticalValue:(CGFloat)criticalValue offsetY:(CGFloat)offsetY completion:(void (^)(CGRect, CGFloat))completion;

@end

NS_ASSUME_NONNULL_END
