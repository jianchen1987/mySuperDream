//
//  LKRecordPool.m
//  SuperApp
//
//  Created by seeu on 2021/10/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "LKRecordPool.h"
#import "CMNetworkRequest.h"
#import "SACacheManager.h"
#import "SAUser.h"
#import "SAWriteDateReadableModel.h"
#import <HDKitCore/HDKitCore.h>
#import <YYModel.h>
#import "SAApolloManager.h"

LKEventGroupName const LKEventGroupNameLogin = @"login";
LKEventGroupName const LKEventGroupNameViewPage = @"viewPage";
LKEventGroupName const LKEventGroupNameClick = @"click";
LKEventGroupName const LKEventGroupNameSession = @"session";
LKEventGroupName const LKEventGroupNameOther = @"other";


@implementation LKSPM

+ (instancetype)SPMWithPage:(NSString *)currentPage parent:(NSString *)parentPage child:(NSString *)childPage stayTime:(NSTimeInterval)stayTime {
    LKSPM *spm = [[LKSPM alloc] init];
    spm.currentPage = currentPage;
    spm.parentPage = parentPage;
    spm.childPage = childPage;
    spm.stayTime = stayTime;
    return spm;
}

+ (instancetype)SPMWithPage:(NSString *_Nonnull)currentPage area:(NSString *_Nullable)currentArea node:(NSString *_Nullable)node {
    LKSPM *spm = [[LKSPM alloc] init];
    spm.currentPage = currentPage;
    spm.currentArea = currentArea;
    spm.node = node;
    return spm;
}

@end


@implementation LKRecord

+ (instancetype)recordWithSessionId:(NSString *_Nonnull)sessionId
                          EventGoup:(LKEventGroupName)groupName
                            eventId:(NSString *_Nonnull)eventId
                          eventName:(NSString *_Nullable)eventName
                                ext:(NSDictionary *_Nullable)ext
                                SPM:(LKSPM *_Nullable)spm;
{
    LKRecord *record = [[LKRecord alloc] init];
    record.sessionId = sessionId;
    record.eventGroup = groupName;
    record.event = eventId;
    record.businessName = HDIsStringEmpty(eventName) ? @"" : eventName;
    if (ext) {
        record.ext = ext;
    } else {
        record.ext = @{};
    }

    record.recordTime = [[NSString stringWithFormat:@"%.0f", [[NSDate new] timeIntervalSince1970] * 1000] integerValue];
    if (spm) {
        record.spm = spm;
    } else {
        record.spm = [LKSPM SPMWithPage:@"" area:@"" node:@""];
    }

    record.appId = @"SuperApp";
    record.appNo = @"11";
    record.channel = @"AppStore";
    record.appVersion = [HDDeviceInfo appVersion];
    record.deviceId = [HDDeviceInfo getUniqueId];
    record.deviceType = @"iOS";
    record.language = [SAMultiLanguageManager currentLanguage];
    if ([SAUser hasSignedIn]) {
        record.operatorNo = SAUser.shared.operatorNo;
        record.loginName = SAUser.shared.loginName;
    }

    if ([HDLocationManager.shared isCoordinate2DValid:HDLocationManager.shared.realCoordinate2D]) {
        record.latitude = [NSString stringWithFormat:@"%f", HDLocationManager.shared.realCoordinate2D.latitude];
        record.longitude = [NSString stringWithFormat:@"%f", HDLocationManager.shared.realCoordinate2D.longitude];
    }

    return record;
}

@end

#define kCacheKeyStandardRecords @"com.kh-super.superapp.records.standard.cacheV3"
#define kCacheKeyOtherRecords @"com.kh-super.superapp.records.other.cacheV3"


@interface LKRecordPool ()

@property (atomic, strong) NSMutableArray<LKRecord *> *standardRecords; ///< 标准事件
@property (atomic, strong) NSMutableArray<LKRecord *> *otherRecords;    ///< 其他事件
@property (nonatomic, strong) dispatch_queue_t lockQueue;
@property (atomic, strong) NSLock *taskLock;

@end


@implementation LKRecordPool

- (instancetype)init {
    self = [super init];
    if (self) {
        self.standardRecords = [[NSMutableArray alloc] initWithCapacity:40];
        self.otherRecords = [[NSMutableArray alloc] initWithCapacity:40];
        self.lockQueue = dispatch_queue_create("com.wownow.datarecord.lock", DISPATCH_QUEUE_SERIAL);
        self.taskLock = NSLock.new;

        
        NSString *standardPoolSize = [SAApolloManager getApolloConfigForKey:kApolloConfigKeyDataRecordStandardPoolSize];
        if (standardPoolSize.integerValue > 0) {
            self.standardPoolSize = standardPoolSize.integerValue;
        } else {
            self.standardPoolSize = 20;
        }

        NSString *otherPoolSize = [SAApolloManager getApolloConfigForKey:kApolloConfigKeyDataRecordOtherPoolSize];
        if (otherPoolSize.integerValue > 0) {
            self.otherPoolSize = otherPoolSize.integerValue;
        } else {
            self.otherPoolSize = 20;
        }
    }
    return self;
}

- (void)addRecord:(LKRecord *)record {
//    HDLog(@"添加埋点:\n  ⚠️event:%@ \n ⚠️businessName:%@ \n ⚠️ext:%@", record.event, record.businessName, record.ext);

    NSString *LkSwitch = [SAApolloManager getApolloConfigForKey:kApolloConfigKeyDataRecordSwitch];
    if (HDIsStringNotEmpty(LkSwitch) && [[LkSwitch lowercaseString] isEqualToString:@"off"]) {
        return;
    }
    [self logMessage:@"添加埋点，请求锁"];
    @HDWeakify(self);
    [self lockInstanceCompletion:^{
        @HDStrongify(self);
        [self logMessage:@"添加埋点，拿到锁"];
        if ([record.eventGroup isEqualToString:LKEventGroupNameOther]) {
            [self.otherRecords addObject:record];
        } else {
            [self.standardRecords addObject:record];
        }
        [self.taskLock unlock];

        [self logMessage:@"添加完毕，解锁"];

        if (self.standardRecords.count >= self.standardPoolSize) {
            // 池子满了，开始上送
            [self pushStandardRecords];
        }

        if (self.otherRecords.count >= self.otherPoolSize) {
            // 池子满了，开始上送
            [self pushOtherRecords];
        }
    }];
}

- (void)pushRecords {
    //主动上送
    [self pushStandardRecords];
    [self pushOtherRecords];
}

- (void)pushStandardRecords {
    //复制一份
    [self logMessage:@"上传标准事件，锁定数组"];
    @HDWeakify(self);
    [self lockInstanceCompletion:^{
        @HDStrongify(self);
        [self logMessage:@"上传标准事件，拿到锁"];
        if (self.standardRecords.count) {
            NSArray *uploadCache = [self.standardRecords copy];
            [self.standardRecords removeObjectsInArray:uploadCache];
            [self logMessage:@"上传标准事件，解锁"];
            [self.taskLock unlock];
            [self _pushStandardRecords:uploadCache];
        } else {
            [self logMessage:@"标准事件池为空，解锁"];
            [self.taskLock unlock];
        }
    }];
}

- (void)_pushStandardRecords:(NSArray<LKRecord *> *)copyArr {
    // 分组 每次上传20条
    NSArray<NSArray *> *groupArr = [copyArr hd_splitArrayWithEachCount:20];
    for (NSUInteger i = 0; i < groupArr.count; i++) {
        NSArray<LKRecord *> *data = groupArr[i];
        [self logMessage:[NSString stringWithFormat:@"开始上传标准事件，第%zd/%zd组,共%zd. queue:%zd", i, groupArr.count, copyArr.count, self.standardRecords.count]];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"standardCollectionDatas"] = [data yy_modelToJSONObject];
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 1;
        request.requestURI = @"/warehouse/collection/saveStandardCollectionData.do";
        request.isNeedLogin = NO;
        request.shouldAlertErrorMsgExceptSpecCode = NO;
        request.shouldRecordAndReport = NO;
        request.logEnabled = NO;
        request.requestParameter = params;

        @HDWeakify(self);
        [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
            @HDStrongify(self);
            [self logMessage:@"上传标准成功"];
        } failure:^(HDNetworkResponse *_Nonnull response) {
            @HDStrongify(self);
            [self logMessage:@"上传标准失败"];
        }];
    }
}

- (void)pushOtherRecords {
    // 复制一份
    [self logMessage:@"上传其他事件，锁定数组"];
    @HDWeakify(self);
    [self lockInstanceCompletion:^{
        @HDStrongify(self);
        [self logMessage:@"上传其他，拿到锁"];
        if (self.otherRecords.count) {
            NSArray<LKRecord *> *uploadCache = [self.otherRecords copy];
            [self.otherRecords removeObjectsInArray:uploadCache];
            [self logMessage:@"上传其他，解锁"];
            [self.taskLock unlock];
            [self _pushOtherRecords:uploadCache];
        } else {
            [self logMessage:@"其他事件池为空，解锁"];
            [self.taskLock unlock];
        }
    }];
}

- (void)_pushOtherRecords:(NSArray<LKRecord *> *)copyArr {
    // 分组 每次上传20条
    if(![copyArr isKindOfClass:NSArray.class]) {
        return;
    }
    
    if(copyArr.count == 0) {
        return;
    }
    
    NSArray<NSArray *> *groupArr = [copyArr hd_splitArrayWithEachCount:20];

    for (NSUInteger i = 0; i < groupArr.count; i++) {
        NSArray<LKRecord *> *data = groupArr[i];
        [self logMessage:[NSString stringWithFormat:@"开始上传其他事件，第%zd/%zd组,共%zd. queue:%zd", i, groupArr.count, copyArr.count, self.otherRecords.count]];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"otherCollectionDatas"] = [data yy_modelToJSONObject];
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 1;
        request.requestURI = @"/warehouse/collection/saveOtherCollectionData.do";
        request.isNeedLogin = NO;
        request.shouldAlertErrorMsgExceptSpecCode = NO;
        request.shouldRecordAndReport = NO;
        request.logEnabled = NO;
        request.requestParameter = params;
        @HDWeakify(self);
        [request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
            @HDStrongify(self);
            [self logMessage:@"上传其他成功"];
        } failure:^(HDNetworkResponse *_Nonnull response) {
            @HDStrongify(self);
            [self logMessage:@"上传其他失败"];
        }];
    }
}

- (void)archiveRecords {
    @HDWeakify(self);
    [self logMessage:@"归档，请求锁"];
    [self lockInstanceCompletion:^{
        @HDStrongify(self);
        [self logMessage:@"归档，拿到锁"];
        NSMutableArray<LKRecord *> *standardTmp = [self.standardRecords mutableCopy];

        SAWriteDateReadableModel *cacheModel = [SACacheManager.shared objectForKey:kCacheKeyStandardRecords type:SACacheTypeDocumentPublic];
        NSArray<LKRecord *> *cacheRecords = [NSArray yy_modelArrayWithClass:LKRecord.class json:cacheModel.storeObj];
        if (cacheRecords.count > 0) {
            [standardTmp addObjectsFromArray:cacheRecords];
        }

        [SACacheManager.shared setObject:[SAWriteDateReadableModel modelWithStoreObj:standardTmp] forKey:kCacheKeyStandardRecords type:SACacheTypeDocumentPublic];
        [self.standardRecords removeObjectsInArray:standardTmp];

        NSMutableArray<LKRecord *> *otherTmp = [self.otherRecords mutableCopy];
        cacheModel = nil;
        cacheModel = [SACacheManager.shared objectForKey:kCacheKeyOtherRecords type:SACacheTypeDocumentPublic];
        NSArray<LKRecord *> *cacheOtherRecords = [NSArray yy_modelArrayWithClass:LKRecord.class json:cacheModel.storeObj];
        if (cacheOtherRecords.count > 0) {
            [otherTmp addObjectsFromArray:cacheOtherRecords];
        }

        [SACacheManager.shared setObject:[SAWriteDateReadableModel modelWithStoreObj:otherTmp] forKey:kCacheKeyOtherRecords type:SACacheTypeDocumentPublic];
        [self.otherRecords removeObjectsInArray:otherTmp];

        [self.taskLock unlock];
        [self logMessage:@"归档，解锁"];
    }];
}

- (void)unarchiveRecords {
    @HDWeakify(self);
    [self logMessage:@"解档，请求锁"];
    [self lockInstanceCompletion:^{
        @HDStrongify(self);
        [self logMessage:@"解档，拿到锁"];
        SAWriteDateReadableModel *cacheModel = [SACacheManager.shared objectForKey:kCacheKeyStandardRecords type:SACacheTypeDocumentPublic];
        NSArray<LKRecord *> *cacheRecords = [NSArray yy_modelArrayWithClass:LKRecord.class json:cacheModel.storeObj];
        // 清空缓存
        [SACacheManager.shared setObject:[SAWriteDateReadableModel modelWithStoreObj:@[]] forKey:kCacheKeyStandardRecords type:SACacheTypeDocumentPublic];
        [self.standardRecords addObjectsFromArray:cacheRecords];

        cacheModel = [SACacheManager.shared objectForKey:kCacheKeyOtherRecords type:SACacheTypeDocumentPublic];
        NSArray<LKRecord *> *cacheOtherRecords = [NSArray yy_modelArrayWithClass:LKRecord.class json:cacheModel.storeObj];
        //清空缓存
        [SACacheManager.shared setObject:[SAWriteDateReadableModel modelWithStoreObj:@[]] forKey:kCacheKeyOtherRecords type:SACacheTypeDocumentPublic];
        [self.otherRecords addObjectsFromArray:cacheOtherRecords];

        [self.taskLock unlock];
        [self logMessage:@"解档，解锁"];
    }];
}


- (void)lockInstanceCompletion:(void (^)(void))completion {
    @HDWeakify(self);
    dispatch_async(self.lockQueue ? self.lockQueue : dispatch_queue_create("com.wownow.datarecord.lock", DISPATCH_QUEUE_SERIAL), ^{
        @HDStrongify(self);
        [self.taskLock lock];
        completion();
    });
}


- (void)logMessage:(NSString *)msg {
    //    HDLog(@"[%@]%@", [NSThread currentThread], msg);
}

@end
