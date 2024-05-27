//
//  SAAppEnvManager.m
//  SuperApp
//
//  Created by VanJay on 2020/4/3.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAAppEnvManager.h"
#import "NSDate+SAExtension.h"
#import "SAAppSwitchManager.h"
#import "SACommonConst.h"
#import "SAGeneralUtil.h"
#import <HDKitCore/NSArray+HDKitCore.h>

static NSString *const kSAAPPCurrentEnvTypeCacheKey = @"kSAAPPCurrentEnvTypeCacheKey";

NSString *const kNotificationNameChangeAppEnvSuccess = @"kNotificationNameChangeAppEnvSuccess";


@interface SAAppEnvManager ()
@property (nonatomic, strong) SAAppEnvConfig *appEnvConfig;
/// 所有线路配置
@property (nonatomic, copy) NSArray<SAAppEnvConfig *> *dataSource;
///< 备用线路
@property (nonatomic, copy) NSArray<SAAppEnvConfig *> *backupLines;
///< 环境切换时间
@property (nonatomic, strong) NSDate *lastSwitchDate;
///< 切换队列
@property (nonatomic, strong) dispatch_queue_t cacheQueue;
///< 切换次数
@property (nonatomic, assign) NSUInteger maxSwitchCount;
@end


@implementation SAAppEnvManager
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static SAAppEnvManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
        instance.cacheQueue = dispatch_queue_create("com.wownow.environment.switch.queue", DISPATCH_QUEUE_SERIAL);
        instance.maxSwitchCount = 2; // 最多切两次
#if EnableDebug
        SAAppEnvType type = SAAppEnvTypeUAT;
        SAAppEnvType localType = [instance getLocalEnvType];
        NSArray<SAAppEnvType> *suppoted = instance.supportEnvTypes;
        if ([suppoted containsObject:localType]) {
            type = localType;
        }
        [instance setEnvType:type];
#else
            SAAppEnvType type = SAAppEnvTypeProduct;
            SAAppEnvType localType = [instance getLocalEnvType];
            if ([localType isEqualToString:SAAppEnvTypeProduct] || [localType isEqualToString:SAAppEnvTypeBakcup]) {
                type = localType;
            }
            [instance setEnvType:type];
#endif
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

#pragma mark - private methods
/// 所有支持的环境
- (NSArray<SAAppEnvType> *)supportEnvTypes {
    return [self.dataSource mapObjectsUsingBlock:^SAAppEnvType _Nonnull(SAAppEnvConfig *_Nonnull obj, NSUInteger idx) {
        return obj.type;
    }];
}

- (void)saveEnvTypeToLocal:(SAAppEnvType)type {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:type forKey:kSAAPPCurrentEnvTypeCacheKey];
    [defaults synchronize];
}

- (SAAppEnvType)getLocalEnvType {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:kSAAPPCurrentEnvTypeCacheKey];
}

- (void)p_setEnvConfig:(SAAppEnvConfig *)config {
    // 标志启动设置
    BOOL isOldEmpty = !self.appEnvConfig;
    self.appEnvConfig = config;

    // 存储
    [self saveEnvTypeToLocal:config.type];

    if (!isOldEmpty) {
        // 发出通知线路切换完成
        [NSNotificationCenter.defaultCenter postNotificationName:kNotificationNameChangeAppEnvSuccess object:nil];
        self.lastSwitchDate = NSDate.new;
    }
    HDLog(@"环境已配置，%@", config);
}

#pragma mark - public methods
- (void)setEnvType:(SAAppEnvType)type {
    if (![self.supportEnvTypes containsObject:type]) {
        return;
    }
    // 同样的type不需要设置第二次，除了备份线路
    if ([self.appEnvConfig.type isEqualToString:type] && ![type isEqualToString:SAAppEnvTypeBakcup]) {
        return;
    }

    NSArray<SAAppEnvConfig *> *filteredConfigs =
        [self.dataSource filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(SAAppEnvConfig *_Nullable evaluatedObject, NSDictionary<NSString *, id> *_Nullable bindings) {
                             return [evaluatedObject.type isEqualToString:type];
                         }]];

    if (filteredConfigs.count > 0 && [type isEqualToString:SAAppEnvTypeBakcup]) {
        if (filteredConfigs.count == 1) {
            [self p_setEnvConfig:filteredConfigs.firstObject];
        } else {
            NSUInteger idx = arc4random() % filteredConfigs.count;
            [self p_setEnvConfig:filteredConfigs[idx]];
        }
    } else if (filteredConfigs.count > 0) {
        [self p_setEnvConfig:filteredConfigs.firstObject];
    } else {
        [self setEnvType:SAAppEnvTypeProduct];
    }
}

- (void)envSwitchCompletion:(void (^)(BOOL hasSwitch))completion {
    HDLog(@"☣️☣️☣️进入队列，准备切换线路...");
    @HDWeakify(self);
    dispatch_async(self.cacheQueue ? self.cacheQueue : dispatch_queue_create("com.wownow.environment.switch.queue", DISPATCH_QUEUE_SERIAL), ^{
        @HDStrongify(self);
        HDLog(@"☣️☣️☣️检查剩余次数【%zd】...上次切换时间【%@】", self.maxSwitchCount, [self.lastSwitchDate stringWithFormatStr:@"dd HH:mm:ss ffff"]);
        if (self.maxSwitchCount > 0) {
            if ([SAGeneralUtil getDiffValueUntilNowForDate:self.lastSwitchDate] > 20) {
                HDLog(@"☣️☣️☣️条件满足，开始切换");
                [self setEnvType:SAAppEnvTypeBakcup];
                self.maxSwitchCount--;
                HDLog(@"☣️☣️☣️延迟1秒，执行回调");
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
                    completion(YES);
                });
            } else {
                HDLog(@"☣️☣️☣️20秒内已经切过，延迟2秒返回");
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
                    completion(YES);
                });
            }
        } else {
            HDLog(@"☣️☣️☣️没有切换次数，切换失败");
            completion(NO);
        }
    });
}

#pragma mark - lazy load
- (NSArray<SAAppEnvConfig *> *)dataSource {
    if (!_dataSource) {
        NSMutableArray<SAAppEnvConfig *> *tmp = [[NSMutableArray alloc] initWithCapacity:5];
        [tmp addObjectsFromArray:[NSArray yy_modelArrayWithClass:SAAppEnvConfig.class json:self.baseAppServerConfigs]];
        [tmp addObjectsFromArray:self.backupLines];
        _dataSource = [NSArray arrayWithArray:tmp];
    }
    return _dataSource;
}

- (NSArray<SAAppEnvConfig *> *)backupLines {
    if (!_backupLines) {
        _backupLines = [NSArray yy_modelArrayWithClass:SAAppEnvConfig.class json:[[SAAppSwitchManager shared] switchForKey:SAAppSwitchBackUpLines]];
    }

    return _backupLines;
}

- (NSArray<NSDictionary *> *)baseAppServerConfigs {
    return @[
        @{
            @"serviceURL": @"https://appgateway.lifekh.com/gateway_web",
            @"fileServer": @"https://h5.lifekh.com/file_web/file-service/file",
            @"ocrServer": @"https://ocr.lifekh.com/apis",
            @"h5URL": @"https://h5.lifekh.com",
            @"openAPIURL": @"https://openapi.vipaylife.com/",
            @"downloadURL": @"https://fileserver.vipaylife.com/file_web/file-service/file/download.do",
            @"tinhNowHost": @"https://tinhnow.wownow.net",
            @"type": SAAppEnvTypeProduct,
            @"name": @"生产环境",
            //支付类
            @"payServiceURL": @"https://appgateway.coolcashcam.com/gateway_web",
            @"payH5Url": @"https://app-h5.vipaylife.com/app-h5/",
            @"payFileServer": @"https://fileserver.coolcashcam.com",
            @"coolcashcam": @"https://appgw.coolcashcam.com",
            @"tinhNowLog": @"https://log.wownow.net",
        },
        @{
            @"serviceURL": @"https://appgateway-pre.lifekh.com/gateway_web",
            @"fileServer": @"https://h5-pre.lifekh.com/file_web/file-service/file",
            @"ocrServer": @"https://ocr-pre.lifekh.com/apis",
            @"h5URL": @"https://app-h5-pre.lifekh.com",
            @"openAPIURL": @"https://openapi-pre.lifekh.com/",
            @"downloadURL": @"https://fileserver-pre.lifekh.com/file_web/file-service/file/download.do",
            @"tinhNowHost": @"https://tinhnow-pre.wownow.net",
            @"type": SAAppEnvTypePreRelease,
            @"name": @"预发布环境",
            //支付类
            @"payServiceURL": @"https://appgateway-pre.vipaylife.com/gateway_web",
            @"payH5Url": @"https://app-h5-pre.vipaylife.com/app-h5/",
            @"payFileServer": @"https://fileserver-pre.vipaylife.com",
            @"coolcashcam": @"https://appgw-pre.coolcashcam.com",
            @"tinhNowLog": @"https://log.wownow.net",
        },
        @{
            @"serviceURL": @"https://appgateway-uat.lifekh.com/gateway_web",
            @"fileServer": @"https://h5-uat.lifekh.com/file_web/file-service/file",
            @"ocrServer": @"https://ocr-uat.lifekh.com/apis",
            @"h5URL": @"https://h5-uat.lifekh.com",
            @"openAPIURL": @"https://uat.x-vipay.com/",
            @"downloadURL": @"https://uat.x-vipay.com/file_web/file-service/file/download.do",
            @"tinhNowHost": @"https://tinhnow-uat.wownow.net",
            @"type": SAAppEnvTypeUAT,
            @"name": @"UAT 环境",
            //支付类
            @"payServiceURL": @"https://appgateway-uat.coolcashcam.com/gateway_web",
            @"payH5Url": @"https://app-h5-uat.coolcashcam.com/app-h5/",
            @"payFileServer": @"https://fileserver-uat.coolcashcam.com",
            @"coolcashcam": @"https://appgw-uat.coolcashcam.com",
            @"tinhNowLog": @"https://log-uat.wownow.net",
        },
        @{
            @"serviceURL": @"https://appgateway-fat.lifekh.com/gateway_web",
            @"fileServer": @"https://h5-fat.lifekh.com/file_web/file-service/file",
            @"ocrServer": @"https://ocr-fat.lifekh.com/apis",
            @"h5URL": @"https://h5-fat.lifekh.com",
            @"openAPIURL": @"https://fat.x-vipay.com/",
            @"downloadURL": @"https://fat.x-vipay.com/file_web/file-service/file/download.do",
            @"tinhNowHost": @"https://tinhnow-fat.wownow.net",
            @"payNowHost": @"https://appgateway-fat.coolcashcam.com/gateway_web",
            @"type": SAAppEnvTypeFAT,
            @"name": @"FAT 环境",
            //支付类
            @"payServiceURL": @"https://appgateway-fat.coolcashcam.com/gateway_web",
            @"payH5Url": @"https://app-h5-fat.coolcashcam.com/app-h5/",
            @"payFileServer": @"https://fileserver-fat.coolcashcam.com/files/app/",
            @"coolcashcam": @"https://appgw-fat.coolcashcam.com",
            @"tinhNowLog": @"https://log-uat.wownow.net",

        },
        @{
            @"serviceURL": @"https://appgateway-sit.lifekh.com/gateway_web",
            @"fileServer": @"https://h5-sit.lifekh.com/file_web/file-service/file",
            @"ocrServer": @"https://ocr-sit.lifekh.com/apis",
            @"h5URL": @"https://h5-sit.lifekh.com",
            @"openAPIURL": @"https://sit.x-vipay.com/",
            @"downloadURL": @"https://sit.x-vipay.com/file_web/file-service/file/download.do",
            @"tinhNowHost": @"https://tinhnow-sit.wownow.net",
            @"type": SAAppEnvTypeSIT,
            @"name": @"SIT 环境",
            //支付类
            @"payServiceURL": @"https://appgateway-sit.coolcashcam.com/gateway_web",
            @"payH5Url": @"https://app-h5-sit.coolcashcam.com/app-h5/",
            @"payFileServer": @"https://fileserver-sit.coolcashcam.com",
            @"coolcashcam": @"https://appgw-sit.coolcashcam.com", //@"http://172.16.20.63:8080",
            @"tinhNowLog": @"https://log-sit.wownow.net",
        },
        @{
            @"serviceURL": @"https://appgateway-uat.lifekh.com/gateway_web",
            @"fileServer": @"https://h5-uat.lifekh.com/file_web/file-service/file",
            @"ocrServer": @"https://ocr-uat.lifekh.com/apis",
            @"h5URL": @"https://h5-uat.lifekh.com",
            @"openAPIURL": @"https://uat.x-vipay.com/",
            @"downloadURL": @"https://uat.x-vipay.com/file_web/file-service/file/download.do",
            @"tinhNowHost": @"https://tinhnow-sit.wownow.net",
            @"type": SAAppEnvTypeMOCK,
            @"name": @"MOCK 环境",
            //支付类
            @"payServiceURL": @"https://appgateway-uat.coolcashcam.com/gateway_web",
            @"payH5Url": @"https://app-h5-uat.coolcashcam.com/app-h5/",
            @"payFileServer": @"https://fileserver-sit.coolcashcam.com",
            @"coolcashcam": @"https://appgw-sit.coolcashcam.com",
            @"tinhNowLog": @"https://log-sit.wownow.net",
        }
    ];
}
@end
