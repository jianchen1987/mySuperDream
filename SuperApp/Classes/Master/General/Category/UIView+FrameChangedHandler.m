//
//  UIView+FrameChangedHandler.m
//  SuperApp
//
//  Created by VanJay on 2020/4/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "UIView+FrameChangedHandler.h"
#import <HDKitCore/HDAssociatedObjectHelper.h>
#import <Stinger/Stinger.h>

static NSString *const kID = @"UIView.layoutSubviews.after";
static NSString *const kIDOnce = @"UIView.layoutSubviews.after.once";


@interface UIView ()
@property (nonatomic, assign) CGRect hd_frameChangedHandler_oldFrame; ///< 旧 frame
@end


@implementation UIView (FrameChangedHandler)

- (void)hd_setFrameChangedHandler:(FrameChangedHandler)handler {
    void (^insideHandler)(void) = ^{
        !handler ?: handler(self.frame);
    };

    self.hd_frameChangedHandler_oldFrame = self.frame;
    [self st_hookInstanceMethod:@selector(layoutSubviews) option:STOptionAfter usingIdentifier:kID withBlock:^(id<StingerParams> params) {
        if (!CGRectEqualToRect(self.hd_frameChangedHandler_oldFrame, self.frame)) {
            // HDLog(@"%@ <%p> frame changed：%@", NSStringFromClass(self.class), self, NSStringFromCGRect(self.frame));
            // 设置新值
            self.hd_frameChangedHandler_oldFrame = self.frame;
            insideHandler();
        }
    }];
}

- (void)hd_removeFrameChangedHandler {
    [self st_removeHookWithIdentifier:kID forKey:@selector(layoutSubviews)];
}

- (void)hd_setFrameNonZeroOnceHandler:(FrameChangedHandler)handler {
    void (^insideHandler)(void) = ^{
        // 能再次进到这里来，这个又有值，说明已经有 frame，移除 hook
        [self st_removeHookWithIdentifier:kIDOnce forKey:@selector(layoutSubviews)];
        if (handler) {
            handler(self.frame);
        }
    };

    CGFloat selfWidth = CGRectGetWidth(self.frame);
    if (selfWidth <= 0 || isnan(selfWidth)) {
        [self st_hookInstanceMethod:@selector(layoutSubviews) option:STOptionAfter usingIdentifier:kIDOnce withBlock:^(id<StingerParams> params) {
            if (!CGRectIsEmpty(self.frame)) {
                // HDLog(@"%@ <%p> frame non zero revoked：%@", NSStringFromClass(self.class), self, NSStringFromCGRect(self.frame));
                insideHandler();
            }
        }];
    } else {
        insideHandler();
    }
}

#pragma mark - getters and setters
HDSynthesizeCGRectProperty(hd_frameChangedHandler_oldFrame, setHd_frameChangedHandler_oldFrame);
@end
