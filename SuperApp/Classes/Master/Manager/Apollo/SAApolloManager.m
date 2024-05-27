//
//  SAApolloManager.m
//  SuperApp
//
//  Created by Chaos on 2021/5/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAApolloManager.h"
#import "SACacheManager.h"
#import "SANotificationConst.h"


@implementation SAApolloManager

+ (void)saveApolloConfigs:(NSDictionary *)configs {
    [SACacheManager.shared setObject:configs forKey:kCacheKeyRemoteConfigs type:SACacheTypeDocumentPublic relyLanguage:NO];
    [NSNotificationCenter.defaultCenter postNotificationName:kNotificationNameRemoteConfigsUpdate object:nil];
}

+ (id)getApolloConfigForKey:(ApolloConfigKey)key {
    NSDictionary *configs = [SACacheManager.shared objectForKey:kCacheKeyRemoteConfigs type:SACacheTypeDocumentPublic relyLanguage:NO];
    if (configs && [configs isKindOfClass:NSDictionary.class]) {
        return [configs objectForKey:key];
    }
    return nil;
}

@end
