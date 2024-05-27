
//
//  HDPopTipConfig.m
//  SuperApp
//
//  Created by VanJay on 2019/6/26.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDPopTipConfig.h"
#import <HDUIKit/HDAppTheme.h>


@implementation HDPopTipConfig
- (instancetype)init {
    self = [super init];
    if (self) {
        self.textColor = UIColor.whiteColor;
        self.textFont = HDAppTheme.font.standard2;
        self.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        self.autoDismiss = true;
        self.autoDismissDelay = 1;
        self.shouldShake = true;
        self.shakeCount = 6;
        self.shakeDistance = 6.f;
        self.shakeDuration = 1.0;
        self.overLayBackgroundColor = [UIColor colorWithRed:1 / 255.0 green:1 / 255.0 blue:1 / 255.0 alpha:0.60];
        self.contentMaxWidth = 200;
        self.maskImageHeightScale = 1.2;
    }
    return self;
}
@end
