//
//  WMFeedBackMainCell.m
//  SuperApp
//
//  Created by wmz on 2022/11/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "WMFeedBackMainCell.h"


@interface WMFeedBackMainCell ()
@property (nonatomic, strong) HDLabel *nameLB;
@property (nonatomic, strong) HDLabel *detailLB;
@property (nonatomic, strong) UIImageView *rightIV;
@property (nonatomic, strong) UIImageView *iconIV;
@property (nonatomic, strong) UIView *bgView;
@end


@implementation WMFeedBackMainCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.iconIV];
    [self.bgView addSubview:self.rightIV];
    [self.bgView addSubview:self.nameLB];
    [self.bgView addSubview:self.detailLB];
}

- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];

    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kRealWidth(24), kRealWidth(24)));
        make.left.top.mas_equalTo(kRealWidth(12));
        make.bottom.mas_lessThanOrEqualTo(-kRealWidth(12));
    }];

    [self.rightIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconIV);
        make.size.mas_equalTo(self.rightIV.image.size);
        make.right.mas_equalTo(-kRealWidth(12));
    }];

    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(4));
        make.height.mas_greaterThanOrEqualTo(kRealWidth(20));
        make.centerY.equalTo(self.iconIV);
        make.right.equalTo(self.rightIV.mas_left).offset(-kRealWidth(12));
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

- (void)setGNModel:(GNCellModel *)data {
    self.nameLB.text = data.title;
    self.detailLB.text = data.detail;
    NSMutableAttributedString *mstr = [[NSMutableAttributedString alloc] initWithString:data.detail ?: @""];
    mstr.yy_lineSpacing = kRealWidth(4);
    self.detailLB.attributedText = mstr;
    self.detailLB.hidden = HDIsStringEmpty(data.detail);
    self.iconIV.image = data.image;
}

- (UIImageView *)rightIV {
    if (!_rightIV) {
        _rightIV = UIImageView.new;
        _rightIV.image = [UIImage imageNamed:@"yn_submit_gengd"];
    }
    return _rightIV;
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

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = UIView.new;
        _bgView.layer.backgroundColor = UIColor.whiteColor.CGColor;
    }
    return _bgView;
}
@end
