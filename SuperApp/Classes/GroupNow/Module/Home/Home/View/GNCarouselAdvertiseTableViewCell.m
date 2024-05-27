//
//  GNCarouselAdvertiseTableViewCell.m
//  SuperApp
//
//  Created by wmz on 2022/5/27.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNCarouselAdvertiseTableViewCell.h"
#import "SAWindowItemModel.h"


@implementation GNCarouselAdvertiseTableViewCell

- (void)hd_setupViews {
    [super hd_setupViews];
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithWhite:1 alpha:1];
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:1 alpha:0.4];
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.pageControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.equalTo(self.collectionView.mas_bottom).offset(-kRealWidth(8));
        make.width.mas_equalTo(MIN(kScreenWidth - kRealWidth(25), kRealWidth(12) * self.dataSource.count));
        make.height.mas_equalTo(kRealWidth(6));
    }];
}

- (CGSize)cardItemSize {
    CGFloat itemWidth = 311 / 375.0 * kScreenWidth;
    return CGSizeMake(itemWidth, itemWidth / 3.0);
}

- (CGFloat)cardSpace {
    return kRealWidth(8);
}

- (BOOL)cardCycle {
    return YES;
}

- (CGFloat)bannerDistance {
    return kRealWidth(23);
}

@end
