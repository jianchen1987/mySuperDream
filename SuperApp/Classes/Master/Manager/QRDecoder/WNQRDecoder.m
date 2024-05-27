//
//  WNQRDecoder.m
//  SuperApp
//
//  Created by seeu on 2022/5/9.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WNQRDecoder.h"
#import "SAMultiLanguageManager.h"
#import "SAWindowManager.h"
#import <HDKitCore/HDKitCore.h>
#import <HDServiceKit/HDWebViewHost.h>
#import <HDUIKit/NAT.h>


@implementation WNQRDecoder

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static WNQRDecoder *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

- (BOOL)canDecodeQRCode:(NSString *)code {
    if ([code.lowercaseString hasPrefix:@"superapp"]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)decodeQRCode:(NSString *)code {
    if ([code.lowercaseString hasPrefix:@"superapp"]) {
        [SAWindowManager openUrl:code withParameters:nil];
        return YES;
    } else if ([code.lowercaseString hasPrefix:@"http"]) {
        // decode 一下，防止有特殊字符导致无法转换
        NSString *decodeStr = [code hd_URLDecodedString];
        NSURL *url = [NSURL URLWithString:decodeStr];
        // 非URL 返回
        if (!url) {
            return NO;
        }

        // 可识别的url，用H5容器打开
        HDWebViewHostViewController *webVC = [[HDWebViewHostViewController alloc] init];
        webVC.url = decodeStr;
        [SAWindowManager navigateToViewController:webVC];
        return YES;
    } else {
        // 其他schema,暂时不支持，后续做了白名单可适当开放一些app的跳转
        [NAT showToastWithTitle:nil content:SALocalizedString(@"unknow_qr_code", @"无法识别该二维码") type:HDTopToastTypeError];
        return NO;
    }

    return NO;
}

@end
