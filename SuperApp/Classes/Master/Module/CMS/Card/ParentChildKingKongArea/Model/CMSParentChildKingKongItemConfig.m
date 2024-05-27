//
//  CMSParentChildKingKongItemConfig.m
//  SuperApp
//
//  Created by Chaos on 2021/7/1.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "CMSParentChildKingKongItemConfig.h"


@implementation CMSParentChildKingKongItemConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.titleColor = @"#343b4d";
        self.titleFont = 12;
    }
    return self;
}


- (void)setTitleColor:(NSString *)titleColor {
    if (HDIsStringEmpty(titleColor)) {
        titleColor = @"#343b4d";
    }
    [super setTitleColor:titleColor];
}

- (void)setTitleFont:(NSUInteger)titleFont {
    if (titleFont <= 0) {
        titleFont = 12;
    }
    [super setTitleFont:titleFont];
}

@end
