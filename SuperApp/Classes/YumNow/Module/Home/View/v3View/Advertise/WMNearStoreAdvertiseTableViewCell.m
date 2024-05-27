//
//  WMNearStoreAdvertiseTableViewCell.m
//  SuperApp
//
//  Created by wmz on 2022/4/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMNearStoreAdvertiseTableViewCell.h"


@interface WMNearStoreAdvertiseTableViewCell ()
/// lineView
@property (nonatomic, strong) UIView *lineView;

@end


@implementation WMNearStoreAdvertiseTableViewCell

- (CGSize)cardItemSize {
    CGFloat itemWidth = 350 / 375.0 * kScreenWidth;
    return CGSizeMake(itemWidth, 135.0 * kScreenWidth / 375.0);
}

- (void)hd_setupViews {
    [super hd_setupViews];
    [self.contentView addSubview:self.lineView];
}

- (void)updateConstraints {
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.8);
        make.left.right.equalTo(self.collectionView);
        make.bottom.mas_equalTo(0);
    }];
    [super updateConstraints];
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = UIView.new;
        _lineView.backgroundColor = HDAppTheme.WMColor.lineColor;
    }
    return _lineView;
}

@end
