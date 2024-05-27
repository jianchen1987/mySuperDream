//
//  CMSTwoImageScrolledItemConfig.m
//  SuperApp
//
//  Created by Chaos on 2021/7/5.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "CMSTwoImagePagedItemConfig.h"


@implementation CMSTwoImagePagedItemConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.titleColor = @"#343b4d";
        self.titleFont = 15;
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

@end
