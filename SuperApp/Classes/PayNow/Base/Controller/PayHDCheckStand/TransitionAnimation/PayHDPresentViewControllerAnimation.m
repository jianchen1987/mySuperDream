
//
//  PayHDPresentViewControllerAnimation.m
//  customer
//
//  Created by VanJay on 2019/5/15.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "PayHDPresentViewControllerAnimation.h"
#import "HDAppTheme+PayNow.h"
#import <HDKitCore/HDCommonDefines.h>

CGFloat kPayHDPresentDefaultTransitionDuration = 0.3;


@interface PayHDPresentViewControllerAnimation ()
@property (nonatomic, strong) UIView *shadowView; ///< 阴影
@end


@implementation PayHDPresentViewControllerAnimation

- (instancetype)init {
    self = [super init];
    if (self) {
        // 默认
        self.presentingStyle = PayHDPresentVCAnimationPresentingStyleFromBottom;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return kPayHDPresentDefaultTransitionDuration;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    NSTimeInterval duration = [self transitionDuration:transitionContext];

    if (fromViewController.isBeingDismissed) {
        // dismiss
        CGRect finalFrame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);

        switch (self.dismissStyle) {
            case PayHDPresentVCAnimationDismissStyleToBottom: {
                [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    fromViewController.view.transform = CGAffineTransformMakeTranslation(0, fromViewController.preferredContentSize.height);
                    self.shadowView.alpha = 0;
                } completion:^(BOOL finished) {
                    [fromViewController.view removeFromSuperview];
                    [self.shadowView removeFromSuperview];

                    BOOL wasCancelled = [transitionContext transitionWasCancelled];
                    [transitionContext completeTransition:!wasCancelled];
                }];
            } break;

            case PayHDPresentVCAnimationDismissStyleToBottomBackVCZoomOut: {
                [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    CATransform3D transform = toViewController.view.layer.transform;
                    // transform.m34 = 1.0 / 2000.f;
                    // transform = CATransform3DRotate(transform, -M_PI / 180 * 20.f, 1, 0, 0);
                    toViewController.view.layer.transform = transform;

                    fromViewController.view.transform = CGAffineTransformMakeTranslation(0, fromViewController.preferredContentSize.height);
                    self.shadowView.alpha = 0;
                    toViewController.view.alpha = 1;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        toViewController.view.layer.transform = CATransform3DIdentity;
                        toViewController.view.frame = finalFrame;
                    } completion:^(BOOL finished) {
                        [fromViewController.view removeFromSuperview];
                        [self.shadowView removeFromSuperview];

                        BOOL wasCancelled = [transitionContext transitionWasCancelled];
                        [transitionContext completeTransition:!wasCancelled];
                    }];
                }];
            } break;

            case PayHDPresentVCAnimationDismissStyleNone: {
                BOOL isFromVCCustomSize = !CGSizeEqualToSize(fromViewController.preferredContentSize, CGSizeZero);

                if (!isFromVCCustomSize) {
                    [fromViewController.view removeFromSuperview];

                    BOOL wasCancelled = [transitionContext transitionWasCancelled];
                    [transitionContext completeTransition:!wasCancelled];
                } else {
                    [UIView animateWithDuration:duration animations:^{
                        self.shadowView.alpha = 0;
                    } completion:^(BOOL finished) {
                        [fromViewController.view removeFromSuperview];
                        [self.shadowView removeFromSuperview];

                        BOOL wasCancelled = [transitionContext transitionWasCancelled];
                        [transitionContext completeTransition:!wasCancelled];
                    }];
                }
            } break;

            default:
                break;
        }

    } else {
        // present
        UIView *shadowView = [[UIView alloc] init];

        BOOL isToVCCustomSize = !CGSizeEqualToSize(toViewController.preferredContentSize, CGSizeZero);

        // 获取状态栏高度
        CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
        BOOL isHotspotConnected = CGRectGetHeight(statusBarFrame) == (kStatusBarH + kHotSpotStatusBarH) ? YES : NO;

        CGFloat y = kScreenHeight - toViewController.preferredContentSize.height;
        if (isHotspotConnected) {
            y = y - kHotSpotStatusBarH;
        }

        CGRect finalFrame = CGRectMake(0, y, toViewController.preferredContentSize.width, toViewController.preferredContentSize.height);
        if (isToVCCustomSize) {
            shadowView.backgroundColor = [HDAppTheme.PayNowColor.c000000 colorWithAlphaComponent:0.4];
            self.shadowView = shadowView;

            shadowView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            [transitionContext.containerView addSubview:shadowView];
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedShadowView)];
            [shadowView addGestureRecognizer:recognizer];

            [transitionContext.containerView addSubview:toViewController.view];

            toViewController.view.frame = finalFrame;
        }

        switch (self.presentingStyle) {
            case PayHDPresentVCAnimationPresentingStyleFromBottom: {
                shadowView.alpha = 0;
                toViewController.view.transform = CGAffineTransformMakeTranslation(0, finalFrame.size.height);

                [UIView animateWithDuration:2 * duration delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.5 options:UIViewAnimationOptionLayoutSubviews animations:^{
                    toViewController.view.transform = CGAffineTransformIdentity;
                    shadowView.alpha = 1;
                } completion:^(BOOL finished) {
                    BOOL wasCancelled = [transitionContext transitionWasCancelled];
                    [transitionContext completeTransition:!wasCancelled];
                }];
            } break;

            case PayHDPresentVCAnimationPresentingStyleFromBottomBackVCZoomIn: {
                shadowView.alpha = 0;
                [transitionContext.containerView sendSubviewToBack:fromViewController.view];
                toViewController.view.transform = CGAffineTransformMakeTranslation(0, finalFrame.size.height);
                [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    CATransform3D transform = CATransform3DIdentity;
                    // transform.m34 = 1.0 / 2000.f;
                    // transform = CATransform3DRotate(transform, -M_PI / 180 * 20.f, 1, 0, 0);
                    fromViewController.view.layer.transform = transform;
                    shadowView.alpha = 1;
                    fromViewController.view.alpha = 0.4;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        toViewController.view.transform = CGAffineTransformIdentity;

                        CGFloat xScale = 1 - 2 * 18.f / kScreenWidth;
                        CGFloat yScale = 1 - 2 * 20.f / kScreenHeight;

                        CATransform3D transform = CATransform3DMakeScale(xScale, yScale, 1);
                        fromViewController.view.layer.transform = transform;
                    } completion:^(BOOL finished) {
                        BOOL wasCancelled = [transitionContext transitionWasCancelled];
                        [transitionContext completeTransition:!wasCancelled];
                    }];
                }];
            } break;

            case PayHDPresentVCAnimationPresentingStyleNone: {
                [transitionContext.containerView addSubview:toViewController.view];
                if (!isToVCCustomSize) {
                    toViewController.view.frame = transitionContext.containerView.bounds;

                    BOOL wasCancelled = [transitionContext transitionWasCancelled];
                    [transitionContext completeTransition:!wasCancelled];
                } else {
                    toViewController.view.frame = finalFrame;

                    shadowView.alpha = 0;
                    [UIView animateWithDuration:duration animations:^{
                        shadowView.alpha = 1;
                    } completion:^(BOOL finished) {
                        BOOL wasCancelled = [transitionContext transitionWasCancelled];
                        [transitionContext completeTransition:!wasCancelled];
                    }];
                }
            } break;

            default:
                break;
        }
    }
}

#pragma mark - event response
- (void)tappedShadowView {
    !self.tappedShadowHandler ?: self.tappedShadowHandler();
}

#pragma mark - getters and setters
- (void)setPresentingStyle:(PayHDPresentVCAnimationStyle)presentingStyle {
    if (_presentingStyle == presentingStyle)
        return;

    _presentingStyle = presentingStyle;

    if (presentingStyle == PayHDPresentVCAnimationPresentingStyleFromBottom) {
        _dismissStyle = PayHDPresentVCAnimationDismissStyleToBottom;
    } else if (presentingStyle == PayHDPresentVCAnimationPresentingStyleFromBottomBackVCZoomIn) {
        _dismissStyle = PayHDPresentVCAnimationDismissStyleToBottomBackVCZoomOut;
    } else if (presentingStyle == PayHDPresentVCAnimationPresentingStyleNone) {
        _dismissStyle = PayHDPresentVCAnimationDismissStyleNone;
    }
}

- (void)setDismissStyle:(PayHDPresentVCAnimationStyle)dismissStyle {
    if (_dismissStyle == dismissStyle)
        return;

    _dismissStyle = dismissStyle;

    if (dismissStyle == PayHDPresentVCAnimationDismissStyleToBottom) {
        _presentingStyle = PayHDPresentVCAnimationPresentingStyleFromBottom;
    } else if (dismissStyle == PayHDPresentVCAnimationDismissStyleToBottomBackVCZoomOut) {
        _presentingStyle = PayHDPresentVCAnimationPresentingStyleFromBottomBackVCZoomIn;
    } else if (dismissStyle == PayHDPresentVCAnimationDismissStyleNone) {
        _presentingStyle = PayHDPresentVCAnimationPresentingStyleNone;
    }
}
@end
