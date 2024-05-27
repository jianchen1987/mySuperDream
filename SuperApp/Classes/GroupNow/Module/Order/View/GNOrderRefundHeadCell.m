//
//  GNOrderRefundHeadCell.m
//  SuperApp
//
//  Created by wmz on 2022/3/15.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNOrderRefundHeadCell.h"


@interface GNOrderRefundHeadCell ()

@property (nonatomic, strong) UIImageView *iconIV;

@property (nonatomic, strong) HDLabel *nameLB;

@end


@implementation GNOrderRefundHeadCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.iconIV];
    [self.contentView addSubview:self.nameLB];
}

- (void)updateConstraints {
    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealWidth(44), kRealWidth(44)));
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(kRealWidth(44));
    }];

    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconIV.mas_bottom).offset(kRealWidth(25));
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.bottom.mas_equalTo(-kRealWidth(25));
    }];

    [super updateConstraints];
}

- (void)setGNModel:(GNCellModel *)data {
    self.iconIV.image = data.image;
    self.nameLB.text = data.title;
    self.contentView.backgroundColor = HDAppTheme.color.gn_mainBgColor;
}

- (HDLabel *)nameLB {
    if (!_nameLB) {
        HDLabel *label = HDLabel.new;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [HDAppTheme.font gn_boldForSize:23];
        _nameLB = label;
    }
    return _nameLB;
}

- (UIImageView *)iconIV {
    if (!_iconIV) {
        _iconIV = UIImageView.new;
    }
    return _iconIV;
}

@end
