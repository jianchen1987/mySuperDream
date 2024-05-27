
//
//  HDPopTipView.m
//  SuperApp
//
//  Created by VanJay on 2019/6/26.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDPopTipView.h"
#import "HDPopTipConfig.h"
#import "SALabel.h"
#import "UIView+FrameChangedHandler.h"
#import "UIView+Shake.h"
#import <HDVendorKit/HDWebImageManager.h>
#import <HDKitCore/HDKitCore.h>


@interface HDPopTipOverlay : UIView
@property (nonatomic, strong) UIButton *button; ///< 占据整个 overlay 的按钮，方便接收 event
@end


@implementation HDPopTipOverlay

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
        if ([v isKindOfClass:[HDPopTipView class]] && [v respondsToSelector:@selector(dismissAnimated:)]) {
            HDPopTipView *finalV = (HDPopTipView *)v;
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
typedef NS_ENUM(NSUInteger, HDPopTipViewArrowDirection) {
    HDPopTipViewArrowDirectionNone = 0,
    HDPopTipViewArrowDirectionUp,
    HDPopTipViewArrowDirectionDown,
    HDPopTipViewArrowDirectionLeft,
    HDPopTipViewArrowDirectionRight,
};


@interface HDPopTipView ()
@property (nonatomic, assign) HDPopTipViewArrowDirection arrowDirection; ///< 箭头方向
@property (nonatomic, assign) CGFloat arrowPosition;                     ///< 箭头顶点
@property (nonatomic, strong) SALabel *textLabel;                        ///< 文字
@property (nonatomic, strong) HDPopTipConfig *config;                    ///< 配置
@property (nonatomic, strong) UIView *contentView;                       ///< 内容
@property (nonatomic, strong) HDPopTipOverlay *overLay;                  ///< 遮罩
@property (nonatomic, strong) UIImageView *maskImageView;                ///< 背景图片
@property (nonatomic, strong) UIImageView *arrowImageView;               ///< 箭头图片
@property (nonatomic, strong) SDAnimatedImageView *animatedImageView;    ///< 真正的图片
@property (nonatomic, weak) UIView *containerView;                       ///< 容器
@property (nonatomic, copy) NSArray<HDPopTipConfig *> *leftConfigs;      ///< 当前剩余要展示的配置
@property (nonatomic, strong) UIImage *maskImageForSourceView;           ///< mask 图

@end


@implementation HDPopTipView
- (void)dealloc {
    HDLog(@"HDPopTipView -- dealloc");
}

#pragma mark - public methods
- (void)showPopTipInView:(UIView *__nullable)view fromView:(UIView *)fromView config:(HDPopTipConfig *__nullable)config {
    config = config ?: [[HDPopTipConfig alloc] init];
    if (!fromView)
        return;
    config.sourceView = fromView;
    [self showPopTipInView:view configs:@[config] onlyInControllerClass:nil];
}

- (void)showPopTipInView:(UIView *__nullable)view configs:(NSArray<HDPopTipConfig *> *)configs onlyInControllerClass:(Class __nullable)controllerClass {
    __block UIView *_view = view;
    @HDWeakify(self);
    [HDAlertQueueManager showWithObserver:self priority:HDAlertQueuePriorityNormal showInController:controllerClass showBlock:^{
        @HDStrongify(self);
        _view = view ?: [UIApplication sharedApplication].keyWindow;
        self.containerView = _view;

        if (configs.count <= 0)
            return;

        // 添加背景
        HDPopTipOverlay *overLay = [[HDPopTipOverlay alloc] initWithFrame:_view.bounds];
        [overLay addSubview:self];
        [_view addSubview:overLay];
        self.overLay = overLay;

        // 背景由暗变明
        self.overLay.alpha = 0;
        [UIView animateWithDuration:0.3 animations:^(void) {
            self.overLay.alpha = 1;
        }];
        [self startShowPopWithConfigs:configs shouldShowFirst:true];
    } dismissBlock:^{
        @HDStrongify(self);
        [self dismissAnimated:true];
    }];
}

- (void)setCurrentConfigs:(NSArray<HDPopTipConfig *> *)configs onlyInControllerClass:(Class __nullable)controllerClass {
    @HDWeakify(self);
    [HDAlertQueueManager showWithObserver:self priority:HDAlertQueuePriorityNormal showInController:controllerClass showBlock:^{
        @HDStrongify(self);
        [self startShowPopWithConfigs:configs shouldShowFirst:false];
    } dismissBlock:^{
        @HDStrongify(self);
        [self dismissAnimated:true];
    }];
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
                if ([self.superview isKindOfClass:[HDPopTipOverlay class]])
                    [self.superview removeFromSuperview];
                [self removeFromSuperview];
            }];

        } else {
            if (shouldCallDismissHandler) {
                !self.dismissHandler ?: self.dismissHandler();
            }
            if ([self.superview isKindOfClass:[HDPopTipOverlay class]])
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
    if (_arrowDirection == HDPopTipViewArrowDirectionUp || _arrowDirection == HDPopTipViewArrowDirectionDown) {
        shakeDirection = ShakeDirectionVertical;
    } else if (_arrowDirection == HDPopTipViewArrowDirectionLeft || _arrowDirection == HDPopTipViewArrowDirectionRight) {
        shakeDirection = ShakeDirectionHorizontal;
    }

    BOOL isArrowLeftOrTop = self.arrowDirection == HDPopTipViewArrowDirectionUp || self.arrowDirection == HDPopTipViewArrowDirectionLeft;

    [self.contentView shake:(int)(self.config.shakeCount) withDelta:self.config.shakeDistance * (isArrowLeftOrTop ? 1 : -1)speed:self.config.shakeDuration shakeDirection:shakeDirection
              shouldShuttle:false completion:^{
                  if (self.config.autoDismiss) {
                      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.config.autoDismissDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                          [self simulateTouchOverLayView];
                      });
                  }
              }];
}

/// 模拟按下背景
- (void)simulateTouchOverLayView {
    HDPopTipOverlay *overlayView = (HDPopTipOverlay *)self.superview;
    if ([overlayView isKindOfClass:HDPopTipOverlay.class]) {
        [overlayView.button sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

/// 开始展示
/// @param configs 所有配置
/// @param shouldShowFirst 是否直接开始展示第一个
- (void)startShowPopWithConfigs:(NSArray<HDPopTipConfig *> *)configs shouldShowFirst:(BOOL)shouldShowFirst {
    // 直接显示第一个
    NSMutableArray<HDPopTipConfig *> *originConfigs = [NSMutableArray arrayWithArray:configs];
    if (shouldShowFirst) {
        [self showPopViewWithConfig:originConfigs.firstObject];
    }
    self.leftConfigs = originConfigs.copy;

    __weak __typeof(self) weakSelf = self;
    // 点击了界面的回调，决定显示下一个或者消失
    self.tappedHandler = ^{
        // 移除无效的
        [originConfigs filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(HDPopTipConfig *_Nullable config, NSDictionary<NSString *, id> *_Nullable bindings) {
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
- (void)showPopViewWithConfig:(HDPopTipConfig *)config {
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

        [strongSelf setupFrameFromView:strongConfig.sourceView];

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

#pragma mark - UI
- (void)setupContentView {
    self.userInteractionEnabled = false;
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }

    if (!_config)
        return;

    // 使懒加载再次进入
    self.maskImageForSourceView = nil;

    [self addSubview:self.contentView];
    [self.contentView addSubview:self.textLabel];
    self.textLabel.textColor = self.config.textColor;
    self.textLabel.font = self.config.textFont;
    self.textLabel.text = self.config.text;
    self.textLabel.hd_edgeInsets = self.config.edgeInsets;

    // 箭头
    [self.contentView addSubview:self.arrowImageView];

    if (self.maskImageForSourceView) {
        // mask 图
        [self addSubview:self.maskImageView];
        self.maskImageView.image = self.maskImageForSourceView;
    }
    if (self.config.imageURL && self.config.imageURL.length > 0) {
        [self.maskImageView addSubview:self.animatedImageView];
        [HDWebImageManager setGIFImageWithURL:self.config.imageURL placeholderImage:HDHelper.circlePlaceholderImage imageView:self.animatedImageView];
    }
}

- (void)setupFrameFromView:(UIView *)fromView {
    const CGSize contentSize = self.textLabelSize;
    CGRect fromRect = [fromView convertRect:fromView.bounds toView:self.containerView];

    const CGFloat outerWidth = self.containerView.bounds.size.width;
    const CGFloat outerHeight = self.containerView.bounds.size.height;

    const CGFloat minX = CGRectGetMinX(fromRect);
    const CGFloat maxX = CGRectGetMaxX(fromRect);
    const CGFloat midX = CGRectGetMidX(fromRect);
    const CGFloat minY = CGRectGetMinY(fromRect);
    const CGFloat maxY = CGRectGetMaxY(fromRect);
    const CGFloat midY = CGRectGetMidY(fromRect);

    const CGFloat widthHalf = contentSize.width * 0.5f;
    const CGFloat heightHalf = contentSize.height * 0.5f;

    const CGFloat kMargin = 5.f;
    const CGSize maskImageViewSize = self.maskImageViewSize;
    const CGSize textLabelSize = self.textLabelSize;
    const CGSize sourceViewSize = self.minusSizeBetweenMaskImageSizeAndSourceViewSize;

    const CGFloat upContentHeight = contentSize.height + [self arrowHeightOrWidthForDirection:HDPopTipViewArrowDirectionUp];
    const CGFloat downContentHeight = contentSize.height + [self arrowHeightOrWidthForDirection:HDPopTipViewArrowDirectionDown];
    const CGFloat leftContentWidth = contentSize.width + [self arrowHeightOrWidthForDirection:HDPopTipViewArrowDirectionLeft];
    const CGFloat rightContentWidth = contentSize.width + [self arrowHeightOrWidthForDirection:HDPopTipViewArrowDirectionRight];
    if (upContentHeight < (outerHeight - maxY)) { // 优先箭头向上
        self.arrowDirection = HDPopTipViewArrowDirectionUp;
        CGPoint point = (CGPoint){midX - widthHalf, maxY};

        if (point.x < kMargin)
            point.x = kMargin;

        if ((point.x + contentSize.width + kMargin) > outerWidth)
            point.x = outerWidth - contentSize.width - kMargin;

        _arrowPosition = midX - point.x;

        self.layer.anchorPoint = CGPointMake(_arrowPosition / contentSize.width, 0);
        CGFloat selfHeight = upContentHeight;

        if (self.maskImageForSourceView) {
            point.y -= (maskImageViewSize.height - sourceViewSize.height * 0.5);
            selfHeight += maskImageViewSize.height;
        }
        [self hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            make.size.hd_equalTo(CGSizeMake(contentSize.width, selfHeight));
            make.origin.hd_equalTo(point);
        }];

        if (self.maskImageForSourceView) {
            [self.maskImageView hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
                make.size.hd_equalTo(maskImageViewSize);
                make.centerX.hd_equalTo(self.arrowPosition);
                make.top.hd_equalTo(0);
            }];
        }

        [self.contentView hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            if (self.maskImageForSourceView) {
                make.top.hd_equalTo(CGRectGetMaxY(self.maskImageView.frame));
            } else {
                make.top.hd_equalTo(0);
            }
            make.size.hd_equalTo(CGSizeMake(contentSize.width, upContentHeight));
            make.left.hd_equalTo(0);
        }];

        [self.arrowImageView hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            make.size.hd_equalTo(self.arrowImageView.image.size);
            make.centerX.hd_equalTo(self.arrowPosition);
            make.top.hd_equalTo(0);
        }];

        [self.textLabel hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            make.size.hd_equalTo(textLabelSize);
            make.left.hd_equalTo(0);
            make.top.hd_equalTo(CGRectGetMaxY(self.arrowImageView.frame));
        }];
    } else if (downContentHeight < minY) { // 箭头向下次之
        self.arrowDirection = HDPopTipViewArrowDirectionDown;
        CGPoint point = (CGPoint){midX - widthHalf, minY - downContentHeight};

        if (point.x < kMargin)
            point.x = kMargin;

        if ((point.x + contentSize.width + kMargin) > outerWidth)
            point.x = outerWidth - contentSize.width - kMargin;

        _arrowPosition = midX - point.x;
        self.layer.anchorPoint = CGPointMake(_arrowPosition / contentSize.width, 1);

        CGFloat selfHeight = downContentHeight;

        if (self.maskImageForSourceView) {
            selfHeight += maskImageViewSize.height;
        }

        if (selfHeight + point.y > CGRectGetHeight(self.containerView.frame)) {
            CGFloat minus = selfHeight + point.y - CGRectGetHeight(self.containerView.frame);
            // 上移差值
            point.y -= minus;
        }

        [self hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            make.size.hd_equalTo(CGSizeMake(contentSize.width, selfHeight));
            make.origin.hd_equalTo(point);
        }];

        if (self.maskImageForSourceView) {
            [self.maskImageView hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
                make.size.hd_equalTo(maskImageViewSize);
                make.centerX.hd_equalTo(self.arrowPosition);
                make.bottom.hd_equalTo(CGRectGetHeight(self.frame));
            }];
        }

        [self.contentView hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            make.top.hd_equalTo(0);
            make.size.hd_equalTo(CGSizeMake(contentSize.width, downContentHeight));
            make.left.hd_equalTo(0);
        }];

        [self.arrowImageView hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            make.size.hd_equalTo(self.arrowImageView.image.size);
            make.centerX.hd_equalTo(self.arrowPosition);
            make.bottom.hd_equalTo(CGRectGetHeight(self.contentView.frame));
        }];

        [self.textLabel hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            make.size.hd_equalTo(textLabelSize);
            make.left.hd_equalTo(0);
            make.top.hd_equalTo(0);
        }];
    } else if (leftContentWidth < (outerWidth - maxX)) { // 箭头向左次之
        self.arrowDirection = HDPopTipViewArrowDirectionLeft;
        CGPoint point = (CGPoint){maxX, midY - heightHalf};

        if (point.y < kMargin)
            point.y = kMargin;

        if ((point.y + contentSize.height + kMargin) > outerHeight)
            point.y = outerHeight - contentSize.height - kMargin;

        _arrowPosition = midY - point.y;

        self.layer.anchorPoint = CGPointMake(0, _arrowPosition / contentSize.height);
        CGFloat selfWidth = leftContentWidth;

        if (self.maskImageForSourceView) {
            selfWidth += maskImageViewSize.width;
            point.x -= (maskImageViewSize.width - sourceViewSize.width * 0.5);
        }

        [self hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            make.size.hd_equalTo(CGSizeMake(selfWidth, contentSize.height));
            make.origin.hd_equalTo(point);
        }];

        if (self.maskImageForSourceView) {
            [self.maskImageView hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
                make.size.hd_equalTo(maskImageViewSize);
                make.centerY.hd_equalTo(self.arrowPosition);
                make.left.hd_equalTo(0);
            }];
        }

        [self.contentView hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            make.top.hd_equalTo(0);
            make.size.hd_equalTo(CGSizeMake(leftContentWidth, contentSize.height));
            if (self.maskImageForSourceView) {
                make.left.hd_equalTo(CGRectGetMaxX(self.maskImageView.frame));
            } else {
                make.left.hd_equalTo(0);
            }
        }];

        [self.arrowImageView hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            make.size.hd_equalTo(self.arrowImageView.image.size);
            make.centerY.hd_equalTo(self.arrowPosition);
            make.left.hd_equalTo(0);
        }];

        [self.textLabel hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            make.size.hd_equalTo(textLabelSize);
            make.left.hd_equalTo(CGRectGetMaxX(self.arrowImageView.frame));
            make.top.hd_equalTo(0);
        }];
    } else if (rightContentWidth < minX) { // 箭头向右最后
        self.arrowDirection = HDPopTipViewArrowDirectionRight;
        CGPoint point = (CGPoint){minX - rightContentWidth, midY - heightHalf};

        if (point.y < kMargin)
            point.y = kMargin;

        if ((point.y + contentSize.height + kMargin) > outerHeight)
            point.y = outerHeight - contentSize.height - kMargin;

        _arrowPosition = midY - point.y;

        self.layer.anchorPoint = CGPointMake(1, _arrowPosition / contentSize.height);

        CGFloat selfWidth = rightContentWidth;

        if (self.maskImageForSourceView) {
            selfWidth += maskImageViewSize.width;
            point.x -= (sourceViewSize.width * 0.5);
        }

        [self hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            make.size.hd_equalTo(CGSizeMake(selfWidth, contentSize.height));
            make.origin.hd_equalTo(point);
        }];

        [self.contentView hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            make.top.hd_equalTo(0);
            make.size.hd_equalTo(CGSizeMake(leftContentWidth, contentSize.height));
            make.left.hd_equalTo(0);
        }];

        if (self.maskImageForSourceView) {
            [self.maskImageView hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
                make.size.hd_equalTo(maskImageViewSize);
                make.centerY.hd_equalTo(self.arrowPosition);
                make.left.hd_equalTo(CGRectGetMaxX(self.contentView.frame));
            }];
        }

        [self.textLabel hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            make.size.hd_equalTo(textLabelSize);
            make.left.hd_equalTo(0);
            make.top.hd_equalTo(0);
        }];

        [self.arrowImageView hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            make.size.hd_equalTo(self.arrowImageView.image.size);
            make.centerY.hd_equalTo(self.arrowPosition);
            make.left.hd_equalTo(CGRectGetMaxX(self.textLabel.frame));
        }];
    } else {
        self.arrowDirection = HDPopTipViewArrowDirectionNone;

        [self hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            make.size.hd_equalTo(contentSize);
            make.origin.hd_equalTo(CGPointMake((outerWidth - contentSize.width) * 0.5, (outerHeight - contentSize.height) * 0.5));
        }];
    }
    if (self.config.imageURL && self.config.imageURL.length > 0) {
        [self.animatedImageView hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            make.center.hd_equalTo(CGPointMake(self.maskImageView.width * 0.5, self.maskImageView.height * 0.5));
            make.size.hd_equalTo(self.animatedImageViewSize);
        }];
    }
}

#pragma mark - getters and setters
- (void)setArrowDirection:(HDPopTipViewArrowDirection)arrowDirection {
    _arrowDirection = arrowDirection;

    [self setArrowImageForDirection:_arrowDirection];
}

- (CGFloat)arrowHeightOrWidthForDirection:(HDPopTipViewArrowDirection)direction {
    UIImage *image = [UIImage imageNamed:@"guide_arrow_up"];
    CGFloat heightOrWidth = image.size.height;
    if (direction == HDPopTipViewArrowDirectionDown) {
        image = [image hd_imageWithOrientation:UIImageOrientationDown];
        heightOrWidth = image.size.height;
    } else if (direction == HDPopTipViewArrowDirectionLeft) {
        image = [image hd_imageWithOrientation:UIImageOrientationLeft];
        heightOrWidth = image.size.width;
    } else if (direction == HDPopTipViewArrowDirectionRight) {
        image = [image hd_imageWithOrientation:UIImageOrientationRight];
        heightOrWidth = image.size.width;
    }
    return heightOrWidth;
}

- (void)setArrowImageForDirection:(HDPopTipViewArrowDirection)direction {
    UIImage *image = [UIImage imageNamed:@"guide_arrow_up"];
    if (direction == HDPopTipViewArrowDirectionDown) {
        image = [image hd_imageWithOrientation:UIImageOrientationDown];
    } else if (direction == HDPopTipViewArrowDirectionLeft) {
        image = [image hd_imageWithOrientation:UIImageOrientationLeft];
    } else if (direction == HDPopTipViewArrowDirectionRight) {
        image = [image hd_imageWithOrientation:UIImageOrientationRight];
    }
    self.arrowImageView.image = image;
}

- (CGSize)textLabelSize {
    // 计算文字尺寸
    CGFloat maxContentWidth = self.config.contentMaxWidth;
    // 不能超出容器宽度
    maxContentWidth = maxContentWidth > CGRectGetWidth(self.containerView.frame) ? CGRectGetWidth(self.containerView.frame) : maxContentWidth;
    // Label 最大宽度
    const CGFloat maxLabelWidth = maxContentWidth - self.config.edgeInsets.left - self.config.edgeInsets.right;

    if (!self.config.text || self.config.text.length <= 0)
        return CGSizeMake(maxLabelWidth, 20);

    CGSize textSize = [self.textLabel sizeThatFits:CGSizeMake(maxLabelWidth, CGFLOAT_MAX)];
    return CGSizeSafeSize(textSize);
}

- (CGSize)minusSizeBetweenMaskImageSizeAndSourceViewSize {
    CGSize maskImageViewSize = self.maskImageViewSize;
    CGSize sourceViewSize = self.config.sourceView.bounds.size;
    return CGSizeMake(maskImageViewSize.width - sourceViewSize.width, maskImageViewSize.height - sourceViewSize.height);
}

- (CGSize)maskImageViewSize {
    CGFloat height = CGRectGetHeight(self.config.sourceView.frame);
    if (self.config.needDrawMaskImageBackground) {
        height = sqrt(pow(height, 2) * 2);
    }
    const CGFloat imageViewHeight = height * ((isinf(self.config.maskImageHeightScale) || isnan(self.config.maskImageHeightScale)) ? 1 : self.config.maskImageHeightScale);
    const CGSize imageViewSize = CGSizeMake(imageViewHeight * self.maskImageForSourceView.size.width / self.maskImageForSourceView.size.height, imageViewHeight);
    return imageViewSize;
}

- (CGSize)animatedImageViewSize {
    CGFloat height = CGRectGetHeight(self.config.sourceView.frame);
    const CGFloat imageViewHeight = height * ((isinf(self.config.maskImageHeightScale) || isnan(self.config.maskImageHeightScale)) ? 1 : self.config.maskImageHeightScale);
    const CGSize imageViewSize = CGSizeMake(imageViewHeight * self.maskImageForSourceView.size.width / self.maskImageForSourceView.size.height, imageViewHeight);
    return imageViewSize;
}

- (NSArray<HDPopTipConfig *> *)currentLeftConfigs {
    return self.leftConfigs;
}

- (UIImage *)maskImageForSourceView {
    if (!_maskImageForSourceView) {
        UIImage *logoImage;
        if (self.config.maskImageViewForSourceView.image) {
            logoImage = self.config.maskImageViewForSourceView.image;
        } else {
            logoImage = self.config.maskImageForSourceView;
        }
        const CGFloat scale = UIScreen.mainScreen.scale;
        CGFloat imageW
            = self.config.maskImageViewForSourceView ? self.config.maskImageViewForSourceView.bounds.size.width : (logoImage ? logoImage.size.width : CGRectGetWidth(self.config.sourceView.frame));

        if (self.config.imageURL && self.config.imageURL.length > 0) {
            CGFloat bgImageW = sqrt(pow(imageW, 2) * 2);
            if (self.config.needDrawMaskImageBackground) {
                logoImage = [UIImage hd_imageWithColor:UIColor.whiteColor size:CGSizeMake(bgImageW * scale, bgImageW * scale) cornerRadius:bgImageW * 0.5 * scale];

            } else {
                logoImage = [UIImage hd_imageWithColor:UIColor.clearColor size:CGSizeMake(bgImageW * scale, bgImageW * scale) cornerRadius:bgImageW * 0.5 * scale];
            }
        } else {
            if (!logoImage) {
                _maskImageForSourceView = nil;
            } else {
                // 纠正图片尺寸
                logoImage = [logoImage hd_imageResizedWithScreenScaleInLimitedSize:CGSizeMake(imageW * scale, imageW * scale)];
                if (self.config.needDrawMaskImageBackground) {
                    CGFloat bgImageW = sqrt(pow(imageW, 2) * 2);
                    UIImage *bgImage = [UIImage hd_imageWithColor:UIColor.whiteColor size:CGSizeMake(bgImageW * scale, bgImageW * scale) cornerRadius:bgImageW * 0.5 * scale];
                    // 计算绘制点
                    CGPoint point = CGPointMake((bgImage.size.width - logoImage.size.width) * 0.5, (bgImage.size.height - logoImage.size.height) * 0.5);
                    logoImage = [bgImage hd_imageWithImageAbove:logoImage atPoint:point];
                }
            }
        }
        _maskImageForSourceView = logoImage;
    }
    return _maskImageForSourceView;
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

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = UIImageView.new;
    }
    return _arrowImageView;
}

- (UIImageView *)maskImageView {
    if (!_maskImageView) {
        _maskImageView = UIImageView.new;
    }
    return _maskImageView;
}

- (SDAnimatedImageView *)animatedImageView {
    if (!_animatedImageView) {
        _animatedImageView = SDAnimatedImageView.new;
        _animatedImageView.runLoopMode = NSRunLoopCommonModes;
    }
    return _animatedImageView;
}
@end
