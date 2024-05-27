//
//  SAShoppingAddressTableViewCell.m
//  SuperApp
//
//  Created by VanJay on 2020/5/7.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAShoppingAddressTableViewCell.h"


@interface SAShoppingAddressTableViewCell ()
/// 线条
@property (nonatomic, strong) UIView *bottomLine;
@end


@implementation SAShoppingAddressTableViewCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.floatLayoutView];
    [self.contentView addSubview:self.typeIV];
    [self.contentView addSubview:self.detailTitleLabel];
    [self.contentView addSubview:self.bottomLine];
}

#pragma mark - setter
- (void)setModel:(SAShoppingAddressModel *)model {
    _model = model;

    self.titleLabel.text = model.fullAddress ?: @"";

    NSMutableArray<NSString *> *tags = [NSMutableArray arrayWithArray:model.tags];
    if ([model.isDefault isEqualToString:SABoolValueTrue]) {
        [tags insertObject:WMLocalizedString(@"default", @"默认") atIndex:0];
    }
    self.floatLayoutView.hidden = HDIsArrayEmpty(tags);
    if (!self.floatLayoutView.isHidden) {
        [self.floatLayoutView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [tags enumerateObjectsUsingBlock:^(NSString *_Nonnull title, NSUInteger idx, BOOL *_Nonnull stop) {
            HDUIGhostButton *button = HDUIGhostButton.new;
            [button setTitle:SALocalizedString([title lowercaseString], title) forState:UIControlStateNormal];
            [button setTitleColor:HDAppTheme.color.C3 forState:UIControlStateNormal];
            button.backgroundColor = [HexColor(0xFCCB30) colorWithAlphaComponent:0.1];
            button.titleLabel.font = HDAppTheme.font.standard4;
            button.titleEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
            [button sizeToFit];
            button.userInteractionEnabled = false;
            [self.floatLayoutView addSubview:button];
        }];
    }

    self.titleLabel.textColor = HDAppTheme.color.G2;
    if (model.cellType == SAShoppingAddressCellTypeChoose) {
        BOOL isNeedCompleteAddress = self.isNeedCompleteAddress && [model isNeedCompleteAddressInClientType:nil];
        if (isNeedCompleteAddress) {
            self.typeIV.hidden = false;
            self.typeIV.image = [UIImage imageNamed:@"address_error"];
        } else {
            self.typeIV.hidden = ![model.isSelected isEqualToString:SABoolValueTrue];
            self.typeIV.image = [UIImage imageNamed:@"icon_tick"];
        }
    } else if (model.cellType == SAShoppingAddressCellTypeEdit) {
        self.typeIV.image = [UIImage imageNamed:@"mine_address_edit"];
        self.typeIV.hidden = false;
    } else {
        self.typeIV.hidden = true;
    }
    NSString *key = [NSString stringWithFormat:@"sa_text_%@_title", model.gender];

    NSString *detailText = [NSString stringWithFormat:SALocalizedString(key, @"%@,%@"), model.consigneeName ?: @"", model.mobile ?: @""];
    if ([detailText isEqualToString:@","]) {
        self.detailTitleLabel.hidden = YES;
    } else {
        self.detailTitleLabel.hidden = HDIsStringEmpty(detailText);
    }
    if (!self.detailTitleLabel.isHidden) {
        self.detailTitleLabel.text = detailText;
    }

    if ([model.inRange isEqualToString:SABoolValueFalse]) {
        self.titleLabel.textColor = HDAppTheme.color.G3;
    } else {
        self.titleLabel.textColor = HDAppTheme.color.G2;
    }

    [self setNeedsUpdateConstraints];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.model.isSelected = selected ? SABoolValueTrue : SABoolValueFalse;
    if (self.model.cellType == SAShoppingAddressCellTypeChoose) {
        BOOL isNeedCompleteAddress = self.isNeedCompleteAddress && [self.model isNeedCompleteAddressInClientType:nil];
        if (isNeedCompleteAddress) {
            self.typeIV.hidden = false;
            self.typeIV.image = [UIImage imageNamed:@"address_error"];
        } else {
            self.typeIV.hidden = ![self.model.isSelected isEqualToString:SABoolValueTrue];
            self.typeIV.image = [UIImage imageNamed:@"icon_tick"];
        }
    }
    [self setNeedsUpdateConstraints];
}

#pragma mark - layout
- (void)updateConstraints {
    CGFloat const left = kRealWidth(20);
    [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.iconView.image.size);
        make.left.equalTo(self.contentView).offset(left);
        make.centerY.equalTo(self.titleLabel);
    }];

    CGFloat const margin = kRealWidth(10);
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(margin);
        make.top.equalTo(self.contentView).offset(kRealWidth(15));
        if (self.typeIV.isHidden) {
            make.right.equalTo(self.contentView).offset(-HDAppTheme.value.padding.right);
        } else {
            make.right.equalTo(self.typeIV.mas_left).offset(-kRealWidth(5));
        }
    }];

    [self.typeIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.typeIV.isHidden) {
            make.size.mas_equalTo(self.typeIV.image.size);
            make.right.equalTo(self.contentView).offset(-HDAppTheme.value.padding.right);
            BOOL isNeedCompleteAddress = self.isNeedCompleteAddress && [self.model isNeedCompleteAddressInClientType:nil];
            if (isNeedCompleteAddress) {
                make.centerY.equalTo(self.contentView);
            } else {
                make.top.equalTo(self.titleLabel);
            }
        }
    }];

    [self.detailTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.detailTitleLabel.isHidden) {
            make.left.equalTo(self.iconView.mas_right).offset(margin);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(10));

            if (self.typeIV.isHidden) {
                make.right.equalTo(self.contentView).offset(-HDAppTheme.value.padding.right);
            } else {
                make.right.equalTo(self.typeIV.mas_left).offset(-kRealWidth(5));
            }

            if (self.floatLayoutView.isHidden && self.bottomLine.isHidden) {
                make.bottom.equalTo(self.contentView).offset(-kRealWidth(15));
            }
        }
    }];

    [self.floatLayoutView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.floatLayoutView.isHidden) {
            CGFloat floatLayoutViewWidth = self.frame.size.width - left - margin - self.iconView.image.size.width - HDAppTheme.value.padding.right;
            UIView *view = self.detailTitleLabel.isHidden ? self.titleLabel : self.detailTitleLabel;
            make.top.equalTo(view.mas_bottom).offset(kRealWidth(10));
            make.left.equalTo(self.titleLabel);
            make.size.mas_equalTo([self.floatLayoutView sizeThatFits:CGSizeMake(floatLayoutViewWidth, CGFLOAT_MAX)]);
            if (self.bottomLine.isHidden) {
                make.bottom.equalTo(self.contentView).offset(-kRealWidth(15));
            }
        }
    }];

    [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.bottomLine.isHidden) {
            UIView *view = self.floatLayoutView.isHidden ? self.detailTitleLabel : self.floatLayoutView;
            view = view.isHidden ? self.titleLabel : view;
            make.top.equalTo(view.mas_bottom).offset(kRealWidth(15));
            make.height.mas_equalTo(PixelOne);
            make.left.equalTo(self.titleLabel);
            make.right.equalTo(self.contentView).offset(-HDAppTheme.value.padding.right);
            make.bottom.equalTo(self.contentView);
        }
    }];

    [super updateConstraints];
}

#pragma mark - lazy load
- (SALabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[SALabel alloc] init];
        _titleLabel.font = HDAppTheme.font.standard3;
        _titleLabel.textColor = HDAppTheme.color.G2;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (SALabel *)detailTitleLabel {
    if (!_detailTitleLabel) {
        _detailTitleLabel = [[SALabel alloc] init];
        _detailTitleLabel.font = HDAppTheme.font.standard3;
        _detailTitleLabel.textColor = HDAppTheme.color.G2;
        _detailTitleLabel.numberOfLines = 0;
    }
    return _detailTitleLabel;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.image = [UIImage imageNamed:@"address_icon"];
    }
    return _iconView;
}

- (HDFloatLayoutView *)floatLayoutView {
    if (!_floatLayoutView) {
        _floatLayoutView = HDFloatLayoutView.new;
        _floatLayoutView.itemMargins = UIEdgeInsetsMake(0, 0, 8, 10);
    }
    return _floatLayoutView;
}

- (UIImageView *)typeIV {
    if (!_typeIV) {
        UIImageView *imageView = UIImageView.new;
        _typeIV = imageView;
    }
    return _typeIV;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = UIView.new;
        _bottomLine.backgroundColor = HDAppTheme.color.G4;
    }
    return _bottomLine;
}
@end
