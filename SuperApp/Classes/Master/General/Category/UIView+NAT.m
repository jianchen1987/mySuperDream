
//
//  UIView+NAT.m
//  SuperApp
//
//  Created by VanJay on 2020/3/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "UIView+NAT.h"
#import <HDKitCore/HDAssociatedObjectHelper.h>
#import <HDUIKit/HDTips.h>


@interface UIView ()
@property (nonatomic, strong) HDTips *hud; ///< 提示 HUD
@end


@implementation UIView (NAT)
HDSynthesizeIdStrongProperty(hud, setHud);

#pragma mark - HUD
- (void)showloading {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.hud) {
            [self.hud hideAnimated:NO];
        }
        self.hud = [HDTips showLoadingInView:self];
        @HDWeakify(self);
        self.hud.didHideBlock = ^(UIView *_Nonnull hideInView, BOOL animated) {
            @HDStrongify(self);
            [self.hud removeFromSuperview];
            self.hud = nil;
        };
    });
}

- (void)showloadingText:(id)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.hud) {
            [self.hud hideAnimated:true];
        }
        self.hud = [HDTips showLoading:text inView:self];
        @HDWeakify(self);
        self.hud.didHideBlock = ^(UIView *_Nonnull hideInView, BOOL animated) {
            @HDStrongify(self);
            [self.hud removeFromSuperview];
            self.hud = nil;
        };
    });
}

- (void)dismissLoading {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.hud) {
            [self.hud hideAnimated:true afterDelay:0];
        }
    });
}

- (void)dismissLoadingAfterDelay:(NSTimeInterval)delay {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.hud) {
            [self.hud hideAnimated:true afterDelay:delay];
        }
    });
}
@end
