//
//  BaseTimer.h
//  GoldBook
//
//  Created by wmz on 2021/4/5.
//  Copyright © 2021 wmz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface GNTimer : NSObject

+ (NSString *)timerWithStartTime:(NSTimeInterval)start
                        interval:(NSTimeInterval)interval
                          timeId:(NSString *)timeId
                         repeats:(BOOL)repeats
                       mainQueue:(BOOL)async
                      completion:(void (^)(NSInteger time))completion;

+ (NSString *)timerWithStartTime:(NSTimeInterval)start
                        interval:(NSTimeInterval)interval
                          timeId:(NSString *)timeId
                           total:(NSTimeInterval)total
                         repeats:(BOOL)repeats
                       mainQueue:(BOOL)async
                      completion:(void (^)(NSInteger time))completion;

+ (NSString *)timerWithStartTime:(NSTimeInterval)start
                        interval:(NSTimeInterval)interval
                         durtion:(NSTimeInterval)duration
                          timeId:(NSString *)timeId
                         repeats:(BOOL)repeats
                       mainQueue:(BOOL)async
                      completion:(void (^)(NSInteger time))completion;

+ (void)cancel:(NSString *)timerID;

+ (void)cancels:(NSArray *)timerIDs;

+ (void)cancels;

@end


@interface NSTimer (GNBlcokTimer)
///用block使用定时器 避免循环引用
+ (NSTimer *)bl_scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void (^)(void))block repeats:(BOOL)repeats;

+ (void)bl_blockSelector:(NSTimer *)timer;
@end

NS_ASSUME_NONNULL_END
