//
//  TNMyCustomerItemCell+Skeleton.m
//  SuperApp
//
//  Created by xixi_wen on 2021/12/13.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNMyCustomerItemCell+Skeleton.h"


@implementation TNMyCustomerItemCell (Skeleton)

#pragma mark - HDSkeletonLayerLayoutProtocol
- (NSArray<HDSkeletonLayer *> *)skeletonLayoutViews {
    HDSkeletonLayer *circle = [[HDSkeletonLayer alloc] init];
    const CGFloat iconW = 20;
    circle.skeletonCornerRadius = 10;
    [circle hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(iconW);
        make.height.hd_equalTo(iconW);
        make.top.hd_equalTo(12);
        make.left.hd_equalTo(12);
    }];

    HDSkeletonLayer *r1 = [[HDSkeletonLayer alloc] init];
    [r1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.top.hd_equalTo(circle.hd_top);
        make.left.hd_equalTo(circle.hd_right + 10);
        make.right.hd_equalTo(self.hd_right - 15);
        make.height.hd_equalTo(20);
    }];

    return @[circle, r1];
}

- (UIColor *)skeletonContainerViewBackgroundColor {
    return UIColor.whiteColor;
}

+ (CGFloat)skeletonViewHeight {
    return 60;
}

@end
