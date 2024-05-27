//
//  WMAddressManageCell.m
//  SuperApp
//
//  Created by wmz on 2021/4/15.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "WMAddressManageCell.h"


@interface WMAddressManageCell ()
@property (nonatomic, strong) HDUIButton *button;
@end


@implementation WMAddressManageCell

- (void)hd_setupViews {
    [super hd_setupViews];
    [self.contentView addSubview:self.button];
}
- (void)updateConstraints {
    [super updateConstraints];
    [self.button mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kRealWidth((40)));
        make.top.mas_equalTo(kRealWidth(10));
        make.bottom.mas_equalTo(-kRealWidth(10));
        make.centerX.mas_equalTo(0);
        make.width.equalTo(self.contentView.mas_width).multipliedBy(0.6);
    }];
}
- (void)setModel:(WMAddressManageCellModel *)model {
    _model = model;
    [self.button setTitle:model.title forState:UIControlStateNormal];
    if (model.tag == 1) {
        self.button.layer.backgroundColor = HDAppTheme.color.mainOrangeColor.CGColor;
        self.button.layer.borderColor = HDAppTheme.color.mainOrangeColor.CGColor;
        self.button.layer.borderWidth = 0;
        [self.button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    } else if (model.tag == 2) {
        self.button.layer.backgroundColor = UIColor.whiteColor.CGColor;
        self.button.layer.borderColor = HDAppTheme.color.mainOrangeColor.CGColor;
        self.button.layer.borderWidth = 1;
        [self.button setTitleColor:HDAppTheme.color.mainOrangeColor forState:UIControlStateNormal];
    } else {
        self.button.layer.backgroundColor = HDAppTheme.color.mainOrangeColor.CGColor;
        self.button.layer.borderWidth = 0;
        self.button.layer.borderColor = HDAppTheme.color.mainOrangeColor.CGColor;
    }
}


- (HDUIButton *)button {
    if (!_button) {
        _button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        _button.layer.cornerRadius = 8;
        _button.userInteractionEnabled = NO;
    }
    return _button;
}
@end
