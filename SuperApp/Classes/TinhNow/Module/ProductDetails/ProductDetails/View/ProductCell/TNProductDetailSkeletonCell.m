//
//  TNProductDetailSkeletonCell.m
//  SuperApp
//
//  Created by 张杰 on 2022/2/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNProductDetailSkeletonCell.h"


@implementation TNProductDetailSkeletonCell
- (NSArray<HDSkeletonLayer *> *)skeletonLayoutViews {
    HDSkeletonLayer *r1 = [[HDSkeletonLayer alloc] init];
    [r1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.height.hd_equalTo(30);
        make.left.hd_equalTo(15);
        make.right.hd_equalTo(self.hd_right).offset(-15);
        make.top.hd_equalTo(15);
    }];

    HDSkeletonLayer *r2 = [[HDSkeletonLayer alloc] init];
    [r2 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.height.hd_equalTo(30);
        make.left.hd_equalTo(15);
        make.right.hd_equalTo(self.hd_right).offset(-15);
        make.top.hd_equalTo(r1.hd_bottom + 15);
    }];

    return @[r1, r2];
}

- (UIColor *)skeletonContainerViewBackgroundColor {
    return UIColor.whiteColor;
}
+ (CGFloat)skeletonViewHeight {
    return 105.0f;
}

@end


@implementation TNProductDetailSkeletonImageCell
- (NSArray<HDSkeletonLayer *> *)skeletonLayoutViews {
    HDSkeletonLayer *r1 = [[HDSkeletonLayer alloc] init];
    [r1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.height.hd_equalTo(kScreenWidth);
        make.left.hd_equalTo(0);
        make.right.hd_equalTo(self.hd_right).offset(-0);
        make.top.hd_equalTo(0);
    }];

    return @[r1];
}

- (UIColor *)skeletonContainerViewBackgroundColor {
    return UIColor.whiteColor;
}
+ (CGFloat)skeletonViewHeight {
    return kScreenWidth;
}

@end


@implementation TNProductDetailSkeletonInfoCell
- (NSArray<HDSkeletonLayer *> *)skeletonLayoutViews {
    HDSkeletonLayer *r1 = [[HDSkeletonLayer alloc] init];
    [r1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.height.hd_equalTo(30);
        make.left.hd_equalTo(15);
        make.width.hd_equalTo(200);
        make.top.hd_equalTo(15);
    }];

    HDSkeletonLayer *r2 = [[HDSkeletonLayer alloc] init];
    [r2 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.height.hd_equalTo(30);
        make.right.hd_equalTo(self.hd_right).offset(-15);
        make.width.hd_equalTo(30);
        make.centerY.hd_equalTo(r1.hd_centerY);
    }];

    HDSkeletonLayer *r3 = [[HDSkeletonLayer alloc] init];
    [r3 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.height.hd_equalTo(20);
        make.left.hd_equalTo(15);
        make.width.hd_equalTo(100);
        make.top.hd_equalTo(r1.hd_bottom + 10);
    }];

    HDSkeletonLayer *r4 = [[HDSkeletonLayer alloc] init];
    [r4 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.height.hd_equalTo(20);
        make.right.hd_equalTo(self.hd_right).offset(-15);
        make.width.hd_equalTo(80);
        make.top.hd_equalTo(r1.hd_bottom + 10);
    }];

    HDSkeletonLayer *r5 = [[HDSkeletonLayer alloc] init];
    [r5 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.height.hd_equalTo(30);
        make.right.hd_equalTo(self.hd_right).offset(-15);
        make.left.hd_equalTo(15);
        make.top.hd_equalTo(r3.hd_bottom + 10);
    }];

    HDSkeletonLayer *r6 = [[HDSkeletonLayer alloc] init];
    [r6 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.height.hd_equalTo(50);
        make.right.hd_equalTo(self.hd_right).offset(-120);
        make.left.hd_equalTo(15);
        make.top.hd_equalTo(r5.hd_bottom + 10);
    }];

    return @[r1, r2, r3, r4, r5, r6];
}

- (UIColor *)skeletonContainerViewBackgroundColor {
    return UIColor.whiteColor;
}
+ (CGFloat)skeletonViewHeight {
    return 190.0f;
}

@end
