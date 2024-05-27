//
//  FBSDKShareManager.m
//  SuperApp
//
//  Created by Chaos on 2020/12/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "FBSDKShareManager.h"
#import "SAShareImageObject.h"
#import "SAShareWebpageObject.h"
#import "SAWindowManager.h"
#import <FBSDKShareKit/FBSDKShareKit.h>


@interface FBSDKShareManager () <FBSDKSharingDelegate>

/// 分享回调
@property (nonatomic, copy) void (^shareCompletion)(BOOL success);

@end


@implementation FBSDKShareManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static FBSDKShareManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self sharedManager];
}

#pragma mark - public methods
- (void)sendShareInFacebook:(SAShareObject *)shareObject completion:(void (^)(BOOL))completion {
    self.shareCompletion = completion;
    [FBSDKShareDialog showFromViewController:[SAWindowManager visibleViewController] withContent:[self sendContentWithShareObject:shareObject] delegate:self];
}

- (void)sendShareInMessenger:(SAShareObject *)shareObject completion:(void (^)(BOOL))completion {
    self.shareCompletion = completion;
    BeginIgnoreClangWarning(-Wunused - result)[FBSDKMessageDialog showWithContent:[self sendContentWithShareObject:shareObject] delegate:self];
    EndIgnoreClangWarning
}

#pragma mark - private methods
- (id<FBSDKSharingContent>)sendContentWithShareObject:(SAShareObject *)shareObject {
    id<FBSDKSharingContent> content;
    if ([shareObject isKindOfClass:SAShareWebpageObject.class]) {
        SAShareWebpageObject *tureShareObject = (SAShareWebpageObject *)shareObject;
        FBSDKShareLinkContent *linkContent = [[FBSDKShareLinkContent alloc] init];
        linkContent.contentURL = [NSURL URLWithString:HDIsStringNotEmpty(tureShareObject.facebookWebpageUrl) ? tureShareObject.facebookWebpageUrl : tureShareObject.webpageUrl];
        content = linkContent;
    } else if ([shareObject isKindOfClass:SAShareImageObject.class]) {
        SAShareImageObject *tureShareObject = (SAShareImageObject *)shareObject;
        // 此时的shareImage必须为UIImage类型
        FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] initWithImage:tureShareObject.shareImage isUserGenerated:true];
        FBSDKSharePhotoContent *photoContent = [[FBSDKSharePhotoContent alloc] init];
        photoContent.photos = @[photo];
        content = photoContent;
    }
    return content;
}

#pragma mark - FBSDKSharingDelegate
- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary<NSString *, id> *)results {
    HDLog(@"Facebook分享成功：%@", results);
    !self.shareCompletion ?: self.shareCompletion(true);
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
    HDLog(@"Facebook分享失败：%@", error);
    !self.shareCompletion ?: self.shareCompletion(false);
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
    !self.shareCompletion ?: self.shareCompletion(false);
}

@end
