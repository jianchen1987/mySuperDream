//
//  TNBargainRecordCell+Skeleton.m
//  SuperApp
//
//  Created by 张杰 on 2020/12/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNBargainRecordCell+Skeleton.h"


@implementation TNBargainRecordCell (Skeleton)
- (NSArray<HDSkeletonLayer *> *)skeletonLayoutViews {
    HDSkeletonLayer *imageLayer = [[HDSkeletonLayer alloc] init];
    CGFloat width = kRealWidth(105);
    [imageLayer hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(width);
        make.height.hd_equalTo(width);
        make.top.hd_equalTo(15);
        make.left.hd_equalTo(23);
    }];

    HDSkeletonLayer *r1 = [[HDSkeletonLayer alloc] init];
    [r1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(150);
        make.height.hd_equalTo(20);
        make.top.hd_equalTo(imageLayer.hd_top);
        make.left.hd_equalTo(imageLayer.hd_right + 17);
    }];

    HDSkeletonLayer *r2 = [[HDSkeletonLayer alloc] init];
    [r2 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(150);
        make.height.hd_equalTo(20);
        make.top.hd_equalTo(r1.hd_bottom + 10);
        make.left.hd_equalTo(imageLayer.hd_right + 17);
    }];

    HDSkeletonLayer *r3 = [[HDSkeletonLayer alloc] init];
    [r3 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(80);
        make.height.hd_equalTo(17);
        make.top.hd_equalTo(imageLayer.hd_bottom - 17);
        make.left.hd_equalTo(imageLayer.hd_right + 17);
    }];

    HDSkeletonLayer *r4 = [[HDSkeletonLayer alloc] init];
    [r4 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.width.hd_equalTo(60);
        make.height.hd_equalTo(17);
        make.top.hd_equalTo(r3.hd_top);
        make.right.hd_equalTo(self.hd_right - 23 - 60);
    }];
    return @[imageLayer, r1, r2, r3, r4];
}
- (UIColor *)skeletonContainerViewBackgroundColor {
    return [UIColor whiteColor];
}
+ (CGFloat)skeletonViewHeight {
    return kRealWidth(135);
}
@end
