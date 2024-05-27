//
//  SAInstagramShareManager.m
//  SuperApp
//
//  Created by Chaos on 2021/3/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAInstagramShareManager.h"
#import "SAShareWebpageObject.h"
#import "SAShareImageObject.h"
#import "SAWindowManager.h"
#import "UIView+NAT.h"
#import <HDUIKit/HDUIKit.h>
#import <HXPhotoPicker/HXPhotoPicker.h>


@interface SAInstagramShareManager () <UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) UIDocumentInteractionController *document;

@end


@implementation SAInstagramShareManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static SAInstagramShareManager *instance = nil;
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
        HDLog(@"Instagram不支持分享链接");
        !completion ?: completion(false);
    } else if ([shareObject isKindOfClass:SAShareImageObject.class]) {
        SAShareImageObject *tureShareObject = (SAShareImageObject *)shareObject;
        UIViewController *visibleViewController = [SAWindowManager visibleViewController];
        // 保存图片到相册
        [visibleViewController.view showloading];
        [HXPhotoTools savePhotoToCustomAlbumWithName:nil photo:tureShareObject.shareImage location:nil complete:^(HXPhotoModel *_Nullable model, BOOL success) {
            if (!success) { // 保存图片失败
                [visibleViewController.view dismissLoading];
                HDLog(@"保存图片失败");
                !completion ?: completion(false);
                return;
            }
            // 获取图片在相册中的路径
            [model.asset requestContentEditingInputWithOptions:PHContentEditingInputRequestOptions.new
                                             completionHandler:^(PHContentEditingInput *_Nullable contentEditingInput, NSDictionary *_Nonnull info) {
                                                 [visibleViewController.view dismissLoading];
                                                 NSString *assetPath = contentEditingInput.fullSizeImageURL.absoluteString;
                                                 if (HDIsStringEmpty(assetPath)) {
                                                     HDLog(@"获取图片路径失败");
                                                     !completion ?: completion(false);
                                                 } else {
                                                     [self shareImageWithAssetPath:assetPath completion:completion];
                                                 }
                                             }];
        }];
    }
}

- (void)shareImageWithAssetPath:(NSString *)assetPath completion:(void (^)(BOOL))completion {
    NSString *str = [NSString stringWithFormat:@"instagram://library?AssetPath=%@", assetPath];
    NSURL *instagramURL = [NSURL URLWithString:str];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        [[UIApplication sharedApplication] openURL:instagramURL options:@{} completionHandler:^(BOOL success) {
            !completion ?: completion(success);
        }];
    } else {
        !completion ?: completion(false);
    }
}

@end
