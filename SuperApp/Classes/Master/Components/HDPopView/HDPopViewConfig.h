//
//  HDPopViewConfig.h
//  SuperApp
//
//  Created by VanJay on 2019/6/26.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface HDPopViewConfig : NSObject

@property (nonatomic, assign) CGFloat arrowSideLength;            ///< 箭头三角形腰边长
@property (nonatomic, assign) CGFloat arrowBottomSideLength;      ///< 箭头三角形底边长
@property (nonatomic, assign) CGFloat cornerRadius;               ///< 圆角大小
@property (nonatomic, nullable, copy) NSArray<UIColor *> *colors; ///< 渐变图层 colors
@property (nonatomic, copy) NSArray *locations;                   ///< 渐变图层 locations

@property (nonatomic, strong) UIColor *textColor;              ///< 文字颜色
@property (nonatomic, strong) UIFont *textFont;                ///< 文字字体
@property (nonatomic, assign) UIEdgeInsets edgeInsets;         ///< 内边距
@property (nonatomic, assign) BOOL shouldShake;                ///< 是否抖动
@property (nonatomic, assign) NSUInteger shakeCount;           ///< 抖动次数
@property (nonatomic, assign) NSTimeInterval shakeDuration;    ///< 单次抖动时间
@property (nonatomic, assign) CGFloat shakeDistance;           ///< 抖动距离
@property (nonatomic, assign) BOOL autoDismiss;                ///< 是否自动消失
@property (nonatomic, assign) NSTimeInterval autoDismissDelay; ///< 多久自动消失，默认3秒
@property (nonatomic, copy) NSString *text;                    ///< 提示内容
@property (nonatomic, strong) UIView *sourceView;              ///< 源 View
@property (nonatomic, strong) UIColor *overLayBackgroundColor; ///< 遮罩层背景色
@property (nonatomic, strong) UIColor *contentBackgroundColor; ///< 遮罩层背景色
@property (nonatomic, assign) CGFloat contentMaxWidth; ///< 内容区域最大宽度，默认屏幕宽度 0.9，如果容器 View 不足则以容器宽度为准 上的图高度与源 View 高度的比值，默认1.2
@property (nonatomic, copy) NSString *identifier; ///< 唯一标识
@end

NS_ASSUME_NONNULL_END
