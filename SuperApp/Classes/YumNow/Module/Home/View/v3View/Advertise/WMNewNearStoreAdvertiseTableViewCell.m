//
//  WMNewNearStoreAdvertiseTableViewCell.m
//  SuperApp
//
//  Created by Tia on 2023/7/19.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMNewNearStoreAdvertiseTableViewCell.h"


@implementation WMNewNearStoreAdvertiseTableViewCell

- (CGSize)cardItemSize {
    CGFloat itemWidth = 350 / 375.0 * kScreenWidth;
    return CGSizeMake(itemWidth, 90.0 * kScreenWidth / 375.0);
}

- (void)hd_setupViews {
    [super hd_setupViews];
    self.contentView.backgroundColor = [UIColor hd_colorWithHexString:@"#f7f7f7"];
}

- (Class)cardClass {
    return WMNewNearStoreAdvertiseItemCardCell.class;
}

@end


@implementation WMNewNearStoreAdvertiseItemCardCell

- (void)setGNModel:(WMAdadvertisingModel *)data {
    if ([data isKindOfClass:WMAdadvertisingModel.class]) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:data.images]
                          placeholderImage:[HDHelper placeholderImageWithCornerRadius:kRealWidth(8) size:CGSizeMake(350 / 375.0 * kScreenWidth, 90.0 * kScreenWidth / 375.0)]];
    }
}

@end
