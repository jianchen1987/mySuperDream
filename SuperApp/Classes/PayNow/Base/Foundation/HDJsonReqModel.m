//
//  HDJsonReqModel.m
//  National Wallet
//
//  Created by 陈剑 on 2018/4/25.
//  Copyright © 2018年 chaos technology. All rights reserved.
//

#import "HDJsonReqModel.h"
#import "HDDeviceInfo.h"
#import "HDLocationManager.h"
#import "HDLocationUtils.h"
#import "NSString+HD_MD5.h"
#import "PNCommonUtils.h"
#import "PNUtilMacro.h"
#import "SAUser.h"
#import "UIDevice+Extension.h"
#import "VipayUser.h"
#import <YYModel/YYModel.h>


@interface HDJsonReqModel ()
@property (nonatomic, strong) NSMutableDictionary *params;
@end


@implementation HDJsonReqModel

- (instancetype)init {
    if (self = [super init]) {
        self.params = [[NSMutableDictionary alloc] init];
        self.retryCount = 0;
        self.retryInterval = 0;
        self.retryProgressive = NO;
        self.isNeedLogin = YES;
    }
    return self;
}

- (void)packageRiskInfo {
    [_params setObject:@"userApp" forKey:@"appType"];
    if ([VipayUser shareInstance].loginName.length > 0) {
        [_params setObject:[VipayUser shareInstance].loginName forKey:@"loginName"];
    }
}

/** 处理参数中 value 是字典或数组 */
- (NSMutableDictionary *)getFinalParams {
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionaryWithDictionary:_params];
    return requestDic;
}

/** 对数组或者字典嵌套递归排序 */
- (id)sortedObjectForRecursiveNestedObject:(id)object {
    id output = object;

    if ([object isKindOfClass:NSDictionary.class]) {
        NSDictionary *dict = (NSDictionary *)object;
        NSMutableDictionary *tmpDict = [NSMutableDictionary dictionaryWithCapacity:dict.count];
        NSArray *keys = [[dict allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
            return (NSComparisonResult)[str1 compare:str2 options:NSNumericSearch];
        }];
        for (NSString *key in keys) {
            id value = [dict valueForKey:key];
            tmpDict[key] = [self sortedObjectForRecursiveNestedObject:value];
        }
        output = tmpDict;
    } else if ([object isKindOfClass:NSArray.class]) {
        NSArray *arr = (NSArray *)object;
        NSMutableArray *tmpArr = [NSMutableArray arrayWithCapacity:arr.count];
        for (id subObject in arr) {
            [tmpArr addObject:[self sortedObjectForRecursiveNestedObject:subObject]];
        }
        output = tmpArr;
    }
    return output;
}

/** 对数组或者字典嵌套递归输出用于 md5 加密的字符串 */
- (NSString *)stringForRecursiveNestedObject:(id)object {
    NSString *jsonStr = object;

    if ([object isKindOfClass:NSDictionary.class]) {
        NSDictionary *dictionary = (NSDictionary *)object;

        NSArray *keys = [[dictionary allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
            return (NSComparisonResult)[str1 compare:str2 options:NSNumericSearch];
        }];

        NSMutableString *oriSig = [[NSMutableString alloc] init];
        [oriSig appendString:@"{"];
        for (int i = 0; i < dictionary.count; i++) {
            [oriSig appendString:keys[i]];
            [oriSig appendString:@"="];
            id value = [dictionary objectForKey:keys[i]];

            value = [self stringForRecursiveNestedObject:value];
            [oriSig appendString:[NSString stringWithFormat:@"%@", value]];
            if (i < keys.count - 1) {
                [oriSig appendString:@"&"];
            }
        }
        [oriSig appendString:@"}"];
        jsonStr = oriSig;
    } else if ([object isKindOfClass:NSArray.class]) {
        jsonStr = @"[";
        NSArray *array = (NSArray *)object;
        for (NSInteger i = 0; i < array.count; ++i) {
            if (i != 0) {
                jsonStr = [jsonStr stringByAppendingString:@", "];
            }

            id value = [self stringForRecursiveNestedObject:array[i]];
            jsonStr = [jsonStr stringByAppendingString:[NSString stringWithFormat:@"%@", value]];
        }
        jsonStr = [jsonStr stringByAppendingString:@"]"];
    }
    return jsonStr;
}

/** 获取 md5 签名 */
- (NSString *)getSignature {
    NSDictionary *requestDic = [self getFinalParams];

    NSArray *keys = [[requestDic allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
        return (NSComparisonResult)[str1 compare:str2 options:NSNumericSearch];
    }];
    NSMutableString *oriSign = [[NSMutableString alloc] init];
    if ([VipayUser isLogin] && self.isNeedLogin) {
        [oriSign appendString:[VipayUser shareInstance].mobileToken];
    } else {
        [oriSign appendString:@"chaos"];
    }
    for (NSString *key in keys) {
        id value = [requestDic valueForKey:key];
        [oriSign appendFormat:@"&%@=%@", key, [self stringForRecursiveNestedObject:value]];
    }

    // HDLog(@"生成 md5 原始字符串：%@", oriSign);
    NSString *md5 = [oriSign hd_md5];
    // HDLog(@"生成 md5 ：%@", md5);
    return md5;
}

- (NSDictionary *)getRequestJsonDictionary {
    [self packageRiskInfo];

    self.requestTm = [PNCommonUtils getCurrentDateStrByFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.platformName = @"IOS";
    self.deviceId = [UIDevice uniqueIdentifier];
    self.tokenId = self.isNeedLogin ? ([VipayUser isLogin] ? [VipayUser shareInstance].sessionKey : @"") : @"";
    self.acceptLanguage = SAMultiLanguageManager.currentLanguage;
    self.appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (self.needSessionKey) {
        self.sessionKey = [VipayUser shareInstance].sessionKey;
    }
    self.md5 = [self getSignature];

    NSMutableDictionary *requestDic = [self getFinalParams];
    NSArray *keys = [[requestDic allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
        return (NSComparisonResult)[str1 compare:str2 options:NSNumericSearch];
    }];
    for (NSString *key in keys) {
        id value = [requestDic valueForKey:key];
        value = [self sortedObjectForRecursiveNestedObject:value];
        [requestDic setObject:value forKey:key];
    }

    return requestDic;
}

- (void)setReqParams:(NSDictionary *)params {
    [self.params addEntriesFromDictionary:params];

    self.paramsStr = [self.params yy_modelToJSONString];
}

- (NSString *)getTraceNo {
    return [NSString stringWithFormat:@"%@%04d%06d%04d%04d", [PNCommonUtils getyyyyMMddhhmmss:[NSDate date]], arc4random() % 10000, arc4random() % 1000000, arc4random() % 10000, arc4random() % 10000];
}

/// 获取设备相关信息
+ (NSString *)getDeviceInfo {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:25];
    ///< 厂家
    [dic setValue:@"apple" forKey:@"brand"];
    ///< 型号
    [dic setValue:[UIDevice model] forKey:@"model"];
    ///< 厂家
    [dic setValue:[UIDevice name] forKey:@"manufacturer"];
    ///< 系统版本
    [dic setValue:[UIDevice systemVersion] forKey:@"osVersion"];
    ///< api版本
    [dic setValue:@"" forKey:@"apiLevel"];
    ///< 芯片架构
    [dic setValue:@"" forKey:@"abi"];
    ///< 芯片支撑架构
    [dic setValue:@"" forKey:@"supportedAbis"];
    ///< OPenGL ES版本
    [dic setValue:@"" forKey:@"glesVersion"];
    ///< 屏幕宽高
    [dic setValue:[UIDevice WxH] forKey:@"WxH"];
    ///< 屏幕密度
    [dic setValue:[UIDevice density] forKey:@"density"];
    ///< 屏幕密度DP
    [dic setValue:@"" forKey:@"densityDpi"];
    ///< 手机内存
    [dic setValue:[UIDevice totalMemory] forKey:@"memory"];
    ///< cpu核数
    [dic setValue:@"" forKey:@"cpuCore"];
    ///< 语言
    [dic setValue:[UIDevice language] forKey:@"language"];
    ///< 国家地区
    [dic setValue:[UIDevice region] forKey:@"region"];
    ///< app版本号
    [dic setValue:[[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"] forKey:@"appVersion"];
    ///< 渠道
    [dic setValue:@"AppStore" forKey:@"appChannel"];
    ///< 设备号
    [dic setValue:[UIDevice uniqueIdentifier] forKey:@"deviceId"];

    if ([HDLocationUtils getCLAuthorizationStatus] == HDCLAuthorizationStatusAuthed) {
        ///< 经度
        [dic setValue:[NSString stringWithFormat:@"%f", [HDLocationManager shared].coordinate2D.latitude] forKey:@"latitude"];
        ///< 纬度
        [dic setValue:[NSString stringWithFormat:@"%f", [HDLocationManager shared].coordinate2D.longitude] forKey:@"longitude"];
    } else {
        ///< 经度
        [dic setValue:@"" forKey:@"latitude"];
        ///< 纬度
        [dic setValue:@"" forKey:@"longitude"];
    }
    ///< pos sp版本
    [dic setValue:@"" forKey:@"spVersion"];

    [dic setValue:@"" forKey:@"posVersion"];
    ///<  广告标识符
    [dic setValue:[UIDevice IDFA] forKey:@"IDFA"];
    ///<  设备标识符
    [dic setValue:[UIDevice UUID] forKey:@"UUID"];
    ///< 磁盘总大小
    [dic setValue:[UIDevice totalDisk] forKey:@"totalDisk"];
    ///< 运营商
    [dic setValue:[UIDevice networkBrand] forKey:@"networkBrand"];
    ///< 网络类型
    [dic setValue:[PNCommonUtils getCurrentNetworkType] forKey:@"networkType"];
    ///< 电池状态
    [dic setValue:[UIDevice batteryState] forKey:@"batteryState"];
    ///< 电量
    [dic setValue:[UIDevice batteryLevel] forKey:@"batteryLevel"];

    return [dic yy_modelToJSONString];
}

@end
