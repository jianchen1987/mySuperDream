//
//  UIView+Shake.h
//  SuperApp
//
//  Created by VanJay on 2020/4/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ShakeDirection) { ShakeDirectionHorizontal = 0, ShakeDirectionVertical };


@interface UIView (Shake)

/** Shake the UIView
 *
 * Shake the view a default number of times
 */
- (void)shake;

/** Shake the UIView
 *
 * Shake the view a given number of times
 *
 * @param times The number of shakes
 * @param delta The width of the shake
 */
- (void)shake:(int)times withDelta:(CGFloat)delta;

/** Shake the UIView
 *
 * Shake the view a given number of times
 *
 * @param times The number of shakes
 * @param delta The width of the shake
 * @param handler A block object to be executed when the shake sequence ends
 */
- (void)shake:(int)times withDelta:(CGFloat)delta completion:(void( (^)(void)))handler;

/** Shake the UIView at a custom speed
 *
 * Shake the view a given number of times with a given speed
 *
 * @param times The number of shakes
 * @param delta The width of the shake
 * @param interval The duration of one shake
 */
- (void)shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval;

/** Shake the UIView at a custom speed
 *
 * Shake the view a given number of times with a given speed
 *
 * @param times The number of shakes
 * @param delta The width of the shake
 * @param interval The duration of one shake
 * @param handler A block object to be executed when the shake sequence ends
 */
- (void)shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval completion:(void( (^)(void)))handler;

/** Shake the UIView at a custom speed
 *
 * Shake the view a given number of times with a given speed
 *
 * @param times The number of shakes
 * @param delta The width of the shake
 * @param interval The duration of one shake
 */
- (void)shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(ShakeDirection)shakeDirection;

/** Shake the UIView at a custom speed
 *
 * Shake the view a given number of times with a given speed, with a completion handler
 *
 * @param times The number of shakes
 * @param delta The width of the shake
 * @param interval The duration of one shake
 * @param completion to be called when the view is done shaking
 */
- (void)shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(ShakeDirection)shakeDirection completion:(void (^)(void))completion;

/** Shake the UIView at a custom speed
 *
 * Shake the view a given number of times with a given speed
 *
 * @param times The number of shakes
 * @param delta The width of the shake
 * @param interval The duration of one shake
 * @param shouldShuttle 来回
 */
- (void)shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(ShakeDirection)shakeDirection shouldShuttle:(BOOL)shouldShuttle;

/** Shake the UIView at a custom speed
 *
 * Shake the view a given number of times with a given speed, with a completion handler
 *
 * @param times The number of shakes
 * @param delta The width of the shake
 * @param interval The duration of one shake
 * @param completion to be called when the view is done shaking
 * @param shouldShuttle 来回
 */
- (void)shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(ShakeDirection)shakeDirection shouldShuttle:(BOOL)shouldShuttle completion:(void (^)(void))completion;
@end

NS_ASSUME_NONNULL_END
