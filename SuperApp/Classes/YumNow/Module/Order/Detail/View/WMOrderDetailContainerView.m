//
//  WMOrderDetailContainerView.m
//  SuperApp
//
//  Created by VanJay on 2020/5/30.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMOrderDetailContainerView.h"


@implementation WMOrderDetailContainerView

#pragma mark - HDSkeletonLayerLayoutProtocol
- (NSArray<HDSkeletonLayer *> *)skeletonLayoutViews {
    HDSkeletonLayer *r0 = [[HDSkeletonLayer alloc] init];
    [r0 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(kScreenWidth * 0.3);
        make.left.hd_equalTo(HDAppTheme.value.padding.left);
        make.top.hd_equalTo(HDAppTheme.value.padding.top);
        make.height.hd_equalTo(20);
    }];

    HDSkeletonLayer *r0_1 = [[HDSkeletonLayer alloc] init];
    [r0_1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(10);
        make.right.hd_equalTo(self.hd_width - HDAppTheme.value.padding.right);
        make.centerY.hd_equalTo(r0.hd_centerY);
        make.height.hd_equalTo(8);
    }];
    r0_1.cornerRadius = 2;

    HDSkeletonLayer *r1 = [[HDSkeletonLayer alloc] init];
    [r1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(kScreenWidth * 0.6);
        make.left.hd_equalTo(r0.hd_left);
        make.top.hd_equalTo(r0.hd_bottom + 10);
        make.height.hd_equalTo(18);
    }];

    HDSkeletonLayer *r2 = [[HDSkeletonLayer alloc] init];
    r2.animationStyle = HDSkeletonLayerAnimationStyleGradientLeftToRight;
    [r2 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(80);
        make.height.hd_equalTo(30);
        make.left.hd_equalTo(r1.hd_left);
        make.top.hd_equalTo(r1.hd_bottom + 15);
    }];

    HDSkeletonLayer *r2_1 = [[HDSkeletonLayer alloc] init];
    [r2_1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(80);
        make.height.hd_equalTo(r2.hd_height);
        make.left.hd_equalTo(r2.hd_right + 20);
        make.top.hd_equalTo(r2.hd_top);
    }];

    HDSkeletonLayer *r3 = [[HDSkeletonLayer alloc] init];
    [r3 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(self.hd_width * 0.6);
        make.left.hd_equalTo(r1.hd_left);
        make.height.hd_equalTo(25);
        make.top.hd_equalTo(r2_1.hd_bottom + 20);
    }];

    HDSkeletonLayer *r4 = [[HDSkeletonLayer alloc] init];
    [r4 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(80);
        make.left.hd_equalTo(r3.hd_left);
        make.height.hd_equalTo(80);
        make.top.hd_equalTo(r3.hd_bottom + 12);
    }];

    HDSkeletonLayer *r4_1 = [[HDSkeletonLayer alloc] init];
    [r4_1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.size.hd_equalTo(CGSizeMake(60, 15));
        make.left.hd_equalTo(r4.hd_right + 10);
        make.top.hd_equalTo(r4.hd_top);
    }];

    HDSkeletonLayer *r4_1_1 = [[HDSkeletonLayer alloc] init];
    [r4_1_1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.size.hd_equalTo(CGSizeMake(20, 10));
        make.right.hd_equalTo(r0_1.hd_right);
        make.centerY.hd_equalTo(r4_1.hd_centerY);
    }];
    r4_1_1.cornerRadius = 2;

    HDSkeletonLayer *r4_2 = [[HDSkeletonLayer alloc] init];
    [r4_2 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.size.hd_equalTo(CGSizeMake(100, 15));
        make.left.hd_equalTo(r4.hd_right + 10);
        make.top.hd_equalTo(r4_1.hd_bottom + 5);
    }];

    HDSkeletonLayer *r4_3 = [[HDSkeletonLayer alloc] init];
    [r4_3 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.size.hd_equalTo(CGSizeMake(50, 15));
        make.left.hd_equalTo(r4.hd_right + 10);
        make.bottom.hd_equalTo(r4.hd_bottom);
    }];

    HDSkeletonLayer *r5 = [[HDSkeletonLayer alloc] init];
    [r5 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(80);
        make.left.hd_equalTo(r3.hd_left);
        make.height.hd_equalTo(80);
        make.top.hd_equalTo(r4.hd_bottom + 30);
    }];

    HDSkeletonLayer *r5_1 = [[HDSkeletonLayer alloc] init];
    [r5_1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.size.hd_equalTo(CGSizeMake(60, 15));
        make.left.hd_equalTo(r5.hd_right + 10);
        make.top.hd_equalTo(r5.hd_top);
    }];

    HDSkeletonLayer *r5_1_1 = [[HDSkeletonLayer alloc] init];
    [r5_1_1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.size.hd_equalTo(CGSizeMake(20, 10));
        make.right.hd_equalTo(r0_1.hd_right);
        make.centerY.hd_equalTo(r5_1.hd_centerY);
    }];
    r5_1_1.cornerRadius = 2;

    HDSkeletonLayer *r5_2 = [[HDSkeletonLayer alloc] init];
    [r5_2 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.size.hd_equalTo(CGSizeMake(100, 15));
        make.left.hd_equalTo(r5.hd_right + 10);
        make.top.hd_equalTo(r5_1.hd_bottom + 5);
    }];

    HDSkeletonLayer *r5_3 = [[HDSkeletonLayer alloc] init];
    [r5_3 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.size.hd_equalTo(CGSizeMake(50, 15));
        make.left.hd_equalTo(r5.hd_right + 10);
        make.bottom.hd_equalTo(r5.hd_bottom);
    }];

    HDSkeletonLayer *r9 = [[HDSkeletonLayer alloc] init];
    [r9 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(80);
        make.left.hd_equalTo(r3.hd_left);
        make.height.hd_equalTo(80);
        make.top.hd_equalTo(r5.hd_bottom + 30);
    }];

    HDSkeletonLayer *r9_1 = [[HDSkeletonLayer alloc] init];
    [r9_1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.size.hd_equalTo(CGSizeMake(60, 15));
        make.left.hd_equalTo(r9.hd_right + 10);
        make.top.hd_equalTo(r9.hd_top);
    }];

    HDSkeletonLayer *r9_1_1 = [[HDSkeletonLayer alloc] init];
    [r9_1_1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.size.hd_equalTo(CGSizeMake(20, 10));
        make.right.hd_equalTo(r0_1.hd_right);
        make.centerY.hd_equalTo(r9_1.hd_centerY);
    }];
    r9_1_1.cornerRadius = 2;

    HDSkeletonLayer *r9_2 = [[HDSkeletonLayer alloc] init];
    [r9_2 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.size.hd_equalTo(CGSizeMake(100, 15));
        make.left.hd_equalTo(r9.hd_right + 10);
        make.top.hd_equalTo(r9_1.hd_bottom + 5);
    }];

    HDSkeletonLayer *r9_3 = [[HDSkeletonLayer alloc] init];
    [r9_3 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.size.hd_equalTo(CGSizeMake(50, 15));
        make.left.hd_equalTo(r9.hd_right + 10);
        make.bottom.hd_equalTo(r9.hd_bottom);
    }];

    HDSkeletonLayer *r6 = [[HDSkeletonLayer alloc] init];
    [r6 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(80);
        make.height.hd_equalTo(20);
        make.left.hd_equalTo(r9.hd_left);
        make.top.hd_equalTo(r9.hd_bottom + 30);
    }];

    HDSkeletonLayer *r6_1 = [[HDSkeletonLayer alloc] init];
    [r6_1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(80);
        make.height.hd_equalTo(20);
        make.right.hd_equalTo(r0_1.hd_right);
        make.centerY.hd_equalTo(r6.hd_centerY);
    }];

    HDSkeletonLayer *r7 = [[HDSkeletonLayer alloc] init];
    [r7 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(80);
        make.height.hd_equalTo(20);
        make.left.hd_equalTo(r5.hd_left);
        make.top.hd_equalTo(r6.hd_bottom + 25);
    }];

    HDSkeletonLayer *r7_1 = [[HDSkeletonLayer alloc] init];
    [r7_1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(80);
        make.height.hd_equalTo(20);
        make.right.hd_equalTo(r0_1.hd_right);
        make.centerY.hd_equalTo(r7.hd_centerY);
    }];

    HDSkeletonLayer *r8 = [[HDSkeletonLayer alloc] init];
    [r8 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(80);
        make.height.hd_equalTo(20);
        make.left.hd_equalTo(r5.hd_left);
        make.top.hd_equalTo(r7.hd_bottom + 25);
    }];

    HDSkeletonLayer *r8_1 = [[HDSkeletonLayer alloc] init];
    [r8_1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(80);
        make.height.hd_equalTo(20);
        make.right.hd_equalTo(r0_1.hd_right);
        make.centerY.hd_equalTo(r8.hd_centerY);
    }];

    return @[r0, r0_1, r1, r2, r2_1, r3, r4, r4_1, r4_1_1, r4_2, r4_3, r5, r5_1, r5_1_1, r5_2, r5_3, r6, r6_1, r7, r7_1, r8, r8_1, r9, r9_1, r9_1_1, r9_2, r9_3];
}

- (UIColor *)skeletonContainerViewBackgroundColor {
    return UIColor.whiteColor;
}

+ (CGFloat)skeletonViewHeight {
    return 235 + 20 + (kScreenWidth - 2 * 10) * (150 / 375.0);
}
@end
