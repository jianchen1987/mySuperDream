//
//  SALoginAdManager.h
//  SuperApp
//
//  Created by Tia on 2022/9/28.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface SALoginAdManager : NSObject
/// 保存登录广告配置
+ (void)saveLoginAdConfigs:(NSDictionary *)configs;

@end

NS_ASSUME_NONNULL_END
