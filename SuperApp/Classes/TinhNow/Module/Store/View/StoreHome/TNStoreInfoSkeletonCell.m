//
//  TNStoreInfoSkeletonCell.m
//  SuperApp
//
//  Created by 张杰 on 2021/7/27.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNStoreInfoSkeletonCell.h"
#import "HDAppTheme+TinhNow.h"


@implementation TNStoreInfoSkeletonCellModel
- (NSUInteger)cellHeight {
    return kRealWidth(110);
}
@end


@implementation TNStoreInfoSkeletonCell
- (NSArray<HDSkeletonLayer *> *)skeletonLayoutViews {
    HDSkeletonLayer *imageLayer = [[HDSkeletonLayer alloc] init];
    [imageLayer hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(self.contentView.hd_left + kRealWidth(15));
        make.top.hd_equalTo(self.contentView.hd_top + kRealWidth(15));
        make.width.hd_equalTo(kRealWidth(70));
        make.height.hd_equalTo(kRealWidth(70));
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

    HDSkeletonLayer *r4 = [[HDSkeletonLayer alloc] init];
    [r4 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.height.hd_equalTo(kRealWidth(10));
        make.left.hd_equalTo(self.contentView.hd_left);
        make.right.hd_equalTo(self.contentView.hd_right);
        make.top.hd_equalTo(imageLayer.hd_bottom + kRealWidth(15));
    }];
    r4.layerColor = HDAppTheme.TinhNowColor.G5;
    r4.animationDuration = 10;
    return @[imageLayer, r1, r2, r3, r4];
}

- (UIColor *)skeletonContainerViewBackgroundColor {
    return UIColor.whiteColor;
}
@end
