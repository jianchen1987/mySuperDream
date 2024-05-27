//
//  HDAuxiliaryToolBaseWindow.m
//  SuperApp
//
//  Created by VanJay on 2019/11/23.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDAuxiliaryToolBaseWindow.h"
#import <HDUIKit/HDUIKit.h>


@implementation HDAuxiliaryToolBaseWindow

+ (HDAuxiliaryToolBaseWindow *)shared {
    static dispatch_once_t once;
    static HDAuxiliaryToolBaseWindow *instance;
    dispatch_once(&once, ^{
        instance = [[HDAuxiliaryToolBaseWindow alloc] initWithFrame:CGRectZero];
    });
    return instance;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelStatusBar + 2.f;
        [self addRootVc];
    }
    return self;
}

- (void)addRootVc {
    // 需要子类重写
}

- (void)becomeKeyWindow {
    UIWindow *appWindow = [[UIApplication sharedApplication].delegate window];
    [appWindow makeKeyWindow];
}

- (void)show {
    self.hidden = NO;
}

- (void)hide {
    self.hidden = YES;
}
@end
