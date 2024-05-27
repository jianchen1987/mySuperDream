//
//  WMZPageView+Skeleton.m
//  SuperApp
//
//  Created by wmz on 2023/2/3.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMZPageView+Skeleton.h"


@implementation WMZPageView (Skeleton)
- (NSArray<HDSkeletonLayer *> *)skeletonLayoutViews {
    NSMutableArray *marr = NSMutableArray.new;
    HDSkeletonLayer *last = nil;
    if (true) {
        HDSkeletonLayer *r0 = [[HDSkeletonLayer alloc] init];
        [r0 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            const CGFloat w = self.hd_width - 20;
            make.width.hd_equalTo(w);
            make.centerX.hd_equalTo(self.hd_width * 0.5);
            make.top.hd_equalTo(10);
            make.height.hd_equalTo(w * (150 / 375.0));
        }];

        HDSkeletonLayer *r1 = [[HDSkeletonLayer alloc] init];
        [r1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            make.width.hd_equalTo(150);
            make.height.hd_equalTo(30);
            make.left.hd_equalTo(10);
            make.top.hd_equalTo(r0.hd_bottom + 10);
        }];

        HDSkeletonLayer *r2 = [[HDSkeletonLayer alloc] init];
        r2.animationStyle = HDSkeletonLayerAnimationStyleGradientLeftToRight;
        [r2 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            make.width.hd_equalTo(kScreenWidth * 0.15);
            make.height.hd_equalTo(20);
            make.left.hd_equalTo(r1.hd_left);
            make.top.hd_equalTo(r1.hd_bottom + 10);
        }];

        HDSkeletonLayer *r2_1 = [[HDSkeletonLayer alloc] init];
        [r2_1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            make.width.hd_equalTo(kScreenWidth * 0.2);
            make.height.hd_equalTo(r2.hd_height);
            make.left.hd_equalTo(r2.hd_right + 10);
            make.top.hd_equalTo(r2.hd_top);
        }];

        HDSkeletonLayer *r2_2 = [[HDSkeletonLayer alloc] init];
        [r2_2 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            make.width.hd_equalTo(kScreenWidth * 0.25);
            make.height.hd_equalTo(r2.hd_height);
            make.left.hd_equalTo(r2_1.hd_right + 10);
            make.top.hd_equalTo(r2.hd_top);
        }];

        HDSkeletonLayer *r3 = [[HDSkeletonLayer alloc] init];
        [r3 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            make.width.hd_equalTo(self.hd_width * 0.8);
            make.left.hd_equalTo(r1.hd_left);
            make.height.hd_equalTo(25);
            make.top.hd_equalTo(r2_1.hd_bottom + 10);
        }];

        HDSkeletonLayer *r4 = [[HDSkeletonLayer alloc] init];
        [r4 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            make.width.hd_equalTo(100);
            make.left.hd_equalTo(r3.hd_left);
            make.height.hd_equalTo(40);
            make.top.hd_equalTo(r3.hd_bottom + 25);
        }];

        HDSkeletonLayer *r4_1 = [[HDSkeletonLayer alloc] init];
        [r4_1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            make.size.hd_equalTo(CGSizeMake(10, 18));
            make.right.hd_equalTo(r0.hd_right);
            make.centerY.hd_equalTo(r4.hd_centerY);
        }];

        CGSize size = CGSizeMake(self.hd_width * 0.2, 30);
        HDSkeletonLayer *r5 = [[HDSkeletonLayer alloc] init];
        [r5 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            make.size.hd_equalTo(size);
            make.left.hd_equalTo(r4.hd_left);
            make.top.hd_equalTo(r4.hd_bottom + 25);
        }];

        HDSkeletonLayer *r5_1 = [[HDSkeletonLayer alloc] init];
        [r5_1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            make.size.hd_equalTo(size);
            make.left.hd_equalTo(r5.hd_right + 10);
            make.top.hd_equalTo(r5.hd_top);
        }];

        HDSkeletonLayer *r5_2 = [[HDSkeletonLayer alloc] init];
        [r5_2 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            make.size.hd_equalTo(size);
            make.left.hd_equalTo(r5_1.hd_right + 10);
            make.top.hd_equalTo(r5.hd_top);
        }];

        HDSkeletonLayer *r5_3 = [[HDSkeletonLayer alloc] init];
        [r5_3 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            make.size.hd_equalTo(size);
            make.left.hd_equalTo(r5_2.hd_right + 10);
            make.top.hd_equalTo(r5.hd_top);
        }];
        last = r5_3;
        [marr addObjectsFromArray:@[r0, r1, r2, r2_1, r2_2, r3, r4, r4_1, r5, r5_1, r5_2, r5_3]];
    }

    for (int i = 0; i < 10; i++) {
        if (true) {
            HDSkeletonLayer *circle = [[HDSkeletonLayer alloc] init];
            const CGFloat iconW = 60;
            [circle hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
                make.width.hd_equalTo(iconW);
                make.height.hd_equalTo(iconW);
                make.top.hd_equalTo(last.hd_bottom + 15);
                make.left.hd_equalTo(15);
            }];

            CGFloat margin = 10;
            HDSkeletonLayer *r1 = [[HDSkeletonLayer alloc] init];
            [r1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
                make.width.hd_equalTo(150);
                make.height.hd_equalTo(20);
                make.left.hd_equalTo(circle.hd_right + margin);
                make.top.hd_equalTo(circle.hd_top);
            }];

            HDSkeletonLayer *r2 = [[HDSkeletonLayer alloc] init];
            [r2 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
                make.left.hd_equalTo(r1.hd_left);
                make.right.hd_equalTo(self.hd_right - 15);
                make.bottom.hd_equalTo(circle.hd_bottom - 5);
                make.height.hd_equalTo(20);
            }];

            HDSkeletonLayer *r3 = [[HDSkeletonLayer alloc] init];
            [r3 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
                make.left.hd_equalTo(r1.hd_left);
                make.width.hd_equalTo(120);
                make.top.hd_equalTo(r2.hd_bottom + 10);
                make.height.hd_equalTo(20);
            }];

            HDSkeletonLayer *r4 = [[HDSkeletonLayer alloc] init];
            [r4 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
                make.right.hd_equalTo(self.hd_right - 15);
                make.width.hd_equalTo(60);
                make.top.hd_equalTo(r3.hd_top);
                make.height.hd_equalTo(r3.hd_height);
            }];

            last = r4;
            [marr addObjectsFromArray:@[circle, r1, r2, r3, r4]];
        }
    }
    return [NSArray arrayWithArray:marr];
}

- (UIColor *)skeletonContainerViewBackgroundColor {
    return UIColor.whiteColor;
}

@end
