//
//  CMSThreeImage3x2ItemConfig.m
//  SuperApp
//
//  Created by Chaos on 2021/6/29.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "CMSThreeImage3x2ItemConfig.h"


@implementation CMSThreeImage3x2ItemConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.titleColor = @"#343b4d";
        self.titleFont = 14;
    }
    return self;
}

#pragma mark - setter
- (void)setTitleColor:(NSString *)titleColor {
    if (HDIsStringEmpty(titleColor)) {
        _titleColor = @"#343b4d";
    } else {
        _titleColor = titleColor;
    }
}

- (void)setTitleFont:(NSUInteger)titleFont {
    if (titleFont <= 0) {
        _titleFont = 14;
    } else {
        _titleFont = titleFont;
    }
}

@end
