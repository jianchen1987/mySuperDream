//
//  CMSSingleImage80x375ScrolledCardView.m
//  SuperApp
//
//  Created by Chaos on 2021/7/5.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "CMSSingleImage80x375ScrolledCardView.h"


@implementation CMSSingleImage80x375ScrolledCardView

- (void)hd_setupViews {
    [super hd_setupViews];
    self.imageRatio = 80 / 375.0;
    self.cornerRadius = 5;
}

@end
