//
//  SAShareManager.m
//  ViPay
//
//  Created by seeu on 2019/5/24.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "SAShareManager.h"
#import "FBSDKShareManager.h"
#import "HDWebImageManager.h"
#import "SAInstagramShareManager.h"
#import "SALineShareManager.h"
#import "SAPayHelper.h"
#import "SATelegramShareManager.h"
#import "SATwitterShareManager.h"
#import "SAWindowManager.h"
#import "UIView+NAT.h"
#import "WXApiManager.h"
#import <HDKitCore/HDKitCore.h>
#import <HDUIKit/HDUIKit.h>

#define thumbImageSize CGSizeMake(100, 100)
#define thumbPlaceholderImage [UIImage imageNamed:@"wownow_share"]


@implementation SAShareManager

+ (void)shareObject:(SAShareObject *)shareObject inChannel:(SAShareChannel)channel completion:(void (^_Nullable)(BOOL, NSString *_Nullable))completion {
    if ([channel isEqualToString:SAShareChannelFacebook]) { // facebook
        if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]]) {
            [NAT showToastWithTitle:nil content:SALocalizedString(@"share_not_install_facebook", @"未安装Facebook") type:HDTopToastTypeInfo];
            !completion ?: completion(false, SAShareChannelFacebook);
            return;
        }
        [self setShareImageWithShareObject:shareObject completion:^{
            [FBSDKShareManager.sharedManager sendShareInFacebook:shareObject completion:^(BOOL success) {
                !completion ?: completion(success, SAShareChannelFacebook);
            }];
        }];
    } else if ([channel isEqualToString:SAShareChannelMessenger]) { // Messenger
        if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb-messenger://"]]) {
            [NAT showToastWithTitle:nil content:SALocalizedString(@"share_not_install_messenger", @"未安装Messenger") type:HDTopToastTypeInfo];
            !completion ?: completion(false, SAShareChannelMessenger);
            return;
        }
        [self setShareImageWithShareObject:shareObject completion:^{
            [FBSDKShareManager.sharedManager sendShareInMessenger:shareObject completion:^(BOOL success) {
                !completion ?: completion(success, SAShareChannelMessenger);
            }];
        }];
    } else if ([channel isEqualToString:SAShareChannelWechatSession]) { // 微信好友
        BOOL isSupported = [SAPayHelper isSupportWechatPayAppNotInstalledHandler:nil appNotSupportApiHandler:nil];
        if (!isSupported) {
            [NAT showToastWithTitle:nil content:SALocalizedString(@"share_not_install_wechat", @"未安装微信") type:HDTopToastTypeInfo];
            !completion ?: completion(false, SAShareChannelWechatSession);
            return;
        }
        [self setShareImageDataWithShareObject:shareObject completion:^{
            [WXApiManager.sharedManager sendShareReq:shareObject inScene:WXSceneSession completion:^(BOOL success) {
                !completion ?: completion(success, SAShareChannelWechatSession);
            }];
        }];
    } else if ([channel isEqualToString:SAShareChannelWechatTimeline]) { // 微信朋友圈
        BOOL isSupported = [SAPayHelper isSupportWechatPayAppNotInstalledHandler:nil appNotSupportApiHandler:nil];
        if (!isSupported) {
            [NAT showToastWithTitle:nil content:SALocalizedString(@"share_not_install_wechat", @"未安装微信") type:HDTopToastTypeInfo];
            !completion ?: completion(false, SAShareChannelWechatTimeline);
            return;
        }
        [self setShareImageDataWithShareObject:shareObject completion:^{
            [WXApiManager.sharedManager sendShareReq:shareObject inScene:WXSceneTimeline completion:^(BOOL success) {
                !completion ?: completion(success, SAShareChannelWechatTimeline);
            }];
        }];
    } else if ([channel isEqualToString:SAShareChannelLine]) { // Line
        if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"line://"]]) {
            [NAT showToastWithTitle:nil content:SALocalizedString(@"share_not_install_line", @"未安装Line") type:HDTopToastTypeInfo];
            !completion ?: completion(false, SAShareChannelLine);
            return;
        }
        [self setShareImageDataWithShareObject:shareObject completion:^{
            [SALineShareManager.sharedManager sendShare:shareObject completion:^(BOOL success) {
                !completion ?: completion(success, SAShareChannelLine);
            }];
        }];
    } else if ([channel isEqualToString:SAShareChannelTwitter]) { // Twitter
        if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://"]]) {
            [NAT showToastWithTitle:nil content:SALocalizedString(@"share_not_install_twitter", @"未安装Twitter") type:HDTopToastTypeInfo];
            !completion ?: completion(false, SAShareChannelTwitter);
            return;
        }
        [self setShareImageWithShareObject:shareObject completion:^{
            [SATwitterShareManager.sharedManager sendShare:shareObject completion:^(BOOL success) {
                !completion ?: completion(success, SAShareChannelTwitter);
            }];
        }];
    } else if ([channel isEqualToString:SAShareChannelInstagram]) { // Instagram
        if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"instagram://"]]) {
            [NAT showToastWithTitle:nil content:SALocalizedString(@"share_not_install_instagram", @"未安装Instagram") type:HDTopToastTypeInfo];
            !completion ?: completion(false, SAShareChannelInstagram);
            return;
        }
        [self setShareImageWithShareObject:shareObject completion:^{
            [SAInstagramShareManager.sharedManager sendShare:shareObject completion:^(BOOL success) {
                !completion ?: completion(success, SAShareChannelInstagram);
            }];
        }];
    } else if ([channel isEqualToString:SAShareChannelTelegram]) { // Telegram
        if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tg://"]]) {
            [NAT showToastWithTitle:nil content:SALocalizedString(@"share_not_install_telegram", @"未安装Telegram") type:HDTopToastTypeInfo];
            !completion ?: completion(false, SAShareChannelTelegram);
            return;
        }
        [SATelegramShareManager.sharedManager sendShare:shareObject completion:^(BOOL success) {
            !completion ?: completion(success, SAShareChannelTelegram);
        }];
    }
}

#pragma mark - 类型转换方法
// 分享渠道需要的是UIImage类型时，使用该方法转换
+ (void)setShareImageWithShareObject:(SAShareObject *)shareObject completion:(void (^)(void))completion {
    dispatch_group_t group = dispatch_group_create();

    if (!HDIsObjectNil(shareObject.thumbImage) && [shareObject.thumbImage isKindOfClass:NSString.class]) {
        dispatch_group_enter(group);
        [self getImageWithImageUrl:shareObject.thumbImage isThumbImage:true completion:^(UIImage *_Nullable image) {
            shareObject.thumbImage = image;
            dispatch_group_leave(group);
        }];
    }

    if ([shareObject isKindOfClass:SAShareImageObject.class]) {
        SAShareImageObject *trueShareObject = (SAShareImageObject *)shareObject;
        if (!HDIsObjectNil(trueShareObject.shareImage) && [trueShareObject.shareImage isKindOfClass:NSString.class]) {
            dispatch_group_enter(group);
            [self getImageWithImageUrl:trueShareObject.shareImage isThumbImage:false completion:^(UIImage *_Nullable image) {
                trueShareObject.shareImage = image;
                dispatch_group_leave(group);
            }];
        }
    }

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        !completion ?: completion();
    });
}

// 分享渠道需要的是NSData类型时，使用该方法转换
+ (void)setShareImageDataWithShareObject:(SAShareObject *)shareObject completion:(void (^)(void))completion {
    dispatch_group_t group = dispatch_group_create();

    if (HDIsObjectNil(shareObject.thumbData) && !HDIsObjectNil(shareObject.thumbImage)) {
        dispatch_group_enter(group);
        [self getImageDataWithImage:shareObject.thumbImage isThumbImage:true completion:^(NSData *imageData) {
            shareObject.thumbData = imageData;
            dispatch_group_leave(group);
        }];
    }

    if ([shareObject isKindOfClass:SAShareImageObject.class]) {
        SAShareImageObject *trueShareObject = (SAShareImageObject *)shareObject;
        if (HDIsObjectNil(trueShareObject.shareImageData) && !HDIsObjectNil(trueShareObject.shareImage)) {
            dispatch_group_enter(group);
            [self getImageDataWithImage:trueShareObject.shareImage isThumbImage:false completion:^(NSData *imageData) {
                trueShareObject.shareImageData = imageData;
                dispatch_group_leave(group);
            }];
        }
    }

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        !completion ?: completion();
    });
}

#pragma mark - 私有方法
// 转化id类型（UIImage类型或者NSString类型）的image为imageData
+ (void)getImageDataWithImage:(id)image isThumbImage:(BOOL)isThumbImage completion:(void (^)(NSData *imageData))completion {
    UIViewController *visibleViewController = [SAWindowManager visibleViewController];

    void (^imageToData)(UIImage *image) = ^(UIImage *image) {
        if (HDIsObjectNil(image)) {
            completion(thumbPlaceholderImage.hd_rawData);
            return;
        }
        [visibleViewController.view showloading];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *thumbData;
            // 缩略图最大不超过64KB
            if (isThumbImage) {
                thumbData = image.hd_rawData;
                if (thumbData.length > 64 * 1024) {
                    thumbData = thumbPlaceholderImage.hd_rawData;
                }
            } else {
                thumbData = [image hd_rawDataWithType:HDUIImageSourceTypePNG];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [visibleViewController.view dismissLoading];
                completion(thumbData);
            });
        });
    };

    if ([image isKindOfClass:NSString.class]) {
        [self getImageWithImageUrl:image isThumbImage:isThumbImage completion:^(UIImage *_Nullable image) {
            imageToData(image);
        }];
    } else if ([image isKindOfClass:UIImage.class]) {
        imageToData(image);
    } else {
        imageToData(thumbPlaceholderImage);
    }
}

+ (void)getImageWithImageUrl:(NSString *)imageUrl isThumbImage:(BOOL)isThumbImage completion:(void (^)(UIImage *_Nullable image))completion {
    if (HDIsStringEmpty(imageUrl)) {
        completion(thumbPlaceholderImage);
        return;
    }
    UIViewController *visibleViewController = [SAWindowManager visibleViewController];
    [visibleViewController.view showloading];
    [HDWebImageManager setImageWithURL:imageUrl placeholderImage:nil imageView:UIImageView.new
                             completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {
                                 if (!error) {
                                     [visibleViewController.view dismissLoading];
                                     completion([image hd_imageResizedWithScreenScaleInLimitedSize:thumbImageSize]);
                                 } else {
                                     [visibleViewController.view dismissLoading];
                                     completion(thumbPlaceholderImage);
                                 }
                             }];
}

@end
