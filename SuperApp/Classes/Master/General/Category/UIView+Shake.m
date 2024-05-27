//
//  UIView+Shake.m
//  SuperApp
//
//  Created by VanJay on 2020/4/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "UIView+Shake.h"


@implementation UIView (Shake)

- (void)shake {
    [self _shake:10 direction:1 currentTimes:0 withDelta:5 speed:0.03 shakeDirection:ShakeDirectionHorizontal shouldShuttle:true completion:nil];
}

- (void)shake:(int)times withDelta:(CGFloat)delta {
    [self _shake:times direction:1 currentTimes:0 withDelta:delta speed:0.03 shakeDirection:ShakeDirectionHorizontal shouldShuttle:true completion:nil];
}

- (void)shake:(int)times withDelta:(CGFloat)delta completion:(void (^)(void))handler {
    [self _shake:times direction:1 currentTimes:0 withDelta:delta speed:0.03 shakeDirection:ShakeDirectionHorizontal shouldShuttle:true completion:handler];
}

- (void)shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval {
    [self _shake:times direction:1 currentTimes:0 withDelta:delta speed:interval shakeDirection:ShakeDirectionHorizontal shouldShuttle:true completion:nil];
}

- (void)shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval completion:(void (^)(void))handler {
    [self _shake:times direction:1 currentTimes:0 withDelta:delta speed:interval shakeDirection:ShakeDirectionHorizontal shouldShuttle:true completion:handler];
}

- (void)shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(ShakeDirection)shakeDirection {
    [self _shake:times direction:1 currentTimes:0 withDelta:delta speed:interval shakeDirection:shakeDirection shouldShuttle:true completion:nil];
}

- (void)shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(ShakeDirection)shakeDirection completion:(void (^)(void))completion {
    [self _shake:times direction:1 currentTimes:0 withDelta:delta speed:interval shakeDirection:shakeDirection shouldShuttle:true completion:completion];
}

- (void)shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(ShakeDirection)shakeDirection shouldShuttle:(BOOL)shouldShuttle {
    [self _shake:times direction:1 currentTimes:0 withDelta:delta speed:interval shakeDirection:shakeDirection shouldShuttle:shouldShuttle completion:nil];
}

- (void)shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(ShakeDirection)shakeDirection shouldShuttle:(BOOL)shouldShuttle completion:(void (^)(void))completion {
    [self _shake:times direction:1 currentTimes:0 withDelta:delta speed:interval shakeDirection:shakeDirection shouldShuttle:shouldShuttle completion:completion];
}

- (void)_shake:(int)times
         direction:(int)direction
      currentTimes:(int)current
         withDelta:(CGFloat)delta
             speed:(NSTimeInterval)interval
    shakeDirection:(ShakeDirection)shakeDirection
     shouldShuttle:(BOOL)shouldShuttle
        completion:(void (^)(void))completionHandler {
    [UIView animateWithDuration:interval animations:^{
        self.layer.affineTransform = (shakeDirection == ShakeDirectionHorizontal) ? CGAffineTransformMakeTranslation(shouldShuttle ? delta * direction : (direction == 1 ? delta * direction : 0), 0) :
                                                                                    CGAffineTransformMakeTranslation(0, shouldShuttle ? delta * direction : (direction == 1 ? delta * direction : 0));
    } completion:^(BOOL finished) {
        if (current >= times) {
            [UIView animateWithDuration:interval animations:^{
                self.layer.affineTransform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                if (completionHandler != nil) {
                    completionHandler();
                }
            }];
            return;
        }
        [self _shake:(times - 1) direction:direction * -1 currentTimes:current + 1 withDelta:delta speed:interval shakeDirection:shakeDirection shouldShuttle:shouldShuttle
                completion:completionHandler];
    }];
}

@end
