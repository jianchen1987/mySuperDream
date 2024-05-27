//
//  TNMicroShopProductSkeletonCell.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNMicroShopProductSkeletonCell.h"


@implementation TNMicroShopProductSkeletonCellModel
- (NSUInteger)cellHeight {
    return kRealWidth(120);
}
@end


@implementation TNMicroShopProductSkeletonCell
- (NSArray<HDSkeletonLayer *> *)skeletonLayoutViews {
    HDSkeletonLayer *imageLayer = [[HDSkeletonLayer alloc] init];
    [imageLayer hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(self.contentView.hd_left + kRealWidth(10));
        make.top.hd_equalTo(self.contentView.hd_top + kRealWidth(10));
        make.width.hd_equalTo(kRealWidth(100));
        make.height.hd_equalTo(kRealWidth(100));
    }];

    HDSkeletonLayer *r1 = [[HDSkeletonLayer alloc] init];
    [r1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.height.hd_equalTo(kRealWidth(20));
        make.left.hd_equalTo(imageLayer.hd_right + kRealWidth(15));
        make.width.hd_equalTo(kRealWidth(200));
        make.top.hd_equalTo(imageLayer.hd_top);
    }];

    HDSkeletonLayer *r2 = [[HDSkeletonLayer alloc] init];
    [r2 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.height.hd_equalTo(kRealWidth(15));
        make.left.hd_equalTo(imageLayer.hd_right + kRealWidth(15));
        make.width.hd_equalTo(kRealWidth(100));
        make.top.hd_equalTo(r1.hd_bottom + kRealWidth(6));
    }];

    HDSkeletonLayer *r3 = [[HDSkeletonLayer alloc] init];
    [r3 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.height.hd_equalTo(kRealWidth(15));
        make.left.hd_equalTo(imageLayer.hd_right + kRealWidth(15));
        make.width.hd_equalTo(kRealWidth(100));
        make.top.hd_equalTo(r2.hd_bottom + kRealWidth(8));
    }];
    return @[imageLayer, r1, r2, r3];
}

- (UIColor *)skeletonContainerViewBackgroundColor {
    return UIColor.whiteColor;
}
@end
