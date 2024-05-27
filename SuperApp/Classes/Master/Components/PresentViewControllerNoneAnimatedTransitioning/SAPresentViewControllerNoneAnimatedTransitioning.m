//
//  SAPresentViewControllerNoneAnimatedTransitioning.m
//  SuperApp
//
//  Created by VanJay on 2020/5/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAPresentViewControllerNoneAnimatedTransitioning.h"
#import "SAView.h"

CGFloat kHDPresentDefaultTransitionDuration = 0.3;


@interface SAPresentViewControllerNoneAnimatedTransitioning ()
/// 阴影
@property (nonatomic, strong) UIView *shadowView;
@end


@implementation SAPresentViewControllerNoneAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return kHDPresentDefaultTransitionDuration;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    NSTimeInterval duration = [self transitionDuration:transitionContext];

    if (fromViewController.isBeingDismissed) {
        // dismiss
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
            shadowView.backgroundColor = HDColor(0, 0, 0, 0.4);
            self.shadowView = shadowView;

            shadowView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            [transitionContext.containerView addSubview:shadowView];
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedShadowView)];
            [shadowView addGestureRecognizer:recognizer];

            [transitionContext.containerView addSubview:toViewController.view];

            toViewController.view.frame = finalFrame;
        }

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
    }
}

#pragma mark - event response
- (void)tappedShadowView {
    !self.tappedShadowHandler ?: self.tappedShadowHandler();
}
@end
