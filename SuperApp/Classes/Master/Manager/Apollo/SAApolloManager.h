//
//  SAApolloManager.h
//  SuperApp
//
//  Created by Chaos on 2021/5/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAApolloKeyConst.h"

NS_ASSUME_NONNULL_BEGIN


@interface SAApolloManager : NSObject

/// 保存阿波罗配置
+ (void)saveApolloConfigs:(NSDictionary *)configs;

/// 获取阿波罗配置
+ (id)getApolloConfigForKey:(ApolloConfigKey)key;

@end

NS_ASSUME_NONNULL_END
