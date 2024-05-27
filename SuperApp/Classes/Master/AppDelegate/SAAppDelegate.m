//
//  SAAppDelegate.m
//  SuperApp
//
//  Created by VanJay on 2020/3/22.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAAppDelegate.h"
#import "LKDataRecord.h"
#import "SAAddressCacheAdaptor.h"
#import "SAAppDelegate+AppService.h"
#import "SAAppDelegate+PushService.h"
#import "SAAppDelegate+URLProtocol.h"
#import "SAAppDelegate+WebViewHost.h"
#import "SAChooseLanguageManager.h"
#import "SALaboratoryViewController.h"
#import "SAStartupAdManager.h"
#import "SAWindowManager.h"
#import <HDUIKit/HDAppTheme.h>
#import <HDVendorKit/HDWebImageManager.h>
#import <KSInstantMessagingKit/KSCore.h>
#import <KSInstantMessagingKit/KSCall.h>

@interface SAAppDelegate ()

@end


@implementation SAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //
    //        SALaboratoryViewController *testVc = [SALaboratoryViewController new];
    //        UINavigationController *navc = [UINavigationController rootVC:testVc];
    //        self.window.rootViewController = navc;
    //        [self.window makeKeyAndVisible];
    //
    //        //方便调试用
    //        [self initThirdPartyServiceWithApplication:application didFinishLaunchingWithOptions:launchOptions];
    //        return YES;
    //先移除手切位置缓存数据
    [SAAddressCacheAdaptor removeYumAddress];
     
    [HDLocationManager.shared start];
    //注入自定义网络协议
    [self initCustomURLProtocol:application didFinishLaunchingWithOptions:launchOptions];

    [self initThirdPartyServiceWithApplication:application didFinishLaunchingWithOptions:launchOptions];
    // 初始化自定义H5指令
    [self initWebViewHost:application didFinishLaunchingWithOptions:launchOptions];
    // 初始化推送服务
    [self initRemotePush:application didFinishLaunchingWithOptions:launchOptions];
    // 清空外卖首页通过tipView手动选择的地址（目前没想到别的方式）
    //    [SAAddressCacheAdaptor removeWMOnceTimeAddress];

    // im自动登录
    if ([SAUser hasSignedIn]) {
        [KSInstMsgManager.share fastSigninWithOpeartorNo:SAUser.shared.operatorNo storeNo:nil role:KSInstMsgRoleUser completion:^(NSError *_Nonnull error) {
            if (!error) {
                [NSNotificationCenter.defaultCenter postNotificationName:kNotificationNameIMLoginSuccess object:nil];
            } else {
                HDLog(@"IM登陆失败:%@", error.localizedDescription);
            }
        }];
    }

    [self.window makeKeyAndVisible];
    self.window.backgroundColor = HDAppTheme.color.G5;
    [SAChooseLanguageManager adjustShouldShowChooseLanguageWindow];
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL needShowVoipCall = [KSAudioCallManager isAudioCalling];

        if (needShowVoipCall)
            return; //处理有voip缓存时，不展示广告

        [SAStartupAdManager adjustShouldShowStartupAdWindow];
    });

    return YES;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    HDLog(@"⚠️⚠️⚠️：收到系统内存警告，将清除图片缓存以及存储工具类内存缓存");
    [LKDataRecord.shared saveAll];
    // 清除内存缓存
    [HDWebImageManager clearWebImageCache];

}

#pragma mark - private methods

#pragma mark - getter
- (UIWindow *)window {
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        _window.rootViewController = SAWindowManager.rootViewController;
    }
    return _window;
}

@end
