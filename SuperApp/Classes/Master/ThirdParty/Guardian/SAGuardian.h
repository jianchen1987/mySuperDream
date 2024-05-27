//
//  SAGuardian.h
//  SuperApp
//
//  Created by seeu on 2021/1/26.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface SAGuardian : NSObject


/// 初始化
+ (void)initNTERisk;

+ (void)logout;


/// 获取token
/// - Parameters:
///   - timeout: 超时时间，单位毫秒
///   - handler: 回调
+ (void)getTokenWithTimeout:(int)timeout completeHandler:(void (^)(NSString *token, NSInteger code, NSString *message))handler;

@end

NS_ASSUME_NONNULL_END
