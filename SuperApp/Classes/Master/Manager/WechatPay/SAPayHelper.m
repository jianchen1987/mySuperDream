//
//  SAPayHelper.m
//  SuperApp
//
//  Created by VanJay on 2020/6/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAPayHelper.h"
#import <WechatOpenSDK/WXApi.h>
#import <WechatOpenSDK/WXApiObject.h>


@implementation SAPayHelper
+ (BOOL)isSupportWechatPayAppNotInstalledHandler:(void (^_Nullable)(void))appNotInstalledHandler appNotSupportApiHandler:(void (^_Nullable)(void))appNotSupportApiHandler {
    // 1.判断是否安装微信
    if (![WXApi isWXAppInstalled]) {
        // 业务代码，提示微信未安装...
        !appNotInstalledHandler ?: appNotInstalledHandler();
        return NO;
    }
    // 2.判断微信的版本是否支持最新API
    if (![WXApi isWXAppSupportApi]) {
        // 业务代码，提示微信当前版本不支持此功能...
        !appNotSupportApiHandler ?: appNotSupportApiHandler();
        return NO;
    }
    return YES;
}
@end
