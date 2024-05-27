//
//  LKRecordPool.h
//  SuperApp
//
//  Created by seeu on 2021/10/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SACodingModel.h"

NS_ASSUME_NONNULL_BEGIN

///外卖专题活动类型
typedef NSString *LKEventGroupName NS_STRING_ENUM;
FOUNDATION_EXPORT LKEventGroupName const LKEventGroupNameLogin;    ///< 登陆事件组
FOUNDATION_EXPORT LKEventGroupName const LKEventGroupNameViewPage; ///< 页面浏览
FOUNDATION_EXPORT LKEventGroupName const LKEventGroupNameClick;    ///< 点击事件
FOUNDATION_EXPORT LKEventGroupName const LKEventGroupNameSession;  ///< 会话相关
FOUNDATION_EXPORT LKEventGroupName const LKEventGroupNameOther;    ///< 其他


@interface LKSPM : SACodingModel

@property (nonatomic, copy) NSString *parentPage;      ///< 父页面
@property (nonatomic, copy) NSString *currentPage;     ///< 当前页面
@property (nonatomic, copy) NSString *currentArea;     ///< 当前区域
@property (nonatomic, copy) NSString *childPage;       ///< 子页面
@property (nonatomic, copy) NSString *node;            ///< 当前节点
@property (nonatomic, assign) NSTimeInterval stayTime; ///< 停留时间

+ (instancetype)SPMWithPage:(NSString *_Nonnull)currentPage parent:(NSString *_Nullable)parentPage child:(NSString *_Nullable)childPage stayTime:(NSTimeInterval)stayTime;
+ (instancetype)SPMWithPage:(NSString *_Nonnull)currentPage area:(NSString *_Nullable)currentArea node:(NSString *_Nullable)node;

@end


@interface LKRecord : SACodingModel
@property (nonatomic, copy) NSString *sessionId;         ///< 会话Id
@property (nonatomic, copy) LKEventGroupName eventGroup; ///< 事件组
@property (nonatomic, copy) NSString *event;             ///< 事件Id
@property (nonatomic, copy) NSString *businessName;      ///< 事件名
@property (nonatomic, assign) NSUInteger recordTime;     ///< 记录时间
@property (nonatomic, strong) NSDictionary *ext;         ///< 业务自定义
@property (nonatomic, strong) LKSPM *spm;                ///< 位置信息
@property (nonatomic, copy) NSString *businessLine;      ////< 业务线

#pragma mark - 全局参数
///< appid
@property (nonatomic, copy) NSString *appId;
///< appNo
@property (nonatomic, copy) NSString *appNo;
///< channel
@property (nonatomic, copy) NSString *channel;
///< appVersion
@property (nonatomic, copy) NSString *appVersion;
///< 设备号
@property (nonatomic, copy) NSString *deviceId;
///< 设备类型
@property (nonatomic, copy) NSString *deviceType;
///< 语言
@property (nonatomic, copy) NSString *language;
///< 操作员
@property (nonatomic, copy) NSString *operatorNo;
///< 登录号
@property (nonatomic, copy) NSString *loginName;
///< 纬度
@property (nonatomic, copy) NSString *latitude;
///< 经度
@property (nonatomic, copy) NSString *longitude;

+ (instancetype)recordWithSessionId:(NSString *_Nonnull)sessionId
                          EventGoup:(LKEventGroupName)groupName
                            eventId:(NSString *_Nonnull)eventId
                          eventName:(NSString *_Nullable)eventName
                                ext:(NSDictionary *_Nullable)ext
                                SPM:(LKSPM *_Nullable)spm;

@end


@interface LKRecordPool : NSObject

@property (nonatomic, assign) NSUInteger standardPoolSize; ///< 标准事件池子大小
@property (nonatomic, assign) NSUInteger otherPoolSize;    ///< 其他事件池子大小

/// 新增记录
- (void)addRecord:(LKRecord *)record;
/// 上送
- (void)pushRecords;

/// 归档数据，来不及上传的先保存
- (void)archiveRecords;

/// 解档数据，继续上送
- (void)unarchiveRecords;

@end

NS_ASSUME_NONNULL_END
