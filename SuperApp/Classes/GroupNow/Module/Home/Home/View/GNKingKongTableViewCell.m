//
//  GNKingKongTableViewCell.m
//  SuperApp
//
//  Created by wmz on 2022/5/27.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNKingKongTableViewCell.h"

static const CGFloat kItemCountPerRow = 5.f;


@implementation GNKingKongTableViewCell

- (CGFloat)cardSpace {
    CGFloat space = 0;
    if (self.dataSource.count < 9) {
        space = ((kScreenWidth - kRealWidth(20)) / (kItemCountPerRow - 1)) - (kScreenWidth + kRealWidth(20)) / kItemCountPerRow;
    }
    return space;
}

- (CGSize)cardItemSize {
    CGFloat itemWidth = (kScreenWidth + kRealWidth(20)) / kItemCountPerRow;
    return CGSizeMake(itemWidth, kRealWidth(103));
}

@end
