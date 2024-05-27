//
//  PayOrderTableCell.m
//  SuperApp
//
//  Created by Quin on 2021/11/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PayOrderTableCell.h"


@implementation PayOrderTableCell

- (void)hd_setupViews {
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.nameLB];
    [self.contentView addSubview:self.valueLB];
}

- (void)updateConstraints {
    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_centerX).offset(-kRealWidth(15));
        make.centerY.equalTo(self.contentView);
        if (self.model.value.length <= 0) {
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealHeight(5));
        }
    }];

    [self.valueLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_centerX).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.centerY.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealHeight(5));
    }];
    [super updateConstraints];
}

#pragma mark - setter
- (void)setModel:(PayOrderTableCellModel *)model {
    _model = model;
    self.nameLB.text = model.name;
    self.nameLB.textColor = model.nameTextColor;
    self.nameLB.font = model.nameTextFont;

    self.valueLB.text = model.value;
    self.valueLB.textColor = model.valueTextColor;
    self.valueLB.font = model.valueTextFont;

    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (SALabel *)nameLB {
    if (!_nameLB) {
        SALabel *label = SALabel.new;
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentLeft;
        _nameLB = label;
    }
    return _nameLB;
}

- (SALabel *)valueLB {
    if (!_valueLB) {
        SALabel *label = SALabel.new;
        label.textAlignment = NSTextAlignmentRight;
        label.numberOfLines = 0;
        _valueLB = label;
    }
    return _valueLB;
}

@end
