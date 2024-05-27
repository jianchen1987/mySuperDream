//
//  UIDevice+Extension.m
//  ViPay
//
//  Created by VanJay on 2019/8/24.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "SACacheManager.h"
#import "UIDevice+Extension.h"
#import <AdSupport/ASIdentifierManager.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <sys/mount.h>

static NSString *const kUniqueIdentifierKey = @"com.vipay.uniqueIdentifier";


@implementation UIDevice (Extension)

/** 获取IDFA */
+ (NSString *)IDFA {
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

/** 获取IDFV */
+ (NSString *)IDFV {
    return [[UIDevice currentDevice].identifierForVendor UUIDString];
}

/** 获取UUID */
+ (NSString *)UUID {
    return [[NSUUID UUID] UUIDString];
}

+ (NSString *)model {
    return [UIDevice currentDevice].model;
}

+ (NSString *)name {
    return [UIDevice currentDevice].name;
}

+ (NSString *)systemVersion {
    return [UIDevice currentDevice].systemVersion;
}

+ (NSString *)WxH {
    return [NSString stringWithFormat:@"%.1f/%.1f", [UIScreen mainScreen].nativeBounds.size.width, [UIScreen mainScreen].nativeBounds.size.height];
}

+ (NSString *)density {
    return [NSString stringWithFormat:@"%.1f", [UIScreen mainScreen].nativeScale];
}

+ (NSString *)totalMemory {
    return [NSString stringWithFormat:@"%llu", [NSProcessInfo processInfo].physicalMemory];
}

+ (NSString *)language {
    return [[NSLocale preferredLanguages] objectAtIndex:0];
}

+ (NSString *)region {
    return [NSLocale currentLocale].localeIdentifier;
}

+ (NSString *)batteryState {
    return [NSString stringWithFormat:@"%ld", [UIDevice currentDevice].batteryState];
}

+ (NSString *)batteryLevel {
    return [NSString stringWithFormat:@"%.2f", [UIDevice currentDevice].batteryLevel];
}

+ (NSString *)totalDisk {
    struct statfs buf;
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0) {
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_blocks);
    }
    return [NSString stringWithFormat:@"%llu", freeSpace];
}

+ (NSString *)networkBrand {
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    return carrier.carrierName;
}

+ (NSString *)uniqueIdentifier {
    // 从缓存读取
    NSString *uqid = [SACacheManager.shared objectForKey:kUniqueIdentifierKey type:SACacheTypeKeyChainPublic];

    if (!uqid) {
        // 获取 IDFA
        uqid = [self IDFA];

        // IDFA获取失败的情况，获取IDFV
        if (!uqid || [uqid isEqualToString:@"00000000-0000-0000-0000-000000000000"]) {
            uqid = [self IDFV];

            // IDFV获取失败的情况，获取uuid
            if (!uqid) {
                uqid = [self UUID];
            }
        }
        [SACacheManager.shared setObject:uqid forKey:kUniqueIdentifierKey type:SACacheTypeKeyChainPublic];
    }
    return uqid;
}

@end
