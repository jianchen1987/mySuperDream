//
//  PNWalletLogOutManager.m
//  SuperApp
//
//  Created by xixi_wen on 2022/8/31.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNWalletLogOutManager.h"
#import "HDWeakTimer.h"
#import "PNUtilMacro.h"
#import "SAWindowManager.h"
#import "HDCommonDefines.h"
#import "PNMultiLanguageManager.h"
#import <HDUIKit/NAT.h>
#import <HDKitCore/HDFunctionThrottle.h>
#import <HDKitCore/UIViewController+HDKitCore.h>


@interface PNWalletLogOutManager ()
@property (nonatomic, assign) NSInteger totalSecond;
@property (nonatomic, strong) NSTimer *timer;
@end


@implementation PNWalletLogOutManager

+ (instancetype)sharedInstance {
    static PNWalletLogOutManager *ins = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ins = [[super allocWithZone:nil] init];
    });
    return ins;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [self sharedInstance];
}

- (id)copyWithZone:(NSZone *)zone {
    return [[self class] sharedInstance];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[self class] sharedInstance];
}

/// init pro


/// start count down
- (void)start {
    HDLog(@"pre check");
    [self destroy];
    self.totalSecond = 10000;
    HDLog(@"%@", _timer);
    [HDFunctionThrottle throttleWithInterval:1 handler:^{
        HDLog(@"start");
        @HDWeakify(self);
        NSString *currentVCNameStr = NSStringFromClass(SAWindowManager.visibleViewController.class);
        HDLog(@"当前的root是: %@", NSStringFromClass(SAWindowManager.rootViewController.class));
        HDLog(@"当前的vc是: %@", currentVCNameStr);
        @HDStrongify(self);
        /// HDScanCodeViewController
        if ([currentVCNameStr hasPrefix:@"PN"] || [currentVCNameStr isEqualToString:@"PayHDCheckstandInputPwdViewController"] ||
            [currentVCNameStr isEqualToString:@"PayHDCheckstandConfirmViewController"]) {
            @HDWeakify(self);
            self.timer = [HDWeakTimer scheduledTimerWithTimeInterval:1 block:^(id userInfo) {
                @HDStrongify(self);
                [self countDown];
            } userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:UITrackingRunLoopMode];
        }
    }];
}

/// 销毁定时器
- (void)destroy {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

/// 时间倒数
- (void)countDown {
    if (_totalSecond > 0) {
        _totalSecond -= 1;
    }
    HDLog(@"%zd", _totalSecond);
    if (_totalSecond <= 0) {
        [self destroy];

        [NAT showAlertWithMessage:@"由于您长时间未作任何操作，账户已登出，为了您的账户安全，请重新登录。" buttonTitle:SALocalizedStringFromTable(@"confirm", @"确定", @"Buttons")
                          handler:^(HDAlertView *_Nonnull alertView, HDAlertViewButton *_Nonnull button) {
                              [alertView dismiss];

                              if ([NSStringFromClass(SAWindowManager.visibleViewController.navigationController.class) isEqualToString:@"PayHDCheckstandViewController"]) {
                                  /// 处理收银台
                                  [SAWindowManager.visibleViewController.navigationController dismissAnimated:YES completion:^{
                                      [SAWindowManager.visibleViewController.navigationController popToRootViewControllerAnimated:YES];
                                  }];
                              } else {
                                  [SAWindowManager.visibleViewController.navigationController popToRootViewControllerAnimated:YES];
                              }
                          }];
    }
}
@end
