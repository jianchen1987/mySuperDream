//
//  HDCouponTicketBgView.h
//  customer
//
//  Created by VanJay on 2019/6/10.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface HDCouponTicketBgView : UIView
@property (nonatomic, assign) BOOL isVertical;                      ///< 标签显示样式,是否是垂直的，默认
@property (nonatomic, assign) CGFloat sepDistance;                  ///< 左右两边的两个缺角中心（虚线）距离（水平距离左边，垂直距离顶部）的距离
@property (nonatomic, assign) CGFloat sepRadius;                    ///< 中间分隔弧的 radius
@property (nonatomic, assign) CGFloat borderRadius;                 ///< 视图外部的弧度角
@property (nonatomic, strong) UIColor *shadowColor;                 ///< 外部阴影的颜色.默认黑色
@property (nonatomic, assign) CGFloat shadowRadius;                 ///< 外部阴影的宽度，默认
@property (nonatomic, assign) CGSize shadowOffset;                  ///< 阴影偏移
@property (nonatomic, assign) float shadowOpacity;                  ///< 阴影不透明度
@property (nonatomic, strong) UIColor *fillColor;                   ///< 内部填充色.默认白色
@property (nonatomic, assign) CGFloat dashWidth;                    ///< 虚线宽度
@property (nonatomic, assign) CGFloat dashLength;                   ///< 虚线长度
@property (nonatomic, assign) CGFloat dashMargin;                   ///< 虚线间距
@property (nonatomic, assign) CGFloat dashMarginToEdge;             ///< 虚线两端距离分隔弧的最小间距，会根据虚线个数进行修正
@property (nonatomic, strong) UIColor *dashColor;                   ///< 虚线分割线的颜色，默认黑色
@property (nonatomic, assign) CGFloat toothRadius;                  ///< 齿半径
@property (nonatomic, assign) NSUInteger maxToothCount;             ///< 最大齿个数，默认0，不限制
@property (nonatomic, assign) CGFloat toothMargin;                  ///< 齿间距
@property (nonatomic, assign) CGFloat toothHEdgeMargin;             ///< 齿上下两头距边缘距离，会根据最终齿的个数计算进行（修正）
@property (nonatomic, assign) CGFloat gradientLayerWidth;           ///< 渐变图层宽度
@property (nonatomic, nullable, copy) NSArray *gradientLayerColors; ///< 渐变图层 colors
@property (nonatomic, assign) CGPoint gradientLayerStartPoint;      ///< 渐变图层 startPoint
@property (nonatomic, assign) CGPoint gradientLayerEndPoint;        ///< 渐变图层 endPoint
@property (nonatomic, copy) NSArray *locations;                     ///< 渐变图层 locations，默认 @[@(0), @(1.0f)]
@property (nonatomic, assign) BOOL isFullRenderedGradientLayer;     ///< 是否全部渲染渐变，默认 NO
@property (nonatomic, assign) BOOL isCornerRadiusInward;            ///< 圆角向内，只在 isFullRenderedGradientLayer 为 true 生效，默认 NO
@property (nonatomic, assign) BOOL needSepHalfCircle;               ///< 是否需要隔开的半圆，默认 NO
@property (nonatomic, strong) UIColor *borderLayerStrokeColor;      ///< 边框色
@property (nonatomic, assign) CGFloat borderLayerLineWidth;         ///< 边框线宽度，默认1
@end

NS_ASSUME_NONNULL_END
