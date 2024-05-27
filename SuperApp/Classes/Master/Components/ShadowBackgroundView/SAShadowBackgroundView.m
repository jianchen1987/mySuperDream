//
//  SAShadowBackgroundView.m
//  SuperApp
//
//  Created by VanJay on 2020/4/15.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAShadowBackgroundView.h"
#import <HDKitCore/HDCommonDefines.h>
#import <HDKitCore/UIView+HDKitCore.h>
#import <HDKitCore/UIView+HD_Extension.h>


@interface SAShadowBackgroundView ()
@property (nonatomic, strong) CAShapeLayer *shadowLayer; ///< 阴影
@end


@implementation SAShadowBackgroundView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.shadowRectCorners = UIRectCornerAllCorners;
        self.shadowRoundRadius = 10;
        self.shadowRadius = 6;
        self.shadowOpacity = 1;
        self.shadowColor = [UIColor.blackColor colorWithAlphaComponent:0.1];
        self.shadowFillColor = UIColor.whiteColor;
        self.backgroundColor = self.shadowFillColor;
        self.shadowOffset = CGSizeMake(0, 0);

        @HDWeakify(self);
        self.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            @HDStrongify(self);
            // 设置阴影圆角
            if (self.shadowLayer) {
                [self.shadowLayer removeFromSuperlayer];
                self.shadowLayer = nil;
            }
            self.shadowLayer = [view setRoundedCorners:self.shadowRectCorners radius:self.shadowRoundRadius shadowRadius:self.shadowRadius shadowOpacity:self.shadowOpacity
                                           shadowColor:self.shadowColor.CGColor
                                             fillColor:self.shadowFillColor.CGColor
                                          shadowOffset:self.shadowOffset];
        };
    }
    return self;
}

- (void)setShadowFillColor:(UIColor *)shadowFillColor {
    _shadowFillColor = shadowFillColor;

    self.backgroundColor = shadowFillColor;
}

- (void)setShadowColor:(UIColor *)shadowColor {
    _shadowColor = shadowColor;

    [self setNeedsLayout];
}
@end
