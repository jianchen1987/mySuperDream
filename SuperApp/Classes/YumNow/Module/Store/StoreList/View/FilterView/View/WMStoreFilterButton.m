//
//  WMStoreFilterButton.m
//  SuperApp
//
//  Created by VanJay on 2020/4/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreFilterButton.h"
#import <HDKitCore/HDFrameLayout.h>


@interface WMStoreFilterButton ()

@end


@implementation WMStoreFilterButton

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];

    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (CGRectIsEmpty(self.frame))
        return;
    const CGFloat w = self.width, h = self.height;
    const CGFloat margin = 5;
    const CGFloat imageW = self.imageView.image.size.width;
    const CGFloat maxLabelWidth = w - imageW - margin;
    const CGFloat labelWidth = [self.titleLabel sizeThatFits:CGSizeMake(maxLabelWidth, h)].width;

    [self.imageView hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo((w - margin - imageW - labelWidth) * 0.5);
        make.centerY.hd_equalTo(h * 0.5);
        make.size.hd_equalTo(self.imageView.image.size);
    }];

    [self.titleLabel hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(self.imageView.right).offset(margin);
        make.centerY.hd_equalTo(h * 0.5);
        make.size.hd_equalTo(CGSizeMake(labelWidth, h));
    }];
}
@end
