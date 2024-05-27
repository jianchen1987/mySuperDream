//
//  SAMessageButton.h
//  SuperApp
//
//  Created by VanJay on 2020/4/7.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAEnum.h"
#import <HDUIKit/HDUIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** 消息按钮，可显示消息条数 */
@interface SAMessageButton : HDUIButton

/// 客户端类型
@property (nonatomic, copy) SAClientType clientType;

/// 红点偏移位置  默认偏贵 x - 3  y + 3
@property (nonatomic, assign) CGPoint dotPosition;

/// 红点背景颜色
@property (nonatomic, strong) UIColor *dotBackgroundColor;

/// 展示消息数量
/// @param count 数量
- (void)showMessageCount:(NSUInteger)count;

/// 清除消息数量
- (void)clearMessageCount;

/// 设置圆点颜色
- (void)setDotColor:(UIColor *)dotColor;

+ (instancetype)buttonWithType:(UIButtonType)buttonType NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

+ (instancetype)buttonWithType:(UIButtonType)buttonType clientType:(SAClientType)clientType;
@end

NS_ASSUME_NONNULL_END
