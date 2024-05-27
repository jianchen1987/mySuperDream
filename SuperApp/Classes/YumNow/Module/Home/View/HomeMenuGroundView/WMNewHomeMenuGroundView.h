//
//  WMNewHomeMenuGroundView.h
//  SuperApp
//
//  Created by Tia on 2023/7/19.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMNewHomeMenuGroundView : SAView
/// scrollView 滚动至输入框完全显示的最大偏移值
@property (nonatomic, assign) CGFloat scrollViewMaxOffsetY;

/// 外部滚动容器代理，弱引用
@property (nonatomic, weak) id scrollViewDelegate;

- (void)refreshUIWithOffsetY:(CGFloat)offsetY completion:(nullable void (^)(CGRect, CGFloat))completion;
@end

NS_ASSUME_NONNULL_END
