//
//  WMShoppingAddressTableViewCell.m
//  SuperApp
//
//  Created by Chaos on 2020/10/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMShoppingAddressTableViewCell.h"
#import "SARadioView.h"


@interface WMShoppingAddressTableViewCell ()
/// 标题
@property (nonatomic, strong) SALabel *titleLabel;
/// 描述
@property (nonatomic, strong) SALabel *detailTitleLabel;
/// 选中图标
@property (nonatomic, strong) SARadioView *radioView;
/// 标签
@property (nonatomic, strong) HDFloatLayoutView *floatLayoutView;
/// 线条
@property (nonatomic, strong) UIView *bottomLine;
/// 地址完善提示icon
@property (nonatomic, strong) UIImageView *addressTipsIV;

@end


@implementation WMShoppingAddressTableViewCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.radioView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.floatLayoutView];
    [self.contentView addSubview:self.detailTitleLabel];
    [self.contentView addSubview:self.bottomLine];
    [self.contentView addSubview:self.addressTipsIV];
}

#pragma mark - setter
- (void)setModel:(SAShoppingAddressModel *)model {
    _model = model;

    self.titleLabel.text = [NSString stringWithFormat:@"%@%@", model.address, model.consigneeAddress ?: @""];

    NSMutableArray<NSString *> *tags = [NSMutableArray arrayWithArray:model.tags];
    if ([model.isDefault isEqualToString:SABoolValueTrue]) {
        [tags insertObject:WMLocalizedString(@"default", @"默认") atIndex:0];
    }
    if ([model.slowPayMark isEqualToString:SABoolValueTrue]) {
        [tags addObject:WMLocalizedString(@"wm_later_to_pay", @"慢必赔")];
    }
    self.floatLayoutView.hidden = HDIsArrayEmpty(tags);
    if (!self.floatLayoutView.isHidden) {
        [self.floatLayoutView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [tags enumerateObjectsUsingBlock:^(NSString *_Nonnull title, NSUInteger idx, BOOL *_Nonnull stop) {
            HDUIGhostButton *button = HDUIGhostButton.new;
            [button setTitle:SALocalizedString([title lowercaseString], title) forState:UIControlStateNormal];
            if ([title isEqualToString:WMLocalizedString(@"wm_later_to_pay", @"慢必赔")]) {
                [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
                button.backgroundColor = HDAppTheme.WMColor.mainRed;
            } else {
                [button setTitleColor:HDAppTheme.color.C3 forState:UIControlStateNormal];
                button.backgroundColor = [HexColor(0xFCCB30) colorWithAlphaComponent:0.1];
            }
            button.titleLabel.font = HDAppTheme.font.standard4;
            button.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(4), kRealWidth(8), kRealWidth(4), kRealWidth(8));
            [button sizeToFit];
            button.userInteractionEnabled = false;
            [self.floatLayoutView addSubview:button];
        }];
    }

    self.titleLabel.textColor = HDAppTheme.color.G2;
    NSString *key = [NSString stringWithFormat:@"sa_text_%@_title", model.gender];
    NSString *detailText = [NSString stringWithFormat:SALocalizedString(key, @"%@,%@"), model.consigneeName, model.mobile];
    self.detailTitleLabel.hidden = HDIsStringEmpty(detailText);
    if (!self.detailTitleLabel.isHidden) {
        self.detailTitleLabel.text = detailText;
    }

    if ([model.inRange isEqualToString:SABoolValueFalse]) {
        self.titleLabel.textColor = HDAppTheme.color.G3;
        self.detailTitleLabel.textColor = HDAppTheme.color.G3;
    } else {
        self.titleLabel.textColor = HDAppTheme.color.G1;
        self.detailTitleLabel.textColor = HDAppTheme.color.G1;
    }

    if (self.isNeedCompleteAddress && [model isNeedCompleteAddressInClientType:nil] && [model.inRange isEqualToString:SABoolValueTrue]) {
        self.radioView.hidden = true;
        self.addressTipsIV.hidden = false;
    } else {
        self.radioView.hidden = false;
        self.addressTipsIV.hidden = true;
        self.radioView.selected = model.isSelected.boolValue;
    }

    [self setNeedsUpdateConstraints];
}

#pragma mark - layout
- (void)updateConstraints {
    CGFloat const left = kRealWidth(20);
    CGFloat const margin = kRealWidth(10);
    [self.floatLayoutView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.floatLayoutView.isHidden) {
            CGFloat floatLayoutViewWidth = self.frame.size.width - left - margin - self.radioView.config.size.width - HDAppTheme.value.padding.right;
            UIView *view = self.detailTitleLabel.isHidden ? self.titleLabel : self.detailTitleLabel;
            make.top.equalTo(view.mas_bottom).offset(kRealWidth(10));
            make.left.equalTo(self.titleLabel);
            make.size.mas_equalTo([self.floatLayoutView sizeThatFits:CGSizeMake(floatLayoutViewWidth, CGFLOAT_MAX)]);
        }
    }];

    [self.radioView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.radioView.isHidden) {
            make.size.mas_equalTo(self.radioView.config.size);
            make.left.equalTo(self.contentView).offset(left);
            make.top.equalTo(self.titleLabel);
        }
    }];

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.radioView.isHidden) {
            make.left.equalTo(self.addressTipsIV.mas_right).offset(margin);
        } else {
            make.left.equalTo(self.radioView.mas_right).offset(margin);
        }
        make.top.equalTo(self.contentView).offset(kRealWidth(15));
        make.right.equalTo(self.contentView).offset(-HDAppTheme.value.padding.right);
    }];

    [self.detailTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.detailTitleLabel.isHidden) {
            if (self.radioView.isHidden) {
                make.left.equalTo(self.addressTipsIV.mas_right).offset(margin);
            } else {
                make.left.equalTo(self.radioView.mas_right).offset(margin);
            }
            make.top.equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(10));
            make.right.equalTo(self.contentView).offset(-HDAppTheme.value.padding.right);
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
    [self.addressTipsIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.addressTipsIV.isHidden) {
            make.size.mas_equalTo(self.radioView.config.size);
            make.left.equalTo(self.contentView).offset(left);
            make.centerY.equalTo(self.contentView);
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
        _detailTitleLabel.textColor = HDAppTheme.color.G3;
        _detailTitleLabel.numberOfLines = 0;
    }
    return _detailTitleLabel;
}

- (SARadioView *)radioView {
    if (!_radioView) {
        SARadioViewConfig *config = SARadioViewConfig.new;
        config.selectedColor = HDAppTheme.color.C3;
        _radioView = [[SARadioView alloc] initWithConfig:config];
    }
    return _radioView;
}

- (HDFloatLayoutView *)floatLayoutView {
    if (!_floatLayoutView) {
        _floatLayoutView = HDFloatLayoutView.new;
        _floatLayoutView.itemMargins = UIEdgeInsetsMake(0, 0, 8, 10);
    }
    return _floatLayoutView;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = UIView.new;
        _bottomLine.backgroundColor = HDAppTheme.color.G4;
    }
    return _bottomLine;
}

- (UIImageView *)addressTipsIV {
    if (!_addressTipsIV) {
        _addressTipsIV = UIImageView.new;
        _addressTipsIV.contentMode = UIViewContentModeCenter;
        _addressTipsIV.image = [UIImage imageNamed:@"address_error"];
    }
    return _addressTipsIV;
}

@end
