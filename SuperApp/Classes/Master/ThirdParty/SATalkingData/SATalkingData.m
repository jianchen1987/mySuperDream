//
//  SATalkingData.m
//  SuperApp
//
//  Created by VanJay on 2020/3/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SATalkingData.h"
#import "CMNetworkRequest.h"
#import "SAUser.h"
#import <HDKitCore/HDCommonDefines.h>


@interface SATalkingData ()
@property (nonatomic, strong) NSMutableDictionary *dataInfo;
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *records; ///< 埋点记录
@end


@implementation SATalkingData

static SATalkingData *talkData;

+ (instancetype)shareHDTalkingData {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        talkData = [[SATalkingData alloc] init];
    });
    return talkData;
}

+ (void)load {
    [super load];
    talkData = [SATalkingData shareHDTalkingData];
    // 关闭日志
    [TalkingData setLogEnabled:false];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dataInfo = [NSMutableDictionary dictionary];
        self.records = [[NSMutableArray alloc] initWithCapacity:10];
        NSMutableArray<NSDictionary *> *tmp = [NSUserDefaults.standardUserDefaults valueForKey:@"kTalkingDataHistory"];
        if (tmp && tmp.count > 0) {
            [self.records addObjectsFromArray:tmp];
        }
    }
    return self;
}

- (void)dealloc {
    [NSUserDefaults.standardUserDefaults setValue:self.records forKey:@"kTalkingDataHistory"];
}

+ (void)trackPageBegin:(NSString *)pageName {
    [TalkingData trackPageBegin:pageName];
}

+ (void)trackPageEnd:(NSString *)pageName {
    [TalkingData trackPageEnd:pageName];
}

+ (void)trackEvent:(NSString *)eventId {
    [SATalkingData trackEvent:eventId label:@"null" parameters:@{}];
}

+ (void)trackEvent:(NSString *)eventId label:(NSString *)eventLabel parameters:(NSDictionary *)parameters {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:parameters];

    [TalkingData trackEvent:eventId label:eventLabel parameters:dic];
}

+ (void)trackEvent:(NSString *)eventId label:(NSString *)eventLabel {
    [SATalkingData trackEvent:eventId label:eventLabel parameters:@{}];
}

+ (void)trackEventDurationStart:(NSString *)eventId {
    NSString *timeSp = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970] * 1000.0];
    [talkData.dataInfo setObject:timeSp forKey:eventId];
}

+ (void)trackEventDurationEnd:(NSString *)eventId {
    if ([talkData.dataInfo.allKeys containsObject:eventId]) {
        NSInteger startTime = [talkData.dataInfo[eventId] integerValue];
        NSString *timeSp = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970] * 1000];
        NSInteger durtion = [timeSp integerValue] - startTime;
        [self trackEvent:eventId label:[NSString stringWithFormat:@"%ld(ms)", (long)durtion]];
        [talkData.dataInfo removeObjectForKey:eventId];
        HDLog(@"%@: 时间长度===%ld(ms)", eventId, (long)durtion);
    }
}

/// 超A数据埋点
/// @param eventName 事件名
/// @param eventLabel 事件Label
/// @param parameters 参数
+ (void)SATrackEvent:(NSString *_Nonnull)eventName label:(NSString *_Nullable)eventLabel parameters:(NSDictionary *_Nonnull)parameters {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"eventName"] = eventName;
    params[@"eventLabel"] = eventLabel;
    params[@"params"] = [parameters yy_modelToJSONString];

    [talkData addRecord:params];
}

/// 记录用户当前选择语言
+ (void)SATrackUserLanguage {
    if (![SAUser hasSignedIn]) {
        return;
    }

    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 1;
    request.requestURI = @"/operator/info/modify.do";
    request.isNeedLogin = YES;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"language"] = [SAMultiLanguageManager currentLanguage];
    request.requestParameter = params;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    [request startWithSuccess:nil failure:nil];
}

+ (BOOL)handleUrl:(NSURL *)url {
    return [TalkingData handleUrl:url];
}

#pragma mark - private methods
- (void)addRecord:(NSDictionary *)record {
    [talkData.records addObject:record];
    if (talkData.records.count > 1) {
        NSArray<NSDictionary *> *tmp = [talkData.records subarrayWithRange:NSMakeRange(0, 10)];
        [talkData pushRecords:tmp];
        [talkData.records removeObjectsInArray:tmp];
    }
}

- (void)pushRecords:(NSArray<NSDictionary *> *)records {
    CMNetworkRequest *request = CMNetworkRequest.new;
    request.retryCount = 1;
    request.requestURI = @"/advertisement/data/record";
    request.isNeedLogin = NO;
    request.shouldAlertErrorMsgExceptSpecCode = NO;
    request.requestParameter = @{@"adsContentList": records};
    [request startWithSuccess:nil failure:nil];
}

+ (void)save {
    [NSUserDefaults.standardUserDefaults setValue:talkData.records forKey:@"kTalkingDataHistory"];
}

@end
