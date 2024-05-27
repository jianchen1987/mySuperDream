//
//  LKDataRecord.m
//  SuperApp
//
//  Created by seeu on 2021/10/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "LKDataRecord.h"
#import "LKRecordPool.h"
#import "NSDate+SAExtension.h"
#import <HDKitCore/HDKitCore.h>
#import <YYModel.h>
#import "SACacheManager.h"
#import "SAUrlBizMappingModel.h"
#import "SAApolloManager.h"

#define DATA_RECORD_CACHE_SESSION @"com.kh-super.superapp.record.session"


@interface LKPageViewRecordCache : NSObject
@property (nonatomic, copy) NSString *pageName;          ///<
@property (nonatomic, copy) NSString *parent;            ///<
@property (nonatomic, copy) NSString *child;             ///< 子节点
@property (nonatomic, assign) NSTimeInterval recordTime; ///< 记录时间

+ (instancetype)recordWithName:(NSString *)pageName;
@end


@implementation LKPageViewRecordCache

+ (instancetype)recordWithName:(NSString *)pageName {
    LKPageViewRecordCache *inst = LKPageViewRecordCache.new;
    inst.pageName = pageName;
    inst.recordTime = [[NSDate new] timeIntervalSince1970];
    return inst;
}

@end


@interface LKDataRecord ()
@property (nonatomic, copy) NSString *sessionId;                                    ///< 会话id
@property (nonatomic, strong) LKRecordPool *pool;                                   ///< 记录池
@property (nonatomic, assign) NSTimeInterval sessionStartTime;                      ///< 会话开始时间
@property (nonatomic, strong) NSMutableDictionary *cache;                           ///< 临时缓存
@property (nonatomic, strong) NSMutableArray<LKPageViewRecordCache *> *pageViewArr; ///<
@property (nonatomic, strong) dispatch_queue_t pageViewQueue;                       ///<
@property (nonatomic, strong) NSTimer *timer;                                       ///< 定时上送
@end


@implementation LKDataRecord

- (instancetype)init {
    self = [super init];
    if (self) {
        self.pool = [[LKRecordPool alloc] init];
        self.cache = [[NSMutableDictionary alloc] initWithCapacity:3];
        self.pageViewArr = [[NSMutableArray alloc] initWithCapacity:10];
        self.pageViewQueue = dispatch_queue_create("com.kh-super.superapp.record.pageViewQueeu", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static LKDataRecord *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self shared];
}

#pragma mark - public methods
/// 初始化埋点工具
/// @param appId appId
/// @param key 密钥
+ (void)initWithAppId:(NSString *_Nonnull)appId secretKey:(NSString *_Nonnull)key {
}

/// 会话开始
- (void)sessionStart {
    // 解档历史数据
    [self.pool unarchiveRecords];
    [self.pool pushRecords];
    // 生成会话id
    NSDate *now = [NSDate new];
    self.sessionStartTime = [now timeIntervalSince1970];
    [self setSessionId:[NSString stringWithFormat:@"%@%06d", [now stringWithFormatStr:@"yyyyMMddHHmmss"], arc4random() % 1000000]];

    NSMutableDictionary *tmp = [[NSMutableDictionary alloc] initWithCapacity:1];
    NSString *shortID = [SACacheManager.shared objectPublicForKey:kCacheKeyShortIDTrace];
    if (shortID && HDIsStringNotEmpty(shortID)) {
        [tmp setObject:shortID forKey:@"shortID"];
    }

    [self.pool addRecord:[LKRecord recordWithSessionId:self.sessionId EventGoup:LKEventGroupNameSession eventId:@"@sessionStart" eventName:@"" ext:tmp SPM:[LKSPM SPMWithPage:@"" parent:@"" child:@""
                                                                                                                                                                     stayTime:0]]];
    [self.cache setObject:now forKey:DATA_RECORD_CACHE_SESSION];

    NSString *pushInterval = [SAApolloManager getApolloConfigForKey:kApolloConfigKeyDataRecordPushInterval];
    
    if (HDIsStringEmpty(pushInterval) || pushInterval.integerValue <= 0) {
        return;
    }
    
    self.timer = nil;
    self.timer = [NSTimer timerWithTimeInterval:pushInterval.integerValue target:self selector:@selector(periodicPush) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [[NSRunLoop currentRunLoop] run];
    [self.timer fire];
}

/// 会话结束
- (void)sessionEnd {
    NSDate *now = [self.cache objectForKey:DATA_RECORD_CACHE_SESSION];
    if (!now) {
        return;
    }
    double diff = [[NSDate new] timeIntervalSince1970] - [now timeIntervalSince1970];
    NSString *stayTimeStr = [NSString stringWithFormat:@"%.0f", diff * 1000];
    HDLog(@"会话结束:%@", stayTimeStr);
    [self.pool addRecord:[LKRecord recordWithSessionId:self.sessionId EventGoup:LKEventGroupNameSession eventId:@"@sessionEnd" eventName:@"" ext:@{} SPM:[LKSPM SPMWithPage:@"" parent:@"" child:@""
                                                                                                                                                                   stayTime:stayTimeStr.integerValue]]];

    if (self.timer) {
        [self.timer invalidate];
        //        self.timer = nil;
    }

    // 先归档，避免进程被杀死丢失数据
    [self.pool archiveRecords];
}

/// 页面开始
/// @param pageName 页面标识
- (void)tracePageBegin:(NSString *_Nonnull)pageName {
    dispatch_async(self.pageViewQueue, ^{
        LKPageViewRecordCache *new = [LKPageViewRecordCache recordWithName : pageName];
        LKPageViewRecordCache *last = self.pageViewArr.lastObject;
        if (last) {
            new.parent = last.pageName;
            last.child = new.pageName;
        }
        [self.pageViewArr addObject:new];
    });
}

/// 页面结束
/// @param pageName 页面标识
- (void)tracePageEnd:(NSString *_Nonnull)pageName {
    dispatch_async(self.pageViewQueue, ^{
        LKPageViewRecordCache *cache = [self findRecordWithPageName:pageName];
        if (cache) {
            NSString *stayTimeStr = [NSString stringWithFormat:@"%.0f", ([[NSDate new] timeIntervalSince1970] - cache.recordTime) * 1000];
            LKSPM *spm = [LKSPM SPMWithPage:cache.pageName parent:cache.parent child:cache.child stayTime:stayTimeStr.integerValue];
            LKRecord *record = [LKRecord recordWithSessionId:self.sessionId EventGoup:LKEventGroupNameViewPage eventId:@"@viewPage" eventName:@"" ext:@{} SPM:spm];
            [self.pool addRecord:record];
            [self.pageViewArr removeObject:cache];
        }
    });
}

/// 登录事件
/// @param type 登录类型
/// @param userId 用户唯一标识
- (void)loginWithType:(LKDataRecordLoginType)type userId:(NSString *_Nonnull)userId SPM:(LKSPM *_Nullable)spm {
    NSString *eventName = nil;
    if (type == LKDataRecordLoginTypeSms) {
        eventName = @"短信登录";
    } else if (type == LKDataRecordLoginTypePassword) {
        eventName = @"密码登录";
    } else if (type == LKDataRecordLoginTypeFaceBook) {
        eventName = @"FaceBook登录";
    } else if (type == LKDataRecordLoginTypeWechat) {
        eventName = @"微信登录";
    } else if (type == LKDataRecordLoginTypeAppleId) {
        eventName = @"Apple登录";
    } else {
        eventName = @"自定义登录";
    }

    [self.pool addRecord:[LKRecord recordWithSessionId:self.sessionId EventGoup:LKEventGroupNameLogin eventId:@"@login" eventName:eventName ext:@{@"type": [NSNumber numberWithInteger:type]} SPM:spm]];
}

- (void)traceEventGroup:(LKEventGroupName)group event:(NSString *_Nonnull)eventId name:(NSString *_Nonnull)eventName parameters:(NSDictionary *_Nullable)params SPM:(LKSPM *_Nullable)spm {
    [self.pool addRecord:[LKRecord recordWithSessionId:self.sessionId EventGoup:group eventId:eventId eventName:eventName ext:params SPM:spm]];
}

- (void)traceFirstOpenWithExt:(NSDictionary *)ext {
    NSMutableDictionary *tmp = [[NSMutableDictionary alloc] initWithDictionary:ext];
    NSString *shortID = [SACacheManager.shared objectPublicForKey:kCacheKeyShortIDTrace];
    if (shortID && HDIsStringNotEmpty(shortID)) {
        [tmp setObject:shortID forKey:@"shortID"];
    }

    [self.pool addRecord:[LKRecord recordWithSessionId:self.sessionId EventGoup:LKEventGroupNameLogin eventId:@"firstOpen" eventName:@"首次打开" ext:tmp SPM:nil]];
    [self.pool pushRecords];
}

- (void)traceClickEvent:(NSString *_Nonnull)eventName parameters:(NSDictionary *_Nullable)params SPM:(LKSPM *_Nullable)spm {
    [self.pool addRecord:[LKRecord recordWithSessionId:self.sessionId EventGoup:LKEventGroupNameClick eventId:@"@click" eventName:eventName ext:params SPM:spm]];
}

- (void)tracePVEvent:(NSString *_Nonnull)eventName parameters:(NSDictionary *_Nullable)params SPM:(LKSPM *_Nullable)spm {
    [self.pool addRecord:[LKRecord recordWithSessionId:self.sessionId EventGoup:LKEventGroupNameOther eventId:eventName eventName:eventName ext:params SPM:spm]];
}

- (void)traceBizActiveDaily:(NSString *_Nonnull)bizLine routhPath:(NSString *_Nonnull)routhPath ext:(NSDictionary *_Nullable)params {
    if (HDIsStringNotEmpty(bizLine)) {
        NSString *cacheKey = [NSString stringWithFormat:@"BizActiveDaily_%@_%@", [[NSDate new] stringWithFormatStr:@"yyyyMMdd"], bizLine];
        HDLog(@"bizActiveDailyCacheKey: %@", cacheKey);
        NSString *flag = [SACacheManager.shared objectForKey:cacheKey type:SACacheTypeCacheNotPublic];
        if (!HDIsObjectNil(flag) && HDIsStringNotEmpty(flag)) {
            HDLog(@"该业务线今天已经记录，忽略：%@", bizLine);
            return;
        }
        [SACacheManager.shared setObject:@"1" forKey:cacheKey duration:60 * 60 * 24 type:SACacheTypeCacheNotPublic];
    }

    LKRecord *record = [LKRecord recordWithSessionId:self.sessionId EventGoup:LKEventGroupNameOther eventId:@"business_active_user_daily" eventName:routhPath ext:params SPM:nil];
    record.businessLine = bizLine;
    [self.pool addRecord:record];
}


/// 自定义事件
/// @param eventId 事件标识
/// @param eventName 事件名
/// @param params 参数
- (void)traceEvent:(NSString *_Nonnull)eventId name:(NSString *_Nonnull)eventName parameters:(NSDictionary *_Nullable)params SPM:(LKSPM *_Nullable)spm {
    [self.pool addRecord:[LKRecord recordWithSessionId:self.sessionId EventGoup:LKEventGroupNameOther eventId:eventId eventName:eventName ext:params SPM:spm]];
}

- (void)traceEvent:(NSString *)eventId name:(NSString *)eventName parameters:(NSDictionary *)params {
    [self traceEvent:eventId name:eventName parameters:params SPM:nil];
}

+ (void)traceYumNowEvent:(NSString *_Nonnull)eventId name:(NSString *_Nonnull)eventName ext:(NSDictionary *_Nullable)ext {
    NSString *shortID = [SACacheManager.shared objectPublicForKey:kCacheKeyShortIDTrace];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:2];
    [dic addEntriesFromDictionary:ext];
    if(HDIsStringNotEmpty(shortID)) {
        [dic setObject:shortID forKey:@"shortID"];
    }
    LKRecord *lr = [LKRecord recordWithSessionId:LKDataRecord.shared.sessionId EventGoup:LKEventGroupNameOther eventId:eventId eventName:eventName ext:dic SPM:nil];
    lr.businessLine = SAClientTypeYumNow;
    [LKDataRecord.shared.pool addRecord:lr];
}

- (void)saveAll {
    [self.pool archiveRecords];
}

#pragma mark - private methods
- (LKPageViewRecordCache *_Nullable)findRecordWithPageName:(NSString *)pageName {
    // 复制一份 防止中间被修改
    NSArray<LKPageViewRecordCache *> *backup = [self.pageViewArr copy];
    NSArray<LKPageViewRecordCache *> *bingo = [backup hd_filterWithBlock:^BOOL(LKPageViewRecordCache *_Nonnull item) {
        return [item.pageName isEqualToString:pageName];
    }];

    if (bingo.count > 0) {
        return bingo.lastObject;
    } else {
        return nil;
    }
}

- (void)periodicPush {
    //    HDLog(@"开始定时上报...");
    [self.pool pushRecords];
}

- (void)forcePush {
    [self.pool pushRecords];
}

@end
