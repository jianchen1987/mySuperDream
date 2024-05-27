//
//  WMOrderDetailTelegramView.m
//  SuperApp
//
//  Created by wmz on 2023/4/17.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "WMOrderDetailTelegramView.h"


@interface WMOrderDetailTelegramView ()
@property (nonatomic, strong) UIImageView *bgIV;
@property (nonatomic, strong) UIImageView *rightIV;
@property (nonatomic, strong) HDLabel *label;
@end


@implementation WMOrderDetailTelegramView

- (void)hd_setupViews {
    self.layer.backgroundColor = UIColor.whiteColor.CGColor;
    self.layer.cornerRadius = kRealWidth(8);
    [self addSubview:self.bgIV];
    [self addSubview:self.label];
    [self addSubview:self.rightIV];
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.bgIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(12));
        make.top.mas_equalTo(kRealWidth(14));
        make.size.mas_equalTo(self.bgIV.image.size);
        make.bottom.mas_equalTo(-kRealWidth(14));
    }];

    [self.rightIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.rightIV.image.size);
        make.right.mas_equalTo(-kRealWidth(12));
        make.centerY.mas_equalTo(0);
    }];

    [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgIV.mas_right).offset(kRealWidth(8));
        make.centerY.mas_equalTo(0);
        make.right.equalTo(self.rightIV.mas_left).offset(-kRealWidth(8));
        make.height.mas_greaterThanOrEqualTo(kRealWidth(18));
    }];
    [self.label setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    [self.label setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
}

- (HDLabel *)label {
    if (!_label) {
        _label = HDLabel.new;
        _label.textColor = HDAppTheme.WMColor.B3;
        _label.font = [HDAppTheme.WMFont wm_ForSize:12 weight:UIFontWeightMedium];
        _label.text = WMLocalizedString(@"wm_bind_tg", @"绑定Telegram，实时获取外卖订单信息");
    }
    return _label;
}

- (UIImageView *)bgIV {
    if (!_bgIV) {
        _bgIV = UIImageView.new;
        _bgIV.contentMode = UIViewContentModeScaleAspectFit;
        _bgIV.image = [UIImage imageNamed:@"yn_telegram_icon"];
    }
    return _bgIV;
}

- (UIImageView *)rightIV {
    if (!_rightIV) {
        _rightIV = UIImageView.new;
        _rightIV.contentMode = UIViewContentModeScaleAspectFit;
        _rightIV.image = [UIImage imageNamed:@"yn_telegram_enter"];
    }
    return _rightIV;
}

@end
