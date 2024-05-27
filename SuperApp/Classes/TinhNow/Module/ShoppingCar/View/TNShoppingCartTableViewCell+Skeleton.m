//
//  TNShoppingCartTableViewCell+Skeleton.m
//  SuperApp
//
//  Created by seeu on 2020/7/5.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNShoppingCartTableViewCell+Skeleton.h"


@implementation TNShoppingCartTableViewCell (Skeleton)
#pragma mark - HDSkeletonLayerLayoutProtocol
- (NSArray<HDSkeletonLayer *> *)skeletonLayoutViews {
    HDSkeletonLayer *c0 = [[HDSkeletonLayer alloc] init];
    const CGFloat iconW = 20;
    [c0 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(iconW);
        make.height.hd_equalTo(iconW);
        make.centerY.hd_equalTo(TNShoppingCartTableViewCell.skeletonViewHeight * 0.5);
        make.left.hd_equalTo(15);
    }];
    c0.skeletonCornerRadius = iconW * 0.5;

    HDSkeletonLayer *r0 = [[HDSkeletonLayer alloc] init];
    const CGFloat r0W = TNShoppingCartTableViewCell.skeletonViewHeight - 2 * 15;
    [r0 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(r0W);
        make.height.hd_equalTo(r0W);
        make.top.hd_equalTo(15);
        make.left.hd_equalTo(c0.hd_right).offset(10);
    }];
    r0.skeletonCornerRadius = 5;

    CGFloat margin = 10;
    HDSkeletonLayer *r1 = [[HDSkeletonLayer alloc] init];
    [r1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(100);
        make.height.hd_equalTo(15);
        make.left.hd_equalTo(r0.hd_right + margin);
        make.top.hd_equalTo(r0.hd_top);
    }];

    HDSkeletonLayer *r2 = [[HDSkeletonLayer alloc] init];
    [r2 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(r1.hd_left);
        make.width.hd_equalTo(70);
        make.top.hd_equalTo(r1.hd_bottom).offset(10);
        make.height.hd_equalTo(15);
    }];

    HDSkeletonLayer *r3 = [[HDSkeletonLayer alloc] init];
    [r3 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(r1.hd_left);
        make.width.hd_equalTo(130);
        make.bottom.hd_equalTo(r0.hd_bottom);
        make.height.hd_equalTo(15);
    }];

    HDSkeletonLayer *r3_1 = [[HDSkeletonLayer alloc] init];
    [r3_1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.right.hd_equalTo(self.hd_width).offset(-15);
        make.width.hd_equalTo(60);
        make.top.hd_equalTo(r3.hd_top);
        make.height.hd_equalTo(r3.hd_height);
    }];

    return @[c0, r0, r1, r2, r3, r3_1];
}

- (UIColor *)skeletonContainerViewBackgroundColor {
    return UIColor.whiteColor;
}

+ (CGFloat)skeletonViewHeight {
    return 100;
}
@end
