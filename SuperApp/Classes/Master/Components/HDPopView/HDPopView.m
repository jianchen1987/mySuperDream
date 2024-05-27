//
//  HDPopView.m
//  SuperApp
//
//  Created by VanJay on 2019/6/26.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDPopView.h"
#import "HDPopViewConfig.h"
#import "SALabel.h"
#import "UIView+FrameChangedHandler.h"
#import "UIView+Shake.h"
#import <HDKitCore/HDCommonDefines.h>
#import <HDVendorKit/HDWebImageManager.h>


@interface HDPopViewOverlay : UIView
@property (nonatomic, strong) UIButton *button; ///< 占据整个 overlay 的按钮，方便接收 event
@end


@implementation HDPopViewOverlay

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = self.bounds;
        //        button.hd_eventTimeInterval = 0.5;
        [self addSubview:button];
        self.button = button;
        [button addTarget:self action:@selector(backgroundButtonTappedHandler) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)backgroundButtonTappedHandler {
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:[HDPopView class]] && [v respondsToSelector:@selector(dismissAnimated:)]) {
            HDPopView *finalV = (HDPopView *)v;
            if (finalV.tappedHandler) {
                finalV.tappedHandler();
            } else {
                [finalV dismissAnimated:YES];
            }
        }
    }
}

@end

/** 箭头方向 */
typedef NS_ENUM(NSUInteger, HDPopViewArrowDirection) {
    HDPopViewArrowDirectionNone = 0,
    HDPopViewArrowDirectionUp,
    HDPopViewArrowDirectionDown,
    HDPopViewArrowDirectionLeft,
    HDPopViewArrowDirectionRight,
};


@interface HDPopView ()
@property (nonatomic, assign) HDPopViewArrowDirection arrowDirection; ///< 箭头方向
@property (nonatomic, assign) CGFloat arrowPosition;                  ///< 箭头顶点
@property (nonatomic, strong) SALabel *textLabel;                     ///< 文字
@property (nonatomic, strong) HDPopViewConfig *config;                ///< 配置
@property (nonatomic, strong) UIView *contentView;                    ///< 内容
@property (nonatomic, strong) HDPopViewOverlay *overLay;              ///< 遮罩
@property (nonatomic, weak) UIView *containerView;                    ///< 容器
@property (nonatomic, copy) NSArray<HDPopViewConfig *> *leftConfigs;  ///< 当前剩余要展示的配置
@property (nonatomic, assign) CGFloat arrowHeightOrWidth;             ///< 箭头高度
@end


@implementation HDPopView
- (void)dealloc {
    HDLog(@"HDPopView -- dealloc");
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.arrowHeightOrWidth = -1;
    }
    return self;
}

#pragma mark - public methods
- (void)showPopTipInView:(UIView *__nullable)view fromView:(UIView *)fromView config:(HDPopViewConfig *__nullable)config {
    config = config ?: [[HDPopViewConfig alloc] init];
    if (!fromView)
        return;
    config.sourceView = fromView;
    [self showPopTipInView:view configs:@[config]];
}

- (void)showPopTipInView:(UIView *__nullable)view configs:(NSArray<HDPopViewConfig *> *)configs {
    view = view ?: [UIApplication sharedApplication].keyWindow;
    self.containerView = view;

    if (configs.count <= 0)
        return;

    // 添加背景
    HDPopViewOverlay *overLay = [[HDPopViewOverlay alloc] initWithFrame:view.bounds];
    [overLay addSubview:self];
    [view addSubview:overLay];
    self.overLay = overLay;

    // 背景由暗变明
    self.overLay.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^(void) {
        self.overLay.alpha = 1;
    }];
    [self startShowPopWithConfigs:configs shouldShowFirst:true];
}

- (void)dismissAnimated:(BOOL)animated shouldCallDismissHandler:(BOOL)shouldCallDismissHandler {
    if (self.superview) {
        if (animated) {
            [UIView animateWithDuration:0.3 animations:^(void) {
                self.alpha = 0;
                self.overLay.alpha = 0;
                self.transform = CGAffineTransformMakeScale(0.01, 0.01);
            } completion:^(BOOL finished) {
                if (shouldCallDismissHandler) {
                    !self.dismissHandler ?: self.dismissHandler();
                }
                if ([self.superview isKindOfClass:[HDPopViewOverlay class]])
                    [self.superview removeFromSuperview];
                [self removeFromSuperview];
            }];

        } else {
            if (shouldCallDismissHandler) {
                !self.dismissHandler ?: self.dismissHandler();
            }
            if ([self.superview isKindOfClass:[HDPopViewOverlay class]])
                [self.superview removeFromSuperview];
            [self removeFromSuperview];
        }
    }
}

- (void)dismissAnimated:(BOOL)animated {
    [self dismissAnimated:animated shouldCallDismissHandler:true];
}

#pragma mark - private methods
/** 抖动 */
- (void)shake {
    ShakeDirection shakeDirection = ShakeDirectionVertical;
    if (_arrowDirection == HDPopViewArrowDirectionUp || _arrowDirection == HDPopViewArrowDirectionDown) {
        shakeDirection = ShakeDirectionVertical;
    } else if (_arrowDirection == HDPopViewArrowDirectionLeft || _arrowDirection == HDPopViewArrowDirectionRight) {
        shakeDirection = ShakeDirectionHorizontal;
    }

    BOOL isArrowLeftOrTop = self.arrowDirection == HDPopViewArrowDirectionUp || self.arrowDirection == HDPopViewArrowDirectionLeft;

    [self shake:(int)(self.config.shakeCount) withDelta:self.config.shakeDistance * (isArrowLeftOrTop ? 1 : -1)speed:self.config.shakeDuration shakeDirection:shakeDirection shouldShuttle:false
            completion:^{
                if (self.config.autoDismiss) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.config.autoDismissDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self simulateTouchOverLayView];
                    });
                }
            }];
}

/// 模拟按下背景
- (void)simulateTouchOverLayView {
    HDPopViewOverlay *overlayView = (HDPopViewOverlay *)self.superview;
    if ([overlayView isKindOfClass:HDPopViewOverlay.class]) {
        [overlayView.button sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

/// 开始展示
/// @param configs 所有配置
/// @param shouldShowFirst 是否直接开始展示第一个
- (void)startShowPopWithConfigs:(NSArray<HDPopViewConfig *> *)configs shouldShowFirst:(BOOL)shouldShowFirst {
    // 直接显示第一个
    NSMutableArray<HDPopViewConfig *> *originConfigs = [NSMutableArray arrayWithArray:configs];
    if (shouldShowFirst) {
        [self showPopViewWithConfig:originConfigs.firstObject];
    }
    self.leftConfigs = originConfigs.copy;

    __weak __typeof(self) weakSelf = self;
    // 点击了界面的回调，决定显示下一个或者消失
    self.tappedHandler = ^{
        // 移除无效的
        [originConfigs filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(HDPopViewConfig *_Nullable config, NSDictionary<NSString *, id> *_Nullable bindings) {
                           return config.sourceView && config.sourceView.viewController;
                       }]];

        __strong __typeof(weakSelf) strongSelf = weakSelf;
        // 移除上一个
        [originConfigs removeObject:strongSelf.config];
        if (originConfigs.count > 0) {
            [strongSelf showPopViewWithConfig:originConfigs.firstObject];
        } else {
            [strongSelf dismissAnimated:true];
        }
        strongSelf.leftConfigs = originConfigs.copy;
    };
}

/// 根据当前配配置显示引导
/// @param config 配置
- (void)showPopViewWithConfig:(HDPopViewConfig *)config {
    self.config = config;
    if (!config || !config.sourceView) {
        HDLog(@"config or sourceView is nil");
        [self simulateTouchOverLayView];
        return;
    }

    if (!config.sourceView.viewController) {
        HDLog(@"sourceView viewController is nil");
        [self simulateTouchOverLayView];
        return;
    }
    __weak __typeof(self) weakSelf = self;
    __weak __typeof(config) weakConfig = config;
    [config.sourceView hd_setFrameNonZeroOnceHandler:^(CGRect frame) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        __strong __typeof(weakConfig) strongConfig = weakConfig;

        strongSelf.overLay.backgroundColor = strongConfig.overLayBackgroundColor;
        [strongSelf setupContentView];

        self.backgroundColor = UIColor.clearColor;

        [strongSelf setupFrameFromView:strongConfig.sourceView];

        //        [strongSelf setupFrameFromView:strongConfig.sourceView];

        strongSelf.alpha = 0.0f;
        strongSelf.transform = CGAffineTransformMakeScale(0.01, 0.01);
        [UIView animateWithDuration:0.3 animations:^(void) {
            strongSelf.alpha = 1.0f;
            strongSelf.transform = CGAffineTransformIdentity;
        } completion:^(BOOL completed) {
            if (strongConfig.shouldShake) {
                // 跳动
                [strongSelf shake];
            } else {
                if (strongConfig.autoDismiss) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(strongConfig.autoDismissDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [strongSelf simulateTouchOverLayView];
                    });
                }
            }
        }];
    }];
}

- (CGSize)textLabelSize {
    // 计算文字尺寸
    CGFloat maxContentWidth = self.config.contentMaxWidth;
    // 不能超出容器宽度
    maxContentWidth = maxContentWidth > CGRectGetWidth(self.containerView.frame) ? CGRectGetWidth(self.containerView.frame) : maxContentWidth;
    // Label 最大宽度
    const CGFloat maxLabelWidth = maxContentWidth;

    if (!self.config.text || self.config.text.length <= 0)
        return CGSizeMake(maxLabelWidth, 20);

    CGSize textSize = [self.textLabel sizeThatFits:CGSizeMake(maxLabelWidth, CGFLOAT_MAX)];
    return CGSizeSafeSize(textSize);
}

- (CGFloat)arrowHeightOrWidth {
    if (_arrowHeightOrWidth == -1) {
        self.config = self.config ?: [[HDPopViewConfig alloc] init];
        CGFloat heightOrWidth = sqrt(pow(self.config.arrowSideLength, 2) - pow(self.config.arrowBottomSideLength * 0.5, 2));
        _arrowHeightOrWidth = heightOrWidth;
    }
    return _arrowHeightOrWidth;
}

#pragma mark - UI
- (void)setupContentView {
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }

    if (!_config)
        return;

    // 重新计算一次
    self.arrowHeightOrWidth = -1;

    [self addSubview:self.contentView];
    self.contentView.backgroundColor = self.config.contentBackgroundColor;
    self.contentView.layer.cornerRadius = self.config.cornerRadius;

    [self.contentView addSubview:self.textLabel];
    self.textLabel.textColor = self.config.textColor;
    self.textLabel.font = self.config.textFont;
    self.textLabel.text = self.config.text;
    self.textLabel.hd_edgeInsets = self.config.edgeInsets;

    // 计算文字尺寸
    CGSize textSize = self.textLabelSize;
    self.textLabel.frame = (CGRect){0, 0, textSize};

    self.contentView.frame = (CGRect){0, 0, textSize.width, textSize.height};
}

- (void)setupFrameFromView:(UIView *)fromView {
    const CGSize contentSize = self.contentView.bounds.size;

    CGRect fromRect = [fromView convertRect:fromView.bounds toView:self.containerView];

    const CGFloat outerWidth = self.containerView.bounds.size.width;
    const CGFloat outerHeight = self.containerView.bounds.size.height;

    const CGFloat minX = CGRectGetMinX(fromRect);
    const CGFloat maxX = CGRectGetMaxX(fromRect);
    const CGFloat midX = CGRectGetMidX(fromRect);
    const CGFloat minY = CGRectGetMinY(fromRect);
    const CGFloat maxY = CGRectGetMaxY(fromRect);
    const CGFloat midY = CGRectGetMidY(fromRect);

    const CGFloat widthPlusArrow = contentSize.width + self.arrowHeightOrWidth;
    const CGFloat heightPlusArrow = contentSize.height + self.arrowHeightOrWidth;
    const CGFloat widthHalf = contentSize.width * 0.5f;
    const CGFloat heightHalf = contentSize.height * 0.5f;

    const CGFloat kMargin = 5.f;

    if (heightPlusArrow < minY) { // 优先箭头向下
        _arrowDirection = HDPopViewArrowDirectionDown;

        CGPoint point = (CGPoint){midX - widthHalf, minY - heightPlusArrow};

        if (point.x < kMargin)
            point.x = kMargin;

        if ((point.x + contentSize.width + kMargin) > outerWidth)
            point.x = outerWidth - contentSize.width - kMargin;

        _arrowPosition = midX - point.x;
        _contentView.frame = (CGRect){CGPointZero, contentSize};

        self.layer.anchorPoint = CGPointMake(_arrowPosition / contentSize.width, 1);
        self.frame = (CGRect){point, contentSize.width, contentSize.height + self.arrowHeightOrWidth};
    } else if (heightPlusArrow < (outerHeight - maxY)) { // 箭头向上次之
        _arrowDirection = HDPopViewArrowDirectionUp;
        CGPoint point = (CGPoint){midX - widthHalf, maxY};

        if (point.x < kMargin)
            point.x = kMargin;

        if ((point.x + contentSize.width + kMargin) > outerWidth)
            point.x = outerWidth - contentSize.width - kMargin;

        _arrowPosition = midX - point.x;

        _contentView.frame = (CGRect){0, self.arrowHeightOrWidth, contentSize};

        self.layer.anchorPoint = CGPointMake(_arrowPosition / contentSize.width, 0);
        self.frame = (CGRect){point, contentSize.width, contentSize.height + self.arrowHeightOrWidth};
    } else if (widthPlusArrow < (outerWidth - maxX)) { // 箭头向左次之
        _arrowDirection = HDPopViewArrowDirectionLeft;
        CGPoint point = (CGPoint){maxX, midY - heightHalf};

        if (point.y < kMargin)
            point.y = kMargin;

        if ((point.y + contentSize.height + kMargin) > outerHeight)
            point.y = outerHeight - contentSize.height - kMargin;

        _arrowPosition = midY - point.y;
        _contentView.frame = (CGRect){self.arrowHeightOrWidth, 0, contentSize};

        self.layer.anchorPoint = CGPointMake(0, _arrowPosition / contentSize.height);
        self.frame = (CGRect){point, contentSize.width + self.arrowHeightOrWidth, contentSize.height};

    } else if (widthPlusArrow < minX) { // 箭头向右最后
        _arrowDirection = HDPopViewArrowDirectionRight;
        CGPoint point = (CGPoint){minX - widthPlusArrow, midY - heightHalf};

        if (point.y < kMargin)
            point.y = kMargin;

        if ((point.y + contentSize.height + kMargin) > outerHeight)
            point.y = outerHeight - contentSize.height - kMargin;

        _arrowPosition = midY - point.y;
        _contentView.frame = (CGRect){CGPointZero, contentSize};

        self.layer.anchorPoint = CGPointMake(1, _arrowPosition / contentSize.height);
        self.frame = (CGRect){point, contentSize.width + self.arrowHeightOrWidth, contentSize.height};
    } else {
        _arrowDirection = HDPopViewArrowDirectionNone;
        self.frame = (CGRect){
            (outerWidth - contentSize.width) * 0.5f,
            (outerHeight - contentSize.height) * 0.5f,
            contentSize,
        };
    }
    [self setNeedsDisplay];
}

#pragma mark - draw
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    if (self.arrowHeightOrWidth <= 0)
        return;

    const CGFloat w = self.frame.size.width, h = self.frame.size.height;

    UIBezierPath *path = [UIBezierPath bezierPath];
    if (_arrowDirection == HDPopViewArrowDirectionDown) {
        // 箭头
        [path moveToPoint:CGPointMake(_arrowPosition, h)];
        [path addLineToPoint:CGPointMake(_arrowPosition - self.config.arrowBottomSideLength * 0.5, h - self.arrowHeightOrWidth)];
        [path addLineToPoint:CGPointMake(_arrowPosition + self.config.arrowBottomSideLength * 0.5, h - self.arrowHeightOrWidth)];
        [path addLineToPoint:CGPointMake(_arrowPosition, h)];
    } else if (_arrowDirection == HDPopViewArrowDirectionUp) {
        // 箭头
        [path moveToPoint:CGPointMake(_arrowPosition, 0)];
        [path addLineToPoint:CGPointMake(_arrowPosition - self.config.arrowBottomSideLength * 0.5, self.arrowHeightOrWidth)];
        [path addLineToPoint:CGPointMake(_arrowPosition + self.config.arrowBottomSideLength * 0.5, self.arrowHeightOrWidth)];
        [path addLineToPoint:CGPointMake(_arrowPosition, 0)];
    } else if (_arrowDirection == HDPopViewArrowDirectionLeft) {
        // 箭头
        [path moveToPoint:CGPointMake(0, _arrowPosition)];
        [path addLineToPoint:CGPointMake(self.arrowHeightOrWidth, _arrowPosition - self.config.arrowBottomSideLength * 0.5)];
        [path addLineToPoint:CGPointMake(self.arrowHeightOrWidth, _arrowPosition + self.config.arrowBottomSideLength * 0.5)];
        [path addLineToPoint:CGPointMake(0, _arrowPosition)];
    } else if (_arrowDirection == HDPopViewArrowDirectionRight) {
        // 箭头
        [path moveToPoint:CGPointMake(w, _arrowPosition)];
        [path addLineToPoint:CGPointMake(w - self.arrowHeightOrWidth, _arrowPosition - self.config.arrowBottomSideLength * 0.5)];
        [path addLineToPoint:CGPointMake(w - self.arrowHeightOrWidth, _arrowPosition + self.config.arrowBottomSideLength * 0.5)];
        [path addLineToPoint:CGPointMake(w, _arrowPosition)];
    }
    [path closePath];

    // 设置填充颜色
    UIColor *fillColor = self.config.contentBackgroundColor;
    [fillColor set];
    [path fill];
}

#pragma mark - lazy load
- (SALabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[SALabel alloc] init];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.numberOfLines = 0;
    }
    return _textLabel;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = UIView.new;
    }
    return _contentView;
}
@end
