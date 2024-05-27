//
//  SAShareManager.h
//  SuperApp
//
//  Created by Tia on 2023/7/10.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SHAKE_NOTIFY @"shake_notify"

NS_ASSUME_NONNULL_BEGIN


@interface SAShakeManager : NSObject

+ (instancetype)shaked;

/// 开始监听摇一摇
- (BOOL)startMonitorShake;

/// 停止监听摇一摇
- (void)stopMonitorShake;


@end

NS_ASSUME_NONNULL_END
