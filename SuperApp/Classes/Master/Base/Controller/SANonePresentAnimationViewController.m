//
//  SANonePresentAnimationViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/5/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SANonePresentAnimationViewController.h"
#import "SAPresentViewControllerNoneAnimatedTransitioning.h"


@interface SANonePresentAnimationViewController () <UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) SAPresentViewControllerNoneAnimatedTransitioning *transitioning;

@end


@implementation SANonePresentAnimationViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.transitioning = [[SAPresentViewControllerNoneAnimatedTransitioning alloc] init];

        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    return self;
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    return self.transitioning;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self.transitioning;
}

@end
