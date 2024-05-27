//
//  SAAppDelegate+AppService.m
//  SuperApp
//
//  Created by VanJay on 2020/3/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAAppDelegate+AppService.h"
#import "SAAppEnvManager.h"
#import "SAAppLaunchToDoService.h"
#import "SACacheManager.h"
#import "SACommonConst.h"
#import "SAMultiLanguageManager.h"
#import "SATalkingData.h"
#import "SAUser.h"
#import "SAWindowManager.h"
#import "WXApiManager.h"
#import <Bugly/Bugly.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FIRApp.h>
#import <HDKitCore/HDKitCore.h>
#import <HDUIKit/HDKeyboardManager.h>

#ifdef DEBUG
#import "HDAuxiliaryToolManager.h"
#import <Bagel/Bagel.h>
#import <DoraemonKit/DoraemonManager.h>
#endif
#import "LKDataRecord.h"
#import "SAAppDelegate+PushService.h"
#import "SAAppSwitchManager.h"
#import "SANotificationConst.h"
#import "SAOpenCapabilityAppPayPresenter.h"
#import "SARemoteNotificationModel.h"
#import "SAStartupAdController.h"
#import "SATabBarController.h"
#import "SAGuardian.h"
#import <HDServiceKit/WNHelloWebSocketClient.h>
#import <KSInstantMessagingKit/KSCallKitCenter.h>
#import <KSInstantMessagingKit/KSInstMsgConfig.h>
#import <KSInstantMessagingKit/KSInstMsgManager.h>

#import <UserNotifications/UserNotifications.h>
#import "SAUrlBizMappingModel.h"
#import "TNEventTracking.h"

#if !TARGET_IPHONE_SIMULATOR
#import <HuionePaySDK_iOS/HuionePaySDK_iOS.h>
#import "RRMerchantManager.h"
#endif

@interface SAAppDelegate () <WNHelloClientDelegate, WMHelloClientListenerDelegate>

@end

@implementation SAAppDelegate (AppService)

- (void)initThirdPartyServiceWithApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    HDLog(@"准备初始化三方服务了:%@", [NSThread currentThread]);
    // 开启firebase 服务， ⚠️这个必须在最前面，不然拿不到开关
    [FIRApp configure];

    [SAGuardian initNTERisk];
#ifndef DEBUG
    [self initTalkingData];
    [self initBugly];
#endif
    [self initTinhnowEventTracking]; //初始化电商埋点
    [self configWXRegistion];
    [self initLKData];
    [self initHDMediator];
    [self initHuioneV2];
    [self initPrinceSdk];
    [self initIm];
//    [self registerHelloPlatform];

    // for facebook login
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];

    if (@available(iOS 14.5, *)) {
        [FBSDKSettings.sharedSettings setAdvertiserTrackingEnabled:YES];
    }

    if (launchOptions[UIApplicationLaunchOptionsURLKey] == nil) {
        [FBSDKAppLinkUtility fetchDeferredAppLink:^(NSURL *_Nullable url, NSError *_Nullable error) {
            if (!error) {
                [SAWindowManager openUrl:url.absoluteString withParameters:nil];
            }
        }];
    }

    HDKeyboardManager.sharedInstance.shouldResignOnTouchOutside = true;
    //忽略im对话框的控制
    [HDKeyboardManager.sharedInstance.touchResignedGestureIgnoreClasses addObject:NSClassFromString(@"LHChatBarView")];
#ifdef DEBUG
#if EnableDebug
    //    // 确保生产包不启用
//        [[DoraemonManager shareInstance] install];
    //    //
    //    //    // 辅助工具启用
//        [[HDAuxiliaryToolManager shared] setup];

    if (@available(iOS 14, *)) {
        // 抓包工具, 低版本测试手机总是崩溃就不加了
        [Bagel start];
    }
#endif
#endif

    // 启动后事件 todo list 执行
    [[SAAppLaunchToDoService sharedInstance] performAll];

    // 子线程开启，防止阻塞主线程
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [LKDataRecord.shared sessionStart];
    });
}

#pragma mark - 微信支付
- (void)configWXRegistion {
#ifdef DEBUG
    // 在register之前打开log, 后续可以根据log排查问题
    [WXApi startLogByLevel:WXLogLevelNormal logBlock:^(NSString *log) {
        HDLog(@"微信SDK log: %@", log);
    }];
#endif
    NSString *universalLink = @"https://h5.lifekh.com/app-wownow-links/";

    // 务必在调用自检函数前注册
    [WXApi registerApp:@"wxcb2d7694e0cade99" universalLink:universalLink];

    [WXApiManager sharedManager].delegate = (id)self;
}

- (void)initTalkingData {
#ifdef DEBUG
    [TalkingData sessionStarted:@"A8ACC56156264280AEDD5D90A3643BFE" withChannelId:@"test"];
#else
    [TalkingData sessionStarted:@"A8ACC56156264280AEDD5D90A3643BFE" withChannelId:@"App Store"];
#endif
    [TalkingData setExceptionReportEnabled:NO];
    [TalkingData setSignalReportEnabled:NO];
    [TalkingData setLogEnabled:NO];
    [TalkingData setGlobalKV:@"设备型号" value:[UIDevice currentDevice].model];
    [TalkingData setGlobalKV:@"系统版本" value:[UIDevice currentDevice].systemVersion];
}

- (void)initTinhnowEventTracking {
    [TNEventTracking instance];
}

- (void)initBugly {
    BuglyConfig *config = [[BuglyConfig alloc] init];
    config.consolelogEnable = NO;
#ifdef DEBUG
    config.channel = @"test";
    config.blockMonitorEnable = YES;
#else
    config.channel = @"App Store";
#endif
    [Bugly startWithAppId:@"3fe1cb2da1" config:config];
    if ([SAUser hasSignedIn]) {
        [Bugly setUserIdentifier:SAUser.shared.loginName];
    }
}


- (void)initIm {
    KSInstMsgConfig *config = KSInstMsgConfig.new;
    config.appId = @"321";
    config.appSecret
        = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBALz8qZE7dSRqkcBZd1NbqK0+EOJuVoDBzvDBwIjDyOoP7C+Yoxn3C9Uao4y39IhrCHQK/NP552qpeD/jHR6PQ/R3np6B+O96xsoBDBlTpD3+fTuDwxmcaMk4qakKyho/"
          @"R0grY0mw0m+omEaJfYMfu4rkK5d9cEFyHHuLNugq3g3jAgMBAAECgYEAuP73mjRCulAbttedKBssZdHAw3ZQ9R9CzIhNSVOl5AGMKRdYaX1cttGp0YDtPXDQyI9M6M/TiaS1Eozmn1iMohvnRc+fcvP9XoGz7Xr/"
          @"HcVCqQBjIPKK7NJC+LDzdcylLaSpLopxi6GOAcCbtlDSa8V6+eDVLHQ37IR9oEYKOukCQQD2TJb7HR0oWcpfT+dOlbDNp++HWR8TWqkBnEbou/ZjVG6+OCpvpQ35n27dHLuz51tXJutd+2i2Fa12Vx3us2UvAkEAxG4y/st/"
          @"j+O5iPoBw29x3+KOWupg3C1OS8+9J95lLLMd1OCRSJNDAByMQlmDPfewxC7yI+fUoXbuFVgv5bcdjQJBALa8vIgzYZ6+f9eXgRZdGYB8SMsy5EuHyDzZpgKm8ndf/"
          @"YpEQbfzzhqWn7qNxvYDgVF4Hsjr7xSpoLlciWjA0SECQHnv2rI2y1IcUHGKmQukI/GSZ0Ji2ovzh/"
          @"Yh2E9mjDHqYutiGG4QFHh+QEdz37fZCZ9PcTr+0A0HkhYn71vPh4UCQDlKvTjMx9iAZOKcwsadVVjbsn5yQ4tulgUjujnlI08upfG8QbmsXceeUQRTh3tWmWVHBhMwgGmTleTCozQ4Mwc=";
#ifdef DEBUG
    config.APNsCertName = @"WOWNOW_push_test";
#else
    config.APNsCertName = @"WOWNOW_push";
#endif
    SAAppEnvConfig *envConfig = [SAAppEnvManager.sharedInstance appEnvConfig];
    if ([envConfig.type isEqualToString:SAAppEnvTypeSIT]) {
        config.env = KSEnvConfigSIT;
    } else if ([envConfig.type isEqualToString:SAAppEnvTypeUAT]) {
        config.env = KSEnvConfigUAT;
    } else {
        config.env = KSEnvConfigProd;
    }

    NSString *providerSwitch = [SAAppSwitchManager.shared switchForKey:SAAppSwitchIMProvider];
    if (HDIsStringNotEmpty(providerSwitch) && [providerSwitch isEqualToString:@"off"]) {
        config.imProvider = @"FlooIM";
    } else {
        config.imProvider = @"OpenIM";
    }
    config.appName = @"SuperApp";
    [KSInstMsgManager.share registerWithConfig:config];
    [KSInstMsgManager.share setCurrentLanguage:[SAMultiLanguageManager currentLanguage]];
}

- (void)initLKData {
    [LKDataRecord initWithAppId:@"123" secretKey:@"123"];
}

- (void)initHDMediator {
    // 加入路由拦截钩子
    // host and path
    HDMediator.sharedInstance.willPerformHandler = ^(NSString *_Nullable urlStr, NSString *_Nullable target, NSString *_Nullable action, NSDictionary *_Nullable params) {
        //        HDLog(@"即将跳转路由:%@  %@", target, action);

        NSString *bizLine = @"";

        if ([target.lowercaseString isEqualToString:@"tinhnow"] || ([target.lowercaseString isEqualToString:@"superapp"] && [action.lowercaseString isEqualToString:@"tinhnow"])) {
            // 电商业务线
            bizLine = SAClientTypeTinhNow;

        } else if ([target.lowercaseString isEqualToString:@"yumnow"] || ([target.lowercaseString isEqualToString:@"superapp"] && [action.lowercaseString isEqualToString:@"yumnow"])) {
            // 外卖业务线
            bizLine = SAClientTypeYumNow;

        } else if ([target.lowercaseString isEqualToString:@"groupon"] || ([target.lowercaseString isEqualToString:@"superapp"] && [action.lowercaseString isEqualToString:@"groupon"])) {
            // 团购业务线
            bizLine = SAClientTypeGroupBuy;

        } else if ([target.lowercaseString isEqualToString:@"paynow"] || ([target.lowercaseString isEqualToString:@"superapp"] && [action.lowercaseString isEqualToString:@"wallet"])) {
            // 支付业务线
            bizLine = SAClientTypeBillPayment;

        } else if ([target.lowercaseString isEqualToString:@"http"]) {
            // 网页
            NSString *mappingStr = [SAAppSwitchManager.shared switchForKey:SAAppSwitchBizUrlMapping];
            NSArray<SAUrlBizMappingModel *> *mapping = [NSArray yy_modelArrayWithClass:SAUrlBizMappingModel.class json:mappingStr];
            NSURL *url = [NSURL URLWithString:urlStr];

            NSArray<SAUrlBizMappingModel *> *bingo = [mapping hd_filterWithBlock:^BOOL(SAUrlBizMappingModel *_Nonnull item) {
                return [url.host containsString:item.hostName] && [url.path containsString:item.regx];
            }];
            if (bingo.count) {
                bizLine = bingo.firstObject.bizName;
            } else {
                bizLine = @"";
            }

        } else if ([target.lowercaseString isEqualToString:@"superapp"]) {
            // 中台负责，无法拆分
            bizLine = SAClientTypeMaster;

        } else {
            // 其他未知
            bizLine = @"";
        }

        [LKDataRecord.shared traceBizActiveDaily:bizLine routhPath:urlStr ext:params];
    };
}

- (void)initPrinceSdk {
#if !TARGET_IPHONE_SIMULATOR
    [[RRMerchantManager shared] setAppID:@"WOWNOW"];
#endif
}

- (void)initHuioneV2 {
#if !TARGET_IPHONE_SIMULATOR
#ifdef DEBUG
    // 测试环境
    [HuionePaySDK initAppID:@"1391701045247963471873"];
#else
    // 生产环境
    [HuionePaySDK initAppID:@"6f01703716728682704898"];
#endif
#endif
}

- (void)registerHelloPlatform {
    WNApp *app = nil;
    if ([[SAAppEnvManager.sharedInstance appEnvConfig].type isEqualToString:SAAppEnvTypeSIT]) {
        app = [WNApp appWithAppId:@"16EuLXnkwc2J8" secrectKey:@"" privateKey:@""];
        [[WNHelloClient sharedClient] initWithApp:app host:@"wss://hello-sit.lifekh.com/hello-worker"];
    } else if ([[SAAppEnvManager.sharedInstance appEnvConfig].type isEqualToString:SAAppEnvTypeUAT]) {
        app = [WNApp appWithAppId:@"16EuLXnkwc2J8" secrectKey:@"" privateKey:@""];
        [[WNHelloClient sharedClient] initWithApp:app host:@"wss://hello-uat.lifekh.com/hello-worker"];
    } else {
        app = [WNApp appWithAppId:@"tq103w" secrectKey:@"" privateKey:@""];
        [[WNHelloClient sharedClient] initWithApp:app host:@"wss://hello.lifekh.com/hello-worker"];
    }

    [WNHelloClient sharedClient].delegate = self;
    [[WNHelloClient sharedClient] addListener:self forEvent:WNHelloEventDataMessage];

    NSString *helloSwitch = [SAAppSwitchManager.shared switchForKey:SAAppSwitchHelloPlatform];
#ifndef DEBUG
    if (HDIsStringEmpty(helloSwitch) || [[helloSwitch lowercaseString] isEqualToString:@"off"]) {
        return;
    }
#endif

    if ([SAUser hasSignedIn]) {
        [self loginHello];
    }
}

#pragma mark - override system methods
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    if (@available(iOS 9.0, *)) {
        NSString *sourceApplication = [options valueForKey:UIApplicationOpenURLOptionsSourceApplicationKey];
        // com.apple.springboard 系统调用
        HDLog(@"sourceApplication:%@", sourceApplication);
    } else {
        // Fallback on earlier versions
    }
    HDLog(@"收到外部唤起:%@", url.absoluteString);
    // 其他如支付等SDK的回调
    [self configWXRegistion];
    if ([WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]]) {
        return YES;
    }
    // FB 授权登录
    if ([[FBSDKApplicationDelegate sharedInstance] application:app openURL:url options:options]) {
        return YES;
    }

    // TalkingData
    if ([SATalkingData handleUrl:url]) {
        return YES;
    }

    // 开放能力
    if ([SAOpenCapabilityAppPayPresenter application:app openURL:url options:options]) {
        return YES;
    }

    if ([url.absoluteString hasPrefix:@"superapp://h5.lifekh.com/wakeup"] || [url.absoluteString containsString:@".lifekh.com"] || [url.absoluteString containsString:@".ozos.xyz"]) {
        return [self openRoutePathWithURL:url];
    }

    if ([SAWindowManager canOpenURL:url.absoluteString]) {
        return [SAWindowManager openUrl:url.absoluteString withParameters:nil];
    }

#if !TARGET_IPHONE_SIMULATOR
    if([url.scheme isEqualToString:@"huione2"] || [url.absoluteString hasPrefix:@"huione2"]) {
        // 汇旺最终还没确定，直接返回结果未知，靠后端查询
        HDLog(@"汇旺支付回调:%@", url.absoluteString);
        [NSNotificationCenter.defaultCenter postNotificationName:kNotificationNameHuiOneResp object:@(5000)];
        
        [LKDataRecord.shared traceEvent:@"@DEBUG"
                                   name:@"汇旺V2回调"
                             parameters:@{@"url": url.absoluteString, @"carriers": [HDDeviceInfo getCarrierName], @"network": [HDDeviceInfo getNetworkType]}
                                    SPM:nil];
        
        return YES;
    }
#endif
    
    
#if !TARGET_IPHONE_SIMULATOR
    // 太子银行回调
    [[RRMerchantManager shared] handlePayWithURL:url complete:^(NSString *status) {
        if ([status isEqualToString:@"1"]) {
            // payment completed
            HDLog(@"prince callback user complete");
        } else {
            // user cancel
            HDLog(@"prince callback user cancel");
        }
        [NSNotificationCenter.defaultCenter postNotificationName:kNotificationNamePrinceBankResp object:status];
    }];
#endif


    return NO;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *_Nullable))restorationHandler {
    HDLog(@"收到 applinks 唤醒 : %@", userActivity.webpageURL.absoluteString);

    if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        NSURL *webpageURL = userActivity.webpageURL;
        NSString *urlStr = webpageURL.absoluteString;

        [self configWXRegistion];
        if ([WXApi handleOpenUniversalLink:userActivity delegate:[WXApiManager sharedManager]]) {
            return YES;
        }

        if ([[FBSDKApplicationDelegate sharedInstance] application:application openURL:webpageURL options:@{}]) {
            return YES;
        }

        if ([SATalkingData handleUrl:webpageURL]) {
            return YES;
        }

        if ([SAOpenCapabilityAppPayPresenter application:application continueUserActivity:userActivity restorationHandler:restorationHandler]) {
            return YES;
        }

        if ([urlStr containsString:SAAppEnvManager.sharedInstance.appEnvConfig.h5URL] || [urlStr containsString:@".lifekh.com"] || [urlStr containsString:@".ozos.xyz"]) {
            return [self openRoutePathWithURL:webpageURL];
        }

        if ([SAWindowManager canOpenURL:urlStr]) {
            return [SAWindowManager openUrl:urlStr withParameters:nil];
        }
#if !TARGET_IPHONE_SIMULATOR
        if([webpageURL.scheme isEqualToString:@"huione2"] || [webpageURL.absoluteString hasPrefix:@"huione2"]) {
            // 汇旺最终还没确定，直接返回结果未知，靠后端查询
            [NSNotificationCenter.defaultCenter postNotificationName:kNotificationNameHuiOneResp object:@(5000)];
            
            [LKDataRecord.shared traceEvent:@"@DEBUG"
                                       name:@"汇旺V2回调"
                                 parameters:@{@"url": webpageURL.absoluteString, @"carriers": [HDDeviceInfo getCarrierName], @"network": [HDDeviceInfo getNetworkType]}
                                        SPM:nil];
            
            return YES;
        }
#endif

#if !TARGET_IPHONE_SIMULATOR
        // 太子银行回调
        [[RRMerchantManager shared] handlePayWithURL:webpageURL complete:^(NSString *_Nonnull status) {
            if ([status isEqualToString:@"1"]) {
                // payment completed
                HDLog(@"prince callback user complete");
            } else {
                // user cancel
                HDLog(@"prince callback user cancel");
            }
            [NSNotificationCenter.defaultCenter postNotificationName:kNotificationNamePrinceBankResp object:status];
        }];
#endif

    }

    if ([SAUser hasSignedIn] && [KSCallKitCenter handleOpenUniversalLink:userActivity phone:[SAUser.shared loginName] operatorNo:[SAUser.shared operatorNo]]) {
        return YES;
    }

    return NO;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    HDLog(@"应用进入前台:%@", [NSThread currentThread]);
    [WNHelloClient.sharedClient reconnect];
    [KSInstMsgManager.share reConnect];

    // 子线程执行,防止卡住主线程
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [[SAAppLaunchToDoService sharedInstance] enterForeground];
        [LKDataRecord.shared sessionStart];
    });
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    HDLog(@"应用开始进入活跃状态");
    [FBSDKAppEvents.shared activateApp];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    HDLog(@"应用进入后台:%@", [NSThread currentThread]);

    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        [KSInstMsgManager.share disConnect];
        [WNHelloClient.sharedClient disConnect];
        // 保存内存中的埋点数据
        [SATalkingData save];
        [LKDataRecord.shared sessionEnd];
    });

    // 向操作系统申请后台运行的资格，能维持多久，不确定
    __block UIBackgroundTaskIdentifier task = [application beginBackgroundTaskWithExpirationHandler:^{
        // 当申请的后台运行时间已经结束（过期），就会调用这个block
        HDLog(@"application death");
        // 赶紧结束任务
        [application endBackgroundTask:task];
    }];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    HDLog(@"应用要被干掉了...");
}

#pragma mark - private methods
- (BOOL)openRoutePathWithURL:(NSURL *)url {
    NSDictionary *parameters = url.query.hd_parameters;

    NSMutableDictionary *newParameters = [NSMutableDictionary dictionaryWithCapacity:parameters.count];
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, id _Nonnull obj, BOOL *_Nonnull stop) {
        newParameters[key.lowercaseString] = obj;
    }];

    if ([newParameters.allKeys containsObject:@"shortid"]) {
        NSString *shortID = [newParameters objectForKey:@"shortid"];
        [SACacheManager.shared setObject:shortID forKey:kCacheKeyShortIDTrace duration:60 * 60 * 24 type:SACacheTypeDocumentPublic];
    }

    if ([newParameters.allKeys containsObject:@"routepath"]) {
        NSString *routerName = [[newParameters objectForKey:@"routepath"] hd_URLDecodedString];

        //转换只会decode 一次的url 的方法
        routerName = [[newParameters objectForKey:@"routepath"] stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];

        NSDictionary *paramsDict = [NSDictionary dictionary];
        if ([newParameters.allKeys containsObject:@"params"]) {
            NSString *params = [[newParameters objectForKey:@"params"] hd_URLDecodedString];
            NSData *data = [params dataUsingEncoding:NSUTF8StringEncoding];
            paramsDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        }

        //电商埋点解析来源字段
        [TNEventTrackingInstance parseOpenRouter:routerName];

        NSURL *routeURL = [NSURL URLWithString:routerName];
        UIWindow *keyWindow = UIApplication.sharedApplication.keyWindow;
        if ([keyWindow.rootViewController isKindOfClass:SATabBarController.class]) {
            return [SAWindowManager openUrl:routeURL.absoluteString withParameters:paramsDict];
        } else if ([keyWindow.rootViewController isKindOfClass:SAStartupAdController.class]) {
            HDLog(@"要打开的路由:%@", routerName);
            SAStartupAdController *vc = (SAStartupAdController *)keyWindow.rootViewController;
            vc.routeForClose = routerName;
            return false;
        }
    }

    return false;
}

- (void)loginHello {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[WNHelloClient sharedClient] signInWithUserId:[SAUser.shared operatorNo]];
    });
}

#pragma mark - WXApiManager delegate
/// 微信唤醒APP
- (void)managerDidRecvLaunchFromWXReq:(LaunchFromWXReq *)request {
    NSString *webpageURL = request.message.messageExt;

    HDLog(@"!!url: %@", webpageURL);
    if ([webpageURL hasPrefix:@"superapp://h5.lifekh.com/wakeup"]) {
        [self openRoutePathWithURL:[NSURL URLWithString:webpageURL]];
        return;
    }

    if ([SAWindowManager canOpenURL:webpageURL]) {
        [SAWindowManager openUrl:webpageURL withParameters:nil];
    }
}

#pragma mark - WNHelloClientDelegate
- (void)loginSuccess:(NSString *)deviceToken {
    HDLog(@"Hello登陆成功:%@", deviceToken);
    // 存本地公共区域
    [SACacheManager.shared setObject:deviceToken forKey:kCacheKeyHelloPlatformDeviceToken type:SACacheTypeCachePublic];

    //取消重登
    [HDFunctionThrottle throttleCancelWithKey:@"Hello_retry_login"];

    [NSNotificationCenter.defaultCenter postNotificationName:kNotificationNameDidReceiveHelloPlatformDeviceToken object:nil userInfo:@{@"deviceToken": deviceToken}];
}

- (void)helloClientError:(NSError *)error {
    HDLog(@"传声筒异常:%@", error);
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateBackground) {
        // 应用还在运行，尝试重连
        [HDFunctionThrottle throttleWithInterval:5 key:@"Hello_retry_login" handler:^{
            [self loginHello];
        }];
    } else {
        HDLog(@"应用退到后台，正常关闭，不再尝试重登");
        [HDFunctionThrottle throttleCancelWithKey:@"Hello_retry_login"];
    }
}

- (void)helloClientClosedWithReason:(NSString *_Nullable)reason {
    HDLog(@"传声筒关闭了!%@", reason);
    if (HDIsStringEmpty(reason)) {
        HDLog(@"正常退出，不需要重连:%@", reason);
        return;
    }

    if ([UIApplication sharedApplication].applicationState != UIApplicationStateBackground) {
        // 应用还在运行，尝试重连
        [HDFunctionThrottle throttleWithInterval:5 key:@"Hello_retry_login" handler:^{
            [self loginHello];
        }];
    } else {
        HDLog(@"应用退到后台，正常关闭，不再尝试重登");
        [HDFunctionThrottle throttleCancelWithKey:@"Hello_retry_login"];
    }
}

- (void)didReciveMessage:(id)message forEvent:(WNHelloEvent)type {
    HDLog(@"收到消息:%@", message);
    if ([type isEqualToString:WNHelloEventDataMessage]) {
        WNHelloDownloadMsg *trueMsg = (WNHelloDownloadMsg *)message;
        HDLog(@"消息内容:%@", trueMsg.data);
        [self showPushOnNotificationCenterWithModel:trueMsg];
    }
}

- (void)showPushOnNotificationCenterWithModel:(WNHelloDownloadMsg *)message {
    NSDictionary *properties = [message.messageContent objectForKey:@"customProperty"];
    SARemoteNotificationModel *model = [SARemoteNotificationModel yy_modelWithDictionary:properties];

    //针对voip挂断，单独处理，无需再生成本地推送
    if ([model.voipType isEqualToString:@"voice"] && [model.templateNo isEqualToString:@"VOIP01"]) {
        [self proccessNotification:properties];
        return;
    }

    NSMutableDictionary *userinfo = [[NSMutableDictionary alloc] initWithDictionary:properties];
    [userinfo setObject:@"hello" forKey:@"pushChannel"];

    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = model.msgTitle;
#ifdef DEBUG
    content.subtitle = @"传声筒[正式环境没有这行]";
#endif
    content.body = model.msgBody;
    content.userInfo = [userinfo copy];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:model.bizId content:content trigger:nil];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError *_Nullable error) {
        if (error) {
            HDLog(@"添加了本地推送失败:%@", error.localizedDescription);
        }
    }];
}

@end
