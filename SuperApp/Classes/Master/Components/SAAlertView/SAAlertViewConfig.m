//
//  SAAlertViewConfig.m
//  SuperApp
//
//  Created by Tia on 2022/9/19.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAAlertViewConfig.h"
#import "HDCommonDefines.h"
#import "SAAppTheme.h"


@implementation SAAlertViewConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        CGFloat margin = kRealWidth(12);

        //        const CGFloat onePix = (CGFloat)(1 * 2) / [UIScreen mainScreen].scale;
        // 默认值
        self.titleFont = HDAppTheme.font.sa_standard16B;
        self.titleColor = HDAppTheme.color.sa_C333;
        self.messageFont = HDAppTheme.font.sa_standard14;
        self.messageColor = HDAppTheme.color.sa_C999;
        self.containerViewEdgeInsets = UIEdgeInsetsMake(kRealWidth(64), margin, kRealWidth(16), margin);
        self.contentViewEdgeInsets = UIEdgeInsetsMake(kRealWidth(5), kRealWidth(15), kRealWidth(5), kRealWidth(15));
        self.labelHEdgeMargin = kRealWidth(16);
        self.marginTitle2Message = margin;
        self.marginMessageToButton = kRealWidth(16);
        self.buttonHMargin = margin;
        self.buttonVMargin = 2;
        self.buttonHeight = margin * 4;
        self.buttonCorner = 4;
        self.containerCorner = 8;
        self.containerMinHeight = 10;
    }
    return self;
}

@end
