//
//  WMStoreSearchResultTableViewCell+Skeleton.m
//  SuperApp
//
//  Created by VanJay on 2020/5/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreSearchResultTableViewCell+Skeleton.h"


@implementation WMStoreSearchResultTableViewCell (Skeleton)

#pragma mark - HDSkeletonLayerLayoutProtocol
- (NSArray<HDSkeletonLayer *> *)skeletonLayoutViews {
    HDSkeletonLayer *circle = [[HDSkeletonLayer alloc] init];
    const CGFloat iconW = 60;
    [circle hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(iconW);
        make.height.hd_equalTo(iconW);
        make.top.hd_equalTo(15);
        make.left.hd_equalTo(15);
    }];
    circle.skeletonCornerRadius = iconW * 0.5;

    CGFloat margin = 10;
    HDSkeletonLayer *r1 = [[HDSkeletonLayer alloc] init];
    [r1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(100);
        make.height.hd_equalTo(20);
        make.left.hd_equalTo(circle.hd_right + margin);
        make.top.hd_equalTo(circle.hd_top + 5);
    }];

    HDSkeletonLayer *r2 = [[HDSkeletonLayer alloc] init];
    [r2 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(r1.hd_left);
        make.width.hd_equalTo(kScreenWidth * 0.7);
        make.bottom.hd_equalTo(circle.hd_bottom - 5);
        make.height.hd_equalTo(20);
    }];

    HDSkeletonLayer *r3 = [[HDSkeletonLayer alloc] init];
    [r3 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(r1.hd_left);
        make.width.hd_equalTo(150);
        make.top.hd_equalTo(r2.hd_bottom + 10);
        make.height.hd_equalTo(20);
    }];

    return @[circle, r1, r2, r3];
}

- (UIColor *)skeletonContainerViewBackgroundColor {
    return UIColor.whiteColor;
}

+ (CGFloat)skeletonViewHeight {
    return 120;
}
@end
