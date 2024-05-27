//
//  SAMessageCenterListTableViewCell+Skeleton.m
//  SuperApp
//
//  Created by seeu on 2021/8/8.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAMessageCenterListTableViewCell+Skeleton.h"


@implementation SAMessageCenterListCellSkeletonModel

@end


@implementation SAMessageCenterListTableViewCell (Skeleton)
- (NSArray<HDSkeletonLayer *> *)skeletonLayoutViews {
    HDSkeletonLayer *circle = [[HDSkeletonLayer alloc] init];
    const CGFloat iconW = 30;
    [circle hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(iconW);
        make.height.hd_equalTo(iconW);
        make.top.hd_equalTo(17);
        make.left.hd_equalTo(13);
    }];
    circle.skeletonCornerRadius = iconW * 0.5;

    HDSkeletonLayer *r1 = [[HDSkeletonLayer alloc] init];
    [r1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.height.hd_equalTo(15);
        make.right.hd_equalTo(self.hd_right).offset(-13);
        make.width.hd_equalTo(40);
        make.top.hd_equalTo(circle.hd_top);
    }];
    HDSkeletonLayer *r1_1 = [[HDSkeletonLayer alloc] init];
    [r1_1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.height.hd_equalTo(20);
        make.right.hd_equalTo(r1.hd_left).offset(-10);
        make.top.hd_equalTo(circle.hd_top);
        make.left.hd_equalTo(circle.hd_right).offset(8);
    }];

    HDSkeletonLayer *r2 = [[HDSkeletonLayer alloc] init];
    [r2 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(circle.hd_left);
        make.right.hd_equalTo(r1.hd_right);
        make.top.hd_equalTo(circle.hd_bottom).offset(10);
        make.height.hd_equalTo(18);
    }];

    HDSkeletonLayer *r3 = [[HDSkeletonLayer alloc] init];
    [r3 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(circle.hd_left);
        make.top.hd_equalTo(r2.hd_bottom).offset(5);
        make.height.hd_equalTo(18);
        make.width.hd_equalTo(kScreenWidth * 0.3);
    }];

    HDSkeletonLayer *r4 = [[HDSkeletonLayer alloc] init];
    [r4 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(circle.hd_left);
        make.top.hd_equalTo(r3.hd_bottom).offset(10);
        make.height.hd_equalTo(18);
        make.width.hd_equalTo(50);
    }];
    r4.cornerRadius = 13;

    return @[r1, r1_1, circle, r2, r3, r4];
}

- (UIColor *)skeletonContainerViewBackgroundColor {
    return UIColor.whiteColor;
}

+ (CGFloat)skeletonViewHeight {
    return 150;
}
@end
