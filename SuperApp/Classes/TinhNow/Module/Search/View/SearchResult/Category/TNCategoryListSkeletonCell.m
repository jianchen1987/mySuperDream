//
//  TNCategoryListSkeletonCell.m
//  SuperApp
//
//  Created by 张杰 on 2021/7/27.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNCategoryListSkeletonCell.h"


@implementation TNCategoryListSkeletonCellModel
- (NSUInteger)cellHeight {
    return kRealWidth(100);
}
@end


@implementation TNCategoryListSkeletonCell
- (NSArray<HDSkeletonLayer *> *)skeletonLayoutViews {
    NSMutableArray *arr = [NSMutableArray array];
    HDSkeletonLayer *lastLayer = nil;
    for (int i = 0; i < 5; i++) {
        HDSkeletonLayer *imageLayer = [[HDSkeletonLayer alloc] init];
        [imageLayer hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            if (lastLayer == nil) {
                make.left.hd_equalTo(self.contentView.hd_left + kRealWidth(15));
            } else {
                make.left.hd_equalTo(lastLayer.hd_right + kRealWidth(15));
            }

            make.top.hd_equalTo(self.contentView.hd_top + kRealWidth(15));
            make.width.hd_equalTo(kRealWidth(50));
            make.height.hd_equalTo(kRealWidth(50));
        }];

        HDSkeletonLayer *r1 = [[HDSkeletonLayer alloc] init];
        [r1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            make.height.hd_equalTo(kRealWidth(15));
            make.centerX.hd_equalTo(imageLayer.hd_centerX);
            make.width.hd_equalTo(kRealWidth(50));
            make.top.hd_equalTo(imageLayer.hd_bottom + kRealWidth(5));
        }];
        [arr addObject:imageLayer];
        [arr addObject:r1];

        lastLayer = imageLayer;
    }

    return arr;
}

- (UIColor *)skeletonContainerViewBackgroundColor {
    return UIColor.whiteColor;
}
@end
