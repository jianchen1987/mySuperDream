//
//  SAMessageTableViewCell+Skeleton.m
//  SuperApp
//
//  Created by seeu on 2021/3/4.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAMessageTableViewCell+Skeleton.h"


@implementation SAMessageTableViewCell (Skeleton)
#pragma mark - HDSkeletonLayerLayoutProtocol
- (NSArray<HDSkeletonLayer *> *)skeletonLayoutViews {
    HDSkeletonLayer *circle = [[HDSkeletonLayer alloc] init];
    const CGFloat iconW = 60;
    [circle hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(iconW);
        make.height.hd_equalTo(iconW);
        make.top.hd_equalTo(kRealWidth(18));
        make.left.hd_equalTo(kRealWidth(15));
        make.bottom.hd_equalTo(-kRealWidth(18));
    }];
    circle.skeletonCornerRadius = iconW * 0.5;

    HDSkeletonLayer *r2 = [[HDSkeletonLayer alloc] init];
    [r2 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(circle.hd_right).offset(10);
        make.width.hd_equalTo(kScreenWidth * 0.3);
        make.top.hd_equalTo(circle.hd_top).offset(0);
        make.height.hd_equalTo(15);
    }];

    HDSkeletonLayer *r3 = [[HDSkeletonLayer alloc] init];
    [r3 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(r2.hd_left);
        make.width.hd_equalTo(kScreenWidth * 0.5);
        make.top.hd_equalTo(r2.hd_bottom + 10);
        make.height.hd_equalTo(15);
    }];

    return @[circle, r2, r3];
}

- (UIColor *)skeletonContainerViewBackgroundColor {
    return UIColor.whiteColor;
}

+ (CGFloat)skeletonViewHeight {
    return 50;
}
@end
