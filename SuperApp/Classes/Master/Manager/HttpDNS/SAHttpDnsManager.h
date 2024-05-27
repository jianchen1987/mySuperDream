//
//  SAHttpDnsManager.h
//  SuperApp
//
//  Created by Tia on 2022/7/1.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define kSAHttpDnsManager [SAHttpDnsManager sharedInstance]


@interface SAHttpDnsManager : NSObject

+ (instancetype)sharedInstance;

/// 获取域名对应的IP，单IP
/// @param host 域名
- (NSString *)getIpByHostAsync:(NSString *)host;

/// 是否拦截,默认拦截
- (BOOL)canIntercept;

@end

NS_ASSUME_NONNULL_END
