//
//  WMSortCollectionViewCell.m
//  SuperApp
//
//  Created by wmz on 2021/6/28.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "WMSortCollectionViewCell.h"


@interface WMSortCollectionViewCell ()

@property (nonatomic, strong) HDLabel *titleLB;

@property (nonatomic, strong) UIImageView *iconLB;

@end


@implementation WMSortCollectionViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.titleLB];
    [self.contentView addSubview:self.iconLB];
}

- (void)updateConstraints {
    [self.iconLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRealWidth(5));
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kRealHeight(65), kRealHeight(65)));
    }];

    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(3));
        make.right.mas_equalTo(-kRealWidth(3));
        make.top.equalTo(self.iconLB.mas_bottom).offset(kRealWidth(3));
        make.bottom.mas_equalTo(kRealWidth(-5));
    }];

    [super updateConstraints];
}

- (void)setModel:(WMCategoryItem *)model {
    _model = model;
    self.titleLB.text = model.message.desc;
    [self.iconLB sd_setImageWithURL:[NSURL URLWithString:model.imagesUrl] placeholderImage:HDHelper.placeholderImage];
}

- (HDLabel *)titleLB {
    if (!_titleLB) {
        _titleLB = HDLabel.new;
        _titleLB.numberOfLines = 3;
        _titleLB.textAlignment = NSTextAlignmentCenter;
        _titleLB.font = HDAppTheme.font.standard3;
        _titleLB.textColor = HDAppTheme.WMColor.B6;
    }
    return _titleLB;
}

- (UIImageView *)iconLB {
    if (!_iconLB) {
        _iconLB = UIImageView.new;
    }
    return _iconLB;
}
@end
