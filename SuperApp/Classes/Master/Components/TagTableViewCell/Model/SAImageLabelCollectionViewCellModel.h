//
//  SAImageLabelCollectionViewCellModel.h
//  SuperApp
//
//  Created by VanJay on 2020/5/6.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAImageLabelCollectionViewCellModel : SAModel

@property (nonatomic, copy) NSString *title;            ///< 标题
@property (nonatomic, assign) UIEdgeInsets edgeInsets;  ///< 内边距
@property (nonatomic, assign) CGFloat cornerRadius;     ///< 圆角
@property (nonatomic, strong) UIColor *backgroundColor; ///< 背景色
@property (nonatomic, strong) UIFont *textFont;         ///< 字体
@property (nonatomic, strong) UIColor *textColor;       ///< 字颜色
@property (nonatomic, copy) NSString *imageName;        ///< 图片
@property (nonatomic, assign) CGFloat iconTextMargin;   ///< 图片和文字距离
@property (nonatomic, assign) CGFloat iconWidth;        ///< 图片宽度，根据宽高比自动计算高度
@property (nonatomic, assign) BOOL heightFullRounded;   ///< 高度圆角，如果为 true，cornerRadius 将不生效
@property (nonatomic, strong) id associatedObj;         ///< 关联对象
@end

NS_ASSUME_NONNULL_END
