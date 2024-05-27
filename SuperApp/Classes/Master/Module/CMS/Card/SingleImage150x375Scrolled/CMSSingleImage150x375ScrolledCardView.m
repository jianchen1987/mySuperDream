//
//  CMSBigSingleImageScrolledCardView.m
//  SuperApp
//
//  Created by Chaos on 2021/6/28.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "CMSSingleImage150x375ScrolledCardView.h"


@implementation CMSSingleImage150x375ScrolledCardView

- (void)hd_setupViews {
    [super hd_setupViews];
    self.imageRatio = 150 / 375.0;
    self.cornerRadius = 0;
}

@end
