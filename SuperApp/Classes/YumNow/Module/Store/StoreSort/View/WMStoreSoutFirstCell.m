//
//  WMStoreSoutFirstCell.m
//  SuperApp
//
//  Created by wmz on 2021/6/28.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "WMStoreSoutFirstCell.h"


@interface WMStoreSoutFirstCell ()

@property (nonatomic, strong) UIView *leftLine;

@property (nonatomic, strong) HDLabel *titleLB;

@property (nonatomic, strong) UIImageView *iconLB;

@end


@implementation WMStoreSoutFirstCell

- (void)hd_setupViews {
    self.contentView.clipsToBounds = YES;
    [self.contentView addSubview:self.titleLB];
    [self.contentView addSubview:self.leftLine];
    [self.contentView addSubview:self.iconLB];
}

- (void)updateConstraints {
    [self.iconLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRealWidth(5));
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kRealHeight(40), kRealHeight(40)));
    }];

    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(3));
        make.right.mas_equalTo(kRealWidth(-3));
        make.height.mas_greaterThanOrEqualTo(kRealHeight(30));
        make.top.equalTo(self.iconLB.mas_bottom).offset(kRealWidth(4));
        make.bottom.mas_equalTo(kRealWidth(-5));
    }];

    [self.leftLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kRealWidth(2.5));
        make.left.centerY.mas_equalTo(0);
        make.height.equalTo(self.contentView.mas_width).multipliedBy(0.65);
    }];

    [super updateConstraints];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self setModel:self.model];
}

- (void)setModel:(WMCategoryItem *)model {
    _model = model;
    self.titleLB.text = model.message.desc;
    self.leftLine.hidden = !model.isSelected;
    [self.iconLB sd_setImageWithURL:[NSURL URLWithString:model.imagesUrl] placeholderImage:HDHelper.placeholderImage];
    self.contentView.backgroundColor = model.isSelected ? UIColor.whiteColor : HDAppTheme.WMColor.bgGray;
    self.titleLB.textColor = model.isSelected ? HDAppTheme.WMColor.mainRed : HDAppTheme.WMColor.B6;
}

- (HDLabel *)titleLB {
    if (!_titleLB) {
        _titleLB = HDLabel.new;
        _titleLB.numberOfLines = 3;
        _titleLB.font = HDAppTheme.font.standard4;
        _titleLB.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLB;
}

- (UIImageView *)iconLB {
    if (!_iconLB) {
        _iconLB = UIImageView.new;
    }
    return _iconLB;
}

- (UIView *)leftLine {
    if (!_leftLine) {
        _leftLine = UIView.new;
        _leftLine.backgroundColor = HDAppTheme.WMColor.mainRed;
    }
    return _leftLine;
}

@end
