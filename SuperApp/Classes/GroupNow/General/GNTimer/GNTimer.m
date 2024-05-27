
//
//  BaseTimer.m
//  GoldBook
//
//  Created by wmz on 2021/4/5.
//  Copyright © 2021 wmz. All rights reserved.
//

#import "GNTimer.h"


@implementation GNTimer

static NSMutableDictionary *timers;

dispatch_semaphore_t sem;

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timers = [NSMutableDictionary dictionary];
        sem = dispatch_semaphore_create(1);
    });
}

+ (NSString *)timerWithStartTime:(NSTimeInterval)start
                        interval:(NSTimeInterval)interval
                          timeId:(NSString *)timeId
                         repeats:(BOOL)repeats
                       mainQueue:(BOOL)async
                      completion:(void (^)(NSInteger time))completion {
    return [GNTimer timerWithStartTime:start interval:interval durtion:0 timeId:timeId repeats:repeats mainQueue:async completion:completion];
}

+ (NSString *)timerWithStartTime:(NSTimeInterval)start
                        interval:(NSTimeInterval)interval
                          timeId:(NSString *)timeId
                           total:(NSTimeInterval)total
                         repeats:(BOOL)repeats
                       mainQueue:(BOOL)async
                      completion:(void (^)(NSInteger time))completion {
    return [GNTimer timerWithStartTime:start interval:interval durtion:0 total:total timeId:timeId repeats:repeats mainQueue:async completion:completion];
}

+ (NSString *)timerWithStartTime:(NSTimeInterval)start
                        interval:(NSTimeInterval)interval
                         durtion:(NSTimeInterval)duration
                          timeId:(NSString *)timeId
                         repeats:(BOOL)repeats
                       mainQueue:(BOOL)async
                      completion:(void (^)(NSInteger time))completion {
    return [GNTimer timerWithStartTime:start interval:interval durtion:duration total:0 timeId:timeId repeats:repeats mainQueue:async completion:completion];
}

+ (NSString *)timerWithStartTime:(NSTimeInterval)start
                        interval:(NSTimeInterval)interval
                         durtion:(NSTimeInterval)duration
                           total:(NSTimeInterval)total
                          timeId:(NSString *)timeId
                         repeats:(BOOL)repeats
                       mainQueue:(BOOL)async
                      completion:(void (^)(NSInteger time))completion {
    if (!completion || start < 0 || interval <= 0) {
        return nil;
    }
    __block NSTimeInterval seconds = duration;
    __block NSTimeInterval mTotal = total;
    __block NSTimeInterval num = 1;
    dispatch_queue_t queue = !async ? dispatch_queue_create("gcd.timer.queue", NULL) : dispatch_get_main_queue();
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, start * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0);
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    timers[timeId] = timer;
    dispatch_semaphore_signal(sem);
    dispatch_source_set_event_handler(timer, ^{
        if (total) {
            mTotal--;
            if (num == interval) {
                num = 0;
                if (completion) {
                    completion(mTotal);
                }
            }
            num++;
            if (mTotal == 0) {
                [self cancel:timeId];
            }
        } else {
            if (duration) {
                seconds--;
                if (completion) {
                    completion(seconds);
                }
                if (seconds == 0) {
                    [self cancel:timeId];
                }
            } else {
                if (completion) {
                    completion(seconds);
                }
                if (!repeats) {
                    [self cancel:timeId];
                }
            }
        }
    });
    dispatch_resume(timer);

    return timeId;
}

+ (void)cancel:(NSString *)timerID {
    if (!timerID || timerID.length <= 0) {
        return;
    }
    dispatch_source_t timer = timers[timerID];
    if (timer) {
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
        dispatch_source_cancel(timer);
        [timers removeObjectForKey:timerID];
        dispatch_semaphore_signal(sem);
    }
}

+ (void)cancels:(NSArray *)timerIDs {
    for (NSString *key in timers.allKeys) {
        if ([timerIDs indexOfObject:key] == NSNotFound) {
            dispatch_source_t timer = timers[key];
            dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
            dispatch_source_cancel(timer);
            [timers removeObjectForKey:key];
            dispatch_semaphore_signal(sem);
        }
    }
}

+ (void)cancels {
    for (NSString *key in timers.allKeys) {
        dispatch_source_t timer = timers[key];
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
        dispatch_source_cancel(timer);
        [timers removeObjectForKey:key];
        dispatch_semaphore_signal(sem);
    }
}

@end


@implementation NSTimer (GNBlcokTimer)

+ (NSTimer *)bl_scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void (^)(void))block repeats:(BOOL)repeats {
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(bl_blockSelector:) userInfo:[block copy] repeats:repeats];
}

+ (void)bl_blockSelector:(NSTimer *)timer {
    void (^block)(void) = timer.userInfo;
    if (block) {
        block();
    }
}
@end
