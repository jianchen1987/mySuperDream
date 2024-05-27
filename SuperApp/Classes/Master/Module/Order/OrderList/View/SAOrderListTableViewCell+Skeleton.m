//
//  SAOrderListTableViewCell+Skeleton.m
//  SuperApp
//
//  Created by VanJay on 2020/5/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAOrderListTableViewCell+Skeleton.h"


@implementation SAOrderListTableViewCell (Skeleton)
#pragma mark - HDSkeletonLayerLayoutProtocol
- (NSArray<HDSkeletonLayer *> *)skeletonLayoutViews {
    HDSkeletonLayer *r1 = [[HDSkeletonLayer alloc] init];
    [r1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(kScreenWidth * 0.5);
        make.height.hd_equalTo(20);
        make.left.hd_equalTo(15);
        make.top.hd_equalTo(15);
    }];
    HDSkeletonLayer *r1_1 = [[HDSkeletonLayer alloc] init];
    [r1_1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(40);
        make.height.hd_equalTo(r1.hd_height);
        make.right.hd_equalTo(self.hd_width).offset(-15);
        make.top.hd_equalTo(r1.hd_top);
    }];

    HDSkeletonLayer *circle = [[HDSkeletonLayer alloc] init];
    const CGFloat iconW = 60;
    [circle hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(iconW);
        make.height.hd_equalTo(iconW);
        make.top.hd_equalTo(r1.hd_bottom).offset(20);
        make.left.hd_equalTo(r1.hd_left);
    }];
    circle.skeletonCornerRadius = iconW * 0.5;

    HDSkeletonLayer *r2 = [[HDSkeletonLayer alloc] init];
    [r2 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(circle.hd_right).offset(10);
        make.width.hd_equalTo(kScreenWidth * 0.4);
        make.top.hd_equalTo(circle.hd_top).offset(3);
        make.height.hd_equalTo(15);
    }];

    HDSkeletonLayer *r3 = [[HDSkeletonLayer alloc] init];
    [r3 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(r2.hd_left);
        make.width.hd_equalTo(kScreenWidth * 0.3);
        make.top.hd_equalTo(r2.hd_bottom + 10);
        make.height.hd_equalTo(15);
    }];

    HDSkeletonLayer *r4 = [[HDSkeletonLayer alloc] init];
    [r4 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.right.hd_equalTo(self.hd_width).offset(-15);
        make.width.hd_equalTo(80);
        make.top.hd_equalTo(circle.hd_bottom).offset(15);
        make.height.hd_equalTo(26);
    }];
    r4.cornerRadius = 13;

    return @[r1, r1_1, circle, r2, r3, r4];
}

- (UIColor *)skeletonContainerViewBackgroundColor {
    return UIColor.whiteColor;
}

+ (CGFloat)skeletonViewHeight {
    return 171;
}
@end
