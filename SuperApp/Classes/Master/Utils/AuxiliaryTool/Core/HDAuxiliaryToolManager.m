//
//  HDAuxiliaryToolManager.m
//  SuperApp
//
//  Created by VanJay on 2019/11/23.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDAuxiliaryToolManager.h"
#import "HDAuxiliaryToolHomeWindow.h"
#import "HDAuxiliaryToolMacro.h"
#import "HDAuxiliaryToolShowFPSWindow.h"
#import "HDAuxiliaryToolShowLogWindow.h"
#import "HDAuxiliaryToolWindow.h"


@interface HDAuxiliaryToolManager ()
@property (nonatomic, strong) HDAuxiliaryToolWindow *toolWindow; ///< 工具窗口
@end


@implementation HDAuxiliaryToolManager
+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static HDAuxiliaryToolManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self shared];
}

- (void)setup {
    _toolWindow = [[HDAuxiliaryToolWindow alloc] init];
    [_toolWindow makeKeyAndVisible];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL isOn = [[defaults valueForKey:kHDAuxiliaryToolShowLogKey] boolValue];

    HDLogger.sharedInstance.delegate = [HDAuxiliaryToolShowLogWindow shared];
    if (isOn) {
        [[HDAuxiliaryToolShowLogWindow shared] show];

        BOOL canScroll = [[defaults valueForKey:kHDAuxiliaryToolCanScrollLogViewKey] boolValue];
        [[HDAuxiliaryToolShowLogWindow shared].vc setLogCanScroll:canScroll];

        CGFloat value = [[defaults valueForKey:kHDAuxiliaryToolShowLogViewAlphaValueKey] floatValue];
        [[HDAuxiliaryToolShowLogWindow shared].vc setLogTextViewAlpha:value];
    }

    BOOL isShowFPSOn = [[defaults valueForKey:kHDAuxiliaryToolShowFPSKey] boolValue];
    if (isShowFPSOn) {
        [[HDAuxiliaryToolShowFPSWindow shared] show];
    }
}
@end
