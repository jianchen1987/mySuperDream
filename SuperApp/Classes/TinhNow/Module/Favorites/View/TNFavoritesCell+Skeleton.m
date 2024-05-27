//
//  TNFavoritesCell+Skeleton.m
//  SuperApp
//
//  Created by 张杰 on 2021/5/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNFavoritesCell+Skeleton.h"


@implementation TNFavoritesCell (Skeleton)
#pragma mark - HDSkeletonLayerLayoutProtocol
- (NSArray<HDSkeletonLayer *> *)skeletonLayoutViews {
    HDSkeletonLayer *circle = [[HDSkeletonLayer alloc] init];
    const CGFloat iconW = 80;
    circle.skeletonCornerRadius = 8;
    [circle hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(iconW);
        make.height.hd_equalTo(iconW);
        make.top.hd_equalTo(15);
        make.left.hd_equalTo(15);
    }];

    HDSkeletonLayer *r1 = [[HDSkeletonLayer alloc] init];
    [r1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.top.hd_equalTo(circle.hd_top);
        make.left.hd_equalTo(circle.hd_right + 10);
        make.right.hd_equalTo(self.hd_right - 15);
        make.height.hd_equalTo(20);
    }];

    HDSkeletonLayer *r2 = [[HDSkeletonLayer alloc] init];
    [r2 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(r1.hd_left);
        make.bottom.hd_equalTo(circle.hd_bottom);
        make.height.hd_equalTo(25);
        make.width.hd_equalTo(100);
    }];

    HDSkeletonLayer *r3 = [[HDSkeletonLayer alloc] init];
    [r3 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.right.hd_equalTo(self.hd_right - 15);
        make.width.hd_equalTo(60);
        make.bottom.hd_equalTo(self.hd_bottom - 15);
        make.height.hd_equalTo(30);
    }];

    return @[circle, r1, r2, r3];
}

- (UIColor *)skeletonContainerViewBackgroundColor {
    return UIColor.whiteColor;
}

+ (CGFloat)skeletonViewHeight {
    return 150;
}
@end
