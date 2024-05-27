//
//  SATalkingData.h
//  SuperApp
//
//  Created by VanJay on 2020/3/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TalkingData.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface SATalkingData : NSObject
/**
 *  @method trackEvent
 *  统计自定义事件（可选），如购买动作
 *  @param  eventId     事件名称（自定义）
 */
+ (void)trackEvent:(NSString *)eventId;

/**
 *  @method    trackEvent:label:parameters
 *  统计带二级参数的自定义事件，单次调用的参数数量不能超过10个
 *  @param  eventId     事件名称（自定义）
 *  @param  eventLabel  事件标签（自定义）
 *  @param  parameters  事件参数 (key只支持NSString, value支持NSString和NSNumber)
 */
+ (void)trackEvent:(NSString *)eventId label:(NSString *)eventLabel parameters:(NSDictionary *)parameters;

/**
 *  @method trackEvent:label:
 *  统计带标签的自定义事件（可选），可用标签来区别同一个事件的不同应用场景
 如购买某一特定的商品
 *  @param  eventId     事件名称（自定义）
 *  @param  eventLabel  事件标签（自定义）
 */
+ (void)trackEvent:(NSString *)eventId label:(NSString *)eventLabel;

/**
 记录事件时长 开始

 @param eventId 事件名称
 */
+ (void)trackEventDurationStart:(NSString *)eventId;
/**
 记录事件时长 结束

 @param eventId 事件名称
 */
+ (void)trackEventDurationEnd:(NSString *)eventId;

+ (void)trackPageBegin:(NSString *)pageName;

+ (void)trackPageEnd:(NSString *)pageName;

/// 超A数据埋点
/// @param eventName 事件名
/// @param eventLabel 事件Label
/// @param parameters 参数
+ (void)SATrackEvent:(NSString *_Nonnull)eventName label:(NSString *_Nullable)eventLabel parameters:(NSDictionary *_Nonnull)parameters;

/// 记录用户当前选择语言
+ (void)SATrackUserLanguage;

/// 灵动分析需要
/// @param url 唤起appurl
+ (BOOL)handleUrl:(NSURL *)url;

/// 保存记录
+ (void)save;

@end

NS_ASSUME_NONNULL_END
