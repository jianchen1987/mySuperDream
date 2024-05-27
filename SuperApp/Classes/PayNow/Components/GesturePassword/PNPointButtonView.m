//
//  PNPointView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/8/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPointButtonView.h"
#import "PNGesturePasswordView.h"
#import "PNGesturePasswordConfig.h"


@implementation PNPointButtonView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    PNGesturePasswordConfig *config = [PNGesturePasswordConfig sharedInstance];

    __weak PNGesturePasswordView *gesView = nil;
    if ([self.superview isKindOfClass:[PNGesturePasswordView class]]) {
        gesView = (PNGesturePasswordView *)self.superview;
    }

    CGFloat radius = config.circleRadius - config.strokeWidth;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, config.strokeWidth);
    CGPoint centerPoint = CGPointMake(rect.size.width / 2, rect.size.height / 2);
    CGFloat startAngle = -((CGFloat)M_PI / 2);
    CGFloat endAngle = ((2 * (CGFloat)M_PI) + startAngle);
    [gesView.strokeColor setStroke];
    CGContextAddArc(context, centerPoint.x, centerPoint.y, radius + config.strokeWidth / 2, startAngle, endAngle, 0);
    CGContextStrokePath(context);

    if (config.showCenterPoint) {
        [gesView.fillColor set]; //同时设置填充和边框色
        CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, startAngle, endAngle, 0);
        CGContextFillPath(context);
        if (config.fillCenterPoint) {
            [gesView.centerPointColor set]; //同时设置填充和边框色
        } else {
            [gesView.centerPointColor setStroke]; //设置边框色
        }
        CGContextAddArc(context, centerPoint.x, centerPoint.y, config.centerPointRadius, startAngle, endAngle, 0);
        if (config.fillCenterPoint) {
            CGContextFillPath(context);
        } else {
            CGContextStrokePath(context);
        }
    }
}

@end
