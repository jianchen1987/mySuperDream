//
//  GNCanceHeadView.m
//  SuperApp
//
//  Created by wmz on 2022/8/2.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNCanceHeadView.h"


@interface GNCanceHeadView ()
@property (nonatomic, strong) HDLabel *label;
@property (nonatomic, strong) YYLabel *tipLB;
@end


@implementation GNCanceHeadView

- (void)hd_setupViews {
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.label];
    [self addSubview:self.tipLB];
}

- (void)hd_bindViewModel {
    self.label.text = GNLocalizedString(@"gn_refunded_account", @"If you use the coupon, it will be refunded to your account.");
    self.tipLB.preferredMaxLayoutWidth = kScreenWidth - kRealWidth(24);
    NSMutableAttributedString *mstr =
        [[NSMutableAttributedString alloc] initWithString:GNLocalizedString(@"gn_help_us_improve", @"Choose or input the reason for canceling the order and help us improve")];
    mstr.yy_lineSpacing = kRealWidth(4);
    mstr.yy_font = [HDAppTheme.WMFont wm_ForSize:16 weight:UIFontWeightHeavy];
    mstr.yy_color = HDAppTheme.WMColor.B3;
    self.tipLB.attributedText = mstr;
}

- (void)updateConstraints {
    [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
    }];

    [self.tipLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(12));
        make.right.mas_equalTo(-kRealWidth(12));
        make.bottom.mas_equalTo(-kRealWidth(8));
        make.top.equalTo(self.label.mas_bottom).offset(kRealWidth(8));
    }];

    [super updateConstraints];
}

- (HDLabel *)label {
    if (!_label) {
        _label = HDLabel.new;
        _label.textColor = HDAppTheme.color.gn_mainColor;
        _label.font = [HDAppTheme.font gn_ForSize:11];
        _label.numberOfLines = 0;
        _label.hd_edgeInsets = UIEdgeInsetsMake(kRealWidth(8), kRealWidth(12), kRealWidth(8), kRealWidth(12));
        _label.backgroundColor = HDAppTheme.color.gn_tipBg;
    }
    return _label;
}

- (YYLabel *)tipLB {
    if (!_tipLB) {
        YYLabel *la = YYLabel.new;
        la.numberOfLines = 0;
        _tipLB = la;
    }
    return _tipLB;
}

@end
