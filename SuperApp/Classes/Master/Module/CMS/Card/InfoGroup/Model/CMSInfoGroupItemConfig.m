//
//  CMSInfoGroupItemConfig.m
//  SuperApp
//
//  Created by Chaos on 2021/7/16.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "CMSInfoGroupItemConfig.h"


@implementation CMSInfoGroupItemConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.titleColor = @"#343b4d";
        self.titleFont = 15;
        self.subTitleColor = @"#adb6c8";
        self.subTitleFont = 15;
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
        _titleFont = 15;
    } else {
        _titleFont = titleFont;
    }
}

- (void)setSubTitleColor:(NSString *)subTitleColor {
    if (HDIsStringEmpty(subTitleColor)) {
        _subTitleColor = @"#adb6c8";
    } else {
        _subTitleColor = subTitleColor;
    }
}

- (void)setSubTitleFont:(NSUInteger)subTitleFont {
    if (subTitleFont <= 0) {
        _subTitleFont = 15;
    } else {
        _subTitleFont = subTitleFont;
    }
}

@end
