//
//  TNNotReviewGoodCell+Skeleton.m
//  SuperApp
//
//  Created by 张杰 on 2021/3/26.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNNotReviewGoodCell+Skeleton.h"


@implementation TNNotReviewGoodCell (Skeleton)
#pragma mark - HDSkeletonLayerLayoutProtocol
- (NSArray<HDSkeletonLayer *> *)skeletonLayoutViews {
    HDSkeletonLayer *t1 = [[HDSkeletonLayer alloc] init];
    [t1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.top.hd_equalTo(15);
        make.left.hd_equalTo(15);
        make.width.hd_equalTo(120);
        make.height.hd_equalTo(17);
    }];

    HDSkeletonLayer *t2 = [[HDSkeletonLayer alloc] init];
    [t2 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.top.hd_equalTo(15);
        make.right.hd_equalTo(self.hd_right - 15);
        make.width.hd_equalTo(20);
        make.height.hd_equalTo(20);
    }];

    HDSkeletonLayer *circle = [[HDSkeletonLayer alloc] init];
    const CGFloat iconW = 60;
    [circle hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(iconW);
        make.height.hd_equalTo(iconW);
        make.top.hd_equalTo(t1.hd_bottom + 20);
        make.left.hd_equalTo(15);
    }];

    CGFloat margin = 10;
    HDSkeletonLayer *r1 = [[HDSkeletonLayer alloc] init];
    [r1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(150);
        make.height.hd_equalTo(20);
        make.left.hd_equalTo(circle.hd_right + margin);
        make.top.hd_equalTo(circle.hd_top);
    }];

    HDSkeletonLayer *r2 = [[HDSkeletonLayer alloc] init];
    [r2 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(r1.hd_left);
        make.right.hd_equalTo(self.hd_right - 15);
        make.bottom.hd_equalTo(circle.hd_bottom - 5);
        make.height.hd_equalTo(20);
    }];

    HDSkeletonLayer *r3 = [[HDSkeletonLayer alloc] init];
    [r3 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(r1.hd_left);
        make.width.hd_equalTo(120);
        make.top.hd_equalTo(r2.hd_bottom + 10);
        make.height.hd_equalTo(20);
    }];

    HDSkeletonLayer *r4 = [[HDSkeletonLayer alloc] init];
    [r4 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.right.hd_equalTo(self.hd_right - 15);
        make.width.hd_equalTo(60);
        make.top.hd_equalTo(r3.hd_top);
        make.height.hd_equalTo(r3.hd_height);
    }];

    return @[t1, t2, circle, r1, r2, r3, r4];
}

- (UIColor *)skeletonContainerViewBackgroundColor {
    return UIColor.whiteColor;
}

+ (CGFloat)skeletonViewHeight {
    return 160;
}
@end
