//
//  WMOrderNoticeView.m
//  SuperApp
//
//  Created by wmz on 2022/4/22.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMOrderNoticeView.h"


@interface WMOrderNoticeView ()
/// label
@property (nonatomic, strong) SALabel *label;
/// icon
@property (nonatomic, strong) UIImageView *icon;

@end


@implementation WMOrderNoticeView

- (void)hd_setupViews {
    [self addSubview:self.label];
    [self addSubview:self.icon];
    self.layer.backgroundColor = HDAppTheme.WMColor.bg3.CGColor;
    self.layer.cornerRadius = kRealWidth(8);
}

- (void)updateConstraints {
    [self.icon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(8));
        make.top.mas_equalTo(kRealWidth(8));
        make.size.mas_equalTo(self.icon.image.size);
    }];

    [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(kRealWidth(8));
        make.height.mas_greaterThanOrEqualTo(self.icon.image.size.height);
        make.bottom.right.mas_equalTo(-kRealWidth(8));
        make.top.equalTo(self.icon.mas_top);
    }];

    [super updateConstraints];
}

- (void)setShowTip:(NSString *)showTip {
    _showTip = showTip;
    self.label.text = WMFillEmpty(showTip);
    NSMutableParagraphStyle *pare = NSMutableParagraphStyle.new;
    pare.lineSpacing = kRealWidth(4);
    self.label.attributedText = [[NSMutableAttributedString alloc] initWithString:self.label.text attributes:@{NSParagraphStyleAttributeName: pare}];
}

- (SALabel *)label {
    if (!_label) {
        SALabel *label = SALabel.new;
        label.textColor = HDAppTheme.WMColor.mainRed;
        label.font = [HDAppTheme.WMFont wm_ForSize:11];
        label.numberOfLines = 0;
        _label = label;
    }
    return _label;
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = UIImageView.new;
        _icon.image = [UIImage imageNamed:@"yn_home_weather"];
    }
    return _icon;
}

@end
