//
//  SAChooseLanguageManager.m
//  SuperApp
//
//  Created by VanJay on 2020/9/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAChooseLanguageManager.h"
#import "SAChooseLanguageViewController.h"
#import "SAWindowManager.h"
#import "SAAppLaunchToDoService.h"
#import <HDUIKit/HDActionAlertView.h>
#import <UIKit/UIKit.h>


@interface SAChooseLanguageWindow : UIWindow

@end


@implementation SAChooseLanguageWindow
- (void)becomeKeyWindow {
    UIWindow *appWindow = SAWindowManager.keyWindow;
    [appWindow makeKeyWindow];
}
@end


@implementation SAChooseLanguageManager
UIWindow *__chooseLanguageWindow = nil;

+ (BOOL)isVisible {
    return !HDIsObjectNil(__chooseLanguageWindow);
}

+ (void)adjustShouldShowChooseLanguageWindow {
    NSString *key = @"hasShownChooseLanguageWindow";

    // 判断是否已经展示过该 window
    BOOL hasShown = [[NSUserDefaults.standardUserDefaults objectForKey:key] boolValue];

    // 全部变量 block 不会捕获
    void (^destoryWindowAnimated)(BOOL) = ^(BOOL animated) {
        if (__chooseLanguageWindow) {
            if (animated) {
                [UIView animateWithDuration:0.3 animations:^{
                    __chooseLanguageWindow.top = UIScreen.mainScreen.bounds.size.height;
                } completion:^(BOOL finished) {
                    // 使原来的 rootViewController 释放
                    __chooseLanguageWindow = nil;
                    [[SAAppLaunchToDoService sharedInstance] performAllAfterChooseLanguage];
                }];
            } else {
                // 使原来的 rootViewController 释放
                __chooseLanguageWindow = nil;
                [[SAAppLaunchToDoService sharedInstance] performAllAfterChooseLanguage];
            }
        }
    };

    if (hasShown) {
        destoryWindowAnimated(false);
        return;
    }

    destoryWindowAnimated(false);
    SAChooseLanguageViewController *vc = SAChooseLanguageViewController.new;
    vc.actionCompletionBlock = ^{
        destoryWindowAnimated(true);
    };
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    window.opaque = NO;
    window.rootViewController = vc;
    // 确保最顶层显示
    window.windowLevel = HDActionAlertViewWindowLevel + 5;
    __chooseLanguageWindow = window;
    [__chooseLanguageWindow makeKeyAndVisible];
    //延迟2秒修改本地缓存，使首页先不请求定位
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [NSUserDefaults.standardUserDefaults setObject:@(1) forKey:key];
        [NSUserDefaults.standardUserDefaults synchronize];
    });

}
@end
