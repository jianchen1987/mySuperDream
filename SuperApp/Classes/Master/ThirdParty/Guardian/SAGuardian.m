//
//  SAGuardian.m
//  SuperApp
//
//  Created by seeu on 2021/1/26.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAGuardian.h"

#if !TARGET_IPHONE_SIMULATOR
#import <RiskPerception/NTESRiskUniPerception.h>
#import <RiskPerception/NTESRiskUniConfiguration.h>
#endif



#import <HDKitCore/HDKitCore.h>
#import <HDKitCore/HDLog.h>
#import "SAAppSwitchManager.h"


@implementation SAGuardian

+ (void)initNTERisk {
    
#if !TARGET_IPHONE_SIMULATOR
#ifdef DEBUG
        [NTESRiskUniConfiguration setServerType:1];
        [NTESRiskUniConfiguration setChannel:@"Test"];
#else
        [NTESRiskUniConfiguration setServerType:3];
        [NTESRiskUniConfiguration setChannel:@"AppStore"];
        
#endif
        
        [[NTESRiskUniPerception fomentBevelDeadengo] init:@"YD00481894759076" callback:^(int code, NSString *_Nonnull msg, NSString *_Nonnull content) {
            if (code != 200) {
                HDLog(@"易盾初始化失败！:%d %@ %@", code, msg, content);
            }
        }];
#else
        HDLog(@"易盾不支持模拟器，直接返回");
        
#endif
}

+ (void)logout {
#if !TARGET_IPHONE_SIMULATOR
    [[NTESRiskUniPerception fomentBevelDeadengo] logOut];
#endif
}


+ (void)getTokenWithTimeout:(int)timeout completeHandler:(void (^)(NSString *token, NSInteger code, NSString *message))handler {
    
#if !TARGET_IPHONE_SIMULATOR
        [[NTESRiskUniPerception fomentBevelDeadengo] getTokenAsync:@"c2c29b2d43d8ed8e3c484882e85e6eb9" withTimeout:timeout completeHandler:^(AntiCheatResult *_Nonnull result) {
            if (result.code == 200) {
                HDLog(@"获取易盾Token成功:%@ [%@]", result.token, result.codeStr);
                !handler ?: handler(result.token, result.code, result.codeStr);
            } else {
                HDLog(@"获取易盾Token失败");
                !handler ?: handler(@"", 200, @"");
            }
        }];
#else
        HDLog(@"模拟器不支持易盾，直接返回");
        !handler ?: handler(@"", 200, @"");
#endif
    
}
@end
