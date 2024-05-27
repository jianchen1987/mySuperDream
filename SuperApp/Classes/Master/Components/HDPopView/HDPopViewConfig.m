//
//  HDPopViewConfig.m
//  SuperApp
//
//  Created by VanJay on 2019/6/26.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDPopViewConfig.h"
#import <HDKitCore/HDCommonDefines.h>
#import <HDUIKit/HDAppTheme.h>


@implementation HDPopViewConfig
- (instancetype)init {
    self = [super init];
    if (self) {
        self.arrowSideLength = 10.f;
        self.arrowBottomSideLength = 10.f;
        self.cornerRadius = 5.f;
        self.colors = @[[UIColor colorWithRed:249 / 255.0 green:68 / 255.0 blue:130 / 255.0 alpha:1.0], [UIColor colorWithRed:239 / 255.0 green:24 / 255.0 blue:98 / 255.0 alpha:1.0]];
        self.locations = @[@(0), @(1.0f)];
        self.textColor = UIColor.whiteColor;
        self.textFont = HDAppTheme.font.standard2;
        self.edgeInsets = UIEdgeInsetsMake(kRealWidth(5), kRealWidth(15), kRealWidth(5), kRealWidth(15));
        self.autoDismiss = false;
        self.autoDismissDelay = 1;
        self.shouldShake = false;
        self.shakeCount = 6;
        self.shakeDistance = 6.f;
        self.shakeDuration = 1.0;
        self.overLayBackgroundColor = UIColor.clearColor;
        self.contentMaxWidth = kScreenWidth * 0.9;
        self.contentBackgroundColor = [[UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1.0] colorWithAlphaComponent:0.7];
    }
    return self;
}
@end
