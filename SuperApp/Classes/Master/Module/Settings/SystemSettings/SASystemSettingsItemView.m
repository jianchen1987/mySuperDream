//
//  SASystemSettingsItemView.m
//  SuperApp
//
//  Created by Tia on 2023/6/25.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SASystemSettingsItemView.h"


@interface SASystemSettingsItemView ()

@end


@implementation SASystemSettingsItemView

- (void)hd_setupViews {
    [self addSubview:self.textLabel];
    [self addSubview:self.itemSwitch];
    [self addSubview:self.line];
}

- (void)updateConstraints {
    [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.centerY.mas_equalTo(0);
        make.right.equalTo(self.itemSwitch.mas_left);
    }];

    [self.itemSwitch sizeToFit];
    [self.itemSwitch mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.size.mas_equalTo(self.itemSwitch.size);
        make.centerY.equalTo(self.textLabel);
    }];

    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(0);
    }];

    [super updateConstraints];
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = UILabel.new;
        _textLabel.textColor = UIColor.sa_C333;
        _textLabel.font = HDAppTheme.font.sa_standard14;
    }
    return _textLabel;
}

- (UISwitch *)itemSwitch {
    if (!_itemSwitch) {
        _itemSwitch = UISwitch.new;
    }
    return _itemSwitch;
}

- (UIView *)line {
    if (!_line) {
        _line = UIView.new;
        _line.backgroundColor = UIColor.sa_separatorLineColor;
    }
    return _line;
}


@end
