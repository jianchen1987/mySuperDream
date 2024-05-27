//
//  TNNavgationCapacityResponse.m
//  SuperApp
//
//  Created by seeu on 2020/7/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNNavgationCapacityResponse.h"
#import "SASocialShareView.h"
#import "TNMultiLanguageManager.h"
#import "TNShortLinkManager.h"
#import <HDKitCore/HDKitCore.h>
#import <HDUIKit/HDUIKit.h>
#import <HDVendorKit/HDVendorKit.h>


@interface TNNavgationCapacityResponse ()
/// 缓存分享参数
@property (nonatomic, strong) NSDictionary *shareParams;
@end


@implementation TNNavgationCapacityResponse
+ (NSDictionary<NSString *, NSString *> *)supportActionList {
    return @{@"showSocialShareNavButton_$": kHDWHResponseMethodOn, @"showPhoneCallNavButton_$": kHDWHResponseMethodOn, @"removeAllNavButton$": kHDWHResponseMethodOn};
}

- (void)showSocialShareNavButton:(NSDictionary *)paramDict callback:(NSString *)callBackKey {
    NSString *content = paramDict[@"content"];
    //    NSString *imageUrl = paramDict[@"titleImage"];
    //    NSString *title = paramDict[@"title"];

    if (HDIsStringEmpty(content)) {
        [self.webViewHost fireCallback:callBackKey actionName:@"showSocialShareNav" code:HDWHRespCodeIllegalArg type:HDWHCallbackTypeFail params:@{}];
        return;
    }
    self.shareParams = [NSMutableDictionary dictionaryWithDictionary:paramDict];

    HDUIButton *socialShareButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
    [socialShareButton setImage:[UIImage imageNamed:@"tinhnow-black-share-new"] forState:UIControlStateNormal];
    @HDWeakify(self);
    [socialShareButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
        @HDStrongify(self);
        [self socialShare];
    }];
    socialShareButton.imageEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(7), 0, 0);
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:socialShareButton];
    NSMutableArray<UIBarButtonItem *> *items = [NSMutableArray arrayWithArray:self.webViewHost.hd_navigationItem.rightBarButtonItems];

    [items addObject:barButtonItem];
    [self.webViewHost.hd_navigationItem setRightBarButtonItems:items];
    [self.webViewHost fireCallback:callBackKey actionName:@"showSocialShareNav" code:HDWHRespCodeSuccess type:HDWHCallbackTypeSuccess params:@{}];
}

- (void)showPhoneCallNavButton:(NSDictionary *)paramDict callback:(NSString *)callBackKey {
    NSString *phoneNum = paramDict[@"phone"];
    if (HDIsStringEmpty(phoneNum)) {
        [self.webViewHost fireCallback:callBackKey actionName:@"showPhoneCallNavButton" code:HDWHRespCodeIllegalArg type:HDWHCallbackTypeFail params:@{}];
        return;
    }
    HDUIButton *phoneCallButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
    [phoneCallButton setImage:[UIImage imageNamed:@"tinhnow_nav_phone"] forState:UIControlStateNormal];
    [phoneCallButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
        [HDSystemCapabilityUtil makePhoneCall:phoneNum];
    }];
    phoneCallButton.imageEdgeInsets = UIEdgeInsetsMake(0, kRealWidth(7), 0, 0);
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:phoneCallButton];
    NSMutableArray<UIBarButtonItem *> *items = [NSMutableArray arrayWithArray:self.webViewHost.hd_navigationItem.rightBarButtonItems];
    [items addObject:barButtonItem];
    [self.webViewHost.hd_navigationItem setRightBarButtonItems:items];
    [self.webViewHost fireCallback:callBackKey actionName:@"showPhoneCallNavButton" code:HDWHRespCodeSuccess type:HDWHCallbackTypeSuccess params:@{}];
}

- (void)removeAllNavButtonWithCallback:(NSString *)callBackKey {
    NSArray<UIBarButtonItem *> *items = self.webViewHost.hd_navigationItem.rightBarButtonItems;
    if (!items.count) {
        [self.webViewHost fireCallback:callBackKey actionName:@"removeAllNavButton" code:HDWHRespCodeCommonFailed type:HDWHCallbackTypeFail params:@{}];
    } else {
        self.webViewHost.hd_navigationItem.rightBarButtonItems = nil;
        [self.webViewHost fireCallback:callBackKey actionName:@"removeAllNavButton" code:HDWHRespCodeSuccess type:HDWHCallbackTypeSuccess params:@{}];
    }
}

#pragma mark - private methods
- (void)socialShare {
    NSString *content = self.shareParams[@"content"];
    NSString *imageUrl = self.shareParams[@"image"];
    NSString *title = self.shareParams[@"title"];
    NSString *facebookUrl = self.shareParams[@"facebookWebpageUrl"];
    NSString *desc = self.shareParams[@"desc"];
    SAShareWebpageObject *object = [[SAShareWebpageObject alloc] init];
    object.title = title;
    object.webpageUrl = content;
    object.facebookWebpageUrl = facebookUrl;
    object.thumbImage = imageUrl;
    object.descr = desc;
    [SASocialShareView showShareWithShareObject:object completion:nil];
}
@end
