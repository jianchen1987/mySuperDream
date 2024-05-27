//
//  SATableViewViewMoreViewModel.h
//  SuperApp
//
//  Created by VanJay on 2020/6/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface SATableViewViewMoreViewModel : NSObject
@property (nonatomic, copy) NSString *title;                  ///< 标题
@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets; ///< 内边距
@property (nonatomic, strong) UIColor *backgroundColor;       ///< 背景色
@property (nonatomic, strong) UIFont *textFont;               ///< 字体
@property (nonatomic, strong) UIColor *textColor;             ///< 字颜色
@property (nonatomic, strong) UIImage *image;                 ///< 图片
@property (nonatomic, assign) CGFloat iconTextMargin;         ///< 图片和文字距离
@property (nonatomic, assign) CGFloat iconWidth;              ///< 图片宽度，根据宽高比自动计算高度
@property (nonatomic, strong) id associatedObj;               ///< 关联对象
@property (nonatomic, strong) UIColor *borderColor;           ///< 边框颜色
@property (nonatomic, assign) CGFloat borderWidth;            ///< 边框大小
@property (nonatomic, assign) CGFloat topMargin;              ///< 按钮距离顶部大小（12.5）默认
@property (nonatomic, assign) CGFloat bottomMargin;           ///< 按钮距离顶部大小（12.5）默认

@end

NS_ASSUME_NONNULL_END
