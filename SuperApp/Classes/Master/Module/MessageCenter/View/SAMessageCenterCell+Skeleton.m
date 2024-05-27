//
//  SAMessageCenterCell+Skeleton.m
//  SuperApp
//
//  Created by Tia on 2023/5/8.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAMessageCenterCell+Skeleton.h"


@implementation SAMessageCenterCellSkeletonModel

@end


@implementation SAMessageCenterCell (Skeleton)

- (NSArray<HDSkeletonLayer *> *)skeletonLayoutViews {
    CGFloat margin = 12;

    HDSkeletonLayer *circle = [[HDSkeletonLayer alloc] init];

    [circle hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(3 * margin);
        make.height.hd_equalTo(3 * margin);
        make.top.hd_equalTo(margin);
        make.left.hd_equalTo(margin);
    }];
    circle.skeletonCornerRadius = margin * 1.5;

    HDSkeletonLayer *r1 = [[HDSkeletonLayer alloc] init];
    [r1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.height.hd_equalTo(margin);
        make.left.hd_equalTo(circle.hd_right).offset(4);
        make.width.hd_equalTo(6 * margin);
        make.top.hd_equalTo(circle.hd_top);
    }];

    HDSkeletonLayer *r1_1 = [[HDSkeletonLayer alloc] init];
    [r1_1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.height.hd_equalTo(margin);
        make.right.hd_equalTo(self.hd_right).offset(-margin);
        make.top.hd_equalTo(circle.hd_top);
        make.width.hd_equalTo(3 * margin);
    }];

    HDSkeletonLayer *r2 = [[HDSkeletonLayer alloc] init];
    [r2 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(r1.hd_left);
        make.width.hd_equalTo(12 * margin);
        make.height.hd_equalTo(margin);
        make.bottom.hd_equalTo(circle.hd_bottom);
    }];

    return @[r1, r1_1, circle, r2];
}

- (UIColor *)skeletonContainerViewBackgroundColor {
    return UIColor.whiteColor;
}

+ (CGFloat)skeletonViewHeight {
    return 60;
}
@end
