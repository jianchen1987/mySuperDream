//
//  WMOrderFeedBackTitleView.m
//  SuperApp
//
//  Created by wmz on 2022/11/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMOrderFeedBackTitleView.h"


@interface WMOrderFeedBackTitleView ()
/// nameLB
@property (nonatomic, strong) HDLabel *nameLB;
/// detailLB
@property (nonatomic, strong) HDLabel *detailLB;
/// iconIV
@property (nonatomic, strong) UIImageView *iconIV;
/// titleLB
@property (nonatomic, strong) HDLabel *titleLB;
/// lineView
@property (nonatomic, strong) UIView *lineView;

@end


@implementation WMOrderFeedBackTitleView

- (void)hd_setupViews {
    self.layer.backgroundColor = UIColor.whiteColor.CGColor;
    self.layer.cornerRadius = kRealWidth(8);
    [self addSubview:self.titleLB];
    [self addSubview:self.lineView];
    [self addSubview:self.iconIV];
    [self addSubview:self.nameLB];
    [self addSubview:self.detailLB];
}

- (void)updateConstraints {
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(kRealWidth(12));
        make.right.mas_equalTo(-kRealWidth(12));
        make.height.mas_greaterThanOrEqualTo(kRealWidth(24));
    }];

    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.titleLB.mas_bottom).offset(kRealWidth(12));
        make.height.mas_equalTo(HDAppTheme.WMValue.line);
    }];

    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealWidth(24), kRealWidth(24)));
        make.left.mas_equalTo(kRealWidth(12));
        make.top.equalTo(self.lineView.mas_bottom).offset(kRealWidth(12));
        make.bottom.mas_lessThanOrEqualTo(-kRealWidth(12));
    }];

    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(4));
        make.height.mas_greaterThanOrEqualTo(kRealWidth(20));
        make.centerY.equalTo(self.iconIV);
        make.right.mas_equalTo(-kRealWidth(12));
    }];

    [self.detailLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.detailLB.isHidden) {
            make.top.equalTo(self.nameLB.mas_bottom).offset(kRealWidth(4));
            make.left.right.equalTo(self.nameLB);
            make.bottom.mas_lessThanOrEqualTo(-kRealWidth(12));
        }
    }];

    [super updateConstraints];
}

- (void)setModel:(GNCellModel *)model {
    self.nameLB.text = model.title;
    self.detailLB.text = model.detail;
    NSMutableAttributedString *mstr = [[NSMutableAttributedString alloc] initWithString:WMFillEmpty(model.detail)];
    mstr.yy_lineSpacing = kRealWidth(4);
    self.detailLB.attributedText = mstr;
    self.detailLB.hidden = HDIsStringEmpty(model.detail);
    self.iconIV.image = model.image;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = UIView.new;
        _lineView.backgroundColor = HDAppTheme.WMColor.lineColorE9;
    }
    return _lineView;
}

- (HDLabel *)titleLB {
    if (!_titleLB) {
        HDLabel *label = HDLabel.new;
        NSMutableAttributedString *titleStr =
            [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"*%@", WMLocalizedString(@"wm_order_feedback_processing_method", @"Expectation Handling Style")]];
        titleStr.yy_font = [HDAppTheme.WMFont wm_boldForSize:16];
        titleStr.yy_color = HDAppTheme.WMColor.B3;
        [titleStr yy_setColor:HDAppTheme.WMColor.mainRed range:[titleStr.string rangeOfString:@"*"]];
        label.attributedText = titleStr;
        _titleLB = label;
    }
    return _titleLB;
}

- (UIImageView *)iconIV {
    if (!_iconIV) {
        _iconIV = UIImageView.new;
    }
    return _iconIV;
}

- (HDLabel *)nameLB {
    if (!_nameLB) {
        HDLabel *label = HDLabel.new;
        label.textColor = HDAppTheme.WMColor.B3;
        label.font = [HDAppTheme.WMFont wm_boldForSize:13.0];
        label.numberOfLines = 0;
        label.userInteractionEnabled = NO;
        _nameLB = label;
    }
    return _nameLB;
}

- (HDLabel *)detailLB {
    if (!_detailLB) {
        HDLabel *label = HDLabel.new;
        label.textColor = HDAppTheme.WMColor.B9;
        label.font = [HDAppTheme.WMFont wm_ForSize:12.0];
        label.numberOfLines = 0;
        label.userInteractionEnabled = NO;
        _detailLB = label;
    }
    return _detailLB;
}

@end
