//
//  WMTipAlertView.m
//  SuperApp
//
//  Created by wmz on 2022/9/29.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMTipAlertView.h"


@interface WMTipAlertView ()
/// titleLb
@property (nonatomic, strong) HDLabel *titleLB;

@end


@implementation WMTipAlertView

- (void)hd_setupViews {
    [self addSubview:self.titleLB];
}

- (void)updateConstraints {
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRealWidth(12));
        make.right.mas_equalTo(-kRealWidth(12));
        make.top.mas_equalTo(kRealWidth(4));
    }];
    [super updateConstraints];
}

- (void)setTip:(NSString *)tip {
    _tip = tip;
    self.titleLB.text = tip;
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    [paragraphStyle setLineSpacing:kRealWidth(4)];
    self.titleLB.attributedText = [[NSMutableAttributedString alloc] initWithString:self.titleLB.text attributes:@{
        NSParagraphStyleAttributeName: paragraphStyle,
    }];
}

- (void)layoutyImmediately {
    [self layoutIfNeeded];
    self.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(self.titleLB.frame) + kRealWidth(24));
}

- (HDLabel *)titleLB {
    if (!_titleLB) {
        HDLabel *label = HDLabel.new;
        label.textColor = HDAppTheme.WMColor.B6;
        label.font = [HDAppTheme.WMFont wm_ForSize:14];
        label.numberOfLines = 0;
        _titleLB = label;
    }
    return _titleLB;
}

@end
