//
//  LKDataRecord.h
//  SuperApp
//
//  Created by seeu on 2021/10/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "LKRecordPool.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, LKDataRecordLoginType) {
    LKDataRecordLoginTypePassword = 10,
    LKDataRecordLoginTypeSms = 11,
    LKDataRecordLoginTypeWechat = 12,
    LKDataRecordLoginTypeFaceBook = 13,
    LKDataRecordLoginTypeAppleId = 14,
    LKDataRecordLoginTypeCustomer = 15
};


@interface LKDataRecord : NSObject

+ (instancetype)shared;

/// 初始化埋点工具
/// @param appId appId
/// @param key 密钥
+ (void)initWithAppId:(NSString *_Nonnull)appId secretKey:(NSString *_Nonnull)key;

/// 标准会话事件，开始（日活相关）
- (void)sessionStart;

/// 标准会话事件，结束
- (void)sessionEnd;

/// 标准页面浏览事件，页面开始
/// @param pageName 页面标识
- (void)tracePageBegin:(NSString *_Nonnull)pageName;

/// 标准页面浏览事件，页面结束
/// @param pageName 页面标识
- (void)tracePageEnd:(NSString *_Nonnull)pageName;

/// 标准登陆事件
/// @param type 登陆类型
/// @param userId 用户唯一标识
- (void)loginWithType:(LKDataRecordLoginType)type userId:(NSString *_Nonnull)userId SPM:(LKSPM *_Nullable)spm;

/// 首次打开app埋点
- (void)traceFirstOpenWithExt:(NSDictionary *_Nullable)ext;

///< 业务线日活埋点
- (void)traceBizActiveDaily:(NSString *_Nonnull)bizLine routhPath:(NSString *_Nonnull)routhPath ext:(NSDictionary *_Nullable)params;

/// 标准点击时间，记录事件名，发生的位置
/// @param eventName 事件名
/// @param params 自定义参数
/// @param spm 位置
- (void)traceClickEvent:(NSString *)eventName parameters:(NSDictionary *_Nullable)params SPM:(LKSPM *_Nullable)spm;
/// 点击PV事件，记录事件名，发生的位置
/// @param eventName 事件名
/// @param params 自定义参数
/// @param spm 位置
- (void)tracePVEvent:(NSString *_Nonnull)eventName parameters:(NSDictionary *_Nullable)params SPM:(LKSPM *_Nullable)spm;
/// 自定义事件
/// @param eventId 事件标识
/// @param eventName 事件名
/// @param params 自定义参数
- (void)traceEvent:(NSString *_Nonnull)eventId name:(NSString *_Nonnull)eventName parameters:(NSDictionary *_Nullable)params SPM:(LKSPM *_Nullable)spm;

/// 添加外卖事件
/// @param eventId 事件id
/// @param eventName 事件名
/// @param ext 扩展参数
+ (void)traceYumNowEvent:(NSString *_Nonnull)eventId name:(NSString *_Nonnull)eventName ext:(NSDictionary *_Nullable)ext;

- (void)traceEventGroup:(LKEventGroupName)group event:(NSString *_Nonnull)eventId name:(NSString *_Nonnull)eventName parameters:(NSDictionary *_Nullable)params SPM:(LKSPM *_Nullable)spm;

- (void)traceEvent:(NSString *_Nonnull)eventId name:(NSString *_Nonnull)eventName parameters:(NSDictionary *_Nullable)params;

///// 添加全局参数，会在每个事件中添加
///// @param key key
///// @param value value
//- (void)setGlobalKV:(NSString *)key value:(id)value;
//
///// 移除全局参数
///// @param key key
//- (void)removeGlobalKV:(NSString *)key;

/// 手动存档
- (void)saveAll;

/// 强制上送
- (void)forcePush;

@end

NS_ASSUME_NONNULL_END
