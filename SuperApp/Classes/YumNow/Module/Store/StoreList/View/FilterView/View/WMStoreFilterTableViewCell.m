//
//  WMStoreFilterTableViewCell.m
//  SuperApp
//
//  Created by VanJay on 2020/4/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMStoreFilterTableViewCell.h"


@interface WMStoreFilterTableViewCell ()
/// 线
@property (nonatomic, strong) UIView *topLine;
/// 线
@property (nonatomic, strong) UIView *bottomLine;
/// 标题
@property (nonatomic, strong) UILabel *titleLB;
/// icon
@property (nonatomic, strong) UIImageView *iconIV;

@end


@implementation WMStoreFilterTableViewCell

- (void)hd_setupViews {
    self.backgroundColor = UIColor.clearColor;

    [self.contentView addSubview:self.topLine];
    [self.contentView addSubview:self.bottomLine];
    [self.contentView addSubview:self.titleLB];
    [self.contentView addSubview:self.iconIV];
}

- (void)updateConstraints {
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(kRealWidth(12.5));
        make.left.equalTo(self.contentView).offset(kRealWidth(12));
        if (self.iconIV.isHidden) {
            make.right.equalTo(self.contentView).offset(-kRealWidth(12));
        } else {
            make.right.equalTo(self.iconIV.mas_left).offset(-kRealWidth(5));
        }
        make.center.equalTo(self.contentView);
    }];

    [self.topLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.topLine.isHidden) {
            make.height.mas_equalTo(PixelOne);
            make.left.equalTo(self.contentView).offset(kRealWidth(10));
            make.right.equalTo(self.contentView).offset(self.model.isMain ? -kRealWidth(10) : 0);
            make.top.equalTo(self.contentView);
        }
    }];

    [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.bottomLine.isHidden) {
            make.height.mas_equalTo(PixelOne);
            make.left.equalTo(self.contentView).offset(kRealWidth(10));
            make.right.equalTo(self.contentView).offset(self.model.isMain ? -kRealWidth(10) : 0);
            make.bottom.equalTo(self.contentView);
        }
    }];

    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.iconIV.isHidden) {
            make.size.mas_equalTo(self.iconIV.image.size);
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-kRealWidth(12));
        }
    }];

    [super updateConstraints];
}

#pragma mark - setter
- (void)setModel:(WMStoreFilterTableViewCellBaseModel *)model {
    _model = model;

    if (model.attributedTitle) {
        if (model.isSelected) {
            self.titleLB.attributedText = model.selectedAttributedTitle;
        } else {
            self.titleLB.attributedText = model.attributedTitle;
        }
    } else {
        if (model.isSelected && model.isMain) {
            self.titleLB.font = model.titleSelectFont;
        } else {
            self.titleLB.font = model.titleFont;
        }
        self.titleLB.text = model.title;
        self.titleLB.textColor = self.model.isSelected ? self.model.titleSelectColor : self.model.titleColor;
    }
    self.iconIV.image = [UIImage imageNamed:model.isSelected ? @"yn_filter_select" : @"yn_filter_normal"];
    self.topLine.hidden = !model.needTopLine;
    self.bottomLine.hidden = !model.needBottomLine;
    if (model.unShowNormal) {
        if (!model.isSelected) {
            self.iconIV.hidden = YES;
        } else {
            self.iconIV.hidden = !model.isCanSelect;
        }
    } else {
        self.iconIV.hidden = !model.isCanSelect;
    }
    [self setNeedsUpdateConstraints];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    //    self.iconIV.hidden = YES;  //self.model.isMain || !self.model.isSelected;
    if (self.model.attributedTitle) {
        if (self.model.isSelected) {
            self.titleLB.attributedText = self.model.selectedAttributedTitle;
        } else {
            self.titleLB.attributedText = self.model.attributedTitle;
        }
    } else {
        if (self.model.isSelected && self.model.isMain) {
            self.titleLB.font = self.model.titleSelectFont;
        } else {
            self.titleLB.font = self.model.titleFont;
        }
        self.titleLB.text = self.model.title;
        self.titleLB.textColor = self.model.isSelected ? self.model.titleSelectColor : self.model.titleColor;
    }
    self.iconIV.image = [UIImage imageNamed:self.model.isSelected ? @"yn_filter_select" : @"yn_filter_normal"];
    self.contentView.backgroundColor = selected ? UIColor.whiteColor : UIColor.clearColor;

    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (UIView *)topLine {
    if (!_topLine) {
        _topLine = UIView.new;
        _topLine.backgroundColor = HDAppTheme.color.G4;
    }
    return _topLine;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = UIView.new;
        _bottomLine.backgroundColor = HDAppTheme.color.G4;
    }
    return _bottomLine;
}

- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = UILabel.new;
        _titleLB.font = HDAppTheme.font.standard3;
        _titleLB.numberOfLines = 2;
        _titleLB.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _titleLB;
}

- (UIImageView *)iconIV {
    if (!_iconIV) {
        _iconIV = UIImageView.new;
    }
    return _iconIV;
}

@end
