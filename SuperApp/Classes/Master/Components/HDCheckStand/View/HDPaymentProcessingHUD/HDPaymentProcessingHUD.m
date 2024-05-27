//
//  HDPaymentProcessingHUD.m
//  SuperApp
//
//  Created by VanJay on 2019/9/16.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDPaymentProcessingHUD.h"
#import "HDAppTheme.h"

static CGFloat lineWidth = 4.0f;
static CGFloat circleDuriation = 0.5f;
static CGFloat checkDuration = 0.2f;

#define ThemeColor HDAppTheme.color.C1

typedef void (^CompletionHandler)(void);


@interface HDPaymentProcessingHUD () <CAAnimationDelegate>
@property (nonatomic, copy) CompletionHandler completionHandler; ///< 动画完成回调
@property (nonatomic, assign) CGFloat offset;                    ///< Y 方向偏移
@property (nonatomic, strong) CADisplayLink *link;               ///< 定时器
@property (nonatomic, assign) CGFloat startAngle;                ///< 圆环起始角度
@property (nonatomic, assign) CGFloat endAngle;                  ///< 圆环结束角度
@property (nonatomic, assign) CGFloat progress;                  ///< 圆环当前进度
@property (nonatomic, strong) CAShapeLayer *rotatingLayer;       ///< loading 图层
@property (nonatomic, strong) CALayer *animationLayer;           ///< 成功图层
@property (nonatomic, strong) CAShapeLayer *tickLayer;           ///< √图层
@end


@implementation HDPaymentProcessingHUD
#pragma mark - life cycle
- (void)commonInit {
    _rotatingLayer = [CAShapeLayer layer];
    _rotatingLayer.bounds = CGRectMake(0, 0, 60, 60);
    _rotatingLayer.position = CGPointMake(self.bounds.size.width / 2.0f, self.bounds.size.height / 2.0 + self.offset);
    _rotatingLayer.fillColor = [UIColor clearColor].CGColor;
    _rotatingLayer.strokeColor = ThemeColor.CGColor;
    _rotatingLayer.lineWidth = lineWidth;
    _rotatingLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:_rotatingLayer];

    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkHandler)];
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    _link.paused = true;

    _animationLayer = [CALayer layer];
    _animationLayer.bounds = CGRectMake(0, 0, 60, 60);
    _animationLayer.position = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2 + self.offset);
    [self.layer addSublayer:_animationLayer];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

#pragma mark - public methods
+ (HDPaymentProcessingHUD *)showLoadingIn:(UIView *)view offset:(CGFloat)offset {
    [self hideFor:view];
    HDPaymentProcessingHUD *hud = [[HDPaymentProcessingHUD alloc] initWithFrame:view.bounds];
    hud.offset = offset;
    [hud startRotating];
    [view addSubview:hud];
    return hud;
}

- (void)showSuccessCompletion:(void (^__nullable)(void))completion {
    _completionHandler = completion;

    [self endRotating];
    [self startDrawSuccessLayer];
}

+ (HDPaymentProcessingHUD *)hideFor:(UIView *)view {
    HDPaymentProcessingHUD *hud;
    for (HDPaymentProcessingHUD *subView in view.subviews) {
        if ([subView isKindOfClass:HDPaymentProcessingHUD.class]) {
            [subView hide];
            hud = subView;
        }
    }
    return hud;
}

#pragma mark - private methods
- (void)startRotating {
    _link.paused = false;
}

- (void)endRotating {
    _link.paused = true;
    _progress = 0;

    [self updaterotatingLayer];
}

- (void)updaterotatingLayer {
    _startAngle = -M_PI_2;
    _endAngle = -M_PI_2 + _progress * M_PI * 2;
    if (_endAngle > M_PI) {
        CGFloat progress1 = 1 - (1 - _progress) / 0.25;
        _startAngle = -M_PI_2 + progress1 * M_PI * 2;
    }
    CGFloat radius = _rotatingLayer.bounds.size.width / 2.0f - lineWidth / 2.0f;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.circleCenter radius:radius startAngle:_startAngle endAngle:_endAngle clockwise:true];
    path.lineCapStyle = kCGLineCapRound;

    _rotatingLayer.path = path.CGPath;
}

- (CGFloat)rotatingSpeed {
    if (_endAngle > M_PI) {
        return 0.3 / 60.0f;
    }
    return 2 / 60.0f;
}

- (CGPoint)circleCenter {
    CGFloat centerX = _rotatingLayer.bounds.size.width / 2.0f;
    CGFloat centerY = _rotatingLayer.bounds.size.height / 2.0f + self.offset;
    return CGPointMake(centerX, centerY);
}

- (void)startDrawSuccessLayer {
    [self drawSuccessCircleLayer];
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.8 * circleDuriation * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^(void) {
        [self drawTickLayer];
    });
}

- (void)hide {
    [_rotatingLayer removeAllAnimations];
    for (CALayer *layer in _animationLayer.sublayers) {
        [layer removeAllAnimations];
    }
    [_link invalidate];
    _link = nil;

    [self removeFromSuperview];
}

/** 画成功的圆 */
- (void)drawSuccessCircleLayer {
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.frame = _animationLayer.bounds;
    [_animationLayer addSublayer:circleLayer];
    circleLayer.fillColor = [[UIColor clearColor] CGColor];
    circleLayer.strokeColor = ThemeColor.CGColor;
    circleLayer.lineWidth = lineWidth;
    circleLayer.lineCap = kCALineCapRound;

    CGFloat lineWidth = 5.0f;
    CGFloat radius = _animationLayer.bounds.size.width / 2.0f - lineWidth / 2.0f;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.circleCenter radius:radius startAngle:-M_PI / 2 endAngle:M_PI * 3.0 / 2.0 clockwise:true];
    circleLayer.path = path.CGPath;

    CABasicAnimation *circleAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    circleAnimation.duration = circleDuriation;
    circleAnimation.fromValue = @(0.0f);
    circleAnimation.toValue = @(1.0f);
    [circleLayer addAnimation:circleAnimation forKey:nil];
}

/** 画勾 */
- (void)drawTickLayer {
    CGFloat a = _animationLayer.bounds.size.width;

    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(a * 2.7 / 10, a * 5.4 / 10 + self.offset)];
    [path addLineToPoint:CGPointMake(a * 4.5 / 10, a * 7 / 10 + self.offset)];
    [path addLineToPoint:CGPointMake(a * 7.8 / 10, a * 3.8 / 10 + self.offset)];

    CAShapeLayer *tickLayer = [CAShapeLayer layer];
    tickLayer.path = path.CGPath;
    tickLayer.fillColor = [UIColor clearColor].CGColor;
    tickLayer.strokeColor = ThemeColor.CGColor;
    tickLayer.lineWidth = lineWidth;
    tickLayer.lineCap = kCALineCapRound;
    tickLayer.lineJoin = kCALineJoinRound;
    self.tickLayer = tickLayer;
    [_animationLayer addSublayer:tickLayer];

    CABasicAnimation *tickAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    tickAnimation.duration = checkDuration;
    tickAnimation.fromValue = @(0.0f);
    tickAnimation.toValue = @(1.0f);
    tickAnimation.delegate = self;
    [self.tickLayer addAnimation:tickAnimation forKey:@"successAnimation"];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    // 为何 nil ？
    // if ([[self.tickLayer animationForKey:@"successAnimation"] isEqual:anim]) {
    [self hide];
    !_completionHandler ?: _completionHandler();
    // }
}

#pragma mark - event response
- (void)displayLinkHandler {
    _progress += [self rotatingSpeed];
    if (_progress >= 1) {
        _progress = 0;
    }
    [self updaterotatingLayer];
}
@end
