//
//  WMShoppingCartButton.h
//  SuperApp
//
//  Created by VanJay on 2020/5/14.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDUIButton.h"
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN


@interface TNShoppingCartButton : HDUIButton
/// 上下偏移位置
@property (nonatomic, assign) CGFloat offsetY;
/// 左右偏移位置
@property (nonatomic, assign) CGFloat offsetX;
/// 角标 字体
@property (strong, nonatomic) UIFont *indicatorFont;
/// 间距
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
/// 更新购物车按钮指示器标识
- (void)updateIndicatorDotWithCount:(NSUInteger)count;
@end

NS_ASSUME_NONNULL_END
