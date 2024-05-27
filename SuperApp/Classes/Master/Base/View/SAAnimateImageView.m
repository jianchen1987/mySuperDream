//
//  SAAnimateImageView.m
//  SuperApp
//
//  Created by seeu on 2022/6/5.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAAnimateImageView.h"


@implementation SAAnimateImageView

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];

    if (!self.animating && self.animationImages.count) {
        [self startAnimating];
    }
}

@end
