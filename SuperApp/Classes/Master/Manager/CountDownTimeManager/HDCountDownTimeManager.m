//
//  HDCountDownTimeManager.m
//  SuperApp
//
//  Created by VanJay on 2020/4/6.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDCountDownTimeManager.h"
#import "SACacheManager.h"

static NSString *const kCacheKeyPersistencedCountDownTime = @"com.superapp.public.persistencedCountDownTime";


@interface HDCountDownPersistencedModel : NSObject
@property (nonatomic, assign) NSTimeInterval oldTimeInterval; ///< 旧时间戳
@property (nonatomic, assign) UInt64 maxCountDownSeconds;     ///< 最大秒数，默认60
@end


@implementation HDCountDownPersistencedModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.maxCountDownSeconds = 60;
    }
    return self;
}
@end


@interface HDCountDownTimeManager ()
/// 所有的缓存的键值对
@property (nonatomic, strong) NSMutableDictionary<NSString *, HDCountDownPersistencedModel *> *totalObjs;
/// 信号量
@property (nonatomic, strong) dispatch_semaphore_t sema4;
@end


@implementation HDCountDownTimeManager
+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static HDCountDownTimeManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
        instance.sema4 = dispatch_semaphore_create(1);
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self shared];
}

#pragma mark - public methods
- (void)updatePersistencedCountDownWithKey:(NSString *)key maxSeconds:(NSInteger)maxSeconds {
    if (!key || maxSeconds <= 0)
        return;

    dispatch_semaphore_wait(_sema4, DISPATCH_TIME_FOREVER);

    HDCountDownPersistencedModel *model;
    if ([self.totalObjs objectForKey:key]) {
        model = [self.totalObjs objectForKey:key];
    } else {
        model = HDCountDownPersistencedModel.new;
    }
    model.oldTimeInterval = (UInt64)[[NSDate date] timeIntervalSince1970];
    model.maxCountDownSeconds = maxSeconds;

    [self.totalObjs setObject:model forKey:key];

    [SACacheManager.shared setObject:self.totalObjs forKey:kCacheKeyPersistencedCountDownTime];

    dispatch_semaphore_signal(_sema4);
}

- (NSInteger)getPersistencedCountDownSecondsWithKey:(NSString *)key {
    if (!key)
        return 0;

    dispatch_semaphore_wait(_sema4, DISPATCH_TIME_FOREVER);
    HDCountDownPersistencedModel *model;
    if ([self.totalObjs objectForKey:key]) {
        model = [self.totalObjs objectForKey:key];

        // 获取当前时间戳
        UInt64 nowInterval = (UInt64)[[NSDate date] timeIntervalSince1970];
        NSInteger minus = nowInterval - model.oldTimeInterval;
        NSInteger less = minus <= model.maxCountDownSeconds ? (NSInteger)(model.maxCountDownSeconds - minus) : 0;
        dispatch_semaphore_signal(_sema4);
        return less;
    }
    dispatch_semaphore_signal(_sema4);
    return 0;
}

- (void)removePersistencedCountDownSecondsWithKey:(NSString *)key {
    dispatch_semaphore_wait(_sema4, DISPATCH_TIME_FOREVER);
    [self.totalObjs removeObjectForKey:key];

    [SACacheManager.shared setObject:self.totalObjs forKey:kCacheKeyPersistencedCountDownTime];
    dispatch_semaphore_signal(_sema4);
}

#pragma mark - lazy load
- (NSMutableDictionary<NSString *, HDCountDownPersistencedModel *> *)totalObjs {
    if (!_totalObjs) {
        _totalObjs = [SACacheManager.shared objectForKey:kCacheKeyPersistencedCountDownTime];
        _totalObjs = _totalObjs ?: NSMutableDictionary.new;
    }
    return _totalObjs;
}
@end
