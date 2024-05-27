//
//  SACMSPluginView.m
//  SuperApp
//
//  Created by seeu on 2022/6/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SACMSPluginView.h"


@implementation SACMSPluginView

- (instancetype)initWithConfig:(SACMSPluginViewConfig *)config {
    self = [super init];
    if (self) {
        self.config = config;
    }
    return self;
}

- (void)setConfig:(SACMSPluginViewConfig *)config {
    _config = config;

    [self setNeedsUpdateConstraints];
}

@end
