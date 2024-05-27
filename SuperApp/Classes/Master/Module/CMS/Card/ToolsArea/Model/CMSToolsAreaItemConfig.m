//
//  CMSToolsAreaItemConfig.m
//  SuperApp
//
//  Created by Chaos on 2021/6/29.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "CMSToolsAreaItemConfig.h"


@implementation CMSToolsAreaItemConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.titleColor = @"#5d667f";
        self.titleFont = 15;
    }
    return self;
}


- (void)setTitleColor:(NSString *)titleColor {
    if (HDIsStringEmpty(titleColor)) {
        _titleColor = @"#5d667f";
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
