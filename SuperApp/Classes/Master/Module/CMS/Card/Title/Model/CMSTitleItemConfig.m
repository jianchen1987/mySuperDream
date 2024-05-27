//
//  CMSTitleCardConfig.m
//  SuperApp
//
//  Created by Chaos on 2021/7/6.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "CMSTitleItemConfig.h"


@implementation CMSTitleItemConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.titleColor = @"#343b4d";
        self.titleFont = 14;
        self.style = CMSTitleCardStyleMiddle;
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

- (void)setStyle:(CMSTitleCardStyle)style {
    if (style < 1 || style > 3) {
        _style = CMSTitleCardStyleMiddle;
    } else {
        _style = style;
    }
}

@end
