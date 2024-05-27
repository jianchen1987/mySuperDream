//
//  WMStoreProductDetailNavigationBarView.h
//  SuperApp
//
//  Created by VanJay on 2020/6/12.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMStoreProductDetailNavigationBarView : SAView
- (void)updateTitle:(NSString *)title;

/// 根据 UIScrollView 偏移更新 UI
- (void)updateUIWithScrollViewOffsetY:(CGFloat)offsetY;
@end

NS_ASSUME_NONNULL_END
