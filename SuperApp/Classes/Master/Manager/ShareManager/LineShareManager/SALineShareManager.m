//
//  SALineShareManager.m
//  SuperApp
//
//  Created by Chaos on 2021/3/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SALineShareManager.h"
#import "SAShareWebpageObject.h"
#import "SAShareImageObject.h"


@implementation SALineShareManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static SALineShareManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self sharedManager];
}

#pragma mark - public methods
- (void)sendShare:(SAShareObject *)shareObject completion:(void (^)(BOOL))completion {
    if ([shareObject isKindOfClass:SAShareWebpageObject.class]) {
        SAShareWebpageObject *tureShareObject = (SAShareWebpageObject *)shareObject;
        NSString *webpage = HDIsStringNotEmpty(tureShareObject.facebookWebpageUrl) ? tureShareObject.facebookWebpageUrl : tureShareObject.webpageUrl;
        NSURL *lineOpenUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://line.me/R/msg/text/%@", webpage].hd_URLEncodedString];
        if (![UIApplication.sharedApplication canOpenURL:lineOpenUrl]) {
            HDLog(@"未安装Line");
            !completion ?: completion(false);
            return;
        }
        [UIApplication.sharedApplication openURL:lineOpenUrl options:@{} completionHandler:^(BOOL success) {
            !completion ?: completion(success);
        }];
    } else if ([shareObject isKindOfClass:SAShareImageObject.class]) {
        SAShareImageObject *tureShareObject = (SAShareImageObject *)shareObject;
        // 将图片data添加到剪贴板
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setData:tureShareObject.shareImageData forPasteboardType:@"public.jpeg"];
        NSURL *lineOpenUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://line.me/R/msg/image/%@", pasteboard.name.hd_URLEncodedString]];
        if (![UIApplication.sharedApplication canOpenURL:lineOpenUrl]) {
            HDLog(@"未安装Line");
            !completion ?: completion(false);
            return;
        }
        [UIApplication.sharedApplication openURL:lineOpenUrl options:@{} completionHandler:^(BOOL success) {
            !completion ?: completion(success);
        }];
    }
}

@end
