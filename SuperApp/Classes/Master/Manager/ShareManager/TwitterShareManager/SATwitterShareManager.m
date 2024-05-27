//
//  SATwitterShareManager.m
//  SuperApp
//
//  Created by Chaos on 2021/3/19.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SATwitterShareManager.h"
#import "SAShareWebpageObject.h"
#import "SAShareImageObject.h"
#import "SAWindowManager.h"
//#import <TwitterKit/TWTRComposer.h>
#import <Social/Social.h>
#import <HDKitCore/HDKitCore.h>


@implementation SATwitterShareManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static SATwitterShareManager *instance = nil;
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
    SLComposeViewController *composeVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    if (!composeVC) {
        HDLog(@"您尚未安装软件");
        !completion ?: completion(false);
        return;
    }
    if ([shareObject isKindOfClass:SAShareWebpageObject.class]) {
        SAShareWebpageObject *tureShareObject = (SAShareWebpageObject *)shareObject;
        NSString *webpage = HDIsStringNotEmpty(tureShareObject.facebookWebpageUrl) ? tureShareObject.facebookWebpageUrl : tureShareObject.webpageUrl;

        //        TWTRComposer *composer = [[TWTRComposer alloc] init];
        //        [composer setText:tureShareObject.title];
        //        [composer setURL:[NSURL URLWithString:webpage]];
        //        [composer showFromViewController:SAWindowManager.visibleViewController completion:^(TWTRComposerResult result){
        //            if(result == TWTRComposerResultCancelled) {
        //                !completion ?: completion(false);
        //            }else{
        //                !completion ?: completion(true);
        //            }
        //        }];
        [composeVC addURL:[NSURL URLWithString:webpage]];
        [composeVC setInitialText:tureShareObject.title];
        [composeVC addImage:tureShareObject.thumbImage];

    } else if ([shareObject isKindOfClass:SAShareImageObject.class]) {
        SAShareImageObject *tureShareObject = (SAShareImageObject *)shareObject;

        //        TWTRComposer *composer = [[TWTRComposer alloc] init];
        //        [composer setImage:tureShareObject.shareImage];
        //        [composer showFromViewController:SAWindowManager.visibleViewController completion:^(TWTRComposerResult result){
        //            if(result == TWTRComposerResultCancelled) {
        //                !completion ?: completion(false);
        //            }else{
        //                !completion ?: completion(true);
        //            }
        //        }];
        [composeVC addImage:tureShareObject.shareImage];
    }
    //弹出分享控制器
    [SAWindowManager.visibleViewController presentViewController:composeVC animated:YES completion:^{
        CGFloat top = iPhoneXSeries ? 44 : 20;
        composeVC.view.frame = CGRectMake(0, top, SCREEN_WIDTH, SCREEN_HEIGHT - top);
    }];
    //监听用户点击了取消还是发送
    composeVC.completionHandler = ^(SLComposeViewControllerResult result) {
        if (result == SLComposeViewControllerResultCancelled) {
            !completion ?: completion(false);
        } else {
            !completion ?: completion(true);
        }
    };
}
@end
