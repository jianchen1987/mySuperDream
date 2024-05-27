//
//  TNOrderSubmitSkeletonTableViewCell.m
//  SuperApp
//
//  Created by seeu on 2020/7/5.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNOrderSubmitSkeletonTableViewCell.h"


@implementation TNOrderSubmitSkeletonTableViewCell

- (NSArray<HDSkeletonLayer *> *)skeletonLayoutViews {
    HDSkeletonLayer *r1 = [[HDSkeletonLayer alloc] init];
    [r1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.height.hd_equalTo(30);
        make.left.hd_equalTo(15);
        make.width.hd_equalTo(30);
        make.top.hd_equalTo(15);
    }];

    HDSkeletonLayer *r2 = [[HDSkeletonLayer alloc] init];
    [r2 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.height.hd_equalTo(30);
        make.left.hd_equalTo(r1.hd_right + 10);
        make.width.hd_equalTo(kScreenWidth * 0.8);
        make.top.hd_equalTo(15);
    }];

    HDSkeletonLayer *r3 = [[HDSkeletonLayer alloc] init];
    [r3 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(15);
        make.width.hd_equalTo(kScreenWidth * 0.6);
        make.top.hd_equalTo(r1.hd_bottom + 15);
        make.height.hd_equalTo(20);
        make.bottom.hd_equalTo(-15);
    }];

    return @[r1, r2, r3];
}

- (UIColor *)skeletonContainerViewBackgroundColor {
    return UIColor.whiteColor;
}
+ (CGFloat)skeletonViewHeight {
    return 80.0f;
}

@end


@implementation TNOrderSubmitSkeletonPayMentCell

- (NSArray<HDSkeletonLayer *> *)skeletonLayoutViews {
    HDSkeletonLayer *r1 = [[HDSkeletonLayer alloc] init];
    [r1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.height.hd_equalTo(30);
        make.left.hd_equalTo(15);
        make.width.hd_equalTo(30);
        make.top.hd_equalTo(30);
    }];

    HDSkeletonLayer *r2 = [[HDSkeletonLayer alloc] init];
    [r2 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.height.hd_equalTo(30);
        make.left.hd_equalTo(r1.hd_right + 10);
        make.width.hd_equalTo(kScreenWidth * 0.8);
        make.top.hd_equalTo(30);
    }];

    HDSkeletonLayer *r3 = [[HDSkeletonLayer alloc] init];
    [r3 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.height.hd_equalTo(20);
        make.left.hd_equalTo(r2.hd_left);
        make.width.hd_equalTo(200);
        make.top.hd_equalTo(r2.hd_bottom + 20);
    }];

    HDSkeletonLayer *r4 = [[HDSkeletonLayer alloc] init];
    [r4 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.height.hd_equalTo(20);
        make.right.hd_equalTo(-15);
        make.width.hd_equalTo(20);
        make.top.hd_equalTo(r2.hd_bottom + 20);
    }];
    r4.cornerRadius = 10;

    HDSkeletonLayer *r5 = [[HDSkeletonLayer alloc] init];
    [r5 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.height.hd_equalTo(20);
        make.left.hd_equalTo(r2.hd_left);
        make.width.hd_equalTo(200);
        make.top.hd_equalTo(r3.hd_bottom + 20);
    }];

    HDSkeletonLayer *r6 = [[HDSkeletonLayer alloc] init];
    [r6 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.height.hd_equalTo(20);
        make.right.hd_equalTo(-15);
        make.width.hd_equalTo(20);
        make.top.hd_equalTo(r3.hd_bottom + 20);
    }];
    r6.cornerRadius = 10;

    return @[r1, r2, r3, r4, r5, r6];
}

- (UIColor *)skeletonContainerViewBackgroundColor {
    return UIColor.whiteColor;
}
+ (CGFloat)skeletonViewHeight {
    return 155.0f;
}

@end


@implementation TNOrderSubmitSkeletonGoodsCell

- (NSArray<HDSkeletonLayer *> *)skeletonLayoutViews {
    HDSkeletonLayer *r1 = [[HDSkeletonLayer alloc] init];
    [r1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.height.hd_equalTo(30);
        make.left.hd_equalTo(15);
        make.width.hd_equalTo(30);
        make.top.hd_equalTo(30);
    }];

    HDSkeletonLayer *r2 = [[HDSkeletonLayer alloc] init];
    [r2 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.height.hd_equalTo(30);
        make.left.hd_equalTo(r1.hd_right + 10);
        make.width.hd_equalTo(kScreenWidth * 0.8);
        make.top.hd_equalTo(30);
    }];

    HDSkeletonLayer *r3 = [[HDSkeletonLayer alloc] init];
    [r3 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.height.hd_equalTo(80);
        make.left.hd_equalTo(15);
        make.width.hd_equalTo(80);
        make.top.hd_equalTo(r2.hd_bottom + 20);
    }];
    r3.cornerRadius = 8;

    HDSkeletonLayer *r4 = [[HDSkeletonLayer alloc] init];
    [r4 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.height.hd_equalTo(20);
        make.left.hd_equalTo(r3.hd_right + 10);
        make.width.hd_equalTo(200);
        make.top.hd_equalTo(r2.hd_bottom + 20);
    }];

    HDSkeletonLayer *r5 = [[HDSkeletonLayer alloc] init];
    [r5 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.height.hd_equalTo(20);
        make.left.hd_equalTo(r3.hd_right + 10);
        make.width.hd_equalTo(100);
        make.bottom.hd_equalTo(r3.hd_bottom);
    }];

    HDSkeletonLayer *r6 = [[HDSkeletonLayer alloc] init];
    [r6 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.height.hd_equalTo(20);
        make.left.hd_equalTo(15);
        make.width.hd_equalTo(kScreenWidth * 0.9);
        make.top.hd_equalTo(r3.hd_bottom + 20);
    }];

    HDSkeletonLayer *r7 = [[HDSkeletonLayer alloc] init];
    [r7 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.height.hd_equalTo(20);
        make.left.hd_equalTo(15);
        make.width.hd_equalTo(kScreenWidth * 0.9);
        make.top.hd_equalTo(r6.hd_bottom + 15);
    }];

    return @[r1, r2, r3, r4, r5, r6, r7];
}

- (UIColor *)skeletonContainerViewBackgroundColor {
    return UIColor.whiteColor;
}
+ (CGFloat)skeletonViewHeight {
    return 250.0f;
}

@end
