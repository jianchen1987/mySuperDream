//
//  GNStoreProductTextCell.m
//  SuperApp
//
//  Created by wmz on 2021/6/3.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNStoreProductTextCell.h"


@interface GNStoreProductTextCell ()
/// 上面文字
@property (nonatomic, strong) HDLabel *leftLB;
/// 下面文字
@property (nonatomic, strong) HDLabel *rightLB;
/// 图标
@property (nonatomic, strong) UIImageView *iconIV;

@end


@implementation GNStoreProductTextCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.iconIV];
    [self.contentView addSubview:self.leftLB];
    [self.contentView addSubview:self.rightLB];
    [self.contentView addSubview:self.lineView];
}

- (void)updateConstraints {
    [self.iconIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(kRealWidth(12));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(24), kRealWidth(24)));
    }];

    [self.leftLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconIV.mas_right).offset(kRealWidth(4));
        make.right.mas_equalTo(-kRealWidth(12));
        make.top.equalTo(self.iconIV);
        make.height.mas_greaterThanOrEqualTo(kRealWidth(20));
    }];

    [self.rightLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_lessThanOrEqualTo(-kRealWidth(12));
        make.top.equalTo(self.leftLB.mas_bottom).offset(kRealWidth(2));
        make.left.right.equalTo(self.leftLB);
        make.height.mas_greaterThanOrEqualTo(kRealWidth(18));
    }];

    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftLB);
        make.height.mas_equalTo(HDAppTheme.value.gn_line);
        make.right.mas_equalTo(0);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];

    [self.leftLB setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.leftLB setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [super updateConstraints];
}

- (void)setGNModel:(GNCellModel *)data {
    self.model = data;
    self.iconIV.image = data.image;
    self.leftLB.text = data.title;
    self.rightLB.text = data.detail;
    self.lineView.hidden = data.lineHidden;
    NSMutableAttributedString *mstr = [[NSMutableAttributedString alloc] initWithString:self.rightLB.text];
    mstr.yy_lineSpacing = kRealWidth(4);
    self.rightLB.attributedText = mstr;
    [self setNeedsUpdateConstraints];
}

- (UIImageView *)iconIV {
    if (!_iconIV) {
        _iconIV = UIImageView.new;
    }
    return _iconIV;
}

- (HDLabel *)leftLB {
    if (!_leftLB) {
        _leftLB = HDLabel.new;
        _leftLB.numberOfLines = 0;
        _leftLB.textColor = HDAppTheme.color.gn_333Color;
        _leftLB.font = [HDAppTheme.font gn_boldForSize:14];
    }
    return _leftLB;
}

- (HDLabel *)rightLB {
    if (!_rightLB) {
        _rightLB = HDLabel.new;
        _rightLB.numberOfLines = 0;
        _rightLB.textColor = HDAppTheme.color.gn_999Color;
        _rightLB.font = [HDAppTheme.font gn_12];
    }
    return _rightLB;
}

@end
