//
//  SACompleteAddressTipsView.m
//  SuperApp
//
//  Created by Chaos on 2021/3/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SACompleteAddressTipsView.h"


@interface SACompleteAddressTipsView ()

/// 完善信息图标
@property (nonatomic, strong) UIImageView *tipIV;
/// 完善信息提示
@property (nonatomic, strong) SALabel *tipLB;

@end


@implementation SACompleteAddressTipsView

- (void)hd_setupViews {
    self.tintColor = HDAppTheme.color.C1;
    [self addSubview:self.tipIV];
    [self addSubview:self.tipLB];
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    [self.tipIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(self.tipIV.image.size);
        make.top.greaterThanOrEqualTo(self);
        make.bottom.lessThanOrEqualTo(self);
    }];
    [self.tipLB sizeToFit];
    [self.tipLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tipIV.mas_right).offset(kRealWidth(5));
        make.centerY.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(self.tipLB.height);
        make.top.greaterThanOrEqualTo(self);
        make.bottom.lessThanOrEqualTo(self);
    }];
    [super updateConstraints];
}

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    self.tipIV.image = [self.tipIV.image hd_imageWithTintColor:tintColor];
    self.tipLB.textColor = tintColor;
}

#pragma mark - lazy load
- (UIImageView *)tipIV {
    if (!_tipIV) {
        _tipIV = UIImageView.new;
        _tipIV.image = [UIImage imageNamed:@"ic_complete_address"];
    }
    return _tipIV;
}
- (SALabel *)tipLB {
    if (!_tipLB) {
        SALabel *label = SALabel.new;
        label.text = SALocalizedString(@"1qlk3HjQ", @"请补充完善地址信息。");
        label.textColor = HDAppTheme.color.C1;
        label.font = HDAppTheme.font.standard4;
        _tipLB = label;
    }
    return _tipLB;
}

@end
