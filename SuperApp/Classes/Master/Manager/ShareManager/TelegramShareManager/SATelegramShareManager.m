//
//  SATelegramShareManager.m
//  SuperApp
//
//  Created by Chaos on 2021/3/19.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SATelegramShareManager.h"
#import "SAShareWebpageObject.h"
#import "SAShareImageObject.h"


@implementation SATelegramShareManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static SATelegramShareManager *instance = nil;
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
        NSURL *tgOpenUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://telegram.me/share/url?url=%@&text=%@", webpage, tureShareObject.title].hd_URLEncodedString];
        if (![UIApplication.sharedApplication canOpenURL:tgOpenUrl]) {
            HDLog(@"未安装Telegram");
            !completion ?: completion(false);
            return;
        }
        [UIApplication.sharedApplication openURL:tgOpenUrl options:@{} completionHandler:^(BOOL success) {
            !completion ?: completion(success);
        }];
    } else if ([shareObject isKindOfClass:SAShareImageObject.class]) {
        HDLog(@"Telegram不支持分享图片");
        !completion ?: completion(false);
    }
}

@end
