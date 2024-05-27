//
//  HDCountDownTimeManager.h
//  SuperApp
//
//  Created by VanJay on 2020/4/6.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface HDCountDownTimeManager : NSObject
+ (instancetype)shared;

/// 更新（key不存在则新增）
/// @param key key
/// @param maxSeconds 最大秒数
- (void)updatePersistencedCountDownWithKey:(NSString *)key maxSeconds:(NSInteger)maxSeconds;

/// 获取某 key 当前的剩余秒数，如果大于 0 则存在
/// @param key key
- (NSInteger)getPersistencedCountDownSecondsWithKey:(NSString *)key;

/// 删除某 key 当前的剩余秒数
/// @param key key
- (void)removePersistencedCountDownSecondsWithKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
