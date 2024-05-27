//
//  HDCommonButton.h
//  customer
//
//  Created by VanJay on 2019/4/18.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "UIButton+Block.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HDCommonButtonType) {
    HDCommonButtonImageLLabelR = 0, ///< 图左字右，默认
    HDCommonButtonImageRLabelL,     ///< 图右字左
    HDCommonButtonImageULabelD,     ///< 图上字下
    HDCommonButtonImageDLabelU,     ///< 图下字上
};


@interface HDCommonButton : UIButton
@property (nonatomic, strong) id associatedObject;                                ///< 关联对象
@property (nonatomic, assign) HDCommonButtonType type;                            ///< 布局位置类型
@property (nonatomic, assign) UIEdgeInsets imageViewEdgeInsets;                   ///< 图片 View 内边距，图片显示原图，设置上下内边距无效
@property (nonatomic, assign) UIEdgeInsets labelEdgeInsets;                       ///< 文字 View 内边距
@property (nonatomic, assign) NSTextAlignment textAlignment;                      ///< 文字 align 类型
@property (nonatomic, strong) UIColor *imageViewContainerColor;                   ///< 图片容器背景设置，暂用于 facebook 登录按钮
@property (nonatomic, assign) CGSize imageViewSize;                               ///< 自定义图片尺寸
@property (nonatomic, assign) BOOL isTextAlignmentCenterToWhole;                  ///< 标题是否对于整个 button 居中
@property (nonatomic, assign, readonly) CGSize appropriateSize;                   ///< 算完间距的合适尺寸
@property (nonatomic, assign) CGFloat minusHeightForIncorrectSystemCalcalateSize; ///< 系统计算不正确的补偿高度，比如高棉语，默认 5
@property (nonatomic, assign) BOOL heightFullRounded;                             ///< 高度圆角，如果为 true，cornerRadius 将不生效
@property (nonatomic, assign) CGFloat cornerRadius;                               ///< 圆角

- (CGSize)appropriateSizeWithWidth:(CGFloat)width;

@end

NS_ASSUME_NONNULL_END
