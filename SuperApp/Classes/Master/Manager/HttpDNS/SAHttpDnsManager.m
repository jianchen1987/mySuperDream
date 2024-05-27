//
//  SAHttpDnsManager.m
//  SuperApp
//
//  Created by Tia on 2022/7/1.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAHttpDnsManager.h"
#import "SAAppSwitchManager.h"
#import "SACacheManager.h"
#import <AlicloudHttpDNS/AlicloudHttpDNS.h>
#import <HDKitCore/HDLog.h>
#import <UIKit/UIKit.h>


@interface SAHttpDnsManager () <HttpDNSDegradationDelegate>
/// httpdns实例对象
@property (nonatomic, strong) HttpDnsService *httpdns;
/// 需要获取ip的host数组
@property (nonatomic, strong) NSArray *targetHosts;

@property (nonatomic, strong) NSMutableDictionary *hostDic;
/// app是否处于不活跃状态，默认NO
@property (nonatomic) BOOL isApplicationStateInactive;

@end

//缓存间隔时间
static NSInteger kSAHttpDnsMargin = 300;
//缓存标识
static NSString *const kCacheKeyHttpDns = @"com.superapp.public.httpDns";
//缓存keyIp
static NSString *const kHttpDnsCacheIp = @"ip";
//缓存keyTimestamp
static NSString *const kHttpDnsCacheTimestamp = @"timestamp";


@implementation SAHttpDnsManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static SAHttpDnsManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
        instance.isApplicationStateInactive = YES;
        //监听app是否在前台
        [[NSNotificationCenter defaultCenter] addObserver:instance selector:@selector(appBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:instance selector:@selector(appWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
        //监听app是否在后台
        [[NSNotificationCenter defaultCenter] addObserver:instance selector:@selector(appEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:instance selector:@selector(appWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    });
    return instance;
}

#pragma mark - public methods
- (NSString *)getIpByHostAsync:(NSString *)host {
    if (!host.length)
        return nil;
    NSString *ip = nil;
    NSDictionary *targetDic = self.hostDic[host];
    if (targetDic) {
        ip = targetDic[kHttpDnsCacheIp];
        NSInteger past = [targetDic[kHttpDnsCacheTimestamp] integerValue];
        NSInteger now = time(0);
        if (now - past <= kSAHttpDnsMargin) {
            return ip;
        }
    } else {
        NSDictionary *dic = [SACacheManager.shared objectForKey:kCacheKeyHttpDns type:SACacheTypeCachePublic];
        if (dic && [dic isKindOfClass:[NSDictionary class]]) {
            targetDic = dic[host];
            if (targetDic) {
                ip = targetDic[kHttpDnsCacheIp];
                NSInteger past = [targetDic[kHttpDnsCacheTimestamp] integerValue];
                NSInteger now = time(0);
                if (now - past <= kSAHttpDnsMargin) {
                    //先存本地
                    self.hostDic[host] = targetDic.mutableCopy;
                    return ip;
                }
            }
        }
    }

    ip = [self.httpdns getIpByHostAsync:host];

    if (ip.length) {
        NSMutableDictionary *newDic = @{}.mutableCopy;
        newDic[kHttpDnsCacheIp] = ip;
        newDic[kHttpDnsCacheTimestamp] = @(time(0));
        self.hostDic[host] = newDic;
        NSDictionary *cacheDic = [SACacheManager.shared objectForKey:kCacheKeyHttpDns];
        if (cacheDic) { //已有硬盘缓存
            NSMutableDictionary *mDic = cacheDic.mutableCopy;
            mDic[host] = newDic;
            [SACacheManager.shared setObject:mDic forKey:kCacheKeyHttpDns duration:1800 type:SACacheTypeCachePublic];
        } else {
            NSMutableDictionary *mDic = @{}.mutableCopy;
            mDic[host] = newDic;
            [SACacheManager.shared setObject:mDic forKey:kCacheKeyHttpDns duration:1800 type:SACacheTypeCachePublic];
        }
    }
    return ip;
}

- (BOOL)canIntercept {
    // app不活跃不走httpdns
    if (self.isApplicationStateInactive)
        return NO;

    //根据后台配置控制是否走httpdns，默认开
    NSString *thirdPartLoginSwitch = [SAAppSwitchManager.shared switchForKey:SAAppSwitchHttpDns];
    BOOL canIntercept = (thirdPartLoginSwitch && [thirdPartLoginSwitch isEqualToString:@"on"]);
    return canIntercept;
}

#pragma mark - Notification
- (void)appBecomeActive {
    self.isApplicationStateInactive = NO;
}

- (void)appWillEnterForeground {
    self.isApplicationStateInactive = NO;
}

- (void)appEnterBackground {
    self.isApplicationStateInactive = YES;
}

- (void)appWillResignActive {
    self.isApplicationStateInactive = YES;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

#pragma mark - HttpDNSDegradationDelegate
///降级过滤器，您可以自己定义HTTPDNS降级机制
- (BOOL)shouldDegradeHTTPDNS:(NSString *)hostName {
    //    NSLog(@"Enters Degradation filter.");
    // 根据firebase设置，如果不拦截，则降级处理
    if (!self.canIntercept) {
        //        NSLog(@"Proxy was set. Degrade!");
        return YES;
    }
    //     假设您禁止"www.taobao.com"域名通过HTTPDNS进行解析
    //    if ([hostName isEqualToString:@"www.taobao.com"]) {
    //        NSLog(@"The host is in blacklist. Degrade!");
    //        return YES;
    //    }

    return NO;
}
#pragma clang diagnostic pop

#pragma mark - lazy
- (HttpDnsService *)httpdns {
    if (!_httpdns) {
        // 初始化HTTPDNS
        // 设置AccoutID
        HttpDnsService *httpdns = [[HttpDnsService alloc] autoInit];
        // 为HTTPDNS服务设置降级机制
        [httpdns setDelegateForDegradationFilter:self];
        // 允许返回过期的IP
        //        [httpdns setExpiredIPEnabled:YES];
        //设置持久化缓存功能
        //        [httpdns setCachedIPEnabled:YES];
        //设置网络切换时是否自动刷新所有域名解析结果
        [httpdns setPreResolveAfterNetworkChanged:YES];

#ifdef DEBUG
#if EnableDebug
        // 打开HTTPDNS Log，线上建议关闭
        [httpdns setLogEnabled:YES];
#endif
#endif

        //        [httpdns setHTTPSRequestEnabled:YES];
        // edited
        NSArray *preResolveHosts = [self.targetHosts mutableCopy];
        [httpdns setPreResolveHosts:preResolveHosts];
        _httpdns = httpdns;
    }
    return _httpdns;
}

- (NSArray *)targetHosts {
    if (!_targetHosts) {
        NSArray *list = nil;
#ifdef DEBUG
        list = @[
            @"appgateway.lifekh.com",
            @"appgateway-uat.lifekh.com",
            @"appgateway-sit.lifekh.com",
        ];
#else
        list = @[@"appgateway.lifekh.com"];
#endif
        _targetHosts = list;
    }
    return _targetHosts;
}

- (NSMutableDictionary *)hostDic {
    if (!_hostDic) {
        _hostDic = NSMutableDictionary.new;
    }
    return _hostDic;
}

@end
