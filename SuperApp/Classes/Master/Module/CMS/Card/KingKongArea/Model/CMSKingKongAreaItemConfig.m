//
//  CMSKingKongAreaItemConfig.m
//  SuperApp
//
//  Created by Chaos on 2021/6/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "CMSKingKongAreaItemConfig.h"
#import "SACMSNode.h"


@implementation CMSKingKongAreaItemConfig

- (instancetype)init {
    if (self = [super init]) {
        self.type = CMSHomeDynamicShowTypeTwo;
        self.titleColor = @"#5d667f";
        self.titleFont = 12;
    }
    return self;
}

- (NSString *)identifier {
    return self.node.nodeNo;
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
        _titleFont = 12;
    } else {
        _titleFont = titleFont;
    }
}

@end
