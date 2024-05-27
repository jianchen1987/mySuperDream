//
//  SAPaymentTipView.m
//  SuperApp
//
//  Created by Tia on 2023/3/30.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import "SAPaymentTipView.h"


@interface SAPaymentTipView ()

@property (nonatomic, strong) UIImageView *iv;

@property (nonatomic, strong) UILabel *tipsLB;

@end


@implementation SAPaymentTipView

- (void)hd_setupViews {
    [self addSubview:self.iv];
    [self addSubview:self.tipsLB];

    self.backgroundColor = UIColor.whiteColor;
}


- (void)updateConstraints {
    [self.iv mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.centerY.equalTo(self);
        make.left.mas_equalTo(kRealWidth(10));
    }];

    [self.tipsLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iv.mas_right).offset(kRealWidth(10));
        make.centerY.equalTo(self.iv);
        make.right.equalTo(self).offset(-kRealWidth(20));
    }];

    [super updateConstraints];
}


- (void)setIconName:(NSString *)iconName {
    _iconName = iconName;
    self.iv.image = [UIImage imageNamed:iconName];

    [self setNeedsUpdateConstraints];
}

- (void)setIsOnlyOnline:(BOOL)isOnlyOnline {
    _isOnlyOnline = isOnlyOnline;
    if (isOnlyOnline) {
        self.tipsLB.text =
            [NSString stringWithFormat:@"%@,%@", SALocalizedString(@"payment_tips", @"在线支付正在维护中"), SALocalizedString(@"payment_tips2", @"建议选择其他支付方式,给你造成不便，敬请谅解")];
    }
}

- (void)setText:(NSString *)text {
    _text = text;
    self.tipsLB.text = text;

    [self setNeedsUpdateConstraints];
}

- (UIImageView *)iv {
    if (!_iv) {
        _iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"payment_maintenanceTips"]];
    }
    return _iv;
}

- (UILabel *)tipsLB {
    if (!_tipsLB) {
        _tipsLB = UILabel.new;
        _tipsLB.textColor = HDAppTheme.color.sa_C999;
        _tipsLB.font = HDAppTheme.font.sa_standard12;
        _tipsLB.hd_lineSpace = 5;
        _tipsLB.numberOfLines = 0;
        _tipsLB.text = [NSString stringWithFormat:@"%@,%@", SALocalizedString(@"payment_tips", @"在线支付正在维护中"), SALocalizedString(@"payment_tips1", @"给你造成不便，敬请谅解")];
    }
    return _tipsLB;
}


@end
