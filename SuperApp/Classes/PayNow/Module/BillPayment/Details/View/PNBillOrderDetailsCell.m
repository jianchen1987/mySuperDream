//
//  PNBillOrderDetailsCell.m
//  SuperApp
//
//  Created by xixi_wen on 2022/4/24.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNBillOrderDetailsCell.h"
#import "SAInfoViewModel.h"


@interface PNBillOrderDetailsCell ()
@property (nonatomic, strong) SALabel *keyLabel;
@property (nonatomic, strong) SALabel *valueLabel;
@end


@implementation PNBillOrderDetailsCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.keyLabel];
    [self.contentView addSubview:self.valueLabel];

    [self.keyLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)updateConstraints {
    [self.keyLabel sizeToFit];
    [self.keyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top);
        make.left.mas_equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        if (WJIsStringEmpty(self.valueLabel.text)) {
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(kRealWidth(-10));
        }
    }];

    if (WJIsStringNotEmpty(self.valueLabel.text)) {
        [self.valueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top);
            make.left.mas_equalTo(self.keyLabel.mas_right).offset(kRealWidth(10));
            make.right.mas_equalTo(self.contentView.mas_right).offset(kRealWidth(-15));
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(kRealWidth(-10));
        }];
    }

    [super updateConstraints];
}

#pragma mark
- (void)setModel:(SAInfoViewModel *)model {
    _model = model;
    self.keyLabel.text = model.keyText;
    self.valueLabel.text = model.valueText;

    [self setNeedsUpdateConstraints];
}

#pragma mark
- (SALabel *)keyLabel {
    if (!_keyLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c9599A2;
        label.font = HDAppTheme.PayNowFont.standard12;
        _keyLabel = label;
    }
    return _keyLabel;
}

- (SALabel *)valueLabel {
    if (!_valueLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c343B4D;
        label.font = HDAppTheme.PayNowFont.standard12;
        label.numberOfLines = 0;
        _valueLabel = label;
    }
    return _valueLabel;
}

@end
