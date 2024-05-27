//
//  WMToStoreContactViewCell.m
//  SuperApp
//
//  Created by Tia on 2023/8/31.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMToStoreContactViewCell.h"


@interface WMToStoreContactViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *numberLabel;


@end


@implementation WMToStoreContactViewCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.numberLabel];
    [self.contentView addSubview:self.btn];
}

- (void)updateConstraints {
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(0);
    }];

    [self.numberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.bottom.mas_equalTo(0);
    }];

    [self.btn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.centerY.mas_equalTo(0);
    }];

    [super updateConstraints];
}

- (void)setModel:(SAShoppingAddressModel *)model {
    _model = model;
    self.titleLabel.text = model.consigneeName;
    self.numberLabel.text = model.mobile;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.new;
        _titleLabel.textColor = UIColor.sa_C333;
        _titleLabel.font = HDAppTheme.font.sa_standard16SB;
    }
    return _titleLabel;
}

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = UILabel.new;
        _numberLabel.textColor = UIColor.sa_C333;
        _numberLabel.font = HDAppTheme.font.sa_standard14;
    }
    return _numberLabel;
}

- (UIButton *)btn {
    if (!_btn) {
        _btn = UIButton.new;
        [_btn setImage:[UIImage imageNamed:@"ac_icon_radio_nor"] forState:UIControlStateNormal];
        [_btn setImage:[UIImage imageNamed:@"ac_icon_radio_sel"] forState:UIControlStateSelected];
        _btn.userInteractionEnabled = NO;
    }
    return _btn;
}

@end
