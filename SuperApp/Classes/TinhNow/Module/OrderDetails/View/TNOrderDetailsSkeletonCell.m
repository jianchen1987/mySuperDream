//
//  TNOrderDetailsSkeletonCell.m
//  SuperApp
//
//  Created by xixi on 2020/12/25.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNOrderDetailsSkeletonCell.h"


@implementation TNOrderDetailsSkeletonCellModel

@end


@implementation TNOrderDetailsSkeletonCell

- (NSArray<HDSkeletonLayer *> *)skeletonLayoutViews {
    HDSkeletonLayer *r1 = [[HDSkeletonLayer alloc] init];
    [r1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(15.f);
        make.top.hd_equalTo(15.f);
        make.width.hd_equalTo(100);
        make.height.hd_equalTo(24.f);
    }];

    HDSkeletonLayer *r2 = [[HDSkeletonLayer alloc] init];
    [r2 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(15.f);
        make.top.hd_equalTo(r1.hd_bottom).offset(10.f);
        make.width.hd_equalTo(kScreenWidth - 30.f);
        make.height.hd_equalTo(24.f);
    }];

    HDSkeletonLayer *r3 = [[HDSkeletonLayer alloc] init];
    [r3 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(47.f);
        make.top.hd_equalTo(r2.hd_bottom).offset(30.f);
        make.width.hd_equalTo(150.f);
        make.height.hd_equalTo(21.f);
    }];

    HDSkeletonLayer *r4 = [[HDSkeletonLayer alloc] init];
    [r4 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(47.f);
        make.top.hd_equalTo(r3.hd_bottom).offset(4.f);
        make.right.hd_equalTo(kScreenWidth - 24.f);
        make.height.hd_equalTo(39.f);
    }];

    HDSkeletonLayer *r5 = [[HDSkeletonLayer alloc] init];
    [r5 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(14.f);
        make.top.hd_equalTo(r4.hd_bottom).offset(41.f);
        make.right.hd_equalTo(self.hd_right).offset(-14.f);
        make.height.hd_equalTo(21.f);
    }];

    HDSkeletonLayer *r6 = [[HDSkeletonLayer alloc] init];
    [r6 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(15.f);
        make.top.hd_equalTo(r5.hd_bottom).offset(30.f);
        make.width.hd_equalTo(80.f);
        make.height.hd_equalTo(80.f);
    }];

    HDSkeletonLayer *r7 = [[HDSkeletonLayer alloc] init];
    [r7 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(r6.hd_right).offset(10.f);
        make.top.hd_equalTo(r6.hd_top);
        make.height.hd_equalTo(18.f);
        make.right.hd_equalTo(self.hd_right).offset(-14.f);
    }];

    HDSkeletonLayer *r8 = [[HDSkeletonLayer alloc] init];
    [r8 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(r7.hd_left);
        make.top.hd_equalTo(r7.hd_bottom).offset(5.f);
        make.height.hd_equalTo(17.f);
        make.right.hd_equalTo(self.hd_right).offset(-34.f);
    }];

    HDSkeletonLayer *r9 = [[HDSkeletonLayer alloc] init];
    [r9 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.top.hd_equalTo(r6.hd_bottom).offset(33.f);
        make.height.hd_equalTo(21.f);
        make.right.hd_equalTo(self.hd_right).offset(-15.f);
        make.width.hd_equalTo(150.f);
    }];

    HDSkeletonLayer *r10 = [[HDSkeletonLayer alloc] init];
    [r10 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.top.hd_equalTo(r9.hd_bottom).offset(5.f);
        make.height.hd_equalTo(21.f);
        make.right.hd_equalTo(r9.hd_right);
        make.width.hd_equalTo(270.f);
    }];

    NSMutableArray *listArray = [NSMutableArray array];
    CGFloat beginTop = r10.hd_bottom + 40.f;
    for (int i = 0; i < 7; i++) {
        HDSkeletonLayer *r11 = [[HDSkeletonLayer alloc] init];
        [r11 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            make.left.hd_equalTo(15.f);
            make.top.hd_equalTo(beginTop);
            make.height.hd_equalTo(21.f);
            make.width.hd_equalTo(60.f);
        }];

        HDSkeletonLayer *r12 = [[HDSkeletonLayer alloc] init];
        [r12 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            make.left.hd_equalTo(r11.hd_right).offset(30.f);
            make.top.hd_equalTo(r11.hd_top);
            make.height.hd_equalTo(21.f);
            make.right.hd_equalTo(self.hd_right).offset(-15.f);
        }];

        beginTop = r12.hd_bottom + 20.f;
        [listArray addObject:r11];
        [listArray addObject:r12];
    }

    NSMutableArray *topList = [NSMutableArray arrayWithObjects:r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, nil];
    [topList addObjectsFromArray:listArray];
    return topList;
}
/**
 骨架占位的背景颜色
 */
- (UIColor *)skeletonContainerViewBackgroundColor {
    return UIColor.whiteColor;
}

@end
