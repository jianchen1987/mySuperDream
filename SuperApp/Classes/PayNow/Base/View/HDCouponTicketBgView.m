//
//  HDCouponTicketBgView.m
//  customer
//
//  Created by VanJay on 2019/6/10.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDCouponTicketBgView.h"


@interface HDCouponTicketBgView ()
@property (nonatomic, strong) CAGradientLayer *gradientLayer; ///< 渐变图层
@property (nonatomic, strong) CAShapeLayer *shadowLayer;      ///< 阴影图层
@property (nonatomic, strong) CAShapeLayer *dashLineLayer;    ///< 虚线图层
@end


@implementation HDCouponTicketBgView
- (instancetype)init {
    self = [super init];
    if (self) {
        self.needSepHalfCircle = NO;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self defaultAttribute];
        [self setupSubView];
    }
    return self;
}

// 设置默认值
- (void)defaultAttribute {
    self.backgroundColor = UIColor.clearColor;

    self.isVertical = NO;
    self.sepDistance = 50;
    self.gradientLayerWidth = 50;
    self.sepRadius = 10;
    self.borderRadius = 15;
    self.shadowColor = [UIColor colorWithRed:228 / 255.0 green:229 / 255.0 blue:234 / 255.0 alpha:0.50];
    self.shadowRadius = 6;
    self.shadowOffset = CGSizeMake(0, 3);
    self.shadowOpacity = 1;
    self.fillColor = [UIColor whiteColor];
    self.dashColor = [UIColor colorWithRed:75 / 255.0 green:161 / 255.0 blue:255 / 255.0 alpha:1.0];
    self.dashWidth = 0.5f;
    self.dashMargin = 4;
    self.dashLength = 6;
    self.dashMarginToEdge = 4;
    self.toothRadius = 4;
    self.toothMargin = 5;
    self.toothHEdgeMargin = 1.5 * self.toothMargin;
    self.locations = @[@(0), @(1.0f)];
    self.gradientLayerStartPoint = CGPointMake(0.87, 0);
    self.gradientLayerEndPoint = CGPointMake(0, 0);
    self.borderLayerStrokeColor = [UIColor colorWithRed:228 / 255.0 green:229 / 255.0 blue:234 / 255.0 alpha:0.50];
    self.borderLayerLineWidth = 1;
}

/** 自定义内容 */
- (void)setupSubView {
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    CAGradientLayer * (^setGradientLayerWithPath)(UIBezierPath *) = ^CAGradientLayer *(UIBezierPath *path) {
        if (self.gradientLayer) {
            [self.gradientLayer removeFromSuperlayer];
            self.gradientLayer = nil;
        }
        CAShapeLayer *gradientLayerMaskLayer = [CAShapeLayer layer];
        gradientLayerMaskLayer.path = path.CGPath;

        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.startPoint = self.gradientLayerStartPoint;
        gradientLayer.endPoint = self.gradientLayerEndPoint;
        gradientLayer.locations = self.locations;
        gradientLayer.mask = gradientLayerMaskLayer;
        gradientLayer.frame = path.bounds;
        gradientLayer.colors = self.gradientLayerColors;
        self.gradientLayer = gradientLayer;
        return gradientLayer;
    };

    CAShapeLayer * (^setShadowLayerWithPath)(UIBezierPath *, BOOL) = ^CAShapeLayer *(UIBezierPath *path, BOOL needShadow) {
        if (self.shadowLayer) {
            [self.shadowLayer removeFromSuperlayer];
            self.shadowLayer = nil;
        }
        CAShapeLayer *shadowLayer = [CAShapeLayer layer];
        shadowLayer.path = path.CGPath;
        shadowLayer.fillColor = self.fillColor.CGColor;
        shadowLayer.strokeColor = self.borderLayerStrokeColor.CGColor;
        if (needShadow) {
            shadowLayer.shadowColor = self.shadowColor.CGColor;
            shadowLayer.shadowOffset = self.shadowOffset;
            shadowLayer.shadowOpacity = self.shadowOpacity;
            shadowLayer.shadowRadius = self.shadowRadius;
            shadowLayer.lineWidth = self.borderLayerLineWidth;
        }
        self.shadowLayer = shadowLayer;
        return shadowLayer;
    };

    CGFloat radius = self.toothRadius, lineH = self.toothMargin, bigLineH = self.toothHEdgeMargin, borderRadius = self.borderRadius, w = self.frame.size.width, h = self.frame.size.height,
            sepDistance = self.sepDistance, sepRadius = self.sepRadius, leftPartW = self.gradientLayerWidth;

    if (self.isVertical) {
        NSInteger count = (floor)(w + lineH - 2.f * bigLineH) / (float)(2.f * radius + lineH);
        if (self.maxToothCount > 0) {
            count = self.maxToothCount;
        }
        // 修正 bigLineH
        bigLineH = (w - (count - 1) * lineH - count * 2 * radius) * 0.5;

        UIBezierPath *path = [UIBezierPath bezierPath];
        // 左边，左上角开始
        [path moveToPoint:CGPointMake(0, borderRadius)];

        if (self.needSepHalfCircle) {
            [path addLineToPoint:CGPointMake(0, sepDistance - sepRadius)];

            // 画左边中间半圆
            [path addArcWithCenter:CGPointMake(0, sepDistance) radius:sepRadius startAngle:-M_PI_2 endAngle:-3 * M_PI_2 clockwise:YES];
        }
        [path addLineToPoint:CGPointMake(0, h - borderRadius)];

        [path addArcWithCenter:CGPointMake(borderRadius, h - borderRadius) radius:borderRadius startAngle:-M_PI endAngle:-3 * M_PI_2 clockwise:NO];
        [path addLineToPoint:CGPointMake(w - borderRadius, h)];
        [path addArcWithCenter:CGPointMake(w - borderRadius, h - borderRadius) radius:borderRadius startAngle:-3 * M_PI_2 endAngle:0 clockwise:NO];

        if (self.needSepHalfCircle) {
            [path addLineToPoint:CGPointMake(w, sepDistance + sepRadius)];
            // 画右边中间半圆
            [path addArcWithCenter:CGPointMake(w, sepDistance) radius:sepRadius startAngle:-3 * M_PI_2 endAngle:-M_PI_2 clockwise:YES];
        }
        [path addLineToPoint:CGPointMake(w, 0)];

        for (short i = 0; i < count; i++) {
            [path addLineToPoint:CGPointMake(w - bigLineH - i * (2 * radius + lineH), 0)];
            [path addArcWithCenter:CGPointMake(w - bigLineH - i * (2 * radius + lineH) - radius, 0) radius:radius startAngle:0 endAngle:-M_PI clockwise:YES];
        }
        [path addLineToPoint:CGPointMake(0, 0)];

        [path closePath];

        CAShapeLayer *shadowLayer = setShadowLayerWithPath(path, false);
        [self.layer insertSublayer:shadowLayer atIndex:0];
        self.shadowLayer = shadowLayer;

    } else {
        NSInteger count = (floor)(h + lineH - 2.f * bigLineH - 2 * borderRadius) / (float)(2.f * radius + lineH);
        if (self.maxToothCount > 0) {
            count = self.maxToothCount;
        }

        // 修正 bigLineH
        bigLineH = (h - (count - 1) * lineH - count * 2 * radius - 2 * borderRadius) * 0.5;

        // 为了不影响原来的逻辑，对于渲染全部渐变的情况，单独写一份代码，重复没关系，便于维护
        if (self.isFullRenderedGradientLayer) {
            UIBezierPath *gradientLayerPath = [UIBezierPath bezierPath];
            // 左边，左下角开始
            [gradientLayerPath moveToPoint:CGPointMake(borderRadius, h)];
            if (self.needSepHalfCircle) {
                [gradientLayerPath addLineToPoint:CGPointMake(sepDistance - sepRadius, h)];
                // 画中间半圆
                [gradientLayerPath addArcWithCenter:CGPointMake(sepDistance, h) radius:sepRadius startAngle:-M_PI endAngle:0 clockwise:YES];
            }
            [gradientLayerPath addLineToPoint:CGPointMake(w - borderRadius, h)];
            // 画右下角 1/4 圆
            if (self.isCornerRadiusInward) {
                [gradientLayerPath addArcWithCenter:CGPointMake(w - borderRadius, h - borderRadius) radius:borderRadius startAngle:-M_PI_2 * 3 endAngle:0 clockwise:false];
            } else {
                [gradientLayerPath addArcWithCenter:CGPointMake(w, h) radius:borderRadius startAngle:-M_PI endAngle:-M_PI_2 clockwise:YES];
            }

            for (short i = 0; i < count; i++) {
                [gradientLayerPath addLineToPoint:CGPointMake(w, h - borderRadius - bigLineH - i * (2 * radius + lineH))];
                [gradientLayerPath addArcWithCenter:CGPointMake(w, h - borderRadius - bigLineH - i * (2 * radius + lineH) - radius) radius:radius startAngle:-3 * M_PI_2 endAngle:-M_PI_2
                                          clockwise:YES];
            }
            [gradientLayerPath addLineToPoint:CGPointMake(w, borderRadius + bigLineH)];
            // 画右上角 1/4 圆
            if (self.isCornerRadiusInward) {
                [gradientLayerPath addArcWithCenter:CGPointMake(w - borderRadius, borderRadius) radius:borderRadius startAngle:0 endAngle:-M_PI_2 clockwise:false];
            } else {
                [gradientLayerPath addArcWithCenter:CGPointMake(w, 0) radius:self.borderRadius startAngle:-3 * M_PI / 2 endAngle:-M_PI clockwise:YES];
            }

            if (self.needSepHalfCircle) {
                [gradientLayerPath addLineToPoint:CGPointMake(sepDistance + sepRadius, 0)];
                // 画中间半圆
                [gradientLayerPath addArcWithCenter:CGPointMake(sepDistance, 0) radius:sepRadius startAngle:0 endAngle:M_PI clockwise:YES];
            }

            [gradientLayerPath addLineToPoint:CGPointMake(borderRadius, 0)];
            // 画左上角半圆
            if (self.isCornerRadiusInward) {
                [gradientLayerPath addArcWithCenter:CGPointMake(borderRadius, borderRadius) radius:borderRadius startAngle:-M_PI_2 endAngle:-M_PI clockwise:false];
            } else {
                [gradientLayerPath addArcWithCenter:CGPointMake(0, 0) radius:borderRadius startAngle:0 endAngle:-3 * M_PI_2 clockwise:YES];
            }

            for (short i = 0; i < count; i++) {
                [gradientLayerPath addLineToPoint:CGPointMake(0, borderRadius + bigLineH + i * (2 * radius + lineH))];
                [gradientLayerPath addArcWithCenter:CGPointMake(0, borderRadius + bigLineH + i * (2 * radius + lineH) + radius) radius:radius startAngle:-M_PI_2 endAngle:-3 * M_PI_2 clockwise:YES];
            }

            [gradientLayerPath addLineToPoint:CGPointMake(0, h - sepRadius)];

            // 画左下角半圆
            if (self.isCornerRadiusInward) {
                [gradientLayerPath addArcWithCenter:CGPointMake(borderRadius, h - borderRadius) radius:borderRadius startAngle:-M_PI endAngle:-M_PI_2 * 3 clockwise:false];
            } else {
                [gradientLayerPath addArcWithCenter:CGPointMake(0, h) radius:borderRadius startAngle:-M_PI_2 endAngle:0 clockwise:YES];
            }
            [gradientLayerPath closePath];

            CAGradientLayer *gradientLayer = setGradientLayerWithPath(gradientLayerPath);
            [self.layer insertSublayer:gradientLayer atIndex:0];

            CAShapeLayer *shadowLayer = setShadowLayerWithPath(gradientLayerPath, false);
            [self.layer insertSublayer:shadowLayer below:self.gradientLayer];
        } else {
            UIBezierPath *gradientLayerPath = [UIBezierPath bezierPath];
            // 左边，左下角开始
            [gradientLayerPath moveToPoint:CGPointMake(borderRadius, h)];

            if (self.needSepHalfCircle && sepDistance < leftPartW) {
                [gradientLayerPath addLineToPoint:CGPointMake(sepDistance - sepRadius, h)];
                // 画中间半圆
                [gradientLayerPath addArcWithCenter:CGPointMake(sepDistance, h) radius:sepRadius startAngle:-M_PI endAngle:0 clockwise:YES];
            }
            [gradientLayerPath addLineToPoint:CGPointMake(leftPartW, h)];
            [gradientLayerPath addLineToPoint:CGPointMake(leftPartW, 0)];
            if (self.needSepHalfCircle && sepDistance < leftPartW) {
                [gradientLayerPath addLineToPoint:CGPointMake(sepDistance + sepRadius, 0)];
                // 画中间半圆
                [gradientLayerPath addArcWithCenter:CGPointMake(sepDistance, 0) radius:sepRadius startAngle:0 endAngle:M_PI clockwise:YES];
            }
            [gradientLayerPath addLineToPoint:CGPointMake(borderRadius, 0)];
            // 画左上角半圆
            [gradientLayerPath addArcWithCenter:CGPointMake(0, 0) radius:borderRadius startAngle:0 endAngle:-3 * M_PI_2 clockwise:YES];

            for (short i = 0; i < count; i++) {
                [gradientLayerPath addLineToPoint:CGPointMake(0, borderRadius + bigLineH + i * (2 * radius + lineH))];
                [gradientLayerPath addArcWithCenter:CGPointMake(0, borderRadius + bigLineH + i * (2 * radius + lineH) + radius) radius:radius startAngle:-M_PI_2 endAngle:-3 * M_PI_2 clockwise:YES];
            }

            [gradientLayerPath addLineToPoint:CGPointMake(0, h - sepRadius)];

            // 画左下角半圆
            [gradientLayerPath addArcWithCenter:CGPointMake(0, h) radius:borderRadius startAngle:-M_PI_2 endAngle:0 clockwise:YES];
            [gradientLayerPath closePath];

            UIBezierPath *shadowLayerPath = [UIBezierPath bezierPath];
            // 右边，下分隔点开始
            [shadowLayerPath moveToPoint:CGPointMake(leftPartW, h)];

            if (self.needSepHalfCircle && sepDistance > leftPartW) {
                [shadowLayerPath addLineToPoint:CGPointMake(sepDistance - sepRadius, h)];
                // 画中间半圆
                [shadowLayerPath addArcWithCenter:CGPointMake(sepDistance, h) radius:sepRadius startAngle:-M_PI endAngle:0 clockwise:YES];
            }

            [shadowLayerPath addLineToPoint:CGPointMake(w - borderRadius, h)];
            // 画右下角 1/4 圆
            [shadowLayerPath addArcWithCenter:CGPointMake(w, h) radius:borderRadius startAngle:-M_PI endAngle:-M_PI_2 clockwise:YES];
            for (short i = 0; i < count; i++) {
                [shadowLayerPath addLineToPoint:CGPointMake(w, h - borderRadius - bigLineH - i * (2 * radius + lineH))];
                [shadowLayerPath addArcWithCenter:CGPointMake(w, h - borderRadius - bigLineH - i * (2 * radius + lineH) - radius) radius:radius startAngle:-3 * M_PI_2 endAngle:-M_PI_2 clockwise:YES];
            }
            [shadowLayerPath addLineToPoint:CGPointMake(w, borderRadius + bigLineH)];
            // 画右上角 1/4 圆
            [shadowLayerPath addArcWithCenter:CGPointMake(w, 0) radius:self.borderRadius startAngle:-3 * M_PI / 2 endAngle:-M_PI clockwise:YES];
            if (self.needSepHalfCircle && sepDistance > leftPartW) {
                [shadowLayerPath addLineToPoint:CGPointMake(sepDistance + sepRadius, 0)];
                // 画中间半圆
                [shadowLayerPath addArcWithCenter:CGPointMake(sepDistance, 0) radius:sepRadius startAngle:0 endAngle:M_PI clockwise:YES];
            }
            [shadowLayerPath addLineToPoint:CGPointMake(leftPartW, 0)];
            [shadowLayerPath addLineToPoint:CGPointMake(leftPartW, h)];
            [shadowLayerPath closePath];

            CAGradientLayer *gradientLayer = setGradientLayerWithPath(gradientLayerPath);
            [self.layer insertSublayer:gradientLayer atIndex:0];

            CAShapeLayer *shadowLayer = setShadowLayerWithPath(shadowLayerPath, true);
            [self.layer insertSublayer:shadowLayer below:self.gradientLayer];
        }
    }

    if (self.needSepHalfCircle && leftPartW != sepDistance) {
        [self drawDashLine];
    }
}

/** 画虚线 */
- (void)drawDashLine {
    CGFloat dashWidth = self.dashWidth, dashLength = self.dashLength, dashMargin = self.dashMargin, dashMarginToEdge = self.dashMarginToEdge, w = self.frame.size.width, h = self.frame.size.height,
            sepDistance = self.sepDistance, sepRadius = self.sepRadius;
    if (self.isVertical) {
        NSInteger count = (floor)(w + dashMargin - 2.f * dashMarginToEdge - 2 * sepRadius) / (float)(dashLength + dashMargin);
        if (self.maxToothCount > 0) {
            count = self.maxToothCount;
        }

        // 修正 dashMarginToEdge
        dashMarginToEdge = (w - (count - 1) * dashMargin - count * dashLength - 2 * sepRadius) * 0.5;

        UIBezierPath *dashLineLayerPath = [UIBezierPath bezierPath];

        for (short i = 0; i < count; i++) {
            [dashLineLayerPath moveToPoint:CGPointMake(sepRadius + dashMarginToEdge + i * (dashMargin + dashLength), sepDistance)];
            [dashLineLayerPath addLineToPoint:CGPointMake(sepRadius + dashMarginToEdge + i * (dashMargin + dashLength) + dashLength, sepDistance)];
        }

        if (self.dashLineLayer) {
            [self.dashLineLayer removeFromSuperlayer];
            self.dashLineLayer = nil;
        }

        CAShapeLayer *dashLineLayer = [CAShapeLayer layer];
        dashLineLayer.lineWidth = dashWidth;
        dashLineLayer.path = dashLineLayerPath.CGPath;
        dashLineLayer.lineJoin = kCALineJoinRound;
        dashLineLayer.fillColor = [UIColor clearColor].CGColor;
        dashLineLayer.strokeColor = self.dashColor.CGColor;
        [self.layer addSublayer:dashLineLayer];
        self.dashLineLayer = dashLineLayer;
    } else {
        NSInteger count = (floor)(h + dashMargin - 2.f * dashMarginToEdge - 2 * sepRadius) / (float)(dashLength + dashMargin);
        if (self.maxToothCount > 0) {
            count = self.maxToothCount;
        }

        // 修正 dashMarginToEdge
        dashMarginToEdge = (h - (count - 1) * dashMargin - count * dashLength - 2 * sepRadius) * 0.5;

        UIBezierPath *dashLineLayerPath = [UIBezierPath bezierPath];

        for (short i = 0; i < count; i++) {
            [dashLineLayerPath moveToPoint:CGPointMake(sepDistance, sepRadius + dashMarginToEdge + i * (dashMargin + dashLength))];
            [dashLineLayerPath addLineToPoint:CGPointMake(sepDistance, sepRadius + dashMarginToEdge + i * (dashMargin + dashLength) + dashLength)];
        }

        if (self.dashLineLayer) {
            [self.dashLineLayer removeFromSuperlayer];
            self.dashLineLayer = nil;
        }

        CAShapeLayer *dashLineLayer = [CAShapeLayer layer];
        dashLineLayer.lineWidth = dashWidth;
        dashLineLayer.path = dashLineLayerPath.CGPath;
        dashLineLayer.lineJoin = kCALineJoinRound;
        dashLineLayer.fillColor = [UIColor clearColor].CGColor;
        dashLineLayer.strokeColor = self.dashColor.CGColor;
        [self.layer addSublayer:dashLineLayer];
        self.dashLineLayer = dashLineLayer;
    }
}

#pragma mark - getters and setters
- (void)setGradientLayerColors:(NSArray *)gradientLayerColors {
    _gradientLayerColors = gradientLayerColors;

    [self setNeedsDisplay];
}

- (void)setSepDistance:(CGFloat)sepDistance {
    if (_sepDistance == sepDistance)
        return;

    _sepDistance = sepDistance;

    [self setNeedsDisplay];
}

- (void)setGradientLayerWidth:(CGFloat)gradientLayerWidth {
    if (_gradientLayerWidth == gradientLayerWidth)
        return;

    _gradientLayerWidth = gradientLayerWidth;

    [self setNeedsDisplay];
}
@end
