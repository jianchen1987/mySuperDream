//
//  SARadioView.h
//  SuperApp
//
//  Created by Chaos on 2020/10/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"

NS_ASSUME_NONNULL_BEGIN


@interface SARadioViewConfig : SAModel

/// 组件大小（默认18*18）
@property (nonatomic, assign) CGSize size;
/// 内外圆圈间距（默认4）
@property (nonatomic, assign) CGFloat margin;
/// 未选中状态边框宽度（默认PixelOne）
@property (nonatomic, assign) CGFloat borderWidth;
/// 选中状态边框宽度（默认1）
@property (nonatomic, assign) CGFloat selectedBorderWidth;
/// 未选中状态颜色（默认#ADB6C8）
@property (nonatomic, strong) UIColor *color;
/// 选中状态颜色（默认mainColor）
@property (nonatomic, strong) UIColor *selectedColor;

@end


@interface SARadioView : SAView

- (instancetype)initWithConfig:(SARadioViewConfig *)config;
/// 配置
@property (nonatomic, strong) SARadioViewConfig *config;
/// 是否选中
@property (nonatomic, assign, getter=isSelected) BOOL selected;

@end

NS_ASSUME_NONNULL_END
