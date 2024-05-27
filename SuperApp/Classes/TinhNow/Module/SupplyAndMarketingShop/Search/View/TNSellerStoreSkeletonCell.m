//
//  TNSellerStoreSkeletonCell.m
//  SuperApp
//
//  Created by 张杰 on 2021/12/22.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNSellerStoreSkeletonCell.h"


@implementation TNSellerStoreSkeletonCellModel

- (NSUInteger)cellHeight {
    return kRealWidth(100);
}

@end


@implementation TNSellerStoreSkeletonCell
- (NSArray<HDSkeletonLayer *> *)skeletonLayoutViews {
    HDSkeletonLayer *imageLayer = [[HDSkeletonLayer alloc] init];
    [imageLayer hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.left.hd_equalTo(self.contentView.hd_left + kRealWidth(15));
        make.top.hd_equalTo(self.contentView.hd_top + kRealWidth(30));
        make.width.hd_equalTo(kRealWidth(60));
        make.height.hd_equalTo(kRealWidth(60));
    }];

    HDSkeletonLayer *r1 = [[HDSkeletonLayer alloc] init];
    [r1 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.height.hd_equalTo(kRealWidth(20));
        make.left.hd_equalTo(imageLayer.hd_right + kRealWidth(15));
        make.width.hd_equalTo(kRealWidth(250));
        make.top.hd_equalTo(imageLayer.hd_top);
    }];

    HDSkeletonLayer *r2 = [[HDSkeletonLayer alloc] init];
    [r2 hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.height.hd_equalTo(kRealWidth(15));
        make.left.hd_equalTo(imageLayer.hd_right + kRealWidth(15));
        make.width.hd_equalTo(kRealWidth(100));
        make.bottom.hd_equalTo(imageLayer.hd_bottom);
    }];
    return @[imageLayer, r1, r2];
}

- (UIColor *)skeletonContainerViewBackgroundColor {
    return UIColor.whiteColor;
}
@end
