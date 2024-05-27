//
//  SACouponTicketCell+Skeleton.m
//  SuperApp
//
//  Created by seeu on 2021/8/7.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACouponTicketCell+Skeleton.h"


@implementation SACouponTicketSkeletonModel

@end


@implementation SACouponTicketCell (Skeleton)
- (NSArray<HDSkeletonLayer *> *)skeletonLayoutViews {
    HDSkeletonLayer *circle = [[HDSkeletonLayer alloc] init];
    const CGFloat iconW = 65;
    [circle hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(iconW);
        make.height.hd_equalTo(iconW);
        make.top.hd_equalTo(kRealHeight(15));
        make.left.hd_equalTo(kRealWidth(8));
    }];
    circle.skeletonCornerRadius = 6.0f;

    HDSkeletonLayer *r2 = [[HDSkeletonLayer alloc] init];
    [r2 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(circle.hd_right).offset(10);
        make.width.hd_equalTo(kRealWidth(20));
        make.top.hd_equalTo(circle.hd_top).offset(3);
        make.height.hd_equalTo(12);
    }];

    HDSkeletonLayer *r4 = [[HDSkeletonLayer alloc] init];
    [r4 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.right.hd_equalTo(self.hd_right).offset(-kRealWidth(8));
        make.width.hd_equalTo(100);
        make.top.hd_equalTo(kRealHeight(15));
        make.height.hd_equalTo(120);
    }];
    r4.cornerRadius = 8.0f;

    HDSkeletonLayer *r3 = [[HDSkeletonLayer alloc] init];
    [r3 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(r2.hd_right).offset(kRealWidth(5));
        make.right.hd_equalTo(r4.hd_left).offset(-kRealWidth(5));
        make.top.hd_equalTo(circle.hd_top).offset(3);
        make.height.hd_equalTo(12);
    }];

    HDSkeletonLayer *r1 = [[HDSkeletonLayer alloc] init];
    [r1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(circle.hd_left);
        make.height.hd_equalTo(20);
        make.top.hd_equalTo(circle.hd_bottom).offset(kRealHeight(3));
        make.right.hd_equalTo(r4.hd_left).offset(-kRealWidth(5));
    }];
    HDSkeletonLayer *r1_1 = [[HDSkeletonLayer alloc] init];
    [r1_1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.height.hd_equalTo(20);
        make.top.hd_equalTo(r2.hd_bottom).offset(kRealHeight(10));
        make.left.hd_equalTo(r2.hd_left);
        make.right.hd_equalTo(r4.hd_left).offset(-kRealWidth(8));
    }];

    return @[r1, r1_1, circle, r2, r3, r4];
}

- (UIColor *)skeletonContainerViewBackgroundColor {
    return UIColor.whiteColor;
}

+ (CGFloat)skeletonViewHeight {
    return 120;
}
@end
