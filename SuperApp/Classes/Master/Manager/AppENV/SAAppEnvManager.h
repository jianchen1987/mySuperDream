//
//  SAAppEnvManager.h
//  SuperApp
//
//  Created by VanJay on 2020/4/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAAppEnvConfig.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 切换环境成功的通知
FOUNDATION_EXPORT NSString *const kNotificationNameChangeAppEnvSuccess;


@interface SAAppEnvManager : NSObject
+ (instancetype)sharedInstance;

/// 当前环境配置
@property (nonatomic, strong, readonly) SAAppEnvConfig *appEnvConfig;
/// 所有线路配置
@property (nonatomic, copy, readonly) NSArray<SAAppEnvConfig *> *dataSource;

/// 设置环境
/// @param type 环境类型
- (void)setEnvType:(SAAppEnvType)type;

/// 切换环境
/// @param completion 完成回调
- (void)envSwitchCompletion:(void (^)(BOOL hasSwitch))completion;

@end

NS_ASSUME_NONNULL_END
